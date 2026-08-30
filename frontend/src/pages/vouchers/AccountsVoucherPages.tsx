import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Typography, Paper, Autocomplete,
  Table, TableHead, TableBody, TableRow, TableCell, TableContainer
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
const VOUCHER_TYPES = ["Payment", "Receipt", "Contra", "Journal", "Purchase", "Misc. Expenses"];

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

  const handlePrintSingleVoucher = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = {
      showLogo: true,
      paperSize: "A4",
      voucherTitle: `${voucherType} Voucher`,
      voucherTerms: "1. Subject to local jurisdiction.\n2. E. & O.E.",
    };
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig);
        if (parsed.voucherPaperSize) {
          parsed.paperSize = parsed.voucherPaperSize;
        }
        printConfig = { ...printConfig, ...parsed };
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
            <td style="font-weight: 600;">${line.narration || ledgerName}</td>
            <td>${line.narration ? "" : line.narration || ""}</td>
            <td style="text-align: right;">${drAmount}</td>
            <td style="text-align: right; font-weight: 600;">${crAmount}</td>
          </tr>
        `;
      });
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
              ${cTax ? `<p>${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-bar">
            <h2>${voucherTitle}</h2>
          </div>
          <div class="meta-section">
            <div class="meta-box">
              <h3>${leftColTitle}</h3>
              <p class="name">${mainLedgerName}</p>
              ${mainLedgerAddress ? `<p>${mainLedgerAddress}</p>` : ""}
              ${mainLedgerGstin ? `<p><strong>GSTIN:</strong> ${mainLedgerGstin}</p>` : ""}
            </div>
            <div class="meta-box right">
              <p><strong>Voucher No:</strong> ${row.voucher_no}</p>
              <p><strong>Date:</strong> ${dateStr}</p>
              ${row.ref_no ? `<p><strong>Ref No:</strong> ${row.ref_no}</p>` : ""}
            </div>
          </div>
          <table class="items-table">
            <thead>
              <tr>
                <th style="width: 5%; text-align: center;">S.No</th>
                <th style="width: 45%;">Particulars</th>
                <th style="width: 20%;">Narration</th>
                <th style="width: 15%; text-align: right;">Dr (₹)</th>
                <th style="width: 15%; text-align: right;">Cr (₹)</th>
              </tr>
            </thead>
            <tbody>
              ${linesHtml}
            </tbody>
          </table>
          <div class="total-section">
            <div class="words-col">
              <div class="amount-in-words">
                <span class="label">Amount in words:</span>
                <span class="value">${amountInWordsStr} Only</span>
              </div>
            </div>
            <div class="amount-col">
              <div class="total-box">
                <span class="label">Total Amount:</span>
                <span class="value">₹${formatAmount(row.amount)}</span>
              </div>
            </div>
          </div>
          <div class="footer-container">
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
    { field: "ledger_id", headerName: (voucherType === "Purchase" || voucherType === "Misc. Expenses") ? "Supplier Name" : "Ledger", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { field: "amount", headerName: "Amount", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "narration", headerName: "Narration", flex: 1 },
    { field: "ref_no", headerName: "Ref No.", width: 120 },
    { headerName: "Actions", width: 110, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Print Slip"><IconButton size="small" onClick={() => handlePrintSingleVoucher(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => { if (window.confirm(`Delete voucher "${p.data.voucher_no}"?`)) deleteMutation.mutate(p.data.id); }}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  const handleOpenNewVoucher = () => {
    setOpen(true);
  };

  const pageTitle = voucherType === "Misc. Expenses" ? "Misc. Expenses" : `${voucherType} Voucher`;
  const pageSubtitle = voucherType === "Misc. Expenses" ? "Manage and record miscellaneous expense vouchers" : `Post ${voucherType.toLowerCase()} entries`;

  return (
    <Box>
      <PageHeader
        title={pageTitle}
        subtitle={pageSubtitle}
        breadcrumbs={[{ label: "Accounts" }, { label: pageTitle }]}
      />
      <OrbxGrid
        rowData={vouchers}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={handleOpenNewVoucher}
        addLabel={voucherType === "Misc. Expenses" ? "New Expense Entry" : `New ${voucherType}`}
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
  const isToolMode = voucherType === "Misc. Expenses" || voucherType === "Purchase";

  const [lines, setLines] = useState<VoucherLine[]>([{ ledger_id: "", dr_amount: 0, cr_amount: 0, narration: "" }]);
  const [itemLines, setItemLines] = useState<any[]>([{ stock_item_id: "", quantity: "", rate: "", amount: "" }]);

  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });
  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
    enabled: open && isToolMode,
  });

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
      setItemLines([{ stock_item_id: "", quantity: "", rate: "", amount: "" }]);
      reset({ voucher_no: "", voucher_date: today, ledger_id: "", amount: "" as any, narration: "", ref_no: "" });

      const vtype = voucherType.toLowerCase().replace(/[^a-z0-9]/g, "_");
      api.get(`/sequences/preview/voucher_${vtype}`)
        .then((res) => {
          setValue("voucher_no", res.data.next_no);
        })
        .catch((e) => console.error(e));
    }
  }, [open, reset, voucherType, setValue]);

  const addLine = () => {
    setLines((l) => [...l, { ledger_id: "", dr_amount: "", cr_amount: "", narration: "" }]);
  };
  const updateLine = (i: number, field: string, val: any) => setLines((l) => l.map((line, idx) => idx === i ? { ...line, [field]: val } : line));
  const removeLine = (i: number) => {
    setLines((l) => l.filter((_, idx) => idx !== i));
  };

  const addItemLine = () => {
    setItemLines((prev) => [...prev, { stock_item_id: "", quantity: "", rate: "", amount: "" }]);
  };

  const updateItemLine = (index: number, field: string, value: any) => {
    setItemLines((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          if (field === "quantity" || field === "rate") {
            const q = Number(field === "quantity" ? value : item.quantity) || 0;
            const r = Number(field === "rate" ? value : item.rate) || 0;
            updated.amount = q > 0 && r > 0 ? (q * r).toFixed(2) : "";
          }
          return updated;
        }
        return item;
      })
    );
  };

  const removeItemLine = (index: number) => {
    if (itemLines.length === 1) return;
    setItemLines((prev) => prev.filter((_, i) => i !== index));
  };

  const totalItemAmount = useMemo(() => {
    return itemLines.reduce((sum, item) => {
      const lineAmt = Number(item.amount) || (Number(item.quantity || 0) * Number(item.rate || 0));
      return sum + lineAmt;
    }, 0);
  }, [itemLines]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      let payloadLines = lines;
      let finalAmount = Number(data.amount) || 0;

      if (isToolMode) {
        finalAmount = totalItemAmount;
        payloadLines = itemLines.map((item) => {
          const stockItem = stockItems.find((s: any) => s.id === Number(item.stock_item_id));
          const itemName = stockItem ? stockItem.name : "Tool/Item";
          const lineAmt = Number(item.amount) || (Number(item.quantity || 0) * Number(item.rate || 0));
          return {
            ledger_id: data.ledger_id,
            dr_amount: lineAmt,
            cr_amount: 0,
            narration: `${itemName} (Qty: ${item.quantity || 0}, Rate: ₹${item.rate || 0})`,
          };
        });
      }

      return api.post(`/vouchers/?fy=${activeFY}`, {
        ...data,
        amount: finalAmount,
        voucher_type: voucherType,
        lines: payloadLines,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["vouchers"] });
      onClose();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
      alert("Failed to save Accounts Voucher. Please verify the details and try again.");
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
        <DialogTitle>{voucherType === "Misc. Expenses" ? "New Expense Voucher" : `New ${voucherType} Voucher`}</DialogTitle>
        <DialogContent dividers>
          <Grid container spacing={2}>
            <Grid size={{ xs: 6, sm: isToolMode ? 4 : 3 }}><TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required size="small" disabled /></Grid>
            <Grid size={{ xs: 6, sm: isToolMode ? 4 : 3 }}><TextField {...register("voucher_date")} label="Date *" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} /></Grid>
            <Grid size={{ xs: 12, sm: isToolMode ? 4 : 6 }}>
              <LazyAutocomplete
                size="small"
                value={ledgerMapObj[watch("ledger_id")] || null}
                onChange={(_, val) => setValue("ledger_id", val ? val.id : "")}
                options={ledgers}
                getOptionLabel={(option: any) => option.name || ""}
                noOptionsText="No matching ledgers"
                renderInput={(params) => <TextField {...params} label={isToolMode ? "Supplier Name *" : "Main Ledger *"} required={!watch("ledger_id")} />}
              />
            </Grid>
            {!isToolMode && (
              <Grid size={{ xs: 6, sm: 4 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth size="small" /></Grid>
            )}
            <Grid size={{ xs: 6, sm: isToolMode ? 6 : 4 }}><TextField {...register("ref_no")} label="Ref No." fullWidth size="small" /></Grid>
            <Grid size={{ xs: 12, sm: isToolMode ? 6 : 4 }}><TextField {...register("narration")} label="Narration" fullWidth size="small" /></Grid>

            {/* Lines Section */}
            {isToolMode ? (
              <Grid size={{ xs: 12 }}>
                <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1, mt: 1 }}>
                  <Typography sx={{ fontWeight: 600, color: "#023020" }} variant="subtitle2">Tools List Master</Typography>
                  <Button size="small" startIcon={<Add />} onClick={addItemLine} sx={{ color: "#023020", fontWeight: 700 }}>Add Line</Button>
                </Box>
                <TableContainer component={Paper} variant="outlined" sx={{ borderRadius: "8px" }}>
                  <Table size="small">
                    <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                      <TableRow>
                        <TableCell sx={{ minWidth: 260, fontWeight: 700 }}>Tool / Item Name *</TableCell>
                        <TableCell sx={{ width: 120, minWidth: 120, fontWeight: 700 }} align="right">Qty *</TableCell>
                        <TableCell sx={{ width: 120, minWidth: 120, fontWeight: 700 }} align="right">Rate *</TableCell>
                        <TableCell sx={{ width: 140, minWidth: 140, fontWeight: 700 }} align="right">Amount</TableCell>
                        <TableCell sx={{ width: 50, minWidth: 50 }} align="center">Del</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {itemLines.map((item, idx) => (
                        <TableRow key={idx}>
                          <TableCell sx={{ minWidth: 260, verticalAlign: "top", pt: 1.5 }}>
                            <LazyAutocomplete
                              size="small"
                              options={stockItems}
                              getOptionLabel={(o: any) => o.item_code ? `${o.name} (${o.item_code})` : o.name}
                              value={stockItems.find((s: any) => s.id === Number(item.stock_item_id)) || null}
                              onChange={(_, v) => updateItemLine(idx, "stock_item_id", v ? String(v.id) : "")}
                              renderInput={(params) => <TextField {...params} placeholder="Search Tool / Item..." required={!item.stock_item_id} />}
                              fullWidth
                            />
                          </TableCell>
                          <TableCell sx={{ minWidth: 120, verticalAlign: "top", pt: 1.5 }} align="right">
                            <TextField
                              size="small"
                              type="number"
                              value={item.quantity}
                              onChange={(e) => updateItemLine(idx, "quantity", e.target.value)}
                              slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.001", min: 0 } }}
                              required
                              fullWidth
                            />
                          </TableCell>
                          <TableCell sx={{ minWidth: 120, verticalAlign: "top", pt: 1.5 }} align="right">
                            <TextField
                              size="small"
                              type="number"
                              value={item.rate}
                              onChange={(e) => updateItemLine(idx, "rate", e.target.value)}
                              slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.01", min: 0 } }}
                              required
                              fullWidth
                            />
                          </TableCell>
                          <TableCell sx={{ minWidth: 140, verticalAlign: "top", pt: 2.2 }} align="right">
                            <Typography variant="body2" sx={{ fontWeight: 600, pr: 1 }}>
                              {item.amount ? `₹${formatAmount(item.amount)}` : (Number(item.quantity || 0) * Number(item.rate || 0)) > 0 ? `₹${formatAmount(Number(item.quantity) * Number(item.rate))}` : "-"}
                            </Typography>
                          </TableCell>
                          <TableCell sx={{ minWidth: 50, verticalAlign: "top", pt: 1.5 }} align="center">
                            <IconButton size="small" color="error" disabled={itemLines.length === 1} onClick={() => removeItemLine(idx)}>
                              <Delete fontSize="small" />
                            </IconButton>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
                <Box sx={{ display: "flex", justifyContent: "flex-end", mt: 1.5, pr: 1 }}>
                  <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#023020" }}>
                    Total Amount: ₹{formatAmount(totalItemAmount)}
                  </Typography>
                </Box>
              </Grid>
            ) : (
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
                        />
                      )}
                      sx={{ flex: 2 }}
                    />
                    <TextField size="small" label="Dr" type="number" value={line.dr_amount} onChange={(e) => updateLine(i, "dr_amount", e.target.value)} sx={{ width: 110 }} />
                    <TextField size="small" label="Cr" type="number" value={line.cr_amount} onChange={(e) => updateLine(i, "cr_amount", e.target.value)} sx={{ width: 110 }} />
                    <TextField size="small" label="Narr." value={line.narration} onChange={(e) => updateLine(i, "narration", e.target.value)} sx={{ flex: 1 }} />
                    {lines.length > 1 && <IconButton size="small" color="error" onClick={() => removeLine(i)} tabIndex={-1}><Delete fontSize="small" /></IconButton>}
                  </Paper>
                ))}
              </Grid>
            )}
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
export const MiscExpensesPage = () => <AccountsVoucherPage voucherType="Misc. Expenses" />;
