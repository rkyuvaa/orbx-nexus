import { RouterProvider } from "react-router-dom";
import { ThemeProvider, CssBaseline } from "@mui/material";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { router } from "./router";
import { getOrbxTheme } from "./theme/theme";
import { useUIStore } from "./store";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      refetchInterval: 3000, // Poll every 3 seconds for real-time updates
      refetchOnWindowFocus: true,
      retry: 1,
    },
  },
});

function App() {
  const { themeMode } = useUIStore();
  const theme = getOrbxTheme(themeMode);

  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <RouterProvider router={router} />
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
