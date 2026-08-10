import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, MenuItem, Autocomplete, Typography } from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
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
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Contractor"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Contractor")).data });

  const { data: outwardVouchers = [] } = useQuery<any>({
    queryKey: ["outward-vouchers", activeFY],
    queryFn: async () => (await api.get(`/stock/outward?fy=${activeFY}`)).data,
    enabled: type === "job-work",
  });

  const { data: products = [] } = useQuery<any>({
    queryKey: ["products"],
    queryFn: async () => (await api.get("/products/")).data,
    enabled: type === "job-work",
  });

  const { register, handleSubmit, reset, control, watch, setValue } = useForm({
    defaultValues: {
      entry_no: "",
      entry_date: today,
      ledger_id: "",
      outward_id: "",
      outward_ids: [] as number[],
      product_id: "",
      process_id: "",
      quantity: 0,
      rate: 0,
      amount: 0,
      entry_type: type === "payment" ? "Payment" : "Register",
      narration: "",
    },
  });

  const selectedOutwardIds = watch("outward_ids") || [];
  const selectedProcessId = watch("process_id");
  const qty = watch("quantity");
  const rate = watch("rate");

  // Sum of quantities and weights for selectedProcessId inside the items list of selected Outward Vouchers
  const { totalDispatchedQty, totalDispatchedWeight } = useMemo(() => {
    let totalQty = 0;
    let totalWt = 0;
    if (!selectedProcessId || selectedOutwardIds.length === 0) {
      return { totalDispatchedQty: 0, totalDispatchedWeight: 0 };
    }
    selectedOutwardIds.forEach((id: number) => {
      const v = outwardVouchers.find((out: any) => out.id === id);
      if (v && v.items && Array.isArray(v.items)) {
        v.items.forEach((item: any) => {
          if (Number(item.process_id) === Number(selectedProcessId)) {
            totalQty += Number(item.quantity) || 0;
            totalWt += Number(item.total_weight) || 0;
          }
        });
      }
    });
    return { totalDispatchedQty: totalQty, totalDispatchedWeight: totalWt };
  }, [selectedOutwardIds, selectedProcessId, outwardVouchers]);

  // Sum of previously registered quantities for these outward vouchers and process in other register entries
  const { prevCompletedQty, prevCompletedWeight } = useMemo(() => {
    let totalQty = 0;
    let totalWt = 0;
    if (!selectedProcessId || selectedOutwardIds.length === 0) {
      return { prevCompletedQty: 0, prevCompletedWeight: 0 };
    }
    data.forEach((entry: any) => {
      if (editing && entry.id === editing.id) return;
      if (entry.entry_type === "Register" && Number(entry.process_id) === Number(selectedProcessId)) {
        const entryOids = entry.outward_ids || (entry.outward_id ? [entry.outward_id] : []);
        const intersects = entryOids.some((id: number) => selectedOutwardIds.includes(id));
        if (intersects) {
          totalQty += Number(entry.quantity) || 0;
        }
      }
    });
    if (totalDispatchedQty > 0) {
      totalWt = (totalQty / totalDispatchedQty) * totalDispatchedWeight;
    }
    return { prevCompletedQty: totalQty, prevCompletedWeight: totalWt };
  }, [selectedOutwardIds, selectedProcessId, data, editing, totalDispatchedQty, totalDispatchedWeight]);

  const balanceQty = useMemo(() => {
    return Math.max(0, totalDispatchedQty - prevCompletedQty);
  }, [totalDispatchedQty, prevCompletedQty]);

  const balanceWeight = useMemo(() => {
    return Math.max(0, totalDispatchedWeight - prevCompletedWeight);
  }, [totalDispatchedWeight, prevCompletedWeight]);

  // Auto fill quantity with balanceQty when Process or Outward Vouchers change
  useEffect(() => {
    if (type === "job-work" && (selectedProcessId || selectedOutwardIds.length > 0)) {
      setValue("quantity", balanceQty as any);
    }
  }, [balanceQty, type, setValue, selectedProcessId, selectedOutwardIds.length]);

  // Auto fill rate with Contractor Rate when Process is selected
  useEffect(() => {
    if (selectedProcessId && processes.length > 0) {
      const match = processes.find((p: any) => p.id === Number(selectedProcessId));
      if (match) {
        setValue("rate", (match.contractor_rate ?? 0) as any);
      }
    }
  }, [selectedProcessId, processes, setValue]);

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

  const handleOpen = async (row?: any) => {
    if (row) {
      setEditing(row);
      reset({
        ...row,
        outward_ids: row.outward_ids || (row.outward_id ? [row.outward_id] : []),
      });
    } else {
      setEditing(null);
      let nextNo = "";
      try {
        const seqType = type === "job-work" ? "job_work_register" : "job_work_payment";
        const res = await api.get(`/sequences/preview/${seqType}`);
        nextNo = res.data.next_no;
      } catch (e) {
        console.error("Error fetching document sequence preview:", e);
      }
      reset({
        entry_no: nextNo,
        entry_date: today,
        ledger_id: "",
        outward_id: "",
        outward_ids: [],
        product_id: "",
        process_id: "",
        quantity: 0,
        rate: 0,
        amount: 0,
        entry_type: type === "payment" ? "Payment" : "Register",
        narration: "",
      });
    }
    setOpen(true);
  };

  const TITLES: Record<string, string> = { rates: "Supplier Rate Register", "job-work": "Job Work Register", payment: "Job Work Payment" };
  const BREADCRUMBS: Record<string, string> = { rates: "Rate Register", "job-work": "Job Work Register", payment: "Job Work Payment" };

  const colDefs: ColDef[] = [
    { field: "entry_no", headerName: "Entry No.", width: 130 },
    { field: "entry_date", headerName: "Date", width: 100 },
    { field: "contractor_name", headerName: "Contractor", width: 180, valueFormatter: (p) => p.value || "General" },
    { field: "process_name", headerName: "Process", flex: 1, minWidth: 150, valueFormatter: (p: any) => p.value || "-" },
    ...(type === "job-work" ? [
      {
        field: "outward_ids",
        headerName: "Outward No(s)",
        width: 180,
        cellRenderer: (p: any) => {
          const ids = p.data.outward_ids || (p.data.outward_id ? [p.data.outward_id] : []);
          const names = ids.map((id: number) => outwardVouchers.find((v: any) => v.id === id)?.outward_no).filter(Boolean);
          return names.length > 0 ? names.join(", ") : (p.data.outward_no || "-");
        }
      },
      { field: "product_name", headerName: "Product", flex: 1, minWidth: 150, valueFormatter: (p: any) => p.value || "-" },
    ] : []),
    { field: "quantity", headerName: "Qty", width: 80, type: "numericColumn" },
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
              <Grid size={{ xs: 6 }}>
                <TextField {...register("entry_no")} label="Entry No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("entry_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="ledger_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={ledgers}
                      getOptionLabel={(o: any) => o.name}
                      value={ledgers.find((l: any) => l.id === field.value) || null}
                      onChange={(_, v) => field.onChange(v ? v.id : "")}
                      renderInput={(params) => <TextField {...params} label="Contractor *" error={!!fieldState.error} helperText={fieldState.error?.message} />}
                    />
                  )}
                />
              </Grid>

              {type === "job-work" && (
                <Grid size={{ xs: 12 }}>
                  <Controller
                    name="outward_ids"
                    control={control}
                    render={({ field }) => (
                      <Autocomplete
                        multiple
                        options={outwardVouchers}
                        getOptionLabel={(o: any) => `${o.outward_no} (${o.outward_date})`}
                        value={outwardVouchers.filter((v: any) => field.value?.includes(v.id))}
                        onChange={(_, v) => {
                          const ids = v ? (v as any[]).map((x) => x.id) : [];
                          field.onChange(ids);
                          setValue("process_id", "");
                          setValue("quantity", 0);
                          setValue("rate", 0);
                          setValue("amount", 0);
                        }}
                        renderInput={(params) => <TextField {...params} label="Outward Vouchers / Dispatches *" required={field.value?.length === 0} />}
                      />
                    )}
                  />
                </Grid>
              )}

              <Grid size={{ xs: 12 }}>
                <Controller
                  name="process_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <TextField
                      {...field}
                      select
                      label="Process *"
                      fullWidth
                      required
                      error={!!fieldState.error}
                      helperText={fieldState.error?.message}
                      slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                    >
                      <MenuItem value=""><em>Select Process</em></MenuItem>
                      {processes.map((p: any) => (
                        <MenuItem key={p.id} value={p.id}>{p.name}</MenuItem>
                      ))}
                    </TextField>
                  )}
                />
              </Grid>

              {type === "job-work" && selectedProcessId && selectedOutwardIds.length > 0 && (
                <Grid size={{ xs: 12 }}>
                  <Box sx={{ p: 2, bgcolor: "#f6ffed", border: "1px solid #b7eb8f", borderRadius: 1, display: "flex", flexWrap: "wrap", gap: 3 }}>
                    <Box>
                      <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>Total Dispatched Qty</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 600, color: "#135200" }}>{totalDispatchedQty} units ({totalDispatchedWeight.toFixed(2)} kg)</Typography>
                    </Box>
                    <Box>
                      <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>Previously Completed Qty</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 600, color: "#135200" }}>{prevCompletedQty} units ({prevCompletedWeight.toFixed(2)} kg)</Typography>
                    </Box>
                    <Box sx={{ borderLeft: "1px solid #d9d9d9", pl: 3 }}>
                      <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>Balance Qty to Complete</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: "#389e0d" }}>{balanceQty} units</Typography>
                    </Box>
                    <Box>
                      <Typography variant="caption" sx={{ color: "text.secondary", display: "block" }}>Balance Weight</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: "#389e0d" }}>{balanceWeight.toFixed(2)} kg</Typography>
                    </Box>
                  </Box>
                </Grid>
              )}

              <Grid size={{ xs: 4 }}>
                <TextField {...register("quantity")} label="Quantity" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 4 }}>
                <TextField {...register("rate")} label="Rate" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 4 }}>
                <TextField {...register("amount")} label="Amount" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <TextField {...register("narration")} label="Narration" fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
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
