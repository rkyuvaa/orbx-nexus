import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box,
  Chip,
  IconButton,
  Tooltip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  Typography,
  Paper,
  TextField,
  Snackbar,
  Alert,
  CircularProgress,
  Grid,
  Switch,
  FormControlLabel,
  Select,
  MenuItem,
} from "@mui/material";
import Visibility from "@mui/icons-material/Visibility";
import PrintIcon from "@mui/icons-material/Print";
import Payment from "@mui/icons-material/Payment";
import ArrowLeft from "@mui/icons-material/ArrowLeft";
import ArrowRight from "@mui/icons-material/ArrowRight";
import { ColDef } from "../../components/tables/OrbxGrid";
import OrbxGrid from "../../components/tables/OrbxGrid";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";
import { useAuthStore, useCompanyStore } from "../../store";
import { formatAmount, formatWeight } from "../../utils/format";
import { COMMON_PRINT_CSS, getPageSizeCSS, getCompanyLogoHtml, PRINT_TRIGGER_SCRIPT, getGlobalPrintFooterHtml, resolveCompanyDetails } from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";

const todayStr = () => new Date().toISOString().split("T")[0];

// Persist the last-selected supplier for Staff Balance so it loads by default next time
const loadDefaultSupplier = () => {
  try {
    const saved = localStorage.getItem("orbx_staff_balance_default_supplier");
    return saved ? JSON.parse(saved) : null;
  } catch {
    return null;
  }
};

const WEEKDAY_INDEX: Record<string, number> = {
  Sunday: 0, Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6,
};

function shiftDate(date: Date, days: number) {
  const shifted = new Date(date);
  shifted.setDate(shifted.getDate() + days);
  return shifted;
}

