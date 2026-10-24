import { useState, useMemo, useEffect, Fragment } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Checkbox,
  Divider, Table, TableHead, TableBody, TableFooter, TableRow, TableCell,
  TableContainer, Paper, LinearProgress, Tooltip, IconButton,
  InputAdornment, FormControlLabel, Switch,
} from "@mui/material";
import PaymentIcon from "@mui/icons-material/Payment";
import Refresh from "@mui/icons-material/Refresh";
import Search from "@mui/icons-material/Search";
import ExpandMore from "@mui/icons-material/ExpandMore";
import ExpandLess from "@mui/icons-material/ExpandLess";
import PrintIcon from "@mui/icons-material/Print";
import Visibility from "@mui/icons-material/Visibility";
import { useForm, Controller } from "react-hook-form";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import { useAuthStore, useCompanyStore } from "../../store";
import { formatAmount } from "../../utils/format";
import { COMMON_PRINT_CSS, getPageSizeCSS, getCompanyLogoHtml, PRINT_TRIGGER_SCRIPT, getGlobalPrintFooterHtml } from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";

const PAYMENT_MODE_OPTIONS = ["Cash", "Bank Transfer", "Cheque", "UPI", "Other"];

const RUPEE = "₹";
const DASH = "—";

const statusChip = (status: string) => {
  const color = status === "Paid" ? "success" : status === "Partial" ? "warning" : "error";
  return <Chip label={status || "Unpaid"} size="small" color={color} />;
};

