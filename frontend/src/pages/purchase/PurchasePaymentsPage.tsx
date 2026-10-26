import { useState, useMemo, useEffect, Fragment } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Table, TableHead,
  TableBody, TableFooter, TableRow, TableCell, TableContainer,
  Paper, LinearProgress, Tooltip, IconButton, InputAdornment,
  Divider, Collapse,
} from "@mui/material";
import Refresh from "@mui/icons-material/Refresh";
import Search from "@mui/icons-material/Search";
import Print from "@mui/icons-material/Print";
import Visibility from "@mui/icons-material/Visibility";
import Edit from "@mui/icons-material/Edit";
import Payment from "@mui/icons-material/Payment";
import Clear from "@mui/icons-material/Clear";
import ArrowForward from "@mui/icons-material/ArrowForward";
import KeyboardArrowDown from "@mui/icons-material/KeyboardArrowDown";
import KeyboardArrowRight from "@mui/icons-material/KeyboardArrowRight";
import UnfoldMore from "@mui/icons-material/UnfoldMore";
import UnfoldLess from "@mui/icons-material/UnfoldLess";
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

export interface PaymentGroup {
  groupId: string;
  voucherNo: string;
  supplierName: string;
  paymentDate: string;
  paymentMode: string;
  paymentNotes: string;
  totalBillAmount: number;
  totalPaidAmount: number;
  totalBalance: number;
  status: "Paid" | "Partial";
  bills: any[];
}

