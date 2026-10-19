import React, { useState, useMemo, useEffect } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, TextField, Paper, Typography, Grid,
  Table, TableHead, TableBody, TableRow, TableCell, TableSortLabel, MenuItem, Autocomplete,
  Dialog, DialogTitle, DialogContent, DialogActions, Divider, Chip, IconButton, Tooltip,
  TableFooter, ToggleButton, ToggleButtonGroup
} from "@mui/material";
import Print from "@mui/icons-material/Print";
import Search from "@mui/icons-material/Search";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";
import { useAuthStore, useCompanyStore } from "../../store";
import { COMMON_PRINT_CSS, getCompanyLogoHtml, ensurePrintReady, PRINT_TRIGGER_SCRIPT, resolveCompanyDetails } from "../../utils/printStyles";
import { formatQty, formatWeight, formatAmount, formatDate } from "../../utils/format";

const ACCENT = "#0f5132";
const BORDER = "#0f5132";
const RUPEE = "₹";
const _now = new Date();
const today = `${_now.getFullYear()}-${String(_now.getMonth() + 1).padStart(2, '0')}-${String(_now.getDate()).padStart(2, '0')}`;
const firstOfMonth = `${_now.getFullYear()}-${String(_now.getMonth() + 1).padStart(2, '0')}-01`;

(function() {
  const savedConfig = localStorage.getItem("orbx_print_config");
  let reportPaperSize = "A4";
  if (savedConfig) {
    try { reportPaperSize = JSON.parse(savedConfig).reportPaperSize || "A4"; } catch (e) {}
  }
  const css = `
@media print {
  @page { size: ${reportPaperSize === "A5" ? "A5 landscape" : "A4"}; margin: 15mm; }
  body { background: #fff !important; }
  .MuiDrawer-root, .MuiAppBar-root, .MuiToolbar-root { display: none !important; }
  main.MuiBox-root, main { margin-left: 0 !important; width: 100% !important; max-width: 100% !important; }
  .no-print { display: none !important; }
  .print-only { display: block !important; }
  .MuiPaper-root { box-shadow: none !important; border: 0.5px solid #198754 !important; }
  table.MuiTable-root { border-collapse: collapse !important; border: 0.5px solid #198754 !important; }
  table.MuiTable-root thead th { background: #0f5132 !important; color: #ffffff !important; border: 0.5px solid #198754 !important; font-weight: 700 !important; text-transform: uppercase !important; }
  table.MuiTable-root tbody td { border-left: 0.5px solid #198754 !important; border-right: 0.5px solid #198754 !important; border-top: none !important; border-bottom: none !important; color: #000000 !important; }
  table.MuiTable-root tbody tr:last-child td { border-bottom: 0.5px solid #198754 !important; }
  .MuiTableRow-root:last-child td { background: #f0fdf4 !important; color: #0f5132 !important; font-weight: 700 !important; border-top: 0.5px solid #198754 !important; }
}`;
  const s = document.createElement("style");
  s.textContent = css;
  document.head.appendChild(s);
})();

// ── Filter row using Box (avoids Grid container alignItems error) ──
function FilterRow({ children }: { children: React.ReactNode }) {
  return (
    <Paper sx={{ p: 2, mb: 2 }} variant="outlined">
      <Box sx={{ display: "flex", gap: 2, alignItems: "center", flexWrap: "wrap" }}>
        {children}
      </Box>
    </Paper>
  );
}

