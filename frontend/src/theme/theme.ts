import { createTheme, alpha } from "@mui/material/styles";

export const getOrbxTheme = (mode: "dark" | "light") => {
  const isDark = mode === "dark";

  const PRIMARY = isDark ? "#123524" : "#E6EBE8";
  const PRIMARY_LIGHT = isDark ? "#1e4d36" : "#c2d1ca";
  const PRIMARY_DARK = isDark ? "#08140E" : "#F4F6F5";
  const ACCENT = "#16C47F";
  const ACCENT_LIGHT = isDark ? "#3ae09d" : "#0f9e64";
  const BACKGROUND = isDark ? "#08140E" : "#F4F6F5";
  const SURFACE = isDark ? "#0D1B14" : "#FFFFFF";
  const SURFACE_2 = isDark ? "#123524" : "#E6EBE8";
  const BORDER = isDark ? "rgba(255, 255, 255, 0.08)" : "rgba(0, 0, 0, 0.08)";
  const TEXT_PRIMARY = isDark ? "#FFFFFF" : "#0E1F18";
  const TEXT_SECONDARY = isDark ? "#A5B4B1" : "#5C6E6B";
  const TEXT_DISABLED = isDark ? "#5c6e6b" : "#99adab";

  return createTheme({
    palette: {
      mode,
      primary: {
        main: ACCENT,
        light: ACCENT_LIGHT,
        dark: isDark ? "#0b965f" : "#0c8052",
        contrastText: isDark ? "#08140E" : "#FFFFFF",
      },
      secondary: {
        main: PRIMARY_LIGHT,
        light: isDark ? "#276346" : "#d9e3df",
        dark: PRIMARY_DARK,
      },
      background: {
        default: BACKGROUND,
        paper: SURFACE,
      },
      divider: BORDER,
      text: {
        primary: TEXT_PRIMARY,
        secondary: TEXT_SECONDARY,
        disabled: TEXT_DISABLED,
      },
      success: { main: "#16C47F" },
      error: { main: "#ff5252" },
      warning: { main: "#ffab40" },
      info: { main: "#29b6f6" },
    },
    typography: {
      fontFamily: "'Inter', 'Manrope', -apple-system, sans-serif",
      h1: { fontWeight: 700, fontSize: "2.5rem", letterSpacing: "-0.02em", color: TEXT_PRIMARY },
      h2: { fontWeight: 700, fontSize: "2rem", letterSpacing: "-0.01em", color: TEXT_PRIMARY },
      h3: { fontWeight: 600, fontSize: "1.75rem", color: TEXT_PRIMARY },
      h4: { fontWeight: 600, fontSize: "1.5rem", color: TEXT_PRIMARY },
      h5: { fontWeight: 600, fontSize: "1.25rem", color: TEXT_PRIMARY },
      h6: { fontWeight: 600, fontSize: "1rem", color: TEXT_PRIMARY },
      subtitle1: { fontWeight: 500, fontSize: "0.95rem", color: TEXT_SECONDARY },
      subtitle2: { fontWeight: 500, fontSize: "0.875rem", color: TEXT_SECONDARY },
      body1: { fontSize: "0.875rem", lineHeight: 1.5, color: TEXT_PRIMARY },
      body2: { fontSize: "0.8125rem", lineHeight: 1.4, color: TEXT_SECONDARY },
      button: { fontWeight: 600, fontSize: "0.85rem", textTransform: "none" },
      caption: { fontSize: "0.75rem", color: TEXT_SECONDARY },
    },
    shape: { borderRadius: 12 },
    components: {
      MuiCssBaseline: {
        styleOverrides: `
          * { box-sizing: border-box; }
          ::-webkit-scrollbar { width: 6px; height: 6px; }
          ::-webkit-scrollbar-track { background: ${BACKGROUND}; }
          ::-webkit-scrollbar-thumb { background: ${BORDER}; border-radius: 3px; }
          ::-webkit-scrollbar-thumb:hover { background: ${PRIMARY_LIGHT}; }
          body { background: ${BACKGROUND}; color: ${TEXT_PRIMARY}; }
        `,
      },
      MuiPaper: {
        styleOverrides: {
          root: {
            backgroundImage: "none",
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
          },
        },
      },
      MuiCard: {
        styleOverrides: {
          root: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            borderRadius: 16,
            backgroundImage: "none",
            transition: "border-color 150ms, box-shadow 150ms",
            boxShadow: isDark ? "none" : "0 4px 12px rgba(0, 0, 0, 0.03)",
            "&:hover": {
              borderColor: alpha(ACCENT, 0.3),
              boxShadow: isDark ? `0 8px 32px rgba(0, 0, 0, 0.3)` : `0 8px 24px rgba(0, 0, 0, 0.08)`,
            },
          },
        },
      },
      MuiButton: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            padding: "8px 20px",
            fontWeight: 600,
            transition: "all 150ms ease-in-out",
            "&:active": {
              transform: "scale(0.98)",
            },
          },
          contained: {
            backgroundColor: ACCENT,
            color: isDark ? "#08140E" : "#FFFFFF",
            boxShadow: `0 2px 8px ${alpha(ACCENT, 0.25)}`,
            "&:hover": {
              backgroundColor: ACCENT_LIGHT,
              boxShadow: `0 4px 16px ${alpha(ACCENT, 0.4)}`,
            },
          },
          outlined: {
            borderColor: BORDER,
            color: TEXT_PRIMARY,
            "&:hover": {
              borderColor: ACCENT,
              backgroundColor: alpha(ACCENT, 0.08),
            },
          },
        },
      },
      MuiTextField: {
        defaultProps: { size: "small" },
        styleOverrides: {
          root: {
            "& .MuiOutlinedInput-root": {
              backgroundColor: isDark ? "rgba(0, 0, 0, 0.2)" : "rgba(0, 0, 0, 0.02)",
              color: TEXT_PRIMARY,
              "& fieldset": { borderColor: BORDER },
              "&:hover fieldset": { borderColor: alpha(ACCENT, 0.3) },
              "&.Mui-focused fieldset": { borderColor: ACCENT, borderWidth: 1 },
            },
          },
        },
      },
      MuiSelect: {
        defaultProps: { size: "small" },
        styleOverrides: {
          root: {
            backgroundColor: isDark ? "rgba(0, 0, 0, 0.2)" : "rgba(0, 0, 0, 0.02)",
            color: TEXT_PRIMARY,
            "& fieldset": { borderColor: BORDER },
            "&:hover fieldset": { borderColor: alpha(ACCENT, 0.3) },
            "&.Mui-focused fieldset": { borderColor: ACCENT },
          },
        },
      },
      MuiTableHead: {
        styleOverrides: {
          root: {
            "& .MuiTableCell-head": {
              backgroundColor: SURFACE_2,
              color: TEXT_SECONDARY,
              fontWeight: 600,
              fontSize: "0.875rem",
              textTransform: "none",
              letterSpacing: "normal",
              borderBottom: `1px solid ${BORDER}`,
              whiteSpace: "nowrap",
            },
          },
        },
      },
      MuiTableCell: {
        styleOverrides: {
          root: {
            whiteSpace: "nowrap",
          },
        },
      },
      MuiTableRow: {
        styleOverrides: {
          root: {
            "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.04)" },
            "& .MuiTableCell-root": { borderColor: BORDER },
          },
        },
      },
      MuiChip: {
        styleOverrides: {
          root: { fontWeight: 500, borderRadius: 6 },
          sizeSmall: {
            fontSize: "0.625rem",
            height: 18,
            "& .MuiChip-label": {
              paddingLeft: 6,
              paddingRight: 6,
            },
          },
          colorSuccess: { backgroundColor: "rgba(22, 196, 127, 0.12)", color: ACCENT },
        },
      },
      MuiDialog: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            borderRadius: 16,
          },
        },
      },
      MuiDrawer: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            borderRight: `1px solid ${BORDER}`,
          },
        },
      },
      MuiAppBar: {
        styleOverrides: {
          root: {
            backgroundColor: alpha(BACKGROUND, 0.85),
            backgroundImage: "none",
            borderBottom: `1px solid ${BORDER}`,
            backdropFilter: "blur(12px)",
            boxShadow: "none",
          },
        },
      },
      MuiListItemButton: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            margin: "2px 8px",
            transition: "all 150ms ease-in-out",
            "&.Mui-selected": {
              backgroundColor: "rgba(22, 196, 127, 0.12)",
              color: TEXT_PRIMARY,
              "& .MuiListItemIcon-root": { color: ACCENT },
              "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.18)" },
            },
            "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.06)" },
          },
        },
      },
      MuiTooltip: {
        styleOverrides: {
          tooltip: {
            backgroundColor: SURFACE_2,
            border: `1px solid ${BORDER}`,
            color: TEXT_PRIMARY,
            fontSize: "0.75rem",
          },
        },
      },
      MuiLinearProgress: {
        styleOverrides: {
          root: { backgroundColor: BORDER, borderRadius: 4 },
          bar: { background: `linear-gradient(90deg, ${ACCENT}, ${ACCENT_LIGHT})` },
        },
      },
    },
  });
};

export const orbxTheme = getOrbxTheme("dark");
