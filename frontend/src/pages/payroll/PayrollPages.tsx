import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, Typography, Paper, Chip,
  MenuItem, Divider, CircularProgress, Alert
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Print from "@mui/icons-material/Print";
import Calculate from "@mui/icons-material/Calculate";
import EventAvailable from "@mui/icons-material/EventAvailable";
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
}: any) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

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
    mutationFn: (data: any) => {
      const payload = { ...data, payment_type: paymentType, ledger_type: ledgerType };
      if (editing) {
        return api.put(`${endpoint}/${editing.id}?fy=${activeFY}`, payload);
      }
      return api.post(`${endpoint}?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: [queryKey] });
      setOpen(false);
      setEditing(null);
    },
    onError: (err: any) => alert(`Failed to save. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`${endpoint.replace("/advances", `/advances/${id}`)}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: [queryKey] }),
    onError: (err: any) => alert(`Failed to delete. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const handleDeleteRow = (id: number) => {
    if (window.confirm("Delete this record? This cannot be undone.")) {
      deleteMutation.mutate(id);
    }
  };

  const handleEditRow = (row: any) => {
    setEditing(row);
    reset({
      voucher_no: row.voucher_no || "",
      voucher_date: row.voucher_date || today,
      ledger_id: row.ledger_id || "",
      payment_type: paymentType,
      ledger_type: ledgerType,
      amount: row.amount || 0,
      narration: row.narration || "",
    });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140 },
    { field: "voucher_date", headerName: "Date", width: 100 },
    {
      field: "ledger_id",
      headerName: ledgerType,
      width: 200,
      valueFormatter: (p: any) => {
        const l = ledgers.find((item: any) => item.id === p.value || item.id === Number(p.value));
        return l ? `${l.code ? l.code + ' - ' : ''}${l.name}` : p.value;
      }
    },
    { field: "amount", headerName: "Amount", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "narration", headerName: "Narration", flex: 1 },
    {
      headerName: "Actions",
      width: 110,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5 }}>
          <Tooltip title="Edit">
            <IconButton size="small" color="primary" onClick={() => handleEditRow(p.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => handleDeleteRow(p.data.id)}>
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader title={title} breadcrumbs={breadcrumbs} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={async () => {
          setEditing(null);
          let nextNo = "";
          try {
            const ltype = ledgerType.toLowerCase();
            const ptype = paymentType.toLowerCase();
            const seqType = ltype === "contractor" ? `job_work_advance_${ptype}` : `${ltype}_advance_${ptype}`;
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
      <Dialog open={open} onClose={() => { setOpen(false); setEditing(null); }} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? `Edit ${title}` : title}</DialogTitle>
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
            <Button onClick={() => { setOpen(false); setEditing(null); }} variant="outlined">Cancel</Button>
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
  return <VoucherModule title="Advance Receipt (Contractor)" queryKey="cont-advance-rec" endpoint="/payroll/advances" ledgerType="Contractor" paymentType="Receipt" breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Advance Receipt" }]} />;
}

const MONTH_NAMES = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

export function SalaryVoucherPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [viewVoucher, setViewVoucher] = useState<any>(null);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["salary-vouchers", activeFY],
    queryFn: async () => (await api.get(`/payroll/salary?fy=${activeFY}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers", "Staff"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Staff")).data
  });

  const staffMap = useMemo(() => {
    const map: Record<number, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const { register, handleSubmit, reset, control, setValue, watch, getValues } = useForm({
    defaultValues: {
      voucher_no: "",
      voucher_date: today,
      ledger_id: "" as any,
      month: new Date().getMonth() + 1,
      year: new Date().getFullYear(),
      days_worked: 0,
      basic_salary: 0,
      per_day_salary: 0,
      payable_amount: 0,
      allowances: 0,
      deductions: 0,
      net_salary: 0,
      narration: "",
    },
  });

  const watchLedgerId = watch("ledger_id");
  const watchMonth = Number(watch("month") || (new Date().getMonth() + 1));
  const watchYear = Number(watch("year") || new Date().getFullYear());
  const watchDaysWorked = watch("days_worked");
  const watchPerDaySalary = watch("per_day_salary");
  const watchAllowances = watch("allowances");
  const watchDeductions = watch("deductions");
  const watchBasicSalary = watch("basic_salary");

  // Fetch real-time attendance stats from biometric entries for chosen staff & month/year
  const { data: attendanceStats, isFetching: isStatsLoading } = useQuery({
    queryKey: ["staff-attendance-stats", activeFY, watchLedgerId, watchMonth, watchYear],
    queryFn: async () => {
      if (!watchLedgerId) return null;
      return (await api.get(`/payroll/staff-attendance-stats?fy=${activeFY}&ledger_id=${watchLedgerId}&month=${watchMonth}&year=${watchYear}`)).data;
    },
    enabled: Boolean(open && watchLedgerId && watchMonth && watchYear),
  });

  // When attendanceStats updates for a new entry, auto-populate working days, per-day salary, and payable
  useEffect(() => {
    if (attendanceStats && open && !editing) {
      const workingDays = Number(attendanceStats.working_days ?? 0);
      const perDay = Number(attendanceStats.per_day_salary ?? 0);
      const basic = Number(attendanceStats.basic_salary ?? 0);
      const payableCalc = Math.round((workingDays * perDay) * 100) / 100;
      const al = Number(getValues("allowances") || 0);
      const ded = Number(getValues("deductions") || 0);
      const netCalc = Math.round((payableCalc + al - ded) * 100) / 100;

      setValue("days_worked", workingDays);
      setValue("per_day_salary", perDay);
      setValue("basic_salary", basic);
      setValue("payable_amount", payableCalc);
      setValue("net_salary", netCalc);
    }
  }, [attendanceStats, open, editing, setValue, getValues]);

  // Reactive calculation: Payable = Working Days * Per Day Salary
  const payable = useMemo(() => {
    const dw = Number(watchDaysWorked || 0);
    const pds = Number(watchPerDaySalary || 0);
    return Math.round((dw * pds) * 100) / 100;
  }, [watchDaysWorked, watchPerDaySalary]);

  // Reactive calculation: Net Salary = Payable + Allowances - Deductions
  const netSalary = useMemo(() => {
    const al = Number(watchAllowances || 0);
    const ded = Number(watchDeductions || 0);
    return Math.round((payable + al - ded) * 100) / 100;
  }, [payable, watchAllowances, watchDeductions]);

  // Keep form values in sync with calculated amounts
  useEffect(() => {
    setValue("payable_amount", payable);
    setValue("net_salary", netSalary);
  }, [payable, netSalary, setValue]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        days_worked: Number(data.days_worked || 0),
        per_day_salary: Number(data.per_day_salary || 0),
        payable_amount: Number(payable || 0),
        basic_salary: Number(data.basic_salary || 0),
        allowances: Number(data.allowances || 0),
        deductions: Number(data.deductions || 0),
        net_salary: Number(netSalary || 0),
      };
      if (editing) {
        return api.put(`/payroll/salary/${editing.id}?fy=${activeFY}`, payload);
      }
      return api.post(`/payroll/salary?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["salary-vouchers"] });
      setOpen(false);
      setEditing(null);
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || err?.message || "Failed to save salary voucher");
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/payroll/salary/${id}?fy=${activeFY}`),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["salary-vouchers"] }); },
    onError: () => alert("Failed to delete salary voucher."),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: async (rows: any[]) => {
      await Promise.all(rows.map((r) => api.delete(`/payroll/salary/${r.id}?fy=${activeFY}`)));
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["salary-vouchers"] });
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || "Failed to delete selected salary vouchers");
    },
  });

  const handleEditRow = (row: any) => {
    setEditing(row);
    reset({
      voucher_no: row.voucher_no || "",
      voucher_date: row.voucher_date || today,
      ledger_id: row.ledger_id || "",
      month: row.month || (new Date().getMonth() + 1),
      year: row.year || new Date().getFullYear(),
      days_worked: Number(row.days_worked || 0),
      basic_salary: Number(row.basic_salary || 0),
      per_day_salary: Number(row.per_day_salary || (Number(row.days_worked) ? (row.payable_amount || row.basic_salary) / row.days_worked : 0)),
      payable_amount: Number(row.payable_amount || (Number(row.days_worked || 0) * Number(row.per_day_salary || 0))),
      allowances: Number(row.allowances || 0),
      deductions: Number(row.deductions || 0),
      net_salary: Number(row.net_salary || 0),
      narration: row.narration || "",
    });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140, cellRenderer: (p) => <span style={{ fontWeight: 700 }}>{p.value}</span> },
    { field: "voucher_date", headerName: "Date", width: 105 },
    {
      field: "ledger_id",
      headerName: "Staff Member",
      flex: 1,
      minWidth: 170,
      cellRenderer: (p) => {
        const staff = staffMap[p.value];
        const name = p.data?.staff_name || staff?.name || p.value;
        const code = p.data?.staff_code || staff?.ledger_code;
        return (
          <Box>
            <span style={{ fontWeight: 600 }}>{name}</span>
            {code && <span style={{ fontSize: "0.75rem", color: "#64748b", marginLeft: "6px" }}>({code})</span>}
          </Box>
        );
      }
    },
    {
      field: "month",
      headerName: "Month / Year",
      width: 120,
      valueFormatter: (p) => `${MONTH_NAMES[(p.value || 1) - 1] || p.value} ${p.data?.year || ""}`
    },
    {
      field: "days_worked",
      headerName: "Working Days",
      width: 115,
      type: "numericColumn",
      cellRenderer: (p) => (
        <Chip
          label={`${p.value || 0} days`}
          size="small"
          color="primary"
          variant="outlined"
          sx={{ fontWeight: 700, fontSize: "0.75rem" }}
        />
      )
    },
    {
      field: "per_day_salary",
      headerName: "Per Day Salary",
      width: 125,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value || 0)}`
    },
    {
      field: "payable_amount",
      headerName: "Payable Amount",
      width: 145,
      type: "numericColumn",
      cellRenderer: (p) => {
        const amt = p.value || (Number(p.data?.days_worked || 0) * Number(p.data?.per_day_salary || 0));
        return (
          <span style={{ fontWeight: 700, color: "#166534" }}>
            ₹{formatAmount(amt)}
          </span>
        );
      }
    },
    { field: "allowances", headerName: "Allowances (+)", width: 115, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value || 0)}` },
    { field: "deductions", headerName: "Deductions (-)", width: 115, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value || 0)}` },
    {
      field: "net_salary",
      headerName: "Net Salary",
      width: 125,
      type: "numericColumn",
      cellRenderer: (p) => (
        <span style={{ fontWeight: 800, color: "#0f5132" }}>
          ₹{formatAmount(p.value || 0)}
        </span>
      )
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 120,
      sortable: false,
      cellRenderer: (p) => (
        <Box sx={{ display: "flex", gap: 0.5 }}>
          <Tooltip title="View / Print Voucher Slip">
            <IconButton size="small" color="info" onClick={() => setViewVoucher(p.data)}>
              <Print fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit Voucher">
            <IconButton size="small" color="primary" onClick={() => handleEditRow(p.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete Voucher">
            <IconButton
              size="small"
              color="error"
              onClick={() => {
                if (window.confirm(`Are you sure you want to delete Salary Voucher ${p.data.voucher_no}?`)) {
                  deleteMutation.mutate(p.data.id);
                }
              }}
            >
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
        title="Salary Voucher"
        subtitle="Staff monthly salary vouchers calculated from daily attendance (Working Days × Per Day Salary)"
        breadcrumbs={[{ label: "Payroll Voucher" }, { label: "Salary Voucher" }]}
      />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onBulkDelete={async (rows) => {
          await bulkDeleteMutation.mutateAsync(rows);
        }}
        onAdd={async () => {
          setEditing(null);
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
            per_day_salary: 0,
            payable_amount: 0,
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

      {/* CREATE / EDIT SALARY VOUCHER DIALOG */}
      <Dialog open={open} onClose={() => { setOpen(false); setEditing(null); }} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle sx={{ fontWeight: 800, color: "#0f5132" }}>
            {editing ? `Edit Salary Voucher (${editing.voucher_no})` : "New Staff Salary Voucher"}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 12, sm: 6 }}>
                <TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12, sm: 6 }}>
                <TextField {...register("voucher_date")} label="Voucher Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>

              {/* Staff Member Selector */}
              <Grid size={{ xs: 12, sm: 6 }}>
                <Controller
                  name="ledger_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={ledgers}
                      getOptionLabel={(o: any) => `${o.name}${o.ledger_code ? ` (${o.ledger_code})` : ""}${o.per_day_salary ? ` [₹${o.per_day_salary}/day]` : o.basic_salary ? ` [₹${o.basic_salary}/mo]` : ""}`}
                      value={ledgers.find((l: any) => l.id === field.value) || null}
                      onChange={(_, v) => {
                        field.onChange(v ? v.id : "");
                      }}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="Select Staff Member *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                        />
                      )}
                    />
                  )}
                />
              </Grid>

              {/* Month & Year Selection */}
              <Grid size={{ xs: 6, sm: 3 }}>
                <TextField
                  select
                  {...register("month")}
                  label="Payroll Month *"
                  fullWidth
                  value={watchMonth}
                  onChange={(e) => setValue("month", Number(e.target.value))}
                  slotProps={{ inputLabel: { shrink: true } }}
                >
                  {MONTH_NAMES.map((name, i) => (
                    <MenuItem key={i + 1} value={i + 1}>{name}</MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid size={{ xs: 6, sm: 3 }}>
                <TextField
                  {...register("year")}
                  label="Payroll Year *"
                  type="number"
                  fullWidth
                  value={watchYear}
                  onChange={(e) => setValue("year", Number(e.target.value))}
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>

              {/* Real-time Attendance Stats Banner */}
              {watchLedgerId && (
                <Grid size={{ xs: 12 }}>
                  <Paper
                    variant="outlined"
                    sx={{
                      p: 2,
                      bgcolor: "#fcfdfc",
                      borderRadius: "8px",
                      border: "1px solid #d1fae5"
                    }}
                  >
                    <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1.5, flexWrap: "wrap", gap: 1 }}>
                      <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#0f5132", display: "flex", alignItems: "center", gap: 0.8 }}>
                        <EventAvailable fontSize="small" sx={{ color: "#0f5132" }} />
                        Attendance Record for {MONTH_NAMES[watchMonth - 1]} {watchYear}
                        {attendanceStats && ` (${attendanceStats.days_in_month} Calendar Days)`}
                      </Typography>
                      {isStatsLoading ? (
                        <Chip icon={<CircularProgress size={12} color="inherit" />} label="Fetching attendance..." size="small" variant="outlined" />
                      ) : attendanceStats ? (
                        <Chip
                          size="small"
                          label={`Calculated Working Days: ${attendanceStats.working_days} Days`}
                          color="success"
                          sx={{ fontWeight: 800 }}
                        />
                      ) : null}
                    </Box>

                    <Grid container spacing={1}>
                      <Grid size={{ xs: 6, sm: 3 }}>
                        <Box sx={{ p: 1, bgcolor: "#f0fdf4", borderRadius: "6px", textAlign: "center", border: "1px solid #bbf7d0" }}>
                          <Typography variant="caption" sx={{ color: "#166534", fontWeight: 700 }}>PRESENT</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: "#15803d" }}>
                            {attendanceStats?.present_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Full Day (1.0)</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 3 }}>
                        <Box sx={{ p: 1, bgcolor: "#fffbeb", borderRadius: "6px", textAlign: "center", border: "1px solid #fde68a" }}>
                          <Typography variant="caption" sx={{ color: "#92400e", fontWeight: 700 }}>HALF DAY</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: "#b45309" }}>
                            {attendanceStats?.half_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Half Day (0.5)</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 3 }}>
                        <Box sx={{ p: 1, bgcolor: "#fef2f2", borderRadius: "6px", textAlign: "center", border: "1px solid #fecaca" }}>
                          <Typography variant="caption" sx={{ color: "#991b1b", fontWeight: 700 }}>ABSENT</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: "#b91c1c" }}>
                            {attendanceStats?.absent_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Unpaid</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 3 }}>
                        <Box sx={{ p: 1, bgcolor: "#eff6ff", borderRadius: "6px", textAlign: "center", border: "1px solid #bfdbfe" }}>
                          <Typography variant="caption" sx={{ color: "#1e40af", fontWeight: 700 }}>WORKING DAYS</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: "#1d4ed8" }}>
                            {attendanceStats?.working_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Present + (0.5×Half)</Typography>
                        </Box>
                      </Grid>
                    </Grid>

                    {attendanceStats && attendanceStats.total_ot_hours > 0 && (
                      <Typography variant="caption" sx={{ mt: 1, display: "block", color: "#475569" }}>
                        Logged Overtime: <strong>{attendanceStats.total_ot_hours} hrs</strong> | Total Working Hours: <strong>{attendanceStats.total_hours} hrs</strong>
                      </Typography>
                    )}
                  </Paper>
                </Grid>
              )}

              {/* Formula & Calculation Banner */}
              <Grid size={{ xs: 12 }}>
                <Box
                  sx={{
                    p: 1.5,
                    bgcolor: "#f0fdf4",
                    borderRadius: "8px",
                    border: "1px solid #86efac",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    flexWrap: "wrap",
                    gap: 1
                  }}
                >
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                    <Calculate sx={{ color: "#15803d" }} />
                    <Typography variant="body2" sx={{ fontWeight: 700, color: "#15803d" }}>
                      Formula: Working Days ({watchDaysWorked || 0}) × Per Day Salary (₹{watchPerDaySalary || 0}) = Payable Amount: ₹{formatAmount(payable)}
                    </Typography>
                  </Box>
                  <Chip
                    label={`Payable: ₹${formatAmount(payable)}`}
                    color="success"
                    sx={{ fontWeight: 800, fontSize: "0.85rem" }}
                  />
                </Box>
              </Grid>

              {/* Working Days & Per Day Salary Inputs */}
              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  {...register("days_worked")}
                  label="Working Days (from Attendance) *"
                  type="number"
                  fullWidth
                  required
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { step: "0.5", min: "0" }
                  }}
                  helperText="Present days + 0.5 × Half days"
                />
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  {...register("per_day_salary")}
                  label="Per Day Salary (₹) *"
                  type="number"
                  fullWidth
                  required
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { step: "0.01", min: "0" }
                  }}
                  helperText={
                    watchBasicSalary && attendanceStats?.days_in_month
                      ? `Monthly ₹${watchBasicSalary} ÷ ${attendanceStats.days_in_month}d = ₹${(Number(watchBasicSalary) / attendanceStats.days_in_month).toFixed(2)}/d`
                      : "Daily wage rate for calculation"
                  }
                />
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  label="Payable Amount (₹) *"
                  type="number"
                  fullWidth
                  value={payable}
                  disabled
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { style: { fontWeight: 800, color: "#166534" } }
                  }}
                  helperText="Working Days × Per Day Salary"
                />
              </Grid>

              {/* Allowances, Deductions, Net Salary */}
              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  {...register("allowances")}
                  label="Allowances / Bonus (+) (₹)"
                  type="number"
                  fullWidth
                  placeholder="0.00"
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { step: "0.01", min: "0" }
                  }}
                />
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  {...register("deductions")}
                  label="Deductions / Advance (-) (₹)"
                  type="number"
                  fullWidth
                  placeholder="0.00"
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { step: "0.01", min: "0" }
                  }}
                />
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  label="Net Payable Salary (₹) *"
                  type="number"
                  fullWidth
                  value={netSalary}
                  disabled
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { style: { fontWeight: 900, color: "#0f5132", fontSize: "1.05rem" } }
                  }}
                  helperText="Payable + Allowances - Deductions"
                />
              </Grid>

              <Grid size={{ xs: 12 }}>
                <TextField
                  {...register("narration")}
                  label="Narration / Remarks"
                  fullWidth
                  multiline
                  rows={2}
                  placeholder="e.g. Salary for September 2026 based on biometric attendance register"
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2.5, gap: 1 }}>
            <Button onClick={() => { setOpen(false); setEditing(null); }} variant="outlined">Cancel</Button>
            <Button
              type="submit"
              variant="contained"
              disabled={saveMutation.isPending}
              sx={{ bgcolor: "#0f5132", "&:hover": { bgcolor: "#0b3d26" }, fontWeight: 700, px: 3 }}
            >
              {saveMutation.isPending ? "Saving..." : editing ? "Update Voucher" : "Save Salary Voucher"}
            </Button>
          </DialogActions>
        </form>
      </Dialog>

      {/* VIEW / PRINT SALARY SLIP DIALOG */}
      <Dialog open={!!viewVoucher} onClose={() => setViewVoucher(null)} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ fontWeight: 800, color: "#0f5132", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span>Staff Salary Voucher Slip</span>
          <Button
            size="small"
            variant="contained"
            startIcon={<Print />}
            onClick={() => window.print()}
            sx={{ bgcolor: "#0f5132", "&:hover": { bgcolor: "#0b3d26" } }}
          >
            Print
          </Button>
        </DialogTitle>
        <DialogContent dividers>
          {viewVoucher && (
            <Box sx={{ p: 1 }}>
              <Box sx={{ textAlign: "center", mb: 2 }}>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "#1e293b" }}>
                  SALARY VOUCHER
                </Typography>
                <Typography variant="body2" sx={{ color: "text.secondary" }}>
                  Period: {MONTH_NAMES[(viewVoucher.month || 1) - 1]} {viewVoucher.year}
                </Typography>
              </Box>

              <Paper variant="outlined" sx={{ p: 1.5, mb: 2, bgcolor: "#f8fafc" }}>
                <Grid container spacing={1}>
                  <Grid size={6}>
                    <Typography variant="caption" color="text.secondary">Voucher No:</Typography>
                    <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.voucher_no}</Typography>
                  </Grid>
                  <Grid size={6}>
                    <Typography variant="caption" color="text.secondary">Date:</Typography>
                    <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.voucher_date}</Typography>
                  </Grid>
                  <Grid size={12}>
                    <Typography variant="caption" color="text.secondary">Staff Name:</Typography>
                    <Typography variant="body1" sx={{ fontWeight: 800, color: "#0f5132" }}>
                      {viewVoucher.staff_name || staffMap[viewVoucher.ledger_id]?.name || `Staff #${viewVoucher.ledger_id}`}
                      {viewVoucher.staff_code && ` (${viewVoucher.staff_code})`}
                    </Typography>
                  </Grid>
                </Grid>
              </Paper>

              <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1, color: "#1e293b" }}>
                Attendance & Salary Calculation:
              </Typography>
              <Paper variant="outlined" sx={{ p: 2, mb: 2, bgcolor: "#ffffff" }}>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed #e2e8f0" }}>
                  <Typography variant="body2">Working Days (from Attendance):</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.days_worked} Days</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed #e2e8f0" }}>
                  <Typography variant="body2">Per Day Salary Rate:</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 700 }}>₹{formatAmount(viewVoucher.per_day_salary || 0)}</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.75, bgcolor: "#f0fdf4", px: 1, borderRadius: "4px", mt: 0.5 }}>
                  <Typography variant="body2" sx={{ fontWeight: 700, color: "#166534" }}>
                    Payable Amount (Working Days × Rate):
                  </Typography>
                  <Typography variant="body2" sx={{ fontWeight: 800, color: "#166534" }}>
                    ₹{formatAmount(viewVoucher.payable_amount || (Number(viewVoucher.days_worked || 0) * Number(viewVoucher.per_day_salary || 0)))}
                  </Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed #e2e8f0", mt: 1 }}>
                  <Typography variant="body2">Allowances / Incentives (+):</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 600 }}>₹{formatAmount(viewVoucher.allowances || 0)}</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed #e2e8f0" }}>
                  <Typography variant="body2">Deductions / Advances (-):</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 600, color: "#b91c1c" }}>₹{formatAmount(viewVoucher.deductions || 0)}</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 1, mt: 1, borderTop: "2px solid #0f5132" }}>
                  <Typography variant="subtitle1" sx={{ fontWeight: 800, color: "#0f5132" }}>Net Payable Salary:</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 900, color: "#0f5132" }}>
                    ₹{formatAmount(viewVoucher.net_salary || 0)}
                  </Typography>
                </Box>
              </Paper>

              {viewVoucher.narration && (
                <Typography variant="caption" sx={{ color: "text.secondary", display: "block", fontStyle: "italic" }}>
                  Narration: {viewVoucher.narration}
                </Typography>
              )}
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewVoucher(null)}>Close</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
