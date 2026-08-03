import { create } from "zustand";
import { persist } from "zustand/middleware";

export interface User {
  id: number;
  username: string;
  full_name: string | null;
  email: string | null;
  role: string;
  is_active: boolean;
}

interface AuthState {
  token: string | null;
  user: User | null;
  activeFY: string;
  setAuth: (token: string, user: User) => void;
  setActiveFY: (fy: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      activeFY: "2026_2027",
      setAuth: (token, user) => {
        localStorage.setItem("orbx_token", token);
        set({ token, user });
      },
      setActiveFY: (fy) => set({ activeFY: fy }),
      logout: () => {
        localStorage.removeItem("orbx_token");
        localStorage.removeItem("orbx_user");
        set({ token: null, user: null });
      },
    }),
    {
      name: "orbx-auth",
      partialize: (state) => ({ token: state.token, user: state.user, activeFY: state.activeFY }),
    }
  )
);

export interface HeaderState {
  title: string;
  subtitle?: string;
  breadcrumbs?: { label: string; path?: string }[];
}

interface UIState {
  sidebarOpen: boolean;
  themeMode: "dark" | "light";
  headerState: HeaderState;
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;
  toggleThemeMode: () => void;
  setHeaderState: (state: HeaderState) => void;
}

export const useUIStore = create<UIState>()(
  persist(
    (set) => ({
      sidebarOpen: true,
      themeMode: "dark",
      headerState: { title: "" },
      toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
      setSidebarOpen: (open) => set({ sidebarOpen: open }),
      toggleThemeMode: () => set((s) => ({ themeMode: s.themeMode === "dark" ? "light" : "dark" })),
      setHeaderState: (headerState) => set({ headerState }),
    }),
    {
      name: "orbx-ui",
      partialize: (state) => ({ themeMode: state.themeMode, sidebarOpen: state.sidebarOpen }),
    }
  )
);
