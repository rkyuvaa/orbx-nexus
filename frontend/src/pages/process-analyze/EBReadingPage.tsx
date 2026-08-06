import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, MenuItem } from "@mui/material";
import Add from "@mui/icons-material/Add";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];

export default function EBReadingPage({ mode = "eb" }: { mode?: "eb" | "transfer" }) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);

  const isTransfer = mode === "transfer";

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: [mode, activeFY],
    queryFn: async () => isTransfer ? (await api.get(`/stock/transfer?fy=${activeFY}`)).data : (await api.get(`/process-analyze/eb-readings?fy=${activeFY}`)).data,
  });
  const { data: stockItems = [] } = useQuery({ queryKey: ["stock-items"], queryFn: async () => (await api.get("/products/stock-items")).data });

  const { register, handleSubmit, reset, control } = useForm({ defaultValues: isTransfer
    ? { transfer_no: "", transfer_date: today, from_stock_item_id: "", to_stock_item_id: "", quantity: 0, narration: "" }
    : { reading_date: today, meter_no: "", previous_reading: 0, current_reading: 0, units_consumed: 0, rate_per_unit: 0, amount: 0, narration: "" },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => isTransfer ? api.post(`/stock/transfer?fy=${activeFY}`, data) : api.post(`/process-analyze/eb-readings?fy=${activeFY}`, data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: [mode] }); setOpen(false); },
  });

  const colDefs: ColDef[] = isTransfer ? [
    { field: "transfer_no", headerName: "Transfer No.", width: 140 },
    { field: "transfer_date", headerName: "Date", width: 100 },
    { field: "from_stock_item_id", headerName: "From Item", width: 150 },
    { field: "to_stock_item_id", headerName: "To Item", width: 150 },
    { field: "quantity", headerName: "Quantity", width: 80, type: "numericColumn" },
    { field: "narration", headerName: "Narration", flex: 1 },
  ] : [
    { field: "reading_date", headerName: "Date", width: 110 },
    { field: "meter_no", headerName: "Meter No.", width: 120 },
    { field: "previous_reading", headerName: "Prev", width: 100, type: "numericColumn" },
    { field: "current_reading", headerName: "Current", width: 100, type: "numericColumn" },
    { field: "units_consumed", headerName: "Units", width: 90, type: "numericColumn" },
    { field: "rate_per_unit", headerName: "Rate", width: 80, type: "numericColumn" },
    { field: "amount", headerName: "Amount", width: 100, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
  ];

  const title = isTransfer ? "Stock Transfer" : "EB Reading";
  const breadcrumb = isTransfer ? "Stock Transfer" : "EB Reading";

  return (
    <Box>
      <PageHeader title={title} breadcrumbs={[{ label: "Process Analyze" }, { label: breadcrumb }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { reset({}); setOpen(true); }}
        addLabel="Add Entry"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>New {title}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              {isTransfer ? (
                <>
                  <Grid size={{ xs: 6 }}><TextField {...register("transfer_no")} label="Transfer No. *" fullWidth required /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("transfer_date")} label="Date" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
                  <Grid size={{ xs: 12 }}><Controller name="from_stock_item_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                    <LazyAutocomplete options={stockItems} getOptionLabel={(o: any) => o.name} value={stockItems.find((s: any) => s.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="From Item *" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
                  )} /></Grid>
                  <Grid size={{ xs: 12 }}><Controller name="to_stock_item_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                    <LazyAutocomplete options={stockItems} getOptionLabel={(o: any) => o.name} value={stockItems.find((s: any) => s.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="To Item *" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
                  )} /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("quantity")} label="Quantity" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("narration")} label="Narration" fullWidth /></Grid>
                </>
              ) : (
                <>
                  <Grid size={{ xs: 6 }}><TextField {...register("reading_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("meter_no")} label="Meter No." fullWidth /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("previous_reading")} label="Previous Reading" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 6 }}><TextField {...register("current_reading")} label="Current Reading" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 4 }}><TextField {...register("units_consumed")} label="Units Consumed" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 4 }}><TextField {...register("rate_per_unit")} label="Rate/Unit" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 4 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 12 }}><TextField {...register("narration")} label="Narration" fullWidth /></Grid>
                </>
              )}
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setOpen(false)} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}
