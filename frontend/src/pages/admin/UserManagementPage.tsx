import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, Chip, Switch, FormControlLabel,
  Table, TableHead, TableBody, TableRow, TableCell, Paper, Typography, MenuItem,
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Refresh from "@mui/icons-material/Refresh";
import LockOutlined from "@mui/icons-material/LockOutlined";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { alpha } from "@mui/material/styles";

const ACCENT = "#00a86b";
const MODULES = ["master", "accounts", "inventory", "process", "process_voucher", "labour_bill", "payroll", "contractor", "reports", "admin", "backups", "biometrics"];

export default function UserManagementPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [permOpen, setPermOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [selectedUser, setSelectedUser] = useState<any>(null);
  const [perms, setPerms] = useState<any[]>([]);

  const { data: users = [], isLoading, refetch } = useQuery({
    queryKey: ["users"],
    queryFn: async () => (await api.get("/auth/users")).data,
  });

  const { register, handleSubmit, reset } = useForm({ defaultValues: { username: "", password: "", full_name: "", email: "", role: "User" } });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editing ? api.put(`/auth/users/${editing.id}`, data) : api.post("/auth/users", data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["users"] }); setOpen(false); },
  });

  const permMutation = useMutation({
    mutationFn: (data: any[]) => api.put(`/auth/users/${selectedUser.id}/permissions`, data),
    onSuccess: () => setPermOpen(false),
  });

  const handleOpenPerm = async (user: any) => {
    setSelectedUser(user);
    try {
      const res = await api.get(`/auth/users/${user.id}/permissions`);
      const existingPerms = res.data;
      const merged = MODULES.map((mod) => {
        const found = existingPerms.find((p: any) => p.module === mod);
        return found || { module: mod, can_view: false, can_create: false, can_edit: false, can_delete: false, can_print: false };
      });
      setPerms(merged);
    } catch { setPerms(MODULES.map((mod) => ({ module: mod, can_view: false, can_create: false, can_edit: false, can_delete: false, can_print: false }))); }
    setPermOpen(true);
  };

  const togglePerm = (modIdx: number, field: string) => {
    setPerms((p) => p.map((perm, i) => i === modIdx ? { ...perm, [field]: !perm[field] } : perm));
  };

  const colDefs: ColDef[] = [
    { field: "username", headerName: "Username", width: 140 },
    { field: "full_name", headerName: "Full Name", flex: 1 },
    { field: "email", headerName: "Email", flex: 1 },
    { field: "role", headerName: "Role", width: 100, cellRenderer: (p: any) => <Chip label={p.value} size="small" color={p.value === "Admin" ? "warning" : "default"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "is_active", headerName: "Active", width: 90, cellRenderer: (p: any) => <Chip label={p.value ? "Active" : "Inactive"} size="small" color={p.value ? "success" : "error"} sx={{ fontSize: "0.7rem" }} /> },
    { headerName: "Actions", width: 150, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => { setEditing(p.data); reset({ ...p.data, password: "" }); setOpen(true); }}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Permissions"><Button size="small" startIcon={<LockOutlined />} onClick={() => handleOpenPerm(p.data)} sx={{ fontSize: "0.7rem" }}>Perms</Button></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box>
      <PageHeader title="User Management" subtitle="Manage system users and permissions" breadcrumbs={[{ label: "Administration" }, { label: "User Management" }]} />
      <OrbxGrid
        rowData={users}
        columnDefs={colDefs}
        loading={isLoading}
        height={400}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); reset({ username: "", password: "", full_name: "", email: "", role: "User" }); setOpen(true); }}
        addLabel="Add User"
      />

      {/* Add/Edit User */}
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit User" : "Add User"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}><TextField {...register("username")} label="Username" fullWidth required disabled={!!editing} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("password")} label={editing ? "New Password (leave blank to keep)" : "Password"} type="password" fullWidth required={!editing} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("full_name")} label="Full Name" fullWidth /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("email")} label="Email" type="email" fullWidth /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("role")} select label="Role" fullWidth>
                {["Admin", "User"].map((r) => <MenuItem key={r} value={r}>{r}</MenuItem>)}
              </TextField></Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setOpen(false)} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>

      {/* Permissions */}
      <Dialog open={permOpen} onClose={() => setPermOpen(false)} maxWidth="md" fullWidth>
        <DialogTitle>Permissions — {selectedUser?.username}</DialogTitle>
        <DialogContent>
          <Paper variant="outlined" sx={{ overflow: "auto" }}>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell sx={{ fontWeight: 700, width: 160 }}>Module</TableCell>
                  {["View", "Create", "Edit", "Delete", "Print"].map((h) => <TableCell key={h} align="center" sx={{ fontWeight: 600, fontSize: "0.75rem" }}>{h}</TableCell>)}
                </TableRow>
              </TableHead>
              <TableBody>
                {perms.map((perm, i) => (
                  <TableRow key={perm.module} hover>
                    <TableCell sx={{ fontWeight: 500, textTransform: "capitalize" }}>{perm.module.replace(/_/g, " ")}</TableCell>
                    {(["can_view", "can_create", "can_edit", "can_delete", "can_print"] as const).map((field) => (
                      <TableCell key={field} align="center"><Switch size="small" checked={perm[field]} onChange={() => togglePerm(i, field)} sx={{ "& .MuiSwitch-thumb": { bgcolor: perm[field] ? ACCENT : undefined }, "& .Mui-checked + .MuiSwitch-track": { bgcolor: alpha(ACCENT, 0.5) } }} /></TableCell>
                    ))}
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </Paper>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
          <Button onClick={() => setPermOpen(false)} variant="outlined">Cancel</Button>
          <Button variant="contained" onClick={() => permMutation.mutate(perms)} disabled={permMutation.isPending}>Save Permissions</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
