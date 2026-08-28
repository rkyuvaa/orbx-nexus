import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Tooltip, IconButton,
  Divider
} from "@mui/material";
import PaymentIcon from "@mui/icons-material/Payment";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { formatAmount, formatQty } from "../../utils/format";

const PAYMENT_STATUS_OPTIONS = ["Unpaid", "Partial", "Paid"];
const PAYMENT_MODE_OPTIONS = ["Cash", "Bank Transfer", "Cheque", "UPI", "Other"];

const statusColor = (status: string) => {
  if (status === "Paid") return "success";
  if (status === "Partial") return "warning";
  return "error";
};

interface PaymentDialogProps {
  open: boolean;
  onClose: () => void;
  purchase: any;
}

function PaymentDialog({ open, onClose, purchase }: PaymentDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const { register, handleSubmit, watch, reset, formState: { errors } } = useForm({
    defaultValues: {
      payment_status: purchase?.payment_status || "Unpaid",
      paid_amount: purchase?.paid_amount || "",
      payment_date: purchase?.payment_date || new Date().toISOString().split("T")[0],
      payment_mode: purchase?.payment_mode || "",
      payment_notes: purchase?.payment_notes || "",
    },
  });

  // Reset form when purchase changes
  useState(() => {
    if (purchase) {
      reset({
        payment_status: purchase.payment_status || "Unpaid",
        paid_amount: purchase.paid_amount || "",
        payment_date: purchase.payment_date || new Date().toISOString().split("T")[0],
        payment_mode: purchase.payment_mode || "",
        payment_notes: purchase.payment_notes || "",
      });
    }
  });

  const paymentStatus = watch("payment_status");

  const saveMutation = useMutation({
    mutationFn: (data: any) =>
      api.patch(`/stock/inventory/movements/${purchase.id}/payment?fy=${activeFY}`, {
        ...data,
        paid_amount: Number(data.paid_amount) || 0,
        payment_date: data.payment_date || null,
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["purchase-payables"] });
      onClose();
    },
    onError: (err: any) => {
      alert(err.response?.data?.detail || "Failed to update payment details.");
    },
  });

  if (!purchase) return null;

  const totalAmount = Number(purchase.amount || 0);

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 1 }}>Update Payment — {purchase.movement_no}</DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Box sx={{ bgcolor: "action.hover", borderRadius: 2, p: 1.5, mb: 2 }}>
          <Typography variant="body2" sx={{ fontWeight: 600 }}>{purchase.stock_item_name}</Typography>
          <Typography variant="caption" color="text.secondary">
            {purchase.movement_date} · Supplier: {purchase.ledger_name || "—"} · Total: ₹{formatAmount(totalAmount)}
          </Typography>
        </Box>
        <Grid container spacing={2}>
          <Grid size={{ xs: 12 }}>
            <TextField
              select
              label="Payment Status"
              fullWidth
              size="small"
              slotProps={{ inputLabel: { shrink: true } }}
              defaultValue={purchase?.payment_status || "Unpaid"}
              {...register("payment_status", { required: "Required" })}
              error={!!errors.payment_status}
            >
              {PAYMENT_STATUS_OPTIONS.map((s) => (
                <MenuItem key={s} value={s}>{s}</MenuItem>
              ))}
            </TextField>
          </Grid>
          {(paymentStatus === "Partial" || paymentStatus === "Paid") && (
            <>
              <Grid size={{ xs: 6 }}>
                <TextField
                  label="Paid Amount (₹)"
                  type="number"
                  fullWidth
                  size="small"
                  slotProps={{ inputLabel: { shrink: true }, htmlInput: { step: "0.01", min: 0 } }}
                  {...register("paid_amount")}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  label="Payment Date"
                  type="date"
                  fullWidth
                  size="small"
                  slotProps={{ inputLabel: { shrink: true } }}
                  {...register("payment_date")}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <TextField
                  select
                  label="Payment Mode"
                  fullWidth
                  size="small"
                  slotProps={{ inputLabel: { shrink: true } }}
                  defaultValue={purchase?.payment_mode || ""}
                  {...register("payment_mode")}
                >
                  <MenuItem value="">— Select —</MenuItem>
                  {PAYMENT_MODE_OPTIONS.map((m) => (
                    <MenuItem key={m} value={m}>{m}</MenuItem>
                  ))}
                </TextField>
              </Grid>
            </>
          )}
          <Grid size={{ xs: 12 }}>
            <TextField
              label="Payment Notes"
              fullWidth
              size="small"
              multiline
              rows={2}
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("payment_notes")}
            />
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button
          onClick={handleSubmit((d) => saveMutation.mutate(d))}
          variant="contained"
          size="small"
          color="success"
          disabled={saveMutation.isPending}
        >
          {saveMutation.isPending ? "Saving..." : "Save Payment"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}


