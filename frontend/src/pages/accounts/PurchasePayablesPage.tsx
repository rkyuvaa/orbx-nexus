import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, Typography, Chip, MenuItem, Checkbox,
  Divider, Table, TableHead, TableBody, TableRow, TableCell,
  TableContainer, Paper, LinearProgress, Tooltip, IconButton,
  InputAdornment,
} from "@mui/material";
import PaymentIcon from "@mui/icons-material/Payment";
import Refresh from "@mui/icons-material/Refresh";
import Search from "@mui/icons-material/Search";
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

  const totalOwed = purchases.reduce((s, p) => s + Number(p.amount || 0), 0);

  const { register, handleSubmit, watch, setValue, control, reset } = useForm({
    defaultValues: {
      payment_status: isBulk ? "Paid" : (purchases[0]?.payment_status || "Unpaid"),
      paid_amount: "",
      payment_date: new Date().toISOString().split("T")[0],
      payment_mode: isBulk ? "" : (purchases[0]?.payment_mode || ""),
      payment_notes: "",
    },
  });

  const paymentStatus = watch("payment_status");

  useEffect(() => {
    if (paymentStatus === "Paid") {
      setValue("paid_amount", String(isBulk ? totalOwed : Number(purchases[0]?.amount || 0)));
    } else if (paymentStatus === "Unpaid") {
      setValue("paid_amount", "0");
    }
  }, [paymentStatus, isBulk, totalOwed, purchases, setValue]);

  useEffect(() => {
    if (open) {
      reset({
        payment_status: isBulk ? "Paid" : (purchases[0]?.payment_status || "Unpaid"),
        paid_amount: isBulk ? String(totalOwed) : String(Number(purchases[0]?.amount || 0)),
        payment_date: purchases[0]?.payment_date || new Date().toISOString().split("T")[0],
        payment_mode: isBulk ? "" : (purchases[0]?.payment_mode || ""),
        payment_notes: "",
      });
    }
  }, [open, isBulk, purchases, totalOwed, reset]);

  const saveMutation = useMutation({
    mutationFn: async (data: any) => {
      const payload = {
        payment_status: data.payment_status,
        paid_amount: paymentStatus === "Paid"
          ? (isBulk ? totalOwed : Number(purchases[0]?.amount || 0))
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
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 1 }}>
        {isBulk ? `Bulk Payment — ${purchases.length} entries` : `Update Payment — ${purchases[0]?.movement_no}`}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Box sx={{ bgcolor: "action.hover", borderRadius: 2, p: 1.5, mb: 2 }}>
          {isBulk ? (
            <>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>
                {purchases.length} purchase entries selected
              </Typography>
              <Typography variant="caption" color="text.secondary">
                Combined total: {RUPEE}{formatAmount(totalOwed)}
              </Typography>
            </>
          ) : (
            <>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>
                {purchases[0]?.stock_item_name}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                {purchases[0]?.movement_date} · Supplier: {purchases[0]?.ledger_name || DASH} · Total: {RUPEE}{formatAmount(Number(purchases[0]?.amount || 0))}
              </Typography>
            </>
          )}
        </Box>
        <Grid container spacing={2}>
          <Grid size={{ xs: 12 }}>
            <Controller
              name="payment_status"
              control={control}
              render={({ field }) => (
                <TextField select label="Payment Status" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...field}>
                  <MenuItem value="Unpaid">Unpaid</MenuItem>
                  <MenuItem value="Partial">Partial</MenuItem>
                  <MenuItem value="Paid">Paid</MenuItem>
                </TextField>
              )}
            />
          </Grid>
          {(paymentStatus === "Partial" || paymentStatus === "Paid") && (
            <>
              <Grid size={{ xs: 6 }}>
                <TextField
                  label="Paid Amount"
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
              <Grid size={{ xs: 12 }}>
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
            </>
          )}
          <Grid size={{ xs: 12 }}>
            <TextField label="Notes" fullWidth size="small" multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} {...register("payment_notes")} />
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button onClick={handleSubmit((d) => saveMutation.mutate(d))} variant="contained" size="small" color="success" disabled={saveMutation.isPending}>
          {saveMutation.isPending ? "Saving..." : isBulk ? `Pay ${purchases.length} Entries` : "Save Payment"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}

