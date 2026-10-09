import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, Typography, Paper,
  Table, TableHead, TableRow, TableCell, TableBody, Divider, Alert,
  CircularProgress, Stepper, Step, StepLabel, MenuItem, Autocomplete
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Delete from "@mui/icons-material/Delete";
import Print from "@mui/icons-material/Print";
import CheckCircle from "@mui/icons-material/CheckCircle";
import Refresh from "@mui/icons-material/Refresh";
import InfoOutlined from "@mui/icons-material/InfoOutlined";
import WarningAmber from "@mui/icons-material/WarningAmber";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { ColDef } from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { formatAmount } from "../../utils/format";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";

const AutocompleteAny = Autocomplete as any;

// ─── Helpers ─────────────────────────────────────────────────────────────────

function fmtDate(d?: string | null) {
  if (!d) return "-";
  try {
    return new Date(d).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-");
  } catch {
    return d;
  }
}

function fmtAmt(v?: number | null) {
  return (v ?? 0).toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// ─── Bill Form Dialog ─────────────────────────────────────────────────────────

function JobWorkBillFormDialog({
  open,
  onClose,
  ledgers,
  activeFY,
  companyData,
}: {
  open: boolean;
  onClose: () => void;
  ledgers: any[];
  activeFY: string;
  companyData: any;
}) {
  const qc = useQueryClient();
  const today = new Date().toISOString().split("T")[0];

  const STEPS = ["Select Customer", "Select Inward", "Review & Confirm"];
  const [step, setStep] = useState(0);

  const [selectedLedger, setSelectedLedger] = useState<any>(null);
  const [selectedInward, setSelectedInward] = useState<any>(null);
  const [billDate, setBillDate] = useState(today);
  const [narration, setNarration] = useState("");

  // Tax fields
  const [cgstPct, setCgstPct] = useState(0);
  const [sgstPct, setSgstPct] = useState(0);
  const [additionalCharges, setAdditionalCharges] = useState(0);
  const [discount, setDiscount] = useState(0);

  // Fetched bill details
  const [billDetails, setBillDetails] = useState<any>(null);
  const [detailsLoading, setDetailsLoading] = useState(false);
  const [detailsError, setDetailsError] = useState<string | null>(null);

  // Eligible inwards for selected ledger
  const { data: eligibleInwards = [], isFetching: loadingInwards } = useQuery({
    queryKey: ["jwb-eligible-inwards", selectedLedger?.id, activeFY],
    queryFn: async () => {
      if (!selectedLedger?.id) return [];
      return (await api.get(`/job-work-bills/eligible-inwards?ledger_id=${selectedLedger.id}&fy=${activeFY}`)).data;
    },
    enabled: !!selectedLedger?.id && step >= 1,
  });

  const createMutation = useMutation({
    mutationFn: (payload: any) => api.post(`/job-work-bills/?fy=${activeFY}`, payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["job-work-bills"] });
      handleClose();
    },
  });

  function handleClose() {
    setStep(0);
    setSelectedLedger(null);
    setSelectedInward(null);
    setBillDetails(null);
    setDetailsError(null);
    setBillDate(today);
    setNarration("");
    setCgstPct(0);
    setSgstPct(0);
    setAdditionalCharges(0);
    setDiscount(0);
    onClose();
  }

  async function handleSelectInward(inward: any) {
    setSelectedInward(inward);
    setDetailsLoading(true);
    setDetailsError(null);
    setBillDetails(null);
    try {
      const res = await api.get(
        `/job-work-bills/inward-details/${inward.id}?ledger_id=${selectedLedger.id}&fy=${activeFY}`
      );
      setBillDetails(res.data);
      setStep(2);
    } catch (e: any) {
      setDetailsError(e?.response?.data?.detail || "Failed to load inward details");
    } finally {
      setDetailsLoading(false);
    }
  }

  // Computed totals
  const totalProcessCharges = useMemo(() => {
    if (!billDetails?.bill_lines) return 0;
    return billDetails.bill_lines.reduce((s: number, l: any) => s + Number(l.process_amount || 0), 0);
  }, [billDetails]);

  const taxableBase = totalProcessCharges + additionalCharges - discount;
  const cgstAmt = (taxableBase * cgstPct) / 100;
  const sgstAmt = (taxableBase * sgstPct) / 100;
  const gstAmt = cgstAmt + sgstAmt;
  const rawTotal = taxableBase + gstAmt;
  const roundOff = Math.round(rawTotal) - rawTotal;
  const netTotal = rawTotal + roundOff;

  function handleConfirm() {
    if (!billDetails || !selectedLedger) return;
    const payload = {
      bill_date: billDate,
      ledger_id: selectedLedger.id,
      narration,
      total_process_charges: totalProcessCharges,
      additional_charges: additionalCharges,
      discount,
      cgst_percent: cgstPct,
      cgst_amount: cgstAmt,
      sgst_percent: sgstPct,
      sgst_amount: sgstAmt,
      gst_percent: cgstPct + sgstPct,
      gst_amount: gstAmt,
      round_off: roundOff,
      net_amount: netTotal,
      total_amount: netTotal,
      lines: billDetails.bill_lines.map((l: any) => ({
        inward_id: l.inward_id,
        outward_id: l.outward_id,
        process_id: l.process_id,
        process_name: l.process_name,
        process_code: l.process_code,
        process_rate: l.process_rate,
        uom_symbol: l.uom_symbol,
        billable_quantity: l.billable_quantity,
        process_amount: l.process_amount,
        rate_snapshot: l.rate_snapshot,
      })),
    };
    createMutation.mutate(payload);
  }

  const hasMissingRates = billDetails?.missing_rates?.length > 0;

  return (
    <Dialog open={open} onClose={handleClose} maxWidth="lg" fullWidth>
      <DialogTitle sx={{ fontWeight: 700, fontSize: 18 }}>
        New Job Work Bill
      </DialogTitle>

      <DialogContent dividers>
        <Stepper activeStep={step} sx={{ mb: 3 }}>
          {STEPS.map((label) => (
            <Step key={label}><StepLabel>{label}</StepLabel></Step>
          ))}
        </Stepper>

        {/* STEP 0: Select Customer */}
        {step === 0 && (
          <Box>
            <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 2 }}>
              Select the Company / Customer to raise the bill for.
            </Typography>
            <AutocompleteAny
              options={ledgers.filter((l: any) => l.is_active !== false)}
              getOptionLabel={(o: any) => o.name || ""}
              value={selectedLedger}
              onChange={(_: any, v: any) => { setSelectedLedger(v); setSelectedInward(null); setBillDetails(null); }}
              renderInput={(params: any) => (
                <TextField {...params} label="Customer / Company *" size="small" fullWidth />
              )}
              sx={{ maxWidth: 400 }}
            />
            <Grid container spacing={2} sx={{ mt: 2 }}>
              <Grid size={{ xs: 12, sm: 6, md: 4 }}>
                <TextField
                  label="Bill Date"
                  type="date"
                  size="small"
                  fullWidth
                  value={billDate}
                  onChange={(e) => setBillDate(e.target.value)}
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>
            </Grid>
            <Box sx={{ mt: 3 }}>
              <Button
                variant="contained"
                disabled={!selectedLedger}
                onClick={() => setStep(1)}
                sx={{ bgcolor: "#023020" }}
              >
                Next: Select Inward →
              </Button>
            </Box>
          </Box>
        )}

        {/* STEP 1: Select Inward */}
        {step === 1 && (
          <Box>
            <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
              <Button size="small" onClick={() => setStep(0)}>← Back</Button>
              <Typography variant="subtitle2" color="text.secondary">
                Showing fully completed Inward records for <strong>{selectedLedger?.name}</strong> that have not been billed yet.
              </Typography>
            </Box>

            {loadingInwards && (
              <Box sx={{ display: "flex", justifyContent: "center", py: 4 }}>
                <CircularProgress size={28} sx={{ color: "#023020" }} />
              </Box>
            )}

            {detailsLoading && (
              <Box sx={{ display: "flex", alignItems: "center", gap: 2, py: 2 }}>
                <CircularProgress size={20} sx={{ color: "#023020" }} />
                <Typography variant="body2">Loading inward details...</Typography>
              </Box>
            )}

            {detailsError && (
              <Alert severity="error" sx={{ mb: 2 }}>{detailsError}</Alert>
            )}

            {!loadingInwards && eligibleInwards.length === 0 && (
              <Alert severity="info" icon={<InfoOutlined />}>
                No eligible inward records found for <strong>{selectedLedger?.name}</strong>.
                All inwards are either pending, already billed, or not fully dispatched.
              </Alert>
            )}

            {!loadingInwards && eligibleInwards.length > 0 && (
              <Paper variant="outlined" sx={{ borderRadius: 2 }}>
                <Table size="small">
                  <TableHead>
                    <TableRow sx={{ bgcolor: "#f5f5f5" }}>
                      <TableCell sx={{ fontWeight: 700 }}>Inward No.</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Material</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Ref No.</TableCell>
                      <TableCell sx={{ fontWeight: 700 }} align="right">Inward Qty</TableCell>
                      <TableCell sx={{ fontWeight: 700 }} align="right">Dispatched</TableCell>
                      <TableCell sx={{ fontWeight: 700 }} align="center">Action</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {eligibleInwards.map((inw: any) => (
                      <TableRow
                        key={inw.id}
                        hover
                        sx={{ cursor: "pointer", "&:hover": { bgcolor: "rgba(2,48,32,0.04)" } }}
                        onClick={() => !detailsLoading && handleSelectInward(inw)}
                      >
                        <TableCell sx={{ fontWeight: 600, color: "#023020" }}>{inw.inward_no}</TableCell>
                        <TableCell>{fmtDate(inw.inward_date)}</TableCell>
                        <TableCell>{inw.product_name || "-"}</TableCell>
                        <TableCell>{inw.ref_no || inw.serial_no || "-"}</TableCell>
                        <TableCell align="right">{Number(inw.total_inward_qty || 0).toLocaleString("en-IN", { maximumFractionDigits: 3 })}</TableCell>
                        <TableCell align="right">{Number(inw.dispatched_qty || 0).toLocaleString("en-IN", { maximumFractionDigits: 3 })}</TableCell>
                        <TableCell align="center">
                          <Button
                            size="small"
                            variant="contained"
                            disabled={detailsLoading}
                            onClick={(e) => { e.stopPropagation(); handleSelectInward(inw); }}
                            sx={{ bgcolor: "#023020", fontSize: "0.7rem" }}
                          >
                            Select
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </Paper>
            )}
          </Box>
        )}

        {/* STEP 2: Review & Confirm */}
        {step === 2 && billDetails && (
          <Box>
            <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
              <Button size="small" onClick={() => { setStep(1); setBillDetails(null); setDetailsError(null); }}>← Back</Button>
              <Typography variant="subtitle2" color="text.secondary">
                Review auto-generated bill for <strong>{selectedLedger?.name}</strong>
              </Typography>
            </Box>

            {hasMissingRates && (
              <Alert severity="error" icon={<WarningAmber />} sx={{ mb: 2 }}>
                <strong>Cannot confirm bill:</strong> The following processes have missing or zero rates in the Process Register:
                <ul style={{ margin: "4px 0 0 16px", padding: 0 }}>
                  {billDetails.missing_rates.map((m: any, i: number) => (
                    <li key={i}><strong>{m.process_name || `#${m.process_id}`}</strong>: {m.issue}</li>
                  ))}
                </ul>
              </Alert>
            )}

            {/* Inward & Outward Reference */}
            <Paper variant="outlined" sx={{ p: 2, mb: 2, borderRadius: 2, bgcolor: "#f8fffe" }}>
              <Grid container spacing={2}>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                  <Typography variant="caption" color="text.secondary">Inward No.</Typography>
                  <Typography sx={{ fontWeight: 700 }}>{billDetails.inward?.inward_no}</Typography>
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                  <Typography variant="caption" color="text.secondary">Inward Date</Typography>
                  <Typography>{fmtDate(billDetails.inward?.inward_date)}</Typography>
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                  <Typography variant="caption" color="text.secondary">Ref. No.</Typography>
                  <Typography>{billDetails.inward?.ref_no || billDetails.inward?.serial_no || "-"}</Typography>
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                  <Typography variant="caption" color="text.secondary">Outward Ref(s)</Typography>
                  <Typography>{billDetails.outwards?.map((o: any) => o.outward_no).join(", ") || "-"}</Typography>
                </Grid>
              </Grid>
            </Paper>

            {/* Process-wise bill lines */}
            <Typography variant="subtitle2" sx={{ fontWeight: 700 }} sx={{ mb: 1 }}>Process-wise Charges</Typography>
            <Paper variant="outlined" sx={{ borderRadius: 2, mb: 2 }}>
              <Table size="small">
                <TableHead>
                  <TableRow sx={{ bgcolor: "#f5f5f5" }}>
                    <TableCell sx={{ fontWeight: 700 }}>Process</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Outward Ref</TableCell>
                    <TableCell sx={{ fontWeight: 700 }} align="right">Rate</TableCell>
                    <TableCell sx={{ fontWeight: 700 }} align="right">Qty</TableCell>
                    <TableCell sx={{ fontWeight: 700 }} align="right">Amount (₹)</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {billDetails.bill_lines.map((line: any, idx: number) => {
                    const out = billDetails.outwards?.find((o: any) => o.id === line.outward_id);
                    return (
                      <TableRow key={idx}>
                        <TableCell>
                          <Typography variant="body2" sx={{ fontWeight: 600 }}>{line.process_name}</Typography>
                          {line.process_code && <Typography variant="caption" color="text.secondary">{line.process_code}</Typography>}
                        </TableCell>
                        <TableCell>
                          <Typography variant="body2">{out?.outward_no || `#${line.outward_id}`}</Typography>
                          <Typography variant="caption" color="text.secondary">{fmtDate(out?.outward_date)}</Typography>
                        </TableCell>
                        <TableCell align="right">₹ {fmtAmt(line.process_rate)} / {line.uom_symbol || "unit"}</TableCell>
                        <TableCell align="right">{Number(line.billable_quantity).toLocaleString("en-IN", { maximumFractionDigits: 3 })}</TableCell>
                        <TableCell align="right" sx={{ fontWeight: 600 }}>₹ {fmtAmt(line.process_amount)}</TableCell>
                      </TableRow>
                    );
                  })}
                </TableBody>
              </Table>
            </Paper>

            {/* Bill Summary & Tax fields */}
            <Grid container spacing={2}>
              <Grid size={{ xs: 12, md: 6 }}>
                <Paper variant="outlined" sx={{ p: 2, borderRadius: 2 }}>
                  <Typography variant="subtitle2" sx={{ fontWeight: 700 }} sx={{ mb: 1.5 }}>Charges & Tax</Typography>
                  <Grid container spacing={1.5}>
                    <Grid size={{ xs: 6 }}>
                      <TextField label="Additional Charges (₹)" size="small" type="number" fullWidth
                        value={additionalCharges} onChange={(e) => setAdditionalCharges(Number(e.target.value) || 0)} />
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField label="Discount (₹)" size="small" type="number" fullWidth
                        value={discount} onChange={(e) => setDiscount(Number(e.target.value) || 0)} />
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField label="CGST %" size="small" type="number" fullWidth
                        value={cgstPct} onChange={(e) => setCgstPct(Number(e.target.value) || 0)} />
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField label="SGST %" size="small" type="number" fullWidth
                        value={sgstPct} onChange={(e) => setSgstPct(Number(e.target.value) || 0)} />
                    </Grid>
                    <Grid size={{ xs: 12 }}>
                      <TextField label="Narration / Notes" size="small" multiline rows={2} fullWidth
                        value={narration} onChange={(e) => setNarration(e.target.value)} />
                    </Grid>
                  </Grid>
                </Paper>
              </Grid>

              <Grid size={{ xs: 12, md: 6 }}>
                <Paper variant="outlined" sx={{ p: 2, borderRadius: 2 }}>
                  <Typography variant="subtitle2" sx={{ fontWeight: 700 }} sx={{ mb: 1.5 }}>Bill Summary</Typography>
                  {[
                    ["Process Charges", totalProcessCharges],
                    ["Additional Charges", additionalCharges],
                    ["Discount", -discount],
                    ["Taxable Amount", taxableBase],
                    [`CGST @ ${cgstPct}%`, cgstAmt],
                    [`SGST @ ${sgstPct}%`, sgstAmt],
                    ["Round Off", roundOff],
                  ].map(([label, val]) => (
                    <Box key={label as string} sx={{ display: "flex", justifyContent: "space-between", mb: 0.5 }}>
                      <Typography variant="body2" color="text.secondary">{label as string}</Typography>
                      <Typography variant="body2">₹ {fmtAmt(Number(val))}</Typography>
                    </Box>
                  ))}
                  <Divider sx={{ my: 1 }} />
                  <Box sx={{ display: "flex", justifyContent: "space-between" }}>
                    <Typography sx={{ fontWeight: 700 }}>Net Payable</Typography>
                    <Typography sx={{ fontWeight: 700 }} color="#023020" fontSize={16}>₹ {fmtAmt(netTotal)}</Typography>
                  </Box>
                  <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5, display: "block", fontStyle: "italic" }}>
                    {toWords(Math.round(netTotal))} Only
                  </Typography>
                </Paper>
              </Grid>
            </Grid>
          </Box>
        )}
      </DialogContent>

      <DialogActions sx={{ px: 3, py: 2, gap: 1 }}>
        <Button onClick={handleClose} variant="outlined">Cancel</Button>
        {step === 2 && (
          <Button
            variant="contained"
            onClick={handleConfirm}
            disabled={createMutation.isPending || hasMissingRates || !billDetails?.bill_lines?.length}
            sx={{ bgcolor: "#023020" }}
          >
            {createMutation.isPending ? <CircularProgress size={18} sx={{ color: "#fff" }} /> : "Confirm & Create Bill"}
          </Button>
        )}
      </DialogActions>
      {createMutation.isError && (
        <Alert severity="error" sx={{ mx: 2, mb: 1 }}>
          {(createMutation.error as any)?.response?.data?.detail || "Failed to create bill"}
        </Alert>
      )}
    </Dialog>
  );
}

