import { useState, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Card, CardContent, Typography, Chip, CircularProgress, Alert,
  IconButton, Tooltip, Dialog, DialogTitle, DialogContent, DialogContentText, DialogActions
} from "@mui/material";
import CloudUpload from "@mui/icons-material/CloudUpload";
import Delete from "@mui/icons-material/Delete";
import Backup from "@mui/icons-material/Backup";
import Download from "@mui/icons-material/Download";
import RestorePage from "@mui/icons-material/RestorePage";
import UploadFile from "@mui/icons-material/UploadFile";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { alpha } from "@mui/material/styles";

const ACCENT = "#00a86b";

export default function BackupsPage() {
  const qc = useQueryClient();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [creating, setCreating] = useState(false);
  const [restoring, setRestoring] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMsg, setSuccessMsg] = useState<string | null>(null);
  const [selectedBackupToRestore, setSelectedBackupToRestore] = useState<string | null>(null);

  const { data: backups = [], isLoading } = useQuery({
    queryKey: ["backups"],
    queryFn: async () => (await api.get("/backups/list")).data,
  });

  const createMutation = useMutation({
    mutationFn: async () => {
      setCreating(true);
      setError(null);
      setSuccessMsg(null);
      return api.post("/backups/create");
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["backups"] });
      setCreating(false);
      setSuccessMsg("Backup created successfully!");
    },
    onError: (e: any) => {
      setError(e.response?.data?.detail || "Backup creation failed");
      setCreating(false);
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (filename: string) => api.delete(`/backups/${filename}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["backups"] });
      setSuccessMsg("Backup deleted successfully");
    },
    onError: (e: any) => setError(e.response?.data?.detail || "Delete failed"),
  });

  const restoreMutation = useMutation({
    mutationFn: async (filename: string) => {
      setRestoring(true);
      setError(null);
      setSuccessMsg(null);
      return api.post(`/backups/restore/${filename}`);
    },
    onSuccess: (_, filename) => {
      setRestoring(false);
      setSelectedBackupToRestore(null);
      setSuccessMsg(`Database successfully restored from ${filename}!`);
    },
    onError: (e: any) => {
      setRestoring(false);
      setSelectedBackupToRestore(null);
      setError(e.response?.data?.detail || "Database restore failed");
    },
  });

  const uploadRestoreMutation = useMutation({
    mutationFn: async (file: File) => {
      setRestoring(true);
      setError(null);
      setSuccessMsg(null);
      const formData = new FormData();
      formData.append("file", file);
      return api.post("/backups/upload-restore", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["backups"] });
      setRestoring(false);
      setSuccessMsg("Uploaded database backup restored successfully!");
    },
    onError: (e: any) => {
      setRestoring(false);
      setError(e.response?.data?.detail || "Uploaded backup restore failed");
    },
  });

  const handleDownload = async (filename: string) => {
    try {
      const response = await api.get(`/backups/download/${filename}`, {
        responseType: "blob",
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", filename);
      document.body.appendChild(link);
      link.click();
      link.remove();
    } catch (e: any) {
      setError("Failed to download backup file");
    }
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      if (window.confirm(`Are you sure you want to upload and restore ${file.name}? Current database state will be overwritten.`)) {
        uploadRestoreMutation.mutate(file);
      }
    }
  };

  const colDefs: ColDef[] = [
    { field: "filename", headerName: "Backup File", flex: 2 },
    {
      field: "created_at",
      headerName: "Created At",
      width: 180,
      valueFormatter: (p) => new Date(p.value).toLocaleString(),
    },
    {
      field: "size_bytes",
      headerName: "Size",
      width: 110,
      valueFormatter: (p) => `${(p.value / (1024 * 1024)).toFixed(2)} MB`,
    },
    {
      headerName: "Actions",
      width: 250,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 1, alignItems: "center" }}>
          <Tooltip title="Download Backup">
            <IconButton size="small" color="primary" onClick={() => handleDownload(p.data.filename)}>
              <Download fontSize="small" />
            </IconButton>
          </Tooltip>

          <Button
            size="small"
            variant="outlined"
            color="warning"
            startIcon={<RestorePage fontSize="small" />}
            onClick={() => setSelectedBackupToRestore(p.data.filename)}
          >
            Restore
          </Button>

          <Tooltip title="Delete Backup">
            <IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.filename)}>
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
        title="Database Backups"
        subtitle="Create, download, and restore PostgreSQL database backups"
        breadcrumbs={[{ label: "Backups" }]}
        actions={
          <Box sx={{ display: "flex", gap: 1 }}>
            <input
              type="file"
              ref={fileInputRef}
              style={{ display: "none" }}
              accept=".sql,.dump"
              onChange={handleFileUpload}
            />
            <Button
              variant="outlined"
              color="secondary"
              startIcon={<UploadFile />}
              onClick={() => fileInputRef.current?.click()}
              disabled={restoring}
            >
              Upload & Restore
            </Button>

            <Button
              variant="contained"
              startIcon={creating ? <CircularProgress size={16} sx={{ color: "#000" }} /> : <Backup />}
              onClick={() => createMutation.mutate()}
              disabled={creating || restoring}
            >
              {creating ? "Creating..." : "Create Backup"}
            </Button>
          </Box>
        }
      />

      {error && (
        <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {successMsg && (
        <Alert severity="success" sx={{ mb: 2 }} onClose={() => setSuccessMsg(null)}>
          {successMsg}
        </Alert>
      )}

      {restoring && (
        <Alert severity="info" icon={<CircularProgress size={20} />} sx={{ mb: 2 }}>
          Restoring database... Please do not navigate away.
        </Alert>
      )}

      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
            <Box
              sx={{
                width: 48,
                height: 48,
                borderRadius: 2,
                bgcolor: alpha(ACCENT, 0.12),
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                color: ACCENT,
              }}
            >
              <CloudUpload />
            </Box>
            <Box>
              <Typography variant="subtitle1" sx={{ fontWeight: 600 }}>
                Auto-Backup
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Scheduled via ARQ background worker. Daily at midnight.
              </Typography>
            </Box>
            <Chip label="Active" color="success" size="small" sx={{ ml: "auto" }} />
          </Box>
        </CardContent>
      </Card>

      <OrbxGrid rowData={backups} columnDefs={colDefs} loading={isLoading} height={420} />

      {/* Restore Confirmation Dialog */}
      <Dialog open={Boolean(selectedBackupToRestore)} onClose={() => setSelectedBackupToRestore(null)}>
        <DialogTitle sx={{ fontWeight: 700, color: "#d32f2f" }}>
          Confirm Database Restore
        </DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to restore the database from <strong>{selectedBackupToRestore}</strong>?
            <br />
            <br />
            <strong>Warning:</strong> Restoring a backup will overwrite the current database tables and data with the records from the backup file. This operation cannot be undone.
          </DialogContentText>
        </DialogContent>
        <DialogActions sx={{ p: 2 }}>
          <Button onClick={() => setSelectedBackupToRestore(null)} disabled={restoring}>
            Cancel
          </Button>
          <Button
            variant="contained"
            color="error"
            startIcon={restoring ? <CircularProgress size={16} sx={{ color: "#fff" }} /> : <RestorePage />}
            onClick={() => selectedBackupToRestore && restoreMutation.mutate(selectedBackupToRestore)}
            disabled={restoring}
          >
            {restoring ? "Restoring..." : "Yes, Restore Database"}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
