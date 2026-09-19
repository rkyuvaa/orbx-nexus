import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, MenuItem, Grid, IconButton, Chip, Tooltip, Alert, Typography, Divider, Autocomplete,
  ToggleButton, ToggleButtonGroup, Switch
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import PhotoCamera from "@mui/icons-material/PhotoCamera";
import Person from "@mui/icons-material/Person";
import { useForm, Controller } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { formatAmount } from "../../utils/format";

const optionalNumber = z.preprocess((val) => {
  if (val === "" || val === null || val === undefined) return null;
  const num = Number(val);
  return isNaN(num) ? null : num;
}, z.number().nullish());

const schema = z.object({
  name: z.string().min(1, "Name is required"),
  ledger_code: z.string().nullish(),
  biometric_id: z.string().nullish(),
  ledger_type: z.string().nullish(),
  opening_balance: optionalNumber,
  balance_type: z.string().nullish(),
  phone: z.string().nullish(),
  mobile: z.string().nullish(),
  process_id: optionalNumber,
  process_ids: z.any().nullish(),
  address: z.string().nullish(),
  city: z.string().nullish(),
  pincode: z.string().nullish(),
  state: z.string().nullish(),
  gstin: z.string().nullish(),
  pan: z.string().nullish(),
  bank_name: z.string().nullish(),
  bank_account_no: z.string().nullish(),
  bank_ifsc: z.string().nullish(),
  designation: z.string().nullish(),
  department: z.string().nullish(),
  staff_category: z.string().nullish(),
  basic_salary: optionalNumber,
  per_day_salary: optionalNumber,
  hourly_rate: optionalNumber,
  join_date: z.string().nullish(),
  is_active: z.boolean().default(true),
});

type FormData = z.infer<typeof schema>;

interface LedgerPageProps {
  ledgerType: "Account" | "Staff" | "Contractor";
  title: string;
  breadcrumbs: { label: string; path?: string }[];
}

