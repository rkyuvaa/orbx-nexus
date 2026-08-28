import { useState, memo, useEffect, useMemo } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import {
  Box, List, ListItemButton, ListItemIcon, ListItemText,
  Collapse, Typography, Drawer, Divider, Tooltip, useMediaQuery,
  Autocomplete, TextField, InputAdornment, IconButton,
} from "@mui/material";
import Dashboard from "@mui/icons-material/Dashboard";
import Business from "@mui/icons-material/Business";
import AccountBalance from "@mui/icons-material/AccountBalance";
import Inventory2 from "@mui/icons-material/Inventory2";
import PrecisionManufacturing from "@mui/icons-material/PrecisionManufacturing";
import Receipt from "@mui/icons-material/Receipt";
import Group from "@mui/icons-material/Group";
import Assignment from "@mui/icons-material/Assignment";
import AttachMoney from "@mui/icons-material/AttachMoney";
import Construction from "@mui/icons-material/Construction";
import Analytics from "@mui/icons-material/Analytics";
import BarChart from "@mui/icons-material/BarChart";
import AdminPanelSettings from "@mui/icons-material/AdminPanelSettings";
import Fingerprint from "@mui/icons-material/Fingerprint";
import Backup from "@mui/icons-material/Backup";
import ManageHistory from "@mui/icons-material/ManageHistory";
import ExpandLess from "@mui/icons-material/ExpandLess";
import ExpandMore from "@mui/icons-material/ExpandMore";
import ChevronRight from "@mui/icons-material/ChevronRight";
import MenuIcon from "@mui/icons-material/Menu";
import LocalShipping from "@mui/icons-material/LocalShipping";
import Verified from "@mui/icons-material/Verified";
import Settings from "@mui/icons-material/Settings";
import SearchIcon from "@mui/icons-material/Search";
import { useUIStore } from "../../store";

const DRAWER_WIDTH = 240;
const DRAWER_COLLAPSED = 64;

interface SearchOption {
  label: string;
  path: string;
  category?: string;
}

const getSearchOptions = (items: NavItem[]): SearchOption[] => {
  const options: SearchOption[] = [];
  const traverse = (item: NavItem, category?: string) => {
    if (item.path) {
      options.push({
        label: item.label,
        path: item.path,
        category: category || "",
      });
    }
    if (item.children) {
      item.children.forEach((child) => traverse(child, item.label));
    }
  };
  items.forEach((item) => traverse(item));
  return options;
};

interface NavItem {
  label: string;
  path?: string;
  icon: React.ReactNode;
  children?: NavItem[];
}

