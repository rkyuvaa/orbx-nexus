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
    queryFn: async () => (await api.get(`/audit/?fy=${activeFY}&limit=500`)).data,
  });

  const colDefs: ColDef[] = [
    { field: "created_at", headerName: "Timestamp", width: 180, valueFormatter: (p) => p.value ? new Date(p.value).toLocaleString() : "-" },
    { field: "username", headerName: "User", width: 140 },
    { field: "module", headerName: "Module", width: 150 },
    {
      field: "action",
      headerName: "Action",
      width: 120,
      cellRenderer: (p: any) => {
        const act = (p.value || "").toUpperCase();
        let color: "error" | "success" | "info" | "warning" = "info";
        if (act === "DELETE") color = "error";
        else if (act === "CREATE") color = "success";
        else if (act === "LOGIN") color = "warning";
        return <Chip label={act} size="small" color={color} sx={{ fontSize: "0.7rem", fontWeight: 600 }} />;
      },
    },
    { field: "record_id", headerName: "Record ID", width: 110, type: "numericColumn", valueFormatter: (p) => p.value ?? "-" },
    { field: "ip_address", headerName: "IP Address", width: 140, valueFormatter: (p) => p.value || "-" },
  ];

  return (
    <Box>
      <PageHeader
        title="Audit Logs"
        subtitle="System-wide action & activity trail"
        breadcrumbs={[{ label: "Settings" }, { label: "Audit Logs" }]}
      />
      <OrbxGrid rowData={data} columnDefs={colDefs} loading={isLoading} onRefresh={refetch} />
    </Box>
  );
}

