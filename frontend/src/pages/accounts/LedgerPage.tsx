import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, MenuItem, Grid, IconButton, Chip, Tooltip, Alert, Typography,
} from "@mui/material";
import { Add, Edit, Delete, Refresh, PhotoCamera, Person } from "@mui/icons-material";
import { useForm, Controller } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { formatAmount } from "../../utils/format";
const schema = z.object({
  name: z.string().min(1, "Name is required"),
  ledger_code: z.string().nullish(),
  ledger_type: z.string(),
  opening_balance: z.coerce.number().default(0),
  balance_type: z.string(),
  phone: z.string().nullish(),
  mobile: z.string().nullish(),
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
  basic_salary: z.coerce.number().nullish(),
  join_date: z.string().nullish(),
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
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [deleteId, setDeleteId] = useState<number | null>(null);
  const [photo, setPhoto] = useState<string | null>(null);

  const { data: ledgers = [], isLoading, refetch } = useQuery({
    queryKey: ["ledgers", ledgerType],
    queryFn: async () => (await api.get(`/ledgers/?ledger_type=${ledgerType}&is_active=true`)).data,
  });

  const { register, handleSubmit, control, reset, formState: { errors } } = useForm<any>({
    resolver: zodResolver(schema),
    defaultValues: { ledger_type: ledgerType, balance_type: "Dr", opening_balance: 0 },
  });

  const saveMutation = useMutation({
    mutationFn: async (data: any) => {
      const payload = { ...data, ledger_type: ledgerType, group_id: 157 };
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
        qc.invalidateQueries({ queryKey: ["ledgers", ledgerType], refetchType: "all" });
      }, 100);
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to save supplier";
      alert(msg);
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await api.delete(`/ledgers/${id}`);
      localStorage.removeItem(`ledger_photo_${id}`);
    },
    onSuccess: () => {
      qc.setQueryData(["ledgers", ledgerType], (old: any[]) => (old || []).filter((item) => item.id !== deleteId));
      setDeleteId(null);
    },
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    if (row?.id) {
      setPhoto(localStorage.getItem(`ledger_photo_${row.id}`) || null);
    } else {
      setPhoto(null);
    }
    reset(row || { ledger_type: ledgerType, balance_type: "Dr", opening_balance: 0 });
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditing(null);
    setPhoto(null);
  };

  const colDefs: ColDef[] = [
    {
      field: "name",
      headerName: "Name",
      flex: 2,
      minWidth: 180,
      cellRenderer: (p: any) => {
        const photoKey = `ledger_photo_${p.data?.id}`;
        const storedPhoto = localStorage.getItem(photoKey);
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
    { field: "opening_balance", headerName: "Opening Bal.", width: 130, type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "balance_type", headerName: "Type", width: 80,
      cellRenderer: (p: any) => <Chip label={p.value} size="small" color={p.value === "Dr" ? "info" : "warning"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "mobile", headerName: "Mobile", width: 130 },
    ...(ledgerType === "Staff" ? [{ field: "basic_salary", headerName: "Basic Salary", width: 130,
        valueFormatter: (p: any) => p.value ? `₹${formatAmount(p.value)}` : "-" }] : []),
    {
      headerName: "Actions", width: 100, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
          <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => setDeleteId(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
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
      <OrbxGrid
        rowData={ledgers}
        columnDefs={colDefs}
        loading={isLoading}
        onRowClicked={handleOpen}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel={`Add ${displayName}`}
      />

      <Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit(onSubmit)}>
          <DialogTitle>{editing ? `Edit ${displayName}` : `Add ${displayName}`}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              {/* Photo Upload Row for Staff Ledger */}
              {isStaff && (
                <Grid size={12}>
                  <Box sx={{ display: "flex", alignItems: "center", gap: 2, p: 1.5, border: "1px dashed", borderColor: "divider", borderRadius: "12px", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.02)" : "rgba(0,0,0,0.01)" }}>
                    <Box sx={{ position: "relative" }}>
                      {photo ? (
                        <Box
                          component="img"
                          src={photo}
                          sx={{ width: 64, height: 64, borderRadius: "8px", objectFit: "cover", border: "1px solid", borderColor: "divider" }}
                        />
                      ) : (
                        <Box
                          sx={{
                            width: 64,
                            height: 64,
                            borderRadius: "8px",
                            bgcolor: "grey.100",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                            border: "1px solid",
                            borderColor: "divider",
                          }}
                        >
                          <Person sx={{ fontSize: 32, color: "grey.400" }} />
                        </Box>
                      )}
                      {photo && (
                        <IconButton
                          size="small"
                          onClick={() => setPhoto(null)}
                          sx={{
                            position: "absolute",
                            top: -8,
                            right: -8,
                            bgcolor: "error.main",
                            color: "white",
                            p: 0.25,
                            "&:hover": { bgcolor: "error.dark" }
                          }}
                        >
                          <Delete sx={{ fontSize: 12 }} />
                        </IconButton>
                      )}
                    </Box>
                    <Box sx={{ display: "flex", flexDirection: "column", gap: 0.75 }}>
                      <Typography variant="caption" sx={{ fontWeight: 500, color: "text.secondary" }}>
                        Upload employee photograph or capture using device camera
                      </Typography>
                      <Button
                        variant="outlined"
                        component="label"
                        size="small"
                        startIcon={<PhotoCamera />}
                        sx={{ textTransform: "none", alignSelf: "flex-start", borderRadius: "8px" }}
                      >
                        Choose / Take Photo
                        <input
                          type="file"
                          accept="image/*"
                          capture="user"
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
                  </Box>
                </Grid>
              )}

              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("name")} label="Name *" fullWidth error={!!errors.name} helperText={errors.name?.message ? String(errors.name.message) : ""} /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("ledger_code")} label="Code" fullWidth /></Grid>
              <Grid size={{ xs: 6, sm: 3 }}><TextField {...register("opening_balance")} label="Opening Balance" type="number" fullWidth /></Grid>
              <Grid size={{ xs: 6, sm: 3 }}>
                <Controller name="balance_type" control={control} render={({ field }) => (
                  <TextField {...field} select label="Balance Type" fullWidth>
                    <MenuItem value="Dr">Dr (Debit)</MenuItem>
                    <MenuItem value="Cr">Cr (Credit)</MenuItem>
                  </TextField>
                )} />
              </Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("phone")} label="Phone" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("mobile")} label="Mobile" fullWidth /></Grid>
              <Grid size={12}><TextField {...register("address")} label="Address" fullWidth multiline rows={2} /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("city")} label="City" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("pincode")} label="Pincode" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("state")} label="State" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("gstin")} label={isStaff ? "Aadhar Number" : "GSTIN"} fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("pan")} label="PAN" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_name")} label="Bank Name" fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_account_no")} label="Account No." fullWidth /></Grid>
              <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("bank_ifsc")} label="IFSC Code" fullWidth /></Grid>
              {isStaff && (
                <>
                  <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("designation")} label="Designation" fullWidth /></Grid>
                  <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("department")} label="Department" fullWidth /></Grid>
                  <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("basic_salary")} label="Basic Salary" type="number" fullWidth /></Grid>
                  <Grid size={{ xs: 12, sm: 6 }}><TextField {...register("join_date")} label="Join Date" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
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

      <Dialog open={!!deleteId} onClose={() => setDeleteId(null)} maxWidth="xs">
        <DialogTitle>Delete {displayName}?</DialogTitle>
        <DialogContent><Alert severity="warning">This action cannot be undone.</Alert></DialogContent>
        <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
          <Button onClick={() => setDeleteId(null)} variant="outlined">Cancel</Button>
          <Button color="error" variant="contained" onClick={() => deleteMutation.mutate(deleteId!)} disabled={deleteMutation.isPending}>Delete</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
