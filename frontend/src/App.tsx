import { Component, ReactNode, useEffect } from "react";
import { RouterProvider } from "react-router-dom";
import { ThemeProvider, CssBaseline, Box, Typography, Button } from "@mui/material";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { router } from "./router";
import { getOrbxTheme } from "./theme/theme";
import { useUIStore } from "./store";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      refetchInterval: 3000,
      refetchOnWindowFocus: true,
      retry: 1,
    },
  },
});

interface ErrorBoundaryState {
  hasError: boolean;
  error: any;
}

class ErrorBoundary extends Component<{ children: ReactNode }, ErrorBoundaryState> {
  constructor(props: { children: ReactNode }) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: any): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: any, errorInfo: any) {
    console.error("OrbX Nexus ErrorBoundary caught an error:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <Box
          sx={{
            minHeight: "100vh",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            bgcolor: "#0A1712",
            color: "#E6F0EC",
            p: 3,
            textAlign: "center",
          }}
        >
          <Typography variant="h5" sx={{ fontWeight: 700, mb: 1, color: "#16C47F" }}>
            OrbX Nexus ERP
          </Typography>
          <Typography variant="h6" sx={{ mb: 2 }}>
            Something went wrong while rendering this page.
          </Typography>
          <Typography variant="body2" sx={{ color: "#9EB3AA", mb: 3, maxWidth: 500, fontFamily: "monospace" }}>
            {String(this.state.error?.message || this.state.error)}
          </Typography>
          <Box sx={{ display: "flex", gap: 2 }}>
            <Button
              variant="outlined"
              onClick={() => window.location.reload()}
              sx={{ borderColor: "rgba(255,255,255,0.2)", color: "#E6F0EC" }}
            >
              Reload Page
            </Button>
            <Button
              variant="contained"
              onClick={() => {
                localStorage.clear();
                window.location.href = "/login";
              }}
              sx={{ bgcolor: "#16C47F", color: "#0A1712" }}
            >
              Clear Cache & Re-login
            </Button>
          </Box>
        </Box>
      );
    }
    return this.props.children;
  }
}

function App() {
  const { themeMode } = useUIStore();
  const theme = getOrbxTheme(themeMode || "dark");

  useEffect(() => {
    const handleGlobalKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Enter") {
        if (e.defaultPrevented) return;
        
        const active = document.activeElement as HTMLElement;
        if (!active) return;

        // Skip textareas, buttons, submit inputs
        if (
          active.tagName === "TEXTAREA" ||
          active.tagName === "BUTTON" ||
          active.role === "button" ||
          active.getAttribute("type") === "submit"
        ) {
          return;
        }

        // Skip if autocomplete listbox or popup dropdown is currently open
        if (document.querySelector(".MuiAutocomplete-popper, [role='listbox']")) {
          return;
        }

        e.preventDefault();

        // Find parent container
        const container = active.closest("dialog, [role='dialog'], form, .MuiPaper-root, body") || document.body;
        
        // Find visible focusable input elements
        const focusable = Array.from(
          container.querySelectorAll(
            'input:not([disabled]):not([readonly]), select:not([disabled]), [tabindex="0"]:not([disabled])'
          )
        ).filter(el => {
          const htmlEl = el as HTMLElement;
          // Only focus visible elements
          return htmlEl.offsetWidth > 0 && htmlEl.offsetHeight > 0 && htmlEl.tabIndex !== -1;
        }) as HTMLElement[];

        const index = focusable.indexOf(active);
        if (index > -1) {
          const next = focusable[index + 1];
          if (next) {
            next.focus();
            if (next instanceof HTMLInputElement) {
              next.select();
            }
          } else {
            // Trigger submit on container form or dialog action
            const form = active.closest("form");
            if (form) {
              form.requestSubmit();
            } else {
              const dialog = active.closest("dialog, [role='dialog']");
              if (dialog) {
                const containedButton = dialog.querySelector("button.MuiButton-contained") as HTMLButtonElement;
                if (containedButton) {
                  containedButton.click();
                }
              }
            }
          }
        }
      }
    };

    window.addEventListener("keydown", handleGlobalKeyDown);
    return () => {
      window.removeEventListener("keydown", handleGlobalKeyDown);
    };
  }, []);

  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <RouterProvider router={router} />
        </ThemeProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;