const NAV_ITEMS: NavItem[] = [
  { label: "Dashboard", path: "/", icon: <Dashboard sx={{ fontSize: 20 }} /> },
  {
    label: "Masters",
    icon: <Business sx={{ fontSize: 20 }} />,
    children: [
      { label: "Supplier", path: "/master/suppliers", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Product Register", path: "/process/products", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Process Register", path: "/process/processes", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Process Groups", path: "/process/groups", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Unit of Measure", path: "/inventory/uom", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Customer Material",
    icon: <Inventory2 sx={{ fontSize: 20 }} />,
    children: [
      { label: "Inward Voucher", path: "/process-voucher/inward", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Outward Voucher", path: "/process-voucher/outward", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Contractor Work",
    icon: <Construction sx={{ fontSize: 20 }} />,
    children: [
      { label: "Job Work Register", path: "/contractor/job-work", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Advance Payment", path: "/contractor/advance-payment", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Advance Receipt", path: "/contractor/advance-receipt", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Job Work Payment", path: "/contractor/payment", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Tools Management",
    icon: <PrecisionManufacturing sx={{ fontSize: 20 }} />,
    children: [
      { label: "Tools & Consumables", path: "/inventory/tools-consumables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Tools Management", path: "/inventory/locations", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Purchase",
    icon: <Receipt sx={{ fontSize: 20 }} />,
    children: [
      { label: "Tools & Consumables", path: "/purchase/tools-consumables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },


  {
    label: "Billing",
    icon: <Assignment sx={{ fontSize: 20 }} />,
    children: [
      { label: "Labour Bill", path: "/labour-bill", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Accounts",
    icon: <AccountBalance sx={{ fontSize: 20 }} />,
    children: [
      { label: "Accounts Group", path: "/accounts/groups", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Payables", path: "/accounts/payables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Receivables", path: "/reports/receivables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "HR and Payroll",
    icon: <Group sx={{ fontSize: 20 }} />,
    children: [
      { label: "Staff Ledgers", path: "/accounts/staff", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Contractor", path: "/payroll/contractors", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Salary Voucher", path: "/payroll/salary", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Biometrics", path: "/biometrics", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },

  {
    label: "Reports",
    icon: <BarChart sx={{ fontSize: 20 }} />,
    children: [
      { label: "Day Book", path: "/reports/day-book", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Ledger Accounts", path: "/reports/ledger-account", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Stock in Hand", path: "/reports/stock-in-hand", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Stock Summary", path: "/reports/stock-summary", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Inward Register", path: "/reports/inward-register", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Outward Register", path: "/reports/outward-register", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Labour Bill Register", path: "/reports/labour-bill-register", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Pending Bills", path: "/reports/pending-bills", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Receivables", path: "/reports/receivables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Payables", path: "/reports/payables", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Staff Salary A/c", path: "/reports/staff-salary", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Monthly Report", path: "/reports/monthly", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Trial Balance", path: "/reports/trial-balance", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Administration",
    icon: <AdminPanelSettings sx={{ fontSize: 20 }} />,
    children: [
      { label: "User Management", path: "/admin/users", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Financial Years", path: "/admin/financial-years", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
  {
    label: "Settings",
    icon: <Settings sx={{ fontSize: 20 }} />,
    children: [
      { label: "Company Info", path: "/master/company", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Document Numbering", path: "/settings/document-numbering", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Print Configurations", path: "/settings/print-config", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Backups", path: "/backups", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
      { label: "Audit Logs", path: "/audit", icon: <ChevronRight sx={{ fontSize: 12 }} /> },
    ],
  },
];

const NavNode = memo(function NavNode({
  item,
  depth = 0,
  collapsed,
  activePath,
  onNavigate,
  openMenus = {},
  onToggleMenu,
}: {
  item: NavItem;
  depth?: number;
  collapsed: boolean;
  activePath: string;
  onNavigate: (path: string) => void;
  openMenus?: Record<string, boolean>;
  onToggleMenu?: (label: string) => void;
}) {
  const hasChildren = !!item.children?.length;
  const isMenuOpen = depth === 0 ? (openMenus[item.label] ?? false) : false;
  const isActive = item.path ? activePath === item.path : false;
  const isChildActive = item.children?.some((c) => c.path === activePath) ?? false;
  const isSelected = isActive || isChildActive;

  const handleClick = () => {
    if (hasChildren) {
      if (depth === 0 && onToggleMenu) {
        onToggleMenu(item.label);
      }
    } else if (item.path) {
      onNavigate(item.path);
    }
  };

  const getSelectedBg = () => {
    if (depth > 0) {
      return "rgba(4, 205, 135, 0.15) !important"; // #04CD87, 15% faded
    }
    return "rgba(255, 255, 255, 0.12) !important"; // parent selected bg
  };

  const getSelectedHoverBg = () => {
    if (depth > 0) {
      return "rgba(4, 205, 135, 0.22) !important";
    }
    return "rgba(255, 255, 255, 0.18) !important";
  };

  const getSelectedTextColor = () => {
    if (depth > 0) {
      return "#04CD87 !important"; // sub-menu active text
    }
    return "#FFFFFF !important";
  };

  // Base list item button styles matching exact pad/gap grid specification
  const buttonStyle = {
    borderRadius: "8px",
    transition: "none",
    mb: "2px",
    mx: "8px",
    color: "rgba(255, 255, 255, 0.7)",
    "&.Mui-selected": {
      backgroundColor: getSelectedBg(),
      color: getSelectedTextColor(),
      "&:hover": {
        backgroundColor: getSelectedHoverBg(),
      },
    },
    // Hover styles for inactive menu items (white transparent hover on dark green)
    "&:hover": {
      backgroundColor: "rgba(255, 255, 255, 0.08) !important",
      color: "#FFFFFF",
      "& .MuiListItemIcon-root": {
        color: "#FFFFFF",
      },
      "& .MuiTypography-root": {
        color: "#FFFFFF",
      },
    },
  };

  // Specific styles for active Parent Menu item (depth === 0)
  const activeParentStyle = depth === 0 && isSelected ? {
    backgroundColor: "rgba(255, 255, 255, 0.12) !important",
    color: "#FFFFFF !important",
    borderLeft: "3px solid #00C853",
    borderRadius: "8px",
  } : {
    borderLeft: "3px solid transparent",
  };

  if (collapsed && depth === 0) {
    return (
      <Tooltip title={item.label} placement="right" arrow>
        <ListItemButton
          disableRipple
          selected={isActive || isChildActive}
          onClick={handleClick}
          sx={{
            justifyContent: "center",
            py: 1,
            mx: 0.5,
            borderRadius: "8px",
            mb: 0.25,
            transition: "none",
            "&.Mui-selected": {
              backgroundColor: getSelectedBg(),
              color: getSelectedTextColor(),
              "&:hover": {
                backgroundColor: getSelectedHoverBg(),
              },
            },
          }}
        >
          <ListItemIcon
            sx={{
              minWidth: 0,
              color: (isActive || isChildActive) ? getSelectedTextColor() : "rgba(255, 255, 255, 0.7)",
              display: "flex",
              justifyContent: "center",
            }}
          >
            {item.icon}
          </ListItemIcon>
        </ListItemButton>
      </Tooltip>
    );
  }

  return (
    <>
      <ListItemButton
        disableRipple
        selected={isSelected}
        onClick={handleClick}
        sx={{
          pl: depth === 0 ? "16px" : "28px",
          pr: "12px",
          py: depth === 0 ? "6px" : "4px",
          minHeight: depth === 0 ? "36px" : "30px",
          ...buttonStyle,
          ...activeParentStyle,
        }}
      >
        <ListItemIcon
          sx={{
            minWidth: "20px",
            mr: "12px",
            color: isSelected ? (depth === 0 ? "#FFFFFF" : getSelectedTextColor()) : "rgba(255, 255, 255, 0.7)",
            display: "flex",
            alignItems: "center",
            transition: "none",
          }}
        >
          {item.icon}
        </ListItemIcon>
        <ListItemText
          primary={
            <Typography
              sx={{
                fontSize: depth === 0 ? "14px" : "13px",
                fontWeight: isSelected ? 600 : 500,
                color: isSelected ? (depth === 0 ? "#FFFFFF" : getSelectedTextColor()) : "rgba(255, 255, 255, 0.7)",
                lineHeight: "20px",
                letterSpacing: "0.1px",
                transition: "none",
              }}
            >
              {item.label}
            </Typography>
          }
        />
        {hasChildren && (
          isMenuOpen ? (
            <ExpandLess sx={{ color: isSelected ? "#FFFFFF" : "rgba(255, 255, 255, 0.7)", fontSize: 16 }} />
          ) : (
            <ExpandMore sx={{ color: isSelected ? "#FFFFFF" : "rgba(255, 255, 255, 0.7)", fontSize: 16 }} />
          )
        )}
      </ListItemButton>
      {hasChildren && (
        <Collapse in={isMenuOpen} timeout={0} unmountOnExit>
          <List disablePadding sx={{ py: 0.1 }}>
            {item.children?.map((child) => (
              <NavNode
                key={child.path || child.label}
                item={child}
                depth={depth + 1}
                collapsed={false}
                activePath={activePath}
                onNavigate={onNavigate}
              />
            ))}
          </List>
        </Collapse>
      )}
    </>
  );
});

export default function Sidebar() {
  const navigate = useNavigate();
  const location = useLocation();
  const { sidebarOpen, toggleSidebar, themeMode } = useUIStore();
  const [searchVal, setSearchVal] = useState<SearchOption | null>(null);
  const searchOptions = useMemo(() => getSearchOptions(NAV_ITEMS), []);
  const isMobile = useMediaQuery("(max-width: 600px)");
  const collapsedWidth = isMobile ? 0 : DRAWER_COLLAPSED;
  const width = sidebarOpen ? DRAWER_WIDTH : collapsedWidth;

  const [optimisticPath, setOptimisticPath] = useState(location.pathname);

  useEffect(() => {
    setOptimisticPath(location.pathname);
  }, [location.pathname]);

  const handleNavigate = (path: string) => {
    setOptimisticPath(path);
    navigate(path);
  };

  // Accordion state to track open menus
  const [openMenus, setOpenMenus] = useState<Record<string, boolean>>({});

  const getActiveParentLabel = (pathname: string) => {
    for (const item of NAV_ITEMS) {
      if (item.children?.some((c) => c.path === pathname)) {
        return item.label;
      }
    }
    return null;
  };

  const activeParent = getActiveParentLabel(location.pathname);

  // Auto-expand the active section on load or location change
  useEffect(() => {
    if (activeParent) {
      setOpenMenus({ [activeParent]: true });
    }
  }, [activeParent]);

  const handleToggleMenu = (label: string) => {
    setOpenMenus((prev) => ({
      [label]: !prev[label],
    }));
  };

  const logoSrc = "/logo-dark.svg";

  return (
    <Drawer
      variant="permanent"
      sx={{
        width,
        flexShrink: 0,
        transition: (theme) => theme.transitions.create("width", {
          easing: theme.transitions.easing.sharp,
          duration: theme.transitions.duration.shorter,
        }),
        "& .MuiDrawer-paper": {
          width,
          overflowX: "hidden",
          transition: (theme) => theme.transitions.create("width", {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.shorter,
          }),
          backgroundColor: "#023020 !important",
          borderRight: "1px solid rgba(255, 255, 255, 0.1)",
          height: "100vh",
          display: "flex",
          flexDirection: "column",
        },
      }}
    >
      {/* 1. Header (Logo & Company Title) */}
      <Box
        sx={{
          height: 56,
          display: "flex",
          alignItems: "center",
          px: sidebarOpen ? "16px" : "12px",
          justifyContent: sidebarOpen ? "flex-start" : "center",
          flexShrink: 0,
        }}
      >
        <Box sx={{ display: "flex", alignItems: "center", height: sidebarOpen ? 46 : 34, justifyContent: "center", width: "100%" }}>
          <img src={logoSrc} alt="Logo" style={{ height: "100%", maxHeight: 46, objectFit: "contain" }} />
        </Box>
      </Box>

      {/* 2. Search Bar / Search Icon (Directly above Dashboard) */}
      <Box sx={{ px: "12px", py: 1, flexShrink: 0 }}>
        {sidebarOpen ? (
          <Autocomplete
            size="small"
            value={searchVal}
            onChange={(_, val) => {
              if (val) {
                setSearchVal(null); // Clear search after selection
                handleNavigate(val.path);
              }
            }}
            options={searchOptions}
            getOptionLabel={(option) => option.label}
            groupBy={(option) => option.category || ""}
            popupIcon={null} // Hide dropdown arrow for a cleaner search look
            slotProps={{
              paper: {
                sx: {
                  bgcolor: "#023020",
                  border: "1px solid rgba(255, 255, 255, 0.15)",
                  color: "#FFFFFF",
                  "& .MuiAutocomplete-groupLabel": {
                    bgcolor: "rgba(255, 255, 255, 0.05)",
                    color: "rgba(255, 255, 255, 0.5)",
                    fontWeight: 700,
                    fontSize: "0.7rem",
                    py: "4px",
                    px: "12px",
                  },
                  "& .MuiAutocomplete-option": {
                    fontSize: "0.8rem",
                    py: "6px",
                    px: "12px",
                    color: "rgba(255, 255, 255, 0.8)",
                    '&[aria-selected="true"]': {
                      bgcolor: "rgba(4, 205, 135, 0.2) !important",
                      color: "#04CD87",
                    },
                    "&.Mui-focused": {
                      bgcolor: "rgba(255, 255, 255, 0.08) !important",
                      color: "#FFFFFF",
                    },
                  },
                },
              },
            }}
            renderInput={(params) => {
              const { slotProps, ...otherParams } = params;
              return (
                <TextField
                  {...otherParams}
                  placeholder="Search menu..."
                  variant="outlined"
                  slotProps={{
                    ...slotProps,
                    input: {
                      ...slotProps?.input,
                      startAdornment: (
                        <>
                          <InputAdornment position="start">
                            <SearchIcon sx={{ color: "rgba(255, 255, 255, 0.5)", fontSize: 18 }} />
                          </InputAdornment>
                          {slotProps?.input?.startAdornment}
                        </>
                      ),
                    }
                  }}
                sx={{
                  "& .MuiOutlinedInput-root": {
                    color: "#FFFFFF",
                    fontSize: "0.8rem",
                    bgcolor: "rgba(255, 255, 255, 0.05)",
                    borderRadius: "8px",
                    padding: "4px 8px",
                    "& fieldset": {
                      borderColor: "rgba(255, 255, 255, 0.1)",
                    },
                    "&:hover fieldset": {
                      borderColor: "rgba(255, 255, 255, 0.3)",
                    },
                    "&.Mui-focused fieldset": {
                      borderColor: "#04CD87",
                      borderWidth: "1px",
                    },
                  },
                  "& .MuiInputBase-input::placeholder": {
                    color: "rgba(255, 255, 255, 0.4)",
                    opacity: 1,
                  },
                }}
              />
            );
          }}
        />
        ) : (
          <Tooltip title="Search Menu" placement="right" arrow>
            <ListItemButton
              onClick={toggleSidebar}
              disableRipple
              sx={{
                justifyContent: "center",
                py: 1,
                mx: 0.5,
                borderRadius: "8px",
                transition: "none",
                bgcolor: "rgba(255, 255, 255, 0.03)",
                "&:hover": {
                  bgcolor: "rgba(255, 255, 255, 0.08) !important",
                  color: "#FFFFFF",
                },
              }}
            >
              <ListItemIcon
                sx={{
                  minWidth: 0,
                  color: "rgba(255, 255, 255, 0.7)",
                  display: "flex",
                  justifyContent: "center",
                }}
              >
                <SearchIcon sx={{ fontSize: 20 }} />
              </ListItemIcon>
            </ListItemButton>
          </Tooltip>
        )}
      </Box>

      <Divider sx={{ borderColor: "rgba(255, 255, 255, 0.1)", mx: 2, mb: 1 }} />

      {/* 3. Nav Items List (scrolls independently) */}
      <Box sx={{ flex: 1, overflowY: "auto", overflowX: "hidden", py: 0.25 }}>
        <List disablePadding>
          {NAV_ITEMS.map((item) => (
            <NavNode
              key={item.path || item.label}
              item={item}
              collapsed={!sidebarOpen}
              activePath={optimisticPath}
              onNavigate={handleNavigate}
              openMenus={openMenus}
              onToggleMenu={handleToggleMenu}
            />
          ))}
        </List>
      </Box>
    </Drawer>
  );
}
