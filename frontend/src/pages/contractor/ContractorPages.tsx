import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, MenuItem } from "@mui/material";
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
      product_id: "",
      process_id: "",
      quantity: 0,
      rate: 0,
      amount: 0,
      entry_type: type === "payment" ? "Payment" : "Register",
      narration: "",
    },
  });

  const selectedOutwardId = watch("outward_id");
  const selectedProductId = watch("product_id");
  const selectedProcess = watch("process_id");
  const qty = watch("quantity");
  const rate = watch("rate");

  // Resolve products within selected Outward
  const selectedOutward = useMemo(() => {
    return outwardVouchers.find((v: any) => v.id === Number(selectedOutwardId));
  }, [outwardVouchers, selectedOutwardId]);

  const outwardProducts = useMemo(() => {
    if (!selectedOutward) return [];
    if (selectedOutward.items && Array.isArray(selectedOutward.items) && selectedOutward.items.length > 0) {
      return selectedOutward.items.map((it: any) => {
        const prod = products.find((p: any) => p.id === it.product_id);
        return {
          id: it.product_id,
          name: prod ? prod.name : `Product ID: ${it.product_id}`,
          qty: it.quantity,
        };
      });
    }
    if (selectedOutward.product_id) {
      const prod = products.find((p: any) => p.id === selectedOutward.product_id);
      return [{
        id: selectedOutward.product_id,
        name: prod ? prod.name : `Product ID: ${selectedOutward.product_id}`,
        qty: selectedOutward.quantity,
      }];
    }
    return [];
  }, [selectedOutward, products]);

  // Filter processes by selected Product
  const productProcesses = useMemo(() => {
    if (!selectedProductId) return [];
    return processes.filter((p: any) => p.product_id === Number(selectedProductId));
  }, [processes, selectedProductId]);

  // Auto fill quantity when Product is selected
  useEffect(() => {
    if (type === "job-work" && selectedProductId && outwardProducts.length > 0) {
      const matched = outwardProducts.find((p: any) => p.id === Number(selectedProductId));
      if (matched) {
        setValue("quantity", Number(matched.qty) as any);
      }
    }
  }, [selectedProductId, outwardProducts, type, setValue]);

  // Auto fill rate with Contractor Rate when Process is selected (for Job Work)
  useEffect(() => {
    if (type === "job-work" && selectedProcess && productProcesses.length > 0) {
      const match = productProcesses.find((p: any) => p.id === Number(selectedProcess));
      if (match) {
        setValue("rate", (match.contractor_rate ?? 0) as any);
      }
    }
  }, [selectedProcess, productProcesses, type, setValue]);

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
      reset(row);
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
    ...(type === "job-work" ? [
      { field: "outward_no", headerName: "Outward No", width: 130, valueFormatter: (p: any) => p.value || "-" },
      { field: "product_name", headerName: "Product", flex: 1, minWidth: 150, valueFormatter: (p: any) => p.value || "-" },
      { field: "process_name", headerName: "Process", flex: 1, minWidth: 150, valueFormatter: (p: any) => p.value || "-" },
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
                <>
                  <Grid size={{ xs: 12 }}>
                    <Controller
                      name="outward_id"
                      control={control}
                      render={({ field }) => (
                        <LazyAutocomplete
                          options={outwardVouchers}
                          getOptionLabel={(o: any) => `${o.outward_no} (${o.outward_date})`}
                          value={outwardVouchers.find((v: any) => v.id === field.value) || null}
                          onChange={(_, v) => {
                            field.onChange(v ? v.id : "");
                            setValue("product_id", "");
                            setValue("process_id", "");
                            setValue("quantity", 0);
                            setValue("rate", 0);
                            setValue("amount", 0);
                          }}
                          renderInput={(params) => <TextField {...params} label="Outward Voucher / Dispatch" />}
                        />
                      )}
                    />
                  </Grid>

                  <Grid size={{ xs: 6 }}>
                    <Controller
                      name="product_id"
                      control={control}
                      render={({ field }) => (
                        <TextField
                          {...field}
                          select
                          label="Product"
                          fullWidth
                          slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                          onChange={(e) => {
                            field.onChange(e.target.value);
                            setValue("process_id", "");
                            setValue("rate", 0);
                            setValue("amount", 0);
                          }}
                        >
                          <MenuItem value=""><em>Select Product</em></MenuItem>
                          {outwardProducts.map((p: any) => (
                            <MenuItem key={p.id} value={p.id}>{p.name} (Qty: {p.qty})</MenuItem>
                          ))}
                        </TextField>
                      )}
                    />
                  </Grid>

                  <Grid size={{ xs: 6 }}>
                    <Controller
                      name="process_id"
                      control={control}
                      render={({ field }) => (
                        <TextField
                          {...field}
                          select
                          label="Process"
                          fullWidth
                          slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                        >
                          <MenuItem value=""><em>Select Process</em></MenuItem>
                          {productProcesses.map((p: any) => (
                            <MenuItem key={p.id} value={p.id}>{p.name}</MenuItem>
                          ))}
                        </TextField>
                      )}
                    />
                  </Grid>
                </>
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