function handlePrintSupplierLedger(supplierRow: any, companyData: any) {
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

  const purchases = supplierRow.items || [];
  const supplierName = supplierRow.supplier || "Supplier";

  const rows: any[] = [];
  purchases.forEach((p: any) => {
    const invAmount = Number(p.amount || 0);
    rows.push({
      date: p.movement_date || "-",
      voucher_no: p.movement_no || "-",
      type: "Purchase Invoice",
      particulars: p.stock_item_name ? `Purchase: ${p.stock_item_name}` : `Purchase ${p.movement_no}`,
      dr: 0,
      cr: invAmount,
    });

    const paidAmt = Number(p.paid_amount || 0);
    if (paidAmt > 0) {
      const pMode = p.payment_mode || "Direct Payment";
      const pNotes = p.payment_notes ? ` (${p.payment_notes})` : "";
      rows.push({
        date: p.payment_date || p.movement_date || "-",
        voucher_no: `PAY-${p.movement_no}`,
        type: "Payment",
        particulars: `Payment via ${pMode}${pNotes}`,
        dr: paidAmt,
        cr: 0,
      });
    }
  });

  rows.sort((a, b) => (a.date > b.date ? 1 : a.date < b.date ? -1 : 0));

  let running = 0;
  const ledgerRows = rows.map((r) => {
    running += r.cr - r.dr;
    return { ...r, balance: running };
  });

  const totalInvoice = purchases.reduce((s: number, p: any) => s + Number(p.amount || 0), 0);
  const totalPaid = purchases.reduce((s: number, p: any) => s + Number(p.paid_amount || 0), 0);
  const totalPending = Math.max(0, totalInvoice - totalPaid);
  const amountInWordsStr = toWords(totalPending);

  let statementHtml = "";
  ledgerRows.forEach((r, idx) => {
    statementHtml += `
      <tr>
        <td style="text-align: center;">${idx + 1}</td>
        <td style="text-align: center;">${r.date}</td>
        <td style="font-weight: 600;">${r.voucher_no}</td>
        <td>${r.type}</td>
        <td style="text-align: right; color: ${r.dr > 0 ? '#198754' : '#6c757d'};">${r.dr > 0 ? `₹${formatAmount(r.dr)}` : '—'}</td>
        <td style="text-align: right;">${r.cr > 0 ? `₹${formatAmount(r.cr)}` : '—'}</td>
        <td style="text-align: right; font-weight: 700; color: ${r.balance > 0 ? '#dc3545' : '#198754'};">₹${formatAmount(r.balance)}</td>
      </tr>
    `;
  });

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Print Supplier Ledger - ${supplierName}</title>
        <style>
          @page { size: ${getPageSizeCSS(printConfig.billPaperSize as any)}; margin: 15mm; }
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

        <div class="title-section">
          <h2>SUPPLIER LEDGER STATEMENT</h2>
          <div class="doc-no">Party Name: ${supplierName}</div>
          <div class="doc-date">Date: ${new Date().toLocaleDateString("en-IN")}</div>
        </div>

        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
            <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
              <th style="width: 50px; text-align: center;">S.NO</th>
              <th style="width: 110px; text-align: center;">DATE</th>
              <th style="width: 140px;">VOUCHER NO</th>
              <th style="width: 140px;">TYPE</th>
              <th style="width: 130px; text-align: right;">DEBIT (DR)</th>
              <th style="width: 130px; text-align: right;">CREDIT (CR)</th>
              <th style="width: 140px; text-align: right;">BALANCE</th>
            </tr>
          </thead>
          <tbody>
            ${statementHtml}
          </tbody>
        </table>

        <div class="totals-section">
          <div class="calculation-box">
            <div class="calculation-row">
              <span>Total Credit (Invoices):</span>
              <span>₹${formatAmount(totalInvoice)}</span>
            </div>
            <div class="calculation-row">
              <span>Total Debit (Payments):</span>
              <span>₹${formatAmount(totalPaid)}</span>
            </div>
            <div class="calculation-row grand-total">
              <span>Net Outstanding Balance:</span>
              <span>₹${formatAmount(totalPending)}</span>
            </div>
          </div>
        </div>

        ${totalPending > 0 && amountInWordsStr ? `
          <div class="bottom-section" style="margin-top: 10px;">
            <div class="narration-box" style="background-color: #f0fdf4 !important; font-weight: 700;">
              <strong>AMOUNT IN WORDS (OUTSTANDING):</strong> ${amountInWordsStr.replace(/^Rupees:\s*/i, "").replace(/\s*Rupees Only$/i, "").trim().toUpperCase()} RUPEES ONLY
            </div>
          </div>
        ` : ""}

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

interface SupplierLedgerReportDialogProps {
  open: boolean;
  onClose: () => void;
  allPurchases: any[];
  companyData: any;
}

function round2(n: number): number {
  return Math.round((n + Number.EPSILON) * 100) / 100;
}

function SupplierLedgerReportDialog({ open, onClose, allPurchases, companyData }: SupplierLedgerReportDialogProps) {
  const totalInvoice = allPurchases.reduce((s, p) => s + Number(p.amount || 0), 0);
  const totalPaid = allPurchases.reduce((s, p) => s + Number(p.paid_amount || 0), 0);
  const totalPending = Math.max(0, round2(totalInvoice - totalPaid));
  const supplierName = allPurchases[0]?.ledger_name || "Supplier";

  const ledgerRows = useMemo(() => {
    const rows: any[] = [];
    allPurchases.forEach((p) => {
      const invAmount = Number(p.amount || 0);
      rows.push({
        date: p.movement_date || "-",
        voucher_no: p.movement_no || "-",
        type: "Purchase Invoice",
        dr: 0,
        cr: invAmount,
        status: p.payment_status,
      });

      const paidAmt = Number(p.paid_amount || 0);
      if (paidAmt > 0) {
        const pMode = p.payment_mode || "Direct Payment";
        const pNotes = p.payment_notes ? ` (${p.payment_notes})` : "";
        rows.push({
          date: p.payment_date || p.movement_date || "-",
          voucher_no: `PAY-${p.movement_no}`,
          type: "Payment",
          dr: paidAmt,
          cr: 0,
          status: p.payment_status,
        });
      }
    });

    rows.sort((a, b) => (a.date > b.date ? 1 : a.date < b.date ? -1 : 0));

    let running = 0;
    return rows.map((r) => {
      running += r.cr - r.dr;
      return { ...r, balance: round2(running) };
    });
  }, [allPurchases]);

  if (!allPurchases.length) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ pb: 1, color: "text.primary", fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Supplier Ledger Statement — {supplierName}</span>
        <Button
          startIcon={<PrintIcon />}
          variant="outlined"
          color="primary"
          size="small"
          onClick={() => handlePrintSupplierLedger({ supplier: supplierName, items: allPurchases }, companyData)}
        >
          Print Statement
        </Button>
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1 }}>
          <Typography variant="subtitle2" sx={{ fontWeight: 700, color: (t) => t.palette.mode === "dark" ? "primary.light" : "#0f5132" }}>
            Date-Wise Detailed Ledger (Debit / Credit Statement from NIL)
          </Typography>
          <Typography variant="caption" color="text.secondary">
            {ledgerRows.length} transactions recorded
          </Typography>
        </Box>
        <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
          <TableContainer sx={{ maxHeight: 420 }}>
            <Table size="small" stickyHeader>
              <TableHead>
                <TableRow>
                  <TableCell sx={{ fontWeight: 700, width: 110 }}>Date</TableCell>
                  <TableCell sx={{ fontWeight: 700, width: 130 }}>Voucher No.</TableCell>
                  <TableCell sx={{ fontWeight: 700, width: 130 }}>Type</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Debit - Paid (Dr)</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Credit - Invoice (Cr)</TableCell>
                  <TableCell align="right" sx={{ fontWeight: 700, width: 140 }}>Running Balance</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {ledgerRows.map((r, idx) => (
                  <TableRow key={idx} hover sx={{ bgcolor: r.type === "Payment" ? "rgba(25, 135, 84, 0.04)" : "inherit" }}>
                    <TableCell sx={{ fontSize: 12, whiteSpace: "nowrap" }}>{r.date}</TableCell>
                    <TableCell sx={{ fontSize: 12, fontWeight: 600, color: "primary.main", whiteSpace: "nowrap" }}>{r.voucher_no}</TableCell>
                    <TableCell sx={{ fontSize: 12 }}>
                      <Chip
                        label={r.type}
                        size="small"
                        color={r.type === "Payment" ? "success" : "default"}
                        variant="outlined"
                        sx={{ height: 20, fontSize: 11, fontWeight: 600 }}
                      />
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600, color: r.dr > 0 ? "success.main" : "text.disabled" }}>
                      {r.dr > 0 ? `${RUPEE}${formatAmount(r.dr)}` : "—"}
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600, color: r.cr > 0 ? "text.primary" : "text.disabled" }}>
                      {r.cr > 0 ? `${RUPEE}${formatAmount(r.cr)}` : "—"}
                    </TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 700, color: r.balance > 0 ? "#dc3545" : "success.main" }}>
                      {RUPEE}{formatAmount(r.balance)}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
              <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f4f9f6" }}>
                <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                  <TableCell colSpan={3} align="right" sx={{ fontSize: 12 }}>Statement Summary Totals:</TableCell>
                  <TableCell align="right" sx={{ fontSize: 13, color: "success.main" }}>{RUPEE}{formatAmount(totalPaid)}</TableCell>
                  <TableCell align="right" sx={{ fontSize: 13, color: "text.secondary" }}>{RUPEE}{formatAmount(totalInvoice)}</TableCell>
                  <TableCell align="right" sx={{ fontSize: 14, color: totalPending > 0 ? "#dc3545" : "success.main" }}>{RUPEE}{formatAmount(totalPending)}</TableCell>
                </TableRow>
              </TableFooter>
            </Table>
          </TableContainer>
        </Paper>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="contained" size="small">Close</Button>
      </DialogActions>
    </Dialog>
  );
}

