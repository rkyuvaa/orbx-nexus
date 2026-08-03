import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, IconButton, Tooltip, Typography,
} from "@mui/material";
import { Add, Delete } from "@mui/icons-material";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatQty } from "../../utils/format";

export default function StockAdjustmentPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["stock-adjustments", activeFY],
    queryFn: async () => (await api.get(`/stock/adjustments?fy=${activeFY}`)).data,
  });

  const { data: products = [] } = useQuery({
    queryKey: ["products"],
    queryFn: async () => (await api.get("/products/")).data,
  });

  const productMap = new Map(products.map((p: any) => [p.id, p]));

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/adjustments/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["stock-adjustments"] }),
  });

  const generateNextNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        const prefix = config.adjustmentPrefix || "ADJ/";
        const suffix = config.adjustmentSuffix || "";
        const nextNo = config.adjustmentNextNo || 1;
        const padding = config.adjustmentPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}${suffix}`;
      } catch (e) {}
    }
    return `ADJ/${String(1).padStart(4, "0")}`;
  };

  const incrementNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        if (config.adjustmentNextNo !== undefined) {
          config.adjustmentNextNo = Number(config.adjustmentNextNo) + 1;
          localStorage.setItem("orbx_print_config", JSON.stringify(config));
        }
      } catch (e) {}
    }
  };

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        ...formData,
        quantity: Number(formData.quantity),
        product_id: Number(formData.product_id),
      };
      return editing
        ? api.put(`/stock/adjustments/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/adjustments?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      if (!editing) incrementNo();
      qc.invalidateQueries({ queryKey: ["stock-adjustments"] });
      qc.invalidateQueries({ queryKey: ["report-stock-hand"] });
      handleClose();
    },
    onError: () => alert("Failed to save adjustment."),
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditing(null);
  };

  const colDefs: ColDef[] = [
    { field: "adjustment_no", headerName: "Adjustment No.", width: 150 },
    { field: "adjustment_date", headerName: "Date", width: 110 },
    { field: "product_name", headerName: "Product", width: 200 },
    { field: "quantity", headerName: "Qty", width: 100, type: "numericColumn",
      valueFormatter: (p: any) => {
        const v = Number(p.value || 0);
        const vStr = formatQty(v);
        return v > 0 ? `+${vStr}` : vStr;
      },
      cellRenderer: (p: any) => {
        const v = Number(p.value || 0);
        return <Typography sx={{ fontWeight: 700, color: v > 0 ? "#00a86b" : v < 0 ? "#f44336" : "inherit" }}>
          {v > 0 ? `+${v.toFixed(3)}` : v.toFixed(3)}
        </Typography>;
      },
    },
    { field: "reason", headerName: "Reason", width: 250 },
    { headerName: "Actions", width: 100, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5 }}>
          <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader title="Stock Adjustments" breadcrumbs={[{ label: "Inventory" }, { label: "Stock Adjustments" }]} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={() => refetch()}
        onAdd={() => handleOpen()}
        addLabel="New Adjustment"
      />
      <AdjustmentDialog open={open} onClose={handleClose} editing={editing} products={products} saveMutation={saveMutation} generateNextNo={generateNextNo} />
    </Box>
  );
}

function AdjustmentDialog({ open, onClose, editing, products, saveMutation, generateNextNo }: any) {
  const today = new Date().toISOString().split("T")[0];

  const { register, handleSubmit, reset, control } = useForm({
    defaultValues: {
      adjustment_no: "",
      adjustment_date: today,
      product_id: "",
      quantity: "",
      reason: "",
    },
  });

  const onSubmit = (data: any) => {
    if (!data.product_id) { alert("Please select a product."); return; }
    if (!data.quantity || Number(data.quantity) === 0) { alert("Quantity cannot be zero."); return; }
    saveMutation.mutate(data);
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth
      TransitionProps={{
        onEnter: () => {
          reset({
            adjustment_no: editing?.adjustment_no || generateNextNo(),
            adjustment_date: editing?.adjustment_date || today,
            product_id: editing?.product_id || "",
            quantity: editing?.quantity || "",
            reason: editing?.reason || "",
          });
        }
      }}>
      <DialogTitle sx={{ fontWeight: 700, color: "#023020" }}>
        {editing ? "Edit Adjustment" : "New Stock Adjustment"}
      </DialogTitle>
      <DialogContent>
        <Box component="form" id="adj-form" onSubmit={handleSubmit(onSubmit)} sx={{ mt: 1, display: "flex", flexDirection: "column", gap: 2 }}>
          <TextField
            {...register("adjustment_no")}
            label="Adjustment No"
            fullWidth size="small"
          />
          <TextField
            {...register("adjustment_date")}
            label="Date" type="date" fullWidth size="small"
            slotProps={{ inputLabel: { shrink: true } }}
          />
          <Controller name="product_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
            <LazyAutocomplete options={products} getOptionLabel={(o: any) => o.name} value={products.find((p: any) => p.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Product" size="small" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
          )} />
          <TextField
            {...register("quantity")}
            label="Quantity (+ increase, - decrease)"
            type="number" fullWidth size="small"
            slotProps={{ htmlInput: { step: "any" } }}
          />
          <TextField
            {...register("reason")}
            label="Reason / Remarks"
            fullWidth size="small" multiline rows={2}
          />
        </Box>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button type="submit" form="adj-form" variant="contained" disabled={saveMutation.isPending}>
          {saveMutation.isPending ? "Saving..." : "Save"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
