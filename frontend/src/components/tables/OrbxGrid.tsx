import { useMemo, useState } from "react";
import {
  Box, Card, TextField, InputAdornment, Button, IconButton, Tooltip, useTheme,
  Table, TableHead, TableBody, TableRow, TableCell, TableContainer, TablePagination,
  TableSortLabel, Paper, LinearProgress, Typography, TableFooter
} from "@mui/material";
import Search from "@mui/icons-material/Search";
import Download from "@mui/icons-material/Download";
import Refresh from "@mui/icons-material/Refresh";
import Add from "@mui/icons-material/Add";
import FilterList from "@mui/icons-material/FilterList";
import Print from "@mui/icons-material/Print";
import Visibility from "@mui/icons-material/Visibility";
import PictureAsPdf from "@mui/icons-material/PictureAsPdf";
import { useUIStore } from "../../store";
import { getPageSizeCSS } from "../../utils/printStyles";

export interface ColDef<T = any> {
  field?: string;
  headerName?: string;
  width?: number | string;
  minWidth?: number;
  flex?: number;
  type?: string;
  sortable?: boolean;
  filter?: boolean;
  cellRenderer?: (params: { value: any; data: T }) => React.ReactNode;
  valueGetter?: (params: { data: T }) => any;
  valueFormatter?: (params: { value: any; data: T }) => string;
  [key: string]: any;
}

export interface OrbxGridProps<T = any> {
  rowData: T[];
  columnDefs: ColDef<T>[];
  height?: number | string;
  loading?: boolean;
  onRowClicked?: (row: T) => void;
  gridOptions?: any;
  onRefresh?: () => void;
  onAdd?: () => void;
  addLabel?: string;
  showSearch?: boolean;
  showExport?: boolean;
  summaryCards?: React.ReactNode;
}

