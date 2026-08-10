import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid, IconButton, Tooltip, Typography, Card, CardContent } from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import { useForm } from "react-hook-form";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { ColDef } from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";

export default function DocumentNumberingPage() {
  const { user } = useAuthStore();
  const isAdmin = user?.role === "Admin";
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["document-sequences"],
    queryFn: async () => (await api.get("/sequences/settings")).data,
  });

  const { register, handleSubmit, reset } = useForm({
    defaultValues: { prefix: "", suffix: "", current_number: 0, padding_width: 3 },
  });

  const updateMutation = useMutation({
    mutationFn: (body: any) => api.put(`/sequences/settings/${editing.id}`, body),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["document-sequences"] });
      setOpen(false);
    },
  });

  const handleEdit = (row: any) => {
    if (!isAdmin) return;
    setEditing(row);
    reset({
      prefix: row.prefix || "",
      suffix: row.suffix || "",
      current_number: row.current_number || 0,
      padding_width: row.padding_width || 3,
    });
    setOpen(true);
  };

  const getDocTypeLabel = (docType: string) => {
    const labels: Record<string, string> = {
      stock_inward: "Customer Material Inward",
      stock_outward: "Customer Material Outward",
      job_work_register: "Contractor Work Register",
      job_work_payment: "Contractor Work Payment",
      job_work_advance_payment: "Contractor Advance Payment",
      job_work_advance_receipt: "Contractor Advance Receipt",
      voucher_payment: "Voucher - Payment",
      voucher_receipt: "Voucher - Receipt",
      voucher_contra: "Voucher - Contra",
      voucher_journal: "Voucher - Journal",
      voucher_purchase: "Voucher - Purchase",
      labour_bill: "Labour Bill",
      staff_advance_payment: "Staff Advance Payment",
      staff_advance_receipt: "Staff Advance Receipt",
      salary_voucher: "Staff Salary Voucher",
    };
    return labels[docType] || docType;
  };

  const colDefs: ColDef[] = [
    {
      field: "document_type",
      headerName: "Document Type",
      flex: 1.5,
      minWidth: 200,
      valueFormatter: (p) => getDocTypeLabel(p.value),
    },
    { field: "prefix", headerName: "Prefix", width: 120 },
    { field: "suffix", headerName: "Suffix", width: 120 },
    { field: "current_number", headerName: "Current No.", width: 120, type: "numericColumn" },
    { field: "padding_width", headerName: "Padding", width: 100, type: "numericColumn" },
    {
      headerName: "Next Number Preview",
      flex: 1,
      minWidth: 180,
      valueGetter: (p) => {
        const next = (p.data.current_number || 0) + 1;
        const numStr = String(next).padStart(p.data.padding_width || 3, "0");
        return `${p.data.prefix || ""}${numStr}${p.data.suffix || ""}`;
      },
    },
    ...(isAdmin
      ? [
          {
            headerName: "Actions",
            width: 100,
            sortable: false,
            filter: false,
            cellRenderer: (p: any) => (
              <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
                <Tooltip title="Edit Sequence">
                  <IconButton size="small" onClick={() => handleEdit(p.data)}>
                    <Edit fontSize="small" />
                  </IconButton>
                </Tooltip>
              </Box>
            ),
          },
        ]
      : []),
  ];

  return (
    <Box>
      <PageHeader
        title="Document Numbering"
        breadcrumbs={[{ label: "Settings" }, { label: "Document Numbering" }]}
      />
      {!isAdmin && (
        <Card sx={{ mb: 2, bgcolor: "#fffbe6", border: "1px solid #ffe58f" }}>
          <CardContent sx={{ py: 1.5, "&:last-child": { pb: 1.5 } }}>
            <Typography variant="body2" color="warning.main">
              <strong>Notice:</strong> Only administrators can edit document numbering sequences.
            </Typography>
          </CardContent>
        </Card>
      )}
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
      />

      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => updateMutation.mutate(d))}>
          <DialogTitle>Edit Numbering: {editing ? getDocTypeLabel(editing.document_type) : ""}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("prefix")} label="Prefix" fullWidth />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("suffix")} label="Suffix" fullWidth />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("current_number", { valueAsNumber: true })}
                  label="Current Counter Number"
                  type="number"
                  fullWidth
                  required
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("padding_width", { valueAsNumber: true })}
                  label="Zero Padding Width"
                  type="number"
                  fullWidth
                  required
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setOpen(false)} variant="outlined">
              Cancel
            </Button>
            <Button type="submit" variant="contained" disabled={updateMutation.isPending}>
              Save Sequence
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}
