import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, MenuItem, Typography,
  Divider, Alert,
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";

// ──── Helpers ────

function generateMovementNo(type: "Inward" | "Outward"): string {
  const savedConfig = localStorage.getItem("orbx_print_config");
  if (savedConfig) {
    try {
      const config = JSON.parse(savedConfig);
      if (type === "Inward") {
        const prefix = config.invInwardPrefix || "INV-IN/";
        const nextNo = config.invInwardNextNo || 1;
        const padding = config.invInwardPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}`;
      } else {
        const prefix = config.invOutwardPrefix || "INV-OUT/";
        const nextNo = config.invOutwardNextNo || 1;
        const padding = config.invOutwardPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}`;
      }
    } catch (e) {}
  }
  return type === "Inward"
    ? `INV-IN/${String(1).padStart(4, "0")}`
    : `INV-OUT/${String(1).padStart(4, "0")}`;
}

function incrementMovementNo(type: "Inward" | "Outward") {
  const savedConfig = localStorage.getItem("orbx_print_config");
  if (savedConfig) {
    try {
      const config = JSON.parse(savedConfig);
      const key = type === "Inward" ? "invInwardNextNo" : "invOutwardNextNo";
      if (config[key] !== undefined) {
        config[key] = Number(config[key]) + 1;
        localStorage.setItem("orbx_print_config", JSON.stringify(config));
      }
    } catch (e) {}
  }
}

// ──── Shared Dialog ────

interface MovementDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
  movementType: "Inward" | "Outward";
}