export default function OrbxGrid<T = any>({
  rowData = [],
  columnDefs = [],
  height = "calc(100vh - 180px)",
  loading = false,
  onRowClicked,
  onRefresh,
  onAdd,
  addLabel,
  showSearch = true,
  showExport = true,
  summaryCards,
}: OrbxGridProps<T>) {
  const [searchText, setSearchText] = useState("");
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(25);
  const [orderBy, setOrderBy] = useState<string>(() => {
    const sortableCol = columnDefs.find(c => c.field && c.sortable !== false);
    return sortableCol?.field || "";
  });
  const [order, setOrder] = useState<"asc" | "desc">("desc");
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");

  const theme = useTheme();
  const isDark = theme.palette.mode === "dark";
  const { headerState } = useUIStore();

  const dateFieldKey = useMemo(() => {
    if (rowData.length === 0) return null;
    const firstRow = rowData[0];
    const keys = Object.keys(firstRow);
    const dateKey = keys.find(
      (k) => k.toLowerCase() === "date" || k.toLowerCase().endsWith("_date")
    );
    return dateKey || null;
  }, [rowData]);

  const getRowValue = (row: T, col: ColDef<T>) => {
    if (col.valueGetter) {
      return col.valueGetter({ data: row });
    }
    if (col.field) {
      return (row as any)[col.field];
    }
    return "";
  };

  const renderCellContent = (row: T, col: ColDef<T>) => {
    const rawVal = getRowValue(row, col);
    if (col.cellRenderer) {
      return col.cellRenderer({ value: rawVal, data: row });
    }
    if (col.valueFormatter) {
      return col.valueFormatter({ value: rawVal, data: row });
    }
    if (typeof rawVal === "boolean") {
      return rawVal ? "Yes" : "No";
    }
    if (rawVal === null || rawVal === undefined) {
      return "-";
    }
    return String(rawVal);
  };

  const getColAlignment = (col: ColDef) => {
    if (col.align) return col.align;
    
    const fieldName = (col.field || "").toLowerCase();
    const headerName = (col.headerName || "").toLowerCase();
    
    const rightAlignKeys = [
      "qty", "quantity", "rate", "amount", "weight", "price", "val", "value", 
      "balance", "total", "units", "prev", "current", "salary", "hours", 
      "work", "reading", "meter", "consumed", "gst", "cgst", "sgst", "bill", "payment"
    ];
    if (col.type === "numericColumn" || rightAlignKeys.some(k => fieldName.includes(k) || headerName.includes(k))) {
      return "right";
    }
    
    const centerAlignKeys = [
      "no", "number", "code", "date", "status", "id", "serial", "ref", "year", "active"
    ];
    if (centerAlignKeys.some(k => fieldName.includes(k) || headerName.includes(k))) {
      return "center";
    }
    
    return "left";
  };

  const handleSort = (field: string) => {
    const isAsc = orderBy === field && order === "asc";
    setOrder(isAsc ? "desc" : "asc");
    setOrderBy(field);
  };

  // Filtered & Sorted Rows
  const processedRows = useMemo(() => {
    let result = [...rowData];

    // Date Range Filter
    if (dateFieldKey && (fromDate || toDate)) {
      result = result.filter((row) => {
        const val = (row as any)[dateFieldKey];
        if (!val) return true;
        const rowDate = String(val).split("T")[0];
        if (fromDate && rowDate < fromDate) return false;
        if (toDate && rowDate > toDate) return false;
        return true;
      });
    }

    // Search Filter
    if (searchText.trim()) {
      const q = searchText.toLowerCase();
      result = result.filter((row) => {
        return columnDefs.some((col) => {
          const val = getRowValue(row, col);
          return val !== null && val !== undefined && String(val).toLowerCase().includes(q);
        });
      });
    }

    // Sort
    if (orderBy) {
      const col = columnDefs.find((c) => c.field === orderBy);
      result.sort((a, b) => {
        const valA = col ? getRowValue(a, col) : (a as any)[orderBy];
        const valB = col ? getRowValue(b, col) : (b as any)[orderBy];

        if (valA === valB) return 0;
        if (valA === null || valA === undefined) return 1;
        if (valB === null || valB === undefined) return -1;

        if (typeof valA === "number" && typeof valB === "number") {
          return order === "asc" ? valA - valB : valB - valA;
        }

        return order === "asc"
          ? String(valA).localeCompare(String(valB), undefined, { numeric: true, sensitivity: "base" })
          : String(valB).localeCompare(String(valA), undefined, { numeric: true, sensitivity: "base" });
      });
    }

    return result;
  }, [rowData, searchText, orderBy, order, columnDefs, dateFieldKey, fromDate, toDate]);

  // Paginated Rows
  const paginatedRows = useMemo(() => {
    const start = page * rowsPerPage;
    return processedRows.slice(start, start + rowsPerPage);
  }, [processedRows, page, rowsPerPage]);

  const handleExport = () => {
    const cols = columnDefs.filter((c) => c.field || c.headerName);
    const headers = cols.map((c) => `"${c.headerName || c.field}"`).join(",");
    const rows = processedRows.map((row) =>
      cols
        .map((c) => {
          const v = getRowValue(row, c);
          return `"${String(v ?? "").replace(/"/g, '""')}"`;
        })
        .join(",")
    );
    const csvContent = "data:text/csv;charset=utf-8," + [headers, ...rows].join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute(
      "download",
      `${headerState.title?.toLowerCase().replace(/\s+/g, "_") || "export"}_${new Date().toISOString().split("T")[0]}.csv`
    );
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handlePrint = (previewOnly: boolean) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let gridPaperSize: "A4" | "A5" = "A4";
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        if (config.gridPaperSize) gridPaperSize = config.gridPaperSize;
      } catch (e) {}
    }

    const columns = columnDefs.filter((col) => col.field || col.headerName);
    let headersHtml = columns.map((col) => `<th>${col.headerName || col.field}</th>`).join("");
    let rowsHtml = processedRows
      .map(
        (row) =>
          `<tr>${columns
            .map((col) => {
              const val = getRowValue(row, col);
              return `<td>${val ?? ""}</td>`;
            })
            .join("")}</tr>`
      )
      .join("");

    const now = new Date().toLocaleString();
    const title = headerState.title || "Report";

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>${title} - OrbX Nexus</title>
          <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
            @page { size: ${getPageSizeCSS(gridPaperSize)}; margin: 15mm; }
            body { font-family: 'Inter', sans-serif; color: #1a1a1a; margin: 0; padding: 0; line-height: 1.5; font-size: 11px; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0; padding-bottom: 12px; margin-bottom: 20px; }
            .logo-container { display: flex; align-items: center; gap: 12px; }
            .logo { height: 28px; }
            .company-title { font-size: 18px; font-weight: 700; color: #104f32; letter-spacing: -0.01em; }
            .report-info { text-align: right; font-size: 10px; color: #718096; line-height: 1.4; }
            .report-title { font-size: 18px; font-weight: 700; color: #1c3f60; margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.5px; }
            table { width: 100%; border-collapse: collapse; margin-top: 10px; }
            th { border-top: 1px solid #1a1a1a; border-bottom: 1px solid #1a1a1a; color: #1a1a1a; font-weight: 600; text-align: left; padding: 8px 4px; font-size: 10px; text-transform: uppercase; }
            td { padding: 8px 4px; border-bottom: 1px solid #e2e8f0; color: #2d3748; font-size: 10px; }
            .footer { position: fixed; bottom: 0; width: 100%; display: flex; justify-content: space-between; font-size: 9px; color: #a0aec0; border-top: 1px solid #e0e0e0; padding-top: 8px; }
          </style>
        </head>
        <body>
          <div class="header">
            <div class="logo-container">
              <img src="/logo-light.svg" class="logo" alt="OrbX Nexus" />
              <span class="company-title">OrbX Nexus ERP</span>
            </div>
            <div class="report-info">
              <div>Date/Time: ${now}</div>
              <div>Active FY: 2026-27</div>
            </div>
          </div>
          <div class="report-title">${title} Report</div>
          <table>
            <thead>
              <tr>${headersHtml}</tr>
            </thead>
            <tbody>
              ${rowsHtml}
            </tbody>
          </table>
          <div class="footer">
            <span>OrbX Nexus ERP - Professional Enterprise Report</span>
            <span>Page 1 of 1</span>
          </div>
          ${
            previewOnly
              ? ""
              : `
          <script>
            window.onload = function() {
              window.print();
              window.close();
            }
          </script>
          `
          }
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box sx={{ width: "100%", display: "flex", flexDirection: "column", gap: 2 }}>
      {summaryCards && <Box sx={{ width: "100%" }}>{summaryCards}</Box>}

      <Card
        sx={{
          p: 1.5,
          borderRadius: "16px",
          backgroundColor: "background.paper",
          border: "1px solid",
          borderColor: "divider",
          boxShadow: isDark ? "0 12px 32px rgba(0, 0, 0, 0.35)" : "0 8px 24px rgba(0, 0, 0, 0.05)",
          display: "flex",
          flexDirection: "column",
          gap: 1.5,
        }}
      >
        {/* Toolbar */}
        <Box
          sx={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            flexWrap: { xs: "wrap", md: "nowrap" },
            gap: 1.5,
            width: "100%",
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", gap: 2, flexWrap: "nowrap", flexShrink: 0 }}>
            {showSearch && (
              <TextField
                placeholder="Search products, codes, descriptions..."
                size="small"
                value={searchText}
                onChange={(e) => {
                  setSearchText(e.target.value);
                  setPage(0);
                }}
                slotProps={{
                  input: {
                    startAdornment: (
                      <InputAdornment position="start">
                        <Search sx={{ color: "text.secondary", fontSize: 20 }} />
                      </InputAdornment>
                    ),
                  },
                }}
                sx={{
                  width: { xs: "100%", sm: 260 },
                  "& .MuiOutlinedInput-root": {
                    borderRadius: "8px",
                    backgroundColor: (t) => (t.palette.mode === "dark" ? "rgba(0, 0, 0, 0.2)" : "rgba(0, 0, 0, 0.03)"),
                  },
                }}
              />
            )}
            {dateFieldKey && (
              <Box sx={{ display: "flex", alignItems: "center", gap: 1.5, flexShrink: 0 }}>
                <TextField
                  type="date"
                  label="From"
                  size="small"
                  value={fromDate}
                  onChange={(e) => {
                    setFromDate(e.target.value);
                    setPage(0);
                  }}
                  slotProps={{ inputLabel: { shrink: true } }}
                  sx={{
                    width: 140,
                    "& .MuiOutlinedInput-root": {
                      borderRadius: "8px",
                    },
                  }}
                />
                <TextField
                  type="date"
                  label="To"
                  size="small"
                  value={toDate}
                  onChange={(e) => {
                    setToDate(e.target.value);
                    setPage(0);
                  }}
                  slotProps={{ inputLabel: { shrink: true } }}
                  sx={{
                    width: 140,
                    "& .MuiOutlinedInput-root": {
                      borderRadius: "8px",
                    },
                  }}
                />
                {(fromDate || toDate) && (
                  <Button
                    size="small"
                    variant="text"
                    color="error"
                    onClick={() => {
                      setFromDate("");
                      setToDate("");
                      setPage(0);
                    }}
                    sx={{ textTransform: "none", fontWeight: 600 }}
                  >
                    Clear Dates
                  </Button>
                )}
              </Box>
            )}
          </Box>

          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              gap: 1,
              flexWrap: "nowrap",
              flexShrink: 0,
              justifyContent: "flex-end",
            }}
          >


            <Tooltip title="Print Preview">
              <IconButton
                onClick={() => handlePrint(true)}
                sx={{
                  borderRadius: "8px",
                  border: "1px solid",
                  borderColor: "divider",
                  color: "text.secondary",
                  p: 0.8,
                  "&:hover": { borderColor: "#16C47F", color: "text.primary" },
                }}
              >
                <Visibility sx={{ fontSize: 18 }} />
              </IconButton>
            </Tooltip>

            <Tooltip title="Print Report">
              <IconButton
                onClick={() => handlePrint(false)}
                sx={{
                  borderRadius: "8px",
                  border: "1px solid",
                  borderColor: "divider",
                  color: "text.secondary",
                  p: 0.8,
                  "&:hover": { borderColor: "#16C47F", color: "text.primary" },
                }}
              >
                <Print sx={{ fontSize: 18 }} />
              </IconButton>
            </Tooltip>

            <Tooltip title="Export to PDF">
              <IconButton
                onClick={() => handlePrint(false)}
                sx={{
                  borderRadius: "8px",
                  border: "1px solid",
                  borderColor: "divider",
                  color: "text.secondary",
                  p: 0.8,
                  "&:hover": { borderColor: "#16C47F", color: "text.primary" },
                }}
              >
                <PictureAsPdf sx={{ fontSize: 18 }} />
              </IconButton>
            </Tooltip>

            {showExport && (
              <Tooltip title="Export CSV">
                <IconButton
                  onClick={handleExport}
                  sx={{
                    borderRadius: "8px",
                    border: "1px solid",
                    borderColor: "divider",
                    color: "text.secondary",
                    p: 0.8,
                    "&:hover": { borderColor: "#16C47F", color: "text.primary" },
                  }}
                >
                  <Download sx={{ fontSize: 18 }} />
                </IconButton>
              </Tooltip>
            )}

            {onRefresh && (
              <Tooltip title="Refresh">
                <IconButton
                  onClick={onRefresh}
                  sx={{
                    borderRadius: "8px",
                    border: "1px solid",
                    borderColor: "divider",
                    color: "text.secondary",
                    p: 0.8,
                    "&:hover": { borderColor: "#16C47F", color: "text.primary" },
                  }}
                >
                  <Refresh sx={{ fontSize: 18 }} />
                </IconButton>
              </Tooltip>
            )}

            {onAdd && (
              <Button
                variant="contained"
                startIcon={<Add sx={{ fontSize: 16 }} />}
                onClick={onAdd}
                sx={{
                  borderRadius: "8px",
                  fontWeight: 600,
                  px: 1.5,
                  py: 0.6,
                  fontSize: "0.75rem",
                  whiteSpace: "nowrap",
                }}
              >
                {addLabel || "Add"}
              </Button>
            )}
          </Box>
        </Box>

        {/* Loading Bar */}
        {loading && <LinearProgress sx={{ borderRadius: 1, backgroundColor: "transparent", "& .MuiLinearProgress-bar": { backgroundColor: "#16C47F" } }} />}

        {/* MUI Table View */}
        <TableContainer
          component={Paper}
          variant="outlined"
          sx={{
            maxHeight: height,
            borderRadius: "12px",
            borderColor: "divider",
            backgroundColor: "background.paper",
            overflow: "auto",
          }}
        >
          <Table stickyHeader size="small" sx={{ minWidth: 650 }}>
            <TableHead>
              <TableRow
                sx={{
                  "& th": {
                    backgroundColor: isDark ? "#123524 !important" : "#E6EBE8 !important",
                    color: "text.primary",
                    fontWeight: 700,
                    fontSize: "0.8rem",
                    py: 1,
                    borderColor: "divider",
                    whiteSpace: "nowrap",
                  },
                }}
              >
                {columnDefs.map((col, idx) => {
                  const isSortable = col.sortable !== false && col.field;
                  const align = getColAlignment(col);
                  return (
                    <TableCell
                      key={idx}
                      align={align}
                      style={{
                        width: col.width,
                        minWidth: col.minWidth || col.width || 80,
                        maxWidth: col.maxWidth,
                      }}
                    >
                      {isSortable ? (
                        <TableSortLabel
                          active={orderBy === col.field}
                          direction={orderBy === col.field ? order : "asc"}
                          onClick={() => col.field && handleSort(col.field)}
                          sx={{
                            "&.MuiTableSortLabel-active": { color: "#16C47F" },
                            "& .MuiTableSortLabel-icon": { color: "#16C47F !important" },
                            justifyContent: align === "right" ? "flex-end" : align === "center" ? "center" : "flex-start",
                            flexDirection: align === "right" ? "row-reverse" : "row",
                            width: "100%",
                          }}
                        >
                          {col.headerName || col.field}
                        </TableSortLabel>
                      ) : (
                        col.headerName || col.field
                      )}
                    </TableCell>
                  );
                })}
              </TableRow>
            </TableHead>
            <TableBody>
              {paginatedRows.length > 0 ? (
                paginatedRows.map((row, rIdx) => (
                  <TableRow
                    key={rIdx}
                    hover
                    onClick={() => onRowClicked?.(row)}
                    sx={{
                      cursor: onRowClicked ? "pointer" : "default",
                      backgroundColor: rIdx % 2 === 0 ? "background.paper" : isDark ? "#112119" : "#F4F6F5",
                      "&:hover": {
                        backgroundColor: isDark ? "rgba(22, 196, 127, 0.08) !important" : "rgba(22, 196, 127, 0.04) !important",
                      },
                      "& td": {
                        borderColor: "divider",
                        py: 0.8,
                        fontSize: "0.825rem",
                        whiteSpace: "nowrap",
                      },
                    }}
                  >
                    {columnDefs.map((col, cIdx) => (
                      <TableCell
                        key={cIdx}
                        align={getColAlignment(col)}
                        style={{
                           width: col.width,
                           minWidth: col.minWidth || col.width || 80,
                           maxWidth: col.maxWidth,
                        }}
                      >
                        {renderCellContent(row, col)}
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              ) : (
                <TableRow>
                  <TableCell colSpan={columnDefs.length || 1} align="center" sx={{ py: 6 }}>
                    <Typography variant="body2" color="text.secondary" sx={{ fontStyle: "italic" }}>
                      {loading ? "Loading data..." : "No Rows To Show"}
                    </Typography>
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
            {processedRows.length > 0 && (
              <TableFooter
                sx={{
                  position: "sticky",
                  bottom: 0,
                  zIndex: 1,
                  backgroundColor: isDark ? "#0f2b1d" : "#e1ebe6",
                }}
              >
                <TableRow
                  sx={{
                    backgroundColor: isDark ? "#0f2b1d" : "#e1ebe6",
                    "& td": {
                      borderColor: "divider",
                      py: 1,
                      fontWeight: 700,
                      fontSize: "0.825rem",
                      whiteSpace: "nowrap",
                      color: "text.primary",
                    },
                  }}
                >
                  {columnDefs.map((col, cIdx) => {
                    const isFirst = cIdx === 0;
                    const align = getColAlignment(col);
                    const isNumeric = align === "right";
                    const isSummable = isNumeric && 
                      col.field && 
                      !["rate", "rate_per_unit", "record_id", "sequence", "previous_reading", "current_reading"].includes(col.field.toLowerCase()) &&
                      !col.field.toLowerCase().endsWith("id");
                    
                    let cellContent = "";
                    if (isFirst) {
                      cellContent = "Total";
                    } else if (isSummable) {
                      const totalVal = processedRows.reduce((acc, row) => {
                        const val = getRowValue(row, col);
                        const num = Number(val);
                        return acc + (isNaN(num) ? 0 : num);
                      }, 0);
                      
                      if (col.valueFormatter) {
                        cellContent = col.valueFormatter({ value: totalVal, data: {} as any });
                      } else {
                        cellContent = totalVal.toLocaleString(undefined, { minimumFractionDigits: 0, maximumFractionDigits: 3 });
                      }
                    }

                    return (
                      <TableCell
                        key={cIdx}
                        align={align}
                        style={{
                          width: col.width,
                          minWidth: col.minWidth || col.width || 80,
                          maxWidth: col.maxWidth,
                        }}
                      >
                        {cellContent}
                      </TableCell>
                    );
                  })}
                </TableRow>
              </TableFooter>
            )}
          </Table>
        </TableContainer>

        {/* Pagination Controls */}
        <TablePagination
          component="div"
          count={processedRows.length}
          page={page}
          onPageChange={(_, newPage) => setPage(newPage)}
          rowsPerPage={rowsPerPage}
          onRowsPerPageChange={(e) => {
            setRowsPerPage(parseInt(e.target.value, 10));
            setPage(0);
          }}
          rowsPerPageOptions={[10, 25, 50, 100]}
          sx={{
            borderTop: "1px solid",
            borderColor: "divider",
            color: "text.secondary",
            fontSize: "0.8rem",
            ".MuiTablePagination-select": { fontSize: "0.8rem" },
          }}
        />
      </Card>
    </Box>
  );
}
