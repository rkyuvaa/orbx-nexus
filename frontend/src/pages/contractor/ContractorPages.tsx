import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, MenuItem, Autocomplete, Typography, Table, TableHead, TableRow, TableCell, TableBody, Paper, Select } from "@mui/material";
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

  const [lineItems, setLineItems] = useState<any[]>([{ process_id: "", quantity: "", balance_qty: 0, rate: 0, amount: 0 }]);
  const [submitError, setSubmitError] = useState("");

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

  const watchedOutwardIds = watch("outward_ids");
  const selectedOutwardIds = useMemo(() => watchedOutwardIds || [], [watchedOutwardIds]);
  const selectedProcessId = watch("process_id");
  const qty = watch("quantity");
  const rate = watch("rate");

  // Sum of previously registered quantities for these outward vouchers and process in other register entries
  const getBalanceQtyForProcess = (processId: number | string) => {
    if (!processId || selectedOutwardIds.length === 0) return 0;
    
    let totalDispatched = 0;
    selectedOutwardIds.forEach((id: number) => {
      const v = outwardVouchers.find((out: any) => out.id === id);
      if (v && v.items && Array.isArray(v.items)) {
        v.items.forEach((item: any) => {
          if (Number(item.process_id) === Number(processId)) {
            totalDispatched += Number(item.quantity) || 0;
          }
        });
      }
    });

    let totalCompleted = 0;
    data.forEach((entry: any) => {
      if (editing && entry.id === editing.id) return;
      if (entry.entry_type === "Register") {
        let entryItems: any[] = [];
        if (entry.items) {
          try {
            entryItems = typeof entry.items === "string" ? JSON.parse(entry.items) : entry.items;
          } catch (e) {}
        }
        if (entryItems && entryItems.length > 0) {
          entryItems.forEach((it: any) => {
            if (Number(it.process_id) === Number(processId)) {
              const entryOids = entry.outward_ids || (entry.outward_id ? [entry.outward_id] : []);
              const intersects = entryOids.some((id: number) => selectedOutwardIds.includes(id));
              if (intersects) {
                totalCompleted += Number(it.quantity) || 0;
              }
            }
          });
        } else if (Number(entry.process_id) === Number(processId)) {
          const entryOids = entry.outward_ids || (entry.outward_id ? [entry.outward_id] : []);
          const intersects = entryOids.some((id: number) => selectedOutwardIds.includes(id));
          if (intersects) {
            totalCompleted += Number(entry.quantity) || 0;
          }
        }
      }
    });

    return Math.max(0, totalDispatched - totalCompleted);
  };

  // Filter processes by selected Outward Vouchers, including group processes child expansion
  const outwardProcesses = useMemo(() => {
    if (selectedOutwardIds.length === 0) return [];
    const resolvedIds = new Set<number>();
    
    selectedOutwardIds.forEach((id: number) => {
      const v = outwardVouchers.find((out: any) => out.id === id);
      if (v && v.items && Array.isArray(v.items)) {
        v.items.forEach((item: any) => {
          const procId = Number(item.process_id);
          const proc = processes.find((p: any) => p.id === procId);
          
          if (proc && proc.process_ids) {
            const childIds = proc.process_ids.split(",").map((x: string) => x.trim()).filter(Boolean);
            childIds.forEach((cid: string) => resolvedIds.add(Number(cid)));
          } else if (proc && proc.process_code && proc.process_code.includes(" / ")) {
            const parts = proc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
            parts.forEach((part: any) => {
              const child = processes.find((p: any) => p.process_code === part);
              if (child) resolvedIds.add(child.id);
            });
          } else if (proc) {
            resolvedIds.add(proc.id);
          }
        });
      }
    });
    
    return processes.filter((p: any) => resolvedIds.has(p.id));
  }, [selectedOutwardIds, outwardVouchers, processes]);

  // We do not auto-fill lineItems with processes, the user selects them manually

  const handleLineChange = (index: number, field: string, val: any) => {
    const updated = [...lineItems];
    updated[index][field] = val;
    if (field === "process_id") {
      const proc = processes.find((p: any) => p.id === Number(val));
      const bal = getBalanceQtyForProcess(val);
      updated[index].rate = proc ? proc.contractor_rate || 0 : 0;
      updated[index].balance_qty = bal;
      updated[index].quantity = bal;
      updated[index].amount = Number((Number(bal) * (proc ? proc.contractor_rate || 0 : 0)).toFixed(2));
    }
    if (field === "quantity") {
      if (selectedOutwardIds.length > 0) {
        const bal = Number(updated[index].balance_qty) || 0;
        if ((Number(updated[index].quantity) || 0) > bal) {
          updated[index].quantity = bal;
        }
      }
      const q = Number(updated[index].quantity) || 0;
      const r = Number(updated[index].rate) || 0;
      updated[index].amount = Number((q * r).toFixed(2));
    }
    if (field === "rate") {
      const q = Number(updated[index].quantity) || 0;
      const r = Number(updated[index].rate) || 0;
      updated[index].amount = Number((q * r).toFixed(2));
    }
    setLineItems(updated);
  };

  const handleAddLine = () => {
    setLineItems([...lineItems, { process_id: "", quantity: "", balance_qty: 0, rate: 0, amount: 0 }]);
  };

  const handleRemoveLine = (index: number) => {
    setLineItems(lineItems.filter((_, i) => i !== index));
  };

  // Auto fill rate with Contractor Rate when Process is selected (for payments only)
  useEffect(() => {
    if (type === "payment" && selectedProcessId && processes.length > 0) {
      const match = processes.find((p: any) => p.id === Number(selectedProcessId));
      if (match) {
        setValue("rate", (match.contractor_rate ?? 0) as any);
      }
    }
  }, [selectedProcessId, processes, setValue, type]);

  // Auto calculate amount when quantity or rate changes (for payments only)
  useEffect(() => {
    if (type === "payment") {
      const q = Number(qty || 0);
      const r = Number(rate || 0);
      const amt = q * r;
      if (amt > 0) {
        setValue("amount", amt as any);
      }
    }
  }, [qty, rate, setValue, type]);

  const totalQuantity = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const totalAmount = lineItems.reduce((sum, item) => sum + (Number(item.amount) || 0), 0);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        ...formData,
        quantity: type === "job-work" ? totalQuantity : Number(formData.quantity) || 0,
        amount: type === "job-work" ? totalAmount : Number(formData.amount) || 0,
        process_id: type === "job-work" ? (lineItems[0]?.process_id ? Number(lineItems[0].process_id) : null) : Number(formData.process_id) || null,
        items: type === "job-work" ? lineItems
          .filter((item: any) => item.process_id && Number(item.process_id) > 0)
          .map(item => ({
            process_id: Number(item.process_id),
            quantity: Number(item.quantity) || 0,
            rate: Number(item.rate) || 0,
            amount: Number(item.amount) || 0
          })) : []
      };
      return editing ? api.put(`/contractor/${editing.id}?fy=${activeFY}`, payload) : api.post(`/contractor/?fy=${activeFY}`, payload);
    },
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["contractor", type] }); setOpen(false); },
  });

  const handleSave = (d: any) => {
    if (type === "job-work") {
      const validLines = lineItems.filter((it: any) => it.process_id && Number(it.process_id) > 0);
      if (validLines.length === 0) {
        setSubmitError("Add at least one process line with a process selected.");
        return;
      }
      if (validLines.some((it: any) => !(Number(it.quantity) > 0))) {
        setSubmitError("Each process line must have a quantity greater than zero.");
        return;
      }
      if (selectedOutwardIds.length > 0 && validLines.some((it: any) => Number(it.quantity) > Number(it.balance_qty))) {
        setSubmitError("Quantity cannot exceed the balance quantity for any process line.");
        return;
      }
    }
    setSubmitError("");
    saveMutation.mutate(d);
  };

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/contractor/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["contractor", type] }),
  });

  const handleOpen = async (row?: any) => {
    if (row) {
      setEditing(row);
      setSubmitError("");
      reset({
        ...row,
        outward_ids: row.outward_ids || (row.outward_id ? [row.outward_id] : []),
      });
      let parsedItems: any[] = [];
      if (row.items) {
        try {
          parsedItems = typeof row.items === "string" ? JSON.parse(row.items) : row.items;
        } catch (e) {
          console.error(e);
        }
      }
      if (parsedItems && parsedItems.length > 0) {
        setLineItems(parsedItems.map(it => ({
          ...it,
          balance_qty: getBalanceQtyForProcess(it.process_id) + (Number(it.quantity) || 0)
        })));
      } else {
        const bal = getBalanceQtyForProcess(row.process_id) + (Number(row.quantity) || 0);
        setLineItems([{ process_id: row.process_id || "", quantity: row.quantity || 0, balance_qty: bal, rate: row.rate || 0, amount: row.amount || 0 }]);
      }
    } else {
      setEditing(null);
      setSubmitError("");
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
      setLineItems([{ process_id: "", quantity: "", balance_qty: 0, rate: 0, amount: 0 }]);
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
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="lg" fullWidth>
        <form onSubmit={handleSubmit(handleSave)}>
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
                          setLineItems([{ process_id: "", quantity: "", balance_qty: 0, rate: 0, amount: 0 }]);
                        }}
                        renderInput={(params) => <TextField {...params} label="Outward Vouchers / Dispatches *" required={field.value?.length === 0} />}
                      />
                    )}
                  />
                </Grid>
              )}

              {type === "job-work" ? (
                <Grid size={{ xs: 12 }}>
                  <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1, mt: 2 }}>
                    <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#023020" }}>
                      Registered Process Items
                    </Typography>
                    <Button size="small" variant="outlined" onClick={handleAddLine} sx={{ textTransform: "none" }}>
                      + Add Process Line
                    </Button>
                  </Box>
                  {submitError && (
                    <Typography color="error" variant="body2" sx={{ mt: 1, mb: 1 }}>
                      {submitError}
                    </Typography>
                  )}
                  <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                    <Table size="small">
                      <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                        <TableRow>
                          <TableCell sx={{ width: 50, fontWeight: 700 }} align="center">S. No</TableCell>
                          <TableCell sx={{ minWidth: 200, fontWeight: 700 }}>Process *</TableCell>
                          <TableCell sx={{ width: 140, fontWeight: 700 }} align="right">Qty *</TableCell>
                          <TableCell sx={{ width: 130, fontWeight: 700 }} align="right">Balance Qty</TableCell>
                          <TableCell sx={{ width: 130, fontWeight: 700 }} align="right">Rate *</TableCell>
                          <TableCell sx={{ width: 150, fontWeight: 700 }} align="right">Amount</TableCell>
                          <TableCell sx={{ width: 60 }} align="center">Del</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {lineItems.map((item, idx) => (
                          <TableRow key={idx}>
                            <TableCell align="center">{idx + 1}</TableCell>
                            <TableCell>
                              <Select
                                size="small"
                                fullWidth
                                value={item.process_id || ""}
                                onChange={(e) => handleLineChange(idx, "process_id", e.target.value)}
                                displayEmpty
                              >
                                <MenuItem value=""><em>Select Process</em></MenuItem>
                                {(selectedOutwardIds.length > 0 ? outwardProcesses : processes)
                                  .filter((p: any) => lineItems.every((other: any, oi: number) => oi === idx || Number(other.process_id) !== Number(p.id)))
                                  .map((p: any) => (
                                    <MenuItem key={p.id} value={p.id}>{p.name}</MenuItem>
                                  ))}
                              </Select>
                            </TableCell>
                            <TableCell align="right">
                              <TextField
                                size="small"
                                type="number"
                                fullWidth
                                value={item.quantity === "" ? "" : item.quantity}
                                onChange={(e) => handleLineChange(idx, "quantity", e.target.value)}
                                slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
                                helperText={selectedOutwardIds.length > 0 && item.process_id ? `Max: ${item.balance_qty}` : undefined}
                              />
                            </TableCell>
                            <TableCell align="right" sx={{ fontWeight: 600, color: "text.secondary" }}>
                              {item.balance_qty}
                            </TableCell>
                            <TableCell align="right">
                              <TextField
                                size="small"
                                type="number"
                                fullWidth
                                value={item.rate}
                                onChange={(e) => handleLineChange(idx, "rate", e.target.value)}
                                slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
                              />
                            </TableCell>
                            <TableCell align="right" sx={{ fontWeight: 600 }}>
                              ₹{formatAmount(item.amount)}
                            </TableCell>
                            <TableCell align="center">
                              <IconButton size="small" color="error" onClick={() => handleRemoveLine(idx)}>
                                <Delete fontSize="small" />
                              </IconButton>
                            </TableCell>
                          </TableRow>
                        ))}
                        {lineItems.length === 0 && (
                          <TableRow>
                            <TableCell colSpan={7} align="center" sx={{ py: 3, color: "text.secondary" }}>
                              No processes added. Please select Outward Vouchers or add a line manually.
                            </TableCell>
                          </TableRow>
                        )}
                        {lineItems.length > 0 && (
                          <TableRow sx={{ bgcolor: "#fafafa" }}>
                            <TableCell colSpan={2} sx={{ fontWeight: 700 }} align="right">
                              Total:
                            </TableCell>
                            <TableCell sx={{ fontWeight: 700 }} align="right">
                              {totalQuantity}
                            </TableCell>
                            <TableCell colSpan={2}></TableCell>
                            <TableCell sx={{ fontWeight: 700 }} align="right">
                              ₹{formatAmount(totalAmount)}
                            </TableCell>
                            <TableCell></TableCell>
                          </TableRow>
                        )}
                      </TableBody>
                    </Table>
                  </Paper>
                </Grid>
              ) : (
                <>
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

                  <Grid size={{ xs: 4 }}>
                    <TextField {...register("quantity")} label="Quantity" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
                  </Grid>
                  <Grid size={{ xs: 4 }}>
                    <TextField {...register("rate")} label="Rate" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
                  </Grid>
                  <Grid size={{ xs: 4 }}>
                    <TextField {...register("amount")} label="Amount" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
                  </Grid>
                </>
              )}

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
