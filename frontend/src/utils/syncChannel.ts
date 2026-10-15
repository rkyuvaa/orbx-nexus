import { QueryClient } from "@tanstack/react-query";

let broadcastChannel: BroadcastChannel | null = null;

try {
  if (typeof window !== "undefined" && "BroadcastChannel" in window) {
    broadcastChannel = new BroadcastChannel("orbx_realtime_sync");
  }
} catch (e) {
  console.warn("BroadcastChannel is not supported in this browser environment", e);
}

/**
 * Broadcast an array of query keys or "*" to all other open OrbX browser tabs.
 * E.g., broadcastSync([["ledgers"], ["ledgers-all"]]) or broadcastSync(["*"])
 */
export function broadcastSync(queryKeys: (string | any[])[]) {
  if (!broadcastChannel) return;
  try {
    const formattedKeys = queryKeys.map((k) => (Array.isArray(k) ? k : [k]));
    broadcastChannel.postMessage({
      type: "INVALIDATE_QUERIES",
      queryKeys: formattedKeys,
      timestamp: Date.now(),
    });
  } catch (e) {
    console.error("Failed to broadcast real-time query invalidation:", e);
  }
}

/**
 * Initialize real-time synchronization on the provided QueryClient.
 * 1. Listens for cross-tab invalidation broadcasts and triggers immediate refetching of active queries.
 * 2. Automatically observes the local MutationCache so every successful mutation across the ERP
 *    notifies peer tabs to refresh their active views in real-time.
 */
export function initRealtimeSync(queryClient: QueryClient): () => void {
  const handleMessage = (event: MessageEvent) => {
    if (event.data?.type === "INVALIDATE_QUERIES" && Array.isArray(event.data?.queryKeys)) {
      const keys = event.data.queryKeys;
      const isWildcard = keys.some((k: any) => k === "*" || (Array.isArray(k) && k[0] === "*"));
      
      if (isWildcard) {
        // Refetch all queries currently rendered/active in this tab
        queryClient.invalidateQueries({ refetchType: "active" });
      } else {
        // Refetch targeted query keys
        keys.forEach((key: any) => {
          const queryKey = Array.isArray(key) ? key : [key];
          queryClient.invalidateQueries({ queryKey, refetchType: "active" });
        });
      }
    }
  };

  if (broadcastChannel) {
    broadcastChannel.addEventListener("message", handleMessage);
  }

  // Subscribe to local MutationCache so ANY successful mutation broadcasts to peer tabs
  const unsubscribeMutationCache = queryClient.getMutationCache().subscribe((event) => {
    if (event?.type === "updated" && event.action?.type === "success") {
      broadcastSync(["*"]);
    }
  });

  return () => {
    if (broadcastChannel) {
      broadcastChannel.removeEventListener("message", handleMessage);
    }
    unsubscribeMutationCache();
  };
}
