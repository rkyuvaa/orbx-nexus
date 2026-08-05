import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, Chip, MenuItem, Switch, FormControlLabel,
  Autocomplete
} from "@mui/material";
import { Edit, Delete } from "@mui/icons-material";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";

const AutocompleteAny = Autocomplete as any;
import OrbxGrid from "../../components/tables/OrbxGrid";

// ────── Products ──────
export function ProductRegisterPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const { data = [], isLoading, refetch } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: uoms = [] } = useQuery({ queryKey: ["uom"], queryFn: async () => (await api.get("/products/uom")).data });
  const { register, handleSubmit, reset, control } = useForm({ defaultValues: { name: "", product_code: "", description: "", uom_id: "", weight: "" } });

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        weight: data.weight !== "" && data.weight !== null && data.weight !== undefined ? parseFloat(data.weight) : 0.0,
      };
      return editing ? api.put(`/products/${editing.id}`, payload) : api.post("/products/", payload);
    },
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["products"] }); setOpen(false); },
  });
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/products/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    reset(row || { name: "", product_code: "", description: "", uom_id: "", weight: "" });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "name", headerName: "Product Name", flex: 2 },
    { field: "product_code", headerName: "Code", width: 100 },
    { field: "weight", headerName: "Weight (kg)", width: 140, type: "numericColumn", valueFormatter: (p: any) => (p.value && parseFloat(p.value) > 0 ? `${parseFloat(p.value)} kg` : "-") },
    { field: "description", headerName: "Description", flex: 1 },
    { field: "is_active", headerName: "Active", width: 90, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Yes" : "No"} color={p.value ? "success" : "default"} sx={{ fontSize: "0.7rem" }} /> },
    { headerName: "Actions", width: 100, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title="Product Register" breadcrumbs={[{ label: "Process Info" }, { label: "Product Register" }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add Product"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit Product" : "Add Product"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 8 }}><TextField {...register("name")} label="Product Name" fullWidth required /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("product_code")} label="Code" fullWidth /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("weight")} label="Weight (kg)" type="number" slotProps={{ htmlInput: { step: "any" } }} fullWidth /></Grid>
              <Grid size={{ xs: 6 }}><Controller name="uom_id" control={control} render={({ field }) => (
                <LazyAutocomplete options={uoms} getOptionLabel={(o: any) => `${o.name} (${o.symbol})`} value={uoms.find((u: any) => u.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : null)} renderInput={(params) => <TextField {...params} label="Unit of Measure" />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("description")} label="Description" fullWidth multiline rows={2} /></Grid>
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

// ────── Processes ──────
export function ProcessRegisterPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const { data = [], isLoading, refetch } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { register, handleSubmit, reset, control, watch, setValue, formState: { errors } } = useForm({
    defaultValues: {
      name: "",
      process_code: "",
      sequence: 0,
      description: "",
      company_rate: "",
      contractor_rate: "",
      gst_percent: "" as any,
      is_active: true
    }
  });

  const watchCode = watch("process_code");
  const isCombined = !!(watchCode && watchCode.includes(" / "));

  useEffect(() => {
    if (isCombined) {
      const parts = watchCode.split("/").map(p => p.trim()).filter(Boolean);
      let companySum = 0;
      let contractorSum = 0;
      parts.forEach(part => {
        const matched = data.find((p: any) => p.process_code === part);
        if (matched) {
          companySum += parseFloat(matched.company_rate || 0);
          contractorSum += parseFloat(matched.contractor_rate || 0);
        }
      });
      setValue("company_rate", companySum ? String(companySum.toFixed(2)) : "");
      setValue("contractor_rate", contractorSum ? String(contractorSum.toFixed(2)) : "");
    }
  }, [watchCode, isCombined, data, setValue]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        company_rate: data.company_rate !== "" && data.company_rate !== null && data.company_rate !== undefined ? parseFloat(data.company_rate) : 0.0,
        contractor_rate: data.contractor_rate !== "" && data.contractor_rate !== null && data.contractor_rate !== undefined ? parseFloat(data.contractor_rate) : 0.0,
        gst_percent: data.gst_percent !== "" && data.gst_percent !== null && data.gst_percent !== undefined ? parseFloat(data.gst_percent) : 0.0,
        sequence: data.sequence !== "" && data.sequence !== null && data.sequence !== undefined ? parseInt(data.sequence, 10) : 0,
        is_active: !!data.is_active
      };
      return editing ? api.put(`/products/processes/${editing.id}`, payload) : api.post("/products/processes", payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["processes"] });
      setOpen(false);
    },
    onError: (err: any) => {
      const msg = err.response?.data?.detail || "Failed to save process.";
      alert(msg);
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/products/processes/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["processes"] }),
    onError: (err: any) => {
      const msg = err.response?.data?.detail || "Failed to delete process.";
      alert(msg);
    }
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    reset(row || { name: "", process_code: "", sequence: 0, description: "", company_rate: "", contractor_rate: "", gst_percent: "", is_active: true });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "process_code", headerName: "Short Code", width: 120 },
    { field: "name", headerName: "Process Name", flex: 2 },
    { field: "company_rate", headerName: "Company Rate", width: 140, type: "numericColumn", valueFormatter: (p: any) => p.value !== undefined ? `₹${parseFloat(p.value).toFixed(2)}` : "-" },
    { field: "contractor_rate", headerName: "Contractor Rate", width: 140, type: "numericColumn", valueFormatter: (p: any) => p.value !== undefined ? `₹${parseFloat(p.value).toFixed(2)}` : "-" },
    { field: "is_active", headerName: "Status", width: 110, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Active" : "Inactive"} color={p.value ? "success" : "default"} sx={{ fontSize: "0.75rem", fontWeight: 600 }} /> },
    { field: "gst_percent", headerName: "GST %", width: 90, type: "numericColumn", valueFormatter: (p: any) => `${p.value || 0}%` },
    { field: "sequence", headerName: "Seq.", width: 70, type: "numericColumn" },
    { headerName: "Actions", width: 100, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => {
          if (confirm("Are you sure you want to delete this process?")) {
            deleteMutation.mutate(p.data.id);
          }
        }}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  const singleProcesses = data.filter((p: any) => !p.process_ids && (!p.process_code || !p.process_code.includes(" / ")));

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title="Process Register" breadcrumbs={[{ label: "Process Info" }, { label: "Process Register" }]} />
      <OrbxGrid
        rowData={singleProcesses}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add Process"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit Process" : "Add Process"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 8 }}>
                <TextField
                  {...register("name", { required: "Process Name is required" })}
                  label="Process Name *"
                  fullWidth
                  error={!!errors.name}
                  helperText={errors.name?.message}
                />
              </Grid>
              <Grid size={{ xs: 4 }}>
                <TextField
                  {...register("process_code", { required: "Short Code is required" })}
                  label="Short Code *"
                  fullWidth
                  error={!!errors.process_code}
                  helperText={errors.process_code?.message}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("company_rate", {
                    required: "Company Rate is required",
                    min: { value: 0, message: "Rate cannot be negative" }
                  })}
                  label="Company Rate Per KG *"
                  type="number"
                  slotProps={{
                    input: { readOnly: isCombined },
                    htmlInput: { step: "any", min: 0 }
                  }}
                  sx={{ bgcolor: isCombined ? "action.hover" : "inherit" }}
                  fullWidth
                  error={!!errors.company_rate}
                  helperText={errors.company_rate?.message || (isCombined ? "Sum of component rates" : "")}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("contractor_rate", {
                    required: "Contractor Rate is required",
                    min: { value: 0, message: "Rate cannot be negative" }
                  })}
                  label="Contractor Rate Per KG *"
                  type="number"
                  slotProps={{
                    input: { readOnly: isCombined },
                    htmlInput: { step: "any", min: 0 }
                  }}
                  sx={{ bgcolor: isCombined ? "action.hover" : "inherit" }}
                  fullWidth
                  error={!!errors.contractor_rate}
                  helperText={errors.contractor_rate?.message || (isCombined ? "Sum of component rates" : "")}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("gst_percent")}
                  label="GST %"
                  type="number"
                  slotProps={{ htmlInput: { step: "any" } }}
                  fullWidth
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("sequence")}
                  label="Sequence"
                  type="number"
                  fullWidth
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="is_active"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={
                        <Switch
                          checked={!!field.value}
                          onChange={(e) => field.onChange(e.target.checked)}
                          color="success"
                        />
                      }
                      label="Active (Available for future transactions)"
                    />
                  )}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <TextField
                  {...register("description")}
                  label="Description"
                  fullWidth
                  multiline
                  rows={2}
                />
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