function isoDate(date: Date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function formatDisplayDate(dateStr: string) {
  const [y, m, d] = dateStr.split("-");
  return `${d}-${m}-${y}`;
}

function getWeeklyPayPeriod(anchorDate: string, payoutWeekday: number) {
  const [year, month, day] = anchorDate.split("-").map(Number);
  const anchor = new Date(year, month - 1, day);
  const daysSincePayout = (anchor.getDay() - payoutWeekday + 7) % 7;
  const payoutDate = shiftDate(anchor, -daysSincePayout);
  const to = shiftDate(payoutDate, -1);
  const from = shiftDate(payoutDate, -7);
  return { from: isoDate(from), to: isoDate(to), payoutDate: isoDate(payoutDate) };
}

async function handlePrintStaffStatement(
  staffData: any,
  transactionsParam: any[] | null,
  companyData: any,
  activeFY: string,
  fromDate: string = "",
  toDate: string = ""
) {
  let transactions = transactionsParam || [];

  if ((!transactions || transactions.length === 0) && staffData?.ledger_id) {
    try {
      const res = await api.get(`/payroll/transactions?ledger_id=${staffData.ledger_id}&fy=${activeFY}`);
      transactions = res.data || [];
    } catch (e) {
      console.error("Failed to fetch staff transactions for print", e);
    }
  }

  const printWindow = window.open("", "_blank");
  if (!printWindow) return;

  const savedConfig = localStorage.getItem("orbx_print_config");
  let printConfig = {
    showLogo: true,
    billPaperSize: "A4",
  };
  if (savedConfig) {
    try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch (e) {}
  }

  const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
  const logoHtml = getCompanyLogoHtml(printConfig.showLogo, compData);
  const cName = compData?.name || "SRI METAL";
  const cAddress1 = compData?.address || "";
  const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
  const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
  const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
  const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

  const staffName = staffData?.staff_name || staffData?.name || "Staff Member";
  const staffCode = staffData?.staff_code ? ` (${staffData.staff_code})` : "";
  const designation = staffData?.designation || staffData?.department || "Staff";

  // Calculate totals
  let totalDebits = 0;   // Advances paid to staff
  let totalCredits = 0;  // Direct repayments + salary earned
  if (transactions && transactions.length > 0) {
    transactions.forEach((tx: any) => {
      const amt = Math.abs(tx.amount || 0);
      if (tx.dr_cr === "Dr") {
        totalDebits += amt;
      } else {
        totalCredits += amt;
      }
    });
  } else {
    totalDebits = Math.abs(staffData?.advance_paid || 0);
    totalCredits = Math.abs(staffData?.advance_received || 0) + Math.abs(staffData?.net_salary || 0);
  }

  const finalTx = transactions && transactions.length > 0 ? transactions[transactions.length - 1] : null;
  const netBal = finalTx ? (finalTx.running_balance ?? 0) : (totalCredits - totalDebits);
  const isPayable = netBal >= 0;
  const absPayable = Math.abs(netBal);
  const amountInWordsStr = absPayable > 0 ? toWords(absPayable) : "";

  const outstandingAdv = staffData?.advance_balance ?? Math.max(0, (staffData?.advance_paid || 0) - (staffData?.advance_received || 0) - (staffData?.salary_deductions || 0));

  let txRowsHtml = "";
  if (transactions && transactions.length > 0) {
    transactions.forEach((tx: any, idx: number) => {
      const isDr = tx.dr_cr === "Dr";
      const amt = Math.abs(tx.amount || 0);
      const runBal = Math.abs(tx.running_balance ?? 0);
      const isBalCr = (tx.running_balance ?? 0) >= 0;
      txRowsHtml += `
        <tr>
          <td style="text-align: center;">${idx + 1}</td>
          <td style="text-align: center;">${tx.date || "-"}</td>
          <td style="font-weight: 600;">${tx.doc_no || "-"}</td>
          <td>${tx.category || "-"}</td>
          <td>${tx.narration || "-"}</td>
          <td style="text-align: right; color: ${isDr ? '#dc3545' : '#6c757d'};">${isDr ? `₹${formatAmount(amt)}` : '—'}</td>
          <td style="text-align: right; color: ${!isDr ? '#198754' : '#6c757d'};">${!isDr ? `₹${formatAmount(amt)}` : '—'}</td>
          <td style="text-align: right; font-weight: 700; color: ${isBalCr ? '#198754' : '#dc3545'};">₹${formatAmount(runBal)} ${isBalCr ? 'Cr' : 'Dr'}</td>
        </tr>
      `;
    });
  } else {
    txRowsHtml = `
      <tr>
        <td colspan="8" style="text-align: center; color: #6c757d; padding: 12px;">No detailed transactions found for this period.</td>
      </tr>
    `;
  }

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Staff Advance & Balance Statement - ${staffName}</title>
        <style>
          @page { size: ${getPageSizeCSS(printConfig.billPaperSize as any)}; margin: 15mm; }
          ${COMMON_PRINT_CSS}
          .summary-card-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
          }
          .summary-card-table td {
            padding: 8px 12px;
            border: 1px solid #cbd5e1;
            font-size: 13px;
          }
          .summary-card-table .label-col {
            font-weight: 600;
            color: #334155;
            background-color: #f8fafc;
            width: 65%;
          }
          .summary-card-table .val-col {
            font-weight: 700;
            text-align: right;
            width: 35%;
          }
        </style>
      </head>
      <body>
        <!-- Header -->
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

        <div class="title-section">
          <h2>STAFF ADVANCE & BALANCE STATEMENT</h2>
          <div class="doc-no">Staff Member: <strong>${staffName}${staffCode}</strong> [${designation}]</div>
          <div class="doc-date">Statement Date: ${new Date().toLocaleDateString("en-IN")}</div>
          ${fromDate && toDate ? `<div class="doc-date">Weekly Pay Period: ${fromDate} to ${toDate}</div>` : ""}
        </div>

        <!-- FIRST HALF: Transaction Summary Table -->
        <div style="margin-bottom: 20px;">
          <h3 style="margin: 0 0 8px 0; font-size: 13px; color: #0f5132; text-transform: uppercase; font-weight: 700;">
            1. Transaction Details (Advances, Receipts & Salaries)
          </h3>
          <table class="items-table">
            <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
              <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
                <th style="width: 35px; text-align: center;">S.N</th>
                <th style="width: 85px; text-align: center;">DATE</th>
                <th style="width: 110px;">DOC NO</th>
                <th style="width: 130px;">CATEGORY</th>
                <th>NARRATION / REMARKS</th>
                <th style="width: 105px; text-align: right;">DEBIT (DR)</th>
                <th style="width: 105px; text-align: right;">CREDIT (CR)</th>
                <th style="width: 120px; text-align: right;">CLOSING BAL</th>
              </tr>
            </thead>
            <tbody>
              ${txRowsHtml}
            </tbody>
          </table>
        </div>

        <!-- SECOND HALF: Settlement & Balance Breakdown -->
        <div style="margin-top: 25px; page-break-inside: avoid;">
          <h3 style="margin: 0 0 8px 0; font-size: 13px; color: #0f5132; text-transform: uppercase; font-weight: 700;">
            2. Advance Settlement & Balance Summary
          </h3>
          <table class="summary-card-table">
            <tbody>
              <tr>
                <td class="label-col">Total Advances Paid to Staff (Debit):</td>
                <td class="val-col" style="color: #b02a37;">₹${formatAmount(staffData?.advance_paid || 0)}</td>
              </tr>
              <tr>
                <td class="label-col">Less: Direct Advance Receipts Recovered (Credit):</td>
                <td class="val-col" style="color: #0a7a50;">- ₹${formatAmount(staffData?.advance_received || 0)}</td>
              </tr>
              <tr>
                <td class="label-col">Less: Advance Deducted in Salary Vouchers (Deductions):</td>
                <td class="val-col" style="color: #0a7a50;">- ₹${formatAmount(staffData?.salary_deductions || 0)}</td>
              </tr>
              <tr style="background-color: ${outstandingAdv > 0 ? '#fffbeb' : '#f0fdf4'} !important; -webkit-print-color-adjust: exact !important;">
                <td class="label-col" style="font-weight: 700; color: ${outstandingAdv > 0 ? '#b45309' : '#0f5132'};">
                  NET OUTSTANDING ADVANCE BALANCE:
                </td>
                <td class="val-col" style="font-weight: 800; color: ${outstandingAdv > 0 ? '#b45309' : '#0a7a50'};">
                  ₹${formatAmount(outstandingAdv)} ${outstandingAdv > 0 ? '(Staff Debt)' : '(Fully Cleared)'}
                </td>
              </tr>
              <tr style="background-color: #f8fafc !important;">
                <td class="label-col">Total Net Salary Vouchers (Earned):</td>
                <td class="val-col" style="color: #0a7a50;">₹${formatAmount(staffData?.net_salary || 0)}</td>
              </tr>
              <tr style="background-color: #f0fdf4 !important; -webkit-print-color-adjust: exact !important;">
                <td class="label-col" style="font-size: 14px; font-weight: 700; color: #0f5132;">
                  NET ${isPayable ? 'SALARY PAYABLE TO STAFF' : 'ADVANCE RECEIVABLE FROM STAFF'}:
                </td>
                <td class="val-col" style="font-size: 16px; font-weight: 800; color: ${isPayable ? '#0a7a50' : '#b02a37'};">
                  ₹${formatAmount(absPayable)} ${isPayable ? '(Cr — Company Owes Staff)' : '(Dr — Staff Owes Company)'}
                </td>
              </tr>
            </tbody>
          </table>

          ${absPayable > 0 && amountInWordsStr ? `
            <div style="margin-top: 12px; padding: 10px 14px; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 12px;">
              <strong>NET AMOUNT IN WORDS:</strong> ${amountInWordsStr.replace(/^Rupees:\s*/i, "").replace(/\s*Rupees Only$/i, "").trim().toUpperCase()} RUPEES ONLY
            </div>
          ` : ""}
        </div>

        <!-- Signatures Footer -->
        <div class="signatures-container" style="margin-top: 45px; page-break-inside: avoid;">
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Issued By / Prepared By<br/><span style="font-size: 8.5px; color: #64748b;">(Accounts / Cashier)</span></div>
          </div>
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Received By / Staff Signature<br/><span style="font-size: 8.5px; color: #64748b;">(${staffName})</span></div>
          </div>
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Authorised Signatory<br/><span style="font-size: 8.5px; color: #64748b;">For ${cName}</span></div>
          </div>
        </div>
        ${getGlobalPrintFooterHtml()}
        ${PRINT_TRIGGER_SCRIPT}
      </body>
    </html>
  `);
  printWindow.document.close();
}

export default function StaffBalancePage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [selectedStaff, setSelectedStaff] = useState<any>(null);
  const [quickAdvOpen, setQuickAdvOpen] = useState(false);
  const [advAmount, setAdvAmount] = useState("");
  const [advNarration, setAdvNarration] = useState("");
  const [showZeroBalance, setShowZeroBalance] = useState(false);
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");
  const [defaultSupplier, setDefaultSupplier] = useState<{ id: number | null; name: string } | null>(loadDefaultSupplier);
  const [snack, setSnack] = useState<{ open: boolean; msg: string; severity: "success" | "error" }>({
    open: false,
    msg: "",
    severity: "success",
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: payrollConfig } = useQuery({
    queryKey: ["payroll-config"],
    queryFn: async () => (await api.get("/payroll/config-settings/")).data || {},
  });

  const { data: suppliers = [] } = useQuery({
    queryKey: ["ledgers", "Account"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data,
  });

  // Auto-calculate weekly pay period (Saturday->Friday based on configured payout day)
  const payoutWeekday = WEEKDAY_INDEX[payrollConfig?.payout_day ?? "Saturday"] ?? 6;
  const autoWeek = useMemo(() => getWeeklyPayPeriod(todayStr(), payoutWeekday), [payoutWeekday]);

  useEffect(() => {
    if (autoWeek && !fromDate && !toDate) {
      setFromDate(autoWeek.from);
      setToDate(autoWeek.to);
    }
  }, [autoWeek, fromDate, toDate]);

  useEffect(() => {
    localStorage.setItem("orbx_staff_balance_default_supplier", JSON.stringify(defaultSupplier));
  }, [defaultSupplier]);

  const handlePrevWeek = () => {
    if (!fromDate || !toDate) return;
    const [y, m, d] = fromDate.split("-").map(Number);
    const prevFrom = shiftDate(new Date(y, m - 1, d), -7);
    setFromDate(isoDate(prevFrom));
    setToDate(isoDate(shiftDate(prevFrom, 6)));
  };

  const handleNextWeek = () => {
    if (!fromDate || !toDate) return;
    const [y, m, d] = fromDate.split("-").map(Number);
    const nextFrom = shiftDate(new Date(y, m - 1, d), 7);
    setFromDate(isoDate(nextFrom));
    setToDate(isoDate(shiftDate(nextFrom, 6)));
  };

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["staff-balance-summary", activeFY, fromDate, toDate, defaultSupplier?.id],
    queryFn: async () => {
      const params = new URLSearchParams({ fy: activeFY });
      if (fromDate) params.set("from_date", fromDate);
      if (toDate) params.set("to_date", toDate);
      if (defaultSupplier?.id) params.set("supplier_id", String(defaultSupplier.id));
      return (await api.get(`/payroll/balance-summary?${params}`)).data;
    },
  });

  const { data: inwardWeightData = 0, isLoading: isInwardWeightLoading } = useQuery({
    queryKey: ["staff-balance-inward-weight", activeFY, defaultSupplier?.id, fromDate, toDate],
    queryFn: async () => {
      if (!defaultSupplier?.id) return 0;
      const params = new URLSearchParams({ fy: activeFY, ledger_id: String(defaultSupplier.id) });
      if (fromDate) params.set("from_date", fromDate);
      if (toDate) params.set("to_date", toDate);
      const res = await api.get(`/payroll/staff-inward-weight?${params}`);
      return res.data.total_inward_weight ?? 0;
    },
    enabled: !!defaultSupplier?.id,
  });

  // Total salary paid for the week (all staff balance rows for the selected week/supplier)
  const totalSalary = useMemo(() => {
    return data.reduce((sum: number, row: any) => sum + Number(row.net_salary || 0), 0);
  }, [data]);

  // Cost per ton = Total Salary / Total Inward Weight for the week
  const costPerTon = useMemo(() => {
    const weight = Number(inwardWeightData || 0);
    return weight > 0 ? totalSalary / weight : 0;
  }, [totalSalary, inwardWeightData]);

  const filteredData = useMemo(() => {
    if (showZeroBalance) return data;
    return data.filter((row: any) => {
      const curBal = Math.abs(row.current_balance || 0);
      const advDue = Math.abs(row.advance_balance || 0);
      return curBal >= 0.01 || advDue >= 0.01;
    });
  }, [data, showZeroBalance]);

  const { data: transactions = [], isLoading: isTxLoading } = useQuery({
    queryKey: ["staff-transactions", selectedStaff?.ledger_id, activeFY],
    queryFn: async () => {
      if (!selectedStaff?.ledger_id) return [];
      return (await api.get(`/payroll/transactions?ledger_id=${selectedStaff.ledger_id}&fy=${activeFY}`)).data;
    },
    enabled: !!selectedStaff?.ledger_id,
  });

  const quickAdvMutation = useMutation({
    mutationFn: async (payload: { amount: number; narration: string }) => {
      let nextNo = "";
      try {
        const res = await api.get("/sequences/preview/staff_advance_payment");
        nextNo = res.data.next_no;
      } catch (e) {
        console.error(e);
      }
      return (
        await api.post(`/payroll/advances?fy=${activeFY}`, {
          voucher_no: nextNo,
          voucher_date: todayStr(),
          ledger_id: selectedStaff.ledger_id,
          payment_type: "Payment",
          ledger_type: "Staff",
          amount: payload.amount,
          narration: payload.narration || "Quick Advance Payment from Staff Balance",
        })
      ).data;
    },
    onSuccess: () => {
      setSnack({ open: true, msg: "Advance Payment recorded successfully!", severity: "success" });
      setAdvAmount("");
      setAdvNarration("");
      setQuickAdvOpen(false);
      qc.invalidateQueries({ queryKey: ["staff-transactions", selectedStaff?.ledger_id, activeFY] });
      qc.invalidateQueries({ queryKey: ["staff-balance-summary", activeFY] });
      qc.invalidateQueries({ queryKey: ["staff-advance-pay"] });
    },
    onError: (err: any) => {
      setSnack({ open: true, msg: err?.response?.data?.detail || "Failed to record advance payment", severity: "error" });
    },
  });

  const handleQuickAdvance = () => {
    const amt = parseFloat(advAmount);
    if (!amt || amt <= 0) {
      setSnack({ open: true, msg: "Please enter a valid amount greater than 0", severity: "error" });
      return;
    }
    quickAdvMutation.mutate({ amount: amt, narration: advNarration });
  };

  const colDefs: ColDef[] = [
    {
      field: "staff_name",
      headerName: "Staff Member",
      flex: 1.2,
      minWidth: 200,
      cellRenderer: (p: any) => (
        <Box>
          <span style={{ fontWeight: 700 }}>{p.value}</span>
          {p.data?.staff_code && (
            <span style={{ fontSize: "0.75rem", color: "#64748b", marginLeft: "6px" }}>({p.data.staff_code})</span>
          )}
          {p.data?.designation && (
            <span style={{ fontSize: "0.72rem", color: "#94a3b8", display: "block" }}>
              {p.data.designation} {p.data.department ? `• ${p.data.department}` : ""}
            </span>
          )}
        </Box>
      ),
    },
    {
      field: "advance_paid",
      headerName: "Advance Paid",
      width: 135,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "advance_received",
      headerName: "Direct Recovered",
      width: 145,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "advance_balance",
      headerName: "Advance Due",
      width: 155,
      type: "numericColumn",
      cellRenderer: (p: any) => {
        const val = Number(p.value || 0);
        const hasDue = val > 0;
        return (
          <Box sx={{ display: "flex", alignItems: "center", justifyContent: "flex-end", gap: 0.8, height: "100%" }}>
            <span style={{ fontWeight: 800, color: hasDue ? "#b45309" : "#166534" }}>
              ₹{formatAmount(Math.abs(val))}
            </span>
            <Chip
              label={hasDue ? "Due" : "Clear"}
              size="small"
              sx={{
                height: 18,
                fontSize: 10,
                fontWeight: 700,
                bgcolor: hasDue ? "rgba(245, 158, 11, 0.12)" : "rgba(22, 196, 127, 0.12)",
                color: hasDue ? "#b45309" : "#166534",
              }}
            />
          </Box>
        );
      },
    },
    {
      field: "net_salary",
      headerName: "Total Salary",
      width: 135,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "current_balance",
      headerName: "Net Balance",
      width: 165,
      type: "numericColumn",
      cellRenderer: (p: any) => {
        const val: number = p.value ?? 0;
        const isPayable = val >= 0;
        const label = isPayable ? "Payable" : "Receivable";
        const color = isPayable ? "#0a7a50" : "#b02a37";
        const bgColor = isPayable ? "rgba(22,196,127,0.12)" : "rgba(220,53,69,0.10)";
        return (
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              gap: 0.75,
              justifyContent: "flex-end",
              height: "100%",
              fontWeight: 700,
              color,
            }}
          >
            <span>₹{formatAmount(Math.abs(val))}</span>
            <Chip
              label={label}
              size="small"
              sx={{
                height: 18,
                fontSize: 10,
                fontWeight: 700,
                bgcolor: bgColor,
                color,
              }}
            />
          </Box>
        );
      },
    },
    {
      headerName: "Actions",
      width: 110,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", justifyContent: "center", alignItems: "center", gap: 0.5, height: "100%" }}>
          <Tooltip title="Print Staff Statement (A4)">
            <IconButton size="small" color="primary" onClick={() => handlePrintStaffStatement(p.data, [], companyData, activeFY, fromDate, toDate)}>
              <PrintIcon fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="View Transactions Summary">
            <IconButton size="small" onClick={() => setSelectedStaff(p.data)}>
              <Visibility fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Staff Balance"
        subtitle="Consolidated staff advances, recoveries, salary deductions, and net balances"
        breadcrumbs={[{ label: "Salary and Wages" }, { label: "Staff Balance" }]}
        actions={
          <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
            <FormControlLabel
              control={
                <Switch
                  size="small"
                  checked={showZeroBalance}
                  onChange={(e) => setShowZeroBalance(e.target.checked)}
                  color="primary"
                />
              }
              label={
                <Typography variant="body2" sx={{ fontSize: "0.82rem", fontWeight: 600, color: "text.secondary" }}>
                  Show Zero Balance
                </Typography>
              }
              sx={{ m: 0 }}
            />
            <Box sx={{ display: "flex", alignItems: "center", gap: 0.75, px: 1, border: "1px solid", borderColor: "divider", borderRadius: 1 }}>
              <Typography variant="caption" sx={{ color: "text.secondary", mr: 0.5, fontWeight: 600 }}>
                Weekly Pay Period
              </Typography>
              <IconButton
                size="small"
                onClick={handlePrevWeek}
                disabled={!fromDate || !toDate}
                sx={{ p: 0.5, minWidth: 32 }}
              >
                <ArrowLeft fontSize="small" />
              </IconButton>
              <Typography
                variant="body2"
                sx={{ fontWeight: 700, minWidth: 90, textAlign: "center", fontSize: "0.9rem" }}
              >
                {fromDate && toDate ? `${formatDisplayDate(fromDate)} – ${formatDisplayDate(toDate)}` : "–"}
              </Typography>
              <IconButton
                size="small"
                onClick={handleNextWeek}
                disabled={!fromDate || !toDate}
                sx={{ p: 0.5, minWidth: 32 }}
              >
                <ArrowRight fontSize="small" />
              </IconButton>
            </Box>
          </Box>
        }
      />

      <OrbxGrid
        rowData={filteredData}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        hideDateFields
        extraFilters={
          <Box sx={{ minWidth: 340, display: "flex", alignItems: "center", gap: 0.75 }}>
            <TextField
              select
              size="small"
              label="Supplier"
              value={defaultSupplier?.id ?? ""}
              onChange={(e) => {
                if (e.target.value) {
                  setDefaultSupplier({ id: Number(e.target.value), name: "" });
                } else {
                  setDefaultSupplier(null);
                }
              }}
              slotProps={{ inputLabel: { shrink: true } }}
              sx={{
                "& .MuiOutlinedInput-root": {
                  borderRadius: "8px",
                },
              }}
            >
              <MenuItem value="">All Suppliers</MenuItem>
              {suppliers.map((l: any) => (
                <MenuItem key={l.id} value={l.id}>{l.name}</MenuItem>
              ))}
            </TextField>
            {defaultSupplier && (
              <Box sx={{ display: "flex", alignItems: "center", gap: 0.75 }}>
                <Chip
                  label={`Total Inward Weight: ${formatWeight(inwardWeightData)} kg`}
                  size="small"
                  sx={{
                    height: 24,
                    fontSize: 12,
                    fontWeight: 700,
                    bgcolor: isInwardWeightLoading ? "#f0f4f8" : "#e8f5e9",
                    color: isInwardWeightLoading ? "text.secondary" : "success.dark",
                  }}
                />
                <Chip
                  label={`Cost Per Ton: ₹${formatAmount(costPerTon)}`}
                  size="small"
                  sx={{
                    height: 24,
                    minWidth: 150,
                    fontSize: 12,
                    fontWeight: 700,
                    bgcolor: isInwardWeightLoading ? "#f0f4f8" : "#e8f5e9",
                    color: isInwardWeightLoading ? "text.secondary" : "success.dark",
                  }}
                />
              </Box>
            )}
          </Box>
        }
        printOverride={(rows, printWindow) => {
          const totals = rows.reduce((sum: any, row: any) => ({
            salary: sum.salary + Number(row.net_salary || 0),
            advance: sum.advance + Number(row.advance_paid || 0),
            paid: sum.paid + Number(row.current_balance || 0),
            balance: sum.balance + Number(row.advance_received || 0),
          }), { salary: 0, advance: 0, paid: 0, balance: 0 });

          const compData = useCompanyStore.getState().company;
          const { name: companyName, address, cityStatePin, phone, email, gstin } = resolveCompanyDetails(compData);
          const logoHtml = getCompanyLogoHtml(true, compData);
          const rowsHtml = rows.map((row: any, index: number) => {
            const staffName = row.staff_name || `Staff #${row.ledger_id}`;
            const staffCode = row.staff_code ? ` (${row.staff_code})` : "";
            return `<tr><td>${index + 1}</td><td>${staffName}${staffCode}</td><td class="amount">₹${formatAmount(Number(row.net_salary || 0))}</td><td class="amount">₹${formatAmount(Number(row.advance_paid || 0))}</td><td class="amount">₹${formatAmount(Number(row.current_balance || 0))}</td><td class="amount">₹${formatAmount(Number(row.advance_received || 0))}</td></tr>`;
          }).join("");

          printWindow.document.write(`<!DOCTYPE html><html><head><title>Staff Balance Report</title><style>
            ${COMMON_PRINT_CSS}
            @page { size: A4 portrait; margin: 14mm; }
            body { color: #1a1a1a; font: 11px Arial, sans-serif; }
            .header { display:flex; align-items:center; gap:16px; border-bottom:1px solid #bbb; padding-bottom:10px; margin-bottom:14px; }
            .logo img { max-width:80px; max-height:60px; }
            .company { flex:1; text-align:center; } .company h2 { margin:0 0 4px; font-size:16px; }
            .company p { margin:2px 0; color:#444; }
            h1 { font-size:15px; margin:12px 0 6px; text-transform:uppercase; }
            .period { font-size:12px; margin:0 0 14px; }
            table { width:100%; border-collapse:collapse; table-layout:fixed; }
            col.serial { width:8%; } col.name { width:28%; } col.money { width:16%; }
            th,td { border-bottom:1px solid #d8d8d8; padding:6px 7px; text-align:left; vertical-align:middle; }
            th { border-top:1px solid #555; border-bottom:1px solid #555; font-size:9px; text-transform:uppercase; }
            th:first-child,td:first-child { text-align:center; }
            th.amount,td.amount { text-align:right; white-space:nowrap; }
            tfoot td { font-weight:700; border-top:1.5px solid #444; border-bottom:0; }
            tfoot td.amount { text-align:right; }
            .footer { margin-top:22px; font-size:9px; color:#666; }
            @media print { tr { break-inside:avoid; } }
          </style></head><body>
            <div class="header"><div class="logo">${logoHtml}</div><div class="company"><h2>${companyName}</h2>${address ? `<p>${address}</p>` : ""}${cityStatePin ? `<p>${cityStatePin}</p>` : ""}${phone ? `<p>${phone}</p>` : ""}${email ? `<p>${email}</p>` : ""}${gstin ? `<p>GSTIN: ${gstin}</p>` : ""}</div></div>
            <h1>Staff Balance Report</h1>
            <p class="period"><strong>From:</strong> ${formatDisplayDate(fromDate)} &nbsp;&nbsp; <strong>To:</strong> ${formatDisplayDate(toDate)}</p>
            <table><colgroup><col class="serial"><col class="name"><col class="money"><col class="money"><col class="money"><col class="money"></colgroup>
              <thead><tr><th>S.No</th><th>Name</th><th class="amount">Salary</th><th class="amount">Advance</th><th class="amount">Paid</th><th class="amount">Balance</th></tr></thead>
              <tbody>${rowsHtml}</tbody><tfoot><tr><td colspan="2">Totals</td><td class="amount">₹${formatAmount(totals.salary)}</td><td class="amount">₹${formatAmount(totals.advance)}</td><td class="amount">₹${formatAmount(totals.paid)}</td><td class="amount">₹${formatAmount(totals.balance)}</td></tr><tr><td colspan="5" style="font-weight:700;">Total Inward Weight</td><td class="amount" style="font-weight:700;">${formatWeight(inwardWeightData)} kg</td></tr><tr><td colspan="5" style="font-weight:700;">Cost Per Ton</td><td class="amount" style="font-weight:700;">₹${formatAmount(costPerTon)}</td></tr></tfoot></table>
            ${getGlobalPrintFooterHtml()}${PRINT_TRIGGER_SCRIPT}
          </body></html>`);
          printWindow.document.close();
        }}
      />

      {/* TRANSACTIONS SUMMARY & QUICK ADVANCE MODAL */}
      <Dialog
        open={Boolean(selectedStaff)}
        onClose={() => {
          setSelectedStaff(null);
          setQuickAdvOpen(false);
        }}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", pb: 1 }}>
          <Box>
            <Typography variant="h6" sx={{ fontWeight: 800 }}>
              {selectedStaff?.staff_name} {selectedStaff?.staff_code ? `(${selectedStaff.staff_code})` : ""}
            </Typography>
            <Typography variant="caption" sx={{ color: "text.secondary" }}>
              {selectedStaff?.designation || "Staff"} • Ledger ID: {selectedStaff?.ledger_id}
            </Typography>
          </Box>
          <Box sx={{ display: "flex", gap: 1 }}>
            <Button
              size="small"
              variant="outlined"
              color="primary"
              startIcon={<PrintIcon />}
              onClick={() => handlePrintStaffStatement(selectedStaff, transactions, companyData, activeFY, fromDate, toDate)}
            >
              Print Statement
            </Button>
            <Button
              size="small"
              variant="contained"
              color="primary"
              startIcon={<Payment />}
              onClick={() => setQuickAdvOpen((prev) => !prev)}
            >
              Quick Advance
            </Button>
          </Box>
        </DialogTitle>

        <DialogContent dividers sx={{ p: 2 }}>
          {/* Quick Advance Form Collapse */}
          {quickAdvOpen && (
            <Paper sx={{ p: 2, mb: 2, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "#f0fdf4", border: "1px solid #86efac" }}>
              <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1, color: "#166534" }}>
                Record Quick Advance Payment for {selectedStaff?.staff_name}
              </Typography>
              <Grid container spacing={1.5} sx={{ alignItems: "center" }}>
                <Grid size={{ xs: 12, sm: 4 }}>
                  <TextField
                    size="small"
                    label="Advance Amount (₹) *"
                    type="number"
                    fullWidth
                    value={advAmount}
                    onChange={(e) => setAdvAmount(e.target.value)}
                    slotProps={{ inputLabel: { shrink: true } }}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 5 }}>
                  <TextField
                    size="small"
                    label="Narration"
                    fullWidth
                    value={advNarration}
                    onChange={(e) => setAdvNarration(e.target.value)}
                    placeholder="e.g. Festival advance / emergency advance"
                    slotProps={{ inputLabel: { shrink: true } }}
                  />
                </Grid>
                <Grid size={{ xs: 12, sm: 3 }}>
                  <Button
                    variant="contained"
                    color="success"
                    fullWidth
                    onClick={handleQuickAdvance}
                    disabled={quickAdvMutation.isPending}
                    sx={{ fontWeight: 700 }}
                  >
                    {quickAdvMutation.isPending ? "Saving..." : "Save Advance"}
                  </Button>
                </Grid>
              </Grid>
            </Paper>
          )}

          {/* Balance Breakdown Strip */}
          <Grid container spacing={1.5} sx={{ mb: 2 }}>
            <Grid size={{ xs: 6, sm: 3 }}>
              <Paper sx={{ p: 1.2, textAlign: "center", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(239, 68, 68, 0.1)" : "#fef2f2", border: "1px solid #fecaca" }}>
                <Typography variant="caption" sx={{ color: "#991b1b", fontWeight: 700 }}>ADVANCE PAID</Typography>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "#b91c1c" }}>
                  ₹{formatAmount(selectedStaff?.advance_paid || 0)}
                </Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <Paper sx={{ p: 1.2, textAlign: "center", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4", border: "1px solid #bbf7d0" }}>
                <Typography variant="caption" sx={{ color: "#166534", fontWeight: 700 }}>RECOVERED</Typography>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "#15803d" }}>
                  ₹{formatAmount((selectedStaff?.advance_received || 0) + (selectedStaff?.salary_deductions || 0))}
                </Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <Paper sx={{ p: 1.2, textAlign: "center", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(245, 158, 11, 0.1)" : "#fffbeb", border: "1px solid #fde68a" }}>
                <Typography variant="caption" sx={{ color: "#92400e", fontWeight: 700 }}>ADVANCE DUE</Typography>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "#b45309" }}>
                  ₹{formatAmount(selectedStaff?.advance_balance || 0)}
                </Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <Paper sx={{ p: 1.2, textAlign: "center", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(59, 130, 246, 0.1)" : "#eff6ff", border: "1px solid #bfdbfe" }}>
                <Typography variant="caption" sx={{ color: "#1e40af", fontWeight: 700 }}>TOTAL SALARY</Typography>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "#1d4ed8" }}>
                  ₹{formatAmount(selectedStaff?.net_salary || 0)}
                </Typography>
              </Paper>
            </Grid>
          </Grid>

          {/* Transactions Table */}
          {isTxLoading ? (
            <Box sx={{ display: "flex", justifyContent: "center", py: 4 }}>
              <CircularProgress size={32} />
            </Box>
          ) : transactions.length === 0 ? (
            <Typography variant="body2" sx={{ textAlign: "center", py: 3, color: "text.secondary" }}>
              No transactions recorded for this staff member yet.
            </Typography>
          ) : (
            <Table size="small" sx={{ "& th, & td": { py: 0.8, fontSize: "0.82rem" } }}>
              <TableHead>
                <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "grey.900" : "grey.100" }}>
                  <TableCell sx={{ fontWeight: 700, width: 35 }}>#</TableCell>
                  <TableCell sx={{ fontWeight: 700, width: 85 }}>Date</TableCell>
                  <TableCell sx={{ fontWeight: 700, width: 110 }}>Doc No</TableCell>
                  <TableCell sx={{ fontWeight: 700, width: 130 }}>Type</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Narration</TableCell>
                  <TableCell sx={{ fontWeight: 700, textAlign: "right", width: 95 }}>Debit (Dr)</TableCell>
                  <TableCell sx={{ fontWeight: 700, textAlign: "right", width: 95 }}>Credit (Cr)</TableCell>
                  <TableCell sx={{ fontWeight: 700, textAlign: "right", width: 115 }}>Running Bal</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {transactions.map((tx: any, i: number) => {
                  const isDr = tx.dr_cr === "Dr";
                  const isBalCr = (tx.running_balance ?? 0) >= 0;
                  return (
                    <TableRow key={i} hover>
                      <TableCell>{i + 1}</TableCell>
                      <TableCell>{tx.date || "-"}</TableCell>
                      <TableCell sx={{ fontWeight: 600 }}>{tx.doc_no || "-"}</TableCell>
                      <TableCell>
                        <Chip
                          label={tx.category}
                          size="small"
                          sx={{ height: 18, fontSize: 10, fontWeight: 700 }}
                          color={tx.category.includes("Payment") ? "error" : tx.category.includes("Receipt") ? "success" : "primary"}
                          variant="outlined"
                        />
                      </TableCell>
                      <TableCell sx={{ color: "text.secondary", fontSize: "0.78rem" }}>{tx.narration || "-"}</TableCell>
                      <TableCell sx={{ textAlign: "right", color: isDr ? "#dc3545" : "text.disabled", fontWeight: isDr ? 700 : 400 }}>
                        {isDr ? `₹${formatAmount(tx.amount)}` : "—"}
                      </TableCell>
                      <TableCell sx={{ textAlign: "right", color: !isDr ? "#198754" : "text.disabled", fontWeight: !isDr ? 700 : 400 }}>
                        {!isDr ? `₹${formatAmount(tx.amount)}` : "—"}
                      </TableCell>
                      <TableCell sx={{ textAlign: "right", fontWeight: 800, color: isBalCr ? "#198754" : "#dc3545" }}>
                        ₹{formatAmount(Math.abs(tx.running_balance ?? 0))} {isBalCr ? "Cr" : "Dr"}
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          )}
        </DialogContent>
        <DialogActions sx={{ px: 2.5, py: 1.5 }}>
          <Button onClick={() => setSelectedStaff(null)} variant="outlined">
            Close
          </Button>
        </DialogActions>
      </Dialog>

      <Snackbar
        open={snack.open}
        autoHideDuration={4000}
        onClose={() => setSnack((p) => ({ ...p, open: false }))}
        anchorOrigin={{ vertical: "bottom", horizontal: "right" }}
      >
        <Alert severity={snack.severity} sx={{ width: "100%" }}>
          {snack.msg}
        </Alert>
      </Snackbar>
    </Box>
  );
}
