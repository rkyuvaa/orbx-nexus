import { useQuery } from "@tanstack/react-query";
import { Box, Chip } from "@mui/material";
import { ColDef } from "../../components/tables/OrbxGrid";
import OrbxGrid from "../../components/tables/OrbxGrid";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

export default function ContractorBalancePage() {
  const { activeFY } = useAuthStore();

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["contractor-balance-summary", activeFY],
    queryFn: async () =>
      (await api.get(`/contractor/balance-summary?fy=${activeFY}`)).data,
  });

  const colDefs: ColDef[] = [
    {
      field: "contractor_name",
      headerName: "Contractor",
      flex: 1,
      minWidth: 200,
    },
    {
      field: "opening_balance",
      headerName: "Opening Balance",
      width: 160,
      type: "numericColumn",
      cellRenderer: (p: any) => {
        const val: number = p.value ?? 0;
        const bt: string = p.data?.balance_type ?? "Cr";
        return (
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.75, justifyContent: "flex-end", height: "100%" }}>
            <span>&#8377;{formatAmount(Math.abs(val))}</span>
            <Chip
              label={bt}
              size="small"
              sx={{
                height: 18,
                fontSize: 10,
                fontWeight: 700,
                bgcolor: bt === "Cr" ? "rgba(22,196,127,0.15)" : "rgba(220,53,69,0.12)",
                color: bt === "Cr" ? "#0a7a50" : "#b02a37",
              }}
            />
          </Box>
        );
      },
    },
    {
      field: "advance_paid",
      headerName: "Advance Paid",
      width: 140,
      type: "numericColumn",
      valueFormatter: (p) => `\u20b9${formatAmount(p.value)}`,
    },
    {
      field: "advance_received",
      headerName: "Advance Received",
      width: 155,
      type: "numericColumn",
      valueFormatter: (p) => `\u20b9${formatAmount(p.value)}`,
    },
    {
      field: "job_work_amount",
      headerName: "Job Work",
      width: 130,
      type: "numericColumn",
      valueFormatter: (p) => `\u20b9${formatAmount(p.value)}`,
    },
    {
      field: "job_work_paid",
      headerName: "Job Work Paid",
      width: 140,
      type: "numericColumn",
      valueFormatter: (p) => `\u20b9${formatAmount(p.value)}`,
    },
    {
      field: "current_balance",
      headerName: "Current Balance",
      width: 175,
      type: "numericColumn",
      cellRenderer: (p: any) => {
        const val: number = p.value ?? 0;
        // Positive = payable (company owes contractor); Negative = receivable (contractor owes company)
        const isPayable = val >= 0;
        const label = isPayable ? "Payable" : "Receivable";
        const color = isPayable ? "#0a7a50" : "#b02a37";
        const bgColor = isPayable ? "rgba(22,196,127,0.12)" : "rgba(220,53,69,0.10)";
        return (
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              gap: 0.75,
              justifyContent: "flex-end",
              height: "100%",
              fontWeight: 700,
              color,
            }}
          >
            <span>\u20b9{formatAmount(Math.abs(val))}</span>
            <Chip
              label={label}
              size="small"
              sx={{
                height: 18,
                fontSize: 10,
                fontWeight: 700,
                bgcolor: bgColor,
                color,
              }}
            />
          </Box>
        );
      },
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Contractor Balance"
        breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Contractor Balance" }]}
      />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
      />
    </Box>
  );
}