// ────── Rate Register ──────
export function RateRegisterPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const { data = [], isLoading, refetch } = useQuery({ queryKey: ["rates"], queryFn: async () => (await api.get("/products/rates/all")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Account"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data });
  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: uoms = [] } = useQuery({ queryKey: ["uom"], queryFn: async () => (await api.get("/products/uom")).data });
  const { register, handleSubmit, reset, control } = useForm({ defaultValues: { process_id: "", ledger_id: "", product_id: "", rate: 0, uom_id: "", effective_from: "", effective_to: "" } });

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        process_id: data.process_id ? Number(data.process_id) : null,
        ledger_id: data.ledger_id ? Number(data.ledger_id) : null,
        product_id: data.product_id ? Number(data.product_id) : null,
        rate: Number(data.rate) || 0,
        uom_id: data.uom_id ? Number(data.uom_id) : null
      };
      return api.post("/products/rates", payload);
    },
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["rates"] }); setOpen(false); },
  });

  const handleOpen = () => {
    reset({ process_id: "", ledger_id: "", product_id: "", rate: 0, uom_id: "", effective_from: "", effective_to: "" });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "ledger_id", headerName: "Supplier", width: 220, valueGetter: (p) => ledgers.find((l: any) => l.id === p.data?.ledger_id)?.name || "All Suppliers" },
    { field: "process_id", headerName: "Process", width: 140, valueGetter: (p) => processes.find((pr: any) => pr.id === p.data?.process_id)?.name || p.data?.process_id || "" },
    { field: "product_id", headerName: "Product", flex: 2, valueGetter: (p) => products.find((pr: any) => pr.id === p.data?.product_id)?.name || p.data?.product_id || "" },
    { field: "rate", headerName: "Rate", width: 100, type: "numericColumn" },
    { field: "effective_from", headerName: "From", width: 110 },
    { field: "effective_to", headerName: "To", width: 110 },
    { field: "is_active", headerName: "Active", width: 80, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Yes" : "No"} color={p.value ? "success" : "default"} sx={{ fontSize: "0.7rem" }} /> },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title="Rate Register" breadcrumbs={[{ label: "Process Info" }, { label: "Rate Register" }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={handleOpen}
        addLabel="Add Rate"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>Add Rate</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 12 }}><Controller name="ledger_id" control={control} render={({ field }) => (
                <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Supplier (or all)" />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="product_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                <LazyAutocomplete options={products} getOptionLabel={(o: any) => `${o.name} (${o.product_code || ""})`} value={products.find((p: any) => p.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Product" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="process_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                 <LazyAutocomplete options={processes.filter((p: any) => !p.process_ids && (p.is_active || p.id === Number(field.value)))} getOptionLabel={(o: any) => o.name} value={processes.find((p: any) => p.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Process" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("rate")} label="Rate" type="number" slotProps={{ htmlInput: { step: "any" } }} fullWidth required /></Grid>
              <Grid size={{ xs: 6 }}><Controller name="uom_id" control={control} render={({ field }) => (
                <LazyAutocomplete options={uoms} getOptionLabel={(o: any) => o.symbol} value={uoms.find((u: any) => u.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : null)} renderInput={(params) => <TextField {...params} label="UoM" />} />
              )} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("effective_from")} label="Effective From" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("effective_to")} label="Effective To" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
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

// ────── UoM ──────
export function UoMPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const { data = [], isLoading, refetch } = useQuery({ queryKey: ["uom"], queryFn: async () => (await api.get("/products/uom")).data });
  const { register, handleSubmit, reset } = useForm({ defaultValues: { name: "", symbol: "" } });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editing ? api.put(`/products/uom/${editing.id}`, data) : api.post("/products/uom", data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["uom"] }); setOpen(false); },
  });
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/products/uom/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["uom"] }),
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    reset(row || { name: "", symbol: "" });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "name", headerName: "Unit Name", flex: 1 },
    { field: "symbol", headerName: "Symbol", width: 100 },
    { headerName: "Actions", width: 100, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title="Unit of Measure" breadcrumbs={[{ label: "Inventory Info" }, { label: "Unit of Measure" }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        height={400}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add UoM"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="xs" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit UoM" : "Add Unit of Measure"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 8 }}><TextField {...register("name")} label="Unit Name" fullWidth required /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("symbol")} label="Symbol" fullWidth required /></Grid>
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


