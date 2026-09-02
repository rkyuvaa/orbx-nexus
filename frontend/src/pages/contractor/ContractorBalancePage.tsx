import { useState, useMemo } from "react";
import { useQuery } from "@tanstack/react-query";
import {
  Box,
  Chip,
  IconButton,
  Tooltip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  Typography,
  Paper
} from "@mui/material";
import Visibility from "@mui/icons-material/Visibility";
import { ColDef } from "../../components/tables/OrbxGrid";
import OrbxGrid from "../../components/tables/OrbxGrid";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

export default function ContractorBalancePage() {
  const { activeFY } = useAuthStore();
  const [selectedContractor, setSelectedContractor] = useState<any>(null);

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["contractor-balance-summary", activeFY],
    queryFn: async () =>
      (await api.get(`/contractor/balance-summary?fy=${activeFY}`)).data,
  });

  const { data: transactions = [], isLoading: isTxLoading } = useQuery({
    queryKey: ["contractor-transactions", selectedContractor?.ledger_id, activeFY],
    queryFn: async () => {
      if (!selectedContractor?.ledger_id) return [];
      return (await api.get(`/contractor/transactions?ledger_id=${selectedContractor.ledger_id}&fy=${activeFY}`)).data;
    },
    enabled: !!selectedContractor?.ledger_id,
  });

  const filteredData = useMemo(() => {
    return data.filter((row: any) => {
      const ob = Math.abs(row.opening_balance || 0);
      const advPaid = Math.abs(row.advance_paid || 0);
      const advRec = Math.abs(row.advance_received || 0);
      const jwAmt = Math.abs(row.job_work_amount || 0);
      const jwPaid = Math.abs(row.job_work_paid || 0);
      const curBal = Math.abs(row.current_balance || 0);
      return ob !== 0 || advPaid !== 0 || advRec !== 0 || jwAmt !== 0 || jwPaid !== 0 || curBal !== 0;
    });
  }, [data]);

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
            <span>₹{formatAmount(Math.abs(val))}</span>
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
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "advance_received",
      headerName: "Advance Received",
      width: 155,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "job_work_amount",
      headerName: "Job Work",
      width: 130,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "job_work_paid",
      headerName: "Job Work Paid",
      width: 140,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value)}`,
    },
    {
      field: "current_balance",
      headerName: "Current Balance",
      width: 175,
      type: "numericColumn",
      cellRenderer: (p: any) => {
        const val: number = p.value ?? 0;
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
            <span>₹{formatAmount(Math.abs(val))}</span>
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
    {
      headerName: "Actions",
      width: 80,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", justifyContent: "center", alignItems: "center", height: "100%" }}>
          <Tooltip title="View Transactions Summary">
            <IconButton size="small" onClick={() => setSelectedContractor(p.data)}>
              <Visibility fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  const finalTx = transactions.length > 0 ? transactions[transactions.length - 1] : null;
  const finalBalVal = finalTx ? Math.abs(finalTx.running_balance ?? 0) : Math.abs(selectedContractor?.current_balance ?? 0);
  const isFinalPayable = finalTx ? (finalTx.running_balance ?? 0) >= 0 : (selectedContractor?.current_balance ?? 0) >= 0;
  const finalColor = isFinalPayable ? "#0a7a50" : "#b02a37";
  const finalBgColor = isFinalPayable ? "rgba(22,196,127,0.12)" : "rgba(220,53,69,0.10)";
  const finalBorderColor = isFinalPayable ? "rgba(22,196,127,0.3)" : "rgba(220,53,69,0.3)";

  return (
    <Box>
      <PageHeader
        title="Contractor Balance"
        breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Contractor Balance" }]}
      />
      <OrbxGrid
        rowData={filteredData}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
      />

      <Dialog
        open={!!selectedContractor}
        onClose={() => setSelectedContractor(null)}
        maxWidth="lg"
        fullWidth
      >
        <DialogTitle sx={{ fontWeight: 700 }}>
          Transaction Summary - {selectedContractor?.contractor_name}
        </DialogTitle>
        <DialogContent dividers>
          {isTxLoading ? (
            <Typography variant="body2" sx={{ py: 3, textAlign: "center" }}>
              Loading transaction history...
            </Typography>
          ) : transactions.length === 0 ? (
            <Typography variant="body2" color="text.secondary" sx={{ py: 3, textAlign: "center" }}>
              No transactions found for this contractor.
            </Typography>
          ) : (
            <>
              <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden", mb: 3 }}>
                <Table size="small">
                  <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                    <TableRow>
                      <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Doc / Entry No.</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Transaction Type</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Product / Process</TableCell>
                      <TableCell sx={{ fontWeight: 700 }} align="right">Qty</TableCell>
                      <TableCell sx={{ fontWeight: 700, color: "#b02a37" }} align="right">Debit (Dr)</TableCell>
                      <TableCell sx={{ fontWeight: 700, color: "#0a7a50" }} align="right">Credit (Cr)</TableCell>
                      <TableCell
                        sx={{
                          fontWeight: 700,
                          bgcolor: "rgba(2,48,32,0.06)",
                          borderLeft: "2px solid #023020",
                          color: "#023020",
                        }}
                        align="right"
                      >
                        Closing Balance
                      </TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {transactions.map((tx: any, idx: number) => {
                      const runBal = Math.abs(tx.running_balance ?? 0);
                      const isPayable = (tx.running_balance ?? 0) >= 0;
                      const balColor = isPayable ? "#0a7a50" : "#b02a37";
                      const balBgColor = isPayable ? "rgba(22,196,127,0.15)" : "rgba(220,53,69,0.12)";
                      const isDr = tx.dr_cr === "Dr";

                      return (
                        <TableRow key={idx} hover>
                          <TableCell>{tx.date}</TableCell>
                          <TableCell sx={{ fontWeight: 600 }}>{tx.doc_no}</TableCell>
                          <TableCell>
                            <Chip
                              label={tx.category}
                              size="small"
                              color={
                                tx.category === "Register"
                                  ? "primary"
                                  : tx.category === "Payment" || tx.category === "Job Work Payment"
                                  ? "success"
                                  : tx.category === "Advance Payment"
                                  ? "warning"
                                  : "info"
                              }
                              variant="outlined"
                              sx={{ fontWeight: 600, fontSize: 11 }}
                            />
                          </TableCell>
                          <TableCell>
                            {tx.product_name || tx.process_name
                              ? `${tx.product_name || ""} ${tx.process_name ? `(${tx.process_name})` : ""}`
                              : "-"}
                          </TableCell>
                          <TableCell align="right">{tx.quantity || "-"}</TableCell>
                          <TableCell align="right" sx={{ fontWeight: 600, color: isDr ? "#b02a37" : "text.secondary" }}>
                            {isDr ? `₹${formatAmount(tx.amount)}` : "-"}
                          </TableCell>
                          <TableCell align="right" sx={{ fontWeight: 600, color: !isDr ? "#0a7a50" : "text.secondary" }}>
                            {!isDr ? `₹${formatAmount(tx.amount)}` : "-"}
                          </TableCell>
                          <TableCell
                            align="right"
                            sx={{
                              fontWeight: 700,
                              bgcolor: "rgba(2,48,32,0.03)",
                              borderLeft: "2px solid rgba(2,48,32,0.2)",
                            }}
                          >
                            <Box sx={{ display: "flex", alignItems: "center", gap: 0.75, justifyContent: "flex-end" }}>
                              <span style={{ fontWeight: 800, color: balColor }}>₹{formatAmount(runBal)}</span>
                              <Chip
                                label={isPayable ? "Cr (Payable)" : "Dr (Receivable)"}
                                size="small"
                                sx={{
                                  height: 18,
                                  fontSize: 10,
                                  fontWeight: 700,
                                  bgcolor: balBgColor,
                                  color: balColor,
                                }}
                              />
                            </Box>
                          </TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </Paper>

              {/* Dedicated Final Closing Balance Summary Card */}
              <Paper
                variant="outlined"
                sx={{
                  p: 2,
                  bgcolor: finalBgColor,
                  borderColor: finalBorderColor,
                  borderRadius: "10px",
                  display: "flex",
                  justify: "space-between",
                  alignItems: "center",
                }}
              >
                <Box>
                  <Typography variant="overline" sx={{ fontWeight: 700, color: "text.secondary", letterSpacing: 1 }}>
                    Final Closing Balance
                  </Typography>
                  <Typography variant="h5" sx={{ fontWeight: 800, color: finalColor }}>
                    ₹{formatAmount(finalBalVal)}{" "}
                    <span style={{ fontSize: "1rem", fontWeight: 700 }}>
                      {isFinalPayable ? "Cr — Payable" : "Dr — Receivable"}
                    </span>
                  </Typography>
                </Box>
                <Chip
                  label={isFinalPayable ? "Company owes Contractor" : "Contractor owes Company"}
                  sx={{
                    fontWeight: 700,
                    bgcolor: finalColor,
                    color: "#fff",
                    px: 1,
                  }}
                />
              </Paper>
            </>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setSelectedContractor(null)} variant="outlined">
            Close
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}




