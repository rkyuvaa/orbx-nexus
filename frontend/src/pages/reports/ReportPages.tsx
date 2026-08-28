import React, { useState, useMemo } from "react";
import { useQuery } from "@tanstack/react-query";
import {
  Box, Button, TextField, Paper, Typography,
  Table, TableHead, TableBody, TableRow, TableCell, TableSortLabel, MenuItem, Autocomplete
} from "@mui/material";
import Print from "@mui/icons-material/Print";
import Search from "@mui/icons-material/Search";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";
import { useAuthStore } from "../../store";
import { COMMON_PRINT_CSS } from "../../utils/printStyles";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";

const ACCENT = "#0f5132";
const BORDER = "#0f5132";
const today = new Date().toISOString().split("T")[0];
const firstOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString().split("T")[0];

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

  const compData = Array.isArray(companyData) ? companyData[0] : companyData;
  const logoBase64 = localStorage.getItem("company_logo");
  
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
    <Box sx={{ display: "inline-flex", alignItems: "center", gap: 0.5, px: 1.5, height: 32, borderRadius: 2, bgcolor: color, color: "#fff", whiteSpace: "nowrap" }}>
      <Typography variant="body2" sx={{ lineHeight: 1, color: "#fff" }}>{label}</Typography>
      <Typography variant="body2" sx={{ fontWeight: 700, lineHeight: 1, color: "#fff" }}>{value}</Typography>
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
              <TableCell key={c} sx={{ fontWeight: 700, fontSize: "0.75rem", bgcolor: "#122a1f",
                color: "#ffffff", textTransform: "uppercase", borderColor: BORDER, p: "5px 8px",
                cursor: "pointer", userSelect: "none" }} onClick={() => handleSort(idx)}>
                <TableSortLabel active={orderBy === idx} direction={orderBy === idx ? order : "asc"}
                  sx={{ "&.MuiTableSortLabel-active": { color: "#ffffff" }, "& .MuiTableSortLabel-icon": { color: "#ffffff !important" } }}>
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
                <TableRow key={idx} sx={{ bgcolor: "#0f5132 !important", "&:hover": { bgcolor: "#0f5132 !important" } }}>
                  {totalsRow.map((t, i) => (
                    <TableCell key={i} sx={{ fontWeight: 700, fontSize: "0.8rem", borderColor: BORDER, color: "#ffffff !important", p: "5px 8px" }}>{t ?? ""}</TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow sx={{ bgcolor: "#0f5132 !important", "&:hover": { bgcolor: "#0f5132 !important" } }}>
                {(totals as any[]).map((t, i) => (
                  <TableCell key={i} sx={{ fontWeight: 700, fontSize: "0.8rem", borderColor: BORDER, color: "#ffffff !important", p: "5px 8px" }}>{t ?? ""}</TableCell>
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
  const [enabled, setEnabled] = useState(false);

  const { data = [] } = useQuery({
    queryKey: ["report-daybook", activeFY, fromDate, toDate, enabled],
    queryFn: async () => (await api.get(`/reports/day-book?fy=${activeFY}&from_date=${fromDate}&to_date=${toDate}`)).data,
    enabled,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const totalAmt = data.reduce((s: number, r: any) => s + Number(r.amount || 0), 0);
  const totalEntries = data.length;

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    let rowsHtml = "";
    data.forEach((r: any) => {
      rowsHtml += `<tr>
        <td style="text-align: center; white-space: nowrap;">${r.voucher_no}</td>
        <td style="text-align: center; white-space: nowrap;">${r.voucher_date}</td>
        <td style="text-align: center;">${r.voucher_type}</td>
        <td>${r.ledger_name}</td>
        <td style="text-align: right;">₹${formatAmount(r.amount)}</td>
        <td>${r.narration || ""}</td>
      </tr>`;
    });

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Day Book</title>
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
            <h2>Day Book</h2>
            <div class="doc-date">Period: <strong>${fromDate} to ${toDate}</strong></div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 100px; text-align: center;">Voucher No.</th>
                <th style="width: 85px; text-align: center;">Date</th>
                <th style="width: 80px; text-align: center;">Type</th>
                <th style="text-align: left;">Ledger</th>
                <th style="width: 90px; text-align: right;">Amount</th>
                <th style="text-align: left;">Narration</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
              <tr class="totals-row">
                <td colspan="4" style="text-align: right; text-transform: uppercase;">Total</td>
                <td style="text-align: right;">₹${formatAmount(totalAmt)}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
          <div class="footer-info" style="margin-top: 30px; border-top: 1px solid #ddd; padding-top: 8px; display: flex; justify-content: space-between; font-size: 10px; color: #777;">
            <span>Generated on: ${new Date().toLocaleString("en-IN")}</span>
            <span>OrbX Nexus Enterprise ERP</span>
          </div>
          <script>window.onload = function() { window.print(); }</script>
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <Box className="no-print">
        <PageHeader title="Day Book" breadcrumbs={[{ label: "Reports" }, { label: "Day Book" }]} />
        <FilterRow>
          <TextField label="From Date" type="date" size="small" value={fromDate} onChange={(e) => setFromDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <TextField label="To Date" type="date" size="small" value={toDate} onChange={(e) => setToDate(e.target.value)} slotProps={{ inputLabel: { shrink: true } }} sx={{ minWidth: 160 }} />
          <Button variant="contained" startIcon={<Search />} onClick={() => setEnabled(true)}>Show Report</Button>
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
            title="Day Book"
            columns={["Voucher No.", "Date", "Type", "Ledger", "Amount", "Narration"]}
            rows={data.map((r: any) => [r.voucher_no, r.voucher_date, r.voucher_type, r.ledger_name, `₹${formatAmount(r.amount)}`, r.narration])}
            totals={["", "", "", "TOTAL", `₹${formatAmount(totalAmt)}`, ""]}
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
  const [enabled, setEnabled] = useState(false);

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

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          <script>window.onload = function() { window.print(); }</script>
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
  const [enabled, setEnabled] = useState(false);

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

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          <script>window.onload = function() { window.print(); }</script>
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
  const [enabled, setEnabled] = useState(false);

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

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          <script>window.onload = function() { window.print(); }</script>
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
  const [enabled, setEnabled] = useState(false);

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

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          <script>window.onload = function() { window.print(); }</script>
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

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          <script>window.onload = function() { window.print(); }</script>
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

  const handlePrintStock = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cAddress2 = "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) showLogo = JSON.parse(savedConfig).showLogo !== false;
    } catch (e) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          
          <script>
            window.onload = function() {
              window.print();
            }
          </script>
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
                  <Box sx={{ p: 1.5, backgroundColor: "#0f5132", color: "#ffffff", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#ffffff !important" }}>
                      🏢 Supplier: {sName}
                    </Typography>
                    <Typography variant="body2" sx={{ color: "#ffffff !important", fontWeight: 700 }}>
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
          <Paper variant="outlined" sx={{ p: 2, backgroundColor: "#f0fdf4", borderColor: "#198754", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#0f5132" }}>
              OVERALL GRAND TOTAL (ALL SUPPLIERS):
            </Typography>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#0f5132" }}>
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
  const [enabled, setEnabled] = useState(false);

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

  const handlePrintSummary = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress1 = compData?.address || "";
    const cAddress2 = "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
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

    const logoBase64 = localStorage.getItem("company_logo");
    let showLogo = true;
    try {
      const savedConfig = localStorage.getItem("orbx_print_config");
      if (savedConfig) {
        showLogo = JSON.parse(savedConfig).showLogo !== false;
      }
    } catch (_) {}
    const logoHtml = (showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

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
          
          <script>
            window.onload = function() {
              window.print();
            }
          </script>
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
