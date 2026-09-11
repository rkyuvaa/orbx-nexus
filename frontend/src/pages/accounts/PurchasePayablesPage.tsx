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
import { useForm, Controller } from "react-hook-form";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

const PAYMENT_MODE_OPTIONS = ["Cash", "Bank Transfer", "Cheque", "UPI", "Other"];

const RUPEE = "\u20B9";
const DASH = "\u2014";

const statusChip = (status: string) => {
  const color = status === "Paid" ? "success" : status === "Partial" ? "warning" : "error";
  return <Chip label={status || "Unpaid"} size="small" color={color} />;
};

interface PaymentDialogProps {
  open: boolean;
  onClose: () => void;
  purchases: any[];
  isBulk: boolean;
}

function PaymentDialog({ open, onClose, purchases, isBulk }: PaymentDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const totalInvoice = purchases.reduce((s, p) => s + Number(p.amount || 0), 0);
  const totalPaid = purchases.reduce((s, p) => s + Number(p.paid_amount || 0), 0);
  const totalPending = Math.max(0, totalInvoice - totalPaid);
  const supplierName = purchases[0]?.ledger_name || "Supplier";

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
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ pb: 1, color: "#0f5132", fontWeight: 700 }}>
        Supplier Ledger & Payment — {supplierName}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        {/* Supplier Complete Ledger / Statement Table (Dr / Cr from Nil) */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#0f5132", mb: 1 }}>
          Supplier Bill-wise Statement (Dr / Cr Statement)
        </Typography>
        <Paper variant="outlined" sx={{ mb: 3, borderRadius: "8px", overflow: "hidden" }}>
          <Table size="small">
            <TableHead sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow>
                <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Voucher No.</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Stock Items</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Invoice Amt (Cr)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Paid (Dr)</TableCell>
                <TableCell align="right" sx={{ fontWeight: 700 }}>Balance (Payable)</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {purchases.map((p) => {
                const amt = Number(p.amount || 0);
                const pd = Number(p.paid_amount || 0);
                const bal = Math.max(0, amt - pd);
                return (
                  <TableRow key={p.id} hover>
                    <TableCell sx={{ fontSize: 12 }}>{p.movement_date}</TableCell>
                    <TableCell sx={{ fontSize: 12, fontWeight: 600, color: "primary.main" }}>{p.movement_no}</TableCell>
                    <TableCell sx={{ fontSize: 12 }}>{p.stock_item_name || DASH}</TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 600 }}>{RUPEE}{formatAmount(amt)}</TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, color: "success.main" }}>{RUPEE}{formatAmount(pd)}</TableCell>
                    <TableCell align="right" sx={{ fontSize: 12, fontWeight: 700, color: bal > 0 ? "#dc3545" : "success.main" }}>
                      {RUPEE}{formatAmount(bal)}
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
            <TableFooter sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700 } }}>
                <TableCell colSpan={3} align="right" sx={{ fontSize: 12 }}>Total Statement Summary:</TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "text.secondary" }}>{RUPEE}{formatAmount(totalInvoice)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 13, color: "success.main" }}>{RUPEE}{formatAmount(totalPaid)}</TableCell>
                <TableCell align="right" sx={{ fontSize: 14, color: "#dc3545" }}>{RUPEE}{formatAmount(totalPending)}</TableCell>
              </TableRow>
            </TableFooter>
          </Table>
        </Paper>

        {/* Record Payment Form */}
        <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#0f5132", mb: 1 }}>
          Record Payment Details
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
      const totalAmount = items.reduce((s, item) => s + Number(item.amount || 0), 0);
      const totalPaid = items.reduce((s, item) => s + Number(item.paid_amount || 0), 0);
      const totalPayable = Math.max(0, totalAmount - totalPaid);
      const pendingItems = items.filter((it) => (Number(it.amount || 0) - Number(it.paid_amount || 0)) > 0.01 && it.payment_status !== "Paid");
      const status = totalPayable <= 0.01 ? "Paid" : (totalPaid > 0 ? "Partial" : "Unpaid");
      return { supplier, items, pendingItems, totalAmount, totalPaid, totalPayable, status };
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

          <FormControlLabel
            control={
              <Switch
                size="small"
                checked={hideZeroPayables}
                onChange={(e) => setHideZeroPayables(e.target.checked)}
                color="error"
              />
            }
            label={<Typography variant="body2" sx={{ fontWeight: 600, color: hideZeroPayables ? "error.main" : "text.secondary" }}>Hide 0 Payables</Typography>}
            sx={{ mr: 1 }}
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
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Invoice Amount ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Paid ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right" }}>Pending Payable ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center" }}>Status</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center", width: 100 }}>Action</TableCell>
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
                  </TableCell>
                </TableRow>
              ))}

              {supplierList.length === 0 && !isLoading && (
                <TableRow>
                  <TableCell colSpan={8} align="center" sx={{ py: 6, color: "text.secondary" }}>
                    {search ? "No supplier matches your search." : (hideZeroPayables ? "No pending supplier payables (> 0)." : "No suppliers found.")}
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
            <TableFooter sx={{ position: "sticky", bottom: 0, bgcolor: (t) => t.palette.mode === "dark" ? "#1e293b" : "#e2e8f0" }}>
              <TableRow sx={{ "& > td": { fontWeight: 700, py: 1.2 } }}>
                <TableCell colSpan={5} sx={{ fontWeight: 700, fontSize: 13, textAlign: "right" }}>
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
      />
    </Box>
  );
}