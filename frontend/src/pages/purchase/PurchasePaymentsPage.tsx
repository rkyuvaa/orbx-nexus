import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Table, TableHead,
  TableBody, TableFooter, TableRow, TableCell, TableContainer,
  Paper, LinearProgress, Tooltip, IconButton, InputAdornment,
  Divider, TableSortLabel,
} from "@mui/material";
import Refresh from "@mui/icons-material/Refresh";
import Search from "@mui/icons-material/Search";
import Print from "@mui/icons-material/Print";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Clear from "@mui/icons-material/Clear";
import Payment from "@mui/icons-material/Payment";
import ArrowForward from "@mui/icons-material/ArrowForward";
import { useNavigate } from "react-router-dom";

import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import { useAuthStore, useCompanyStore } from "../../store";
import { formatAmount } from "../../utils/format";
import {
  COMMON_PRINT_CSS,
  getPageSizeCSS,
  getCompanyLogoHtml,
  PRINT_TRIGGER_SCRIPT,
  getGlobalPrintFooterHtml,
} from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";

const PAYMENT_MODE_OPTIONS = ["Bank Transfer", "Cash", "Cheque", "UPI", "Other"];
const RUPEE = "₹";

function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

const statusChip = (status: string) => {
  const isPaid = status === "Paid";
  const isPartial = status === "Partial";
  return (
    <Chip
      label={status || "Paid"}
      size="small"
      color={isPaid ? "success" : isPartial ? "warning" : "default"}
      sx={{ fontWeight: 700, fontSize: "0.72rem", height: 20 }}
    />
  );
};

const modeChip = (mode: string) => {
  const m = (mode || "Direct").toLowerCase();
  let color: "primary" | "success" | "secondary" | "warning" | "default" = "default";
  if (m.includes("bank")) color = "primary";
  else if (m.includes("cash")) color = "success";
  else if (m.includes("upi")) color = "secondary";
  else if (m.includes("cheque")) color = "warning";

  return (
    <Chip
      label={mode || "Direct"}
      size="small"
      variant="outlined"
      color={color}
      sx={{ fontWeight: 600, fontSize: "0.72rem", height: 20 }}
    />
  );
};

export interface PurchasePaymentRow {
  line_id: number;
  payment_id: number;
  payment_no: string;
  payment_date: string;
  payment_mode: string;
  payment_bulk_amount: number;
  payment_notes: string;
  ledger_id: number;
  supplier_name: string;
  movement_id: number;
  movement_no: string;
  movement_date: string;
  ref_no: string;
  bill_amount: number;
  paid_amount: number;
  bill_total_paid: number;
  bill_status: string;
  bill_remaining_balance: number;
}

