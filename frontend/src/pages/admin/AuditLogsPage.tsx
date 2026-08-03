import { useQuery } from "@tanstack/react-query";
import { Box, Chip } from "@mui/material";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";

export default function AuditLogsPage() {
  const { activeFY } = useAuthStore();
  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["audit-logs", activeFY],
    queryFn: async () => (await api.get(`/audit/?fy=${activeFY}&limit=200`)).data,
  });

  const colDefs: ColDef[] = [
    { field: "created_at", headerName: "Timestamp", width: 170, valueFormatter: (p) => p.value ? new Date(p.value).toLocaleString() : "-" },
    { field: "username", headerName: "User", width: 120 },
    { field: "module", headerName: "Module", width: 120 },
    { field: "action", headerName: "Action", width: 100,
      cellRenderer: (p: any) => <Chip label={p.value} size="small" color={p.value === "DELETE" ? "error" : p.value === "CREATE" ? "success" : "info"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "record_id", headerName: "Record ID", width: 100, type: "numericColumn" },
    { field: "ip_address", headerName: "IP Address", width: 130 },
  ];

  return (
    <Box>
      <PageHeader title="Audit Logs" subtitle="System-wide action trail" breadcrumbs={[{ label: "Audit Logs" }]} />
      <OrbxGrid rowData={data} columnDefs={colDefs} loading={isLoading} onRefresh={refetch} />
    </Box>
  );
}
