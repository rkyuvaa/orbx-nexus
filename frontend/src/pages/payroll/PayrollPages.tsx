import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip,
} from "@mui/material";
import Delete from "@mui/icons-material/Delete";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];

// Reusable voucher form + grid for Payment/Receipt, Staff/Contractor
function VoucherModule({
  title,
  breadcrumbs,
  endpoint,
  queryKey,
  ledgerType,
  paymentType,
  clearAllLabel,
}: any) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: [queryKey, activeFY],
    queryFn: async () => (await api.get(`${endpoint}?fy=${activeFY}&ledger_type=${ledgerType}&payment_type=${paymentType}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers", ledgerType],
    queryFn: async () => (await api.get(`/ledgers/?ledger_type=${ledgerType}`)).data,
  });

  const { register, handleSubmit, reset, control } = useForm({
    defaultValues: { voucher_no: "", voucher_date: today, ledger_id: "", payment_type: paymentType, ledger_type: ledgerType, amount: 0, narration: "" },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => api.post(`${endpoint}?fy=${activeFY}`, { ...data, payment_type: paymentType, ledger_type: ledgerType }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: [queryKey] }); setOpen(false); },
    onError: (err: any) => alert(`Failed to save. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`${endpoint.replace("/advances", `/advances/${id}`)}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: [queryKey] }),
    onError: (err: any) => alert(`Failed to delete. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const clearAllMutation = useMutation({
    mutationFn: () => api.delete(`${endpoint}?fy=${activeFY}&ledger_type=${ledgerType}&payment_type=${paymentType}`),
    onSuccess: (res: any) => {
      qc.invalidateQueries({ queryKey: [queryKey] });
      alert(`${res.data?.deleted ?? 0} record(s) cleared successfully.`);
    },
    onError: (err: any) => alert(`Failed to clear records. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const handleClearAll = () => {
    const count = items.length;
    if (count === 0) { alert("No records to clear."); return; }
    if (window.confirm(`Delete all ${count} "${title}" records? This cannot be undone.`)) {
      clearAllMutation.mutate();
    }
  };

  const handleDeleteRow = (id: number) => {
    if (window.confirm("Delete this record? This cannot be undone.")) {
      deleteMutation.mutate(id);
    }
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140 },
    { field: "voucher_date", headerName: "Date", width: 100 },
    { field: "ledger_id", headerName: ledgerType, width: 200 },
    { field: "amount", headerName: "Amount", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "narration", headerName: "Narration", flex: 1 },
    { headerName: "Actions", width: 90, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => handleDeleteRow(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
    )},
  ];

  return (
    <Box>
      <PageHeader title={title} breadcrumbs={breadcrumbs} actions={clearAllLabel ? (
        <Button variant="outlined" color="error" size="small" startIcon={<Delete fontSize="small" />} onClick={handleClearAll} disabled={clearAllMutation.isPending || items.length === 0}>
          {clearAllMutation.isPending ? "Clearing..." : clearAllLabel}
        </Button>
      ) : undefined} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={async () => {
          let nextNo = "";
          try {
            const ltype = ledgerType.toLowerCase();
            const ptype = paymentType.toLowerCase();
            const seqType = `${ltype}_advance_${ptype}`;
            const res = await api.get(`/sequences/preview/${seqType}`);
            nextNo = res.data.next_no;
          } catch (e) {
            console.error(e);
          }
          reset({
            voucher_no: nextNo,
            voucher_date: today,
            ledger_id: "",
            payment_type: paymentType,
            ledger_type: ledgerType,
            amount: 0,
            narration: "",
          });
          setOpen(true);
        }}
        addLabel="New Entry"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{title}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="ledger_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label={`${ledgerType} *`} error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("narration")} label="Narration" fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} /></Grid>
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

export function StaffAdvancePaymentPage() {
  return <VoucherModule title="Advance Payment (Staff)" queryKey="staff-advance-pay" endpoint="/payroll/advances" ledgerType="Staff" paymentType="Payment" breadcrumbs={[{ label: "Payroll Voucher" }, { label: "Advance Payment" }]} />;
}
export function StaffAdvanceReceiptPage() {
  return <VoucherModule title="Advance Receipt (Staff)" queryKey="staff-advance-rec" endpoint="/payroll/advances" ledgerType="Staff" paymentType="Receipt" breadcrumbs={[{ label: "Payroll Voucher" }, { label: "Advance Receipt" }]} />;
}
export function ContractorAdvancePaymentPage() {
  return <VoucherModule title="Advance Payment (Contractor)" queryKey="cont-advance-pay" endpoint="/payroll/advances" ledgerType="Contractor" paymentType="Payment" breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Advance Payment" }]} />;
}
export function ContractorAdvanceReceiptPage() {
  return <VoucherModule title="Advance Receipt (Contractor)" queryKey="cont-advance-rec" endpoint="/payroll/advances" ledgerType="Contractor" paymentType="Receipt" clearAllLabel="Clear All" breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Advance Receipt" }]} />;
}

export function SalaryVoucherPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["salary-vouchers", activeFY],
    queryFn: async () => (await api.get(`/payroll/salary?fy=${activeFY}`)).data,
  });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Staff"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Staff")).data });

  const { register, handleSubmit, reset, control } = useForm({
    defaultValues: { voucher_no: "", voucher_date: today, ledger_id: "", month: new Date().getMonth() + 1, year: new Date().getFullYear(), days_worked: 0, basic_salary: 0, allowances: 0, deductions: 0, net_salary: 0, narration: "" },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => api.post(`/payroll/salary?fy=${activeFY}`, data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["salary-vouchers"] }); setOpen(false); },
  });

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 130 },
    { field: "voucher_date", headerName: "Date", width: 100 },
    { field: "ledger_id", headerName: "Staff", width: 180 },
    { field: "month", headerName: "Month", width: 80 },
    { field: "year", headerName: "Year", width: 80 },
    { field: "days_worked", headerName: "Days", width: 75 },
    { field: "net_salary", headerName: "Net Salary", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
  ];

  return (
    <Box>
      <PageHeader title="Salary Voucher" breadcrumbs={[{ label: "Payroll Voucher" }, { label: "Salary Voucher" }]} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={async () => {
          let nextNo = "";
          try {
            const res = await api.get("/sequences/preview/salary_voucher");
            nextNo = res.data.next_no;
          } catch (e) {
            console.error(e);
          }
          reset({
            voucher_no: nextNo,
            month: new Date().getMonth() + 1,
            year: new Date().getFullYear(),
            voucher_date: today,
            days_worked: 0,
            basic_salary: 0,
            allowances: 0,
            deductions: 0,
            net_salary: 0,
            ledger_id: "",
            narration: "",
          });
          setOpen(true);
        }}
        addLabel="New Salary"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>New Salary Voucher</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="ledger_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => o.name} value={ledgers.find((l: any) => l.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label="Staff Member *" error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 3 }}><TextField {...register("month")} label="Month" type="number" fullWidth slotProps={{ htmlInput: { min: 1, max: 12 } }} /></Grid>
              <Grid size={{ xs: 3 }}><TextField {...register("year")} label="Year" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 3 }}><TextField {...register("days_worked")} label="Days Worked" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 3 }}><TextField {...register("basic_salary")} label="Basic Salary" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("allowances")} label="Allowances" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("deductions")} label="Deductions" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 4 }}><TextField {...register("net_salary")} label="Net Salary" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("narration")} label="Narration" fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} /></Grid>
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