function MovementDialog({ open, onClose, editing, movementType }: MovementDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { data: inventoryBalance = [] } = useQuery({
    queryKey: ["inventory-balance", activeFY],
    queryFn: async () => (await api.get(`/stock/inventory?fy=${activeFY}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  const { data: uoms = [] } = useQuery({
    queryKey: ["uom"],
    queryFn: async () => (await api.get("/products/uom")).data,
  });

  const balanceMap = useMemo(() => {
    const map: Record<number, number> = {};
    inventoryBalance.forEach((i: any) => { map[i.id] = Number(i.balance_qty || 0); });
    return map;
  }, [inventoryBalance]);

  const stockItemMap = useMemo(() => {
    const map: Record<number, any> = {};
    stockItems.forEach((s: any) => { map[s.id] = s; });
    return map;
  }, [stockItems]);

  const { register, handleSubmit, reset, watch, setValue, control, formState: { errors } } = useForm({
    defaultValues: {
      movement_no: "",
      movement_date: new Date().toISOString().split("T")[0],
      stock_item_id: "",
      ledger_id: "",
      quantity: "",
      rate: "",
      amount: "",
      uom_id: "",
      ref_no: "",
      narration: "",
    },
  });

  const qty = watch("quantity");
  const rate = watch("rate");

  // Auto-calc amount
  useEffect(() => {
    const q = Number(qty) || 0;
    const r = Number(rate) || 0;
    if (q > 0 && r > 0) {
      setValue("amount", String(formatAmount(q * r)));
    }
  }, [qty, rate, setValue]);

  // Auto-fill uom when stock item is selected
  const selectedItemId = watch("stock_item_id");
  useEffect(() => {
    if (selectedItemId) {
      const item = stockItemMap[Number(selectedItemId)];
      if (item?.uom_id) setValue("uom_id", String(item.uom_id));
    }
  }, [selectedItemId, stockItemMap, setValue]);

  useEffect(() => {
    if (open) {
      if (editing) {
        reset({
          movement_no: editing.movement_no || "",
          movement_date: editing.movement_date || new Date().toISOString().split("T")[0],
          stock_item_id: String(editing.stock_item_id || ""),
          ledger_id: String(editing.ledger_id || ""),
          quantity: String(editing.quantity || ""),
          rate: String(editing.rate || ""),
          amount: String(editing.amount || ""),
          uom_id: String(editing.uom_id || ""),
          ref_no: editing.ref_no || "",
          narration: editing.narration || "",
        });
      } else {
        reset({
          movement_no: generateMovementNo(movementType),
          movement_date: new Date().toISOString().split("T")[0],
          stock_item_id: "",
          ledger_id: "",
          quantity: "",
          rate: "",
          amount: "",
          uom_id: "",
          ref_no: "",
          narration: "",
        });
      }
    }
  }, [open, editing, reset, movementType]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        movement_type: movementType,
        stock_item_id: Number(data.stock_item_id),
        ledger_id: data.ledger_id ? Number(data.ledger_id) : null,
        quantity: Number(data.quantity) || 0,
        rate: Number(data.rate) || 0,
        amount: Number(data.amount) || 0,
        uom_id: data.uom_id ? Number(data.uom_id) : null,
      };
      return editing
        ? api.put(`/stock/inventory/movements/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/inventory/movements?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      if (!editing) incrementMovementNo(movementType);
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      onClose();
    },
  });

  const currentBalance = selectedItemId ? (balanceMap[Number(selectedItemId)] ?? 0) : null;
  const requestedQty = Number(qty) || 0;
  const willExceed = movementType === "Outward" && currentBalance !== null && requestedQty > currentBalance;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 1 }}>
        {editing ? `Edit ${movementType}` : `New Stock ${movementType}`}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Grid container spacing={2}>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Movement No."
              fullWidth
              size="small"
              {...register("movement_no", { required: "Required" })}
              error={!!errors.movement_no}
              helperText={errors.movement_no?.message as string}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField
              label="Date"
              type="date"
              fullWidth
              size="small"
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("movement_date", { required: "Required" })}
              error={!!errors.movement_date}
            />
          </Grid>

          <Grid size={{ xs: 12 }}>
            <Controller
              name="stock_item_id"
              control={control}
              rules={{ required: "Required" }}
              render={({ field }) => (
                <LazyAutocomplete options={stockItems} getOptionLabel={(o: any) => o.item_code ? `${o.name} (${o.item_code})` : o.name} value={stockItems.find((s: any) => s.id === Number(field.value)) || null} onChange={(_, v) => field.onChange(v ? String(v.id) : "")} renderInput={(params) => <TextField {...params} label="Stock Item (Tool / Consumable)" size="small" error={!!errors.stock_item_id} helperText={errors.stock_item_id?.message as string} />} />
              )}
            />
            {currentBalance !== null && (
              <Typography
                variant="caption"
                sx={{ color: willExceed ? "error.main" : "text.secondary", ml: 0.5 }}
              >
                Current Balance: <strong>{formatQty(currentBalance)}</strong>
                {willExceed && "  ⚠ Exceeds available stock"}
              </Typography>
            )}
          </Grid>

          {movementType === "Inward" && (
            <Grid size={{ xs: 12 }}>
              <Controller
                name="ledger_id"
                control={control}
                render={({ field }) => (
                  <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === Number(field.value)) || null} onChange={(_, v) => field.onChange(v ? String(v.id) : "")} renderInput={(params) => <TextField {...params} label="Supplier / Party (Optional)" size="small" />} />
                )}
              />
            </Grid>
          )}

          {movementType === "Outward" && (
            <Grid size={{ xs: 12 }}>
              <Controller
                name="ledger_id"
                control={control}
                render={({ field }) => (
                  <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === Number(field.value)) || null} onChange={(_, v) => field.onChange(v ? String(v.id) : "")} renderInput={(params) => <TextField {...params} label="Issued To / Party (Optional)" size="small" />} />
                )}
              />
            </Grid>
          )}

          <Grid size={{ xs: 4 }}>
            <TextField
              label="Quantity"
              type="number"
              fullWidth
              size="small"
              slotProps={{ htmlInput: { step: "0.001", min: 0 } }}
              {...register("quantity", { required: "Required" })}
              error={!!errors.quantity}
            />
          </Grid>
          <Grid size={{ xs: 4 }}>
            <TextField
              label="Rate"
              type="number"
              fullWidth
              size="small"
              slotProps={{ htmlInput: { step: "0.01", min: 0 } }}
              {...register("rate")}
            />
          </Grid>
          <Grid size={{ xs: 4 }}>
            <TextField
              label="Amount"
              type="number"
              fullWidth
              size="small"
              slotProps={{ htmlInput: { step: "0.01", min: 0 } }}
              {...register("amount")}
            />
          </Grid>

          <Grid size={{ xs: 6 }}>
            <Controller
              name="uom_id"
              control={control}
              render={({ field }) => (
                <LazyAutocomplete options={uoms} getOptionLabel={(o: any) => `${o.name} (${o.symbol})`} value={uoms.find((u: any) => u.id === Number(field.value)) || null} onChange={(_, v) => field.onChange(v ? String(v.id) : "")} renderInput={(params) => <TextField {...params} label="Unit of Measure" size="small" />} />
              )}
            />
          </Grid>
          <Grid size={{ xs: 6 }}>
            <TextField label="Ref No." fullWidth size="small" {...register("ref_no")} />
          </Grid>

          <Grid size={{ xs: 12 }}>
            <TextField
              label="Narration"
              fullWidth
              size="small"
              multiline
              rows={2}
              {...register("narration")}
            />
          </Grid>

          {willExceed && (
            <Grid size={{ xs: 12 }}>
              <Alert severity="warning" sx={{ py: 0.5 }}>
                Outward quantity ({requestedQty}) exceeds available balance ({formatQty(currentBalance)}).
              </Alert>
            </Grid>
          )}
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button
          onClick={handleSubmit((d) => saveMutation.mutate(d))}
          variant="contained"
          size="small"
          disabled={saveMutation.isPending}
          color={movementType === "Inward" ? "success" : "error"}
        >
          {saveMutation.isPending ? "Saving..." : editing ? "Update" : `Save ${movementType}`}
        </Button>
      </DialogActions>
    </Dialog>
  );
}


