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
import { useForm, Controller } from "react-hook-form";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
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

  const logoBase64 = localStorage.getItem("company_logo");
  const logoHtml = (printConfig.showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

  const compData = Array.isArray(companyData) ? companyData[0] : companyData;
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
        <td>${r.particulars}</td>
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
              <th style="width: 40px; text-align: center;">S.NO</th>
              <th style="width: 95px; text-align: center;">DATE</th>
              <th style="width: 110px;">VOUCHER NO</th>
              <th style="width: 110px;">TYPE</th>
              <th>PARTICULARS / DESCRIPTION</th>
              <th style="width: 110px; text-align: right;">DEBIT (DR)</th>
              <th style="width: 110px; text-align: right;">CREDIT (CR)</th>
              <th style="width: 120px; text-align: right;">BALANCE</th>
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
      </body>
    </html>
  `);
  printWindow.document.close();
  printWindow.focus();
  setTimeout(() => {
    printWindow.print();
  }, 400);
}

interface PaymentDialogProps {
  open: boolean;
  onClose: () => void;
  purchases: any[];
  isBulk: boolean;
  companyData: any;
}

function PaymentDialog({ open, onClose, purchases, isBulk, companyData }: PaymentDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const totalInvoice = purchases.reduce((s, p) => s + Number(p.amount || 0), 0);
  const totalPaid = purchases.reduce((s, p) => s + Number(p.paid_amount || 0), 0);
  const totalPending = Math.max(0, totalInvoice - totalPaid);
  const supplierName = purchases[0]?.ledger_name || "Supplier";

  // Build Chronological Date-Wise Detailed Ledger Statement (Dr / Cr / Running Balance)
  const ledgerRows = useMemo(() => {
    const rows: any[] = [];
    purchases.forEach((p) => {
      // 1. Credit entry for Purchase Invoice
      const invAmount = Number(p.amount || 0);
      rows.push({
        date: p.movement_date || "-",
        voucher_no: p.movement_no || "-",
        type: "Purchase Invoice",
        particulars: p.stock_item_name ? `Purchase: ${p.stock_item_name}` : `Purchase ${p.movement_no}`,
        dr: 0,
        cr: invAmount,
        status: p.payment_status,
      });

      // 2. Debit entry for Payment Made (if paid_amount > 0)
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
          status: p.payment_status,
        });
      }
    });

    // Sort chronologically by date
    rows.sort((a, b) => (a.date > b.date ? 1 : a.date < b.date ? -1 : 0));

    // Compute line-by-line running balance
    let running = 0;
    return rows.map((r) => {
      running += r.cr - r.dr;
      return { ...r, balance: running };
    });
  }, [purchases]);

  const { register, handleSubmit, watch, setValue, control, reset } = useForm({
    defaultValues: {
      payment_status: totalPending <= 0.01 ? "Paid" : "Paid",
      paid_amount: String(totalPending),
      payment_date: new Date().toISOString().split("T")[0],
      payment_mode: "Bank Transfer",
      payment_notes: "",
    },
  });

  const paymentStatus = watch("payment_status");

  useEffect(() => {
    if (paymentStatus === "Paid") {
      setValue("paid_amount", String(totalPending));
    } else if (paymentStatus === "Unpaid") {
      setValue("paid_amount", "0");
    }
  }, [paymentStatus, totalPending, setValue]);

  useEffect(() => {
    if (open) {
      reset({
        payment_status: totalPending <= 0.01 ? "Paid" : "Paid",
        paid_amount: String(totalPending),
        payment_date: new Date().toISOString().split("T")[0],
        payment_mode: "Bank Transfer",
        payment_notes: "",
      });
    }
  }, [open, purchases, totalPending, reset]);

  const saveMutation = useMutation({
    mutationFn: async (data: any) => {
      const payload = {
        payment_status: data.payment_status,
        paid_amount: paymentStatus === "Paid"
          ? totalInvoice
          : Number(data.paid_amount) || 0,
        payment_date: data.payment_date || null,
        payment_mode: data.payment_mode || null,
        payment_notes: data.payment_notes || null,
      };
      await Promise.all(
        purchases.map((p) =>
          api.patch(`/stock/inventory/movements/${p.id}/payment?fy=${activeFY}`, payload)
        )
      );
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || "Failed to update payment details.");
    },
  });

  if (!purchases.length) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle sx={{ pb: 1, color: "#0f5132", fontWeight: 700, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span>Supplier Ledger Statement & Payment — {supplierName}</span>
        <Button
          startIcon={<PrintIcon />}
          variant="outlined"
          color="primary"
          size="small"
          onClick={() => handlePrintSupplierLedger({ supplier: supplierName, items: purchases }, companyData)}
        >
          Print Statement
        </Button>
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        {/* Supplier Chronological Date-Wise Detailed Ledger Statement */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#0f5132", mb: 1 }}>
          Supplier Date-Wise Detailed Ledger (Debit / Credit Statement from NIL)
        </Typography>
        <Paper variant="outlined" sx={{ mb: 3, borderRadius: "8px", overflow: "hidden" }}>
          <Table size="small">
            <TableHead sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow>
                <TableCell sx={{ fontWeight: 700, width: 100 }}>Date</TableCell>
                <TableCell sx={{ fontWeight: 700, width: 120 }}>Voucher No.</TableCell>
                <TableCell sx={{ fontWeight: 700, width: 120 }}>Type</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Particulars / Description</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 120 }}>Debit - Paid (Dr)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 120 }}>Credit - Invoice (Cr)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700, width: 130 }}>Running Balance</TableCell>
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
                  <TableCell sx={{ fontSize: 12 }}>{r.particulars}</TableCell>
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
            <TableFooter sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                <TableCell colSpan={4} align="right" sx={{ fontSize: 12 }}>Statement Summary Totals:</TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "success.main" }}>{RUPEE}{formatAmount(totalPaid)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "text.secondary" }}>{RUPEE}{formatAmount(totalInvoice)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 14, color: totalPending > 0 ? "#dc3545" : "success.main" }}>{RUPEE}{formatAmount(totalPending)}</TableCell>
              </TableRow>
            </TableFooter>
          </Table>
        </Paper>

        {/* Record Payment Form */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#0f5132", mb: 1 }}>
          Record New Payment Details
        </Typography>
        <Grid container spacing={2}>
          <Grid size={{ xs: 6 }}>
            <Controller
              name="payment_status"
              control={control}
              render={({ field }) => (
                <TextField select label="Payment Status" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...field}>
                  <MenuItem value="Unpaid">Unpaid</MenuItem>
                  <MenuItem value="Partial">Partial</MenuItem>
                  <MenuItem value="Paid">Paid (Full Payment)</MenuItem>
                </TextField>
              )}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Payment Amount (₹)"
              type="number"
              fullWidth
              size="small"
              slotProps={{
                inputLabel: { shrink: true },
                htmlInput: { step: "0.01", min: 0, readOnly: paymentStatus === "Paid" },
              }}
              {...register("paid_amount")}
              sx={paymentStatus === "Paid" ? { "& .MuiOutlinedInput-root": { bgcolor: "action.disabledBackground" } } : {}}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField label="Payment Date" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...register("payment_date")} />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <Controller
              name="payment_mode"
              control={control}
              render={({ field }) => (
                <TextField select label="Payment Mode" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...field}>
                  <MenuItem value="">— Select —</MenuItem>
                  {PAYMENT_MODE_OPTIONS.map((m) => (
                    <MenuItem key={m} value={m}>{m}</MenuItem>
                  ))}
                </TextField>
              )}
            />
          </Grid>
          <Grid size={{ xs: 12 }}>
            <TextField label="Notes / Narration" fullWidth size="small" multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} {...register("payment_notes")} />
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button onClick={handleSubmit((d) => saveMutation.mutate(d))} variant="contained" size="small" color="success" disabled={saveMutation.isPending}>
          {saveMutation.isPending ? "Saving..." : "Save Payment"}
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
                  <TableCell sx={{ fontWeight: 700, color: "#0f5132", fontSize: 13.5 }}>{row.supplier}</TableCell>
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
            <TableFooter sx={{ position: "sticky", bottom: 0, bgcolor: (t) => t.palette.mode === "dark" ? "#1e293b" : "#e2e8f0" }}>
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

      <PaymentDialog
        open={payOpen}
        onClose={handleClose}
        purchases={dialogPurchases}
        isBulk={dialogPurchases.length > 1}
        companyData={companyData}
      />
    </Box>
  );
}