// ─── Print Handler ────────────────────────────────────────────────────────────

function printBill(row: any, companyData: any) {
  const compData = Array.isArray(companyData) ? companyData[0] : companyData;
  const cName = compData?.name || "Company";
  const cAddress = [compData?.address, compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(", ");
  const cContact = [compData?.phone, compData?.email].filter(Boolean).join(" | ");
  const cGstin = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";
  const savedConfig = localStorage.getItem("orbx_print_config");
  let printConfig: any = { billPaperSize: "A4", showLogo: true };
  if (savedConfig) try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch {}
  const logoBase64 = localStorage.getItem("company_logo");
  const logoHtml = (printConfig.showLogo && logoBase64) ? `<img src="${logoBase64}" style="max-height:60px;" />` : "";

  const lines: any[] = Array.isArray(row.lines) ? row.lines : [];
  const linesHtml = lines.map((l: any, i: number) => `
    <tr>
      <td>${i + 1}</td>
      <td>${l.process_name || "-"}</td>
      <td style="text-align:right">${Number(l.billable_quantity || 0).toFixed(3)}</td>
      <td style="text-align:right">₹ ${Number(l.process_rate || 0).toFixed(4)}</td>
      <td style="text-align:right">₹ ${Number(l.process_amount || 0).toFixed(2)}</td>
    </tr>`).join("");

  const html = `<!DOCTYPE html><html><head>
  <title>Job Work Bill - ${row.bill_no}</title>
  <style>
    ${COMMON_PRINT_CSS}
    ${getPageSizeCSS(printConfig.billPaperSize || "A4")}
    body { font-family: Arial, sans-serif; font-size: 11px; }
    .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
    .company-name { font-size: 16px; font-weight: bold; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { border: 1px solid #ccc; padding: 5px 8px; }
    th { background: #f0f0f0; font-weight: bold; }
    .summary-row td { border: none; }
    .total-row { font-weight: bold; background: #f8f8f8; }
    .footer { margin-top: 20px; border-top: 1px solid #ccc; padding-top: 8px; font-size: 10px; color: #555; }
  </style>
  </head><body>
  <div class="header">
    <div>${logoHtml}<div class="company-name">${cName}</div><div>${cAddress}</div><div>${cContact}</div><div>${cGstin}</div></div>
    <div style="text-align:right">
      <div style="font-size:18px;font-weight:bold">JOB WORK BILL</div>
      <div>Bill No: <strong>${row.bill_no}</strong></div>
      <div>Date: ${fmtDate(row.bill_date)}</div>
    </div>
  </div>
  <hr/>
  <div><strong>To:</strong> ${row.customer_name || ""}</div>
  <table>
    <thead><tr><th>#</th><th>Process Description</th><th style="text-align:right">Qty</th><th style="text-align:right">Rate</th><th style="text-align:right">Amount</th></tr></thead>
    <tbody>${linesHtml}</tbody>
  </table>
  <table style="margin-top:10px;">
    <tr class="summary-row"><td colspan="3"></td><td>Process Charges</td><td style="text-align:right">₹ ${fmtAmt(row.total_process_charges)}</td></tr>
    ${Number(row.additional_charges) ? `<tr class="summary-row"><td colspan="3"></td><td>Additional Charges</td><td style="text-align:right">₹ ${fmtAmt(row.additional_charges)}</td></tr>` : ""}
    ${Number(row.discount) ? `<tr class="summary-row"><td colspan="3"></td><td>Discount</td><td style="text-align:right">- ₹ ${fmtAmt(row.discount)}</td></tr>` : ""}
    ${Number(row.cgst_amount) ? `<tr class="summary-row"><td colspan="3"></td><td>CGST @ ${row.cgst_percent}%</td><td style="text-align:right">₹ ${fmtAmt(row.cgst_amount)}</td></tr>` : ""}
    ${Number(row.sgst_amount) ? `<tr class="summary-row"><td colspan="3"></td><td>SGST @ ${row.sgst_percent}%</td><td style="text-align:right">₹ ${fmtAmt(row.sgst_amount)}</td></tr>` : ""}
    <tr class="total-row summary-row"><td colspan="3"></td><td>Net Payable</td><td style="text-align:right">₹ ${fmtAmt(row.total_amount)}</td></tr>
  </table>
  <div style="margin-top:8px;font-style:italic;color:#555">${toWords(Math.round(row.total_amount || 0))} Only</div>
  ${row.narration ? `<div style="margin-top:8px"><strong>Narration:</strong> ${row.narration}</div>` : ""}
  <div class="footer">This is a computer-generated Job Work Bill.</div>
  </body></html>`;

  const pw = window.open("", "_blank");
  if (!pw) return;
  pw.document.write(html);
  pw.document.close();
  pw.focus();
  setTimeout(() => { pw.print(); }, 300);
}

// ─── Main Page ────────────────────────────────────────────────────────────────

export default function JobWorkBillPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const today = new Date().toISOString().split("T")[0];

  const { data: bills = [], isLoading, refetch } = useQuery({
    queryKey: ["job-work-bills", activeFY],
    queryFn: async () => (await api.get(`/job-work-bills/?fy=${activeFY}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  const { data: companyData } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const markPaidMutation = useMutation({
    mutationFn: ({ id }: { id: number }) =>
      api.patch(`/job-work-bills/${id}/mark-paid?fy=${activeFY}&payment_date=${today}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["job-work-bills"] }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/job-work-bills/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["job-work-bills"] }),
  });

  const columns: ColDef[] = [
    { field: "bill_no", headerName: "Bill No.", width: 130, renderCell: (r) => (
      <Typography variant="body2" sx={{ fontWeight: 600 }} color="#023020">{r.bill_no}</Typography>
    )},
    { field: "bill_date", headerName: "Bill Date", width: 110, renderCell: (r) => fmtDate(r.bill_date) },
    { field: "customer_name", headerName: "Customer", flex: 1, minWidth: 160 },
    { field: "line_count", headerName: "Processes", width: 90, align: "center", renderCell: (r) => (
      <Chip label={r.line_count || 0} size="small" />
    )},
    { field: "total_process_charges", headerName: "Process Charges", width: 140, align: "right",
      renderCell: (r) => `₹ ${fmtAmt(r.total_process_charges)}` },
    { field: "total_amount", headerName: "Total (₹)", width: 130, align: "right",
      renderCell: (r) => <Typography sx={{ fontWeight: 700 }}>₹ {fmtAmt(r.total_amount)}</Typography> },
    { field: "payment_status", headerName: "Status", width: 100, renderCell: (r) => {
      const st = r.payment_status || "UNPAID";
      const color = st === "PAID" ? "success" : st === "PARTIAL" ? "warning" : "error";
      return <Chip label={st} size="small" color={color} />;
    }},
    { field: "_actions", headerName: "Actions", width: 130, sortable: false, renderCell: (r) => (
      <Box sx={{ display: "flex", gap: 0.5 }}>
        <Tooltip title="Print Bill">
          <IconButton size="small" onClick={() => printBill(r, companyData)}>
            <Print fontSize="small" />
          </IconButton>
        </Tooltip>
        {!r.is_paid && (
          <Tooltip title="Mark as Paid">
            <IconButton size="small" color="success"
              onClick={() => { if (window.confirm("Mark this bill as fully paid?")) markPaidMutation.mutate({ id: r.id }); }}>
              <CheckCircle fontSize="small" />
            </IconButton>
          </Tooltip>
        )}
        <Tooltip title="Delete Bill">
          <IconButton size="small" color="error"
            onClick={() => { if (window.confirm(`Delete bill ${r.bill_no}? This cannot be undone.`)) deleteMutation.mutate(r.id); }}>
            <Delete fontSize="small" />
          </IconButton>
        </Tooltip>
      </Box>
    )},
  ];

  // Expandable row: show bill lines
  const renderExpanded = (row: any) => {
    const lines = Array.isArray(row.lines) ? row.lines : [];
    if (!lines.length) return null;
    return (
      <Box sx={{ px: 3, py: 1.5, bgcolor: "#f8fffe" }}>
        <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 700, mb: 1, display: "block" }}>
          PROCESS LINES
        </Typography>
        <Table size="small">
          <TableHead>
            <TableRow sx={{ bgcolor: "#eaf4f0" }}>
              <TableCell sx={{ fontWeight: 700, fontSize: "0.7rem" }}>Process</TableCell>
              <TableCell sx={{ fontWeight: 700, fontSize: "0.7rem" }} align="right">Rate</TableCell>
              <TableCell sx={{ fontWeight: 700, fontSize: "0.7rem" }} align="right">Qty</TableCell>
              <TableCell sx={{ fontWeight: 700, fontSize: "0.7rem" }} align="right">Amount</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {lines.map((l: any, i: number) => (
              <TableRow key={i}>
                <TableCell sx={{ fontSize: "0.75rem" }}>
                  <b>{l.process_name}</b>
                  {l.process_code && <span style={{ color: "#888", marginLeft: 6 }}>{l.process_code}</span>}
                </TableCell>
                <TableCell align="right" sx={{ fontSize: "0.75rem" }}>₹ {fmtAmt(l.process_rate)}</TableCell>
                <TableCell align="right" sx={{ fontSize: "0.75rem" }}>{Number(l.billable_quantity).toFixed(3)}</TableCell>
                <TableCell align="right" sx={{ fontSize: "0.75rem", fontWeight: 700 }}>₹ {fmtAmt(l.process_amount)}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Box>
    );
  };

  return (
    <Box>
      <PageHeader
        title="Job Work Bill"
        subtitle="Process-based billing from Inward → Outward → Process Register"
        actions={
          <Box sx={{ display: "flex", gap: 1 }}>
            <Tooltip title="Refresh">
              <IconButton size="small" onClick={() => refetch()}>
                <Refresh fontSize="small" />
              </IconButton>
            </Tooltip>
            <Button
              variant="contained"
              startIcon={<Add />}
              onClick={() => setOpen(true)}
              sx={{ bgcolor: "#023020", borderRadius: "8px", fontWeight: 600 }}
            >
              New Job Work Bill
            </Button>
          </Box>
        }
      />

      <Box sx={{ px: 3, pb: 3 }}>
        <OrbxGrid
          rowData={bills}
          columnDefs={columns}
          loading={isLoading}
          rowKey={(r: any) => r.id}
          
        />
      </Box>

      <JobWorkBillFormDialog
        open={open}
        onClose={() => setOpen(false)}
        ledgers={ledgers}
        activeFY={activeFY}
        companyData={companyData}
      />
    </Box>
  );
}
