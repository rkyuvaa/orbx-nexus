import { useState, useMemo } from "react";
import { 
  Box, Typography, Chip, Button, Dialog, DialogTitle, 
  DialogContent, DialogActions, TextField, Grid, IconButton, 
  Tooltip, MenuItem, Divider, Table, TableHead, TableRow, TableCell, TableBody
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Visibility from "@mui/icons-material/Visibility";
import { useForm, Controller } from "react-hook-form";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid, { ColDef } from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { formatQty, formatAmount } from "../../utils/format";

export default function StockItemsPage() {
  const { activeFY, user } = useAuthStore();
  const isAdmin = user?.role === "Admin";
  const qc = useQueryClient();

  // Create/Edit Dialog State
  const [open, setOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<any>(null);

  // View Details Dialog State
  const [viewingItem, setViewingItem] = useState<any>(null);

  // Form setup
  const { register, handleSubmit, control, reset, formState: { errors } } = useForm();

  // 1. Fetch live stock values with inward/outward totals
  const { data: stockItemsBalance = [], isLoading, refetch } = useQuery({
    queryKey: ["stock-items-balance", activeFY],
    queryFn: async () => (await api.get(`/stock/inventory?fy=${activeFY}`)).data,
  });

  // 2. Fetch UoM list for dropdown
  const { data: uoms = [] } = useQuery({
    queryKey: ["uom"],
    queryFn: async () => (await api.get("/products/uom")).data,
  });

  // 3. Fetch movement history for viewing dialog
  const { data: movements = [], isLoading: isMovementsLoading } = useQuery({
    queryKey: ["item-movements", viewingItem?.id, activeFY],
    queryFn: async () => {
      if (!viewingItem?.id) return [];
      return (await api.get(`/stock/inventory/movements?stock_item_id=${viewingItem.id}&fy=${activeFY}`)).data;
    },
    enabled: !!viewingItem?.id,
  });

  // Save (Create/Update) Mutation
  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        name: formData.name,
        item_code: formData.item_code || null,
        uom_id: formData.uom_id ? Number(formData.uom_id) : null,
        opening_stock: Number(formData.opening_stock || 0),
        reorder_level: Number(formData.reorder_level || 0),
      };
      return editingItem
        ? api.put(`/products/stock-items/${editingItem.id}`, payload)
        : api.post("/products/stock-items", payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      qc.invalidateQueries({ queryKey: ["stock-items"] });
      setOpen(false);
    },
  });

  // Delete Mutation
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/products/stock-items/${id}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      qc.invalidateQueries({ queryKey: ["stock-items"] });
    },
  });

  const handleOpenCreate = () => {
    setEditingItem(null);
    reset({
      name: "",
      item_code: "",
      uom_id: "",
      opening_stock: 0,
      reorder_level: 0,
    });
    setOpen(true);
  };

  const handleOpenEdit = (item: any) => {
    let uomId = item.uom_id;
    if (!uomId && item.uom_symbol && uoms.length > 0) {
      const matched = uoms.find((u: any) => u.symbol === item.uom_symbol);
      if (matched) uomId = matched.id;
    }
    setEditingItem(item);
    reset({
      name: item.name,
      item_code: item.item_code || "",
      uom_id: uomId || "",
      opening_stock: item.opening_stock ?? 0,
      reorder_level: item.reorder_level ?? 0,
    });
    setOpen(true);
  };

  const onSave = (formData: any) => {
    saveMutation.mutate(formData);
  };

  const colDefs: ColDef[] = [
    { field: "name", headerName: "Tool / Consumable", flex: 2, minWidth: 200 },
    { field: "item_code", headerName: "Code", width: 110 },
    { field: "uom_symbol", headerName: "UoM", width: 80 },
    {
      field: "opening_stock", headerName: "Opening Qty", width: 120, type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
    {
      field: "total_inward", headerName: "Total Inward", width: 120, type: "numericColumn",
      cellRenderer: (p: any) => (
        <Typography variant="body2" sx={{ color: "success.main", fontWeight: 500 }}>
          +{formatQty(p.value)}
        </Typography>
      ),
    },
    {
      field: "total_outward", headerName: "Total Outward", width: 120, type: "numericColumn",
      cellRenderer: (p: any) => (
        <Typography variant="body2" sx={{ color: "error.main", fontWeight: 500 }}>
          -{formatQty(p.value)}
        </Typography>
      ),
    },
    {
      field: "balance_qty", headerName: "Balance Qty", width: 140, type: "numericColumn",
      cellRenderer: (p: any) => {
        const balance = Number(p.value || 0);
        const reorder = Number(p.data?.reorder_level || 0);
        const isLow = reorder > 0 && balance <= reorder;
        return (
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.5, height: "100%" }}>
            <Typography variant="body2" sx={{ fontWeight: 700, color: isLow ? "warning.main" : "text.primary" }}>
              {formatQty(balance)}
            </Typography>
            {isLow && <Chip label="Low" size="small" color="warning" sx={{ height: 18, fontSize: 10 }} />}
          </Box>
        );
      },
    },
    {
      field: "reorder_level", headerName: "Reorder Level", width: 130, type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
    {
      headerName: "Actions",
      width: 130,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="View Details">
            <IconButton size="small" onClick={() => setViewingItem(p.data)}>
              <Visibility fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => handleOpenEdit(p.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => {
              if (window.confirm(`Are you sure you want to delete "${p.data.name}"?`)) {
                deleteMutation.mutate(p.data.id);
              }
            }}>
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader
        title="Tools & Consumables"
        breadcrumbs={[{ label: "Inventory" }, { label: "Tools & Consumables" }]}
        actions={
          <Button variant="contained" size="small" onClick={handleOpenCreate}>
            New Item
          </Button>
        }
      />
      <OrbxGrid
        rowData={stockItemsBalance}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
      />

      {/* ──── CREATE/EDIT DIALOG ──── */}
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ pb: 1 }}>
          {editingItem ? `Edit Tool / Consumable` : `New Tool / Consumable`}
        </DialogTitle>
        <Divider />
        <form onSubmit={handleSubmit(onSave)}>
          <DialogContent sx={{ pt: 2 }}>
            <Grid container spacing={2}>
              <Grid size={{ xs: 12 }}>
                <TextField
                  label="Name"
                  fullWidth
                  size="small"
                  {...register("name", { required: "Name is required" })}
                  error={!!errors.name}
                  helperText={errors.name?.message as string}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  label="Item Code"
                  fullWidth
                  size="small"
                  {...register("item_code")}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <Controller
                  name="uom_id"
                  control={control}
                  rules={{ required: "Unit of Measure is required" }}
                  render={({ field }) => (
                    <TextField
                      select
                      label="Unit of Measure"
                      fullWidth
                      size="small"
                      {...field}
                      error={!!errors.uom_id}
                      helperText={errors.uom_id?.message as string}
                    >
                      {uoms.map((u: any) => (
                        <MenuItem key={u.id} value={u.id}>
                          {u.name} ({u.symbol})
                        </MenuItem>
                      ))}
                    </TextField>
                  )}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  type="number"
                  label="Opening Stock"
                  fullWidth
                  size="small"
                  disabled={!isAdmin}
                  {...register("opening_stock")}
                  slotProps={{ htmlInput: { step: "any" } }}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  type="number"
                  label="Reorder Level"
                  fullWidth
                  size="small"
                  {...register("reorder_level")}
                  slotProps={{ htmlInput: { step: "any" } }}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <Divider />
          <DialogActions>
            <Button onClick={() => setOpen(false)} size="small" variant="outlined">
              Cancel
            </Button>
            <Button type="submit" size="small" variant="contained" loading={saveMutation.isPending}>
              Save
            </Button>
          </DialogActions>
        </form>
      </Dialog>

      {/* ──── VIEW DETAILS DIALOG ──── */}
      <Dialog open={!!viewingItem} onClose={() => setViewingItem(null)} maxWidth="md" fullWidth>
        <DialogTitle sx={{ pb: 1, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <Typography variant="h6" sx={{ fontWeight: 700 }}>
            {viewingItem?.name} Details
          </Typography>
          <Box>
            <Chip 
              label={`Balance: ${formatQty(viewingItem?.balance_qty)} ${viewingItem?.uom_symbol || ""}`} 
              color={Number(viewingItem?.balance_qty) <= Number(viewingItem?.reorder_level || 0) && Number(viewingItem?.reorder_level || 0) > 0 ? "warning" : "success"}
              sx={{ fontWeight: 700 }}
            />
          </Box>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ pt: 2 }}>
          <Grid container spacing={2} sx={{ mb: 3 }}>
            <Grid size={{ xs: 3 }}>
              <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Item Code</Typography>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>{viewingItem?.item_code || "-"}</Typography>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Unit of Measure</Typography>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>{viewingItem?.uom_symbol || "-"}</Typography>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Opening Stock Qty</Typography>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>{formatQty(viewingItem?.opening_stock)}</Typography>
            </Grid>
            <Grid size={{ xs: 3 }}>
              <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>Reorder Level</Typography>
              <Typography variant="body2" sx={{ fontWeight: 600 }}>{formatQty(viewingItem?.reorder_level)}</Typography>
            </Grid>
          </Grid>

          <Divider sx={{ mb: 2 }} />

          <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1.5, color: "primary.main" }}>
            Stock Movement History
          </Typography>

          {isMovementsLoading ? (
            <Typography variant="body2" color="text.secondary">Loading movements...</Typography>
          ) : movements.length === 0 ? (
            <Typography variant="body2" color="text.disabled" sx={{ py: 2, textAlign: "center" }}>
              No stock movements recorded for this item.
            </Typography>
          ) : (
            <Box sx={{ maxHeight: 300, overflowY: "auto" }}>
              <Table size="small" stickyHeader>
                <TableHead>
                  <TableRow>
                    <TableCell>Date</TableCell>
                    <TableCell>Doc/No.</TableCell>
                    <TableCell>Type</TableCell>
                    <TableCell>Party / Ledger</TableCell>
                    <TableCell align="right">Qty</TableCell>
                    <TableCell align="right">Rate</TableCell>
                    <TableCell align="right">Amount</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {movements.map((m: any) => (
                    <TableRow key={m.id}>
                      <TableCell>{m.movement_date}</TableCell>
                      <TableCell>{m.movement_no}</TableCell>
                      <TableCell>
                        <Chip
                          label={m.movement_type}
                          size="small"
                          color={m.movement_type === "Inward" ? "success" : m.movement_type === "Outward" ? "error" : "primary"}
                          sx={{ height: 18, fontSize: "0.65rem", fontWeight: 700 }}
                        />
                      </TableCell>
                      <TableCell>{m.ledger_name || m.location_name || m.to_location_name || "-"}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700 }}>
                        {m.movement_type === "Inward" ? "+" : "-"}{formatQty(m.quantity)}
                      </TableCell>
                      <TableCell align="right">{m.rate ? `₹${formatAmount(m.rate)}` : "-"}</TableCell>
                      <TableCell align="right">{m.amount ? `₹${formatAmount(m.amount)}` : "-"}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Box>
          )}
        </DialogContent>
        <Divider />
        <DialogActions>
          <Button onClick={() => setViewingItem(null)} size="small" variant="contained">
            Close
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
