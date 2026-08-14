import { createTheme, alpha } from "@mui/material/styles";

export const getOrbxTheme = (mode?: "dark" | "light") => {
  const safeMode = mode === "light" ? "light" : "dark";
  const isDark = safeMode === "dark";

  // Refined Dark Theme Palette — Soft Emerald Slate (eliminates harsh glaring white)
  const PRIMARY = isDark ? "#123524" : "#E6EBE8";
  const PRIMARY_LIGHT = isDark ? "#1e4d36" : "#c2d1ca";
  const PRIMARY_DARK = isDark ? "#0A1712" : "#F4F6F5";
  const ACCENT = "#16C47F";
  const ACCENT_LIGHT = isDark ? "#3ae09d" : "#0f9e64";
  const BACKGROUND = isDark ? "#0A1712" : "#F4F6F5";
  const SURFACE = isDark ? "#0F211A" : "#FFFFFF";
  const SURFACE_2 = isDark ? "#142A21" : "#E6EBE8";
  const BORDER = isDark ? "rgba(255, 255, 255, 0.09)" : "rgba(0, 0, 0, 0.08)";
  const TEXT_PRIMARY = isDark ? "#E6F0EC" : "#0E1F18";
  const TEXT_SECONDARY = TEXT_PRIMARY;
  const TEXT_DISABLED = TEXT_PRIMARY;

  return createTheme({
    palette: {
      mode: safeMode,
      primary: {
        main: ACCENT,
        light: ACCENT_LIGHT,
        dark: isDark ? "#0b965f" : "#0c8052",
        contrastText: isDark ? "#0A1712" : "#FFFFFF",
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
      h1: { fontWeight: 700, fontSize: "2.25rem", letterSpacing: "-0.02em", color: TEXT_PRIMARY },
      h2: { fontWeight: 700, fontSize: "1.85rem", letterSpacing: "-0.01em", color: TEXT_PRIMARY },
      h3: { fontWeight: 600, fontSize: "1.6rem", color: TEXT_PRIMARY },
      h4: { fontWeight: 600, fontSize: "1.4rem", color: TEXT_PRIMARY },
      h5: { fontWeight: 600, fontSize: "1.2rem", color: TEXT_PRIMARY },
      h6: { fontWeight: 600, fontSize: "1rem", color: TEXT_PRIMARY },
      subtitle1: { fontWeight: 500, fontSize: "0.925rem", color: TEXT_SECONDARY },
      subtitle2: { fontWeight: 500, fontSize: "0.85rem", color: TEXT_SECONDARY },
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
          
          /* Globally shrink input label when input has value or browser autofill */
          .MuiFormControl-root:has(input:not(:placeholder-shown)) .MuiInputLabel-root,
          .MuiFormControl-root:has(input:-webkit-autofill) .MuiInputLabel-root,
          .MuiFormControl-root:has(input[type="date"]) .MuiInputLabel-root {
            transform: translate(14px, -9px) scale(0.75) !important;
            pointer-events: auto;
            max-width: calc(133% - 24px);
          }
          
          /* Globally open notched border when input has value or browser autofill */
          .MuiFormControl-root:has(input:not(:placeholder-shown)) .MuiOutlinedInput-notchedOutline legend,
          .MuiFormControl-root:has(input:-webkit-autofill) .MuiOutlinedInput-notchedOutline legend,
          .MuiFormControl-root:has(input[type="date"]) .MuiOutlinedInput-notchedOutline legend {
            max-width: 100% !important;
          }
        `,
      },
      MuiInputBase: {
        defaultProps: {
          placeholder: " ",
        },
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
            borderRadius: 14,
            backgroundImage: "none",
            transition: "border-color 150ms, box-shadow 150ms",
            boxShadow: isDark ? "0 4px 20px rgba(0,0,0,0.25)" : "0 4px 12px rgba(0, 0, 0, 0.03)",
            "&:hover": {
              borderColor: alpha(ACCENT, 0.35),
              boxShadow: isDark ? `0 8px 32px rgba(0, 0, 0, 0.4)` : `0 8px 24px rgba(0, 0, 0, 0.08)`,
            },
          },
        },
      },
      MuiButton: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            padding: "7px 18px",
            fontWeight: 600,
            transition: "all 150ms ease-in-out",
            "&:active": {
              transform: "scale(0.98)",
            },
          },
          contained: {
            backgroundColor: ACCENT,
            color: isDark ? "#0A1712" : "#FFFFFF",
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
              backgroundColor: isDark ? "rgba(0, 0, 0, 0.25)" : "rgba(0, 0, 0, 0.02)",
              color: TEXT_PRIMARY,
              "& fieldset": { borderColor: BORDER },
              "&:hover fieldset": { borderColor: alpha(ACCENT, 0.35) },
              "&.Mui-focused fieldset": { borderColor: ACCENT, borderWidth: 1 },
            },
            "& .MuiInputLabel-root": {
              color: TEXT_SECONDARY,
              "&.Mui-focused": { color: ACCENT },
            },
          },
        },
      },
      MuiSelect: {
        defaultProps: { size: "small" },
        styleOverrides: {
          root: {
            backgroundColor: isDark ? "rgba(0, 0, 0, 0.25)" : "rgba(0, 0, 0, 0.02)",
            color: TEXT_PRIMARY,
            "& fieldset": { borderColor: BORDER },
            "&:hover fieldset": { borderColor: alpha(ACCENT, 0.35) },
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
              fontSize: "0.85rem",
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
            color: TEXT_PRIMARY,
          },
        },
      },
      MuiTableRow: {
        styleOverrides: {
          root: {
            "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.05)" },
            "& .MuiTableCell-root": { borderColor: BORDER },
          },
        },
      },
      MuiChip: {
        styleOverrides: {
          root: { fontWeight: 500, borderRadius: 6 },
          sizeSmall: {
            fontSize: "0.65rem",
            height: 20,
            "& .MuiChip-label": {
              paddingLeft: 6,
              paddingRight: 6,
            },
          },
          colorSuccess: { backgroundColor: "rgba(22, 196, 127, 0.15)", color: ACCENT },
        },
      },
      MuiDialog: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            borderRadius: 16,
            boxShadow: isDark ? "0 16px 48px rgba(0, 0, 0, 0.6)" : "0 16px 48px rgba(0, 0, 0, 0.1)",
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
            backgroundColor: alpha(BACKGROUND, 0.9),
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
              backgroundColor: "rgba(22, 196, 127, 0.14)",
              color: TEXT_PRIMARY,
              "& .MuiListItemIcon-root": { color: ACCENT },
              "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.2)" },
            },
            "&:hover": { backgroundColor: "rgba(22, 196, 127, 0.07)" },
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