// ──── Inventory Inward Page ────

export function InventoryInwardPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["inventory-movements", "Inward", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward`)).data,
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inventory/movements/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
    },
  });

  const totalQty = movements.reduce((acc: number, m: any) => acc + Number(m.quantity || 0), 0);
  const totalValue = movements.reduce((acc: number, m: any) => acc + Number(m.amount || 0), 0);

  const summaryCards = (
    <Box sx={{ display: "flex", gap: 2, mb: 1.5 }}>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "success.main", color: "#fff", minWidth: 140, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Inward Qty</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{formatQty(totalQty)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "success.dark", color: "#fff", minWidth: 160, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Inward Value</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(totalValue)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 120, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Entries</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{movements.length}</Typography>
      </Box>
    </Box>
  );

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Movement No.", width: 150 },
    { field: "movement_date", headerName: "Date", width: 110 },
    { field: "stock_item_name", headerName: "Stock Item", flex: 1, minWidth: 180 },
    { field: "item_code", headerName: "Code", width: 100 },
    { field: "ledger_name", headerName: "Supplier / Party", width: 180 },
    {
      field: "quantity", headerName: "Quantity", width: 110, type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data?.uom_symbol || ""}`,
    },
    {
      field: "rate", headerName: "Rate", width: 100, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    {
      field: "amount", headerName: "Amount", width: 120, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    { field: "ref_no", headerName: "Ref No.", width: 110 },
    {
      headerName: "Actions", width: 110, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => { setEditing(p.data); setOpen(true); }}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => {
              if (window.confirm("Delete this inward entry?")) deleteMutation.mutate(p.data.id);
            }}>
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Stock Inward"
        breadcrumbs={[{ label: "Inventory" }, { label: "Stock Inward" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); setOpen(true); }}
        addLabel="New Inward"
        summaryCards={summaryCards}
      />
      <MovementDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
        movementType="Inward"
      />
    </Box>
  );
}


// ──── Inventory Outward Page ────

export function InventoryOutwardPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["inventory-movements", "Outward", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Outward`)).data,
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inventory/movements/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
    },
  });

  const totalQty = movements.reduce((acc: number, m: any) => acc + Number(m.quantity || 0), 0);
  const totalValue = movements.reduce((acc: number, m: any) => acc + Number(m.amount || 0), 0);

  const summaryCards = (
    <Box sx={{ display: "flex", gap: 2, mb: 1.5 }}>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "error.main", color: "#fff", minWidth: 140, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Outward Qty</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{formatQty(totalQty)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "error.dark", color: "#fff", minWidth: 160, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Outward Value</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(totalValue)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 120, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Entries</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{movements.length}</Typography>
      </Box>
    </Box>
  );

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Movement No.", width: 150 },
    { field: "movement_date", headerName: "Date", width: 110 },
    { field: "stock_item_name", headerName: "Stock Item", flex: 1, minWidth: 180 },
    { field: "item_code", headerName: "Code", width: 100 },
    { field: "ledger_name", headerName: "Issued To / Party", width: 180 },
    {
      field: "quantity", headerName: "Quantity", width: 110, type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data?.uom_symbol || ""}`,
    },
    {
      field: "rate", headerName: "Rate", width: 100, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    {
      field: "amount", headerName: "Amount", width: 120, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    { field: "ref_no", headerName: "Ref No.", width: 110 },
    {
      headerName: "Actions", width: 110, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => { setEditing(p.data); setOpen(true); }}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => {
              if (window.confirm("Delete this outward entry?")) deleteMutation.mutate(p.data.id);
            }}>
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Stock Outward"
        breadcrumbs={[{ label: "Inventory" }, { label: "Stock Outward" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); setOpen(true); }}
        addLabel="New Outward"
        summaryCards={summaryCards}
      />
      <MovementDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
        movementType="Outward"
      />
    </Box>
  );
}