export function PrintHeader({ title }: { title: string }) {
  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
  const logoBase64 = compData?.logo || useCompanyStore.getState().logoBase64 || localStorage.getItem("company_logo");
  
  let showLogo = true;
  try {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      showLogo = JSON.parse(savedConfig).showLogo !== false;
    }
  } catch (e) {}

  if (!compData) return null;

  const cName = compData.name || compData.company_name || "SRI METAL";
  const cAddress1 = compData.address || [compData.address_line1, compData.address_line2].filter(Boolean).join(", ") || "";
  const cCityStatePin = [compData.city, compData.state, compData.pincode].filter(Boolean).join(" - ");
  const cPhone = compData.phone || compData.mobile ? `Tel: ${[compData.phone, compData.mobile].filter(Boolean).join(" / ")}` : "";
  const cEmail = compData.email ? `Email: ${compData.email}` : "";
  const cTax = compData.gstin ? `GSTIN: ${compData.gstin}` : "";

  return (
    <Box sx={{ display: "none", "@media print": { display: "block !important" }, mb: 3 }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid #000000", pb: 2, mb: 2 }}>
        <Box sx={{ flex: "0 0 120px", display: "flex", alignItems: "center" }}>
          {showLogo && logoBase64 && (
            <img src={logoBase64} style={{ maxHeight: 60, maxWidth: 120, objectFit: "contain" }} />
          )}
        </Box>
        <Box sx={{ flex: 1, textAlign: "center", marginRight: showLogo && logoBase64 ? "120px" : 0 }}>
          <Typography variant="h4" sx={{ m: 0, fontSize: "22px", color: "#000000", fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.5px" }}>
            {cName}
          </Typography>
          {cAddress1 && <Typography variant="body2" sx={{ m: 0, fontSize: "11px", color: "#000000" }}>{cAddress1}</Typography>}
          {cCityStatePin && <Typography variant="body2" sx={{ m: 0, fontSize: "11px", color: "#000000" }}>{cCityStatePin}</Typography>}
          <Typography variant="body2" sx={{ m: 0, fontSize: "11px", color: "#000000" }}>
            {[cPhone, cEmail].filter(Boolean).join(" | ")}
          </Typography>
          {cTax && <Typography variant="body2" sx={{ mt: 0.5, fontSize: "11px", fontWeight: 700, color: "#000000" }}>{cTax}</Typography>}
        </Box>
      </Box>
      
      <Box sx={{ display: "flex", justifyContent: "flex-end", borderBottom: "1px solid #000000", pb: 1, mb: 2 }}>
        <Typography variant="h6" sx={{ m: 0, fontSize: "18px", color: "#000000", fontWeight: 700, letterSpacing: "0.5px" }}>
          {title}
        </Typography>
      </Box>
    </Box>
  );
}

function StatPill({ label, value, color }: { label: string; value: string | number; color: string }) {
  return (
    <Box sx={{
      display: "inline-flex",
      alignItems: "center",
      gap: 0.5,
      px: 1.5,
      height: 32,
      borderRadius: 2,
      bgcolor: (theme) => theme.palette.mode === "dark" ? `${color}22` : color,
      color: (theme) => theme.palette.mode === "dark" ? (color === "#0f5132" ? "primary.main" : color) : "#fff",
      border: (theme) => theme.palette.mode === "dark" ? `1px solid ${color}55` : "none",
      whiteSpace: "nowrap"
    }}>
      <Typography variant="body2" sx={{ lineHeight: 1, color: "inherit", opacity: 0.9 }}>{label}</Typography>
      <Typography variant="body2" sx={{ fontWeight: 700, lineHeight: 1, color: "inherit" }}>{value}</Typography>
    </Box>
  );
}

function PrintTable({ columns, rows, totals, title }: { columns: string[]; rows: any[][]; totals?: any; title?: string }) {
  const hasGrouping = rows.some(r => r.some(c => c && typeof c === "object" && !React.isValidElement(c) && ((c as any).rowSpan || (c as any).hidden)));
  const [orderBy, setOrderBy] = useState(hasGrouping ? -1 : 0);
  const [order, setOrder] = useState<"asc" | "desc">("desc");

  const handleSort = (colIdx: number) => {
    const isSame = orderBy === colIdx;
    const isAsc = isSame && order === "asc";
    setOrder(isAsc ? "desc" : "asc");
    setOrderBy(colIdx);
  };

  const sortedRows = useMemo(() => {
    if (orderBy < 0) return rows;
    return [...rows].sort((a, b) => {
      const valA = a[orderBy] && typeof a[orderBy] === "object" ? (a[orderBy] as any).content ?? "" : a[orderBy] ?? "";
      const valB = b[orderBy] && typeof b[orderBy] === "object" ? (b[orderBy] as any).content ?? "" : b[orderBy] ?? "";
      const strA = String(valA).toLowerCase();
      const strB = String(valB).toLowerCase();
      if (strA === strB) return 0;
      const cmp = strA < strB ? -1 : 1;
      return order === "asc" ? cmp : -cmp;
    });
  }, [rows, orderBy, order]);

  return (
    <>
      {title && <PrintHeader title={title} />}
      <Typography variant="h5" className="print-only" sx={{ mb: 1, fontWeight: 700, textAlign: "center", display: "none" }}>{title || ""}</Typography>
      <Table size="small">
        <TableHead>
          <TableRow>
            {columns.map((c, idx) => (
              <TableCell key={c} sx={{ fontWeight: 700, fontSize: "0.75rem",
                textTransform: "uppercase", borderColor: BORDER, p: "5px 8px",
                cursor: "pointer", userSelect: "none" }} onClick={() => handleSort(idx)}>
                <TableSortLabel active={orderBy === idx} direction={orderBy === idx ? order : "asc"}>
                  {c}
                </TableSortLabel>
              </TableCell>
            ))}
          </TableRow>
        </TableHead>
        <TableBody>
          {sortedRows.map((row, i) => (
            <TableRow key={i} hover>
              {row.map((cell, j) => {
                const isObj = cell && typeof cell === "object" && !React.isValidElement(cell) && ("content" in cell || "hidden" in cell);
                if (isObj && cell.hidden) return null;
                const content = isObj ? cell.content : cell;
                const rowSpan = isObj ? cell.rowSpan : undefined;
                return (
                  <TableCell key={j} rowSpan={rowSpan} sx={{ fontSize: "0.8rem", borderColor: BORDER, verticalAlign: "top", p: "5px 8px" }}>
                    {content ?? "-"}
                  </TableCell>
                );
              })}
            </TableRow>
          ))}
          {totals && (
            Array.isArray(totals[0]) ? (
              (totals as any[]).map((totalsRow, idx) => (
                <TableRow key={idx} sx={{ bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.12) !important" : "#e8f5e9 !important", "&:hover": { bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.18) !important" : "#e8f5e9 !important" } }}>
                  {totalsRow.map((t, i) => (
                    <TableCell key={i} sx={{ fontWeight: 700, fontSize: "0.8rem", borderColor: BORDER, color: (theme) => theme.palette.mode === "dark" ? "primary.main !important" : "#0f5132 !important", p: "5px 8px" }}>{t ?? ""}</TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow sx={{ bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.12) !important" : "#e8f5e9 !important", "&:hover": { bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.18) !important" : "#e8f5e9 !important" } }}>
                {(totals as any[]).map((t, i) => (
                  <TableCell key={i} sx={{ fontWeight: 700, fontSize: "0.8rem", borderColor: BORDER, color: (theme) => theme.palette.mode === "dark" ? "primary.main !important" : "#0f5132 !important", p: "5px 8px" }}>{t ?? ""}</TableCell>
                ))}
              </TableRow>
            )
          )}
        </TableBody>
      </Table>
    </>
  );
}

// ── Day Book ──
export function DayBookReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery({
    queryKey: ["report-daybook", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/day-book?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalDr = data.reduce((s: number, r: any) => s + Number(r.dr_amount || 0), 0);
  const totalCr = data.reduce((s: number, r: any) => s + Number(r.cr_amount || 0), 0);
  const totalAmt = data.reduce((s: number, r: any) => s + Number(r.amount || 0), 0);
  const totalEntries = data.length;

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    let rowsHtml = "";
    data.forEach((r: any) => {
      const dr = Number(r.dr_amount || 0);
      const cr = Number(r.cr_amount || 0);
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.voucher_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.voucher_date}</td>
        <td style="text-align: center;">${r.voucher_type}</td>
        <td>${r.ledger_name}</td>
        <td style="text-align: right; color: ${dr > 0 ? '#198754' : '#6c757d'};">${dr > 0 ? `₹${formatAmount(dr)}` : '—'}</td>
        <td style="text-align: right;">${cr > 0 ? `₹${formatAmount(cr)}` : '—'}</td>
        <td>${r.narration || r.particulars || ""}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Day Book Report</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 landscape; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #0f5132 !important;
              color: #ffffff !important;
              -webkit-print-color-adjust: exact !important;
              print-color-adjust: exact !important;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Day Book Report</h2>
            <div class="doc-date">Period: <strong>${fromDate} to ${toDate}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr style="background-color: #0f5132; color: #fff;">
                <th style="width: 110px; text-align: center;">Voucher No.</th>
                <th style="width: 95px; text-align: center;">Date</th>
                <th style="width: 100px; text-align: center;">Type</th>
                <th style="text-align: left;">Ledger / Particulars</th>
                <th style="width: 110px; text-align: right;">Debit (Dr)</th>
                <th style="width: 110px; text-align: right;">Credit (Cr)</th>
                <th style="text-align: left;">Narration / Details</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="4" style="text-align: right; text-transform: uppercase;">Total</td>
                <td style="text-align: right; color: #198754;">₹${formatAmount(totalDr)}</td>
                <td style="text-align: right;">₹${formatAmount(totalCr)}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Day Book" breadcrumbs={[{ label: "Accounts" }, { label: "Day Book" }]} />
        <FilterRow>
          <TextField label="From Date" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <TextField label="To Date" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show Report</Button>
          {data.length > 0 && (
            <>
              <StatPill label="Entries" value={totalEntries} color="#1976d2" />
              <StatPill label="Total Debit (Dr)" value={`₹${formatAmount(totalDr)}`} color="#2e7d32" />
              <StatPill label="Total Credit (Cr)" value={`₹${formatAmount(totalCr)}`} color="#ed6c02" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Day Book"
            columns={["Voucher No.", "Date", "Type", "Ledger / Particulars", "Debit (Dr)", "Credit (Cr)", "Narration / Details"]}
            rows={data.map((r: any) => [
              r.voucher_no,
              r.voucher_date,
              r.voucher_type,
              r.ledger_name,
              Number(r.dr_amount || 0) > 0 ? `₹${formatAmount(r.dr_amount)}` : "—",
              Number(r.cr_amount || 0) > 0 ? `₹${formatAmount(r.cr_amount)}` : "—",
              r.narration || r.particulars || "-"
            ])}
            totals={["", "", "", "TOTAL", `₹${formatAmount(totalDr)}`, `₹${formatAmount(totalCr)}`, ""]}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No entries found for the selected date range.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Inward Register ──
export function InwardRegisterReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery({
    queryKey: ["report-inward-reg", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/inward-register?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalQty = data.reduce((s: number, r: any) => s + Number(r.quantity || 0), 0);
  const totalWeight = data.reduce((s: number, r: any) => s + Number(r.total_weight || 0), 0);
  const totalEntries = data.length;

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = `${fromDate} to ${toDate}`;

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.inward_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.inward_date}</td>
        <td>${r.ledger}</td>
        <td style="text-align: center;">${r.ref_no}</td>
        <td style="text-align: right;">${formatQty(r.quantity)}</td>
        <td style="text-align: right;">${formatWeight(r.total_weight)}</td>
        <td style="text-align: center;">${r.is_completed ? "Done" : "Pending"}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Inward Register</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Inward Register</h2>
            <div class="doc-date">Period: <strong>${dateStr}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 100px; text-align: center;">Inward No.</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="text-align: left;">Ledger</th>
                <th style="width: 105px; text-align: center;">Inward Ref No.</th>
                <th style="width: 75px; text-align: right;">Qty</th>
                <th style="width: 85px; text-align: right;">Weight</th>
                <th style="width: 65px; text-align: center;">Status</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="3" style="text-align: right; text-transform: uppercase;">Total</td>
                <td></td>
                <td style="text-align: right;">${formatQty(totalQty)}</td>
                <td style="text-align: right;">${formatWeight(totalWeight)}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Inward Register" breadcrumbs={[{ label: "Reports" }, { label: "Inward Register" }]} />
        <FilterRow>
          <TextField label="From" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="To" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show</Button>
          {data.length > 0 && (
            <>
              <StatPill label="Entries" value={totalEntries} color="#1976d2" />
              <StatPill label="Total Qty" value={formatQty(totalQty)} color="#ed6c02" />
              <StatPill label="Total Weight" value={`${formatWeight(totalWeight)} kg`} color="#4caf50" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Inward Register"
            columns={["Inward No.", "Date", "Ledger", "Inward Ref No.", "Qty", "Weight", "Status"]}
            rows={data.map((r: any) => [r.inward_no, r.inward_date, r.ledger, r.ref_no, r.quantity, r.total_weight ? formatWeight(r.total_weight) : "-", r.is_completed ? "Done" : "Pending"])}
            totals={["", "", "TOTAL", "", formatQty(totalQty), `${formatWeight(totalWeight)} kg`, ""]}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No inward entries found for the selected date range.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Outward Register ──
export function OutwardRegisterReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery({
    queryKey: ["report-outward-reg", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/outward-register?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalQty = data.reduce((s: number, r: any) => s + Number(r.quantity || 0), 0);
  const totalWeight = data.reduce((s: number, r: any) => s + Number(r.total_weight || 0), 0);
  const totalEntries = data.length;

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = `${fromDate} to ${toDate}`;

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.outward_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.outward_date}</td>
        <td>${r.ledger}</td>
        <td style="text-align: center;">${r.ref_no}</td>
        <td style="text-align: right;">${formatQty(r.quantity)}</td>
        <td style="text-align: right;">${formatWeight(r.total_weight)}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Outward Register</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Outward Register</h2>
            <div class="doc-date">Period: <strong>${dateStr}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 100px; text-align: center;">Outward No.</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="text-align: left;">Ledger</th>
                <th style="width: 140px; text-align: center;">Outward Ref No.</th>
                <th style="width: 75px; text-align: right;">Qty</th>
                <th style="width: 85px; text-align: right;">Weight</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="3" style="text-align: right; text-transform: uppercase;">Total</td>
                <td></td>
                <td style="text-align: right;">${formatQty(totalQty)}</td>
                <td style="text-align: right;">${formatWeight(totalWeight)}</td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Outward Register" breadcrumbs={[{ label: "Reports" }, { label: "Outward Register" }]} />
        <FilterRow>
          <TextField label="From" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="To" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show</Button>
          {data.length > 0 && (
            <>
              <StatPill label="Entries" value={totalEntries} color="#1976d2" />
              <StatPill label="Total Qty" value={formatQty(totalQty)} color="#ed6c02" />
              <StatPill label="Total Weight" value={`${formatWeight(totalWeight)} kg`} color="#4caf50" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Outward Register"
            columns={["Outward No.", "Date", "Ledger", "Outward Ref No.", "Qty", "Weight"]}
            rows={data.map((r: any) => [r.outward_no, r.outward_date, r.ledger, r.ref_no, r.quantity, r.total_weight ? `${formatWeight(r.total_weight)}` : "-"])}
            totals={["", "", "TOTAL", "", formatQty(totalQty), `${formatWeight(totalWeight)} kg`]}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No outward entries found for the selected date range.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Labour Bill Register ──
export function LabourBillRegisterReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery({
    queryKey: ["report-lb-reg", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/labour-bill-register?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalAmt = data.reduce((s: number, r: any) => s + Number(r.total_amount || 0), 0);
  const totalEntries = data.length;

  const contractorSummary = useMemo(() => {
    const map: Record<string, { contractor_name: string; total_qty: number; total_amount: number; count: number }> = {};
    data.forEach((row: any) => {
      const name = row.ledger || "General";
      if (!map[name]) {
        map[name] = { contractor_name: name, total_qty: 0, total_amount: 0, count: 0 };
      }
      map[name].total_qty += Number(row.quantity || 0);
      map[name].total_amount += Number(row.total_amount || row.amount || 0);
      map[name].count += 1;
    });
    return Object.values(map);
  }, [data]);

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.bill_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.bill_date}</td>
        <td>${r.ledger}</td>
        <td>${r.product}</td>
        <td style="text-align: right;">${formatQty(r.quantity)}</td>
        <td style="text-align: right;">${formatAmount(r.rate)}</td>
        <td style="text-align: right;">₹${formatAmount(r.amount)}</td>
        <td style="text-align: center;">${r.gst_percent}%</td>
        <td style="text-align: right;">₹${formatAmount(r.total_amount)}</td>
        <td style="text-align: center;">${r.is_paid ? "Paid" : "Pending"}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Labour Bill Register</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Labour Bill Register</h2>
            <div class="doc-date">Period: <strong>${fromDate} to ${toDate}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 95px; text-align: center;">Bill No.</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="text-align: left;">Contractor</th>
                <th style="text-align: left;">Product</th>
                <th style="width: 60px; text-align: right;">Qty</th>
                <th style="width: 65px; text-align: right;">Rate</th>
                <th style="width: 80px; text-align: right;">Amount</th>
                <th style="width: 55px; text-align: center;">GST%</th>
                <th style="width: 85px; text-align: right;">Total</th>
                <th style="width: 65px; text-align: center;">Status</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="4" style="text-align: right; text-transform: uppercase;">Total</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="text-align: right;">₹${formatAmount(totalAmt)}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Labour Bill Register" breadcrumbs={[{ label: "Reports" }, { label: "Labour Bill Register" }]} />
        <FilterRow>
          <TextField label="From" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <TextField label="To" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show</Button>
          {data.length > 0 && (
            <>
              <StatPill label="Entries" value={totalEntries} color="#1976d2" />
              <StatPill label="Total Amount" value={`₹${formatAmount(totalAmt)}`} color="#ed6c02" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Labour Bill Register"
            columns={["Bill No.", "Date", "Contractor", "Product", "Qty", "Rate", "Amount", "GST%", "Total", "Status"]}
            rows={data.map((r: any) => [r.bill_no, r.bill_date, r.ledger, r.product, r.quantity, r.rate, `₹${formatAmount(r.amount)}`, `${r.gst_percent}%`, `₹${formatAmount(r.total_amount)}`, r.is_paid ? "Paid" : "Pending"])}
            totals={["", "", "", "TOTAL", "", "", "", "", `₹${formatAmount(totalAmt)}`, ""]}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No labour bills found for the selected date range.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Trial Balance ──
export function TrialBalanceReport() {
  const { activeFY } = useAuthStore();
  const [asOfDate, setAsOfDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery({
    queryKey: ["report-trial", activeFY, asOfDate, enabled],
    queryFn: async () => (await api.get(`/reports/trial-balance?fy=${activeFY}&as_of_date=${asOfDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalDr = data.reduce((s: number, r: any) => s + Number(r.closing_dr || 0), 0);
  const totalCr = data.reduce((s: number, r: any) => s + Number(r.closing_cr || 0), 0);
  const totalEntries = data.length;

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td>${r.ledger}</td>
        <td>${r.grp}</td>
        <td style="text-align: right;">${r.closing_dr ? `₹${formatAmount(r.closing_dr)}` : "-"}</td>
        <td style="text-align: right;">${r.closing_cr ? `₹${formatAmount(r.closing_cr)}` : "-"}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Trial Balance</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Trial Balance</h2>
            <div class="doc-date">As of Date: <strong>${asOfDate}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="text-align: left;">Ledger</th>
                <th style="text-align: left;">Group</th>
                <th style="width: 110px; text-align: right;">Total Dr (₹)</th>
                <th style="width: 110px; text-align: right;">Total Cr (₹)</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td style="text-align: right; text-transform: uppercase;">Total</td>
                <td></td>
                <td style="text-align: right;">₹${formatAmount(totalDr)}</td>
                <td style="text-align: right;">₹${formatAmount(totalCr)}</td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Trial Balance" breadcrumbs={[{ label: "Reports" }, { label: "Trial Balance" }]} />
        <FilterRow>
          <TextField label="As of Date" type="date" size="small" value={asOfDate} onChange={(e) => setAsOfDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show Trial Balance</Button>
          {data.length > 0 && (
            <>
              <StatPill label="Ledgers" value={totalEntries} color="#1976d2" />
              <StatPill label="Total Dr" value={`₹${formatAmount(totalDr)}`} color="#ed6c02" />
              <StatPill label="Total Cr" value={`₹${formatAmount(totalCr)}`} color="#4caf50" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Trial Balance"
            columns={["Ledger", "Group", "Total Dr (₹)", "Total Cr (₹)"]}
            rows={data.map((r: any) => [r.ledger, r.grp, r.closing_dr ? `₹${formatAmount(r.closing_dr)}` : "-", r.closing_cr ? `₹${formatAmount(r.closing_cr)}` : "-"])}
            totals={["TOTAL", "", `₹${formatAmount(totalDr)}`, `₹${formatAmount(totalCr)}`]}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No ledger data found for the selected date.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Pending Bills ──
export function PendingBillsReport() {
  const { activeFY } = useAuthStore();
  const { data = [] } = useQuery({
    queryKey: ["report-pending-bills", activeFY],
    queryFn: async () => (await api.get(`/reports/pending-bills?fy=${activeFY}`)).data,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const total = data.reduce((s: number, r: any) => s + Number(r.total_amount || 0), 0);

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.bill_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.bill_date}</td>
        <td>${r.ledger}</td>
        <td style="text-align: right;">₹${formatAmount(r.total_amount)}</td>
        <td>${r.narration || ""}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Pending Bills</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Pending Bills</h2>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 95px; text-align: center;">Bill No.</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="text-align: left;">Contractor</th>
                <th style="width: 100px; text-align: right;">Total Amount</th>
                <th style="text-align: left;">Narration</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="3" style="text-align: right; text-transform: uppercase;">TOTAL PENDING</td>
                <td style="text-align: right;">₹${formatAmount(total)}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Pending Bills" breadcrumbs={[{ label: "Reports" }, { label: "Pending Bills" }]} />
        {data.length > 0 && (
          <FilterRow>
            <StatPill label="Pending Bills" value={data.length} color="#1976d2" />
            <StatPill label="Total Amount" value={`₹${formatAmount(total)}`} color="#ed6c02" />
            <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
          </FilterRow>
        )}
      </Box>
      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Pending Bills"
            columns={["Bill No.", "Date", "Contractor", "Total Amount", "Narration"]}
            rows={data.map((r: any) => [r.bill_no, r.bill_date, r.ledger, `₹${formatAmount(r.total_amount)}`, r.narration])}
            totals={["", "", "TOTAL PENDING", `₹${formatAmount(total)}`, ""]}
          />
        </Paper>
      )}
      {data.length === 0 && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No pending bills found.</Typography>
        </Paper>
      )}
    </Box>
  );
}

// ── Receivables (from Labour Bills) ──
interface RecordPaymentDialogProps {
  open: boolean;
  onClose: () => void;
  bill: any;
  activeFY: string;
  onSuccess: () => void;
}

function RecordBillPaymentDialog({ open, onClose, bill, activeFY, onSuccess }: RecordPaymentDialogProps) {
  const qc = useQueryClient();
  const [editingPaymentId, setEditingPaymentId] = useState<number | null>(null);
  const [paymentDate, setPaymentDate] = useState(new Date().toISOString().split("T")[0]);
  const [paymentMode, setPaymentMode] = useState("Bank Transfer");
  const [componentPreset, setComponentPreset] = useState<"TAXABLE" | "GST" | "PARTIAL" | "FULL">("TAXABLE");
  const [taxableAmt, setTaxableAmt] = useState<string>("");
  const [gstAmt, setGstAmt] = useState<string>("");
  const [tdsPercent, setTdsPercent] = useState<number>(1);
  const [tdsAmt, setTdsAmt] = useState<string>("");
  const [netPaidAmt, setNetPaidAmt] = useState<string>("");
  const [notes, setNotes] = useState("");
  const [saving, setSaving] = useState(false);

  const { data: paymentHistory = [] } = useQuery({
    queryKey: ["bill-payments", bill?.id, activeFY],
    queryFn: async () => {
      if (!bill?.id) return [];
      return (await api.get(`/labour-bills/${bill.id}/payments?fy=${activeFY}`)).data;
    },
    enabled: open && !!bill?.id,
  });

  useEffect(() => {
    if (open && bill) {
      setEditingPaymentId(null);
      const tax = Number(bill.taxable_amount || bill.amount || bill.total_amount || 0);
      const gst = Number(bill.gst_amount || 0);
      const tds = Math.round((tax * 1) / 100 * 100) / 100;

      setPaymentDate(new Date().toISOString().split("T")[0]);
      setPaymentMode("Bank Transfer");
      setTdsPercent(1);
      setNotes("");

      if (bill.taxable_paid && !bill.gst_paid) {
        setComponentPreset("GST");
        setTaxableAmt("0");
        setGstAmt(String(gst));
        setTdsAmt("0");
        setNetPaidAmt(String(gst));
      } else {
        setComponentPreset("FULL");
        setTaxableAmt(String(tax));
        setGstAmt(String(gst));
        setTdsAmt(String(tds));
        setNetPaidAmt(String(Math.max(0, tax + gst - tds)));
      }
    }
  }, [open, bill]);

  if (!bill) return null;

  const fullTaxable = Number(bill.taxable_amount || bill.amount || bill.total_amount || 0);
  const fullGst = Number(bill.gst_amount || 0);
  const fullGross = Number(bill.total_amount || bill.net_amount || 0);
  const totalPaid = Number(bill.paid_amount || 0);
  const pendingBal = Math.max(0, fullGross - totalPaid);

  const applyPreset = (preset: "TAXABLE" | "GST" | "PARTIAL" | "FULL") => {
    setComponentPreset(preset);
    const tax = fullTaxable;
    const gst = fullGst;
    const tds = Math.round((tax * (tdsPercent || 0)) / 100 * 100) / 100;

    if (preset === "TAXABLE") {
      setTaxableAmt(String(tax));
      setGstAmt("0");
      setTdsAmt(String(tds));
      setNetPaidAmt(String(Math.max(0, tax - tds)));
    } else if (preset === "GST") {
      setTaxableAmt("0");
      setGstAmt(String(gst));
      setTdsAmt("0");
      setNetPaidAmt(String(gst));
    } else if (preset === "FULL") {
      setTaxableAmt(String(tax));
      setGstAmt(String(gst));
      setTdsAmt(String(tds));
      setNetPaidAmt(String(Math.max(0, pendingBal)));
    }
  };

  const handleEditPaymentRow = (ph: any) => {
    setEditingPaymentId(ph.id);
    setPaymentDate(ph.payment_date || new Date().toISOString().split("T")[0]);
    setPaymentMode(ph.payment_mode || "Bank Transfer");
    setComponentPreset(ph.component || "PARTIAL");
    setTaxableAmt(String(ph.taxable_amount || 0));
    setGstAmt(String(ph.gst_amount || 0));
    setTdsAmt(String(ph.tds_amount || 0));
    setNetPaidAmt(String(ph.net_paid_amount || 0));
    setNotes(ph.notes || "");
  };

  const handleTaxableChange = (val: string) => {
    setTaxableAmt(val);
    setComponentPreset("PARTIAL");
    const tax = parseFloat(val) || 0;
    const gst = parseFloat(gstAmt) || 0;
    const tds = Math.round((tax * (tdsPercent || 0)) / 100 * 100) / 100;
    setTdsAmt(String(tds));
    setNetPaidAmt(String(Math.max(0, tax + gst - tds)));
  };

  const handleGstChange = (val: string) => {
    setGstAmt(val);
    setComponentPreset("PARTIAL");
    const tax = parseFloat(taxableAmt) || 0;
    const gst = parseFloat(val) || 0;
    const tds = parseFloat(tdsAmt) || 0;
    setNetPaidAmt(String(Math.max(0, tax + gst - tds)));
  };

  const handleTdsPercentChange = (pct: number) => {
    setTdsPercent(pct);
    const tax = parseFloat(taxableAmt) || 0;
    const gst = parseFloat(gstAmt) || 0;
    const tds = Math.round((tax * pct) / 100 * 100) / 100;
    setTdsAmt(String(tds));
    setNetPaidAmt(String(Math.max(0, tax + gst - tds)));
  };

  const handleTdsAmtChange = (val: string) => {
    setTdsAmt(val);
    const tax = parseFloat(taxableAmt) || 0;
    const gst = parseFloat(gstAmt) || 0;
    const tds = parseFloat(val) || 0;
    setNetPaidAmt(String(Math.max(0, tax + gst - tds)));
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const payload = {
        payment_date: paymentDate,
        payment_mode: paymentMode,
        component: componentPreset,
        taxable_amount: parseFloat(taxableAmt) || 0,
        gst_amount: parseFloat(gstAmt) || 0,
        tds_amount: parseFloat(tdsAmt) || 0,
        net_paid_amount: parseFloat(netPaidAmt) || 0,
        notes: notes || `Payment received (${componentPreset})`,
      };

      if (editingPaymentId) {
        await api.put(`/labour-bills/${bill.id}/payments/${editingPaymentId}?fy=${activeFY}`, payload);
      } else {
        await api.post(`/labour-bills/${bill.id}/record-payment?fy=${activeFY}`, payload);
      }
      onSuccess();
      onClose();
    } catch (err: any) {
      alert(err.response?.data?.detail || "Failed to save payment entry.");
    } finally {
      setSaving(false);
    }
  };

  const handleDeletePayment = async (paymentId: number) => {
    if (!confirm("Are you sure you want to delete this payment installment? The bill balance will be automatically recalculated.")) return;
    try {
      await api.delete(`/labour-bills/${bill.id}/payments/${paymentId}?fy=${activeFY}`);
      qc.invalidateQueries({ queryKey: ["bill-payments", bill?.id] });
      qc.invalidateQueries({ queryKey: ["receivables"] });
      onSuccess();
    } catch (err: any) {
      alert("Failed to delete payment.");
    }
  };

  const handleResetToPending = async () => {
    if (!confirm(`Are you sure you want to reset Bill #${bill.bill_no} back to Pending? All payment entries for this bill will be cleared and full bill balance will become receivable again.`)) return;
    try {
      await api.post(`/labour-bills/${bill.id}/reset-payment?fy=${activeFY}`);
      qc.invalidateQueries({ queryKey: ["receivables"] });
      onSuccess();
      onClose();
    } catch (err: any) {
      alert("Failed to reset bill payment.");
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ fontWeight: 700, color: "text.primary", pb: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>{editingPaymentId ? `Edit Payment Entry — Bill #${bill.bill_no}` : `Record Payment — Bill #${bill.bill_no}`}</span>
        <Chip
          label={bill.payment_status === "PAID" ? "FULLY PAID" : bill.payment_status === "PARTIAL" ? "PARTIALLY RECEIVED" : "UNPAID"}
          color={bill.payment_status === "PAID" ? "success" : bill.payment_status === "PARTIAL" ? "warning" : "error"}
          size="small"
          sx={{ fontWeight: 800, fontSize: 11 }}
        />
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "text.primary", mb: 2 }}>
          Contractor: {bill.ledger_name}
        </Typography>

        {/* Preset Stage Buttons */}
        <Paper variant="outlined" sx={{
          p: 1.5,
          mb: 2.5,
          bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "#f0fdf4",
          borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.3)" : "#a5d6a7"
        }}>
          <Typography variant="caption" sx={{
            fontWeight: 700,
            color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132",
            textTransform: "uppercase",
            display: "block",
            mb: 1
          }}>
            Select Payment Stage / Preset Shortcut:
          </Typography>
          <Grid container spacing={1}>
            <Grid size={{ xs: 3 }}>
              <Button
                fullWidth
                size="small"
                variant={componentPreset === "TAXABLE" ? "contained" : "outlined"}
                color="primary"
                onClick={() => applyPreset("TAXABLE")}
                sx={{ textTransform: "none", fontWeight: 700, fontSize: 11, py: 0.75 }}
              >
                1. Pay Taxable First
              </Button>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Button
                fullWidth
                size="small"
                variant={componentPreset === "GST" ? "contained" : "outlined"}
                color="secondary"
                onClick={() => applyPreset("GST")}
                sx={{ textTransform: "none", fontWeight: 700, fontSize: 11, py: 0.75 }}
              >
                2. Pay GST Later
              </Button>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Button
                fullWidth
                size="small"
                variant={componentPreset === "PARTIAL" ? "contained" : "outlined"}
                color="warning"
                onClick={() => applyPreset("PARTIAL")}
                sx={{ textTransform: "none", fontWeight: 700, fontSize: 11, py: 0.75 }}
              >
                Custom Part
              </Button>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Button
                fullWidth
                size="small"
                variant={componentPreset === "FULL" ? "contained" : "outlined"}
                color="success"
                onClick={() => applyPreset("FULL")}
                sx={{ textTransform: "none", fontWeight: 700, fontSize: 11, py: 0.75 }}
              >
                Full Settle
              </Button>
            </Grid>
          </Grid>
        </Paper>

        {/* Editable Bill Breakdown Section */}
        <Paper variant="outlined" sx={{
          p: 2,
          mb: 3,
          bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f8fafc",
          borderRadius: 2
        }}>
          <Typography variant="caption" sx={{
            fontWeight: 700,
            color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132",
            textTransform: "uppercase",
            letterSpacing: 0.5,
            display: "block",
            mb: 1.5
          }}>
            Editable Received Payment Amounts
          </Typography>
          <Grid container spacing={1.5}>
            <Grid size={{ xs: 6 }}>
              <TextField
                label="Taxable Amount Received (₹)"
                type="number"
                fullWidth
                size="small"
                value={taxableAmt}
                onChange={(e) => handleTaxableChange(e.target.value)}
                slotProps={{ inputLabel: { shrink: true } }}
              />
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField
                label="GST Amount Received (₹)"
                type="number"
                fullWidth
                size="small"
                value={gstAmt}
                onChange={(e) => handleGstChange(e.target.value)}
                slotProps={{ inputLabel: { shrink: true } }}
              />
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField
                select
                label="TDS Deduction (%)"
                fullWidth
                size="small"
                value={tdsPercent}
                onChange={(e) => handleTdsPercentChange(Number(e.target.value))}
                slotProps={{ inputLabel: { shrink: true } }}
              >
                <MenuItem value={0}>0% (No TDS)</MenuItem>
                <MenuItem value={1}>1% (Sec 194C - Indv/HUF)</MenuItem>
                <MenuItem value={2}>2% (Sec 194C - Company/Others)</MenuItem>
                <MenuItem value={5}>5% (Sec 194J - Professional)</MenuItem>
                <MenuItem value={10}>10% (Sec 194I - Rent)</MenuItem>
              </TextField>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <TextField
                label="TDS Amount (₹)"
                type="number"
                fullWidth
                size="small"
                value={tdsAmt}
                onChange={(e) => handleTdsAmtChange(e.target.value)}
                slotProps={{ inputLabel: { shrink: true } }}
                sx={{ "& input": { color: "error.main", fontWeight: 700 } }}
              />
            </Grid>
            <Grid size={{ xs: 12 }}>
              <Divider sx={{ my: 0.5 }} />
              <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", pt: 0.5 }}>
                <Typography variant="subtitle2" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                  NET PAYMENT RECEIVED IN THIS ENTRY:
                </Typography>
                <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                  ₹{formatAmount(parseFloat(netPaidAmt) || 0)}
                </Typography>
              </Box>
            </Grid>
          </Grid>
        </Paper>

        {/* Payment Entry Form */}
        <Grid container spacing={2}>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Payment Date"
              type="date"
              fullWidth
              size="small"
              value={paymentDate}
              onChange={(e) => setPaymentDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              select
              label="Payment Mode"
              fullWidth
              size="small"
              value={paymentMode}
              onChange={(e) => setPaymentMode(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            >
              <MenuItem value="Bank Transfer">Bank Transfer (NEFT/RTGS/IMPS)</MenuItem>
              <MenuItem value="Cash">Cash</MenuItem>
              <MenuItem value="Cheque">Cheque</MenuItem>
              <MenuItem value="UPI">UPI</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Net Amount Received (₹)"
              type="number"
              fullWidth
              size="small"
              value={netPaidAmt}
              onChange={(e) => setNetPaidAmt(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
              sx={{ "& input": { fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" } }}
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Payment Notes / Reference No."
              fullWidth
              size="small"
              multiline
              rows={2}
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="e.g. Stage 1 Taxable received via NEFT UTR #12345"
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
        </Grid>

        {/* Previous Payment History */}
        {paymentHistory.length > 0 && (
          <Paper variant="outlined" sx={{ p: 1.5, mt: 3, borderRadius: 2 }}>
            <Typography variant="caption" sx={{ fontWeight: 700, color: "text.secondary", textTransform: "uppercase", display: "block", mb: 1 }}>
              Previous Payment Installments ({paymentHistory.length})
            </Typography>
            <Table size="small">
              <TableHead>
                <TableRow sx={{ bgcolor: "action.hover" }}>
                  <TableCell sx={{ fontWeight: 700, fontSize: 11 }}>Date</TableCell>
                  <TableCell sx={{ fontWeight: 700, fontSize: 11 }}>Stage</TableCell>
                  <TableCell sx={{ fontWeight: 700, fontSize: 11 }}>Mode</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 700, fontSize: 11 }}>Received (₹)</TableCell>
                  <TableCell sx={{ fontWeight: 700, fontSize: 11 }}>Notes</TableCell>
                  <TableCell align="center" sx={{ fontWeight: 700, fontSize: 11, width: 70 }}>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {paymentHistory.map((ph: any) => (
                  <TableRow key={ph.id} selected={editingPaymentId === ph.id}>
                    <TableCell sx={{ fontSize: 11 }}>{ph.payment_date}</TableCell>
                    <TableCell sx={{ fontSize: 11, fontWeight: 700, color: "primary.main" }}>{ph.component}</TableCell>
                    <TableCell sx={{ fontSize: 11 }}>{ph.payment_mode}</TableCell>
                    <TableCell align="right" sx={{ fontSize: 11, fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>₹{formatAmount(ph.net_paid_amount)}</TableCell>
                    <TableCell sx={{ fontSize: 11, color: "text.secondary" }}>{ph.notes || "-"}</TableCell>
                    <TableCell align="center">
                      <Box sx={{ display: "flex", alignItems: "center", justifyContent: "center" }}>
                        <Tooltip title="Edit Payment Entry">
                          <IconButton size="small" color="primary" onClick={() => handleEditPaymentRow(ph)}>
                            <Edit sx={{ fontSize: 14 }} />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete Installment">
                          <IconButton size="small" color="error" onClick={() => handleDeletePayment(ph.id)}>
                            <Delete sx={{ fontSize: 14 }} />
                          </IconButton>
                        </Tooltip>
                      </Box>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </Paper>
        )}
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2, display: "flex", justifyContent: "space-between" }}>
        <Button onClick={handleResetToPending} variant="outlined" color="error" size="small">
          Reset to Pending
        </Button>
        <Box sx={{ display: "flex", gap: 1 }}>
          <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
          <Button onClick={handleSave} variant="contained" color="success" size="small" disabled={saving}>
            {saving ? "Saving..." : editingPaymentId ? "Update Payment Entry" : "Record Payment & Update Status"}
          </Button>
        </Box>
      </DialogActions>
    </Dialog>
  );
}

interface EditBillDetailsDialogProps {
  open: boolean;
  onClose: () => void;
  bill: any;
  activeFY: string;
  onSuccess: () => void;
}

function EditBillDetailsDialog({ open, onClose, bill, activeFY, onSuccess }: EditBillDetailsDialogProps) {
  const [billNo, setBillNo] = useState("");
  const [billDate, setBillDate] = useState("");
  const [taxableAmt, setTaxableAmt] = useState("");
  const [gstAmt, setGstAmt] = useState("");
  const [totalAmt, setTotalAmt] = useState("");
  const [narration, setNarration] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (open && bill) {
      setBillNo(bill.bill_no || "");
      setBillDate(bill.bill_date || "");
      const tax = bill.taxable_amount || bill.amount || 0;
      const gst = bill.gst_amount || 0;
      const tot = bill.total_amount || bill.net_amount || (tax + gst);
      setTaxableAmt(String(tax));
      setGstAmt(String(gst));
      setTotalAmt(String(tot));
      setNarration(bill.narration || "");
    }
  }, [open, bill]);

  if (!bill) return null;

  const handleSave = async () => {
    setSaving(true);
    try {
      await api.patch(`/labour-bills/${bill.id}/edit-bill?fy=${activeFY}`, {
        bill_no: billNo,
        bill_date: billDate,
        taxable_amount: parseFloat(taxableAmt) || 0,
        gst_amount: parseFloat(gstAmt) || 0,
        total_amount: parseFloat(totalAmt) || 0,
        narration: narration,
      });
      onSuccess();
      onClose();
    } catch (err: any) {
      alert(err.response?.data?.detail || "Failed to update bill.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth>
      <DialogTitle sx={{ fontWeight: 700, color: "text.primary", pb: 1 }}>
        Edit Labour Bill — #{bill.bill_no}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Grid container spacing={2}>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Bill No."
              fullWidth
              size="small"
              value={billNo}
              onChange={(e) => setBillNo(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Bill Date"
              type="date"
              fullWidth
              size="small"
              value={billDate}
              onChange={(e) => setBillDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Taxable Amount (₹)"
              type="number"
              fullWidth
              size="small"
              value={taxableAmt}
              onChange={(e) => setTaxableAmt(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="GST Amount (₹)"
              type="number"
              fullWidth
              size="small"
              value={gstAmt}
              onChange={(e) => setGstAmt(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Total Bill Amount (₹)"
              type="number"
              fullWidth
              size="small"
              value={totalAmt}
              onChange={(e) => setTotalAmt(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
              sx={{ "& input": { fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" } }}
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Narration"
              fullWidth
              size="small"
              multiline
              rows={2}
              value={narration}
              onChange={(e) => setNarration(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button onClick={handleSave} variant="contained" color="primary" size="small" disabled={saving}>
          {saving ? "Saving..." : "Update Bill Details"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}

export function ReceivablesReport() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [statusFilter, setStatusFilter] = useState<"pending" | "received" | "all">("pending");
  const [selectedLedgerId, setSelectedLedgerId] = useState<number | "">("");
  const [activePaymentBill, setActivePaymentBill] = useState<any>(null);
  const [activeEditBill, setActiveEditBill] = useState<any>(null);

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-account"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data,
  });

  const { data: rawData = [], isLoading, refetch } = useQuery<any[]>({
    queryKey: ["receivables", activeFY, fromDate, toDate, selectedLedgerId, statusFilter],
    queryFn: async () => {
      let url = `/reports/receivables?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}&status=${statusFilter}`;
      if (selectedLedgerId) url += `&ledger_id=${selectedLedgerId}`;
      return (await api.get(url)).data;
    },
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  // Group by ledger
  const grouped = useMemo(() => {
    const map: Record<string, { ledger_name: string; ledger_id: number; bills: any[]; totalTaxable: number; totalGst: number; totalTds: number; total: number }> = {};
    rawData.forEach((bill: any) => {
      const key = String(bill.ledger_id);
      const taxable = Number(bill.taxable_amount || bill.amount || bill.total_amount || 0);
      const gst = Number(bill.gst_amount || 0);
      const tds = Number(bill.tds_amount || (taxable * 0.01));
      const tot = Number(bill.total_amount || bill.net_amount || 0);

      if (!map[key]) {
        map[key] = {
          ledger_name: bill.ledger_name || `Ledger #${bill.ledger_id}`,
          ledger_id: bill.ledger_id,
          bills: [],
          totalTaxable: 0,
          totalGst: 0,
          totalTds: 0,
          total: 0
        };
      }
      map[key].bills.push(bill);
      map[key].totalTaxable += taxable;
      map[key].totalGst += gst;
      map[key].totalTds += tds;
      map[key].total += tot;
    });
    return Object.values(map).sort((a, b) => a.ledger_name.localeCompare(b.ledger_name));
  }, [rawData]);

  // Aging summary across all bills
  const agingTotals = useMemo(() => {
    const buckets: Record<string, number> = { "0-30 days": 0, "31-60 days": 0, "61-90 days": 0, "90+ days": 0 };
    rawData.forEach((b: any) => {
      const bucket = b.aging_bucket as string;
      buckets[bucket] = (buckets[bucket] || 0) + Number(b.total_amount || 0);
    });
    return buckets;
  }, [rawData]);

  const grandTotal = rawData.reduce((s: number, b: any) => s + Number(b.total_amount || 0), 0);
  const totalBills = rawData.length;
  const totalContractors = grouped.length;

  const AGING_COLORS: Record<string, string> = {
    "0-30 days": "#2e7d32",
    "31-60 days": "#ed6c02",
    "61-90 days": "#d32f2f",
    "90+ days": "#7b1fa2",
  };

  const handlePrint = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;
    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "";
    const cAddress = [compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", "), compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(", ");
    const cGstin = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";
    const logoHtml = getCompanyLogoHtml(undefined, compData);

    let tableRows = "";
    grouped.forEach((grp) => {
      tableRows += `<tr style="background:#e8f5e9;font-weight:700;">
        <td colspan="4">${grp.ledger_name}</td>
        <td style="text-align:right;">₹${formatAmount(grp.totalTaxable)}</td>
        <td style="text-align:right;">₹${formatAmount(grp.totalGst)}</td>
        <td style="text-align:right;">₹${formatAmount(grp.totalTds)}</td>
        <td style="text-align:right;">₹${formatAmount(grp.total)}</td>
      </tr>`;
      grp.bills.forEach((bill: any) => {
        const aging = bill.aging_bucket as string;
        const agingColor = aging === "0-30 days" ? "#2e7d32" : aging === "31-60 days" ? "#ed6c02" : aging === "61-90 days" ? "#d32f2f" : "#7b1fa2";
        const taxable = Number(bill.taxable_amount || bill.amount || bill.total_amount || 0);
        const gst = Number(bill.gst_amount || 0);
        const tds = Number(bill.tds_amount || (taxable * 0.01));
        tableRows += `<tr>
          <td style="padding-left:15px;">${bill.bill_no}</td>
          <td>${bill.bill_date}</td>
          <td>${bill.days_outstanding} days</td>
          <td><span style="color:${agingColor};font-weight:600;">${bill.aging_bucket}</span></td>
          <td style="text-align:right;">₹${formatAmount(taxable)}</td>
          <td style="text-align:right;">₹${formatAmount(gst)}</td>
          <td style="text-align:right;">₹${formatAmount(tds)}</td>
          <td style="text-align:right;font-weight:700;">₹${formatAmount(bill.total_amount)}</td>
        </tr>`;
      });
    });

    printWindow.document.write(`<!DOCTYPE html><html><head><title>Bills Receivable</title>
      <style>
        ${COMMON_PRINT_CSS}
        @page { size: A4 landscape; margin: 15mm; }
        table { width:100%; border-collapse: collapse; font-size:11px; }
        th, td { border: 1px solid #cbd5e1; padding: 5px 7px; }
        th { background:#0f5132; color:#fff; font-weight:700; }
        .total-row td { font-weight:700; background:#f0fdf4; border-top:2px solid #0f5132; }
      </style></head><body>
      <div style="display:flex;align-items:center;border-bottom:1px solid #000;padding-bottom:10px;margin-bottom:14px;">
        <div class="logo-wrapper">${logoHtml}</div>
        <div style="flex:1;text-align:center;">
          <h2 style="margin:0;">${cName}</h2>
          <p style="margin:2px 0;font-size:11px;">${cAddress}</p>
          ${cGstin ? `<p style="margin:2px 0;font-size:11px;font-weight:700;">${cGstin}</p>` : ""}
        </div>
      </div>
      <h3 style="text-align:right;border-bottom:1px solid #000;margin-bottom:10px;">Bills Receivable Statement (${statusFilter.toUpperCase()})</h3>
      <table>
        <thead><tr>
          <th>Bill No.</th><th>Bill Date</th><th>Days O/S</th><th>Aging</th>
          <th style="text-align:right;">Taxable Amt (₹)</th>
          <th style="text-align:right;">GST Amt (₹)</th>
          <th style="text-align:right;">TDS Amt (₹)</th>
          <th style="text-align:right;">Net Amount (₹)</th>
        </tr></thead>
        <tbody>
          ${tableRows}
          <tr class="total-row">
            <td colspan="7" style="text-align:right;">GRAND TOTAL OUTSTANDING</td>
            <td style="text-align:right;">₹${formatAmount(grandTotal)}</td>
          </tr>
        </tbody>
      </table>
      <p style="margin-top:20px;font-size:10px;color:#777;">Generated on: ${new Date().toLocaleString("en-IN")} | OrbX Nexus ERP</p>
      ${PRINT_TRIGGER_SCRIPT}
    </body></html>`);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader
          title="Bills Receivable"
          subtitle="Outstanding & Received labour bill amounts with Taxable, GST & TDS breakdown"
          breadcrumbs={[{ label: "Billing" }, { label: "Bills Receivable" }]}
        />

        {/* Filters */}
        <FilterRow>
          <TextField
            label="From Date"
            type="date"
            size="small"
            value={fromDate}
            onChange={(e) => setFromDate(e.target.value)}
            slotProps={{ inputLabel: { shrink: true } }}
            sx={{ minWidth: 150 }}
          />
          <TextField
            label="To Date"
            type="date"
            size="small"
            value={toDate}
            onChange={(e) => setToDate(e.target.value)}
            slotProps={{ inputLabel: { shrink: true } }}
            sx={{ minWidth: 150 }}
          />
          <Autocomplete
            size="small"
            options={ledgers}
            getOptionLabel={(o: any) => o.name}
            value={ledgers.find((l: any) => l.id === selectedLedgerId) || null}
            onChange={(_, val) => setSelectedLedgerId(val ? val.id : "")}
            renderInput={(params) => <TextField {...params} label="Filter by Contractor" sx={{ minWidth: 230 }} />}
          />
          <Box sx={{ display: "flex", gap: 0.5, bgcolor: "rgba(0,0,0,0.04)", p: 0.5, borderRadius: 1.5, border: "1px solid rgba(0,0,0,0.08)" }}>
            <Button
              size="small"
              variant={statusFilter === "pending" ? "contained" : "text"}
              color="error"
              onClick={() => setStatusFilter("pending")}
              sx={{ textTransform: "none", fontWeight: 700, fontSize: "0.78rem", py: 0.5, px: 1.5, borderRadius: 1 }}
            >
              Pending to Receive
            </Button>
            <Button
              size="small"
              variant={statusFilter === "received" ? "contained" : "text"}
              color="success"
              onClick={() => setStatusFilter("received")}
              sx={{ textTransform: "none", fontWeight: 700, fontSize: "0.78rem", py: 0.5, px: 1.5, borderRadius: 1 }}
            >
              Already Received
            </Button>
            <Button
              size="small"
              variant={statusFilter === "all" ? "contained" : "text"}
              color="primary"
              onClick={() => setStatusFilter("all")}
              sx={{ textTransform: "none", fontWeight: 700, fontSize: "0.78rem", py: 0.5, px: 1.5, borderRadius: 1 }}
            >
              All
            </Button>
          </Box>
          <Button variant="outlined" size="small" onClick={() => { setFromDate(firstOfMonth); setToDate(today); setSelectedLedgerId(""); setStatusFilter("pending"); refetch(); }}>Clear</Button>
          {rawData.length > 0 && (
            <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print Statement</Button>
          )}
        </FilterRow>

        {/* Summary pills */}
        {rawData.length > 0 && (
          <Box sx={{ display: "flex", gap: 1.5, flexWrap: "wrap", mb: 2 }}>
            <StatPill label="Contractors" value={totalContractors} color="#1565c0" />
            <StatPill label="Bills" value={totalBills} color="#0288d1" />
            <StatPill label="Total Amount" value={`₹${formatAmount(grandTotal)}`} color="#c62828" />
            {Object.entries(agingTotals).filter(([, v]) => v > 0).map(([bucket, amt]) => (
              <StatPill key={bucket} label={bucket} value={`₹${formatAmount(amt)}`} color={AGING_COLORS[bucket]} />
            ))}
          </Box>
        )}
      </Box>

      {/* Table — grouped by contractor */}
      {isLoading && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">Loading receivables…</Typography>
        </Paper>
      )}
      {!isLoading && rawData.length === 0 && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No bills found for the selected filters.</Typography>
        </Paper>
      )}
      {!isLoading && grouped.length > 0 && grouped.map((grp) => (
        <Paper key={grp.ledger_id} variant="outlined" sx={{ mb: 2, overflow: "hidden" }}>
          {/* Supplier header row */}
          <Box sx={{
            display: "flex", alignItems: "center", justifyContent: "space-between",
            px: 2, py: 1,
            bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#e8f5e9",
            borderBottom: "1px solid",
            borderColor: "divider",
          }}>
            <Typography sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132", fontSize: "0.9rem" }}>
              {grp.ledger_name}
            </Typography>
            <Box sx={{ display: "flex", gap: 2, alignItems: "center" }}>
              <Typography sx={{ fontSize: "0.78rem", color: "text.secondary" }}>
                {grp.bills.length} bill{grp.bills.length !== 1 ? "s" : ""}
              </Typography>
              <Typography sx={{ fontWeight: 700, color: "error.main", fontSize: "0.9rem" }}>
                ₹{formatAmount(grp.total)}
              </Typography>
            </Box>
          </Box>
          {/* Bills table */}
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Bill No.</TableCell>
                <TableCell sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Bill Date</TableCell>
                <TableCell sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Days O/S</TableCell>
                <TableCell sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Aging</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Taxable Amt ({RUPEE})</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>GST ({RUPEE})</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>TDS (1%) ({RUPEE})</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px" }}>Net Total ({RUPEE})</TableCell>
                <TableCell align="center" sx={{ fontWeight: 700, fontSize: "0.72rem", textTransform: "uppercase", p: "5px 10px", width: 140 }}>Action / Status</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {grp.bills.map((bill: any) => {
                const bucket: string = bill.aging_bucket;
                const bucketColor = AGING_COLORS[bucket] || "#333";
                const taxable = Number(bill.taxable_amount || bill.amount || bill.total_amount || 0);
                const gst = Number(bill.gst_amount || 0);
                const tds = Number(bill.tds_amount || (taxable * 0.01));
                const tot = Number(bill.total_amount || bill.net_amount || 0);

                return (
                  <TableRow key={bill.id} hover>
                    <TableCell sx={{ fontSize: "0.8rem", fontWeight: 600, color: "text.primary", p: "5px 10px" }}>{bill.bill_no}</TableCell>
                    <TableCell sx={{ fontSize: "0.8rem", p: "5px 10px", whiteSpace: "nowrap" }}>
                      {bill.bill_date ? new Date(bill.bill_date).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }) : "-"}
                    </TableCell>
                    <TableCell sx={{ fontSize: "0.8rem", p: "5px 10px" }}>{bill.days_outstanding} days</TableCell>
                    <TableCell sx={{ p: "5px 10px" }}>
                      <Box sx={{
                        display: "inline-block", px: 1, py: 0.25, borderRadius: 1,
                        bgcolor: `${bucketColor}18`, border: `1px solid ${bucketColor}55`,
                        color: bucketColor, fontSize: "0.72rem", fontWeight: 700,
                      }}>
                        {bucket}
                      </Box>
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: "0.8rem", fontWeight: 600, p: "5px 10px", color: "text.primary" }}>
                      ₹{formatAmount(taxable)}
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: "0.8rem", fontWeight: 600, p: "5px 10px", color: "primary.main" }}>
                      ₹{formatAmount(gst)}
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: "0.8rem", fontWeight: 600, p: "5px 10px", color: "error.main" }}>
                      ₹{formatAmount(tds)}
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: "0.8rem", fontWeight: 800, p: "5px 10px", color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                      ₹{formatAmount(tot)}
                    </TableCell>
                    <TableCell align="center" sx={{ p: "5px 10px" }}>
                      <Box sx={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 0.5 }}>
                        <Box>
                          {bill.payment_status === "PAID" || (bill.is_paid && bill.payment_status !== "PARTIAL") ? (
                            <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 0.5 }}>
                              <Chip
                                label="Already Received"
                                color="success"
                                size="small"
                                sx={{ fontWeight: 700, fontSize: 10, height: 22 }}
                              />
                              {bill.payment_date && (
                                <Typography variant="caption" sx={{ fontSize: 9, color: "text.secondary" }}>
                                  {bill.payment_date}
                                </Typography>
                              )}
                              <Button
                                size="small"
                                variant="outlined"
                                color="warning"
                                onClick={() => setActivePaymentBill(bill)}
                                sx={{ textTransform: "none", fontSize: 10, py: 0.1, px: 0.8, borderRadius: 1 }}
                              >
                                Reset / Edit Payment
                              </Button>
                            </Box>
                          ) : (
                            <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 0.5 }}>
                              {bill.payment_status === "PARTIAL" && (
                                <Chip
                                  label={`GST/Part Pending: ₹${formatAmount(bill.pending_amount)}`}
                                  color="warning"
                                  size="small"
                                  sx={{ fontWeight: 700, fontSize: 9, height: 20 }}
                                />
                              )}
                              <Button
                                size="small"
                                variant="contained"
                                color={bill.payment_status === "PARTIAL" ? "warning" : "success"}
                                onClick={() => setActivePaymentBill(bill)}
                                sx={{ textTransform: "none", fontSize: 11, py: 0.25, px: 1.2, borderRadius: 1.5 }}
                              >
                                Record Payment
                              </Button>
                            </Box>
                          )}
                        </Box>
                      </Box>
                    </TableCell>
                  </TableRow>
                );
              })}
              {/* Subtotal row */}
              <TableRow sx={{ bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "#f0fdf4" }}>
                <TableCell colSpan={4} sx={{ fontWeight: 700, fontSize: "0.8rem", p: "5px 10px", borderTop: "1.5px solid", borderColor: "divider", color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132", textAlign: "right" }}>
                  Subtotal — {grp.ledger_name}
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.8rem", p: "5px 10px", borderTop: "1.5px solid", borderColor: "divider", color: "text.primary" }}>
                  ₹{formatAmount(grp.totalTaxable)}
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.8rem", p: "5px 10px", borderTop: "1.5px solid", borderColor: "divider", color: "primary.main" }}>
                  ₹{formatAmount(grp.totalGst)}
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, fontSize: "0.8rem", p: "5px 10px", borderTop: "1.5px solid", borderColor: "divider", color: "error.main" }}>
                  ₹{formatAmount(grp.totalTds)}
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 800, fontSize: "0.85rem", p: "5px 10px", borderTop: "1.5px solid", borderColor: "divider", color: "error.main" }}>
                  ₹{formatAmount(grp.total)}
                </TableCell>
                <TableCell />
              </TableRow>
            </TableBody>
          </Table>
        </Paper>
      ))}

      {/* Grand total footer */}
      {!isLoading && rawData.length > 0 && (
        <Paper variant="outlined" sx={{
          p: 2,
          bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(245, 158, 11, 0.12)" : "#fef3c7",
          borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(245, 158, 11, 0.4)" : "#f59e0b"
        }}>
          <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <Typography sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "#fbbf24" : "#92400e" }}>Grand Total Outstanding</Typography>
            <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "#fbbf24" : "#92400e" }}>₹{formatAmount(grandTotal)}</Typography>
          </Box>
        </Paper>
      )}

      {/* Record Payment Dialog */}
      <RecordBillPaymentDialog
        open={!!activePaymentBill}
        onClose={() => setActivePaymentBill(null)}
        bill={activePaymentBill}
        activeFY={activeFY}
        onSuccess={() => qc.invalidateQueries({ queryKey: ["receivables"] })}
      />
    </Box>
  );
}

// ── Stock In Hand ──

export function StockInHandReport() {
  const { activeFY } = useAuthStore();
  const [asOfDate, setAsOfDate] = useState(today);
  const [viewType, setViewType] = useState<"supplier" | "overall">("supplier");
  const [selectedLedgerId, setSelectedLedgerId] = useState<string>("");
  const [enabled, setEnabled] = useState(true);

  // Fetch ledgers for supplier dropdown
  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  // Fetch stock data
  const { data = [], isLoading } = useQuery({
    queryKey: ["report-stock-hand", activeFY, asOfDate, selectedLedgerId, enabled],
    queryFn: async () => {
      let url = `/reports/stock-in-hand?fy=${activeFY}&as_of_date=${asOfDate}`;
      if (selectedLedgerId) {
        url += `&ledger_id=${selectedLedgerId}`;
      }
      return (await api.get(url)).data;
    },
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  // Summary stats
  const totalQty = data.reduce((s: number, r: any) => s + Number(r.balance_qty || 0), 0);
  const totalWeight = data.reduce((s: number, r: any) => s + Number(r.balance_weight || 0), 0);
  const uniqueSuppliers = useMemo(() => {
    const set = new Set<string>();
    data.forEach((r: any) => { if (r.supplier_name) set.add(r.supplier_name); });
    return Array.from(set);
  }, [data]);

  // Group data by Supplier
  const supplierGroups = useMemo(() => {
    const map: { [supplierName: string]: any[] } = {};
    data.forEach((r: any) => {
      const sName = r.supplier_name || "Unknown Supplier";
      if (!map[sName]) map[sName] = [];
      map[sName].push(r);
    });
    return map;
  }, [data]);

  const handlePrintStock = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cAddress2 = "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = new Date(asOfDate).toLocaleDateString("en-IN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric"
    }).replace(/\//g, "-");

    let tablesHtml = "";

    if (viewType === "supplier") {
      Object.keys(supplierGroups).forEach((sName) => {
        const sItems = supplierGroups[sName];
        const sTotalQty = sItems.reduce((sum, item) => sum + Number(item.balance_qty || 0), 0);
        const sTotalWeight = sItems.reduce((sum, item) => sum + Number(item.balance_weight || 0), 0);

        const inGroups: { [inward_no: string]: any[] } = {};
        sItems.forEach((r: any) => {
          if (!inGroups[r.inward_no]) inGroups[r.inward_no] = [];
          inGroups[r.inward_no].push(r);
        });

        let rowsHtml = "";
        Object.keys(inGroups).forEach((inwardNo) => {
          const groupItems = inGroups[inwardNo];
          const rowSpan = groupItems.length + 1;
          const groupQty = groupItems.reduce((sum, item) => sum + Number(item.balance_qty || 0), 0);
          const groupWeight = groupItems.reduce((sum, item) => sum + Number(item.balance_weight || 0), 0);

          groupItems.forEach((r, idx) => {
            rowsHtml += `<tr>
              ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; font-weight: 600; white-space: nowrap;">${r.inward_no}</td>` : ""}
              ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; white-space: nowrap;">${r.ref_no || "-"}</td>` : ""}
              ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; white-space: nowrap;">${r.inward_date}</td>` : ""}
              <td>${r.product}</td>
              <td style="text-align: right; white-space: nowrap; width: 65px;">${formatQty(r.balance_qty)}</td>
              <td style="text-align: right; white-space: nowrap; width: 90px;">${formatWeight(r.balance_weight)}</td>
              <td></td>
            </tr>`;
          });

          rowsHtml += `<tr style="font-weight: 700; background-color: #f8fafc;">
            <td style="font-weight: 700; text-align: right; text-transform: uppercase;">Inward Sub Total</td>
            <td style="text-align: right; font-weight: 700; white-space: nowrap; width: 65px;">${formatQty(groupQty)}</td>
            <td style="text-align: right; font-weight: 700; white-space: nowrap; width: 90px;">${formatWeight(groupWeight)}</td>
            <td></td>
          </tr>`;
        });

        tablesHtml += `
          <div style="margin-top: 15px; margin-bottom: 20px;">
            <div style="background-color: #0f5132; color: #fff; padding: 6px 12px; font-weight: 700; font-size: 13px; border-radius: 4px 4px 0 0;">
              SUPPLIER: ${sName.toUpperCase()}
            </div>
            <table class="items-table" style="width: 100%; border-top: none;">
              <thead>
                <tr>
                  <th style="width: 95px; text-align: center;">Inward No</th>
                  <th style="width: 105px; text-align: center;">Reference No</th>
                  <th style="width: 85px; text-align: center;">Date</th>
                  <th style="text-align: left;">Product Name</th>
                  <th style="width: 65px; text-align: right;">Quantity</th>
                  <th style="width: 90px; text-align: right;">Weight</th>
                  <th style="width: 80px; text-align: left;">Remarks</th>
                </tr>
              </thead>
              <tbody>
                ${rowsHtml}
                <tr class="totals-row">
                  <td colspan="4" style="text-align: right; text-transform: uppercase; font-weight: 700;">${sName} Total</td>
                  <td style="text-align: right; font-weight: 700;">${formatQty(sTotalQty)}</td>
                  <td style="text-align: right; font-weight: 700;">${formatWeight(sTotalWeight)} kgs</td>
                  <td></td>
                </tr>
              </tbody>
            </table>
          </div>
        `;
      });
    } else {
      const inGroups: { [inward_no: string]: any[] } = {};
      data.forEach((r: any) => {
        if (!inGroups[r.inward_no]) inGroups[r.inward_no] = [];
        inGroups[r.inward_no].push(r);
      });

      let rowsHtml = "";
      Object.keys(inGroups).forEach((inwardNo) => {
        const groupItems = inGroups[inwardNo];
        const rowSpan = groupItems.length + 1;
        const groupQty = groupItems.reduce((sum, item) => sum + Number(item.balance_qty || 0), 0);
        const groupWeight = groupItems.reduce((sum, item) => sum + Number(item.balance_weight || 0), 0);

        groupItems.forEach((r, idx) => {
          rowsHtml += `<tr>
            <td style="font-weight: 600;">${r.supplier_name || "-"}</td>
            ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; font-weight: 600; white-space: nowrap;">${r.inward_no}</td>` : ""}
            ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; white-space: nowrap;">${r.ref_no || "-"}</td>` : ""}
            ${idx === 0 ? `<td rowspan="${rowSpan}" style="vertical-align: top; text-align: center; white-space: nowrap;">${r.inward_date}</td>` : ""}
            <td>${r.product}</td>
            <td style="text-align: right; white-space: nowrap; width: 65px;">${formatQty(r.balance_qty)}</td>
            <td style="text-align: right; white-space: nowrap; width: 90px;">${formatWeight(r.balance_weight)}</td>
            <td></td>
          </tr>`;
        });

        rowsHtml += `<tr style="font-weight: 700; background-color: #f8fafc;">
          <td colspan="4" style="font-weight: 700; text-align: right; text-transform: uppercase;">Sub Total</td>
          <td style="text-align: right; font-weight: 700; white-space: nowrap; width: 65px;">${formatQty(groupQty)}</td>
          <td style="text-align: right; font-weight: 700; white-space: nowrap; width: 90px;">${formatWeight(groupWeight)}</td>
          <td></td>
        </tr>`;
      });

      tablesHtml = `
        <table class="items-table" style="width: 100%; margin-top: 15px;">
          <thead>
            <tr>
              <th style="text-align: left;">Supplier</th>
              <th style="width: 95px; text-align: center;">Inward No</th>
              <th style="width: 105px; text-align: center;">Reference No</th>
              <th style="width: 85px; text-align: center;">Date</th>
              <th style="text-align: left;">Product Name</th>
              <th style="width: 65px; text-align: right;">Quantity</th>
              <th style="width: 90px; text-align: right;">Weight</th>
              <th style="width: 80px; text-align: left;">Remarks</th>
            </tr>
          </thead>
          <tbody>
            ${rowsHtml}
            <tr class="totals-row">
              <td colspan="5" style="text-align: right; text-transform: uppercase; font-weight: 700;">Overall Grand Total</td>
              <td style="text-align: right; font-weight: 700;">${formatQty(totalQty)}</td>
              <td style="text-align: right; font-weight: 700;">${formatWeight(totalWeight)} kgs</td>
              <td></td>
            </tr>
          </tbody>
        </table>
      `;
    }

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Stock in Hand Report - ${viewType === "supplier" ? "Supplier-Based" : "Overall"}</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #e2e8f0;
              border-top: 2px solid #0f5132;
              border-bottom: 2px solid #0f5132;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cAddress2 ? `<p>${cAddress2}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">GSTIN: ${cTax}</p>` : ""}
            </div>
          </div>
          
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Stock In Hand Report (${viewType === "supplier" ? "Supplier-Based View" : "Overall Stock View"})</h2>
            <div class="doc-date">As of Date: <strong>${dateStr}</strong></div>
          </div>
          
          ${tablesHtml}
          
          ${viewType === "supplier" ? `
            <div style="margin-top: 20px; padding: 10px; background-color: #f0fdf4; border: 1px solid #198754; border-radius: 4px; display: flex; justify-content: space-between; font-weight: 700;">
              <span>OVERALL GRAND TOTAL (All Suppliers):</span>
              <span>Total Qty: ${formatQty(totalQty)} | Total Weight: ${formatWeight(totalWeight)} kgs</span>
            </div>
          ` : ""}

          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Stock in Hand" breadcrumbs={[{ label: "Reports" }, { label: "Stock in Hand" }]} />
        <FilterRow>
          <TextField
            select
            label="View Mode"
            size="small"
            value={viewType}
            onChange={(e) => setViewType(e.target.value as any)}
            sx={{ minWidth: 200 }}
          >
            <MenuItem value="supplier">🏢 Supplier-Based Stock</MenuItem>
            <MenuItem value="overall">📊 Overall Stock</MenuItem>
          </TextField>

          <Autocomplete
            size="small"
            sx={{ minWidth: 280 }}
            options={ledgers}
            getOptionLabel={(option: any) => typeof option === "string" ? option : option.name || ""}
            value={ledgers.find((l: any) => l.id.toString() === selectedLedgerId) || null}
            onChange={(_, val: any) => setSelectedLedgerId(val ? val.id.toString() : "")}
            isOptionEqualToValue={(option: any, val: any) => option.id === val.id}
            noOptionsText="No matching suppliers"
            renderInput={(params) => (
              <TextField
                {...params}
                label="Supplier Filter (Type to Search)"
                placeholder="All Suppliers (Overall)"
              />
            )}
          />

          <TextField
            label="As of Date"
            type="date"
            size="small"
            value={asOfDate}
            onChange={(e) => setAsOfDate(e.target.value)}
            slotProps={{ inputLabel: { shrink: true } }}
            sx={{ minWidth: 160 }}
          />

          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>
            Show Report
          </Button>

          {data.length > 0 && (
            <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrintStock}>
              Print
            </Button>
          )}
        </FilterRow>
      </Box>

      {data.length > 0 && (
        <Box sx={{ mt: 2, display: "flex", flexDirection: "column", gap: 3 }}>
          {viewType === "supplier" ? (
            Object.keys(supplierGroups).map((sName) => {
              const sItems = supplierGroups[sName];
              const sTotalQty = sItems.reduce((sum, item) => sum + Number(item.balance_qty || 0), 0);
              const sTotalWeight = sItems.reduce((sum, item) => sum + Number(item.balance_weight || 0), 0);

              const inGroups: { [inward_no: string]: any[] } = {};
              sItems.forEach((r: any) => {
                if (!inGroups[r.inward_no]) inGroups[r.inward_no] = [];
                inGroups[r.inward_no].push(r);
              });

              const processedRows: any[] = [];
              Object.keys(inGroups).forEach((inwardNo) => {
                const groupItems = inGroups[inwardNo];
                const rowSpan = groupItems.length + 1;
                const groupQty = groupItems.reduce((sum, item) => sum + Number(item.balance_qty || 0), 0);
                const groupWeight = groupItems.reduce((sum, item) => sum + Number(item.balance_weight || 0), 0);

                groupItems.forEach((r, idx) => {
                  processedRows.push([
                    idx === 0 ? { content: r.inward_no, rowSpan } : { hidden: true },
                    idx === 0 ? { content: r.ref_no, rowSpan } : { hidden: true },
                    idx === 0 ? { content: r.inward_date, rowSpan } : { hidden: true },
                    r.product,
                    formatQty(r.balance_qty),
                    formatWeight(r.balance_weight),
                    "",
                  ]);
                });

                processedRows.push([
                  { hidden: true },
                  { hidden: true },
                  { hidden: true },
                  { content: <strong>Inward Sub Total</strong> },
                  { content: <strong>{formatQty(groupQty)}</strong> },
                  { content: <strong>{formatWeight(groupWeight)}</strong> },
                  "",
                ]);
              });

              return (
                <Paper key={sName} variant="outlined" sx={{ overflow: "hidden" }}>
                  <Box sx={{
                    p: 1.5,
                    bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.12)" : "#e8f5e9",
                    borderBottom: "1px solid",
                    borderColor: "divider",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center"
                  }}>
                    <Typography variant="subtitle1" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                      🏢 Supplier: {sName}
                    </Typography>
                    <Typography variant="body2" sx={{ color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132", fontWeight: 700 }}>
                      Supplier Total Qty: {formatQty(sTotalQty)} | Weight: {formatWeight(sTotalWeight)} kgs
                    </Typography>
                  </Box>
                  <PrintTable
                    title={`Stock in Hand - ${sName}`}
                    columns={["Inward No", "Reference No", "Date", "Product Name", "Quantity", "Weight", "Remarks"]}
                    rows={processedRows}
                    totals={["", "SUPPLIER TOTAL", "", "", formatQty(sTotalQty), `${formatWeight(sTotalWeight)} kgs`, ""]}
                  />
                </Paper>
              );
            })
          ) : (
            <Paper variant="outlined" sx={{ overflow: "auto" }}>
              <PrintTable
                title="Overall Stock in Hand"
                columns={["Supplier Name", "Inward No", "Reference No", "Date", "Product Name", "Quantity", "Weight", "Remarks"]}
                rows={data.map((r: any) => [
                  r.supplier_name || "-",
                  r.inward_no,
                  r.ref_no || "-",
                  r.inward_date,
                  r.product,
                  formatQty(r.balance_qty),
                  formatWeight(r.balance_weight),
                  "",
                ])}
                totals={["", "", "", "OVERALL TOTAL", "", formatQty(totalQty), `${formatWeight(totalWeight)} kgs`, ""]}
              />
            </Paper>
          )}

          {/* Grand Total Summary Banner */}
          <Paper variant="outlined" sx={{
            p: 2,
            backgroundColor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4",
            borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.3)" : "#198754",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center"
          }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
              OVERALL GRAND TOTAL (ALL SUPPLIERS):
            </Typography>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
              Total Qty: {formatQty(totalQty)} Pcs | Total Weight: {formatWeight(totalWeight)} kgs
            </Typography>
          </Paper>
        </Box>
      )}

      {data.length === 0 && enabled && !isLoading && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center", mt: 2 }}>
          <Typography color="text.secondary">No stock data found for the selected criteria.</Typography>
        </Paper>
      )}
    </Box>
  );
}


// ── Stock Summary ──
export function StockSummaryReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [enabled, setEnabled] = useState(true);

  const { data = [] } = useQuery<any>({
    queryKey: ["report-stock-summary", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/stock-summary?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalInQty = data.reduce((s: number, r: any) => s + Number(r.inward_qty || 0), 0);
  const totalInWeight = data.reduce((s: number, r: any) => s + Number(r.inward_weight || 0), 0);
  const totalOutQty = data.reduce((s: number, r: any) => s + Number(r.outward_qty || 0), 0);
  const totalOutWeight = data.reduce((s: number, r: any) => s + Number(r.outward_weight || 0), 0);

  const closingQty = totalInQty - totalOutQty;
  const closingWeight = totalInWeight - totalOutWeight;

  const handlePrintSummary = async () => {
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress1 = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cAddress2 = "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = `${new Date(fromDate).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-")} to ${new Date(toDate).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-")}`;

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center;">${r.voucher_no}</td>
        <td style="text-align: center;">${r.tx_date}</td>
        <td style="text-align: center;">${r.ref_no || "-"}</td>
        <td>${r.particulars || "-"}</td>
        <td style="text-align: right;">${Number(r.inward_qty || 0) > 0 ? formatQty(r.inward_qty) : "-"}</td>
        <td style="text-align: right;">${Number(r.inward_weight || 0) > 0 ? formatWeight(r.inward_weight) : "-"}</td>
        <td style="text-align: right;">${Number(r.outward_qty || 0) > 0 ? formatQty(r.outward_qty) : "-"}</td>
        <td style="text-align: right;">${Number(r.outward_weight || 0) > 0 ? formatWeight(r.outward_weight) : "-"}</td>
      </tr>`;
    });

    const logoHtml = getCompanyLogoHtml(undefined, compData);

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Stock Summary Report</title>
          <style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 15mm; }
            table.items-table th, table.items-table td {
              border: 1px solid #cbd5e1;
              padding: 5px 7px;
              white-space: nowrap;
            }
            table.items-table th {
              background-color: #f8fafc;
              border-bottom: 2px solid #94a3b8;
            }
            .totals-row td {
              font-weight: 700;
              background-color: #f8fafc;
              border-top: 2px solid #94a3b8;
              border-bottom: 2px solid #94a3b8;
            }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cAddress2 ? `<p>${cAddress2}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">GSTIN: ${cTax}</p>` : ""}
            </div>
          </div>
          
          <div class="title-section" style="align-items: flex-start; margin-bottom: 20px;">
            <h2>Stock Summary Report</h2>
            <div class="doc-date">Period: <strong>${dateStr}</strong></div>
          </div>
          
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 95px; text-align: center;">Voucher No</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="width: 105px; text-align: center;">Reference No</th>
                <th style="text-align: left;">Particulars (Supplier Name)</th>
                <th style="width: 80px; text-align: right;">Inward Qty</th>
                <th style="width: 90px; text-align: right;">Inward Weight</th>
                <th style="width: 80px; text-align: right;">Outward Qty</th>
                <th style="width: 90px; text-align: right;">Outward Weight</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="4" style="text-align: right; text-transform: uppercase;">Total</td>
                <td style="text-align: right;">${formatQty(totalInQty)}</td>
                <td style="text-align: right;">${formatWeight(totalInWeight)}</td>
                <td style="text-align: right;">${formatQty(totalOutQty)}</td>
                <td style="text-align: right;">${formatWeight(totalOutWeight)}</td>
              </tr>
              <tr class="totals-row">
                <td colspan="4" style="text-align: right; text-transform: uppercase;">Closing Stock</td>
                <td style="text-align: right;">${formatQty(closingQty)}</td>
                <td style="text-align: right;">${formatWeight(closingWeight)} kgs</td>
                <td colspan="2"></td>
              </tr>
            </tbody>
          </table>
          
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  const processedRows = data.map((r: any) => [
    r.voucher_no,
    r.tx_date,
    r.ref_no || "-",
    r.particulars || "-",
    Number(r.inward_qty) > 0 ? formatQty(r.inward_qty) : "-",
    Number(r.inward_weight) > 0 ? formatWeight(r.inward_weight) : "-",
    Number(r.outward_qty) > 0 ? formatQty(r.outward_qty) : "-",
    Number(r.outward_weight) > 0 ? formatWeight(r.outward_weight) : "-",
  ]);

  const totalsRows = [
    ["", "TOTAL", "", "", formatQty(totalInQty), formatWeight(totalInWeight), formatQty(totalOutQty), formatWeight(totalOutWeight)],
    ["", "CLOSING STOCK", "", "", formatQty(closingQty), `${formatWeight(closingWeight)} kgs`, "", ""]
  ];

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Stock Summary" breadcrumbs={[{ label: "Reports" }, { label: "Stock Summary" }]} />
        <FilterRow>
          <TextField label="From" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <TextField label="To" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show Report</Button>
          {data.length > 0 && (
            <>
              <StatPill label="In Qty" value={formatQty(totalInQty)} color="#1976d2" />
              <StatPill label="Out Qty" value={formatQty(totalOutQty)} color="#ed6c02" />
              <StatPill label="Closing Qty" value={formatQty(closingQty)} color="#4caf50" />
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrintSummary}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>

      {data.length > 0 && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title="Stock Summary"
            columns={["Voucher No", "Date", "Reference No", "Particulars (Supplier Name)", "Inward Qty", "Inward Weight", "Outward Qty", "Outward Weight"]}
            rows={processedRows}
            totals={totalsRows}
          />
        </Paper>
      )}
      {data.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No stock movements found for the selected date range.</Typography>
        </Paper>
      )}
    </Box>
  );
}


/**
 * Helper to construct or validate side-by-side inward and outward groups.
 * Reuses backend `grouped_details` and `grand_totals` when present, or provides
 * a clean client fallback grouping.
 */
function buildInwardOutwardGroupedData(reportRes: any) {
  if (reportRes?.grouped_details && Array.isArray(reportRes.grouped_details) && reportRes.grouped_details.length > 0) {
    return {
      groupedDetails: reportRes.grouped_details,
      grandTotals: reportRes.grand_totals || {
        total_inward_qty: reportRes.summary?.total_inward_qty || 0,
        total_inward_weight: reportRes.summary?.total_inward_weight || 0,
        total_outward_qty: reportRes.summary?.total_outward_qty || 0,
        total_outward_weight: reportRes.summary?.total_outward_weight || 0,
        balance_qty: reportRes.summary?.closing_qty || 0,
        balance_weight: reportRes.summary?.closing_weight || 0,
      }
    };
  }

  // Graceful client fallback in case older cache or response is loaded:
  const movements = reportRes?.movements || [];
  const groupsMap: Record<string, any> = {};

  const inwardMovements = movements.filter((m: any) => m.type === "Inward");
  const outwardMovements = movements.filter((m: any) => m.type === "Outward");

  inwardMovements.forEach((inv: any) => {
    const key = `${inv.ref_no || "-"}||${inv.voucher_no || "-"}||${inv.date}||${inv.party_name || "-"}`;
    if (!groupsMap[key]) {
      groupsMap[key] = {
        ref_no: inv.ref_no || "-",
        voucher_no: inv.voucher_no || "-",
        date: inv.date,
        party_name: inv.party_name || "-",
        products: [],
        subtotal: { inward_qty: 0, inward_weight: 0, outward_qty: 0, outward_weight: 0 }
      };
    }
    const grp = groupsMap[key];
    const qty = Number(inv.inward_qty || 0);
    const wt = Number(inv.inward_weight || 0);
    grp.products.push({
      product_id: inv.product_id,
      product_name: inv.product_name,
      inward_qty: qty,
      inward_weight: wt,
      outward_transactions: []
    });
    grp.subtotal.inward_qty += qty;
    grp.subtotal.inward_weight += wt;
  });

  outwardMovements.forEach((out: any) => {
    let matched = false;
    for (const key of Object.keys(groupsMap)) {
      const grp = groupsMap[key];
      const matchRef = out.ref_no && out.ref_no !== "-" && grp.ref_no && grp.ref_no !== "-" && grp.ref_no.trim().toLowerCase() === out.ref_no.trim().toLowerCase();
      if (matchRef || out.voucher_no === grp.voucher_no) {
        const prod = grp.products.find((p: any) => p.product_name === out.product_name);
        if (prod) {
          const oQty = Number(out.outward_qty || 0);
          const oWt = Number(out.outward_weight || 0);
          prod.outward_transactions.push({
            voucher_no: out.voucher_no,
            date: out.date,
            quantity: oQty,
            weight: oWt
          });
          grp.subtotal.outward_qty += oQty;
          grp.subtotal.outward_weight += oWt;
          matched = true;
          break;
        }
      }
    }
    if (!matched) {
      const fallbackKey = "__direct_outward__";
      if (!groupsMap[fallbackKey]) {
        groupsMap[fallbackKey] = {
          ref_no: "Direct Outward",
          voucher_no: "-",
          date: out.date,
          party_name: out.party_name || "-",
          products: [],
          subtotal: { inward_qty: 0, inward_weight: 0, outward_qty: 0, outward_weight: 0 }
        };
      }
      const grp = groupsMap[fallbackKey];
      const oQty = Number(out.outward_qty || 0);
      const oWt = Number(out.outward_weight || 0);
      grp.products.push({
        product_id: out.product_id,
        product_name: out.product_name,
        inward_qty: 0,
        inward_weight: 0,
        outward_transactions: [{
          voucher_no: out.voucher_no,
          date: out.date,
          quantity: oQty,
          weight: oWt
        }]
      });
      grp.subtotal.outward_qty += oQty;
      grp.subtotal.outward_weight += oWt;
    }
  });

  const groupedDetails = Object.values(groupsMap);
  const grand_in_qty = groupedDetails.reduce((sum, g) => sum + g.subtotal.inward_qty, 0);
  const grand_in_wt = groupedDetails.reduce((sum, g) => sum + g.subtotal.inward_weight, 0);
  const grand_out_qty = groupedDetails.reduce((sum, g) => sum + g.subtotal.outward_qty, 0);
  const grand_out_wt = groupedDetails.reduce((sum, g) => sum + g.subtotal.outward_weight, 0);

  return {
    groupedDetails,
    grandTotals: {
      total_inward_qty: grand_in_qty,
      total_inward_weight: grand_in_wt,
      total_outward_qty: grand_out_qty,
      total_outward_weight: grand_out_wt,
      balance_qty: grand_in_qty - grand_out_qty,
      balance_weight: grand_in_wt - grand_out_wt
    }
  };
}

export function ItemMovementLedgerReport() {
  const { activeFY } = useAuthStore();
  const [fromDate, setFromDate] = useState(firstOfMonth);
  const [toDate, setToDate] = useState(today);
  const [selectedProduct, setSelectedProduct] = useState<any | null>(null);
  const [selectedLedgerId, setSelectedLedgerId] = useState<string>("");
  const [enabled, setEnabled] = useState(true);

  // Fetch products for dropdown
  const { data: products = [] } = useQuery({
    queryKey: ["products"],
    queryFn: async () => (await api.get("/products/")).data,
  });

  // Fetch ledgers for supplier dropdown
  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  // Fetch report data
  const { data: reportRes = { movements: [], summary: {} }, isLoading } = useQuery({
    queryKey: ["report-item-movement", activeFY, fromDate, toDate, selectedProduct?.id, selectedLedgerId, enabled],
    queryFn: async () => {
      let url = `/reports/item-movement-ledger?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`;
      if (selectedProduct?.id) url += `&product_id=${selectedProduct.id}`;
      if (selectedLedgerId) url += `&ledger_id=${selectedLedgerId}`;
      return (await api.get(url)).data;
    },
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const movements = reportRes.movements || [];
  const summary = reportRes.summary || {};
  const [viewMode, setViewMode] = useState<"grouped" | "flat">("grouped");

  const { groupedDetails, grandTotals } = useMemo(
    () => buildInwardOutwardGroupedData(reportRes),
    [reportRes]
  );

  const formatLedgerQty = (val: number | string | null | undefined, showZero = false): string => {
    if (val === null || val === undefined || val === "") return "";
    const n = Number(val);
    if (isNaN(n)) return "";
    if (n === 0 && !showZero) return "";
    return n % 1 === 0 ? String(Math.round(n)) : String(n);
  };

  const formatLedgerWeight = (val: number | string | null | undefined, showZero = false): string => {
    if (val === null || val === undefined || val === "") return "";
    const n = Number(val);
    if (isNaN(n)) return "";
    if (n === 0 && !showZero) return "";
    return n.toFixed(3);
  };


  const handlePrint = async () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const cName = compData?.name || compData?.company_name || "SRI METAL";

    const selectedLedger = ledgers.find((l: any) => String(l.id) === String(selectedLedgerId));
    const partyHeaderTitle = selectedLedger?.name || movements[0]?.party_name || "TEXMO INDUSTRIES PUMP DIVISION";

    const { groupedDetails, grandTotals } = buildInwardOutwardGroupedData(reportRes);

    let rowsHtml = "";
    let totalGeneratedRows = 0;

    groupedDetails.forEach((grp: any) => {
      let isFirstRowOfGroup = true;
      const grpProducts = grp.products || [];

      grpProducts.forEach((prod: any) => {
        const outs = prod.outward_transactions || [];
        const prodInQty = Number(prod.inward_qty || 0);
        const prodInWt = Number(prod.inward_weight || 0);
        let prodOutQtyTotal = 0;
        let prodOutWtTotal = 0;

        if (outs.length === 0) {
          // Primary row (no outward transactions)
          rowsHtml += `<tr>
            <td style="text-align: left;">${isFirstRowOfGroup ? (grp.ref_no || "") : ""}</td>
            <td style="text-align: center;">${isFirstRowOfGroup ? (grp.voucher_no || "") : ""}</td>
            <td style="text-align: center;">${isFirstRowOfGroup ? formatDate(grp.date, "2digit") : ""}</td>
            <td style="text-align: left;">${prod.product_name || ""}</td>
            <td style="text-align: right;">${formatLedgerQty(prodInQty)}</td>
            <td style="text-align: right;">${formatLedgerWeight(prodInWt)}</td>
            <td style="text-align: center;"></td>
            <td style="text-align: center;"></td>
            <td style="text-align: right;"></td>
            <td style="text-align: right;"></td>
          </tr>`;
          totalGeneratedRows++;
          isFirstRowOfGroup = false;

          // Product Total Row
          rowsHtml += `<tr class="product-total-row">
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td style="text-align: right;">${formatLedgerQty(prodInQty)}</td>
            <td style="text-align: right;">${formatLedgerWeight(prodInWt)}</td>
            <td></td>
            <td></td>
            <td style="text-align: right;"></td>
            <td style="text-align: right;"></td>
          </tr>`;
          totalGeneratedRows++;
        } else {
          // Multiple or single outward movements
          outs.forEach((otx: any, outIdx: number) => {
            const oQty = Number(otx.quantity || 0);
            const oWt = Number(otx.weight || 0);
            prodOutQtyTotal += oQty;
            prodOutWtTotal += oWt;

            if (outIdx === 0) {
              rowsHtml += `<tr>
                <td style="text-align: left;">${isFirstRowOfGroup ? (grp.ref_no || "") : ""}</td>
                <td style="text-align: center;">${isFirstRowOfGroup ? (grp.voucher_no || "") : ""}</td>
                <td style="text-align: center;">${isFirstRowOfGroup ? formatDate(grp.date, "2digit") : ""}</td>
                <td style="text-align: left;">${prod.product_name || ""}</td>
                <td style="text-align: right;">${formatLedgerQty(prodInQty)}</td>
                <td style="text-align: right;">${formatLedgerWeight(prodInWt)}</td>
                <td style="text-align: center;">${otx.voucher_no || ""}</td>
                <td style="text-align: center;">${formatDate(otx.date, "2digit")}</td>
                <td style="text-align: right;">${formatLedgerQty(oQty)}</td>
                <td style="text-align: right;">${formatLedgerWeight(oWt)}</td>
              </tr>`;
              totalGeneratedRows++;
              isFirstRowOfGroup = false;
            } else {
              // Continuation row: Inward cells blank
              rowsHtml += `<tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="text-align: center;">${otx.voucher_no || ""}</td>
                <td style="text-align: center;">${formatDate(otx.date, "2digit")}</td>
                <td style="text-align: right;">${formatLedgerQty(oQty)}</td>
                <td style="text-align: right;">${formatLedgerWeight(oWt)}</td>
              </tr>`;
              totalGeneratedRows++;
            }
          });

          // Product Total Row (present for every product in reference report)
          rowsHtml += `<tr class="product-total-row">
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td style="text-align: right;">${formatLedgerQty(prodInQty)}</td>
            <td style="text-align: right;">${formatLedgerWeight(prodInWt)}</td>
            <td></td>
            <td></td>
            <td style="text-align: right;">${formatLedgerQty(prodOutQtyTotal)}</td>
            <td style="text-align: right;">${formatLedgerWeight(prodOutWtTotal)}</td>
          </tr>`;
          totalGeneratedRows++;
        }
      });

      // Group Total Row (Voucher / Reference Total)
      const sub = grp.subtotal || {};
      rowsHtml += `<tr class="group-total-row" style="font-weight: bold;">
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td style="text-align: right; font-weight: bold;">${formatLedgerQty(sub.inward_qty)}</td>
        <td style="text-align: right; font-weight: bold;">${formatLedgerWeight(sub.inward_weight)}</td>
        <td></td>
        <td></td>
        <td style="text-align: right; font-weight: bold;">${formatLedgerQty(sub.outward_qty)}</td>
        <td style="text-align: right; font-weight: bold;">${formatLedgerWeight(sub.outward_weight)}</td>
      </tr>`;
      totalGeneratedRows++;
    });

    const totalPages = Math.max(1, Math.ceil(totalGeneratedRows / 44));

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Inward and Outward Details - ${cName}</title>
          <style>
            * {
              -webkit-print-color-adjust: exact !important;
              print-color-adjust: exact !important;
              color-adjust: exact !important;
              box-sizing: border-box;
            }
            @page {
              size: A4 landscape;
              margin: 8mm 8mm 10mm 8mm;
              @top-right {
                content: "Page " counter(page) " of " counter(pages);
                font-size: 10pt;
                font-family: Arial, sans-serif;
                color: #000;
              }
            }
            html, body {
              margin: 0;
              padding: 0;
              background-color: #fff;
              color: #000;
              font-family: Arial, Helvetica, sans-serif;
              font-size: 8pt;
              line-height: 1.2;
            }
            table.ledger-table {
              width: 100%;
              border-collapse: collapse;
              page-break-inside: auto;
              border: 1px solid #000;
            }
            table.ledger-table thead {
              display: table-header-group;
            }
            table.ledger-table tfoot {
              display: table-row-group;
              page-break-inside: avoid;
            }
            table.ledger-table tr {
              page-break-inside: avoid;
              page-break-after: auto;
            }
            table.ledger-table th,
            table.ledger-table td {
              border: 1px solid #000;
              padding: 2.5px 4px;
              font-size: 8pt;
              color: #000;
              height: 18px;
            }
            .product-total-row td {
              background-color: #fff;
            }
            .group-total-row td {
              background-color: #fff;
              font-weight: bold;
            }
            @media print {
              body { margin: 0; }
            }
          </style>
        </head>
        <body>
          <table class="ledger-table">
            <thead>
              <!-- Top repeating clean company header exactly matching reference photo -->
              <tr>
                <th colspan="10" style="border: none; padding: 0 0 6px 0; background: #fff; color: #000; font-weight: normal; text-align: left;">
                  <div style="width: 100%; margin-bottom: 2px;">
                    <!-- Line 1: SRI METAL (Center) -->
                    <div style="text-align: center; font-size: 13.5pt; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; color: #000;">
                      ${cName}
                    </div>

                    <!-- Line 2: Inward and Outward Details (Center) & Page Number (Right) -->
                    <div style="display: flex; justify-content: space-between; align-items: baseline; margin-top: 1px;">
                      <div style="flex: 1;"></div>
                      <div style="flex: 2; text-align: center; font-size: 11pt; font-weight: normal; color: #000;">
                        Inward and Outward Details
                      </div>
                      <div style="flex: 1; text-align: right; font-size: 10pt; font-weight: normal; color: #000;">
                        Page 1 of ${totalPages}
                      </div>
                    </div>

                    <!-- Line 3: TEXMO INDUSTRIES PUMP DIVISION (Left, aligned with table left border) -->
                    <div style="text-align: left; font-size: 11.5pt; font-weight: bold; text-transform: uppercase; margin-top: 4px; color: #000;">
                      ${partyHeaderTitle}
                    </div>
                  </div>
                </th>
              </tr>

              <!-- Level 1 Header: Inward Details & Outward Details -->
              <tr style="background-color: #fff; font-weight: normal; font-size: 8.5pt;">
                <th colspan="6" style="border: 1px solid #000; text-align: center; padding: 3px; font-weight: normal; color: #000;">Inward Details</th>
                <th colspan="4" style="border: 1px solid #000; text-align: center; padding: 3px; font-weight: normal; color: #000;">Outward Details</th>
              </tr>

              <!-- Level 2 Header: 10 Columns -->
              <tr style="background-color: #fff; font-weight: normal; font-size: 8pt;">
                <th style="border: 1px solid #000; text-align: center; width: 9%; padding: 3px; font-weight: normal; color: #000;">Ref. No.</th>
                <th style="border: 1px solid #000; text-align: center; width: 6%; padding: 3px; font-weight: normal; color: #000;">Vou. No.</th>
                <th style="border: 1px solid #000; text-align: center; width: 8%; padding: 3px; font-weight: normal; color: #000;">Date</th>
                <th style="border: 1px solid #000; text-align: center; width: 25%; padding: 3px; font-weight: normal; color: #000;">Product Name</th>
                <th style="border: 1px solid #000; text-align: center; width: 6.5%; padding: 3px; font-weight: normal; color: #000;">Quantity</th>
                <th style="border: 1px solid #000; text-align: center; width: 8.5%; padding: 3px; font-weight: normal; color: #000;">Weight</th>
                <th style="border: 1px solid #000; text-align: center; width: 8%; padding: 3px; font-weight: normal; color: #000;">Vou. No.</th>
                <th style="border: 1px solid #000; text-align: center; width: 8%; padding: 3px; font-weight: normal; color: #000;">Date</th>
                <th style="border: 1px solid #000; text-align: center; width: 6.5%; padding: 3px; font-weight: normal; color: #000;">Quantity</th>
                <th style="border: 1px solid #000; text-align: center; width: 8.5%; padding: 3px; font-weight: normal; color: #000;">Weight</th>
              </tr>
            </thead>

            <tbody>
              ${rowsHtml}
            </tbody>
          </table>

          <script>
            window.onload = function() {
              window.print();
            };
          </script>
        </body>
      </html>
    `);
    printWindow.document.close();
  };


  const processedRows = movements.map((m: any) => [
    m.date,
    m.type,
    m.voucher_no,
    m.ref_no || "-",
    m.party_name || "-",
    m.product_name || "-",
    Number(m.inward_qty) > 0 ? formatQty(m.inward_qty) : "-",
    Number(m.outward_qty) > 0 ? formatQty(m.outward_qty) : "-",
    formatQty(m.running_balance_qty),
  ]);

  const totalsRows = [
    ["", "TOTALS", "", "", "", "", formatQty(summary.total_inward_qty || 0), formatQty(summary.total_outward_qty || 0), formatQty(summary.closing_qty || 0)]
  ];

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Item In & Out Movement Ledger" breadcrumbs={[{ label: "Reports" }, { label: "Item In & Out Ledger" }]} />
        <FilterRow>
          <Autocomplete
            size="small"
            sx={{ minWidth: 260 }}
            options={products}
            value={selectedProduct}
            onChange={(_, val) => setSelectedProduct(val)}
            getOptionLabel={(p: any) => p.name || ""}
            renderInput={(params) => <TextField {...params} label="Filter by Product (Item)" placeholder="All Products" />}
          />
          <TextField
            select
            size="small"
            label="Supplier"
            value={selectedLedgerId}
            onChange={(e) => setSelectedLedgerId(e.target.value)}
            sx={{ minWidth: 200 }}
          >
            <MenuItem value="">All Suppliers</MenuItem>
            {ledgers.map((l: any) => (
              <MenuItem key={l.id} value={l.id}>{l.name}</MenuItem>
            ))}
          </TextField>
          <TextField label="From" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 150 }} />
          <TextField label="To" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 150 }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show Report</Button>
          {movements.length > 0 && (
            <>
              <StatPill label="Total In" value={formatQty(summary.total_inward_qty)} color="#0f5132" />
              <StatPill label="Total Out" value={formatQty(summary.total_outward_qty)} color="#c53030" />
              <StatPill label="Stock Bal" value={formatQty(summary.closing_qty)} color="#1976d2" />
              <ToggleButtonGroup
                size="small"
                value={viewMode}
                exclusive
                onChange={(_, val) => val && setViewMode(val)}
                sx={{ height: 36, bgcolor: "background.paper" }}
              >
                <ToggleButton value="grouped" sx={{ px: 1.5, py: 0.5, fontSize: "0.75rem", textTransform: "none", fontWeight: 600 }}>
                  Inward & Outward
                </ToggleButton>
                <ToggleButton value="flat" sx={{ px: 1.5, py: 0.5, fontSize: "0.75rem", textTransform: "none" }}>
                  Flat List
                </ToggleButton>
              </ToggleButtonGroup>
              <Button variant="outlined" size="small" startIcon={<Print />} onClick={handlePrint}>Print</Button>
            </>
          )}
        </FilterRow>
      </Box>

      {movements.length > 0 && viewMode === "grouped" && (
        <Paper variant="outlined" sx={{ overflow: "auto", borderRadius: 2 }}>
          <Table size="small" sx={{ minWidth: 1000, borderCollapse: "collapse", "& td, & th": { border: 1, borderColor: "divider", py: 0.6, px: 1, fontSize: "0.82rem" } }}>
            <TableHead>
              {/* Level 1 Header: Inward Details & Outward Details */}
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.06)" : "grey.100" }}>
                <TableCell colSpan={6} align="center" sx={{ fontWeight: 700, fontSize: "0.85rem", borderRight: "2px solid !important", borderColor: "divider" }}>
                  Inward Details
                </TableCell>
                <TableCell colSpan={4} align="center" sx={{ fontWeight: 700, fontSize: "0.85rem" }}>
                  Outward Details
                </TableCell>
              </TableRow>

              {/* Level 2 Header: 10 Columns */}
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.03)" : "grey.50" }}>
                <TableCell align="center" sx={{ fontWeight: 600, width: "9%" }}>Ref. No.</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "6%" }}>Vou. No.</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "8%" }}>Date</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "25%" }}>Product Name</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "6.5%" }}>Quantity</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "8.5%", borderRight: "2px solid !important", borderColor: "divider" }}>Weight</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "8%" }}>Vou. No.</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "8%" }}>Date</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "6.5%" }}>Quantity</TableCell>
                <TableCell align="center" sx={{ fontWeight: 600, width: "8.5%" }}>Weight</TableCell>
              </TableRow>
            </TableHead>

            <TableBody>
              {groupedDetails.map((grp: any, gIdx: number) => {
                let isFirstRowOfGroup = true;
                const grpProducts = grp.products || [];

                return (
                  <React.Fragment key={`grp-${gIdx}-${grp.ref_no}-${grp.voucher_no}`}>
                    {grpProducts.map((prod: any, pIdx: number) => {
                      const outs = prod.outward_transactions || [];
                      const prodInQty = Number(prod.inward_qty || 0);
                      const prodInWt = Number(prod.inward_weight || 0);
                      let prodOutQtyTotal = 0;
                      let prodOutWtTotal = 0;

                      if (outs.length === 0) {
                        const showGroupInfo = isFirstRowOfGroup;
                        isFirstRowOfGroup = false;

                        return (
                          <React.Fragment key={`prod-${pIdx}-${prod.product_id}`}>
                            <TableRow hover>
                              <TableCell align="left">{showGroupInfo ? (grp.ref_no || "") : ""}</TableCell>
                              <TableCell align="center">{showGroupInfo ? (grp.voucher_no || "") : ""}</TableCell>
                              <TableCell align="center">{showGroupInfo ? formatDate(grp.date, "2digit") : ""}</TableCell>
                              <TableCell align="left" sx={{ fontWeight: 500 }}>{prod.product_name || ""}</TableCell>
                              <TableCell align="right">{formatLedgerQty(prodInQty)}</TableCell>
                              <TableCell align="right" sx={{ borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(prodInWt)}</TableCell>
                              <TableCell align="center"></TableCell>
                              <TableCell align="center"></TableCell>
                              <TableCell align="right"></TableCell>
                              <TableCell align="right"></TableCell>
                            </TableRow>

                            {/* Product Total Row */}
                            <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.015)" }}>
                              <TableCell></TableCell>
                              <TableCell></TableCell>
                              <TableCell></TableCell>
                              <TableCell></TableCell>
                              <TableCell align="right" sx={{ fontWeight: 500 }}>{formatLedgerQty(prodInQty)}</TableCell>
                              <TableCell align="right" sx={{ fontWeight: 500, borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(prodInWt)}</TableCell>
                              <TableCell></TableCell>
                              <TableCell></TableCell>
                              <TableCell align="right"></TableCell>
                              <TableCell align="right"></TableCell>
                            </TableRow>
                          </React.Fragment>
                        );
                      }

                      return (
                        <React.Fragment key={`prod-${pIdx}-${prod.product_id}`}>
                          {outs.map((otx: any, outIdx: number) => {
                            const oQty = Number(otx.quantity || 0);
                            const oWt = Number(otx.weight || 0);
                            prodOutQtyTotal += oQty;
                            prodOutWtTotal += oWt;

                            if (outIdx === 0) {
                              const showGroupInfo = isFirstRowOfGroup;
                              isFirstRowOfGroup = false;

                              return (
                                <TableRow key={`out-${outIdx}`} hover>
                                  <TableCell align="left">{showGroupInfo ? (grp.ref_no || "") : ""}</TableCell>
                                  <TableCell align="center">{showGroupInfo ? (grp.voucher_no || "") : ""}</TableCell>
                                  <TableCell align="center">{showGroupInfo ? formatDate(grp.date, "2digit") : ""}</TableCell>
                                  <TableCell align="left" sx={{ fontWeight: 500 }}>{prod.product_name || ""}</TableCell>
                                  <TableCell align="right">{formatLedgerQty(prodInQty)}</TableCell>
                                  <TableCell align="right" sx={{ borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(prodInWt)}</TableCell>
                                  <TableCell align="center">{otx.voucher_no || ""}</TableCell>
                                  <TableCell align="center">{formatDate(otx.date, "2digit")}</TableCell>
                                  <TableCell align="right">{formatLedgerQty(oQty)}</TableCell>
                                  <TableCell align="right">{formatLedgerWeight(oWt)}</TableCell>
                                </TableRow>
                              );
                            }

                            // Continuation row
                            return (
                              <TableRow key={`out-${outIdx}`} hover>
                                <TableCell></TableCell>
                                <TableCell></TableCell>
                                <TableCell></TableCell>
                                <TableCell></TableCell>
                                <TableCell></TableCell>
                                <TableCell sx={{ borderRight: "2px solid !important", borderColor: "divider" }}></TableCell>
                                <TableCell align="center">{otx.voucher_no || ""}</TableCell>
                                <TableCell align="center">{formatDate(otx.date, "2digit")}</TableCell>
                                <TableCell align="right">{formatLedgerQty(oQty)}</TableCell>
                                <TableCell align="right">{formatLedgerWeight(oWt)}</TableCell>
                              </TableRow>
                            );
                          })}

                          {/* Product Total Row */}
                          <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.015)" }}>
                            <TableCell></TableCell>
                            <TableCell></TableCell>
                            <TableCell></TableCell>
                            <TableCell></TableCell>
                            <TableCell align="right" sx={{ fontWeight: 500 }}>{formatLedgerQty(prodInQty)}</TableCell>
                            <TableCell align="right" sx={{ fontWeight: 500, borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(prodInWt)}</TableCell>
                            <TableCell></TableCell>
                            <TableCell></TableCell>
                            <TableCell align="right" sx={{ fontWeight: 500 }}>{formatLedgerQty(prodOutQtyTotal)}</TableCell>
                            <TableCell align="right" sx={{ fontWeight: 500 }}>{formatLedgerWeight(prodOutWtTotal)}</TableCell>
                          </TableRow>
                        </React.Fragment>
                      );
                    })}

                    {/* Group Total Row */}
                    <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.06)" : "grey.100" }}>
                      <TableCell></TableCell>
                      <TableCell></TableCell>
                      <TableCell></TableCell>
                      <TableCell></TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerQty(grp.subtotal?.inward_qty)}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700, borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(grp.subtotal?.inward_weight)}</TableCell>
                      <TableCell></TableCell>
                      <TableCell></TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerQty(grp.subtotal?.outward_qty)}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerWeight(grp.subtotal?.outward_weight)}</TableCell>
                    </TableRow>
                  </React.Fragment>
                );
              })}
            </TableBody>

            <TableFooter>
              {/* Grand Total Row */}
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.1)" : "grey.200", "& td": { borderTop: "2px solid !important", borderColor: "divider" } }}>
                <TableCell colSpan={4} align="right" sx={{ fontWeight: 700, textTransform: "uppercase" }}>Grand Total</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerQty(grandTotals.total_inward_qty, true)}</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, borderRight: "2px solid !important", borderColor: "divider" }}>{formatLedgerWeight(grandTotals.total_inward_weight, true)}</TableCell>
                <TableCell colSpan={2}></TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerQty(grandTotals.total_outward_qty, true)}</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>{formatLedgerWeight(grandTotals.total_outward_weight, true)}</TableCell>
              </TableRow>

              {/* Closing Balance Row */}
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.05)" : "grey.50" }}>
                <TableCell colSpan={4} align="right" sx={{ fontWeight: 700, textTransform: "uppercase" }}>Closing Balance (Inward - Outward)</TableCell>
                <TableCell colSpan={2} align="right" sx={{ fontWeight: 700, borderRight: "2px solid !important", borderColor: "divider", color: "primary.main" }}>
                  Qty: {formatLedgerQty(grandTotals.balance_qty, true)} &nbsp;|&nbsp; Wt: {formatLedgerWeight(grandTotals.balance_weight, true)}
                </TableCell>
                <TableCell colSpan={4}></TableCell>
              </TableRow>
            </TableFooter>
          </Table>
        </Paper>
      )}

      {movements.length > 0 && viewMode === "flat" && (
        <Paper variant="outlined" sx={{ overflow: "auto" }}>
          <PrintTable
            title={`Item Movement Ledger ${selectedProduct ? `- ${selectedProduct.name}` : ""}`}
            columns={["Date", "Type", "Voucher No", "Reference No", "Party / Supplier", "Product Name", "In Qty", "Out Qty", "Stock Bal"]}
            rows={processedRows}
            totals={totalsRows}
          />
        </Paper>
      )}

      {movements.length === 0 && enabled && (
        <Paper variant="outlined" sx={{ p: 3, textAlign: "center" }}>
          <Typography color="text.secondary">No item movements found for the selected filters.</Typography>
        </Paper>
      )}
    </Box>
  );
}