// ──── Print Individual Payment Voucher ────
function handlePrintPaymentVoucher(group: PaymentGroup, companyData: any) {
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

  const amountWords = toWords(group.totalPaidAmount);

  let billsRowsHtml = "";
  group.bills.forEach((b, idx) => {
    const bTotal = Number(b.amount || 0);
    const bPaid = Number(b.paid_amount || 0);
    const bBal = Math.max(0, round2(bTotal - bPaid));
    billsRowsHtml += `
      <tr>
        <td style="text-align: center;">${idx + 1}</td>
        <td style="font-weight: 700; color: #0f5132;">${b.movement_no}</td>
        <td style="text-align: center;">${b.movement_date || "—"}</td>
        <td style="text-align: right;">₹${formatAmount(bTotal)}</td>
        <td style="text-align: right; font-weight: 700; color: #0f5132;">₹${formatAmount(bPaid)}</td>
        <td style="text-align: right; color: ${bBal > 0 ? '#dc3545' : '#198754'};">₹${formatAmount(bBal)}</td>
        <td style="text-align: center;">${b.payment_status || (bBal <= 0.01 ? "Paid" : "Partial")}</td>
      </tr>
    `;
  });

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Purchase Payment Voucher - ${group.voucherNo}</title>
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
          <div class="doc-no">Voucher No: <strong>${group.voucherNo}</strong></div>
          <div class="doc-date">Date: <strong>${group.paymentDate}</strong></div>
        </div>

        <div class="voucher-box">
          <div class="voucher-grid">
            <div>
              <div class="voucher-label">Paid To (Supplier / Party)</div>
              <div class="voucher-value" style="font-size: 15px; color: #0f5132;">${group.supplierName}</div>
            </div>
            <div>
              <div class="voucher-label">Payment Mode</div>
              <div class="voucher-value">${group.paymentMode}</div>
            </div>
            <div>
              <div class="voucher-label">Bulk Payment Amount</div>
              <div class="voucher-value" style="font-size: 16px; color: #0f5132;">₹${formatAmount(group.totalPaidAmount)}</div>
            </div>
            <div>
              <div class="voucher-label">Notes / Ref</div>
              <div class="voucher-value">${group.paymentNotes || "—"}</div>
            </div>
          </div>
        </div>

        <h3 style="margin-top: 20px; margin-bottom: 8px; font-size: 13px; color: #0f5132; text-transform: uppercase;">
          Amount Adjusted to Bills (${group.bills.length} Bill${group.bills.length > 1 ? "s" : ""}):
        </h3>
        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 40px; text-align: center;">S.NO</th>
              <th style="width: 130px;">BILL NO</th>
              <th style="width: 100px; text-align: center;">BILL DATE</th>
              <th style="width: 130px; text-align: right;">BILL AMOUNT</th>
              <th style="width: 140px; text-align: right;">AMOUNT ADJUSTED (₹)</th>
              <th style="width: 120px; text-align: right;">BALANCE</th>
              <th style="width: 90px; text-align: center;">STATUS</th>
            </tr>
          </thead>
          <tbody>
            ${billsRowsHtml}
          </tbody>
          <tfoot style="font-weight: 700; background-color: #f4f9f6;">
            <tr>
              <td colspan="3" style="text-align: right;">Total:</td>
              <td style="text-align: right;">₹${formatAmount(group.totalBillAmount)}</td>
              <td style="text-align: right; color: #0f5132; font-size: 13px;">₹${formatAmount(group.totalPaidAmount)}</td>
              <td style="text-align: right; color: ${group.totalBalance > 0 ? '#dc3545' : '#198754'};">₹${formatAmount(group.totalBalance)}</td>
              <td></td>
            </tr>
          </tfoot>
        </table>

        <div class="totals-section">
          <div class="calculation-box">
            <div class="calculation-row">
              <span>Total Bills Value:</span>
              <span>₹${formatAmount(group.totalBillAmount)}</span>
            </div>
            <div class="calculation-row grand-total" style="background-color: #e8f5e9 !important;">
              <span>Total Bulk Amount Paid:</span>
              <span style="color: #0f5132;">₹${formatAmount(group.totalPaidAmount)}</span>
            </div>
            <div class="calculation-row">
              <span>Remaining Balance:</span>
              <span>₹${formatAmount(group.totalBalance)}</span>
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
function handlePrintPaymentsRegister(groups: PaymentGroup[], companyData: any, summary: any) {
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
  let idx = 1;

  groups.forEach((g) => {
    const adjustedList = g.bills
      .map((b) => `<strong>${b.movement_no}</strong> = ₹${formatAmount(b.paid_amount)}`)
      .join("<br/>");

    rowsHtml += `
      <tr style="background-color: #f8faf9; font-size: 12px;">
        <td style="text-align: center;">${idx++}</td>
        <td style="text-align: center;">${g.paymentDate}</td>
        <td style="font-weight: 700; color: #0f5132;">${g.voucherNo}</td>
        <td style="font-weight: 700;">${g.supplierName}</td>
        <td style="text-align: center;">${g.paymentMode}</td>
        <td style="text-align: right; font-weight: 700; font-size: 13px; color: #0f5132;">
          ₹${formatAmount(g.totalPaidAmount)}
        </td>
        <td style="line-height: 1.5;">${adjustedList}</td>
        <td style="text-align: right;">₹${formatAmount(g.totalBillAmount)}</td>
        <td style="text-align: right; color: ${g.totalBalance > 0 ? '#dc3545' : '#198754'};">₹${formatAmount(g.totalBalance)}</td>
        <td style="text-align: center;">${g.status}</td>
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
          <h2>PURCHASE PAYMENTS REGISTER (BILL-WISE ADJUSTED AMOUNTS)</h2>
          <div class="doc-no">Total Payments: ${groups.length}</div>
          <div class="doc-date">Generated: ${new Date().toLocaleDateString("en-IN")}</div>
        </div>

        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important;">
            <tr>
              <th style="width: 35px; text-align: center;">#</th>
              <th style="width: 85px; text-align: center;">DATE</th>
              <th style="width: 120px;">VOUCHER NO</th>
              <th style="width: 140px;">SUPPLIER NAME</th>
              <th style="width: 90px; text-align: center;">MODE</th>
              <th style="width: 120px; text-align: right;">BULK PAID (₹)</th>
              <th>AMOUNT ADJUSTED TO BILLS</th>
              <th style="width: 105px; text-align: right;">BILLS TOTAL</th>
              <th style="width: 95px; text-align: right;">BALANCE</th>
              <th style="width: 75px; text-align: center;">STATUS</th>
            </tr>
          </thead>
          <tbody>
            ${rowsHtml}
          </tbody>
          <tfoot style="font-weight: 700; background-color: #f4f9f6;">
            <tr>
              <td colspan="5" style="text-align: right;">Grand Totals:</td>
              <td style="text-align: right; color: #0f5132; font-size: 13px;">₹${formatAmount(summary.totalPaidAmount)}</td>
              <td></td>
              <td style="text-align: right;">₹${formatAmount(summary.totalBillAmount)}</td>
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

// ──── Multi-Bill Payment Allocation Dialog ────
interface EditPaymentAllocationDialogProps {
  open: boolean;
  onClose: () => void;
  group: PaymentGroup | null;
  onSuccess?: () => void;
}

function EditPaymentAllocationDialog({ open, onClose, group, onSuccess }: EditPaymentAllocationDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const [paymentDate, setPaymentDate] = useState<string>("");
  const [paymentMode, setPaymentMode] = useState<string>("Bank Transfer");
  const [paymentNotes, setPaymentNotes] = useState<string>("");
  const [allocations, setAllocations] = useState<Record<number, string>>({});

  useEffect(() => {
    if (group && open) {
      setPaymentDate(group.paymentDate || new Date().toISOString().split("T")[0]);
      setPaymentMode(group.paymentMode || "Bank Transfer");
      setPaymentNotes(group.paymentNotes || "");

      const allocMap: Record<number, string> = {};
      group.bills.forEach((b) => {
        allocMap[b.id] = String(round2(Number(b.paid_amount || 0)));
      });
      setAllocations(allocMap);
    }
  }, [group, open]);

  const totalAllocated = useMemo(() => {
    return round2(
      Object.values(allocations).reduce((sum, v) => sum + (Number(v) || 0), 0)
    );
  }, [allocations]);

  const handleBillPaidChange = (billId: number, valStr: string, maxBill: number) => {
    const num = Number(valStr);
    if (valStr !== "" && !isNaN(num)) {
      if (num > maxBill) {
        valStr = String(maxBill);
      } else if (num < 0) {
        valStr = "0";
      }
    }
    setAllocations((prev) => ({ ...prev, [billId]: valStr }));
  };

  const handleSetFull = (billId: number, billTotal: number) => {
    setAllocations((prev) => ({ ...prev, [billId]: String(billTotal) }));
  };

  const handleResetZero = (billId: number) => {
    setAllocations((prev) => ({ ...prev, [billId]: "0" }));
  };

  const saveMutation = useMutation({
    mutationFn: async () => {
      if (!group) return;

      const allocList = group.bills.map((b) => {
        const valStr = allocations[b.id] !== undefined ? allocations[b.id] : String(b.paid_amount || 0);
        const newPaid = round2(Number(valStr) || 0);
        const bTotal = Number(b.amount || 0);
        const newStatus =
          newPaid <= 0.001
            ? "Unpaid"
            : bTotal - newPaid <= 0.01
            ? "Paid"
            : "Partial";

        return {
          movement_id: b.id,
          allocated_amount: newPaid,
          paid_amount: newPaid,
          payment_status: newStatus,
        };
      });

      await api.post(`/stock/inventory/movements/batch-payment?fy=${activeFY}`, {
        payment_date: paymentDate || null,
        payment_mode: paymentMode || null,
        payment_notes: paymentNotes || null,
        allocations: allocList,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payments"] });
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      if (onSuccess) onSuccess();
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || err.message || "Failed to update payment allocations.");
    },
  });

  if (!group) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ pb: 1, fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Edit Bill-Wise Payment Adjustment</span>
        <Chip label={group.supplierName} color="primary" variant="outlined" size="small" sx={{ fontWeight: 700 }} />
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        {/* Global Payment Header Details */}
        <Grid container spacing={2} sx={{ mb: 2 }}>
          <Grid size={{ xs: 12, sm: 4 }}>
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
          <Grid size={{ xs: 12, sm: 4 }}>
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
          <Grid size={{ xs: 12, sm: 4 }}>
            <TextField
              label="Payment Notes / Transaction Ref"
              fullWidth
              size="small"
              placeholder="e.g. Bank Ref / Cheque No"
              value={paymentNotes}
              onChange={(e) => setPaymentNotes(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
        </Grid>

        {/* Bill-Wise Adjustment Table */}
        <Box sx={{ mb: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "text.primary" }}>
            Adjust Paid Amount to Bills:
          </Typography>
          <Typography variant="caption" sx={{ color: "text.secondary", fontStyle: "italic" }}>
            Specify which amount is adjusted to each bill
          </Typography>
        </Box>

        <Paper variant="outlined" sx={{ borderRadius: 2, overflow: "hidden", mb: 2 }}>
          <Table size="small">
            <TableHead>
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.05)" : "#f8faf9" }}>
                <TableCell sx={{ fontWeight: 700, width: 40 }}>#</TableCell>
                <TableCell sx={{ fontWeight: 700, width: 120 }}>Bill No</TableCell>
                <TableCell sx={{ fontWeight: 700, width: 100 }}>Bill Date</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Bill Amount (₹)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 170, color: "success.main" }}>
                  Amount Adjusted (₹) *
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 110 }}>Balance (₹)</TableCell>
                <TableCell align="center" sx={{ fontWeight: 700, width: 90 }}>Status</TableCell>
                <TableCell align="center" sx={{ fontWeight: 700, width: 110 }}>Quick Set</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {group.bills.map((bill, i) => {
                const bTotal = Number(bill.amount || 0);
                const curPaidStr = allocations[bill.id] !== undefined ? allocations[bill.id] : String(bill.paid_amount || 0);
                const curPaidNum = round2(Number(curPaidStr) || 0);
                const pending = Math.max(0, round2(bTotal - curPaidNum));
                const resultingStatus =
                  curPaidNum <= 0.001
                    ? "Unpaid"
                    : bTotal - curPaidNum <= 0.01
                    ? "Paid"
                    : "Partial";

                return (
                  <TableRow key={bill.id} hover>
                    <TableCell>{i + 1}</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "primary.main" }}>{bill.movement_no}</TableCell>
                    <TableCell>{bill.movement_date || "—"}</TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600 }}>{RUPEE}{formatAmount(bTotal)}</TableCell>
                    <TableCell align="right">
                      <TextField
                        size="small"
                        type="number"
                        value={curPaidStr}
                        onChange={(e) => handleBillPaidChange(bill.id, e.target.value, bTotal)}
                        slotProps={{
                          htmlInput: {
                            step: "0.01",
                            min: 0,
                            max: bTotal,
                            style: { textAlign: "right", fontWeight: 700, color: curPaidNum > 0 ? "#198754" : "inherit" },
                          },
                        }}
                        sx={{ width: 140 }}
                      />
                    </TableCell>
                    <TableCell align="right" sx={{ fontWeight: 700, color: pending > 0.01 ? "#dc3545" : "success.main" }}>
                      {RUPEE}{formatAmount(pending)}
                    </TableCell>
                    <TableCell align="center">
                      {statusChip(resultingStatus)}
                    </TableCell>
                    <TableCell align="center">
                      <Box sx={{ display: "flex", gap: 0.5, justifyContent: "center" }}>
                        <Button
                          size="small"
                          variant="outlined"
                          color="success"
                          onClick={() => handleSetFull(bill.id, bTotal)}
                          sx={{ textTransform: "none", fontSize: 10, px: 0.8, py: 0.2, minWidth: 40 }}
                        >
                          Full
                        </Button>
                        <Button
                          size="small"
                          variant="outlined"
                          color="error"
                          onClick={() => handleResetZero(bill.id)}
                          sx={{ textTransform: "none", fontSize: 10, px: 0.8, py: 0.2, minWidth: 40 }}
                        >
                          ₹0
                        </Button>
                      </Box>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
            <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f4f9f6" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                <TableCell colSpan={3} align="right" sx={{ fontSize: 12 }}>Total:</TableCell>
                <TableCell align="right" sx={{ fontSize: 12.5 }}>{RUPEE}{formatAmount(group.totalBillAmount)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 13.5, color: "success.main" }}>
                  {RUPEE}{formatAmount(totalAllocated)}
                </TableCell>
                <TableCell align="right" sx={{ fontSize: 12.5, color: (group.totalBillAmount - totalAllocated) > 0.01 ? "#dc3545" : "success.main" }}>
                  {RUPEE}{formatAmount(Math.max(0, round2(group.totalBillAmount - totalAllocated)))}
                </TableCell>
                <TableCell colSpan={2} />
              </TableRow>
            </TableFooter>
          </Table>
        </Paper>

        {/* Total Payment Amount Summary Strip */}
        <Box
          sx={{
            p: 1.5,
            borderRadius: 2,
            bgcolor: (t) => t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4",
            border: "1px solid",
            borderColor: (t) => t.palette.mode === "dark" ? "divider" : "#bbf7d0",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <Box>
            <Typography variant="caption" color="text.secondary">Total Bulk Amount Paid</Typography>
            <Typography variant="h6" sx={{ fontWeight: 800, color: "success.main" }}>
              {RUPEE}{formatAmount(totalAllocated)}
            </Typography>
          </Box>
          <Typography variant="caption" sx={{ color: "text.secondary" }}>
            Adjusted across {group.bills.length} bill{group.bills.length > 1 ? "s" : ""}.
          </Typography>
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
          disabled={saveMutation.isPending}
          startIcon={<Edit fontSize="small" />}
        >
          {saveMutation.isPending ? "Updating..." : `Save Adjustment (${RUPEE}${formatAmount(totalAllocated)})`}
        </Button>
      </DialogActions>
    </Dialog>
  );
}

// ──── View Payment Details Dialog ────
interface ViewPaymentDetailsDialogProps {
  open: boolean;
  onClose: () => void;
  group: PaymentGroup | null;
  onEdit?: (group: PaymentGroup) => void;
  onPrint?: (group: PaymentGroup) => void;
}

function ViewPaymentDetailsDialog({ open, onClose, group, onEdit, onPrint }: ViewPaymentDetailsDialogProps) {
  if (!group) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ pb: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <Payment color="primary" />
          <Typography variant="h6" sx={{ fontWeight: 700 }}>
            Payment Record — {group.voucherNo}
          </Typography>
        </Box>
        {statusChip(group.status)}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2.5 }}>
        {/* Info Grid */}
        <Grid container spacing={2} sx={{ mb: 2.5 }}>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Supplier / Party</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "text.primary" }}>
                {group.supplierName}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Voucher No</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "primary.main" }}>
                {group.voucherNo}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Date</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 700 }}>
                {group.paymentDate}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Payment Mode</Typography>
              <Box sx={{ mt: 0.5 }}>{modeChip(group.paymentMode)}</Box>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Bulk Amount Paid</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 800, color: "success.main" }}>
                {RUPEE}{formatAmount(group.totalPaidAmount)}
              </Typography>
            </Paper>
          </Grid>
          <Grid size={{ xs: 12, sm: 4 }}>
            <Paper variant="outlined" sx={{ p: 1.5, borderRadius: 2 }}>
              <Typography variant="caption" color="text.secondary">Notes / Narration</Typography>
              <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                {group.paymentNotes || "—"}
              </Typography>
            </Paper>
          </Grid>
        </Grid>

        {/* Bill-Wise Adjustment Breakdown */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1, textTransform: "uppercase", fontSize: "0.78rem", letterSpacing: 0.5, color: "primary.main" }}>
          Amount Adjusted to Bills:
        </Typography>
        <Paper variant="outlined" sx={{ borderRadius: 2, overflow: "hidden" }}>
          <Table size="small">
            <TableHead>
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f8faf9" }}>
                <TableCell sx={{ fontWeight: 700, width: 40 }}>#</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Bill No</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Bill Date</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Bill Amount (₹)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, color: "success.main" }}>Amount Adjusted (₹)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Remaining Balance (₹)</TableCell>
                <TableCell align="center" sx={{ fontWeight: 700 }}>Status</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {group.bills.map((b, i) => {
                const bTotal = Number(b.amount || 0);
                const bPaid = Number(b.paid_amount || 0);
                const bBal = Math.max(0, round2(bTotal - bPaid));
                return (
                  <TableRow key={b.id} hover>
                    <TableCell>{i + 1}</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "primary.main" }}>{b.movement_no}</TableCell>
                    <TableCell>{b.movement_date || "—"}</TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600 }}>{RUPEE}{formatAmount(bTotal)}</TableCell>
                    <TableCell align="right" sx={{ fontWeight: 800, color: "success.main" }}>
                      = {RUPEE}{formatAmount(bPaid)}
                    </TableCell>
                    <TableCell align="right" sx={{ fontWeight: 600, color: bBal > 0.01 ? "#dc3545" : "success.main" }}>
                      {RUPEE}{formatAmount(bBal)}
                    </TableCell>
                    <TableCell align="center">{statusChip(b.payment_status)}</TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
            <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f4f9f6" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                <TableCell colSpan={3} align="right" sx={{ fontSize: 12 }}>Total:</TableCell>
                <TableCell align="right" sx={{ fontSize: 12.5 }}>{RUPEE}{formatAmount(group.totalBillAmount)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 13.5, color: "success.main" }}>
                  {RUPEE}{formatAmount(group.totalPaidAmount)}
                </TableCell>
                <TableCell align="right" sx={{ fontSize: 12.5, color: group.totalBalance > 0.01 ? "#dc3545" : "success.main" }}>
                  {RUPEE}{formatAmount(group.totalBalance)}
                </TableCell>
                <TableCell />
              </TableRow>
            </TableFooter>
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
              onClick={() => onPrint(group)}
            >
              Print Voucher
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
                onEdit(group);
              }}
            >
              Edit Adjustment
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
  const [editingGroup, setEditingGroup] = useState<PaymentGroup | null>(null);
  const [editDialogOpen, setEditDialogOpen] = useState(false);

  const [viewingGroup, setViewingGroup] = useState<PaymentGroup | null>(null);
  const [viewDialogOpen, setViewDialogOpen] = useState(false);

  // Expandable row state: map of groupId -> boolean
  const [expandedGroups, setExpandedGroups] = useState<Record<string, boolean>>({});

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

  // Group paid movements into unified Payment Groups (by supplier, date, mode, notes)
  const paymentGroups = useMemo<PaymentGroup[]>(() => {
    const groupsMap: Record<string, any[]> = {};

    paidMovements.forEach((m: any) => {
      const sName = m.ledger_name || "Unknown Supplier";
      const pDate = m.payment_date || m.movement_date || "—";
      const pMode = m.payment_mode || "Direct Payment";
      const pNotes = (m.payment_notes || "").trim();

      // Compound key for grouping bills paid in the same transaction
      const groupKey = `${sName}__${pDate}__${pMode}__${pNotes}`;
      if (!groupsMap[groupKey]) {
        groupsMap[groupKey] = [];
      }
      groupsMap[groupKey].push(m);
    });

    return Object.entries(groupsMap).map(([groupId, bills]) => {
      const first = bills[0];
      const supplierName = first.ledger_name || "Unknown Supplier";
      const paymentDate = first.payment_date || first.movement_date || "—";
      const paymentMode = first.payment_mode || "Direct Payment";
      const paymentNotes = (first.payment_notes || "").trim();

      let totalBillAmount = 0;
      let totalPaidAmount = 0;

      bills.forEach((b: any) => {
        totalBillAmount += Number(b.amount || 0);
        totalPaidAmount += Number(b.paid_amount || 0);
      });

      totalBillAmount = round2(totalBillAmount);
      totalPaidAmount = round2(totalPaidAmount);
      const totalBalance = Math.max(0, round2(totalBillAmount - totalPaidAmount));
      const status: "Paid" | "Partial" = totalBalance <= 0.01 ? "Paid" : "Partial";

      const voucherNo = bills.length === 1
        ? `PAY-${first.movement_no}`
        : `PAY-${first.movement_no}+${bills.length - 1}`;

      return {
        groupId,
        voucherNo,
        supplierName,
        paymentDate,
        paymentMode,
        paymentNotes,
        totalBillAmount,
        totalPaidAmount,
        totalBalance,
        status,
        bills,
      };
    }).sort((a, b) => (a.paymentDate < b.paymentDate ? 1 : -1));
  }, [paidMovements]);

  // Expand / collapse all rows
  const handleToggleExpandAll = () => {
    const allExpanded = paymentGroups.length > 0 && paymentGroups.every((g) => expandedGroups[g.groupId]);
    if (allExpanded) {
      setExpandedGroups({});
    } else {
      const nextMap: Record<string, boolean> = {};
      paymentGroups.forEach((g) => {
        nextMap[g.groupId] = true;
      });
      setExpandedGroups(nextMap);
    }
  };

  const handleToggleRow = (groupId: string) => {
    setExpandedGroups((prev) => ({
      ...prev,
      [groupId]: !prev[groupId],
    }));
  };

  // Unique suppliers list for filter dropdown
  const uniqueSuppliers = useMemo(() => {
    const set = new Set<string>();
    paymentGroups.forEach((g) => set.add(g.supplierName));
    return Array.from(set).sort();
  }, [paymentGroups]);

  // Filtered payment groups
  const filteredGroups = useMemo(() => {
    return paymentGroups.filter((g) => {
      // Search text filter
      if (search) {
        const q = search.toLowerCase();
        const matches =
          g.voucherNo.toLowerCase().includes(q) ||
          g.supplierName.toLowerCase().includes(q) ||
          g.paymentMode.toLowerCase().includes(q) ||
          g.paymentNotes.toLowerCase().includes(q) ||
          g.bills.some(
            (b) =>
              (b.movement_no && String(b.movement_no).toLowerCase().includes(q)) ||
              (b.ref_no && String(b.ref_no).toLowerCase().includes(q))
          );
        if (!matches) return false;
      }

      // Supplier filter
      if (supplierFilter !== "ALL" && g.supplierName !== supplierFilter) {
        return false;
      }

      // Mode filter
      if (modeFilter !== "ALL" && g.paymentMode !== modeFilter) {
        return false;
      }

      // Status filter
      if (statusFilter !== "ALL" && g.status !== statusFilter) {
        return false;
      }

      // Date range filter
      if (fromDate && g.paymentDate && g.paymentDate < fromDate) return false;
      if (toDate && g.paymentDate && g.paymentDate > toDate) return false;

      return true;
    });
  }, [paymentGroups, search, supplierFilter, modeFilter, statusFilter, fromDate, toDate]);

  // Summary Metrics
  const summary = useMemo(() => {
    let totalPaidAmount = 0;
    let totalBillAmount = 0;
    let totalBalance = 0;
    let settledCount = 0;
    let partialCount = 0;
    let totalBillsCount = 0;

    filteredGroups.forEach((g) => {
      totalPaidAmount += g.totalPaidAmount;
      totalBillAmount += g.totalBillAmount;
      totalBalance += g.totalBalance;
      totalBillsCount += g.bills.length;

      if (g.status === "Paid") {
        settledCount += 1;
      } else {
        partialCount += 1;
      }
    });

    return {
      totalPaidAmount: round2(totalPaidAmount),
      totalBillAmount: round2(totalBillAmount),
      totalBalance: round2(totalBalance),
      settledCount,
      partialCount,
      totalGroupsCount: filteredGroups.length,
      totalBillsCount,
    };
  }, [filteredGroups]);

  const handleOpenEdit = (group: PaymentGroup) => {
    setEditingGroup(group);
    setEditDialogOpen(true);
  };

  const handleOpenView = (group: PaymentGroup) => {
    setViewingGroup(group);
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

  const areAllExpanded =
    filteredGroups.length > 0 &&
    filteredGroups.every((g) => expandedGroups[g.groupId]);

  return (
    <Box sx={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      <PageHeader
        title="Purchase Payments"
        subtitle="Register of paid purchase bills showing bulk payment amounts and bill-wise adjustments"
        breadcrumbs={[{ label: "Purchase" }, { label: "Purchase Payments" }]}
        actions={
          <Box sx={{ display: "flex", gap: 1 }}>
            <Button
              variant="outlined"
              size="small"
              startIcon={<Print />}
              onClick={() => handlePrintPaymentsRegister(filteredGroups, companyData, summary)}
              disabled={filteredGroups.length === 0}
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
            {summary.totalGroupsCount}
          </Typography>
        </Box>

        <Box sx={{ px: 2.5, py: 1.2, borderRadius: 2, bgcolor: "#0f5132", color: "#fff", minWidth: 140 }}>
          <Typography variant="caption" sx={{ opacity: 0.9, display: "block", fontWeight: 600 }}>
            Bills Settled
          </Typography>
          <Typography variant="h5" sx={{ fontWeight: 800, lineHeight: 1.3 }}>
            {summary.totalBillsCount}
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

          <Grid size={{ xs: "auto" }} sx={{ ml: "auto" }}>
            <Button
              size="small"
              variant="text"
              startIcon={areAllExpanded ? <UnfoldLess fontSize="small" /> : <UnfoldMore fontSize="small" />}
              onClick={handleToggleExpandAll}
              sx={{ textTransform: "none", fontSize: 12 }}
            >
              {areAllExpanded ? "Collapse All" : "Expand All"}
            </Button>
          </Grid>
        </Grid>
      </Paper>

      {/* Main Master-Detail Payment Records Table */}
      <Paper variant="outlined" sx={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", borderRadius: 2 }}>
        {isLoading && <LinearProgress />}
        <TableContainer sx={{ flex: 1, overflow: "auto" }}>
          <Table size="small" stickyHeader>
            <TableHead>
              <TableRow sx={{ "& > th": { fontWeight: 700, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.05)" : "#f8faf9" } }}>
                <TableCell sx={{ width: 40, textAlign: "center" }} />
                <TableCell sx={{ width: 40, textAlign: "center" }}>#</TableCell>
                <TableCell sx={{ width: 105 }}>Payment Date</TableCell>
                <TableCell sx={{ width: 125 }}>Voucher No</TableCell>
                <TableCell sx={{ width: 150 }}>Supplier / Party</TableCell>
                <TableCell sx={{ width: 100, textAlign: "center" }}>Mode</TableCell>
                <TableCell align="right" sx={{ width: 130 }}>Bulk Paid Amount</TableCell>
                <TableCell sx={{ minWidth: 260 }}>Amount Adjusted to Bills</TableCell>
                <TableCell align="right" sx={{ width: 110 }}>Bills Total</TableCell>
                <TableCell align="right" sx={{ width: 100 }}>Balance</TableCell>
                <TableCell align="center" sx={{ width: 85 }}>Status</TableCell>
                <TableCell sx={{ width: 130 }}>Notes / Ref</TableCell>
                <TableCell align="center" sx={{ width: 105 }}>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredGroups.length === 0 ? (
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
                filteredGroups.map((group, idx) => {
                  const isExpanded = Boolean(expandedGroups[group.groupId]);

                  return (
                    <Fragment key={group.groupId}>
                      {/* Master Payment Row */}
                      <TableRow
                        hover
                        sx={{
                          cursor: "pointer",
                          bgcolor: isExpanded
                            ? (t) => t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "rgba(22, 196, 127, 0.04)"
                            : "inherit",
                          "& > td": { py: 1 },
                        }}
                        onClick={() => handleToggleRow(group.groupId)}
                      >
                        <TableCell align="center" padding="checkbox" onClick={(e) => e.stopPropagation()}>
                          <IconButton
                            size="small"
                            onClick={() => handleToggleRow(group.groupId)}
                            sx={{ p: 0.3 }}
                          >
                            {isExpanded ? <KeyboardArrowDown /> : <KeyboardArrowRight />}
                          </IconButton>
                        </TableCell>
                        <TableCell align="center" sx={{ fontSize: 12, color: "text.secondary" }}>
                          {idx + 1}
                        </TableCell>
                        <TableCell sx={{ fontSize: 12, fontWeight: 600, whiteSpace: "nowrap" }}>
                          {group.paymentDate}
                        </TableCell>
                        <TableCell sx={{ fontSize: 12, fontWeight: 700, color: "primary.main", whiteSpace: "nowrap" }}>
                          {group.voucherNo}
                        </TableCell>
                        <TableCell sx={{ fontSize: 12.5, fontWeight: 700 }}>
                          {group.supplierName}
                        </TableCell>
                        <TableCell align="center" sx={{ whiteSpace: "nowrap" }}>
                          {modeChip(group.paymentMode)}
                        </TableCell>
                        {/* Bulk Paid Amount (Prominent) */}
                        <TableCell align="right" sx={{ fontSize: 13.5, fontWeight: 800, color: "success.main", whiteSpace: "nowrap" }}>
                          {RUPEE}{formatAmount(group.totalPaidAmount)}
                        </TableCell>
                        {/* Amount Adjusted to Bills (Clean & Explicit: bill no 1 = 10000) */}
                        <TableCell sx={{ py: 0.8 }}>
                          <Box sx={{ display: "flex", flexDirection: "column", gap: 0.5 }}>
                            {group.bills.map((b) => (
                              <Box
                                key={b.id}
                                sx={{
                                  display: "inline-flex",
                                  alignItems: "center",
                                  gap: 1,
                                  py: 0.2,
                                  px: 0.75,
                                  borderRadius: 1,
                                  bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.04)" : "#f4fbf7",
                                  border: "1px solid",
                                  borderColor: (t) => t.palette.mode === "dark" ? "divider" : "#d1e7dd",
                                  width: "fit-content",
                                }}
                              >
                                <Typography variant="caption" sx={{ fontWeight: 700, color: "primary.main" }}>
                                  {b.movement_no}
                                </Typography>
                                <Typography variant="caption" sx={{ fontWeight: 800, color: "success.main" }}>
                                  = {RUPEE}{formatAmount(b.paid_amount)}
                                </Typography>
                              </Box>
                            ))}
                          </Box>
                        </TableCell>
                        <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>
                          {RUPEE}{formatAmount(group.totalBillAmount)}
                        </TableCell>
                        <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600, color: group.totalBalance > 0.01 ? "#dc3545" : "success.main" }}>
                          {group.totalBalance > 0.01 ? `${RUPEE}${formatAmount(group.totalBalance)}` : "₹0.00"}
                        </TableCell>
                        <TableCell align="center">
                          {statusChip(group.status)}
                        </TableCell>
                        <TableCell sx={{ fontSize: 11.5, color: "text.secondary", maxWidth: 130, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                          <Tooltip title={group.paymentNotes || ""}>
                            <span>{group.paymentNotes || "—"}</span>
                          </Tooltip>
                        </TableCell>
                        <TableCell align="center" sx={{ whiteSpace: "nowrap" }} onClick={(e) => e.stopPropagation()}>
                          <Box sx={{ display: "inline-flex", gap: 0.5 }}>
                            <Tooltip title="View Adjusted Details">
                              <IconButton
                                size="small"
                                color="info"
                                onClick={() => handleOpenView(group)}
                                sx={{ p: 0.4 }}
                              >
                                <Visibility sx={{ fontSize: 17 }} />
                              </IconButton>
                            </Tooltip>

                            <Tooltip title="Edit Bill-Wise Adjustments">
                              <IconButton
                                size="small"
                                color="primary"
                                onClick={() => handleOpenEdit(group)}
                                sx={{ p: 0.4 }}
                              >
                                <Edit sx={{ fontSize: 17 }} />
                              </IconButton>
                            </Tooltip>

                            <Tooltip title="Print Payment Voucher">
                              <IconButton
                                size="small"
                                color="success"
                                onClick={() => handlePrintPaymentVoucher(group, companyData)}
                                sx={{ p: 0.4 }}
                              >
                                <Print sx={{ fontSize: 17 }} />
                              </IconButton>
                            </Tooltip>
                          </Box>
                        </TableCell>
                      </TableRow>

                      {/* Expandable Detail Table: Amount Adjusted per Bill */}
                      <TableRow sx={{ "& > td": { py: 0, borderBottom: isExpanded ? "1px solid" : "none", borderColor: "divider" } }}>
                        <TableCell colSpan={13} sx={{ p: 0, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(0,0,0,0.18)" : "#fdfefe" }}>
                          <Collapse in={isExpanded} timeout="auto" unmountOnExit>
                            <Box sx={{ py: 1.5, px: 3, pl: 7 }}>
                              <Typography variant="caption" sx={{ fontWeight: 700, color: "primary.main", textTransform: "uppercase", letterSpacing: 0.5, display: "block", mb: 0.75 }}>
                                Amount Adjusted to Bills ({group.bills.length} Bill{group.bills.length > 1 ? "s" : ""}):
                              </Typography>
                              <Paper variant="outlined" sx={{ borderRadius: 1.5, overflow: "hidden", bgcolor: "background.paper" }}>
                                <Table size="small">
                                  <TableHead>
                                    <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.03)" : "#f4f9f6" }}>
                                      <TableCell sx={{ fontWeight: 700, width: 40, fontSize: 11.5 }}>#</TableCell>
                                      <TableCell sx={{ fontWeight: 700, width: 140, fontSize: 11.5 }}>Bill No</TableCell>
                                      <TableCell sx={{ fontWeight: 700, width: 110, fontSize: 11.5 }}>Bill Date</TableCell>
                                      <TableCell align="right" sx={{ fontWeight: 700, width: 130, fontSize: 11.5 }}>Bill Amount (₹)</TableCell>
                                      <TableCell align="right" sx={{ fontWeight: 700, width: 150, fontSize: 11.5, color: "success.main" }}>
                                        Amount Adjusted (Paid) (₹)
                                      </TableCell>
                                      <TableCell align="right" sx={{ fontWeight: 700, width: 120, fontSize: 11.5 }}>Remaining Balance (₹)</TableCell>
                                      <TableCell align="center" sx={{ fontWeight: 700, width: 90, fontSize: 11.5 }}>Status</TableCell>
                                    </TableRow>
                                  </TableHead>
                                  <TableBody>
                                    {group.bills.map((bill: any, bIdx: number) => {
                                      const bTotal = Number(bill.amount || 0);
                                      const bPaid = Number(bill.paid_amount || 0);
                                      const bBal = Math.max(0, round2(bTotal - bPaid));

                                      return (
                                        <TableRow key={bill.id} hover sx={{ "& > td": { py: 0.6 } }}>
                                          <TableCell sx={{ fontSize: 11.5, color: "text.secondary" }}>{bIdx + 1}</TableCell>
                                          <TableCell sx={{ fontSize: 12, fontWeight: 700, color: "primary.main" }}>
                                            {bill.movement_no}
                                          </TableCell>
                                          <TableCell sx={{ fontSize: 11.5 }}>{bill.movement_date || "—"}</TableCell>
                                          <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>
                                            {RUPEE}{formatAmount(bTotal)}
                                          </TableCell>
                                          <TableCell align="right" sx={{ fontSize: 13, fontWeight: 800, color: "success.main" }}>
                                            = {RUPEE}{formatAmount(bPaid)}
                                          </TableCell>
                                          <TableCell align="right" sx={{ fontSize: 11.5, fontWeight: 600, color: bBal > 0.01 ? "#dc3545" : "success.main" }}>
                                            {bBal > 0.01 ? `${RUPEE}${formatAmount(bBal)}` : "₹0.00"}
                                          </TableCell>
                                          <TableCell align="center">
                                            {statusChip(bill.payment_status || (bBal <= 0.01 ? "Paid" : "Partial"))}
                                          </TableCell>
                                        </TableRow>
                                      );
                                    })}
                                  </TableBody>
                                  <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.02)" : "#f8faf9" }}>
                                    <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                                      <TableCell colSpan={3} align="right" sx={{ fontSize: 11.5 }}>Total:</TableCell>
                                      <TableCell align="right" sx={{ fontSize: 12 }}>{RUPEE}{formatAmount(group.totalBillAmount)}</TableCell>
                                      <TableCell align="right" sx={{ fontSize: 13, color: "success.main" }}>
                                        {RUPEE}{formatAmount(group.totalPaidAmount)}
                                      </TableCell>
                                      <TableCell align="right" sx={{ fontSize: 12, color: group.totalBalance > 0.01 ? "#dc3545" : "success.main" }}>
                                        {RUPEE}{formatAmount(group.totalBalance)}
                                      </TableCell>
                                      <TableCell />
                                    </TableRow>
                                  </TableFooter>
                                </Table>
                              </Paper>
                            </Box>
                          </Collapse>
                        </TableCell>
                      </TableRow>
                    </Fragment>
                  );
                })
              )}
            </TableBody>
            {filteredGroups.length > 0 && (
              <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.04)" : "#f4f9f6" }}>
                <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                  <TableCell colSpan={6} align="right" sx={{ fontSize: 12 }}>
                    Totals ({filteredGroups.length} payments, {summary.totalBillsCount} bills):
                  </TableCell>
                  <TableCell align="right" sx={{ fontSize: 13.5, color: "success.main", fontWeight: 800 }}>
                    {RUPEE}{formatAmount(summary.totalPaidAmount)}
                  </TableCell>
                  <TableCell />
                  <TableCell align="right" sx={{ fontSize: 12.5, color: "text.secondary" }}>
                    {RUPEE}{formatAmount(summary.totalBillAmount)}
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

      {/* Multi-Bill Payment Allocation Dialog */}
      <EditPaymentAllocationDialog
        open={editDialogOpen}
        onClose={() => {
          setEditDialogOpen(false);
          setEditingGroup(null);
        }}
        group={editingGroup}
      />

      {/* View Details Dialog */}
      <ViewPaymentDetailsDialog
        open={viewDialogOpen}
        onClose={() => {
          setViewDialogOpen(false);
          setViewingGroup(null);
        }}
        group={viewingGroup}
        onEdit={(g) => handleOpenEdit(g)}
        onPrint={(g) => handlePrintPaymentVoucher(g, companyData)}
      />
    </Box>
  );
}
