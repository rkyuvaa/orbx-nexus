import { useMemo } from "react";
import { Box, Typography, Chip } from "@mui/material";
import { ColDef } from "../../components/tables/OrbxGrid";
import { useQuery } from "@tanstack/react-query";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { formatQty } from "../../utils/format";

export default function StockItemsPage() {
  const { activeFY } = useAuthStore();

  // Use the inventory balance endpoint to get live stock values
  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["stock-items-balance", activeFY],
    queryFn: async () => (await api.get(`/stock/inventory?fy=${activeFY}`)).data,
  });

  const totalItems = data.length;
  const totalQty = data.reduce((acc: number, item: any) => acc + Number(item.balance_qty || 0), 0);
  const lowStockCount = data.filter((item: any) =>
    Number(item.reorder_level || 0) > 0 && Number(item.balance_qty || 0) <= Number(item.reorder_level || 0)
  ).length;

  const summaryCards = (
    <Box sx={{ display: "flex", gap: 2, mb: 1.5 }}>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 120, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Items</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{totalItems}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "success.main", color: "#fff", minWidth: 160, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Balance Qty</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{formatQty(totalQty)}</Typography>
      </Box>
      {lowStockCount > 0 && (
        <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "warning.main", color: "#fff", minWidth: 130, textAlign: "center" }}>
          <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Low Stock Items</Typography>
          <Typography variant="h6" sx={{ fontWeight: 700 }}>{lowStockCount}</Typography>
        </Box>
      )}
    </Box>
  );

  const colDefs: ColDef[] = [
    { field: "name", headerName: "Tool / Consumable", flex: 2, minWidth: 200 },
    { field: "item_code", headerName: "Code", width: 110 },
    { field: "uom_symbol", headerName: "UoM", width: 80 },
    {
      field: "opening_stock", headerName: "Opening Qty", width: 120, type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
    {
      field: "total_inward", headerName: "Total Inward", width: 120, type: "numericColumn",
      cellRenderer: (p: any) => (
        <Typography variant="body2" sx={{ color: "success.main", fontWeight: 500 }}>
          +{formatQty(p.value)}
        </Typography>
      ),
    },
    {
      field: "total_outward", headerName: "Total Outward", width: 120, type: "numericColumn",
      cellRenderer: (p: any) => (
        <Typography variant="body2" sx={{ color: "error.main", fontWeight: 500 }}>
          -{formatQty(p.value)}
        </Typography>
      ),
    },
    {
      field: "balance_qty", headerName: "Balance Qty", width: 140, type: "numericColumn",
      cellRenderer: (p: any) => {
        const balance = Number(p.value || 0);
        const reorder = Number(p.data?.reorder_level || 0);
        const isLow = reorder > 0 && balance <= reorder;
        return (
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.5, height: "100%" }}>
            <Typography variant="body2" sx={{ fontWeight: 700, color: isLow ? "warning.main" : "text.primary" }}>
              {formatQty(balance)}
            </Typography>
            {isLow && <Chip label="Low" size="small" color="warning" sx={{ height: 18, fontSize: 10 }} />}
          </Box>
        );
      },
    },
    {
      field: "reorder_level", headerName: "Reorder Level", width: 130, type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
      <PageHeader
        title="Tools & Consumables"
        subtitle="Live stock balance — Opening + Inward − Outward"
        breadcrumbs={[{ label: "Inventory" }, { label: "Tools & Consumables" }]}
      />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        summaryCards={summaryCards}
      />
    </Box>
  );
}
