import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, MenuItem, Chip } from "@mui/material";
import { Add, Edit, Delete, Refresh } from "@mui/icons-material";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];

export default function ContractorPages({ type }: { type: "rates" | "job-work" | "payment" }) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["contractor", type, activeFY],
    queryFn: async () => {
      if (type === "rates") return (await api.get("/products/rates/all")).data;
      return (await api.get(`/contractor/?fy=${activeFY}&entry_type=${type === "payment" ? "Payment" : "Register"}`)).data;
    },
  });

  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Account"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data });

  const { register, handleSubmit, reset, control, watch, setValue } = useForm({ defaultValues: { entry_no: "", entry_date: today, ledger_id: "", process_id: "", quantity: 0, rate: 0, amount: 0, entry_type: type === "payment" ? "Payment" : "Register", narration: "" } });

  const selectedProcess = watch("process_id");
  const qty = watch("quantity");
  const rate = watch("rate");

  // Auto fill rate with Contractor Rate when Process is selected (for Job Work)
  useEffect(() => {
    if (type === "job-work" && selectedProcess && processes.length > 0) {
      const match = processes.find((p: any) => p.id === Number(selectedProcess));
      if (match) {
        setValue("rate", (match.contractor_rate ?? 0) as any);
      }
    }
  }, [selectedProcess, processes, type, setValue]);

  // Auto calculate amount when quantity or rate changes
  useEffect(() => {
    const q = Number(qty || 0);
    const r = Number(rate || 0);
    const amt = q * r;
    if (amt > 0) {
      setValue("amount", amt as any);
    }
  }, [qty, rate, setValue]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => editing ? api.put(`/contractor/${editing.id}?fy=${activeFY}`, data) : api.post(`/contractor/?fy=${activeFY}`, data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["contractor", type] }); setOpen(false); },
  });
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/contractor/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["contractor", type] }),
  });

  const handleOpen = (row?: any) => { setEditing(row || null); reset(row || { entry_date: today, quantity: 0, rate: 0, amount: 0 }); setOpen(true); };

  const TITLES: Record<string, string> = { rates: "Supplier Rate Register", "job-work": "Job Work Register", payment: "Job Work Payment" };
  const BREADCRUMBS: Record<string, string> = { rates: "Rate Register", "job-work": "Job Work Register", payment: "Job Work Payment" };

  const colDefs: ColDef[] = [
    { field: "entry_no", headerName: "Entry No.", width: 130 },
    { field: "entry_date", headerName: "Date", width: 100 },
    { field: "ledger_id", headerName: "Supplier", width: 180 },
    { field: "quantity", headerName: "Qty", width: 70, type: "numericColumn" },
    { field: "rate", headerName: "Rate", width: 80, type: "numericColumn" },
    { field: "amount", headerName: "Amount", width: 110, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { headerName: "Actions", width: 100, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box>
      <PageHeader title={TITLES[type]} breadcrumbs={[{ label: "Contractor Voucher" }, { label: BREADCRUMBS[type] }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add Entry"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit Entry" : TITLES[type]}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}><TextField {...register("entry_no")} label="Entry No. *" fullWidth required /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("entry_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="ledger_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Supplier *" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="process_id" control={control} render={({ field }) => (
                <LazyAutocomplete options={processes} getOptionLabel={(o: any) => o.name} value={processes.find((p: any) => p.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : null)} renderInput={(params) => <TextField {...params} label="Process" />} />
              )} /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("quantity")} label="Quantity" type="number" fullWidth /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("rate")} label="Rate" type="number" fullWidth /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("narration")} label="Narration" fullWidth multiline rows={2} /></Grid>
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
