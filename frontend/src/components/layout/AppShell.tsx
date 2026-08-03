import { Box, Toolbar, useMediaQuery, useTheme } from "@mui/material";
import Sidebar from "./Sidebar";
import Topbar from "./Topbar";
import { useUIStore } from "../../store";
import { Outlet } from "react-router-dom";
import { useEffect } from "react";

const DRAWER_WIDTH = 240;
const DRAWER_COLLAPSED = 64;

export default function AppShell() {
  const theme = useTheme();
  const isTablet = useMediaQuery("(max-width: 992px)");
  const isMobile = useMediaQuery("(max-width: 600px)");
  const { sidebarOpen, setSidebarOpen } = useUIStore();

  useEffect(() => {
    if (isTablet) {
      setSidebarOpen(false);
    }
  }, [isTablet, setSidebarOpen]);

  const collapsedWidth = isMobile ? 0 : DRAWER_COLLAPSED;
  const sidebarWidth = sidebarOpen ? DRAWER_WIDTH : collapsedWidth;

  return (
    <Box sx={{ display: "flex", minHeight: "100vh", bgcolor: "background.default" }}>
      <Topbar />
      <Sidebar />
      <Box
        component="main"
        sx={{
          flex: 1,
          minWidth: 0,
          minHeight: "100vh",
          display: "flex",
          flexDirection: "column",
          transition: (theme) => theme.transitions.create(["margin", "width"], {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.shorter,
          }),
        }}
      >
        <Toolbar sx={{ minHeight: "48px !important", height: 48 }} /> {/* spacer for fixed AppBar */}
        <Box sx={{ flex: 1, px: 1, pt: 0.25, pb: 1, width: "100%" }}>
          <Outlet />
        </Box>
      </Box>
    </Box>
  );
}
