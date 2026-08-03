import { Box, Chip } from "@mui/material";
import { ColDef } from "../../components/tables/OrbxGrid";
import { useQuery } from "@tanstack/react-query";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";

export default function BiometricsPage() {
  const { activeFY } = useAuthStore();
  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["biometrics", activeFY],
    queryFn: async () => (await api.get(`/biometrics/?fy=${activeFY}`)).data,
  });

  const colDefs: ColDef[] = [
    { field: "entry_date", headerName: "Date", width: 110 },
    { field: "ledger_name", headerName: "Staff", flex: 1 },
    { field: "punch_in", headerName: "Punch In", width: 110 },
    { field: "punch_out", headerName: "Punch Out", width: 110 },
    { field: "hours_worked", headerName: "Hours", width: 90, type: "numericColumn" },
    { field: "status", headerName: "Status", width: 100,
      cellRenderer: (p: any) => <Chip label={p.value} size="small" color={p.value === "Present" ? "success" : p.value === "Absent" ? "error" : "warning"} sx={{ fontSize: "0.7rem" }} /> },
    { field: "device_log_id", headerName: "Device Log ID", width: 130 },
  ];

  return (
    <Box>
      <PageHeader title="Biometric Attendance" subtitle="Staff attendance records from biometric device" breadcrumbs={[{ label: "Biometrics" }]} />
      <OrbxGrid rowData={data} columnDefs={colDefs} loading={isLoading} onRefresh={refetch} />
    </Box>
  );
}
