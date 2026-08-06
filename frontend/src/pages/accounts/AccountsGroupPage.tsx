import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, MenuItem, Grid, IconButton, Chip, Tooltip, Alert,
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";

const schema_z = {
  name: (v: string) => v.length > 0 ? null : "Name required",
};

export default function AccountsGroupPage() {
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [deleteId, setDeleteId] = useState<number | null>(null);

  const { data: groups = [], isLoading, refetch } = useQuery({
    queryKey: ["ledger-groups"],
    queryFn: async () => (await api.get("/ledgers/groups")).data,
  });

  const { register, handleSubmit, control, reset, formState: { errors } } = useForm({
    defaultValues: { name: "", parent_id: "" as any, group_type: "Liability" },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editing ? api.put(`/ledgers/groups/${editing.id}`, data) : api.post("/ledgers/groups", data),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["ledger-groups"] }); handleClose(); },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/ledgers/groups/${id}`),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["ledger-groups"] }); setDeleteId(null); },
  });

  const handleOpen = (row?: any) => { setEditing(row || null); reset(row || { group_type: "Liability" }); setOpen(true); };
  const handleClose = () => { setOpen(false); setEditing(null); };

  const TYPE_COLORS: Record<string, any> = {
    Assets: "info", Liability: "warning", Income: "success", Expense: "error"
  };

  const colDefs: ColDef[] = [
    { field: "name", headerName: "Group Name", flex: 3, minWidth: 320 },
    { field: "group_type", headerName: "Type", width: 120,
      cellRenderer: (p: any) => <Chip label={p.value} size="small" color={TYPE_COLORS[p.value] || "default"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "is_system", headerName: "System", width: 100,
      cellRenderer: (p: any) => p.value ? <Chip label="System" size="small" sx={{ fontSize: "0.7rem" }} /> : null },
    {
      headerName: "Actions", width: 100, sortable: false, filter: false,
      cellRenderer: (p: any) => !p.data.is_system && (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
          <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => setDeleteId(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader title="Accounts Groups" subtitle="Manage ledger group hierarchy"
        breadcrumbs={[{ label: "Accounts Info" }, { label: "Accounts Groups" }]}
      />
      <OrbxGrid
        rowData={groups}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => handleOpen()}
        addLabel="Add Group"
      />

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? "Edit Group" : "Add Group"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={12}><TextField {...register("name")} label="Group Name *" fullWidth required /></Grid>
              <Grid size={12}>
                <Controller name="group_type" control={control} render={({ field }) => (
                  <TextField {...field} select label="Group Type" fullWidth>
                    {["Assets", "Liability", "Income", "Expense"].map((t) => <MenuItem key={t} value={t}>{t}</MenuItem>)}
                  </TextField>
                )} />
              </Grid>
              <Grid size={12}>
                <Controller name="parent_id" control={control} render={({ field }) => (
                  <TextField {...field} select label="Parent Group (optional)" fullWidth>
                    <MenuItem value="">None</MenuItem>
                    {groups.filter((g: any) => g.id !== editing?.id).map((g: any) => <MenuItem key={g.id} value={g.id}>{g.name}</MenuItem>)}
                  </TextField>
                )} />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={handleClose} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>

      <Dialog open={!!deleteId} onClose={() => setDeleteId(null)} maxWidth="xs">
        <DialogTitle>Delete Group?</DialogTitle>
        <DialogContent><Alert severity="warning">This will fail if ledgers are assigned to this group.</Alert></DialogContent>
        <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
          <Button onClick={() => setDeleteId(null)} variant="outlined">Cancel</Button>
          <Button color="error" variant="contained" onClick={() => deleteMutation.mutate(deleteId!)} disabled={deleteMutation.isPending}>Delete</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