export default function PurchasePayablesPage() {
  const { activeFY } = useAuthStore();
  const [payOpen, setPayOpen] = useState(false);
  const [selected, setSelected] = useState<any>(null);

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["purchase-payables", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward`)).data,
  });

  const summary = useMemo(() => {
    const totalAmount = movements.reduce((s: number, m: any) => s + Number(m.amount || 0), 0);
    const totalPaid = movements.reduce((s: number, m: any) => s + Number(m.paid_amount || 0), 0);
    const totalPending = totalAmount - totalPaid;
    const unpaidCount = movements.filter((m: any) => !m.payment_status || m.payment_status === "Unpaid").length;
    return { totalAmount, totalPaid, totalPending, unpaidCount };
  }, [movements]);

  const handlePayClick = (data: any) => {
    setSelected(data);
    setPayOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Purchase No.", width: 150 },
    { field: "movement_date", headerName: "Date", width: 110 },
    { field: "stock_item_name", headerName: "Stock Item", flex: 1, minWidth: 180 },
    { field: "ledger_name", headerName: "Supplier / Party", width: 180 },
    {
      field: "quantity", headerName: "Qty", width: 90, type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
    {
      field: "amount", headerName: "Total (₹)", width: 130, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "—",
    },
    {
      field: "paid_amount", headerName: "Paid (₹)", width: 120, type: "numericColumn",
      valueFormatter: (p) => (p.value && Number(p.value) > 0) ? `₹${formatAmount(p.value)}` : "—",
    },
    {
      field: "payment_status", headerName: "Status", width: 110,
      cellRenderer: (p: any) => {
        const status = p.value || "Unpaid";
        return (
          <Box sx={{ display: "flex", alignItems: "center", height: "100%" }}>
            <Chip label={status} size="small" color={statusColor(status) as any} />
          </Box>
        );
      },
    },
    { field: "payment_date", headerName: "Paid On", width: 110 },
    { field: "payment_mode", headerName: "Mode", width: 120 },
    {
      headerName: "Action", width: 90, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", alignItems: "center", height: "100%" }}>
          <Tooltip title="Update Payment">
            <IconButton size="small" color="success" onClick={() => handlePayClick(p.data)}>
              <PaymentIcon fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  const summaryCards = (
    <Box sx={{ display: "flex", gap: 2, mb: 1.5, flexWrap: "wrap" }}>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "error.main", color: "#fff", minWidth: 150, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Payable</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(summary.totalAmount)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "success.main", color: "#fff", minWidth: 150, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Paid</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(summary.totalPaid)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "warning.dark", color: "#fff", minWidth: 150, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Pending Balance</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(summary.totalPending)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 120, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Unpaid Entries</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{summary.unpaidCount}</Typography>
      </Box>
    </Box>
  );

  return (
    <Box>
      <PageHeader
        title="Purchase Payables"
        subtitle="Track and update payment status for your purchases"
        breadcrumbs={[{ label: "Accounts" }, { label: "Payables" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        summaryCards={summaryCards}
      />
      <PaymentDialog
        open={payOpen}
        onClose={() => setPayOpen(false)}
        purchase={selected}
      />
    </Box>
  );
}
