import {
  AppBar, Toolbar, IconButton, Typography, Box,
  Avatar, Menu, MenuItem, Divider, Tooltip, ListItemIcon, Breadcrumbs, Link,
} from "@mui/material";
import Logout from "@mui/icons-material/Logout";
import Person from "@mui/icons-material/Person";
import NotificationsNone from "@mui/icons-material/NotificationsNone";
import LightMode from "@mui/icons-material/LightMode";
import DarkMode from "@mui/icons-material/DarkMode";
import NavigateNext from "@mui/icons-material/NavigateNext";
import MenuIcon from "@mui/icons-material/Menu";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { alpha, useTheme } from "@mui/material/styles";
import { useAuthStore, useUIStore } from "../../store";

export default function Topbar() {
  const { toggleThemeMode, themeMode, headerState, toggleSidebar } = useUIStore();
  const { user, logout } = useAuthStore();
  const theme = useTheme();
  const navigate = useNavigate();
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const logoSrc = themeMode === "dark" ? "/logo-dark.svg" : "/logo-light.svg";

  return (
    <AppBar
      position="fixed"
      elevation={0}
      sx={{
        height: 48,
        bgcolor: "background.paper",
        borderBottom: "1px solid",
        borderColor: "divider",
        color: "text.primary",
        zIndex: (theme) => theme.zIndex.drawer + 1,
      }}
    >
      <Toolbar
        sx={{
          minHeight: "48px !important",
          height: 48,
          px: "20px !important",
          pl: "12px !important",
          display: "flex",
          alignItems: "center",
          gap: "12px",
        }}
      >
        <IconButton
          onClick={toggleSidebar}
          size="small"
          edge="start"
          sx={{
            color: "text.secondary",
            mr: 0.5,
            "&:hover": { color: "text.primary" },
          }}
        >
          <MenuIcon sx={{ fontSize: 20 }} />
        </IconButton>
        {/* Left Section: Logo & Product Branding */}
        <Box sx={{ display: "flex", alignItems: "center", height: 32 }}>
          <img src={logoSrc} alt="Logo" style={{ height: "100%", maxHeight: 32 }} />
        </Box>

        <Divider orientation="vertical" flexItem sx={{ mx: 1, my: 1, borderColor: "divider" }} />

        {/* Navigation Breadcrumb (Only Navigation path) */}
        <Box sx={{ display: "flex", alignItems: "center" }}>
          <Breadcrumbs
            separator={<NavigateNext sx={{ fontSize: 14, color: "text.disabled" }} />}
            sx={{ "& .MuiBreadcrumbs-separator": { mx: 0.5 } }}
          >
            <Link
              underline="hover"
              color="text.secondary"
              sx={{ cursor: "pointer", fontSize: "0.75rem", fontWeight: 500 }}
              onClick={() => navigate("/")}
            >
              Home
            </Link>
            {headerState.breadcrumbs?.map((bc) => (
              <Link
                key={bc.label}
                underline="hover"
                color="text.secondary"
                sx={{ cursor: "pointer", fontSize: "0.75rem", fontWeight: 500 }}
                onClick={() => bc.path && navigate(bc.path)}
              >
                {bc.label}
              </Link>
            ))}
            {headerState.title && (
              <Typography
                color="text.primary"
                sx={{ fontSize: "15px", fontWeight: 700 }}
              >
                {headerState.title}
              </Typography>
            )}
          </Breadcrumbs>
        </Box>

        <Box sx={{ flex: 1 }} />

        {/* Right Section: FY Selector, Theme, Notifications, Avatar */}
        <Box sx={{ display: "flex", alignItems: "center", gap: "12px" }}>
          {/* Theme Mode Toggle (Circle) */}
          <Tooltip title={themeMode === "dark" ? "Switch to Light Mode" : "Switch to Dark Mode"}>
            <IconButton
              onClick={toggleThemeMode}
              sx={{
                width: 40,
                height: 40,
                borderRadius: "20px",
                border: "1px solid",
                borderColor: "divider",
                bgcolor: themeMode === "dark" ? "rgba(255, 255, 255, 0.03)" : "rgba(0, 0, 0, 0.02)",
                color: "text.secondary",
                "&:hover": { bgcolor: "action.hover" },
              }}
            >
              {themeMode === "dark" ? <LightMode sx={{ fontSize: 18 }} /> : <DarkMode sx={{ fontSize: 18 }} />}
            </IconButton>
          </Tooltip>

          {/* Notifications (Circle) */}
          <Tooltip title="Notifications">
            <IconButton
              sx={{
                width: 40,
                height: 40,
                borderRadius: "20px",
                border: "1px solid",
                borderColor: "divider",
                bgcolor: themeMode === "dark" ? "rgba(255, 255, 255, 0.03)" : "rgba(0, 0, 0, 0.02)",
                color: "text.secondary",
                "&:hover": { bgcolor: "action.hover" },
              }}
            >
              <NotificationsNone sx={{ fontSize: 18 }} />
            </IconButton>
          </Tooltip>

          {/* User Profile Card (Pill) */}
          <Tooltip title={user?.username || "User"}>
            <Box
              sx={{
                display: "flex",
                alignItems: "center",
                gap: 1,
                cursor: "pointer",
                pl: 0.75,
                pr: 1.5,
                height: 40,
                borderRadius: "20px",
                border: "1px solid",
                borderColor: "divider",
                bgcolor: themeMode === "dark" ? "rgba(255, 255, 255, 0.03)" : "rgba(0, 0, 0, 0.02)",
                "&:hover": { borderColor: alpha(theme.palette.primary.main, 0.4), bgcolor: "action.hover" },
              }}
              onClick={(e) => setAnchorEl(e.currentTarget)}
            >
              <Avatar
                sx={{
                  width: 26,
                  height: 26,
                  bgcolor: alpha(theme.palette.primary.main, 0.2),
                  color: theme.palette.primary.main,
                  fontSize: "0.75rem",
                  fontWeight: 700,
                }}
              >
                {user?.username?.[0]?.toUpperCase() || "U"}
              </Avatar>
              <Box sx={{ display: { xs: "none", sm: "block" } }}>
                <Typography sx={{ fontWeight: 600, fontSize: "0.75rem", color: "text.primary" }}>
                  {user?.full_name || user?.username}
                </Typography>
              </Box>
            </Box>
          </Tooltip>
        </Box>

        {/* User Menu Dropdown */}
        <Menu
          anchorEl={anchorEl}
          open={Boolean(anchorEl)}
          onClose={() => setAnchorEl(null)}
          slotProps={{ paper: { sx: { minWidth: 180, mt: 1 } } }}
        >
          <Box sx={{ px: 2, py: 1 }}>
            <Typography sx={{ fontWeight: 600 }} variant="subtitle2">{user?.username}</Typography>
            <Typography variant="caption" color="text.secondary">{user?.role}</Typography>
          </Box>
          <Divider />
          <MenuItem onClick={() => { setAnchorEl(null); navigate("/admin/users"); }}>
            <ListItemIcon><Person fontSize="small" /></ListItemIcon>
            Profile
          </MenuItem>
          <Divider />
          <MenuItem onClick={handleLogout} sx={{ color: "error.main" }}>
            <ListItemIcon><Logout fontSize="small" sx={{ color: "error.main" }} /></ListItemIcon>
            Logout
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  );
}
