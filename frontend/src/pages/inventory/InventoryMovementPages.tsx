import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, MenuItem, Typography,
  Divider, Alert, Table, TableBody, TableCell, TableHead, TableRow, Paper
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Add from "@mui/icons-material/Add";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";



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
  const [lineItems, setLineItems] = useState<any[]>([
    { stock_item_id: "", quantity: "", rate: "", amount: "", uom_id: "" }
  ]);

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
      ledger_id: "",
      ref_no: "",
      narration: "",
    },
  });

  // Auto-fill UOM when stock item is selected in a row
  const handleLineItemChange = (index: number, field: string, value: any) => {
    setLineItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          if (field === "stock_item_id") {
            const stockItem = stockItemMap[Number(value)];
            if (stockItem?.uom_id) {
              updated.uom_id = String(stockItem.uom_id);
            } else {
              updated.uom_id = "";
            }
          }
          if (field === "quantity" || field === "rate") {
            const q = Number(field === "quantity" ? value : item.quantity) || 0;
            const r = Number(field === "rate" ? value : item.rate) || 0;
            updated.amount = q > 0 && r > 0 ? (q * r).toFixed(2) : "";
          }
          return updated;
        }
        return item;
      })
    );
  };

  const handleAddLineItem = () => {
    setLineItems((prev) => [...prev, { stock_item_id: "", quantity: "", rate: "", amount: "", uom_id: "" }]);
  };

  const handleRemoveLineItem = (index: number) => {
    if (lineItems.length === 1) return;
    setLineItems((prev) => prev.filter((_, i) => i !== index));
  };

  useEffect(() => {
    if (open) {
      if (editing) {
        reset({
          movement_no: editing.movement_no || "",
          movement_date: editing.movement_date || new Date().toISOString().split("T")[0],
          ledger_id: String(editing.ledger_id || ""),
          ref_no: editing.ref_no || "",
          narration: editing.narration || "",
        });

        let parsedItems: any[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }

        if (parsedItems && parsedItems.length > 0) {
          setLineItems(parsedItems.map((item: any) => ({
            stock_item_id: String(item.stock_item_id || ""),
            quantity: String(item.quantity || ""),
            rate: String(item.rate || ""),
            amount: String(item.amount || ""),
            uom_id: String(item.uom_id || "")
          })));
        } else {
          setLineItems([{
            stock_item_id: String(editing.stock_item_id || ""),
            quantity: String(editing.quantity || ""),
            rate: String(editing.rate || ""),
            amount: String(editing.amount || ""),
            uom_id: String(editing.uom_id || "")
          }]);
        }
      } else {
        reset({
          movement_no: "",
          movement_date: new Date().toISOString().split("T")[0],
          ledger_id: "",
          ref_no: "",
          narration: "",
        });
        setLineItems([{ stock_item_id: "", quantity: "", rate: "", amount: "", uom_id: "" }]);

        const seqType = movementType === "Inward" ? "inventory_inward" : "inventory_outward";
        api.get(`/sequences/preview/${seqType}`)
          .then((res) => setValue("movement_no", res.data.next_no))
          .catch((e) => console.error(e));
      }
    }
  }, [open, editing, reset, movementType, setValue]);

  const totalQty = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const totalAmount = lineItems.reduce((sum, item) => sum + (Number(item.amount) || 0), 0);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const validItems = lineItems.filter(item => item.stock_item_id && Number(item.quantity) > 0);
      if (validItems.length === 0) {
        alert("Please add at least one stock item with a valid quantity.");
        return Promise.reject("No valid items");
      }

      const payload = {
        ...data,
        movement_type: movementType,
        stock_item_id: Number(validItems[0].stock_item_id),
        ledger_id: data.ledger_id ? Number(data.ledger_id) : null,
        quantity: totalQty,
        rate: Number(validItems[0].rate) || 0,
        amount: totalAmount,
        uom_id: validItems[0].uom_id ? Number(validItems[0].uom_id) : null,
        items: validItems.map((item) => ({
          stock_item_id: Number(item.stock_item_id),
          quantity: Number(item.quantity) || 0,
          rate: Number(item.rate) || 0,
          amount: Number(item.amount) || 0,
          uom_id: item.uom_id ? Number(item.uom_id) : null,
        })),
      };
      return editing
        ? api.put(`/stock/inventory/movements/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/inventory/movements?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      onClose();
    },
    onError: (err: any) => {
      console.error("Save error:", err);
      alert(err.response?.data?.detail || "Failed to save entry. Check duplicate number or missing fields.");
    }
  });

  const willExceed = useMemo(() => {
    if (movementType !== "Outward") return false;
    return lineItems.some(item => {
      if (!item.stock_item_id) return false;
      const balance = balanceMap[Number(item.stock_item_id)] ?? 0;
      return (Number(item.quantity) || 0) > balance;
    });
  }, [lineItems, balanceMap, movementType]);

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle sx={{ pb: 1 }}>
        {editing 
          ? `Edit ${movementType === "Inward" ? "Purchase" : movementType}` 
          : `New ${movementType === "Inward" ? "Purchase Entry" : "Stock " + movementType}`}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Grid container spacing={2}>
          <Grid size={{ xs: 4 }}>
            <TextField
              label={movementType === "Inward" ? "Purchase No." : "Movement No."}
              fullWidth
              size="small"
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("movement_no", { required: "Required" })}
              error={!!errors.movement_no}
              helperText={errors.movement_no?.message as string}
            />
          </Grid>
          <Grid size={{ xs: 4 }}>
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
          <Grid size={{ xs: 4 }}>
            <TextField label="Ref No." fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...register("ref_no")} />
          </Grid>
 
          <Grid size={{ xs: 12 }}>
            <Controller
              name="ledger_id"
              control={control}
              render={({ field }) => (
                <LazyAutocomplete 
                  options={ledgers} 
                  getOptionLabel={(o: any) => o.name} 
                  value={ledgers.find((l: any) => l.id === Number(field.value)) || null} 
                  onChange={(_, v) => field.onChange(v ? String(v.id) : "")} 
                  renderInput={(params) => <TextField {...params} label={movementType === "Inward" ? "Supplier / Party (Optional)" : "Issued To / Party (Optional)"} size="small" />} 
                />
              )}
            />
          </Grid>
 
          <Grid size={{ xs: 12 }}>
            <Typography variant="subtitle2" sx={{ color: "#0f5132", fontWeight: 700, mb: 1 }}>Items List</Typography>
            <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
              <Table size="small">
                <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                  <TableRow>
                    <TableCell sx={{ minWidth: 260, fontWeight: 700 }}>Stock Item *</TableCell>
                    <TableCell sx={{ width: 120, minWidth: 120, fontWeight: 700 }} align="right">Qty *</TableCell>
                    <TableCell sx={{ width: 120, minWidth: 120, fontWeight: 700 }} align="right">Rate</TableCell>
                    <TableCell sx={{ width: 120, minWidth: 120, fontWeight: 700 }} align="right">Amount</TableCell>
                    <TableCell sx={{ width: 180, minWidth: 180, fontWeight: 700 }}>UOM</TableCell>
                    <TableCell sx={{ width: 50, minWidth: 50 }} align="center">Del</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {lineItems.map((item, idx) => {
                    const currentBalance = item.stock_item_id ? (balanceMap[Number(item.stock_item_id)] ?? 0) : null;
                    const itemExceeds = movementType === "Outward" && currentBalance !== null && (Number(item.quantity) || 0) > currentBalance;
                    
                    return (
                      <TableRow key={idx}>
                        <TableCell sx={{ minWidth: 260, verticalAlign: "top", pt: 1.5 }}>
                          <LazyAutocomplete
                            size="small"
                            options={stockItems}
                            getOptionLabel={(o: any) => o.item_code ? `${o.name} (${o.item_code})` : o.name}
                            value={stockItems.find((s: any) => s.id === Number(item.stock_item_id)) || null}
                            onChange={(_, v) => handleLineItemChange(idx, "stock_item_id", v ? String(v.id) : "")}
                            renderInput={(params) => <TextField {...params} required />}
                            fullWidth
                          />
                          {currentBalance !== null && (
                            <Typography variant="caption" sx={{ color: itemExceeds ? "error.main" : "text.secondary", display: "block", mt: 0.5, ml: 0.5 }}>
                              Bal: {formatQty(currentBalance)} {itemExceeds && "⚠ Exceeds"}
                            </Typography>
                          )}
                        </TableCell>
                        <TableCell sx={{ minWidth: 120, verticalAlign: "top", pt: 1.5 }} align="right">
                          <TextField
                            size="small"
                            type="number"
                            value={item.quantity}
                            onChange={(e) => handleLineItemChange(idx, "quantity", e.target.value)}
                            onBlur={(e) => {
                              if (e.target.value !== "") {
                                handleLineItemChange(idx, "quantity", Number(e.target.value).toFixed(3));
                              }
                            }}
                            slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.001", min: 0 } }}
                            required
                            fullWidth
                          />
                        </TableCell>
                        <TableCell sx={{ minWidth: 120, verticalAlign: "top", pt: 1.5 }} align="right">
                          <TextField
                            size="small"
                            type="number"
                            value={item.rate}
                            onChange={(e) => handleLineItemChange(idx, "rate", e.target.value)}
                            slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.01", min: 0 } }}
                            fullWidth
                          />
                        </TableCell>
                        <TableCell sx={{ minWidth: 120, verticalAlign: "top", pt: 2.2 }} align="right">
                          <Typography variant="body2" sx={{ fontWeight: 600, pr: 1 }}>
                            {item.amount ? `₹${formatAmount(item.amount)}` : "-"}
                          </Typography>
                        </TableCell>
                        <TableCell sx={{ minWidth: 180, verticalAlign: "top", pt: 1.5 }}>
                          <LazyAutocomplete
                            size="small"
                            options={uoms}
                            getOptionLabel={(o: any) => `${o.name} (${o.symbol})`}
                            value={uoms.find((u: any) => u.id === Number(item.uom_id)) || null}
                            onChange={(_, v) => handleLineItemChange(idx, "uom_id", v ? String(v.id) : "")}
                            renderInput={(params) => <TextField {...params} />}
                            fullWidth
                          />
                        </TableCell>
                        <TableCell sx={{ minWidth: 50, verticalAlign: "top", pt: 2 }} align="center">
                          <IconButton size="small" color="error" disabled={lineItems.length === 1} onClick={() => handleRemoveLineItem(idx)}>
                            <RemoveCircle fontSize="small" />
                          </IconButton>
                        </TableCell>
                      </TableRow>
                    );
                  })}
                  
                  {/* Totals & Add Row */}
                  <TableRow sx={{ bgcolor: "#f4f9f6" }}>
                    <TableCell colSpan={6}>
                      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                        <Button size="small" startIcon={<Add />} onClick={handleAddLineItem} sx={{ textTransform: "none", color: "#0f5132", fontWeight: 700 }}>
                          Add Item Row
                        </Button>
                        <Box sx={{ display: "flex", gap: 3, pr: 2 }}>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#0f5132" }}>
                            Total Qty: {formatQty(totalQty)}
                          </Typography>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#0f5132" }}>
                            Total Value: ₹{formatAmount(totalAmount)}
                          </Typography>
                        </Box>
                      </Box>
                    </TableCell>
                  </TableRow>
                </TableBody>
              </Table>
            </Paper>
          </Grid>

          <Grid size={{ xs: 12 }}>
            <TextField
              label="Narration"
              fullWidth
              size="small"
              multiline
              rows={2}
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("narration")}
            />
          </Grid>

          {willExceed && (
            <Grid size={{ xs: 12 }}>
              <Alert severity="warning" sx={{ py: 0.5 }}>
                One or more outward items exceed available balance.
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

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

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

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Purchase No.", width: 150 },
    { field: "movement_date", headerName: "Date", width: 110 },
    {
      field: "stock_item_name",
      headerName: "Stock Item",
      flex: 1,
      minWidth: 180,
      valueGetter: (p: any) => {
        let itemsList: any[] = [];
        if (typeof p.data?.items === "string") {
          try { itemsList = JSON.parse(p.data.items); } catch (e) {}
        } else if (Array.isArray(p.data?.items)) {
          itemsList = p.data.items;
        }
        if (itemsList && itemsList.length > 0) {
          return itemsList
            .map((it: any) => {
              const item = stockItems.find((s: any) => s.id === Number(it.stock_item_id));
              return item ? item.name : `Item #${it.stock_item_id}`;
            })
            .join(", ");
        }
        return p.data?.stock_item_name || "-";
      }
    },
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
              if (window.confirm("Delete this purchase entry?")) deleteMutation.mutate(p.data.id);
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
        title="Tools & Consumables Purchase"
        breadcrumbs={[{ label: "Purchase" }, { label: "Tools & Consumables" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); setOpen(true); }}
        addLabel="New Purchase"
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

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

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
    {
      field: "stock_item_name",
      headerName: "Stock Item",
      flex: 1,
      minWidth: 180,
      valueGetter: (p: any) => {
        let itemsList: any[] = [];
        if (typeof p.data?.items === "string") {
          try { itemsList = JSON.parse(p.data.items); } catch (e) {}
        } else if (Array.isArray(p.data?.items)) {
          itemsList = p.data.items;
        }
        if (itemsList && itemsList.length > 0) {
          return itemsList
            .map((it: any) => {
              const item = stockItems.find((s: any) => s.id === Number(it.stock_item_id));
              return item ? item.name : `Item #${it.stock_item_id}`;
            })
            .join(", ");
        }
        return p.data?.stock_item_name || "-";
      }
    },
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