export default function PurchasePayablesPage() {
  const { activeFY } = useAuthStore();
  const [payOpen, setPayOpen] = useState(false);
  const [singleItem, setSingleItem] = useState<any>(null);
  const [selectedIds, setSelectedIds] = useState<Set<number>>(new Set());
  const [search, setSearch] = useState("");

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["purchase-payables", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward`)).data,
  });

  const filtered = useMemo(() => {
    const q = search.toLowerCase();
    if (!q) return movements;
    return movements.filter((m: any) =>
      [m.movement_no, m.stock_item_name, m.ledger_name, m.payment_status].some(
        (v) => v && String(v).toLowerCase().includes(q)
      )
    );
  }, [movements, search]);

  const summary = useMemo(() => {
    const totalAmount = movements.reduce((s: number, m: any) => s + Number(m.amount || 0), 0);
    const totalPaid = movements.reduce((s: number, m: any) => s + Number(m.paid_amount || 0), 0);
    const totalPending = totalAmount - totalPaid;
    const unpaidCount = movements.filter((m: any) => !m.payment_status || m.payment_status === "Unpaid").length;
    return { totalAmount, totalPaid, totalPending, unpaidCount };
  }, [movements]);

  const allIds = filtered.map((m: any) => m.id as number);
  const allChecked = allIds.length > 0 && allIds.every((id: number) => selectedIds.has(id));
  const someChecked = selectedIds.size > 0 && !allChecked;

  const toggleAll = () => {
    if (allChecked) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(allIds));
    }
  };

  const toggleOne = (id: number) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const selectedPurchases = movements.filter((m: any) => selectedIds.has(m.id));

  const openSingle = (row: any) => {
    setSingleItem(row);
    setSelectedIds(new Set());
    setPayOpen(true);
  };

  const openBulk = () => {
    setSingleItem(null);
    setPayOpen(true);
  };

  const handleClose = () => {
    setPayOpen(false);
    setSingleItem(null);
  };

  const dialogPurchases = singleItem ? [singleItem] : selectedPurchases;

  const pills = [
    { label: "Total Payable", value: `${RUPEE}${formatAmount(summary.totalAmount)}`, color: "error.main" },
    { label: "Total Paid", value: `${RUPEE}${formatAmount(summary.totalPaid)}`, color: "success.main" },
    { label: "Pending Balance", value: `${RUPEE}${formatAmount(summary.totalPending)}`, color: "warning.dark" },
    { label: "Unpaid Entries", value: String(summary.unpaidCount), color: "primary.main" },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      <PageHeader
        title="Purchase Payables"
        subtitle="Track and update payment status for your purchases"
        breadcrumbs={[{ label: "Accounts" }, { label: "Payables" }]}
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
            placeholder="Search purchase no, item, supplier..."
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
            {selectedIds.size > 0 ? `${selectedIds.size} selected` : `${filtered.length} entries`}
          </Typography>
          {selectedIds.size > 0 && (
            <Button size="small" variant="contained" color="success" startIcon={<PaymentIcon />} onClick={openBulk} sx={{ textTransform: "none", borderRadius: 2 }}>
              Pay {selectedIds.size} Selected
            </Button>
          )}
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
                <TableCell padding="checkbox" sx={{ width: 48 }}>
                  <Checkbox size="small" checked={allChecked} indeterminate={someChecked} onChange={toggleAll} />
                </TableCell>
                <TableCell sx={{ fontWeight: 700, whiteSpace: "nowrap" }}>Purchase No.</TableCell>
                <TableCell sx={{ fontWeight: 700, whiteSpace: "nowrap" }}>Date</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Stock Item</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Supplier</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "right", whiteSpace: "nowrap" }}>Total ({RUPEE})</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center" }}>Status</TableCell>
                <TableCell sx={{ fontWeight: 700, textAlign: "center", width: 80 }}>Action</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filtered.map((m: any) => (
                <TableRow key={m.id} selected={selectedIds.has(m.id)} hover sx={{ cursor: "pointer" }} onClick={() => toggleOne(m.id)}>
                  <TableCell padding="checkbox" onClick={(e) => e.stopPropagation()}>
                    <Checkbox size="small" checked={selectedIds.has(m.id)} onChange={() => toggleOne(m.id)} />
                  </TableCell>
                  <TableCell sx={{ whiteSpace: "nowrap", color: "primary.main", fontWeight: 600, fontSize: 13 }}>
                    {m.movement_no}
                  </TableCell>
                  <TableCell sx={{ whiteSpace: "nowrap", fontSize: 13 }}>{m.movement_date}</TableCell>
                  <TableCell sx={{ fontSize: 13, maxWidth: 200, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {m.stock_item_name || DASH}
                  </TableCell>
                  <TableCell sx={{ fontSize: 13, whiteSpace: "nowrap" }}>{m.ledger_name || DASH}</TableCell>
                  <TableCell sx={{ textAlign: "right", fontWeight: 600, fontSize: 13, whiteSpace: "nowrap" }}>
                    {RUPEE}{formatAmount(m.amount)}
                  </TableCell>
                  <TableCell sx={{ textAlign: "center" }}>
                    {statusChip(m.payment_status)}
                  </TableCell>
                  <TableCell sx={{ textAlign: "center" }} onClick={(e) => e.stopPropagation()}>
                    <Tooltip title="Update Payment">
                      <IconButton size="small" color="success" onClick={() => openSingle(m)}>
                        <PaymentIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                  </TableCell>
                </TableRow>
              ))}
              {filtered.length === 0 && !isLoading && (
                <TableRow>
                  <TableCell colSpan={8} align="center" sx={{ py: 6, color: "text.secondary" }}>
                    {search ? "No results match your search." : "No purchase entries found."}
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
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