interface PaymentDialogProps {
  open: boolean;
  onClose: () => void;
  allPurchases: any[];
}

function PaymentDialog({ open, onClose, allPurchases }: PaymentDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const totalInvoice = allPurchases.reduce((s, p) => s + Number(p.amount || 0), 0);
  const totalPaid = allPurchases.reduce((s, p) => s + Number(p.paid_amount || 0), 0);
  const totalPending = Math.max(0, round2(totalInvoice - totalPaid));
  const supplierName = allPurchases[0]?.ledger_name || "Supplier";

  // Pending Bills list for settlement (sorted oldest first)
  const pendingBills = useMemo(() => {
    return allPurchases
      .filter((p) => {
        const pending = round2(Math.max(0, Number(p.amount || 0) - Number(p.paid_amount || 0)));
        return pending > 0.01;
      })
      .sort((a, b) => ((a.movement_date || "") > (b.movement_date || "") ? 1 : -1));
  }, [allPurchases]);

  // Form & Bill Allocation States
  const [paymentAmountStr, setPaymentAmountStr] = useState<string>("");
  const [paymentDate, setPaymentDate] = useState<string>(new Date().toISOString().split("T")[0]);
  const [paymentMode, setPaymentMode] = useState<string>("Bank Transfer");
  const [paymentNotes, setPaymentNotes] = useState<string>("");
  const [allocations, setAllocations] = useState<Record<number, number>>({});
  const [selectedBillIds, setSelectedBillIds] = useState<Set<number>>(new Set());

  useEffect(() => {
    if (open) {
      setPaymentAmountStr(totalPending > 0 ? String(round2(totalPending)) : "");
      setPaymentDate(new Date().toISOString().split("T")[0]);
      setPaymentMode("Bank Transfer");
      setPaymentNotes("");
      setAllocations({});
      setSelectedBillIds(new Set());
    }
  }, [open, totalPending]);

  const totalAllocated = useMemo(() => {
    return round2(Object.values(allocations).reduce((sum, v) => sum + (Number(v) || 0), 0));
  }, [allocations]);

  const paymentAmount = Number(paymentAmountStr) || 0;
  const unallocatedAmount = round2(paymentAmount - totalAllocated);

  // Ticking / unticking a bill
  const handleToggleBill = (bill: any) => {
    const billId = bill.id;
    const isCurrentlySelected = selectedBillIds.has(billId);

    const nextSelected = new Set(selectedBillIds);
    const nextAlloc = { ...allocations };

    if (isCurrentlySelected) {
      nextSelected.delete(billId);
      delete nextAlloc[billId];
    } else {
      const otherAllocated = Array.from(nextSelected).reduce((sum, id) => sum + (nextAlloc[id] || 0), 0);
      const billPending = round2(Math.max(0, Number(bill.amount || 0) - Number(bill.paid_amount || 0)));

      if (paymentAmount <= 0) {
        nextAlloc[billId] = billPending;
        nextSelected.add(billId);
        setPaymentAmountStr(String(round2(otherAllocated + billPending)));
      } else {
        const remainingCapacity = round2(Math.max(0, paymentAmount - otherAllocated));
        const toAllocate = round2(Math.min(billPending, remainingCapacity));
        nextAlloc[billId] = toAllocate;
        nextSelected.add(billId);
      }
    }

    setSelectedBillIds(nextSelected);
    setAllocations(nextAlloc);
  };

  // Manual allocation input change
  const handleAllocationChange = (bill: any, valStr: string) => {
    const billId = bill.id;
    const billPending = round2(Math.max(0, Number(bill.amount || 0) - Number(bill.paid_amount || 0)));
    const num = Number(valStr);

    if (valStr === "" || isNaN(num) || num <= 0) {
      const nextAlloc = { ...allocations };
      delete nextAlloc[billId];
      setAllocations(nextAlloc);
      const nextSel = new Set(selectedBillIds);
      nextSel.delete(billId);
      setSelectedBillIds(nextSel);
      return;
    }

    const clamped = round2(Math.min(num, billPending));
    setAllocations((prev) => ({ ...prev, [billId]: clamped }));
    setSelectedBillIds((prev) => new Set(prev).add(billId));
  };

  // Auto-Allocate (FIFO: Oldest bills first)
  const handleAutoAllocate = () => {
    if (paymentAmount <= 0) return;
    let rem = paymentAmount;
    const nextAlloc: Record<number, number> = {};
    const nextSel = new Set<number>();

    for (const bill of pendingBills) {
      if (rem <= 0) break;
      const billPending = round2(Math.max(0, Number(bill.amount || 0) - Number(bill.paid_amount || 0)));
      const take = round2(Math.min(billPending, rem));
      if (take > 0) {
        nextAlloc[bill.id] = take;
        nextSel.add(bill.id);
        rem = round2(rem - take);
      }
    }

    setAllocations(nextAlloc);
    setSelectedBillIds(nextSel);
  };

  const handleClearSelection = () => {
    setAllocations({});
    setSelectedBillIds(new Set());
  };

  const handleSetAmountToAllocated = () => {
    setPaymentAmountStr(String(totalAllocated));
  };

  const saveMutation = useMutation({
    mutationFn: async () => {
      const allocList = Object.entries(allocations)
        .filter(([_, amt]) => Number(amt) > 0)
        .map(([idStr, amt]) => {
          const mId = Number(idStr);
          const bill = pendingBills.find((b) => b.id === mId);
          const currPaid = Number(bill?.paid_amount || 0);
          const billTotal = Number(bill?.amount || 0);
          const newPaid = round2(currPaid + Number(amt));
          const newStatus = (billTotal - newPaid) <= 0.01 ? "Paid" : "Partial";
          return {
            movement_id: mId,
            allocated_amount: Number(amt),
            paid_amount: newPaid,
            payment_status: newStatus,
          };
        });

      if (allocList.length === 0) {
        throw new Error("Please select at least one bill to allocate payment.");
      }

      await api.post(`/stock/inventory/movements/batch-payment?fy=${activeFY}`, {
        payment_date: paymentDate || null,
        payment_mode: paymentMode || null,
        payment_notes: paymentNotes || null,
        allocations: allocList,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || err.message || "Failed to update payment details.");
    },
  });

  const canSave = totalAllocated > 0 && unallocatedAmount >= -0.01 && !saveMutation.isPending;

  if (!allPurchases.length) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle sx={{ pb: 1, color: "text.primary", fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Record Bill-Wise Payment — {supplierName}</span>
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        {/* Record Bill-Wise Payment Details Form */}
        <Grid container spacing={2} sx={{ mb: 2 }}>
          <Grid size={{ xs: 12, sm: 4 }}>
            <TextField
              label="Paying Amount (₹) *"
              type="number"
              fullWidth
              size="small"
              value={paymentAmountStr}
              onChange={(e) => setPaymentAmountStr(e.target.value)}
              slotProps={{
                inputLabel: { shrink: true },
                htmlInput: { step: "0.01", min: 0 },
              }}
              helperText="Enter total amount to pay, then tick bills below"
            />
          </Grid>
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
        </Grid>

        {/* Bill-Wise Allocation Section */}
        <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1 }}>
          <Box>
            <Typography variant="subtitle2" sx={{ fontWeight: 700, color: (t) => t.palette.mode === "dark" ? "primary.light" : "#0f5132" }}>
              Select Bills to Settle (Bill-Wise Allocation)
            </Typography>
            <Typography variant="caption" color="text.secondary">
              Tick the bills to settle. The last selected bill will automatically take the remaining partial amount.
            </Typography>
          </Box>
          <Box sx={{ display: "flex", gap: 1 }}>
            <Button
              size="small"
              variant="outlined"
              color="primary"
              onClick={handleAutoAllocate}
              disabled={paymentAmount <= 0}
              sx={{ textTransform: "none", fontSize: 11.5, py: 0.3, px: 1.2, borderRadius: "6px" }}
            >
              Auto-Allocate (FIFO)
            </Button>
            <Button
              size="small"
              variant="text"
              color="inherit"
              onClick={handleClearSelection}
              disabled={selectedBillIds.size === 0}
              sx={{ textTransform: "none", fontSize: 11.5, py: 0.3, px: 1 }}
            >
              Clear
            </Button>
          </Box>
        </Box>

        <Paper variant="outlined" sx={{ mb: 2, borderRadius: "8px", overflow: "hidden" }}>
          <Table size="small">
            <TableHead>
              <TableRow sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.05)" : "#f8faf9" }}>
                <TableCell sx={{ width: 44, textAlign: "center", fontWeight: 700 }} padding="checkbox">
                  Select
                </TableCell>
                <TableCell sx={{ fontWeight: 700, width: 120 }}>Bill No.</TableCell>
                <TableCell sx={{ fontWeight: 700, width: 110 }}>Date</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Bill Amount</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 120 }}>Already Paid</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Pending Balance</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 140 }}>Pay Now (₹)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Remaining</TableCell>
                <TableCell align="center" sx={{ fontWeight: 700, width: 100 }}>Status After</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {pendingBills.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={9} align="center" sx={{ py: 3, color: "text.secondary" }}>
                    All bills for this supplier are fully settled (0 pending).
                  </TableCell>
                </TableRow>
              ) : (
                pendingBills.map((bill) => {
                  const billTotal = Number(bill.amount || 0);
                  const alreadyPaid = Number(bill.paid_amount || 0);
                  const pending = round2(Math.max(0, billTotal - alreadyPaid));
                  const isSelected = selectedBillIds.has(bill.id);
                  const allocNow = allocations[bill.id] !== undefined ? allocations[bill.id] : 0;
                  const remaining = round2(Math.max(0, pending - allocNow));
                  const statusAfter = remaining <= 0.01 && isSelected ? "Paid" : (allocNow > 0 ? "Partial" : (alreadyPaid > 0 ? "Partial" : "Unpaid"));

                  return (
                    <TableRow
                      key={bill.id}
                      hover
                      sx={{
                        cursor: "pointer",
                        bgcolor: isSelected
                          ? (t) => t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.12)" : "rgba(22, 196, 127, 0.06)"
                          : "inherit",
                      }}
                      onClick={() => handleToggleBill(bill)}
                    >
                      <TableCell padding="checkbox" align="center" onClick={(e) => e.stopPropagation()}>
                        <Checkbox
                          size="small"
                          checked={isSelected}
                          onChange={() => handleToggleBill(bill)}
                          sx={{ p: 0.5, "&.Mui-checked": { color: "#16C47F" } }}
                        />
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, fontWeight: 700, color: "primary.main", whiteSpace: "nowrap" }}>
                        {bill.movement_no}
                      </TableCell>
                      <TableCell sx={{ fontSize: 12, whiteSpace: "nowrap" }}>
                        {bill.movement_date || "-"}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>
                        {RUPEE}{formatAmount(billTotal)}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, color: alreadyPaid > 0 ? "success.main" : "text.disabled", fontWeight: 600 }}>
                        {alreadyPaid > 0 ? `${RUPEE}${formatAmount(alreadyPaid)}` : "—"}
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, fontWeight: 700, color: "#dc3545" }}>
                        {RUPEE}{formatAmount(pending)}
                      </TableCell>
                      <TableCell align="right" onClick={(e) => e.stopPropagation()}>
                        <TextField
                          size="small"
                          type="number"
                          value={allocations[bill.id] !== undefined ? allocations[bill.id] : ""}
                          onChange={(e) => handleAllocationChange(bill, e.target.value)}
                          placeholder="0.00"
                          slotProps={{
                            htmlInput: {
                              min: 0,
                              max: pending,
                              step: "0.01",
                              style: { textAlign: "right", fontWeight: 700, fontSize: 12, padding: "4px 8px" },
                            },
                          }}
                          disabled={!isSelected}
                          sx={{
                            width: 120,
                            "& .MuiOutlinedInput-root": {
                              borderRadius: "6px",
                              bgcolor: isSelected ? "background.paper" : "action.disabledBackground",
                            },
                          }}
                        />
                      </TableCell>
                      <TableCell align="right" sx={{ fontSize: 12, fontWeight: 700, color: remaining > 0 ? "warning.main" : "success.main" }}>
                        {RUPEE}{formatAmount(remaining)}
                      </TableCell>
                      <TableCell align="center">
                        <Chip
                          size="small"
                          label={statusAfter}
                          color={statusAfter === "Paid" ? "success" : statusAfter === "Partial" ? "warning" : "default"}
                          sx={{ height: 20, fontSize: 11, fontWeight: 600 }}
                        />
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
            <TableFooter sx={{ bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f4f9f6" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                <TableCell colSpan={5} align="right" sx={{ fontSize: 12 }}>
                  Selected Bills Settlement Total:
                </TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "#dc3545" }}>
                  {RUPEE}{formatAmount(totalPending)}
                </TableCell>
                <TableCell align="right" sx={{ fontSize: 14, color: "success.main", fontWeight: 800 }}>
                  {RUPEE}{formatAmount(totalAllocated)}
                </TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "text.secondary" }}>
                  {RUPEE}{formatAmount(Math.max(0, round2(totalPending - totalAllocated)))}
                </TableCell>
                <TableCell />
              </TableRow>
            </TableFooter>
          </Table>
        </Paper>

        {/* Real-time Allocation Summary Strip */}
        <Box
          sx={{
            p: 1.5,
            mb: 2,
            borderRadius: "8px",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            flexWrap: "wrap",
            gap: 1.5,
            bgcolor: (t) =>
              unallocatedAmount < -0.01
                ? "error.dark"
                : unallocatedAmount > 0.01
                ? (t.palette.mode === "dark" ? "rgba(237, 108, 2, 0.15)" : "#fff8e1")
                : (t.palette.mode === "dark" ? "rgba(22, 196, 127, 0.15)" : "#e8f5e9"),
            border: "1px solid",
            borderColor: (t) =>
              unallocatedAmount < -0.01
                ? "error.main"
                : unallocatedAmount > 0.01
                ? "warning.main"
                : "success.main",
          }}
        >
          <Box sx={{ display: "flex", gap: 3, alignItems: "center", flexWrap: "wrap" }}>
            <Box>
              <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>
                Total Payment Amount:
              </Typography>
              <Typography variant="body2" sx={{ fontWeight: 800 }}>
                {RUPEE}{formatAmount(paymentAmount)}
              </Typography>
            </Box>
            <Box>
              <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>
                Allocated to Bills:
              </Typography>
              <Typography variant="body2" sx={{ fontWeight: 800, color: "success.main" }}>
                {RUPEE}{formatAmount(totalAllocated)}
              </Typography>
            </Box>
            <Box>
              <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>
                Unallocated Remaining:
              </Typography>
              <Typography
                variant="body2"
                sx={{
                  fontWeight: 800,
                  color:
                    unallocatedAmount < -0.01
                      ? "error.main"
                      : unallocatedAmount > 0.01
                      ? "warning.main"
                      : "success.main",
                }}
              >
                {RUPEE}{formatAmount(Math.abs(unallocatedAmount))}
                {unallocatedAmount < -0.01 ? " (Exceeded!)" : unallocatedAmount === 0 ? " (All Allocated)" : " (Remaining)"}
              </Typography>
            </Box>
          </Box>

          {unallocatedAmount > 0.01 && totalAllocated > 0 && (
            <Button
              size="small"
              variant="outlined"
              color="warning"
              onClick={handleSetAmountToAllocated}
              sx={{ textTransform: "none", fontSize: 11, py: 0.2, px: 1, borderRadius: "6px" }}
            >
              Set Payment Amount to {RUPEE}{formatAmount(totalAllocated)}
            </Button>
          )}
        </Box>

        <Grid container spacing={2}>
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Notes / Narration"
              fullWidth
              size="small"
              multiline
              rows={2}
              value={paymentNotes}
              onChange={(e) => setPaymentNotes(e.target.value)}
              slotProps={{ inputLabel: { shrink: true } }}
            />
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">
          Cancel
        </Button>
        <Button
          onClick={() => saveMutation.mutate()}
          variant="contained"
          size="small"
          color="success"
          disabled={!canSave}
          startIcon={<PaymentIcon fontSize="small" />}
        >
          {saveMutation.isPending ? "Saving..." : `Save Payment (${RUPEE}${formatAmount(totalAllocated)})`}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