// ──── Print Individual Payment Voucher ────
function handlePrintPaymentVoucher(row: PurchasePaymentRow, companyData: any) {
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
  const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
  const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
  const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

  const amountWords = toWords(row.paid_amount);

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Purchase Payment Voucher - ${row.payment_no}</title>
        <style>
          @page { size: ${getPageSizeCSS(printConfig.billPaperSize as any)}; margin: 15mm; }
          ${COMMON_PRINT_CSS}
          .voucher-box {
            border: 2px solid #0f5132;
            border-radius: 8px;
            padding: 16px;
            margin-top: 15px;
          }
          .voucher-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            row-gap: 8px;
            column-gap: 20px;
            font-size: 13px;
          }
          .voucher-label {
            color: #555;
            font-size: 11px;
            text-transform: uppercase;
            font-weight: 600;
          }
          .voucher-value {
            font-weight: 700;
            color: #111;
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

        <div class="title-section" style="margin-top: 15px;">
          <h2 style="color: #0f5132; letter-spacing: 1px;">PURCHASE PAYMENT VOUCHER</h2>
          <div class="doc-no">Voucher No: <strong>${row.payment_no}</strong></div>
          <div class="doc-date">Date: <strong>${row.payment_date}</strong></div>
        </div>

        <div class="voucher-box">
          <div class="voucher-grid">
            <div>
              <div class="voucher-label">Paid To (Supplier / Party)</div>
              <div class="voucher-value" style="font-size: 15px; color: #0f5132;">${row.supplier_name}</div>
            </div>
            <div>
              <div class="voucher-label">Payment Mode</div>
              <div class="voucher-value">${row.payment_mode}</div>
            </div>
            <div>
              <div class="voucher-label">Adjusted Against Purchase Bill</div>
              <div class="voucher-value" style="font-size: 14px; color: #0f5132;">${row.movement_no} ${row.ref_no ? `(Inv: ${row.ref_no})` : ""}</div>
            </div>
            <div>
              <div class="voucher-label">Bill Date</div>
              <div class="voucher-value">${row.movement_date || "—"}</div>
            </div>
          </div>
        </div>

        <table class="items-table" style="margin-top: 20px;">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 40px; text-align: center;">S.NO</th>
              <th>PURCHASE BILL NO</th>
              <th style="width: 140px; text-align: right;">BILL AMOUNT</th>
              <th style="width: 150px; text-align: right;">AMOUNT PAID (₹)</th>
              <th style="width: 140px; text-align: right;">REMAINING BALANCE</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="text-align: center;">1</td>
              <td style="font-weight: 700;">
                ${row.movement_no}
                ${row.payment_notes ? `<div style="font-size: 11px; color: #555; font-weight: normal;">Notes: ${row.payment_notes}</div>` : ""}
              </td>
              <td style="text-align: right;">₹${formatAmount(row.bill_amount)}</td>
              <td style="text-align: right; font-weight: 700; color: #0f5132; font-size: 14px;">
                ₹${formatAmount(row.paid_amount)}
              </td>
              <td style="text-align: right; color: ${row.bill_remaining_balance > 0 ? '#dc3545' : '#198754'}; font-weight: 600;">
                ₹${formatAmount(row.bill_remaining_balance)}
              </td>
            </tr>
          </tbody>
        </table>

        <div class="totals-section">
          <div class="calculation-box">
            <div class="calculation-row">
              <span>Total Bill Value:</span>
              <span>₹${formatAmount(row.bill_amount)}</span>
            </div>
            <div class="calculation-row grand-total" style="background-color: #e8f5e9 !important;">
              <span>Amount Paid on this Voucher:</span>
              <span style="color: #0f5132;">₹${formatAmount(row.paid_amount)}</span>
            </div>
            <div class="calculation-row">
              <span>Bill Remaining Balance:</span>
              <span>₹${formatAmount(row.bill_remaining_balance)}</span>
            </div>
          </div>
        </div>

        ${amountWords ? `
          <div class="bottom-section" style="margin-top: 15px;">
            <div class="narration-box" style="background-color: #f0fdf4 !important; font-weight: 700; border-left: 4px solid #0f5132;">
              <strong>AMOUNT IN WORDS:</strong> ${amountWords.replace(/^Rupees:\s*/i, "").replace(/\s*Rupees Only$/i, "").trim().toUpperCase()} RUPEES ONLY
            </div>
          </div>
        ` : ""}

        <div class="signatures-container" style="margin-top: 50px;">
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Prepared By</div>
          </div>
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Receiver's Sign</div>
          </div>
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Authorised Signatory<br/>For ${cName}</div>
          </div>
        </div>

        ${getGlobalPrintFooterHtml()}
        ${PRINT_TRIGGER_SCRIPT}
      </body>
    </html>
  `);
  printWindow.document.close();
}

// ──── Print Full Payments Register ────
function handlePrintPaymentsRegister(rows: PurchasePaymentRow[], companyData: any, summary: any) {
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
  const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
  const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
  const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

  let tableRowsHtml = "";
  rows.forEach((r, idx) => {
    tableRowsHtml += `
      <tr>
        <td style="text-align: center;">${idx + 1}</td>
        <td style="text-align: center;">${r.payment_date}</td>
        <td style="font-weight: 700; color: #0f5132;">${r.payment_no}</td>
        <td style="font-weight: 700;">${r.supplier_name}</td>
        <td style="text-align: center;">${r.payment_mode}</td>
        <td style="font-weight: 700; color: #0f5132;">${r.movement_no}</td>
        <td style="text-align: right;">₹${formatAmount(r.bill_amount)}</td>
        <td style="text-align: right; font-weight: 700; color: #0f5132; font-size: 13px;">
          ₹${formatAmount(r.paid_amount)}
        </td>
        <td style="text-align: right; color: ${r.bill_remaining_balance > 0 ? '#dc3545' : '#198754'};">
          ₹${formatAmount(r.bill_remaining_balance)}
        </td>
        <td style="text-align: center;">${r.bill_status}</td>
      </tr>
    `;
  });

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Purchase Payments Register</title>
        <style>
          @page { size: A4 landscape; margin: 12mm; }
          ${COMMON_PRINT_CSS}
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

        <div class="title-section" style="margin-top: 15px;">
          <h2>PURCHASE PAYMENTS REGISTER (ROW-BY-ROW)</h2>
          <div class="doc-no">Total Records: ${rows.length}</div>
          <div class="doc-date">Generated: ${new Date().toLocaleDateString("en-IN")}</div>
        </div>

        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 40px; text-align: center;">#</th>
              <th style="width: 95px; text-align: center;">DATE</th>
              <th style="width: 130px;">VOUCHER NO</th>
              <th>SUPPLIER / PARTY</th>
              <th style="width: 100px; text-align: center;">MODE</th>
              <th style="width: 120px;">BILL NO</th>
              <th style="width: 115px; text-align: right;">BILL TOTAL</th>
              <th style="width: 125px; text-align: right;">PAID (₹)</th>
              <th style="width: 115px; text-align: right;">BALANCE</th>
              <th style="width: 85px; text-align: center;">STATUS</th>
            </tr>
          </thead>
          <tbody>
            ${tableRowsHtml}
          </tbody>
          <tfoot style="font-weight: 700; background-color: #f4f9f6;">
            <tr>
              <td colspan="7" style="text-align: right;">Totals:</td>
              <td style="text-align: right; color: #0f5132; font-size: 13px;">₹${formatAmount(summary.totalPaidAmount)}</td>
              <td style="text-align: right; color: #dc3545;">₹${formatAmount(summary.totalBalance)}</td>
              <td style="text-align: center;"></td>
            </tr>
          </tfoot>
        </table>

        <div class="signatures-container" style="margin-top: 40px;">
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Prepared By</div>
          </div>
          <div class="signature-block">
            <div class="signature-line"></div>
            <div class="signature-label">Authorised Signatory<br/>For ${cName}</div>
          </div>
        </div>

        ${getGlobalPrintFooterHtml()}
        ${PRINT_TRIGGER_SCRIPT}
      </body>
    </html>
  `);
  printWindow.document.close();
}

