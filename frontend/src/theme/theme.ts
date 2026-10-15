import { createTheme, alpha } from "@mui/material/styles";

export const getOrbxTheme = (mode?: "dark" | "light") => {
  const safeMode = mode === "light" ? "light" : "dark";
  const isDark = safeMode === "dark";

  // Refined Color System — Dark Emerald & Clean Slate
  const ACCENT = "#16C47F";
  const ACCENT_LIGHT = isDark ? "#3ae09d" : "#0f9e64";
  const BACKGROUND = isDark ? "#0A1712" : "#F4F6F5";
  const SURFACE = isDark ? "#0F211A" : "#FFFFFF";
  const SURFACE_2 = isDark ? "#142A21" : "#E8ECE9";
  const BORDER = isDark ? "rgba(255, 255, 255, 0.09)" : "rgba(0, 0, 0, 0.08)";
  
  // High-contrast, theme-appropriate text hierarchy
  const TEXT_PRIMARY = isDark ? "#E6F0EC" : "#0E1F18";
  const TEXT_SECONDARY = isDark ? "rgba(230, 240, 236, 0.70)" : "#475569";
  const TEXT_DISABLED = isDark ? "rgba(230, 240, 236, 0.38)" : "#94A3B8";

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
        main: isDark ? "#1e4d36" : "#2d6a4f",
        light: isDark ? "#276346" : "#40916c",
        dark: isDark ? "#0A1712" : "#1b4332",
        contrastText: "#FFFFFF",
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
      action: {
        hover: isDark ? "rgba(255, 255, 255, 0.05)" : "rgba(0, 0, 0, 0.04)",
        selected: isDark ? "rgba(22, 196, 127, 0.16)" : "rgba(22, 196, 127, 0.10)",
        disabled: TEXT_DISABLED,
        disabledBackground: isDark ? "rgba(255, 255, 255, 0.04)" : "rgba(0, 0, 0, 0.04)",
      },
      success: { 
        main: "#16C47F", 
        light: "#3ae09d", 
        dark: "#0b965f",
        contrastText: "#FFFFFF",
      },
      error: { 
        main: "#ff5252", 
        light: "#ff867f", 
        dark: "#c5112e",
        contrastText: "#FFFFFF",
      },
      warning: { 
        main: "#ffab40", 
        light: "#ffdd71", 
        dark: "#c77c00",
        contrastText: "#0A1712",
      },
      info: { 
        main: "#29b6f6", 
        light: "#73e8ff", 
        dark: "#0086c3",
        contrastText: "#FFFFFF",
      },
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
          :root {
            --color-bg-default: ${BACKGROUND};
            --color-bg-paper: ${SURFACE};
            --color-bg-surface2: ${SURFACE_2};
            --color-border: ${BORDER};
            --color-text-primary: ${TEXT_PRIMARY};
            --color-text-secondary: ${TEXT_SECONDARY};
            --color-accent: ${ACCENT};
          }
          ::-webkit-scrollbar { width: 6px; height: 6px; }
          ::-webkit-scrollbar-track { background: ${BACKGROUND}; }
          ::-webkit-scrollbar-thumb { background: ${BORDER}; border-radius: 3px; }
          ::-webkit-scrollbar-thumb:hover { background: ${isDark ? "#1e4d36" : "#c2d1ca"}; }
          body { background: ${BACKGROUND}; color: ${TEXT_PRIMARY}; }
          
          /* Globally hide number input spinners */
          input[type=number]::-webkit-outer-spin-button,
          input[type=number]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
          }
          input[type=number] {
            -moz-appearance: textfield;
          }

          /* Native Date Picker Theme Support */
          input[type="date"]::-webkit-calendar-picker-indicator {
            filter: ${isDark ? "invert(1) brightness(0.9)" : "none"};
            cursor: pointer;
            opacity: 0.75;
          }
          input[type="date"]::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
          }
          
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
            color: TEXT_PRIMARY,
            border: `1px solid ${BORDER}`,
          },
        },
      },
      MuiCard: {
        styleOverrides: {
          root: {
            backgroundColor: SURFACE,
            color: TEXT_PRIMARY,
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
      MuiOutlinedInput: {
        styleOverrides: {
          root: {
            backgroundColor: isDark ? "rgba(0, 0, 0, 0.25)" : "rgba(0, 0, 0, 0.02)",
            color: TEXT_PRIMARY,
            "& fieldset": { borderColor: BORDER },
            "&:hover fieldset": { borderColor: alpha(ACCENT, 0.35) },
            "&.Mui-focused fieldset": { borderColor: ACCENT, borderWidth: 1 },
            "&.Mui-disabled": {
              backgroundColor: isDark ? "rgba(255, 255, 255, 0.03)" : "rgba(0, 0, 0, 0.04)",
              color: TEXT_DISABLED,
              "& fieldset": { borderColor: isDark ? "rgba(255, 255, 255, 0.05)" : "rgba(0, 0, 0, 0.06)" },
            },
          },
          input: {
            color: TEXT_PRIMARY,
            "&::placeholder": {
              color: TEXT_SECONDARY,
              opacity: 0.6,
            },
          },
        },
      },
      MuiTextField: {
        defaultProps: { size: "small" },
        styleOverrides: {
          root: {
            "& .MuiInputLabel-root": {
              color: TEXT_SECONDARY,
              "&.Mui-focused": { color: ACCENT },
              "&.Mui-disabled": { color: TEXT_DISABLED },
            },
          },
        },
      },
      MuiInputLabel: {
        styleOverrides: {
          root: {
            color: TEXT_SECONDARY,
            "&.Mui-focused": { color: ACCENT },
            "&.Mui-disabled": { color: TEXT_DISABLED },
          },
        },
      },
      MuiSelect: {
        defaultProps: { size: "small" },
        styleOverrides: {
          icon: {
            color: TEXT_SECONDARY,
          },
        },
      },
      MuiAutocomplete: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            color: TEXT_PRIMARY,
            boxShadow: isDark ? "0 12px 36px rgba(0,0,0,0.6)" : "0 8px 24px rgba(0,0,0,0.08)",
          },
          listbox: {
            backgroundColor: SURFACE,
            color: TEXT_PRIMARY,
            padding: "4px",
            "& .MuiAutocomplete-option": {
              borderRadius: "6px",
              margin: "2px 0",
              color: TEXT_PRIMARY,
              '&[aria-selected="true"]': {
                backgroundColor: alpha(ACCENT, 0.15) + " !important",
                color: isDark ? ACCENT_LIGHT : "#0f5132",
              },
              '&.Mui-focused, &:hover': {
                backgroundColor: alpha(ACCENT, 0.08) + " !important",
              },
            },
          },
          noOptions: { color: TEXT_SECONDARY },
          loading: { color: TEXT_SECONDARY },
          popupIndicator: { color: TEXT_SECONDARY },
          clearIndicator: { color: TEXT_SECONDARY },
          tag: {
            backgroundColor: isDark ? alpha(ACCENT, 0.2) : alpha(ACCENT, 0.12),
            color: TEXT_PRIMARY,
            borderColor: isDark ? alpha(ACCENT, 0.4) : alpha(ACCENT, 0.3),
            "& .MuiChip-deleteIcon": {
              color: TEXT_SECONDARY,
              "&:hover": { color: TEXT_PRIMARY },
            },
          },
        },
      },
      MuiMenu: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            color: TEXT_PRIMARY,
            boxShadow: isDark ? "0 12px 36px rgba(0,0,0,0.6)" : "0 8px 24px rgba(0,0,0,0.08)",
          },
        },
      },
      MuiMenuItem: {
        styleOverrides: {
          root: {
            color: TEXT_PRIMARY,
            fontSize: "0.85rem",
            "&:hover": {
              backgroundColor: alpha(ACCENT, 0.08),
            },
            "&.Mui-selected": {
              backgroundColor: alpha(ACCENT, 0.15),
              color: isDark ? ACCENT_LIGHT : "#0f5132",
              "&:hover": {
                backgroundColor: alpha(ACCENT, 0.22),
              },
            },
          },
        },
      },
      MuiTableHead: {
        styleOverrides: {
          root: {
            "& .MuiTableCell-head": {
              backgroundColor: SURFACE_2,
              color: TEXT_PRIMARY,
              fontWeight: 700,
              fontSize: "0.825rem",
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
            borderColor: BORDER,
          },
        },
      },
      MuiTableRow: {
        styleOverrides: {
          root: {
            "&:hover": { backgroundColor: alpha(ACCENT, 0.05) },
            "&.Mui-selected": {
              backgroundColor: alpha(ACCENT, 0.12),
              "&:hover": { backgroundColor: alpha(ACCENT, 0.18) },
            },
            "& .MuiTableCell-root": { borderColor: BORDER },
          },
        },
      },
      MuiTablePagination: {
        styleOverrides: {
          root: {
            color: TEXT_SECONDARY,
            borderTop: `1px solid ${BORDER}`,
          },
          selectIcon: { color: TEXT_SECONDARY },
          actions: { color: TEXT_SECONDARY },
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
          colorSuccess: { 
            backgroundColor: isDark ? "rgba(22, 196, 127, 0.15)" : "rgba(22, 196, 127, 0.12)", 
            color: isDark ? ACCENT : "#0f5132" 
          },
          colorError: {
            backgroundColor: isDark ? "rgba(255, 82, 82, 0.15)" : "rgba(255, 82, 82, 0.12)",
            color: isDark ? "#ff8a80" : "#c62828"
          },
          colorWarning: {
            backgroundColor: isDark ? "rgba(255, 171, 64, 0.15)" : "rgba(255, 171, 64, 0.12)",
            color: isDark ? "#ffd180" : "#b78103"
          },
          colorInfo: {
            backgroundColor: isDark ? "rgba(41, 182, 246, 0.15)" : "rgba(41, 182, 246, 0.12)",
            color: isDark ? "#80d8ff" : "#0277bd"
          },
        },
      },
      MuiDialog: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            border: `1px solid ${BORDER}`,
            borderRadius: 16,
            color: TEXT_PRIMARY,
            backgroundImage: "none",
            boxShadow: isDark ? "0 16px 48px rgba(0, 0, 0, 0.6)" : "0 16px 48px rgba(0, 0, 0, 0.1)",
          },
        },
      },
      MuiDialogTitle: {
        styleOverrides: {
          root: {
            color: TEXT_PRIMARY,
            borderBottom: `1px solid ${BORDER}`,
            fontWeight: 700,
          },
        },
      },
      MuiDialogContent: {
        styleOverrides: {
          root: {
            color: TEXT_PRIMARY,
          },
        },
      },
      MuiDialogActions: {
        styleOverrides: {
          root: {
            borderTop: `1px solid ${BORDER}`,
          },
        },
      },
      MuiDivider: {
        styleOverrides: {
          root: {
            borderColor: BORDER,
          },
        },
      },
      MuiCheckbox: {
        styleOverrides: {
          root: {
            color: isDark ? "rgba(255, 255, 255, 0.4)" : "rgba(0, 0, 0, 0.35)",
            "&.Mui-checked, &.MuiCheckbox-indeterminate": {
              color: ACCENT,
            },
          },
        },
      },
      MuiRadio: {
        styleOverrides: {
          root: {
            color: isDark ? "rgba(255, 255, 255, 0.4)" : "rgba(0, 0, 0, 0.35)",
            "&.Mui-checked": {
              color: ACCENT,
            },
          },
        },
      },
      MuiSwitch: {
        styleOverrides: {
          switchBase: {
            "&.Mui-checked": {
              color: ACCENT,
              "& + .MuiSwitch-track": {
                backgroundColor: ACCENT,
              },
            },
          },
          track: {
            backgroundColor: isDark ? "rgba(255, 255, 255, 0.2)" : "rgba(0, 0, 0, 0.2)",
          },
        },
      },
      MuiDrawer: {
        styleOverrides: {
          paper: {
            backgroundColor: SURFACE,
            borderRight: `1px solid ${BORDER}`,
            color: TEXT_PRIMARY,
          },
        },
      },
      MuiAppBar: {
        styleOverrides: {
          root: {
            backgroundColor: alpha(BACKGROUND, 0.95),
            backgroundImage: "none",
            borderBottom: `1px solid ${BORDER}`,
            backdropFilter: "blur(12px)",
            boxShadow: "none",
            color: TEXT_PRIMARY,
          },
        },
      },
      MuiListItemButton: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            margin: "2px 8px",
            color: TEXT_PRIMARY,
            transition: "all 150ms ease-in-out",
            "&.Mui-selected": {
              backgroundColor: alpha(ACCENT, 0.14),
              color: isDark ? ACCENT_LIGHT : "#0f5132",
              "& .MuiListItemIcon-root": { color: ACCENT },
              "&:hover": { backgroundColor: alpha(ACCENT, 0.2) },
            },
            "&:hover": { backgroundColor: alpha(ACCENT, 0.07) },
          },
        },
      },
      MuiIconButton: {
        styleOverrides: {
          root: {
            color: TEXT_SECONDARY,
            "&:hover": {
              color: TEXT_PRIMARY,
              backgroundColor: alpha(ACCENT, 0.08),
            },
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
      MuiAlert: {
        styleOverrides: {
          root: {
            borderRadius: 8,
            "&.MuiAlert-standardSuccess": {
              backgroundColor: isDark ? alpha("#16C47F", 0.15) : "#e8f5e9",
              color: isDark ? "#3ae09d" : "#0f5132",
              border: `1px solid ${isDark ? alpha("#16C47F", 0.3) : "#a5d6a7"}`,
              "& .MuiAlert-icon": { color: isDark ? "#3ae09d" : "#0f5132" },
            },
            "&.MuiAlert-standardError": {
              backgroundColor: isDark ? alpha("#ff5252", 0.15) : "#ffebee",
              color: isDark ? "#ff8a80" : "#c62828",
              border: `1px solid ${isDark ? alpha("#ff5252", 0.3) : "#ef9a9a"}`,
              "& .MuiAlert-icon": { color: isDark ? "#ff8a80" : "#c62828" },
            },
            "&.MuiAlert-standardWarning": {
              backgroundColor: isDark ? alpha("#ffab40", 0.15) : "#fff8e1",
              color: isDark ? "#ffd180" : "#b78103",
              border: `1px solid ${isDark ? alpha("#ffab40", 0.3) : "#ffe082"}`,
              "& .MuiAlert-icon": { color: isDark ? "#ffd180" : "#b78103" },
            },
            "&.MuiAlert-standardInfo": {
              backgroundColor: isDark ? alpha("#29b6f6", 0.15) : "#e1f5fe",
              color: isDark ? "#80d8ff" : "#0277bd",
              border: `1px solid ${isDark ? alpha("#29b6f6", 0.3) : "#81d4fa"}`,
              "& .MuiAlert-icon": { color: isDark ? "#80d8ff" : "#0277bd" },
            },
          },
        },
      },
      MuiTabs: {
        styleOverrides: {
          indicator: {
            backgroundColor: ACCENT,
            height: 3,
            borderRadius: "3px 3px 0 0",
          },
        },
      },
      MuiTab: {
        styleOverrides: {
          root: {
            textTransform: "none",
            fontWeight: 600,
            fontSize: "0.85rem",
            color: TEXT_SECONDARY,
            "&.Mui-selected": {
              color: ACCENT,
            },
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