export default function PurchasePayablesPage() {
  const { activeFY } = useAuthStore();
  const [payOpen, setPayOpen] = useState(false);
  const [activeSupplierRow, setActiveSupplierRow] = useState<any>(null);
  const [search, setSearch] = useState("");
  const [hideZeroPayables, setHideZeroPayables] = useState(true);

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["purchase-payables", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward`)).data,
  });

  const supplierList = useMemo(() => {
    const groupsMap: Record<string, any[]> = {};
    movements.forEach((m: any) => {
      const supplierName = m.ledger_name || "Unassigned Supplier";
      if (!groupsMap[supplierName]) groupsMap[supplierName] = [];
      groupsMap[supplierName].push(m);
    });

    let list = Object.entries(groupsMap).map(([supplier, items]) => {
      let totalAmount = 0;
      let totalPaid = 0;
      let totalGst = 0;

      items.forEach((item: any) => {
        totalAmount += Number(item.amount || 0);
        totalPaid += Number(item.paid_amount || 0);

        let itemsList: any[] = [];
        if (typeof item.items === "string") {
          try { itemsList = JSON.parse(item.items); } catch (e) {}
        } else if (Array.isArray(item.items)) {
          itemsList = item.items;
        }

        if (itemsList && itemsList.length > 0) {
          const moveGst = itemsList.reduce((sum: number, it: any) => {
            const q = Number(it.quantity) || 0;
            const r = Number(it.rate) || 0;
            const gstP = Number(it.gst_percent) || 0;
            const taxable = it.taxable_amount !== undefined ? Number(it.taxable_amount) : (q * r);
            return sum + (it.gst_amount !== undefined ? Number(it.gst_amount) : ((taxable * gstP) / 100));
          }, 0);
          totalGst += moveGst;
        } else {
          totalGst += Number(item.gst_amount || 0);
        }
      });

      const totalPayable = Math.max(0, totalAmount - totalPaid);
      const pendingItems = items.filter((it) => (Number(it.amount || 0) - Number(it.paid_amount || 0)) > 0.01 && it.payment_status !== "Paid");
      const status = totalPayable <= 0.01 ? "Paid" : (totalPaid > 0 ? "Partial" : "Unpaid");
      return { supplier, items, pendingItems, totalAmount, totalPaid, totalGst, totalPayable, status };
    });

    if (hideZeroPayables) {
      list = list.filter((g) => g.totalPayable > 0.01);
    }

    const q = search.toLowerCase();
    if (q) {
      list = list.filter((g) =>
        g.supplier.toLowerCase().includes(q) ||
        g.items.some((it: any) => [it.movement_no, it.stock_item_name].some((v) => v && String(v).toLowerCase().includes(q)))
      );
    }

    return list;
  }, [movements, search, hideZeroPayables]);

  const summary = useMemo(() => {
    const totalAmount = movements.reduce((s: number, m: any) => s + Number(m.amount || 0), 0);
    const totalPaid = movements.reduce((s: number, m: any) => s + Number(m.paid_amount || 0), 0);
    const totalPending = Math.max(0, totalAmount - totalPaid);
    const unpaidSupplierCount = supplierList.filter((s) => s.totalPayable > 0.01).length;
    return { totalAmount, totalPaid, totalPending, unpaidSupplierCount };
  }, [movements, supplierList]);

  const totalPendingPayable = useMemo(() => {
    return supplierList.reduce((s, row) => s + row.totalPayable, 0);
  }, [supplierList]);

  const [reportOpen, setReportOpen] = useState(false);
  const [activeReportSupplierRow, setActiveReportSupplierRow] = useState<any>(null);

  const openSupplierReport = (supplierRow: any) => {
    setActiveReportSupplierRow(supplierRow);
    setReportOpen(true);
  };

  const handleCloseReport = () => {
    setReportOpen(false);
    setActiveReportSupplierRow(null);
  };

  const openSupplierPayment = (supplierRow: any) => {
    setActiveSupplierRow(supplierRow);
    setPayOpen(true);
  };

  const handleClose = () => {
    setPayOpen(false);
    setActiveSupplierRow(null);
  };

  const dialogPurchases = activeSupplierRow ? (activeSupplierRow.pendingItems.length > 0 ? activeSupplierRow.pendingItems : activeSupplierRow.items) : [];

  const pills = [
    { label: "Total Pending Payable", value: `${RUPEE}${formatAmount(summary.totalPending)}`, color: "error.main" },
    { label: "Total Paid", value: `${RUPEE}${formatAmount(summary.totalPaid)}`, color: "success.main" },
    { label: "Total Purchase Amount", value: `${RUPEE}${formatAmount(summary.totalAmount)}`, color: "primary.main" },
    { label: "Suppliers Pending", value: String(summary.unpaidSupplierCount), color: "warning.dark" },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      <PageHeader
        title="Purchase Payables"
        subtitle="Track and update payment status per supplier"
        breadcrumbs={[{ label: "Purchase" }, { label: "Purchase Payables" }]}
      />

      <Box sx={{ display: "flex", gap: 2, mb: 1.5, flexWrap: "wrap" }}>
        {pills.map((c) => (
          <Box key={c.label} sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: c.color, color: "#fff", minWidth: 130, textAlign: "center" }}>
            <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>{c.label}</Typography>
            <Typography variant="h6" sx={{ fontWeight: 700, lineHeight: 1.3 }}>{c.value}</Typography>
          </Box>
        ))}
      </Box>

      <Paper variant="outlined" sx={{ borderRadius: 3, flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", minHeight: 0 }}>
        {/* Toolbar */}
        <Box sx={{ px: 2, py: 1, display: "flex", alignItems: "center", gap: 1.5, borderBottom: "1px solid", borderColor: "divider", flexShrink: 0, flexWrap: "wrap" }}>
          <TextField
            placeholder="Search supplier..."
            size="small"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            slotProps={{
              input: {
                startAdornment: (
                  <InputAdornment position="start">
                    <Search sx={{ color: "text.secondary", fontSize: 20 }} />
                  </InputAdornment>
                ),
              },
            }}
            sx={{ width: 280, "& .MuiOutlinedInput-root": { borderRadius: "8px" } }}
          />

          <Typography variant="body2" color="text.secondary" sx={{ flex: 1 }}>
            {supplierList.length} suppliers
          </Typography>

          <Tooltip title="Refresh">
            <IconButton size="small" onClick={() => refetch()}>
              <Refresh fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>

        {isLoading && <LinearProgress />}

        <TableContainer sx={{ flex: 1, overflow: "auto" }}>
          <Table size="small" stickyHeader>
            <TableHead>
              <TableRow>
                <TableCell sx={{ fontWeight: 700, width: 60, textAlign: "center" }}>S.No</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Supplier Name</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center" }}>Pending Bills</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>GST Amount ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Invoice Amount ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Paid ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Pending Payable ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center" }}>Status</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center", width: 140 }}>Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {supplierList.map((row, idx) => (
                <TableRow key={row.supplier} hover>
                  <TableCell align="center" sx={{ fontWeight: 600 }}>{idx + 1}</TableCell>
                  <TableCell sx={{ fontWeight: 700, color: (t) => t.palette.mode === "dark" ? "primary.light" : "#0f5132", fontSize: 13.5 }}>{row.supplier}</TableCell>
                  <TableCell align="center" sx={{ fontSize: 13 }}>
                    <Chip label={`${row.pendingItems.length} bill${row.pendingItems.length === 1 ? '' : 's'}`} size="small" variant="outlined" />
                  </TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600, fontSize: 13, color: "primary.main" }}>
                    {RUPEE}{formatAmount(row.totalGst)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600, fontSize: 13, color: "text.secondary" }}>
                    {RUPEE}{formatAmount(row.totalAmount)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontWeight: 600, fontSize: 13, color: "success.main" }}>
                    {RUPEE}{formatAmount(row.totalPaid)}
                  </TableCell>
                  <TableCell align="right" sx={{ fontWeight: 800, fontSize: 14, color: row.totalPayable > 0 ? "#dc3545" : "success.main" }}>
                    {RUPEE}{formatAmount(row.totalPayable)}
                  </TableCell>
                  <TableCell align="center">
                    {statusChip(row.status)}
                  </TableCell>
                  <TableCell align="center">
                    <Box sx={{ display: "flex", gap: 0.5, justifyContent: "center", alignItems: "center" }}>
                      <Tooltip title={`View Statement for ${row.supplier}`}>
                        <IconButton
                          size="small"
                          color="info"
                          onClick={() => openSupplierReport(row)}
                        >
                          <Visibility fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title={`Print Ledger Statement for ${row.supplier}`}>
                        <IconButton
                          size="small"
                          color="primary"
                          onClick={() => handlePrintSupplierLedger(row, companyData)}
                        >
                          <PrintIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title={`Pay ${row.supplier}`}>
                        <Button
                          size="small"
                          variant="contained"
                          color="success"
                          startIcon={<PaymentIcon fontSize="small" />}
                          onClick={() => openSupplierPayment(row)}
                          sx={{ textTransform: "none", fontSize: 12, py: 0.5, px: 1.5, borderRadius: 2 }}
                        >
                          Pay
                        </Button>
                      </Tooltip>
                    </Box>
                  </TableCell>
                </TableRow>
              ))}

              {supplierList.length === 0 && !isLoading && (
                <TableRow>
                  <TableCell colSpan={9} align="center" sx={{ py: 6, color: "text.secondary" }}>
                    {search ? "No supplier matches your search." : "No pending supplier payables (> 0)."}
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
            <TableFooter sx={{ position: "sticky", bottom: 0, bgcolor: (t) => t.palette.mode === "dark" ? "background.paper" : "#e2e8f0" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700, py: 1.2 } }}>
                <TableCell colSpan={6} sx={{ fontWeight: 700, fontSize: 13, textAlign: "right" }}>
                  Total Pending Supplier Payable:
                </TableCell>
                <TableCell sx={{ fontWeight: 800, fontSize: 15, textAlign: "right", color: "#dc3545" }}>
                  {RUPEE}{formatAmount(totalPendingPayable)}
                </TableCell>
                <TableCell colSpan={2} />
              </TableRow>
            </TableFooter>
          </Table>
        </TableContainer>
      </Paper>

      <SupplierLedgerReportDialog
        open={reportOpen}
        onClose={handleCloseReport}
        allPurchases={activeReportSupplierRow?.items || []}
        companyData={companyData}
      />

      <PaymentDialog
        open={payOpen}
        onClose={handleClose}
        allPurchases={activeSupplierRow?.items || []}
      />
    </Box>
  );
}