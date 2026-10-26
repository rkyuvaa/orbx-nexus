import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Table, TableHead,
  TableBody, TableFooter, TableRow, TableCell, TableContainer,
  Paper, LinearProgress, Tooltip, IconButton, InputAdornment,
  Divider, Card, CardContent
} from "@mui/material";
import Refresh from "@mui/icons-material/Refresh";
import Search from "@mui/icons-material/Search";
import Print from "@mui/icons-material/Print";
import Visibility from "@mui/icons-material/Visibility";
import Edit from "@mui/icons-material/Edit";
import Payment from "@mui/icons-material/Payment";
import Clear from "@mui/icons-material/Clear";
import Receipt from "@mui/icons-material/Receipt";
import CheckCircle from "@mui/icons-material/CheckCircle";
import PendingActions from "@mui/icons-material/PendingActions";
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
      sx={{ fontWeight: 700, fontSize: "0.75rem", height: 22 }}
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

// ──── Print Individual Payment Voucher ────
function handlePrintPaymentVoucher(bill: any, companyData: any) {
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

  const supplierName = bill.ledger_name || "Supplier / Payee";
  const paidAmount = Number(bill.paid_amount || 0);
  const billTotal = Number(bill.amount || 0);
  const balance = Math.max(0, round2(billTotal - paidAmount));
  const amountWords = toWords(paidAmount);
  const payDate = bill.payment_date || bill.movement_date || "-";
  const payMode = bill.payment_mode || "Bank Transfer";
  const voucherNo = `PAY-${bill.movement_no}`;

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Purchase Payment Voucher - ${voucherNo}</title>
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
          <div class="doc-no">Voucher No: <strong>${voucherNo}</strong></div>
          <div class="doc-date">Date: <strong>${payDate}</strong></div>
        </div>

        <div class="voucher-box">
          <div class="voucher-grid">
            <div>
              <div class="voucher-label">Paid To (Supplier / Payee)</div>
              <div class="voucher-value" style="font-size: 15px; color: #0f5132;">${supplierName}</div>
            </div>
            <div>
              <div class="voucher-label">Payment Mode</div>
              <div class="voucher-value">${payMode}</div>
            </div>
            <div>
              <div class="voucher-label">Against Purchase Bill No.</div>
              <div class="voucher-value">${bill.movement_no} ${bill.ref_no ? `(Supplier Inv: ${bill.ref_no})` : ""}</div>
            </div>
            <div>
              <div class="voucher-label">Bill Date</div>
              <div class="voucher-value">${bill.movement_date || "—"}</div>
            </div>
          </div>
        </div>

        <table class="items-table" style="margin-top: 20px;">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 50px; text-align: center;">S.NO</th>
              <th>PARTICULARS / DESCRIPTION</th>
              <th style="width: 130px; text-align: right;">BILL AMOUNT</th>
              <th style="width: 140px; text-align: right;">AMOUNT PAID</th>
              <th style="width: 130px; text-align: right;">REMAINING BALANCE</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="text-align: center;">1</td>
              <td>
                <strong>Payment towards Purchase Bill ${bill.movement_no}</strong>
                ${bill.payment_notes ? `<div style="font-size: 11px; color: #555; margin-top: 3px;">Ref / Notes: ${bill.payment_notes}</div>` : ""}
                ${bill.stock_item_name ? `<div style="font-size: 11px; color: #666;">Item: ${bill.stock_item_name}</div>` : ""}
              </td>
              <td style="text-align: right;">₹${formatAmount(billTotal)}</td>
              <td style="text-align: right; font-weight: 700; color: #0f5132; font-size: 14px;">₹${formatAmount(paidAmount)}</td>
              <td style="text-align: right; color: ${balance > 0 ? '#dc3545' : '#198754'}; font-weight: 600;">
                ₹${formatAmount(balance)}
              </td>
            </tr>
          </tbody>
        </table>

        <div class="totals-section">
          <div class="calculation-box">
            <div class="calculation-row">
              <span>Total Bill Value:</span>
              <span>₹${formatAmount(billTotal)}</span>
            </div>
            <div class="calculation-row grand-total" style="background-color: #e8f5e9 !important;">
              <span>Total Paid Amount:</span>
              <span style="color: #0f5132;">₹${formatAmount(paidAmount)}</span>
            </div>
            <div class="calculation-row">
              <span>Remaining Pending Balance:</span>
              <span>₹${formatAmount(balance)}</span>
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
function handlePrintPaymentsRegister(payments: any[], companyData: any, summary: any) {
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

  let rowsHtml = "";
  payments.forEach((p, idx) => {
    const billTotal = Number(p.amount || 0);
    const paidAmt = Number(p.paid_amount || 0);
    const bal = Math.max(0, round2(billTotal - paidAmt));

    rowsHtml += `
      <tr>
        <td style="text-align: center;">${idx + 1}</td>
        <td style="text-align: center;">${p.payment_date || p.movement_date || "-"}</td>
        <td style="font-weight: 600;">PAY-${p.movement_no}</td>
        <td>${p.movement_no}</td>
        <td>${p.ref_no || "—"}</td>
        <td style="font-weight: 600;">${p.ledger_name || "—"}</td>
        <td style="text-align: center;">${p.payment_mode || "Direct"}</td>
        <td style="text-align: right;">₹${formatAmount(billTotal)}</td>
        <td style="text-align: right; font-weight: 700; color: #0f5132;">₹${formatAmount(paidAmt)}</td>
        <td style="text-align: right; color: ${bal > 0 ? '#dc3545' : '#198754'};">₹${formatAmount(bal)}</td>
        <td style="text-align: center;">${p.payment_status || "Paid"}</td>
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
          <h2>PURCHASE PAYMENTS REGISTER</h2>
          <div class="doc-no">Total Records: ${payments.length}</div>
          <div class="doc-date">Generated: ${new Date().toLocaleDateString("en-IN")}</div>
        </div>

        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 40px; text-align: center;">S.NO</th>
              <th style="width: 90px; text-align: center;">DATE</th>
              <th style="width: 120px;">VOUCHER NO</th>
              <th style="width: 110px;">BILL NO</th>
              <th style="width: 100px;">INV REF</th>
              <th>SUPPLIER NAME</th>
              <th style="width: 100px; text-align: center;">MODE</th>
              <th style="width: 110px; text-align: right;">BILL TOTAL</th>
              <th style="width: 115px; text-align: right;">PAID (₹)</th>
              <th style="width: 110px; text-align: right;">BALANCE</th>
              <th style="width: 80px; text-align: center;">STATUS</th>
            </tr>
          </thead>
          <tbody>
            ${rowsHtml}
          </tbody>
          <tfoot style="font-weight: 700; background-color: #f4f9f6;">
            <tr>
              <td colspan="7" style="text-align: right;">Register Grand Totals:</td>
              <td style="text-align: right;">₹${formatAmount(summary.totalBillAmount)}</td>
              <td style="text-align: right; color: #0f5132; font-size: 13px;">₹${formatAmount(summary.totalPaidAmount)}</td>
              <td style="text-align: right; color: #dc3545;">₹${formatAmount(summary.totalBalance)}</td>
              <td></td>
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

// ──── Edit / Correct Paid Amount Dialog ────
interface EditPaidAmountDialogProps {
  open: boolean;
  onClose: () => void;
  bill: any | null;
  onSuccess?: () => void;
}

function EditPaidAmountDialog({ open, onClose, bill, onSuccess }: EditPaidAmountDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const [paidAmountStr, setPaidAmountStr] = useState<string>("");
  const [paymentDate, setPaymentDate] = useState<string>("");
  const [paymentMode, setPaymentMode] = useState<string>("Bank Transfer");
  const [paymentNotes, setPaymentNotes] = useState<string>("");

  useEffect(() => {
    if (bill && open) {
      setPaidAmountStr(String(Number(bill.paid_amount || 0)));
      setPaymentDate(bill.payment_date || bill.movement_date || new Date().toISOString().split("T")[0]);
      setPaymentMode(bill.payment_mode || "Bank Transfer");
      setPaymentNotes(bill.payment_notes || "");
    }
  }, [bill, open]);

  const billTotal = Number(bill?.amount || 0);
  const newPaidAmount = round2(Number(paidAmountStr) || 0);
  const newPending = round2(Math.max(0, billTotal - newPaidAmount));
  const newStatus =
    newPaidAmount <= 0.001
      ? "Unpaid"
      : billTotal - newPaidAmount <= 0.01
      ? "Paid"
      : "Partial";

  const editMutation = useMutation({
    mutationFn: async () => {
      if (!bill) return;
      if (newPaidAmount < 0) {
        throw new Error("Paid amount cannot be negative.");
      }
      if (newPaidAmount > billTotal + 0.01) {
        throw new Error(`Paid amount cannot exceed total bill amount (${RUPEE}${formatAmount(billTotal)}).`);
      }

      await api.patch(`/stock/inventory/movements/${bill.id}/payment?fy=${activeFY}`, {
        paid_amount: newPaidAmount,
        payment_status: newStatus,
        payment_date: newPaidAmount > 0 ? paymentDate || null : null,
        payment_mode: newPaidAmount > 0 ? paymentMode || null : null,
        payment_notes: paymentNotes || null,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payments"] });
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      if (onSuccess) onSuccess();
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || err.message || "Failed to update payment details.");
    },
  });

  if (!bill) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 1, fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Edit / Correct Purchase Payment</span>
        <Chip label={bill.movement_no} color="primary" variant="outlined" size="small" sx={{ fontWeight: 700 }} />
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2.5 }}>
        {/* Bill Info Card */}
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
              <Typography variant="body2" sx={{ fontWeight: 700 }}>{bill.ledger_name || "—"}</Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Bill Date</Typography>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>{bill.movement_date || "—"}</Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Total Bill Amount</Typography>
              <Typography variant="body1" sx={{ fontWeight: 700 }}>
                {RUPEE}{formatAmount(billTotal)}
              </Typography>
            </Grid>
            <Grid size={{ xs: 6 }}>
              <Typography variant="caption" color="text.secondary">Current Recorded Paid</Typography>
              <Typography
                variant="body1"
                sx={{ fontWeight: 700, color: Number(bill.paid_amount || 0) > 0 ? "success.main" : "text.secondary" }}
              >
                {RUPEE}{formatAmount(Number(bill.paid_amount || 0))}
              </Typography>
            </Grid>
          </Grid>
        </Paper>

        {/* Quick Correction Shortcuts */}
        <Box sx={{ display: "flex", gap: 1, mb: 2, flexWrap: "wrap", alignItems: "center" }}>
          <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary", mr: 0.5 }}>
            Quick Shortcuts:
          </Typography>
          <Button
            size="small"
            variant="outlined"
            color="error"
            onClick={() => setPaidAmountStr("0")}
            sx={{ textTransform: "none", fontSize: 11.5, py: 0.3, px: 1.2, borderRadius: "6px" }}
          >
            Reset to ₹0 (Unpaid)
          </Button>
          <Button
            size="small"
            variant="outlined"
            color="success"
            onClick={() => setPaidAmountStr(String(billTotal))}
            sx={{ textTransform: "none", fontSize: 11.5, py: 0.3, px: 1.2, borderRadius: "6px" }}
          >
            Full Payment ({RUPEE}{formatAmount(billTotal)})
          </Button>
        </Box>

        {/* Form Inputs */}
        <Grid container spacing={2}>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Paid Amount (₹) *"
              type="number"
              fullWidth
              size="small"
              value={paidAmountStr}
              onChange={(e) => setPaidAmountStr(e.target.value)}
              slotProps={{
                inputLabel: { shrink: true },
                htmlInput: { step: "0.01", min: 0, max: billTotal },
              }}
              helperText={`Max: ${RUPEE}${formatAmount(billTotal)}`}
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
              disabled={newPaidAmount <= 0}
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
              disabled={newPaidAmount <= 0}
              slotProps={{ inputLabel: { shrink: true } }}
            >
              {PAYMENT_MODE_OPTIONS.map((m) => (
                <MenuItem key={m} value={m}>{m}</MenuItem>
              ))}
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Payment Notes / Narration"
              fullWidth
              size="small"
              placeholder="e.g. Bank Ref / Cheque No"
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
            <Typography variant="caption" color="text.secondary">Remaining Balance</Typography>
            <Typography variant="h6" sx={{ fontWeight: 800, color: newPending > 0.01 ? "#dc3545" : "success.main" }}>
              {RUPEE}{formatAmount(newPending)}
            </Typography>
          </Box>
          <Box sx={{ textAlign: "right" }}>
            <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Updated Status</Typography>
            {statusChip(newStatus)}
          </Box>
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2.5 }}>
        <Button onClick={onClose} variant="outlined" size="small">
          Cancel
        </Button>
        <Button
          onClick={() => editMutation.mutate()}
          variant="contained"
          size="small"
          color="primary"
          disabled={editMutation.isPending || newPaidAmount < 0 || newPaidAmount > billTotal + 0.01}
          startIcon={<Edit fontSize="small" />}
        >
          {editMutation.isPending ? "Saving..." : "Update Payment"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}

// ──── View Payment & Bill Details Dialog ────
interface ViewPaymentDetailsDialogProps {
  open: boolean;
  onClose: () => void;
  bill: any | null;
  onEdit?: (bill: any) => void;
  onPrint?: (bill: any) => void;
}

function ViewPaymentDetailsDialog({ open, onClose, bill, onEdit, onPrint }: ViewPaymentDetailsDialogProps) {
  if (!bill) return null;

  const billTotal = Number(bill.amount || 0);
  const paidAmt = Number(bill.paid_amount || 0);
  const balance = Math.max(0, round2(billTotal - paidAmt));

  let itemsList: any[] = [];
  if (typeof bill.items === "string") {
    try { itemsList = JSON.parse(bill.items); } catch (e) {}
  } else if (Array.isArray(bill.items)) {
    itemsList = bill.items;
  }

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ pb: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <Payment color="primary" />
          <Typography variant="h6" sx={{ fontWeight: 700 }}>
            Payment & Bill Details — {bill.movement_no}
          </Typography>
        </Box>
        {statusChip(bill.payment_status)}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2.5 }}>
        {/* Main Info Grid */}
        <Grid container spacing={2} sx={{ mb: 2.5 }}>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Supplier Name</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "text.primary" }}>
                {bill.ledger_name || "—"}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Voucher No</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "primary.main" }}>
                PAY-{bill.movement_no}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Date</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700 }}>
                {bill.payment_date || bill.movement_date || "—"}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Mode</Typography>
              <Box sx={{ mt: 0.5 }}>{modeChip(bill.payment_mode || "Direct Payment")}</Box>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Supplier Invoice Ref</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                {bill.ref_no || "—"}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Purchase Bill Date</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                {bill.movement_date || "—"}
              </Typography>
            </Paper>
          </Grid>
        </Grid>

        {/* Payment Amount Strip */}
        <Paper
          variant="outlined"
          sx={{
            p: 2,
            mb: 2.5,
            borderRadius: 2,
            bgcolor: (t) => (t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "#f0fdf4"),
            borderColor: (t) => (t.palette.mode === "dark" ? "divider" : "#bbf7d0"),
          }}
        >
          <Grid container spacing={2} sx={{ alignItems: "center" }}>
            <Grid size={{ xs: 4 }} sx={{ textAlign: "center" }}>
              <Typography variant="caption" color="text.secondary">Total Bill Amount</Typography>
              <Typography variant="h6" sx={{ fontWeight: 700 }}>
                {RUPEE}{formatAmount(billTotal)}
              </Typography>
            </Grid>
            <Grid size={{ xs: 4 }} sx={{ textAlign: "center", borderLeft: "1px solid", borderRight: "1px solid", borderColor: "divider" }}>
              <Typography variant="caption" color="text.secondary">Amount Paid</Typography>
              <Typography variant="h6" sx={{ fontWeight: 800, color: "success.main" }}>
                {RUPEE}{formatAmount(paidAmt)}
              </Typography>
            </Grid>
            <Grid size={{ xs: 4 }} sx={{ textAlign: "center" }}>
              <Typography variant="caption" color="text.secondary">Remaining Balance</Typography>
              <Typography variant="h6" sx={{ fontWeight: 800, color: balance > 0.01 ? "#dc3545" : "success.main" }}>
                {RUPEE}{formatAmount(balance)}
              </Typography>
            </Grid>
          </Grid>
        </Paper>

        {/* Payment Notes */}
        {bill.payment_notes && (
          <Paper variant="outlined" sx={{ p: 1.5, mb: 2.5, borderRadius: 2, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.02)" : "#fff8e1" }}>
            <Typography variant="caption" sx={{ fontWeight: 700, color: "text.secondary" }}>Payment Notes / Transaction Ref:</Typography>
            <Typography variant="body2" sx={{ mt: 0.5, fontStyle: "italic" }}>
              "{bill.payment_notes}"
            </Typography>
          </Paper>
        )}

        {/* Purchased Items List */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1 }}>
          Purchased Items in this Bill:
        </Typography>
        <Paper variant="outlined" sx={{ borderRadius: 2, overflow: "hidden" }}>
          <Table size="small">
            <TableHead>
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f8faf9" }}>
                <TableCell sx={{ fontWeight: 700, width: 40 }}>#</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Item Description</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Quantity</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Rate (₹)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>GST %</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Amount (₹)</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {itemsList.length > 0 ? (
                itemsList.map((item: any, i: number) => (
                  <TableRow key={i} hover>
                    <TableCell>{i + 1}</TableCell>
                    <TableCell sx={{ fontWeight: 600 }}>{item.stock_item_name || item.name || bill.stock_item_name || "Stock Item"}</TableCell>
                    <TableCell align="right">{item.quantity || "—"}</TableCell>
                    <TableCell align="right">{item.rate ? `₹${formatAmount(item.rate)}` : "—"}</TableCell>
                    <TableCell align="right">{item.gst_percent ? `${item.gst_percent}%` : "—"}</TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600 }}>₹{formatAmount(item.amount || (Number(item.quantity || 0) * Number(item.rate || 0)))}</TableCell>
                  </TableRow>
                ))
              ) : (
                <TableRow>
                  <TableCell>1</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>{bill.stock_item_name || "Tools / Consumables Purchase"}</TableCell>
                  <TableCell align="right">{bill.quantity || "—"}</TableCell>
                  <TableCell align="right">{bill.rate ? `₹${formatAmount(bill.rate)}` : "—"}</TableCell>
                  <TableCell align="right">—</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600 }}>₹{formatAmount(bill.amount)}</TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </Paper>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2.5, justifyContent: "space-between" }}>
        <Box sx={{ display: "flex", gap: 1 }}>
          {onPrint && (
            <Button
              variant="outlined"
              size="small"
              startIcon={<Print />}
              onClick={() => onPrint(bill)}
            >
              Print Payment Voucher
            </Button>
          )}
          {onEdit && (
            <Button
              variant="outlined"
              size="small"
              color="primary"
              startIcon={<Edit />}
              onClick={() => {
                onClose();
                onEdit(bill);
              }}
            >
              Edit Payment
            </Button>
          )}
        </Box>
        <Button onClick={onClose} variant="contained" size="small">
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}

// ──── Main Page Component ────
export default function PurchasePaymentsPage() {
  const { activeFY } = useAuthStore();
  const navigate = useNavigate();

  // Dialog States
  const [editingBill, setEditingBill] = useState<any | null>(null);
  const [editDialogOpen, setEditDialogOpen] = useState(false);

  const [viewingBill, setViewingBill] = useState<any | null>(null);
  const [viewDialogOpen, setViewDialogOpen] = useState(false);

  // Filter States
  const [search, setSearch] = useState("");
  const [supplierFilter, setSupplierFilter] = useState<string>("ALL");
  const [modeFilter, setModeFilter] = useState<string>("ALL");
  const [statusFilter, setStatusFilter] = useState<string>("ALL");
  const [fromDate, setFromDate] = useState<string>("");
  const [toDate, setToDate] = useState<string>("");

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["purchase-payments", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward&paid_only=true`)).data,
  });

  // Filter to STRICTLY paid records only (paid_amount > 0)
  const paidMovements = useMemo(() => {
    return movements.filter((m: any) => Number(m.paid_amount || 0) > 0);
  }, [movements]);

  // Unique suppliers list for filter dropdown
  const uniqueSuppliers = useMemo(() => {
    const set = new Set<string>();
    paidMovements.forEach((m: any) => {
      if (m.ledger_name) set.add(m.ledger_name);
    });
    return Array.from(set).sort();
  }, [paidMovements]);

  // Filtered payments list
  const filteredPayments = useMemo(() => {
    return paidMovements.filter((p: any) => {
      // Search text filter
      if (search) {
        const q = search.toLowerCase();
        const matches =
          (p.movement_no && String(p.movement_no).toLowerCase().includes(q)) ||
          (p.ledger_name && String(p.ledger_name).toLowerCase().includes(q)) ||
          (p.ref_no && String(p.ref_no).toLowerCase().includes(q)) ||
          (p.payment_mode && String(p.payment_mode).toLowerCase().includes(q)) ||
          (p.payment_notes && String(p.payment_notes).toLowerCase().includes(q)) ||
          (p.stock_item_name && String(p.stock_item_name).toLowerCase().includes(q));
        if (!matches) return false;
      }

      // Supplier filter
      if (supplierFilter !== "ALL" && p.ledger_name !== supplierFilter) {
        return false;
      }

      // Mode filter
      if (modeFilter !== "ALL" && p.payment_mode !== modeFilter) {
        return false;
      }

      // Status filter
      if (statusFilter !== "ALL") {
        const s = p.payment_status || "Paid";
        if (s !== statusFilter) return false;
      }

      // Date range filter
      const pDate = p.payment_date || p.movement_date;
      if (fromDate && pDate && pDate < fromDate) return false;
      if (toDate && pDate && pDate > toDate) return false;

      return true;
    });
  }, [paidMovements, search, supplierFilter, modeFilter, statusFilter, fromDate, toDate]);

  // Summary Metrics
  const summary = useMemo(() => {
    let totalPaidAmount = 0;
    let totalBillAmount = 0;
    let totalBalance = 0;
    let settledCount = 0;
    let partialCount = 0;

    filteredPayments.forEach((p: any) => {
      const billTot = Number(p.amount || 0);
      const paid = Number(p.paid_amount || 0);
      const bal = Math.max(0, round2(billTot - paid));

      totalPaidAmount += paid;
      totalBillAmount += billTot;
      totalBalance += bal;

      if (bal <= 0.01 || p.payment_status === "Paid") {
        settledCount += 1;
      } else {
        partialCount += 1;
      }
    });

    return {
      totalPaidAmount,
      totalBillAmount,
      totalBalance,
      settledCount,
      partialCount,
      totalCount: filteredPayments.length,
    };
  }, [filteredPayments]);

  const handleOpenEdit = (bill: any) => {
    setEditingBill(bill);
    setEditDialogOpen(true);
  };

  const handleOpenView = (bill: any) => {
    setViewingBill(bill);
    setViewDialogOpen(true);
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
        subtitle="Register of paid purchase bills and supplier payment records"
        breadcrumbs={[{ label: "Purchase" }, { label: "Purchase Payments" }]}
        actions={
          <Box sx={{ display: "flex", gap: 1 }}>
            <Button
              variant="outlined"
              size="small"
              startIcon={<Print />}
              onClick={() => handlePrintPaymentsRegister(filteredPayments, companyData, summary)}
              disabled={filteredPayments.length === 0}
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
            Fully Settled Bills
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {summary.settledCount}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "warning.dark", color: "#fff", minWidth: 140 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Partially Paid Bills
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

      {/* Main Payment Records Table */}
      <Paper variant="outlined" sx={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", borderRadius: 2 }}>
        {isLoading && <LinearProgress />}
        <TableContainer sx={{ flex: 1, overflow: "auto" }}>
          <Table size="small" stickyHeader>
            <TableHead>
              <TableRow sx={{ "& > th": { fontWeight: 700, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.05)" : "#f8faf9" } }}>
                <TableCell sx={{ width: 45, textAlign: "center" }}>#</TableCell>
                <TableCell sx={{ width: 110 }}>Payment Date</TableCell>
                <TableCell sx={{ width: 130 }}>Voucher No</TableCell>
                <TableCell sx={{ width: 120 }}>Purchase Bill No</TableCell>
                <TableCell sx={{ width: 110 }}>Inv Ref No</TableCell>
                <TableCell>Supplier / Party</TableCell>
                <TableCell sx={{ width: 110, textAlign: "center" }}>Mode</TableCell>
                <TableCell align="right" sx={{ width: 120 }}>Bill Total</TableCell>
                <TableCell align="right" sx={{ width: 130 }}>Paid Amount</TableCell>
                <TableCell align="right" sx={{ width: 120 }}>Remaining</TableCell>
                <TableCell align="center" sx={{ width: 90 }}>Status</TableCell>
                <TableCell sx={{ width: 150 }}>Notes / Narration</TableCell>
                <TableCell align="center" sx={{ width: 110 }}>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredPayments.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={13} align="center" sx={{ py: 6 }}>
                    <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 1 }}>
                      <Payment sx={{ fontSize: 48, color: "text.disabled" }} />
                      <Typography variant="subtitle1" sx={{ fontWeight: 600, color: "text.secondary" }}>
                        {paidMovements.length === 0
                          ? "No purchase payment records found."
                          : "No payments match the selected filters."}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        {paidMovements.length === 0
                          ? "Payments recorded against purchase bills in 'Purchase Payables' will automatically appear here."
                          : "Try adjusting or clearing your search and filters."}
                      </Typography>
                      {paidMovements.length === 0 ? (
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
                filteredPayments.map((p: any, idx: number) => {
                  const billTotal = Number(p.amount || 0);
                  const paidAmt = Number(p.paid_amount || 0);
                  const balance = Math.max(0, round2(billTotal - paidAmt));
                  const payDate = p.payment_date || p.movement_date || "—";

                  return (
                    <TableRow key={p.id} hover sx={{ "&:hover": { bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "rgba(22, 196, 127, 0.04)" } }}>
                      <TableCell align="center" sx={{ fontSize: 12, color: "text.secondary" }}>
                        {idx + 1}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, fontWeight: 600, whiteSpace: "nowrap" }}>
                        {payDate}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, fontWeight: 700, color: "primary.main", whiteSpace: "nowrap" }}>
                        PAY-{p.movement_no}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, fontWeight: 600, whiteSpace: "nowrap" }}>
                        {p.movement_no}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, color: p.ref_no ? "text.primary" : "text.secondary", whiteSpace: "nowrap" }}>
                        {p.ref_no || "—"}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12.5, fontWeight: 700 }}>
                        {p.ledger_name || "—"}
                      </TableCell>
                      <TableCell align="center" sx={{ whiteSpace: "nowrap" }}>
                        {modeChip(p.payment_mode || "Direct")}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>
                        {RUPEE}{formatAmount(billTotal)}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 13, fontWeight: 800, color: "success.main" }}>
                        {RUPEE}{formatAmount(paidAmt)}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600, color: balance > 0.01 ? "#dc3545" : "success.main" }}>
                        {balance > 0.01 ? `${RUPEE}${formatAmount(balance)}` : "₹0.00"}
                      </TableCell>
                      <TableCell align="center">
                        {statusChip(p.payment_status || (balance <= 0.01 ? "Paid" : "Partial"))}
                      </TableCell>
                      <TableCell sx={{ fontSize: 11.5, color: "text.secondary", maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                        <Tooltip title={p.payment_notes || ""}>
                          <span>{p.payment_notes || "—"}</span>
                        </Tooltip>
                      </TableCell>
                      <TableCell align="center" sx={{ whiteSpace: "nowrap" }}>
                        <Box sx={{ display: "inline-flex", gap: 0.5 }}>
                          <Tooltip title="View Details">
                            <IconButton
                              size="small"
                              color="info"
                              onClick={() => handleOpenView(p)}
                              sx={{ p: 0.4 }}
                            >
                              <Visibility sx={{ fontSize: 17 }} />
                            </IconButton>
                          </Tooltip>

                          <Tooltip title="Edit / Correct Payment">
                            <IconButton
                              size="small"
                              color="primary"
                              onClick={() => handleOpenEdit(p)}
                              sx={{ p: 0.4 }}
                            >
                              <Edit sx={{ fontSize: 17 }} />
                            </IconButton>
                          </Tooltip>

                          <Tooltip title="Print Payment Voucher">
                            <IconButton
                              size="small"
                              color="success"
                              onClick={() => handlePrintPaymentVoucher(p, companyData)}
                              sx={{ p: 0.4 }}
                            >
                              <Print sx={{ fontSize: 17 }} />
                            </IconButton>
                          </Tooltip>
                        </Box>
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
            {filteredPayments.length > 0 && (
              <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f4f9f6" }}>
                <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                  <TableCell colSpan={7} align="right" sx={{ fontSize: 12 }}>
                    Totals ({filteredPayments.length} payments):
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 12.5, color: "text.secondary" }}>
                    {RUPEE}{formatAmount(summary.totalBillAmount)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 13.5, color: "success.main", fontWeight: 800 }}>
                    {RUPEE}{formatAmount(summary.totalPaidAmount)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 12.5, color: summary.totalBalance > 0 ? "#dc3545" : "success.main" }}>
                    {RUPEE}{formatAmount(summary.totalBalance)}
                  </TableCell>
                  <TableCell colSpan={3} />
                </TableRow>
              </TableFooter>
            )}
          </Table>
        </TableContainer>
      </Paper>

      {/* Edit Payment Dialog */}
      <EditPaidAmountDialog
        open={editDialogOpen}
        onClose={() => {
          setEditDialogOpen(false);
          setEditingBill(null);
        }}
        bill={editingBill}
      />

      {/* View Details Dialog */}
      <ViewPaymentDetailsDialog
        open={viewDialogOpen}
        onClose={() => {
          setViewDialogOpen(false);
          setViewingBill(null);
        }}
        bill={viewingBill}
        onEdit={(b) => handleOpenEdit(b)}
        onPrint={(b) => handlePrintPaymentVoucher(b, companyData)}
      />
    </Box>
  );
}