// ──── Edit Single Payment Row Dialog ────
interface EditSinglePaymentDialogProps {
  open: boolean;
  onClose: () => void;
  row: PurchasePaymentRow | null;
  onSuccess?: () => void;
}

function EditSinglePaymentDialog({ open, onClose, row, onSuccess }: EditSinglePaymentDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const [paidAmountStr, setPaidAmountStr] = useState<string>("");
  const [paymentDate, setPaymentDate] = useState<string>("");
  const [paymentMode, setPaymentMode] = useState<string>("Bank Transfer");
  const [paymentNotes, setPaymentNotes] = useState<string>("");

  useEffect(() => {
    if (row && open) {
      setPaidAmountStr(String(Number(row.paid_amount || 0)));
      setPaymentDate(row.payment_date || new Date().toISOString().split("T")[0]);
      setPaymentMode(row.payment_mode || "Bank Transfer");
      setPaymentNotes(row.payment_notes || "");
    }
  }, [row, open]);

  const billTotal = Number(row?.bill_amount || 0);
  const otherPaid = Math.max(0, Number(row?.bill_total_paid || 0) - Number(row?.paid_amount || 0));
  const maxAllowedForThisPayment = round2(Math.max(0, billTotal - otherPaid));
  const newThisPaid = round2(Number(paidAmountStr) || 0);
  const newBillTotalPaid = round2(otherPaid + newThisPaid);
  const newRemainingBalance = round2(Math.max(0, billTotal - newBillTotalPaid));

  const saveMutation = useMutation({
    mutationFn: async () => {
      if (!row) return;
      if (newThisPaid < 0) throw new Error("Paid amount cannot be negative");

      await api.put(`/stock/inventory/purchase-payments/${row.payment_id}?fy=${activeFY}`, {
        payment_date: paymentDate || null,
        payment_mode: paymentMode || null,
        notes: paymentNotes || null,
        paid_amount: newThisPaid,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payments"] });
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      if (onSuccess) onSuccess();
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || err.message || "Failed to update payment");
    },
  });

  if (!row) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 1, fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Edit Payment Record</span>
        <Chip label={row.payment_no} color="primary" variant="outlined" size="small" sx={{ fontWeight: 700 }} />
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        {/* Bill summary information */}
        <Paper
          variant="outlined"
          sx={{
            p: 2,
            mb: 2.5,
            borderRadius: 2,
            bgcolor: (t) => (t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f8faf9"),
          }}
        >
          <Grid container spacing={1.5}>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Supplier / Party</Typography>
              <Typography variant="body2" sx={{ fontWeight: 700 }}>{row.supplier_name}</Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Purchase Bill No</Typography>
              <Typography variant="body2" sx={{ fontWeight: 700, color: "primary.main" }}>{row.movement_no}</Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Total Bill Amount</Typography>
              <Typography variant="body1" sx={{ fontWeight: 700 }}>
                {RUPEE}{formatAmount(billTotal)}
              </Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Current Recorded on this Payment</Typography>
              <Typography variant="body1" sx={{ fontWeight: 700, color: "success.main" }}>
                {RUPEE}{formatAmount(row.paid_amount)}
              </Typography>
            </Grid>
          </Grid>
        </Paper>

        {/* Inputs */}
        <Grid container spacing={2}>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Amount Paid in this Record (₹) *"
              type="number"
              fullWidth
              size="small"
              value={paidAmountStr}
              onChange={(e) => setPaidAmountStr(e.target.value)}
              slotProps={{
                inputLabel: { shrink: true },
                htmlInput: { step: "0.01", min: 0, max: maxAllowedForThisPayment },
              }}
              helperText={`Max: ${RUPEE}${formatAmount(maxAllowedForThisPayment)}`}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Payment Date *"
              type="date"
              fullWidth
              size="small"
              value={paymentDate}
              onChange={(e) => setPaymentDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              select
              label="Payment Mode *"
              fullWidth
              size="small"
              value={paymentMode}
              onChange={(e) => setPaymentMode(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            >
              {PAYMENT_MODE_OPTIONS.map((m) => (
                <MenuItem key={m} value={m}>{m}</MenuItem>
              ))}
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Notes / Narration"
              fullWidth
              size="small"
              value={paymentNotes}
              onChange={(e) => setPaymentNotes(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
        </Grid>

        {/* Live Calculation Preview */}
        <Box
          sx={{
            mt: 2.5,
            p: 1.5,
            borderRadius: 2,
            bgcolor: (t) => (t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f0fdf4"),
            border: "1px solid",
            borderColor: (t) => (t.palette.mode === "dark" ? "divider" : "#bbf7d0"),
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <Box>
            <Typography variant="caption" color="text.secondary">Remaining Bill Balance</Typography>
            <Typography variant="h6" sx={{ fontWeight: 800, color: newRemainingBalance > 0.01 ? "#dc3545" : "success.main" }}>
              {RUPEE}{formatAmount(newRemainingBalance)}
            </Typography>
          </Box>
          <Box sx={{ textAlign: "right" }}>
            <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Resulting Status</Typography>
            {statusChip(newRemainingBalance <= 0.01 ? "Paid" : newBillTotalPaid > 0 ? "Partial" : "Unpaid")}
          </Box>
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2.5 }}>
        <Button onClick={onClose} variant="outlined" size="small">
          Cancel
        </Button>
        <Button
          onClick={() => saveMutation.mutate()}
          variant="contained"
          size="small"
          color="primary"
          disabled={saveMutation.isPending || newThisPaid < 0}
          startIcon={<Edit fontSize="small" />}
        >
          {saveMutation.isPending ? "Updating..." : "Update Payment"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}

// ──── Main Page Component ────
export default function PurchasePaymentsPage() {
  const { activeFY } = useAuthStore();
  const navigate = useNavigate();
  const qc = useQueryClient();

  // Dialog States
  const [editingRow, setEditingRow] = useState<PurchasePaymentRow | null>(null);
  const [editDialogOpen, setEditDialogOpen] = useState(false);

  const [deletingRow, setDeletingRow] = useState<PurchasePaymentRow | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);

  // Filter States
  const [search, setSearch] = useState("");
  const [supplierFilter, setSupplierFilter] = useState<string>("ALL");
  const [modeFilter, setModeFilter] = useState<string>("ALL");
  const [statusFilter, setStatusFilter] = useState<string>("ALL");
  const [fromDate, setFromDate] = useState<string>("");
  const [toDate, setToDate] = useState<string>("");
  const [sortOrder, setSortOrder] = useState<"asc" | "desc">("desc");

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: payments = [], isLoading, refetch } = useQuery<PurchasePaymentRow[]>({
    queryKey: ["purchase-payments", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/purchase-payments?fy=${activeFY}`)).data,
  });

  // Unique suppliers list for filter dropdown
  const uniqueSuppliers = useMemo(() => {
    const set = new Set<string>();
    payments.forEach((p) => {
      if (p.supplier_name) set.add(p.supplier_name);
    });
    return Array.from(set).sort();
  }, [payments]);

  // Filtered rows (sorted by payment date, newest at top by default)
  const filteredRows = useMemo(() => {
    const list = payments.filter((p) => {
      if (search) {
        const q = search.toLowerCase();
        const matches =
          p.payment_no.toLowerCase().includes(q) ||
          p.supplier_name.toLowerCase().includes(q) ||
          p.movement_no.toLowerCase().includes(q) ||
          p.payment_mode.toLowerCase().includes(q) ||
          (p.payment_notes && p.payment_notes.toLowerCase().includes(q)) ||
          (p.ref_no && p.ref_no.toLowerCase().includes(q));
        if (!matches) return false;
      }

      if (supplierFilter !== "ALL" && p.supplier_name !== supplierFilter) return false;
      if (modeFilter !== "ALL" && p.payment_mode !== modeFilter) return false;
      if (statusFilter !== "ALL" && p.bill_status !== statusFilter) return false;
      if (fromDate && p.payment_date < fromDate) return false;
      if (toDate && p.payment_date > toDate) return false;

      return true;
    });

    return list.sort((a, b) => {
      const dateA = a.payment_date || "";
      const dateB = b.payment_date || "";
      if (dateA !== dateB) {
        return sortOrder === "desc" ? (dateA < dateB ? 1 : -1) : (dateA > dateB ? 1 : -1);
      }
      if (sortOrder === "desc") {
        return (b.payment_id || 0) - (a.payment_id || 0) || (b.line_id || 0) - (a.line_id || 0);
      }
      return (a.payment_id || 0) - (b.payment_id || 0) || (a.line_id || 0) - (b.line_id || 0);
    });
  }, [payments, search, supplierFilter, modeFilter, statusFilter, fromDate, toDate, sortOrder]);

  // Summary Metrics
  const summary = useMemo(() => {
    let totalPaidAmount = 0;
    let totalBalance = 0;
    let settledCount = 0;
    let partialCount = 0;

    filteredRows.forEach((r) => {
      totalPaidAmount += Number(r.paid_amount || 0);
      totalBalance += Number(r.bill_remaining_balance || 0);
      if (r.bill_status === "Paid") settledCount++;
      else partialCount++;
    });

    return {
      totalPaidAmount: round2(totalPaidAmount),
      totalBalance: round2(totalBalance),
      settledCount,
      partialCount,
      totalCount: filteredRows.length,
    };
  }, [filteredRows]);

  const deleteMutation = useMutation({
    mutationFn: async (paymentId: number) => {
      await api.delete(`/stock/inventory/purchase-payments/${paymentId}?fy=${activeFY}`);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payments"] });
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      setDeleteDialogOpen(false);
      setDeletingRow(null);
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || err.message || "Failed to delete payment");
    },
  });

  const handleOpenEdit = (row: PurchasePaymentRow) => {
    setEditingRow(row);
    setEditDialogOpen(true);
  };

  const handleOpenDelete = (row: PurchasePaymentRow) => {
    setDeletingRow(row);
    setDeleteDialogOpen(true);
  };

  const handleClearFilters = () => {
    setSearch("");
    setSupplierFilter("ALL");
    setModeFilter("ALL");
    setStatusFilter("ALL");
    setFromDate("");
    setToDate("");
  };

  const isFilterActive =
    Boolean(search) ||
    supplierFilter !== "ALL" ||
    modeFilter !== "ALL" ||
    statusFilter !== "ALL" ||
    Boolean(fromDate) ||
    Boolean(toDate);

  return (
    <Box sx={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      <PageHeader
        title="Purchase Payments"
        subtitle="Register of paid purchase bills and payment records (row-by-row view)"
        breadcrumbs={[{ label: "Purchase" }, { label: "Purchase Payments" }]}
        actions={
          <Box sx={{ display: "flex", gap: 1 }}>
            <Button
              variant="outlined"
              size="small"
              startIcon={<Print />}
              onClick={() => handlePrintPaymentsRegister(filteredRows, companyData, summary)}
              disabled={filteredRows.length === 0}
            >
              Print Payments Register
            </Button>
            <Button
              variant="outlined"
              size="small"
              startIcon={<Refresh />}
              onClick={() => refetch()}
            >
              Refresh
            </Button>
          </Box>
        }
      />

      {/* KPI Stat Cards */}
      <Box sx={{ display: "flex", gap: 2, mb: 2, flexWrap: "wrap" }}>
        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "success.main", color: "#fff", minWidth: 160 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Total Payments Paid
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {RUPEE}{formatAmount(summary.totalPaidAmount)}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 140 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Payment Records
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {summary.totalCount}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "#0f5132", color: "#fff", minWidth: 140 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Fully Settled
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {summary.settledCount}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "warning.dark", color: "#fff", minWidth: 140 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Partially Paid
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {summary.partialCount}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "action.selected", minWidth: 150, border: "1px solid", borderColor: "divider" }}>
          <Typography variant="caption" color="text.secondary" sx={{ display: "block", fontWeight: 600 }}>
            Remaining Balance
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3, color: summary.totalBalance > 0 ? "error.main" : "text.secondary" }}>
            {RUPEE}{formatAmount(summary.totalBalance)}
          </Typography>
        </Box>
      </Box>

      {/* Filter & Search Bar */}
      <Paper variant="outlined" sx={{ p: 1.5, mb: 2, borderRadius: 2 }}>
        <Grid container spacing={1.5} sx={{ alignItems: "center" }}>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              size="small"
              fullWidth
              placeholder="Search Bill No, Supplier, Notes..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              slotProps={{
                input: {
                  startAdornment: (
                    <InputAdornment position="start">
                      <Search fontSize="small" sx={{ color: "text.secondary" }} />
                    </InputAdornment>
                  ),
                },
              }}
            />
          </Grid>

          <Grid size={{ xs: 6, sm: 2.5 }}>
            <TextField
              select
              size="small"
              fullWidth
              label="Supplier"
              value={supplierFilter}
              onChange={(e) => setSupplierFilter(e.target.value)}
            >
              <MenuItem value="ALL">All Suppliers ({uniqueSuppliers.length})</MenuItem>
              {uniqueSuppliers.map((s) => (
                <MenuItem key={s} value={s}>{s}</MenuItem>
              ))}
            </TextField>
          </Grid>

          <Grid size={{ xs: 6, sm: 2 }}>
            <TextField
              select
              size="small"
              fullWidth
              label="Payment Mode"
              value={modeFilter}
              onChange={(e) => setModeFilter(e.target.value)}
            >
              <MenuItem value="ALL">All Modes</MenuItem>
              {PAYMENT_MODE_OPTIONS.map((m) => (
                <MenuItem key={m} value={m}>{m}</MenuItem>
              ))}
            </TextField>
          </Grid>

          <Grid size={{ xs: 6, sm: 1.5 }}>
            <TextField
              select
              size="small"
              fullWidth
              label="Status"
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
            >
              <MenuItem value="ALL">All Status</MenuItem>
              <MenuItem value="Paid">Fully Paid</MenuItem>
              <MenuItem value="Partial">Partial</MenuItem>
            </TextField>
          </Grid>

          <Grid size={{ xs: 6, sm: 1.5 }}>
            <TextField
              size="small"
              type="date"
              fullWidth
              label="From Date"
              value={fromDate}
              onChange={(e) => setFromDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>

          <Grid size={{ xs: 6, sm: 1.5 }}>
            <TextField
              size="small"
              type="date"
              fullWidth
              label="To Date"
              value={toDate}
              onChange={(e) => setToDate(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>

          {isFilterActive && (
            <Grid size={{ xs: "auto" }}>
              <Tooltip title="Clear all filters">
                <IconButton size="small" onClick={handleClearFilters} color="error">
                  <Clear fontSize="small" />
                </IconButton>
              </Tooltip>
            </Grid>
          )}
        </Grid>
      </Paper>

      {/* Main Flat Row-by-Row Table */}
      <Paper variant="outlined" sx={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", borderRadius: 2 }}>
        {isLoading && <LinearProgress />}
        <TableContainer sx={{ flex: 1, overflow: "auto" }}>
          <Table size="small" stickyHeader>
            <TableHead>
              <TableRow sx={{ "& > th": { fontWeight: 700, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.05)" : "#f8faf9" } }}>
                <TableCell sx={{ width: 40, textAlign: "center" }}>#</TableCell>
                <TableCell sx={{ width: 130 }}>
                  <TableSortLabel
                    active
                    direction={sortOrder}
                    onClick={() => setSortOrder((prev) => (prev === "desc" ? "asc" : "desc"))}
                    sx={{ fontWeight: 700 }}
                  >
                    Payment Date
                  </TableSortLabel>
                </TableCell>
                <TableCell sx={{ width: 130 }}>Voucher No</TableCell>
                <TableCell sx={{ minWidth: 150 }}>Supplier / Party</TableCell>
                <TableCell sx={{ width: 100, textAlign: "center" }}>Mode</TableCell>
                <TableCell sx={{ width: 120 }}>Bill No</TableCell>
                <TableCell align="right" sx={{ width: 120 }}>Bill Total</TableCell>
                <TableCell align="right" sx={{ width: 135, color: "success.main" }}>Amount Paid (₹)</TableCell>
                <TableCell align="right" sx={{ width: 110 }}>Balance</TableCell>
                <TableCell align="center" sx={{ width: 85 }}>Status</TableCell>
                <TableCell align="center" sx={{ width: 110 }}>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredRows.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={11} align="center" sx={{ py: 6 }}>
                    <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 1 }}>
                      <Payment sx={{ fontSize: 48, color: "text.disabled" }} />
                      <Typography variant="subtitle1" sx={{ fontWeight: 600, color: "text.secondary" }}>
                        {payments.length === 0
                          ? "No purchase payment records found."
                          : "No payments match the selected filters."}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        {payments.length === 0
                          ? "Payments recorded against purchase bills in 'Purchase Payables' will automatically appear here."
                          : "Try adjusting or clearing your search and filters."}
                      </Typography>
                      {payments.length === 0 ? (
                        <Button
                          variant="contained"
                          size="small"
                          color="primary"
                          endIcon={<ArrowForward />}
                          onClick={() => navigate("/purchase/payables")}
                          sx={{ mt: 1, textTransform: "none" }}
                        >
                          Go to Purchase Payables to Record Payment
                        </Button>
                      ) : (
                        <Button
                          variant="outlined"
                          size="small"
                          onClick={handleClearFilters}
                          sx={{ mt: 1, textTransform: "none" }}
                        >
                          Clear Filters
                        </Button>
                      )}
                    </Box>
                  </TableCell>
                </TableRow>
              ) : (
                filteredRows.map((row, idx) => (
                  <TableRow key={`${row.payment_id}-${row.line_id}`} hover sx={{ "& > td": { py: 0.9 } }}>
                    <TableCell align="center" sx={{ fontSize: 12, color: "text.secondary" }}>
                      {idx + 1}
                    </TableCell>
                    <TableCell sx={{ fontSize: 12, fontWeight: 600, whiteSpace: "nowrap" }}>
                      {row.payment_date}
                    </TableCell>
                    <TableCell sx={{ fontSize: 12, fontWeight: 700, color: "primary.main", whiteSpace: "nowrap" }}>
                      {row.payment_no}
                    </TableCell>
                    <TableCell sx={{ fontSize: 12.5, fontWeight: 700 }}>
                      {row.supplier_name}
                    </TableCell>
                    <TableCell align="center" sx={{ whiteSpace: "nowrap" }}>
                      {modeChip(row.payment_mode)}
                    </TableCell>
                    {/* Bill No */}
                    <TableCell sx={{ fontSize: 12.5, fontWeight: 700, color: "primary.main", whiteSpace: "nowrap" }}>
                      {row.movement_no}
                    </TableCell>
                    {/* Total Bill Amount */}
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>
                      {RUPEE}{formatAmount(row.bill_amount)}
                    </TableCell>
                    {/* Amount Paid in this payment */}
                    <TableCell align="right" sx={{ fontSize: 13.5, fontWeight: 800, color: "success.main", whiteSpace: "nowrap" }}>
                      {RUPEE}{formatAmount(row.paid_amount)}
                    </TableCell>
                    {/* Remaining Balance */}
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600, color: row.bill_remaining_balance > 0.01 ? "#dc3545" : "success.main" }}>
                      {row.bill_remaining_balance > 0.01 ? `${RUPEE}${formatAmount(row.bill_remaining_balance)}` : "₹0.00"}
                    </TableCell>
                    {/* Status */}
                    <TableCell align="center">
                      {statusChip(row.bill_status)}
                    </TableCell>
                    {/* Actions */}
                    <TableCell align="center" sx={{ whiteSpace: "nowrap" }}>
                      <Box sx={{ display: "inline-flex", gap: 0.5 }}>
                        <Tooltip title="Edit this Payment">
                          <IconButton
                            size="small"
                            color="primary"
                            onClick={() => handleOpenEdit(row)}
                            sx={{ p: 0.4 }}
                          >
                            <Edit sx={{ fontSize: 17 }} />
                          </IconButton>
                        </Tooltip>

                        <Tooltip title="Delete this Payment">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleOpenDelete(row)}
                            sx={{ p: 0.4 }}
                          >
                            <Delete sx={{ fontSize: 17 }} />
                          </IconButton>
                        </Tooltip>

                        <Tooltip title="Print Payment Voucher">
                          <IconButton
                            size="small"
                            color="success"
                            onClick={() => handlePrintPaymentVoucher(row, companyData)}
                            sx={{ p: 0.4 }}
                          >
                            <Print sx={{ fontSize: 17 }} />
                          </IconButton>
                        </Tooltip>
                      </Box>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
            {filteredRows.length > 0 && (
              <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f4f9f6" }}>
                <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                  <TableCell colSpan={7} align="right" sx={{ fontSize: 12 }}>
                    Totals ({filteredRows.length} payment records):
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 13.5, color: "success.main", fontWeight: 800 }}>
                    {RUPEE}{formatAmount(summary.totalPaidAmount)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 12.5, color: summary.totalBalance > 0 ? "#dc3545" : "success.main" }}>
                    {RUPEE}{formatAmount(summary.totalBalance)}
                  </TableCell>
                  <TableCell colSpan={2} />
                </TableRow>
              </TableFooter>
            )}
          </Table>
        </TableContainer>
      </Paper>

      {/* Edit Payment Dialog */}
      <EditSinglePaymentDialog
        open={editDialogOpen}
        onClose={() => {
          setEditDialogOpen(false);
          setEditingRow(null);
        }}
        row={editingRow}
      />

      {/* Delete Payment Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)} maxWidth="xs" fullWidth>
        <DialogTitle sx={{ fontWeight: 700, color: "error.main" }}>
          Delete Payment Record?
        </DialogTitle>
        <DialogContent>
          <Typography variant="body2" sx={{ mb: 1 }}>
            Are you sure you want to delete payment <strong>{deletingRow?.payment_no}</strong> for bill <strong>{deletingRow?.movement_no}</strong>?
          </Typography>
          <Typography variant="body2" sx={{ color: "text.secondary" }}>
            Amount: <strong>{RUPEE}{formatAmount(deletingRow?.paid_amount || 0)}</strong>
          </Typography>
          <Typography variant="caption" color="error.main" sx={{ display: "block", mt: 1 }}>
            The bill's paid amount will be automatically re-adjusted.
          </Typography>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={() => setDeleteDialogOpen(false)} variant="outlined" size="small">
            Cancel
          </Button>
          <Button
            onClick={() => deletingRow && deleteMutation.mutate(deletingRow.payment_id)}
            variant="contained"
            color="error"
            size="small"
            disabled={deleteMutation.isPending}
          >
            {deleteMutation.isPending ? "Deleting..." : "Delete Payment"}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