export default function LedgerPage({ ledgerType, title, breadcrumbs }: LedgerPageProps) {
  const displayName = title === "Supplier" ? "Supplier" : ledgerType;
  const isStaff = ledgerType === "Staff";
  const isContractor = ledgerType === "Contractor";
  const isStaffOrContractor = isStaff || isContractor;
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [deleteId, setDeleteId] = useState<number | null>(null);
  const [photo, setPhoto] = useState<string | null>(null);
  const [previewOpen, setPreviewOpen] = useState(false);
  const [statusFilter, setStatusFilter] = useState<"active" | "inactive" | "all">("active");

  const queryParam = statusFilter === "active" ? "&is_active=true" : statusFilter === "inactive" ? "&is_active=false" : "";

  const { data: ledgers = [], isLoading, refetch } = useQuery({
    queryKey: ["ledgers", ledgerType, statusFilter],
    queryFn: async () => (await api.get(`/ledgers/?ledger_type=${ledgerType}${queryParam}`)).data,
  });

  const { data: processes = [] } = useQuery({
    queryKey: ["processes"],
    queryFn: async () => (await api.get("/products/processes/all")).data,
  });

  const { data: groups = [] } = useQuery({
    queryKey: ["ledger-groups"],
    queryFn: async () => (await api.get("/ledgers/groups")).data,
  });

  const defaultGroupId = useMemo(() => {
    if (!groups || groups.length === 0) return 1;
    if (ledgerType === "Staff") {
      const found = groups.find((g: any) => g.name.toLowerCase().includes("staff") || g.name.toLowerCase().includes("salary"));
      return found ? found.id : groups[0].id;
    }
    if (ledgerType === "Contractor") {
      const found = groups.find((g: any) => g.name.toLowerCase().includes("contractor") || g.name.toLowerCase().includes("payable"));
      return found ? found.id : groups[0].id;
    }
    return groups[0].id;
  }, [groups, ledgerType]);

  const { register, handleSubmit, control, reset, watch, setValue, formState: { errors } } = useForm<any>({
    resolver: zodResolver(schema),
    defaultValues: { ledger_type: ledgerType, balance_type: "Dr", opening_balance: 0, staff_category: "Staff", hourly_rate: 0, is_active: true },
  });

  const saveMutation = useMutation({
    mutationFn: async (data: any) => {
      const payload = {
        ...data,
        photo,
        ledger_type: ledgerType,
        ledger_code: data.ledger_code && String(data.ledger_code).trim() !== "" ? String(data.ledger_code).trim() : null,
        group_id: Number(data.group_id) || defaultGroupId,
        process_id: Number(data.process_id) || null,
        process_ids: data.process_ids || null,
        opening_balance: data.opening_balance !== "" && data.opening_balance !== null && data.opening_balance !== undefined ? parseFloat(data.opening_balance) : 0,
        basic_salary: data.basic_salary !== "" && data.basic_salary !== null && data.basic_salary !== undefined ? parseFloat(data.basic_salary) : null,
        hourly_rate: data.hourly_rate !== "" && data.hourly_rate !== null && data.hourly_rate !== undefined ? parseFloat(data.hourly_rate) : 0,
        is_active: data.is_active ?? true,
      };
      const res = editing ? await api.put(`/ledgers/${editing.id}`, payload) : await api.post("/ledgers/", payload);
      const savedLedger = res.data;
      if (photo) {
        localStorage.setItem(`ledger_photo_${savedLedger.id}`, photo);
      } else {
        localStorage.removeItem(`ledger_photo_${savedLedger.id}`);
      }
      return savedLedger;
    },
    onSuccess: () => {
      handleClose();
      setTimeout(() => {
        qc.invalidateQueries({ queryKey: ["ledgers"] });
        qc.invalidateQueries({ queryKey: ["ledgers-all"] });
      }, 100);
    },
    onError: (err: any) => {
      const detail = err?.response?.data?.detail;
      const msg = typeof detail === "string" ? detail : Array.isArray(detail) ? detail.map((d: any) => d.msg).join(", ") : err?.message || "Failed to save record";
      alert(msg);
    },
  });

  const ledgerToDelete = useMemo(() => {
    return ledgers.find((l: any) => l.id === deleteId);
  }, [ledgers, deleteId]);

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await api.delete(`/ledgers/${id}`);
      localStorage.removeItem(`ledger_photo_${id}`);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["ledgers"] });
      qc.invalidateQueries({ queryKey: ["ledgers-all"] });
      setDeleteId(null);
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || "Failed to process delete request");
    },
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: async (rows: any[]) => {
      await Promise.all(
        rows.map(async (r) => {
          await api.delete(`/ledgers/${r.id}`);
          localStorage.removeItem(`ledger_photo_${r.id}`);
        })
      );
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["ledgers", ledgerType], refetchType: "all" });
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || "Failed to process bulk delete");
    },
  });

  const bulkStatusMutation = useMutation({
    mutationFn: async ({ rows, is_active }: { rows: any[]; is_active: boolean }) => {
      await Promise.all(rows.map((r) => api.patch(`/ledgers/${r.id}/status`, { is_active })));
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["ledgers", ledgerType], refetchType: "all" });
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || "Failed to update status of selected records");
    },
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    if (row?.id) {
      setPhoto(row.photo || localStorage.getItem(`ledger_photo_${row.id}`) || null);
    } else {
      setPhoto(null);
    }
    reset(row ? { ...row, is_active: row.is_active ?? true } : { ledger_type: ledgerType, balance_type: "Dr", opening_balance: 0, staff_category: "Staff", hourly_rate: 0, is_active: true });
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditing(null);
    setPhoto(null);
  };

  const colDefs: ColDef[] = [
    { field: "id", headerName: "ID", width: 80 },
    {
      field: "name",
      headerName: "Name",
      flex: 2,
      minWidth: 180,
      cellRenderer: (p: any) => {
        const photoKey = `ledger_photo_${p.data?.id}`;
        const storedPhoto = p.data?.photo || localStorage.getItem(photoKey);
        return (
          <Box sx={{ display: "flex", alignItems: "center", gap: 1.5, height: "100%" }}>
            {storedPhoto ? (
              <Box
                component="img"
                src={storedPhoto}
                sx={{ width: 28, height: 28, borderRadius: "50%", objectFit: "cover", border: "1px solid rgba(0,0,0,0.08)" }}
              />
            ) : (
              <Box
                sx={{
                  width: 28,
                  height: 28,
                  borderRadius: "50%",
                  bgcolor: "grey.200",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  border: "1px solid rgba(0,0,0,0.08)",
                }}
              >
                <Person sx={{ fontSize: 16, color: "grey.500" }} />
              </Box>
            )}
            <Typography sx={{ fontSize: "inherit", fontWeight: "inherit" }}>{p.value}</Typography>
          </Box>
        );
      }
    },
    { field: "ledger_code", headerName: "Code", width: 100 },
    { field: "biometric_id", headerName: "Biometric ID", width: 130 },
    {
      field: "is_active",
      headerName: "Status",
      width: 120,
      cellRenderer: (p: any) => {
        const active = p.data?.is_active ?? true;
        return (
          <Box
            onClick={(e) => e.stopPropagation()}
            sx={{ display: "flex", alignItems: "center", gap: 0.5, height: "100%" }}
          >
            <Switch
              size="small"
              checked={active}
              onChange={async (e) => {
                e.stopPropagation();
                const newStatus = e.target.checked;
                try {
                  await api.patch(`/ledgers/${p.data.id}/status`, { is_active: newStatus });
                  qc.invalidateQueries({ queryKey: ["ledgers", ledgerType], refetchType: "all" });
                } catch (err: any) {
                  const detail = err?.response?.data?.detail;
                  const msg = typeof detail === "string" ? detail : Array.isArray(detail) ? detail.map((d: any) => d.msg).join(", ") : "Failed to update status";
                  alert(msg);
                }
              }}
              color="success"
            />
            <Typography
              variant="caption"
              sx={{
                fontWeight: 600,
                color: active ? "success.main" : "text.secondary",
                fontSize: "0.75rem",
              }}
            >
              {active ? "Active" : "Inactive"}
            </Typography>
          </Box>
        );
      }
    },
    { field: "opening_balance", headerName: "Opening Bal.", width: 130, type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "balance_type", headerName: "Type", width: 80,
      cellRenderer: (p: any) => <Chip label={p.value} size="small" color={p.value === "Dr" ? "info" : "warning"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "mobile", headerName: "Mobile", width: 130 },
    {
      field: "process_ids",
      headerName: "Processes",
      width: 180,
      valueGetter: (p: any) => {
        const raw = p.data?.process_ids || (p.data?.process_id ? String(p.data.process_id) : "");
        if (!raw) return "-";
        const ids = String(raw).split(",").map((x) => Number(x.trim())).filter(Boolean);
        const names = ids.map((id) => processes.find((proc: any) => proc.id === id)?.name).filter(Boolean);
        return names.length > 0 ? names.join(", ") : "-";
      }
    },
    {
      headerName: "Actions", width: 100, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box
          onClick={(e) => e.stopPropagation()}
          sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}
        >
          <Tooltip title="Edit">
            <IconButton
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                handleOpen(p.data);
              }}
            >
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton
              size="small"
              color="error"
              onClick={(e) => {
                e.stopPropagation();
                setOpen(false);
                setDeleteId(p.data.id);
              }}
            >
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  const onSubmit = (data: any) => {
    saveMutation.mutate(data);
  };

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader title={title} subtitle={`Manage ${displayName.toLowerCase()} accounts`} breadcrumbs={breadcrumbs} />
      <Box sx={{ display: "flex", alignItems: "center", gap: 1.5, px: 0.5, py: 0.5 }}>
        <Typography variant="body2" sx={{ fontWeight: 600, color: "text.secondary" }}>
          Status:
        </Typography>
        <ToggleButtonGroup
          size="small"
          value={statusFilter}
          exclusive
          onChange={(_, val) => { if (val) setStatusFilter(val); }}
          sx={{ height: 32 }}
        >
          <ToggleButton value="active" sx={{ textTransform: "none", px: 2, py: 0.2, fontSize: "0.75rem", fontWeight: 600 }}>
            Active
          </ToggleButton>
          <ToggleButton value="inactive" sx={{ textTransform: "none", px: 2, py: 0.2, fontSize: "0.75rem", fontWeight: 600 }}>
            Inactive
          </ToggleButton>
          <ToggleButton value="all" sx={{ textTransform: "none", px: 2, py: 0.2, fontSize: "0.75rem", fontWeight: 600 }}>
            All
          </ToggleButton>
        </ToggleButtonGroup>
      </Box>
      <OrbxGrid
        rowData={ledgers}
        columnDefs={colDefs}
        loading={isLoading}
        onRowClicked={handleOpen}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel={`Add ${displayName}`}
        onBulkDelete={async (rows) => {
          await bulkDeleteMutation.mutateAsync(rows);
        }}
        onBulkStatusChange={async (rows, is_active) => {
          await bulkStatusMutation.mutateAsync({ rows, is_active });
        }}
      />

      <Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit(onSubmit, (errs) => console.error("Form validation errors:", errs))}>
          <DialogTitle>{editing ? `Edit ${displayName} (ID: #${editing.id})` : `Add ${displayName}`}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("name")} label="Name *" fullWidth error={!!errors.name} helperText={errors.name?.message ? String(errors.name.message) : ""} slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6, sm: 4 }}><TextField {...register("ledger_code")} label="Code" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6, sm: 4 }}>
                <TextField
                  {...register("biometric_id")}
                  label="Biometric Machine User ID"
                  placeholder="e.g. 101 or 1002"
                  fullWidth
                  slotProps={{ inputLabel: { shrink: true } }}
                  helperText="User ID / PIN set on Biometric Machine"
                />
              </Grid>
              <Grid size={{ xs: 6, sm: 3 }}><TextField {...register("opening_balance")} label="Opening Balance" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6, sm: 3 }}>
                <Controller name="balance_type" control={control} render={({ field }) => (
                  <TextField {...field} select label="Balance Type" fullWidth slotProps={{ inputLabel: { shrink: true } }}>
                    <MenuItem value="Dr">Dr (Debit)</MenuItem>
                    <MenuItem value="Cr">Cr (Credit)</MenuItem>
                  </TextField>
                )} />
              </Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("phone")} label="Phone" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("mobile")} label="Mobile" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}>
                <Controller
                  name="process_ids"
                  control={control}
                  render={({ field }) => {
                    let rawIds: number[] = [];
                    const val = field.value ?? (editing?.process_ids || (editing?.process_id ? String(editing.process_id) : ""));
                    if (Array.isArray(val)) {
                      rawIds = val.map(Number);
                    } else if (typeof val === "string" && val) {
                      rawIds = val.split(",").map((x: string) => Number(x.trim())).filter(Boolean);
                    } else if (watch("process_id")) {
                      rawIds = [Number(watch("process_id"))];
                    }
                    const selectedValue = processes.filter((p: any) => rawIds.includes(Number(p.id)));

                    return (
                      <Autocomplete
                        multiple
                        size="small"
                        options={processes}
                        getOptionLabel={(option: any) => option?.name || ""}
                        isOptionEqualToValue={(option: any, val: any) => option?.id === val?.id}
                        value={selectedValue}
                        onChange={(_, val) => {
                          const ids = val ? val.map((item: any) => item.id).join(",") : "";
                          field.onChange(ids);
                          if (val && val.length > 0) {
                            setValue("process_id", val[0].id);
                          } else {
                            setValue("process_id", null);
                          }
                        }}
                        renderInput={(params) => <TextField {...params} label="Processes" placeholder="Select processes..." />}
                      />
                    );
                  }}
                />
              </Grid>
              
              {isStaffOrContractor ? (
                <>
                  <Grid size={{ xs: 12, sm: 9 }}>
                    <TextField 
                      {...register("address")} 
                      label="Address" 
                      fullWidth 
                      multiline 
                      rows={2} 
                      slotProps={{ inputLabel: { shrink: true } }} 
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 3 }}>
                    <Box
                      sx={{
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        justifyContent: "center",
                        border: "1px dashed",
                        borderColor: "divider",
                        borderRadius: "12px",
                        p: 1,
                        height: "100%",
                        minHeight: 110,
                        bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.01)",
                      }}
                    >
                      <Box sx={{ position: "relative", mb: 0.5 }}>
                        {photo ? (
                          <Tooltip title="Click to preview">
                            <Box
                              component="img"
                              src={photo}
                              onClick={() => setPreviewOpen(true)}
                              sx={{
                                width: 52,
                                height: 52,
                                borderRadius: "8px",
                                objectFit: "cover",
                                border: "1px solid",
                                borderColor: "divider",
                                cursor: "pointer",
                                "&:hover": { opacity: 0.8 },
                              }}
                            />
                          </Tooltip>
                        ) : (
                          <Box
                            sx={{
                              width: 52,
                              height: 52,
                              borderRadius: "8px",
                              bgcolor: (t) => t.palette.mode === "dark" ? "grey.800" : "grey.100",
                              display: "flex",
                              alignItems: "center",
                              justifyContent: "center",
                              border: "1px solid",
                              borderColor: "divider",
                            }}
                          >
                            <Person sx={{ fontSize: 24, color: "grey.400" }} />
                          </Box>
                        )}
                        {photo && (
                          <IconButton
                            size="small"
                            onClick={() => setPhoto(null)}
                            sx={{
                              position: "absolute",
                              top: -6,
                              right: -6,
                              bgcolor: "error.main",
                              color: "white",
                              p: 0.15,
                              "&:hover": { bgcolor: "error.dark" }
                            }}
                          >
                            <Delete sx={{ fontSize: 10 }} />
                          </IconButton>
                        )}
                      </Box>
                      <Button
                        variant="outlined"
                        component="label"
                        size="small"
                        startIcon={<PhotoCamera sx={{ fontSize: "12px !important" }} />}
                        sx={{ textTransform: "none", fontSize: "0.65rem", py: 0.15, px: 1, borderRadius: "6px" }}
                      >
                        {photo ? "Edit" : "Photo"}
                        <input
                          type="file"
                          accept="image/*"
                          hidden
                          onChange={(e) => {
                            const file = e.target.files?.[0];
                            if (file) {
                              const reader = new FileReader();
                              reader.onloadend = () => {
                                setPhoto(reader.result as string);
                              };
                              reader.readAsDataURL(file);
                            }
                          }}
                        />
                      </Button>
                    </Box>
                  </Grid>
                </>
              ) : (
                <Grid size={12}>
                  <TextField 
                    {...register("address")} 
                    label="Address" 
                    fullWidth 
                    multiline 
                    rows={2} 
                    slotProps={{ inputLabel: { shrink: true } }} 
                  />
                </Grid>
              )}

              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("city")} label="City" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("pincode")} label="Pincode" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("state")} label="State" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("gstin")} label={isStaff || isContractor ? "Aadhar Number" : "GSTIN"} fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("pan")} label="PAN" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_name")} label="Bank Name" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_account_no")} label="Account No." fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_ifsc")} label="IFSC Code" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}>
                <Controller
                  name="is_active"
                  control={control}
                  render={({ field }) => (
                    <TextField
                      {...field}
                      select
                      label="Status *"
                      fullWidth
                      value={field.value !== false ? "true" : "false"}
                      onChange={(e) => field.onChange(e.target.value === "true")}
                      slotProps={{ inputLabel: { shrink: true } }}
                    >
                      <MenuItem value="true">Active</MenuItem>
                      <MenuItem value="false">Inactive</MenuItem>
                    </TextField>
                  )}
                />
              </Grid>
              {isStaff && (
                <>
                  <Grid size={{ xs: 12, sm: 4 }}>
                    <Controller
                      name="staff_category"
                      control={control}
                      render={({ field }) => (
                        <TextField {...field} select label="Staff Category *" fullWidth slotProps={{ inputLabel: { shrink: true } }}>
                          <MenuItem value="Staff">Staff (Fixed Monthly Salary)</MenuItem>
                          <MenuItem value="Labour">Labour (Hour-wise Salary)</MenuItem>
                        </TextField>
                      )}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("designation")} label="Designation" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
                  <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("department")} label="Department" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
                  {watch("staff_category") === "Labour" ? (
                    <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("hourly_rate")} label="Hour-wise Salary (₹ / Hour) *" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} helperText="Hourly rate for labor wage calculation" /></Grid>
                  ) : (
                    <>
                      <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("basic_salary")} label="Fixed Basic Salary (₹ / Month)" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} helperText="Monthly basic salary" /></Grid>
                      <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("per_day_salary")} label="Per Day Salary (₹ / Day)" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} helperText="Daily wage for attendance" /></Grid>
                    </>
                  )}
                  <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("join_date")} label="Join Date" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
                </>
              )}
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={handleClose} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>{saveMutation.isPending ? "Saving..." : "Save"}</Button>
          </DialogActions>
        </form>
      </Dialog>

      <Dialog open={!!deleteId} onClose={() => setDeleteId(null)} maxWidth="xs" fullWidth>
        <DialogTitle sx={{ fontWeight: 700 }}>Delete {displayName}?</DialogTitle>
        <DialogContent>
          <Alert severity="error" sx={{ mb: 1.5 }}>
            Are you sure you want to delete <strong>{ledgerToDelete?.name || `this ${displayName.toLowerCase()}`}</strong>?
          </Alert>
          <Typography variant="body2" color="text.secondary">
            This action cannot be undone. This record will be permanently deleted from the database.
          </Typography>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
          <Button onClick={() => setDeleteId(null)} variant="outlined">Cancel</Button>
          <Button
            color="error"
            variant="contained"
            onClick={() => deleteMutation.mutate(deleteId!)}
            disabled={deleteMutation.isPending}
          >
            {deleteMutation.isPending ? "Deleting..." : "Delete"}
          </Button>
        </DialogActions>
      </Dialog>

      <Dialog open={previewOpen} onClose={() => setPreviewOpen(false)} maxWidth="sm">
        <DialogTitle sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", pb: 1 }}>
          <Typography variant="h6" sx={{ fontWeight: 700 }}>Photo Preview</Typography>
          <Button onClick={() => setPreviewOpen(false)} size="small" variant="text">Close</Button>
        </DialogTitle>
        <Divider />
        <DialogContent sx={{ p: 1, textAlign: "center", display: "flex", justifyContent: "center", bgcolor: "action.hover" }}>
          {photo && (
            <img src={photo} alt="Preview" style={{ maxWidth: "100%", maxHeight: "70vh", objectFit: "contain", borderRadius: "8px", border: "1px solid rgba(0,0,0,0.1)" }} />
          )}
        </DialogContent>
      </Dialog>
    </Box>
  );
}