export function ProcessGroupsPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const { data = [], isLoading, refetch } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { register, handleSubmit, reset, control, watch, setValue, formState: { errors } } = useForm({
    defaultValues: {
      name: "",
      process_code: "",
      sequence: 0,
      description: "",
      company_rate: "",
      contractor_rate: "",
      gst_percent: "" as any,
      is_active: true,
      process_ids: ""
    }
  });

  const singleProcesses = useMemo(() => {
    return data.filter((p: any) => !p.process_ids && (!p.process_code || !p.process_code.includes(" / ")));
  }, [data]);

  const groupProcesses = useMemo(() => {
    return data.filter((p: any) => p.process_ids || (p.process_code && p.process_code.includes(" / ")));
  }, [data]);

  // Map for easy ID lookup
  const processMap = useMemo(() => {
    const map: any = {};
    data.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [data]);

  const watchProcessIds = watch("process_ids");

  useEffect(() => {
    if (watchProcessIds) {
      const parts = watchProcessIds.split(",").map(p => p.trim()).filter(Boolean);
      let companySum = 0;
      let contractorSum = 0;
      parts.forEach(partId => {
        const matched = processMap[partId];
        if (matched) {
          companySum += parseFloat(matched.company_rate || 0);
          contractorSum += parseFloat(matched.contractor_rate || 0);
        }
      });
      setValue("company_rate", companySum ? String(companySum.toFixed(2)) : "");
      setValue("contractor_rate", contractorSum ? String(contractorSum.toFixed(2)) : "");
    } else {
      setValue("company_rate", "");
      setValue("contractor_rate", "");
    }
  }, [watchProcessIds, processMap, setValue]);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        ...formData,
        company_rate: formData.company_rate !== "" && formData.company_rate !== null && formData.company_rate !== undefined ? parseFloat(formData.company_rate) : 0.0,
        contractor_rate: formData.contractor_rate !== "" && formData.contractor_rate !== null && formData.contractor_rate !== undefined ? parseFloat(formData.contractor_rate) : 0.0,
        gst_percent: formData.gst_percent !== "" && formData.gst_percent !== null && formData.gst_percent !== undefined ? parseFloat(formData.gst_percent) : 0.0,
        sequence: formData.sequence !== "" && formData.sequence !== null && formData.sequence !== undefined ? parseInt(formData.sequence, 10) : 0,
        is_active: !!formData.is_active
      };
      return editing ? api.put(`/products/processes/${editing.id}`, payload) : api.post("/products/processes", payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["processes"] });
      setOpen(false);
    },
    onError: (err: any) => {
      const msg = err.response?.data?.detail || "Failed to save process group.";
      alert(msg);
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/products/processes/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["processes"] }),
    onError: (err: any) => {
      const msg = err.response?.data?.detail || "Failed to delete process group.";
      alert(msg);
    }
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    reset(row || { name: "", process_code: "", sequence: 0, description: "", company_rate: "", contractor_rate: "", gst_percent: "", is_active: true, process_ids: "" });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "process_code", headerName: "Group Code", width: 120 },
    { field: "name", headerName: "Group Name", flex: 2 },
    {
      field: "process_ids",
      headerName: "Included Processes",
      flex: 3,
      valueGetter: (p: any) => {
        if (p.data?.process_ids) {
          return p.data.process_ids.split(",")
            .map((id: string) => processMap[id.trim()]?.process_code || id)
            .filter(Boolean).join(" + ");
        }
        if (p.data?.process_code && p.data.process_code.includes(" / ")) {
          return p.data.process_code;
        }
        return "-";
      }
    },
    { field: "company_rate", headerName: "Company Rate", width: 130, type: "numericColumn", valueFormatter: (p: any) => p.value !== undefined ? `₹${parseFloat(p.value).toFixed(2)}` : "-" },
    { field: "contractor_rate", headerName: "Contractor Rate", width: 130, type: "numericColumn", valueFormatter: (p: any) => p.value !== undefined ? `₹${parseFloat(p.value).toFixed(2)}` : "-" },
    { field: "is_active", headerName: "Status", width: 110, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Active" : "Inactive"} color={p.value ? "success" : "default"} sx={{ fontSize: "0.75rem", fontWeight: 600 }} /> },
    { headerName: "Actions", width: 100, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => {
          if (confirm("Are you sure you want to delete this process group?")) {
            deleteMutation.mutate(p.data.id);
          }
        }}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title="Process Groups" breadcrumbs={[{ label: "Process Info" }, { label: "Process Groups" }]} />
      <OrbxGrid
        rowData={groupProcesses}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add Group"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit Process Group" : "Add Process Group"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 8 }}>
                <TextField
                  {...register("name", { required: "Group Name is required" })}
                  label="Group Name *"
                  fullWidth
                  error={!!errors.name}
                  helperText={errors.name?.message}
                />
              </Grid>
              <Grid size={{ xs: 4 }}>
                <TextField
                  {...register("process_code", { required: "Group Code is required" })}
                  label="Group Code *"
                  fullWidth
                  error={!!errors.process_code}
                  helperText={errors.process_code?.message}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="process_ids"
                  control={control}
                  rules={{ required: "At least one process must be selected" }}
                  render={({ field: { value, onChange } }) => {
                    const selectedIds = value ? value.split(",").map((x: string) => Number(x.trim())).filter(Boolean) : [];
                    const selectedOptions = singleProcesses.filter((p: any) => selectedIds.includes(p.id));
                    return (
                      <AutocompleteAny
                        multiple
                        size="small"
                        options={singleProcesses}
                        value={selectedOptions}
                        onChange={(_, val: any) => {
                          const idsStr = val ? val.map((v: any) => v.id).join(",") : "";
                          onChange(idsStr);
                        }}
                        getOptionLabel={(option: any) => option.process_code ? `[${option.process_code}] ${option.name}` : option.name}
                        noOptionsText="No matching processes"
                        disableCloseOnSelect
                        renderInput={(params: any) => (
                          <TextField
                            {...params}
                            label="Select Processes *"
                            error={!!errors.process_ids}
                            helperText={errors.process_ids?.message}
                          />
                        )}
                        renderTags={(tagValue: any, getTagProps: any) =>
                          tagValue.map((option: any, index: number) => {
                            const { key, ...tagProps } = getTagProps({ index });
                            return (
                              <Chip
                                key={key}
                                variant="outlined"
                                label={option.process_code}
                                size="small"
                                sx={{ height: 22, fontSize: "0.7rem" }}
                                {...tagProps}
                              />
                            );
                          })
                        }
                      />
                    );
                  }}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("company_rate")}
                  label="Company Rate Per KG"
                  type="number"
                  slotProps={{ input: { readOnly: true }, htmlInput: { step: "any" } }}
                  sx={{ bgcolor: "action.hover" }}
                  fullWidth
                  helperText="Sum of component rates (Auto-calculated)"
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("contractor_rate")}
                  label="Contractor Rate Per KG"
                  type="number"
                  slotProps={{ input: { readOnly: true }, htmlInput: { step: "any" } }}
                  sx={{ bgcolor: "action.hover" }}
                  fullWidth
                  helperText="Sum of component rates (Auto-calculated)"
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("gst_percent")}
                  label="GST %"
                  type="number"
                  slotProps={{ htmlInput: { step: "any" } }}
                  fullWidth
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("sequence")}
                  label="Sequence"
                  type="number"
                  fullWidth
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="is_active"
                  control={control}
                  render={({ field }) => (
                    <FormControlLabel
                      control={
                        <Switch
                          checked={!!field.value}
                          onChange={(e) => field.onChange(e.target.checked)}
                          color="success"
                        />
                      }
                      label="Active (Available for future transactions)"
                    />
                  )}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <TextField
                  {...register("description")}
                  label="Description"
                  fullWidth
                  multiline
                  rows={2}
                />
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
