import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Typography, Paper, Autocomplete
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import Print from "@mui/icons-material/Print";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { toWords } from "../../utils/numberToWords";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
import { formatAmount } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];
const VOUCHER_TYPES = ["Payment", "Receipt", "Contra", "Journal", "Purchase"];

interface VoucherLine { ledger_id: number | ""; dr_amount: number | ""; cr_amount: number | ""; narration: string; }

function AccountsVoucherPage({ voucherType }: { voucherType: string }) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);

  const { data: vouchers = [], isLoading, refetch } = useQuery({
    queryKey: ["vouchers", voucherType, activeFY],
    queryFn: async () => (await api.get(`/vouchers/?fy=${activeFY}&voucher_type=${voucherType}`)).data,
  });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });
  const { data: companyData } = useQuery({ queryKey: ["company"], queryFn: async () => (await api.get("/company/")).data });

  const ledgerMap = useMemo(() => {
    const map: Record<number, string> = {};
    ledgers.forEach((l: any) => map[l.id] = l.name);
    return map;
  }, [ledgers]);

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/vouchers/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["vouchers"] }),
  });

  const ACCENT = "#00a86b";

  const handlePrintSingleVoucher = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    // Load print configuration
    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = {
      showLogo: true,
      paperSize: "A4",
      voucherTitle: `${voucherType} Voucher`,
      voucherTerms: "1. Subject to local jurisdiction.\n2. E. & O.E.",
    };
    if (savedConfig) {
      try {
        printConfig = { ...printConfig, ...JSON.parse(savedConfig) };
      } catch (e) {}
    }

    const logoBase64 = localStorage.getItem("company_logo");
    const logoHtml = (printConfig.showLogo && logoBase64)
      ? `<img src="${logoBase64}" />`
      : "";

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const voucherTitle = printConfig.voucherTitle.toUpperCase();
    const dateStr = new Date(row.voucher_date).toLocaleDateString("en-IN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric"
    }).replace(/\//g, "-");

    const mainLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const mainLedgerName = mainLedger?.name || `Ledger #${row.ledger_id}`;
    const mainLedgerGstin = mainLedger?.gstin || "";
    const mainLedgerAddress = mainLedger?.address || "";

    let linesHtml = "";
    if (row.lines && row.lines.length > 0) {
      row.lines.forEach((line: any, index: number) => {
        const ledgerName = ledgers.find((l: any) => l.id === line.ledger_id)?.name || `Ledger #${line.ledger_id}`;
        const drAmount = line.dr_amount ? `₹${formatAmount(line.dr_amount)}` : "-";
        const crAmount = line.cr_amount ? `₹${formatAmount(line.cr_amount)}` : "-";
        linesHtml += `
          <tr>
            <td style="text-align: center;">${index + 1}</td>
            <td style="font-weight: 600;">${ledgerName}</td>
            <td>${line.narration || ""}</td>
            <td style="text-align: right;">${drAmount}</td>
            <td style="text-align: right; font-weight: 600;">${crAmount}</td>
          </tr>
        `;
      });
    } else {
      linesHtml += `
        <tr>
          <td style="text-align: center;">1</td>
          <td style="font-weight: 600;">${mainLedgerName}</td>
          <td>${row.narration || ""}</td>
          <td style="text-align: right;">₹${formatAmount(row.amount)}</td>
          <td style="text-align: right; font-weight: 600;">-</td>
        </tr>
      `;
    }

    const formattedTerms = printConfig.voucherTerms.replace(/\n/g, "<br/>");
    const amountInWordsStr = toWords(Number(row.amount));

    const leftColTitle = voucherType === "Payment" ? "PAID TO:" : voucherType === "Receipt" ? "RECEIVED FROM:" : "PARTY DETAILS:";

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Print ${voucherTitle} - ${row.voucher_no}</title>
          <style>
            @page { size: ${getPageSizeCSS(printConfig.paperSize as any)}; margin: 15mm; }
            ${COMMON_PRINT_CSS}
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress ? `<p>${cAddress}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section">
            <h2>${voucherTitle}</h2>
            <div class="doc-no">Voucher No: ${row.voucher_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
          </div>
          <div class="address-section">
            <div class="address-column">
              <h3>${leftColTitle}</h3>
              <div class="name">${mainLedgerName}</div>
              ${mainLedgerAddress ? `<div class="address-lines">${mainLedgerAddress}</div>` : ""}
              ${mainLedgerGstin ? `<div class="gstin">GSTIN: ${mainLedgerGstin}</div>` : ""}
            </div>
            <div class="address-column">
              <h3>Payment Source:</h3>
              <div class="name">${voucherType === "Payment" ? "Bank / Cash Account" : "Account Received In"}</div>
              <div class="address-lines">Ref No: ${row.ref_no || "-"}</div>
            </div>
          </div>
          <table class="items-table">
            <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
              <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
                <th style="width: 50px; text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">S.No</th>
                <th style="background-color: #0f5132 !important; color: #ffffff !important;">Particulars</th>
                <th style="background-color: #0f5132 !important; color: #ffffff !important;">Narration</th>
                <th style="text-align: right; width: 120px; background-color: #0f5132 !important; color: #ffffff !important;">Debit</th>
                <th style="text-align: right; width: 120px; background-color: #0f5132 !important; color: #ffffff !important;">Credit</th>
              </tr>
            </thead>
            <tbody>
              ${linesHtml}
            </tbody>
          </table>
          <div class="totals-section">
            <div class="calculation-box">
              <div class="calculation-row grand-total">
                <span>Total Amount:</span>
                <span>₹${formatAmount(row.amount)}</span>
              </div>
              <div class="amount-in-words">${amountInWordsStr}</div>
            </div>
          </div>
          <div class="bottom-section">
            ${row.narration ? `
              <div class="narration-box">
                <strong>Narration:</strong> ${row.narration}
              </div>
            ` : ""}
            ${formattedTerms ? `
              <div class="terms-box">
                <h4>Terms & Conditions:</h4>
                <ol>
                  ${formattedTerms.split("<br/>").map((t: string) => { const cleanT = t.replace(/^\s*\d+[\.\)]\s*/, "").trim(); return cleanT ? `<li>${cleanT}</li>` : ""; }).filter(Boolean).join("")}
                </ol>
              </div>
            ` : ""}
            <div class="signatures-container">
              <div class="signature-block">
                <div class="signature-line"></div>
                <div class="signature-label">${voucherType === "Payment" ? "Receiver Signature" : "Customer Signature"}</div>
              </div>
              <div class="signature-block">
                <div class="signature-line"></div>
                <div class="signature-label">Authorized Signatory for ${cName}</div>
              </div>
            </div>
            <div class="thank-you-note">Thank you for your business!</div>
          </div>
          <script>
            window.onload = function() {
              window.print();
              setTimeout(function() { window.close(); }, 500);
            };
          </script>
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140 },
    { field: "voucher_date", headerName: "Date", width: 100 },
    { field: "ledger_id", headerName: "Ledger", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { field: "amount", headerName: "Amount", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "narration", headerName: "Narration", flex: 1 },
    { field: "ref_no", headerName: "Ref No.", width: 120 },
    { headerName: "Actions", width: 110, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Print Slip"><IconButton size="small" onClick={() => handlePrintSingleVoucher(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  const breadcrumbMap: Record<string, string> = {
    Payment: "Payment Voucher", Receipt: "Receipt Voucher", Contra: "Contra Voucher",
    Journal: "Journal Voucher", Purchase: "Purchase Voucher",
  };

  const handleOpenNewVoucher = () => {
    setOpen(true);
  };

  return (
    <Box>
      <PageHeader
        title={`${voucherType} Voucher`}
        subtitle={`Post ${voucherType.toLowerCase()} entries`}
        breadcrumbs={[{ label: "Accounts Voucher" }, { label: "Breadcrumb" }]}
      />
      <OrbxGrid
        rowData={vouchers}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={handleOpenNewVoucher}
        addLabel={`New ${voucherType}`}
      />
      <AccountsVoucherDialog
        open={open}
        onClose={() => setOpen(false)}
        voucherType={voucherType}
      />
    </Box>
  );
}

interface AccountsVoucherDialogProps {
  open: boolean;
  onClose: () => void;
  voucherType: string;
}

function AccountsVoucherDialog({ open, onClose, voucherType }: AccountsVoucherDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [lines, setLines] = useState<VoucherLine[]>([{ ledger_id: "", dr_amount: 0, cr_amount: 0, narration: "" }]);

  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const { register, handleSubmit, reset, watch, setValue } = useForm({
    defaultValues: { voucher_no: "", voucher_type: voucherType, voucher_date: today, ledger_id: "", amount: "" as any, narration: "", ref_no: "" },
  });

  useEffect(() => {
    if (open) {
      setLines([{ ledger_id: "", dr_amount: "", cr_amount: "", narration: "" }]);
      reset({ voucher_no: "", voucher_date: today, ledger_id: "", amount: "" as any, narration: "", ref_no: "" });

      const vtype = voucherType.toLowerCase();
      api.get(`/sequences/preview/voucher_${vtype}`)
        .then((res) => {
          setValue("voucher_no", res.data.next_no);
        })
        .catch((e) => console.error(e));
    }
  }, [open, reset, voucherType, setValue]);

  const addLine = () => {
    setLines((l) => [...l, { ledger_id: "", dr_amount: "", cr_amount: "", narration: "" }]);
    setTimeout(() => {
      const inputs = document.querySelectorAll('[data-field="line_ledger"]') as NodeListOf<HTMLInputElement>;
      if (inputs.length > 0) {
        inputs[inputs.length - 1].focus();
      }
    }, 50);
  };
  const updateLine = (i: number, field: string, val: any) => setLines((l) => l.map((line, idx) => idx === i ? { ...line, [field]: val } : line));
  const removeLine = (i: number) => {
    setLines((l) => l.filter((_, idx) => idx !== i));
  };

  const saveMutation = useMutation({
    mutationFn: (data: any) => api.post(`/vouchers/?fy=${activeFY}`, { ...data, voucher_type: voucherType, lines }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["vouchers"] });
      onClose();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
      alert("Failed to save Accounts Voucher. This usually happens if the Voucher Number already exists. Please verify the Voucher Number and try again.");
    }
  });

  const handleKeyDown = (e: React.KeyboardEvent<HTMLFormElement>) => {
    if (e.key === "Enter") {
      const active = document.activeElement as HTMLElement;
      if (active && (active.tagName === "BUTTON" || active.tagName === "TEXTAREA")) {
        return;
      }
      e.preventDefault();

      const form = e.currentTarget;
      const focusable = Array.from(
        form.querySelectorAll(
          'input:not([disabled]):not([readonly]), select:not([disabled]), textarea:not([disabled]), [tabindex="0"]:not([disabled])'
        )
      ) as HTMLElement[];

      const index = focusable.indexOf(active);
      if (index > -1) {
        const isNarr = active.getAttribute("data-field") === "line_narration";
        if (isNarr) {
          const rowIdx = Number(active.getAttribute("data-row-index"));
          if (rowIdx === lines.length - 1) {
            addLine();
            return;
          }
        }
        const next = focusable[index + 1];
        if (next) {
          next.focus();
        }
      }
    }
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))} onKeyDown={handleKeyDown}>
        <DialogTitle>New {voucherType} Voucher</DialogTitle>
        <DialogContent dividers>
          <Grid container spacing={2}>
            <Grid size={{ xs: 6, sm: 3 }}><TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required size="small" disabled /></Grid>
            <Grid size={{ xs: 6, sm: 3 }}><TextField {...register("voucher_date")} label="Date *" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} /></Grid>
            <Grid size={{ xs: 12, sm: 6 }}>
              <LazyAutocomplete
                size="small"
                value={ledgerMapObj[watch("ledger_id")] || null}
                onChange={(_, val) => setValue("ledger_id", val ? val.id : "")}
                options={ledgers}
                getOptionLabel={(option: any) => option.name || ""}
                noOptionsText="No matching ledgers"
                renderInput={(params) => <TextField {...params} label="Main Ledger *" required={!watch("ledger_id")} />}
              />
            </Grid>
            <Grid size={{ xs: 6, sm: 4 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth size="small" /></Grid>
            <Grid size={{ xs: 6, sm: 4 }}><TextField {...register("ref_no")} label="Ref No." fullWidth size="small" /></Grid>
            <Grid size={{ xs: 12, sm: 4 }}><TextField {...register("narration")} label="Narration" fullWidth size="small" /></Grid>

            {/* Ledger Lines */}
            <Grid size={{ xs: 12 }}>
              <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1, mt: 1 }}>
                <Typography sx={{ fontWeight: 600, color: "#023020" }} variant="subtitle2">Ledger Lines</Typography>
                <Button size="small" startIcon={<Add />} onClick={addLine} sx={{ color: "#023020", fontWeight: 700 }}>Add Line</Button>
              </Box>
              {lines.map((line, i) => (
                <Paper key={i} sx={{ p: 1.5, mb: 1, display: "flex", gap: 1.5, alignItems: "center" }} variant="outlined">
                  <LazyAutocomplete
                    size="small"
                    value={ledgerMapObj[line.ledger_id] || null}
                    onChange={(_, val) => updateLine(i, "ledger_id", val ? val.id : "")}
                    options={ledgers}
                    getOptionLabel={(option: any) => option.name || ""}
                    noOptionsText="No matching ledgers"
                    renderInput={(params) => (
                      <TextField
                        {...params}
                        placeholder="Search Ledger..."
                        required={!line.ledger_id}
                        slotProps={{
                          ...params.slotProps,
                          htmlInput: {
                            ...params.slotProps?.htmlInput,
                            "data-field": "line_ledger",
                            "data-row-index": i
                          }
                        }}
                      />
                    )}
                    sx={{ flex: 2 }}
                  />
                  <TextField size="small" label="Dr" type="number" value={line.dr_amount} onChange={(e) => updateLine(i, "dr_amount", e.target.value)} sx={{ width: 110 }} slotProps={{ htmlInput: { "data-field": "line_dr", "data-row-index": i } }} />
                  <TextField size="small" label="Cr" type="number" value={line.cr_amount} onChange={(e) => updateLine(i, "cr_amount", e.target.value)} sx={{ width: 110 }} slotProps={{ htmlInput: { "data-field": "line_cr", "data-row-index": i } }} />
                  <TextField size="small" label="Narr." value={line.narration} onChange={(e) => updateLine(i, "narration", e.target.value)} sx={{ flex: 1 }} slotProps={{ htmlInput: { "data-field": "line_narration", "data-row-index": i } }} />
                  {lines.length > 1 && <IconButton size="small" color="error" onClick={() => removeLine(i)} tabIndex={-1}><Delete fontSize="small" /></IconButton>}
                </Paper>
              ))}
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
          <Button onClick={onClose} variant="outlined">Cancel</Button>
          <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}
export const PaymentVoucherPage = () => <AccountsVoucherPage voucherType="Payment" />;
export const ReceiptVoucherPage = () => <AccountsVoucherPage voucherType="Receipt" />;
export const ContraVoucherPage = () => <AccountsVoucherPage voucherType="Contra" />;
export const JournalVoucherPage = () => <AccountsVoucherPage voucherType="Journal" />;
export const PurchaseVoucherPage = () => <AccountsVoucherPage voucherType="Purchase" />;
