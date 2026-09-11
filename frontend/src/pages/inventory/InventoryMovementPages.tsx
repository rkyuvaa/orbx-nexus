import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, MenuItem, Typography,
  Divider, Alert, Table, TableBody, TableCell, TableHead, TableRow, Paper
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Add from "@mui/icons-material/Add";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import Print from "@mui/icons-material/Print";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";


// ──── Detailed Printout Helper ────

function handlePrintMovement(row: any, companyData: any, stockItems: any[], ledgers: any[], uoms: any[], movementType: "Inward" | "Outward") {
  const printWindow = window.open("", "_blank");
  if (!printWindow) return;

  const savedConfig = localStorage.getItem("orbx_print_config");
  let printConfig = {
    showLogo: true,
    billPaperSize: "A4",
    billTitle: movementType === "Inward" ? "Purchase Invoice Voucher" : "Stock Outward Voucher",
    billTerms: "1. Goods once received / issued are subject to inspection.\n2. All disputes subject to local jurisdiction.",
  };
  if (savedConfig) {
    try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch (e) {}
  }

  const logoBase64 = localStorage.getItem("company_logo");
  const logoHtml = (printConfig.showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

  const compData = Array.isArray(companyData) ? companyData[0] : companyData;
  const cName = compData?.name || "SRI METAL";
  const cAddress1 = compData?.address || "";
  const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
  const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
  const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
  const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

  const dateStr = row.movement_date ? new Date(row.movement_date).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-") : "-";

  const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);
  const supplierName = supplierLedger?.name || row.ledger_name || (row.ledger_id ? `Party #${row.ledger_id}` : "Cash / Direct Entry");
  const supplierAddr1 = supplierLedger?.address || [supplierLedger?.address_line1, supplierLedger?.address_line2].filter(Boolean).join(", ") || "";
  const supplierCityStatePin = [supplierLedger?.city, supplierLedger?.state, supplierLedger?.pincode].filter(Boolean).join(" - ");
  const supplierPhone = supplierLedger?.phone || supplierLedger?.mobile ? `Tel: ${[supplierLedger?.phone, supplierLedger?.mobile].filter(Boolean).join(" / ")}` : "";
  const supplierGstin = supplierLedger?.gstin || "";

  let itemsArray: any[] = [];
  if (typeof row.items === "string") {
    try { itemsArray = JSON.parse(row.items); } catch (e) {}
  } else if (Array.isArray(row.items)) {
    itemsArray = row.items;
  }
  if (!itemsArray || itemsArray.length === 0) {
    itemsArray = [{
      stock_item_id: row.stock_item_id,
      quantity: row.quantity || 0,
      rate: row.rate || 0,
      taxable_amount: row.amount || 0,
      gst_percent: row.gst_percent || 0,
      gst_amount: row.gst_amount || 0,
      amount: row.amount || 0,
      uom_id: row.uom_id
    }];
  }

  let totalQty = 0;
  let totalTaxable = 0;
  let totalGst = 0;
  let grandTotal = 0;

  let itemsHtml = "";
  itemsArray.forEach((item, idx) => {
    const sItem = stockItems.find((s: any) => s.id === Number(item.stock_item_id));
    const itemName = sItem ? (sItem.item_code ? `${sItem.name} (${sItem.item_code})` : sItem.name) : (row.stock_item_name || `Item #${item.stock_item_id}`);
    const uomObj = uoms.find((u: any) => u.id === Number(item.uom_id || sItem?.uom_id));
    const uomSymbol = uomObj?.symbol || sItem?.uom_symbol || "";

    const q = Number(item.quantity) || 0;
    const r = Number(item.rate) || 0;
    const gstP = Number(item.gst_percent) || 0;
    const taxable = item.taxable_amount !== undefined ? Number(item.taxable_amount) : (q * r);
    const gstAmt = item.gst_amount !== undefined ? Number(item.gst_amount) : ((taxable * gstP) / 100);
    const totalAmt = item.amount !== undefined ? Number(item.amount) : (taxable + gstAmt);

    totalQty += q;
    totalTaxable += taxable;
    totalGst += gstAmt;
    grandTotal += totalAmt;

    itemsHtml += `
      <tr>
        <td style="text-align: center;">${idx + 1}</td>
        <td style="font-weight: 600; text-align: left;">${itemName}</td>
        <td style="text-align: right;">${formatQty(q)}</td>
        <td style="text-align: right;">₹${formatAmount(r)}</td>
        <td style="text-align: right;">₹${formatAmount(taxable)}</td>
        <td style="text-align: center;">${gstP}%</td>
        <td style="text-align: right;">₹${formatAmount(gstAmt)}</td>
        <td style="text-align: right; font-weight: 700;">₹${formatAmount(totalAmt)}</td>
      </tr>
    `;
  });

  const cgstVal = totalGst > 0 ? (totalGst / 2) : 0;
  const sgstVal = totalGst > 0 ? (totalGst / 2) : 0;
  const amountInWordsStr = toWords(grandTotal > 0 ? grandTotal : totalTaxable);

  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Print ${movementType === "Inward" ? "Purchase" : "Outward"} - ${row.movement_no}</title>
        <style>
          @page { size: ${getPageSizeCSS(printConfig.billPaperSize as any)}; margin: 15mm; }
          ${COMMON_PRINT_CSS}
        </style>
      </head>
      <body>
        <div class="header-container">
          <div class="logo-wrapper">${logoHtml}</div>
          <div class="company-details">
            <h1>${cName}</h1>
            ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
            ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
            <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
            ${cTax ? `<p class="gstin">${cTax}</p>` : ""}
          </div>
        </div>

        <div class="title-section">
          <h2>${movementType === "Inward" ? "PURCHASE INVOICE VOUCHER" : "STOCK OUTWARD VOUCHER"}</h2>
          <div class="doc-no">${movementType === "Inward" ? "Purchase No" : "Movement No"}: ${row.movement_no}</div>
          <div class="doc-date">Date: ${dateStr}</div>
          ${row.ref_no ? `<div class="doc-date">Ref No: ${row.ref_no}</div>` : ""}
        </div>

        <div class="address-section">
          <div class="address-column" style="width: 100%;">
            <h3>${movementType === "Inward" ? "SUPPLIER / PARTY DETAILS:" : "ISSUED TO / PARTY DETAILS:"}</h3>
            <div class="name">${supplierName}</div>
            ${supplierAddr1 ? `<div class="address-lines">${supplierAddr1}</div>` : ""}
            ${supplierCityStatePin ? `<div class="address-lines">${supplierCityStatePin}</div>` : ""}
            ${supplierPhone ? `<div class="address-lines">${supplierPhone}</div>` : ""}
            ${supplierGstin ? `<div class="gstin">GSTIN: ${supplierGstin}</div>` : ""}
          </div>
        </div>

        <table class="items-table">
          <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
            <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
              <th style="width: 45px; text-align: center;">S.NO</th>
              <th style="min-width: 240px; text-align: left;">STOCK ITEM NAME & CODE</th>
              <th style="width: 75px; text-align: right;">QTY</th>
              <th style="width: 85px; text-align: right;">RATE</th>
              <th style="width: 100px; text-align: right;">TAXABLE AMT</th>
              <th style="width: 60px; text-align: center;">GST %</th>
              <th style="width: 90px; text-align: right;">GST AMT</th>
              <th style="width: 105px; text-align: right;">TOTAL AMT</th>
            </tr>
          </thead>
          <tbody>
            ${itemsHtml}
          </tbody>
        </table>

        <div class="totals-section">
          <div class="calculation-box">
            <div class="calculation-row">
              <span>Total Quantity:</span>
              <span><strong>${formatQty(totalQty)}</strong></span>
            </div>
            <div class="calculation-row">
              <span>Taxable Value:</span>
              <span>₹${formatAmount(totalTaxable)}</span>
            </div>
            ${totalGst > 0 ? `
              <div class="calculation-row">
                <span>CGST Amount:</span>
                <span>₹${formatAmount(cgstVal)}</span>
              </div>
              <div class="calculation-row">
                <span>SGST Amount:</span>
                <span>₹${formatAmount(sgstVal)}</span>
              </div>
              <div class="calculation-row">
                <span>Total GST Amount:</span>
                <span>₹${formatAmount(totalGst)}</span>
              </div>
            ` : ""}
            <div class="calculation-row grand-total">
              <span>Grand Total:</span>
              <span>₹${formatAmount(grandTotal)}</span>
            </div>
          </div>
        </div>

        <div class="bottom-section">
          ${amountInWordsStr ? `
            <div class="narration-box" style="background-color: #f0fdf4 !important; font-weight: 700;">
              <strong>AMOUNT IN WORDS:</strong> ${amountInWordsStr.replace(/^Rupees:\s*/i, "").replace(/\s*Rupees Only$/i, "").trim().toUpperCase()} RUPEES ONLY
            </div>
          ` : ""}

          ${row.narration ? `
            <div class="narration-box">
              <strong>Narration / Remarks:</strong> ${row.narration}
            </div>
          ` : ""}

          <div class="signatures-container">
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">Prepared By</div>
            </div>
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">Authorised Signatory<br/>For ${cName}</div>
            </div>
          </div>
        </div>
      </body>
    </html>
  `);
  printWindow.document.close();
  printWindow.focus();
  setTimeout(() => {
    printWindow.print();
  }, 400);
}



// ──── Shared Dialog ────

interface MovementDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
  movementType: "Inward" | "Outward";
}

const GST_RATES = [0, 5, 12, 18, 28];

function MovementDialog({ open, onClose, editing, movementType }: MovementDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [lineItems, setLineItems] = useState<any[]>([
    { stock_item_id: "", quantity: "", rate: "", gst_percent: "0", taxable_amount: "", gst_amount: "0.00", amount: "", uom_id: "" }
  ]);

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { data: inventoryBalance = [] } = useQuery({
    queryKey: ["inventory-balance", activeFY],
    queryFn: async () => (await api.get(`/stock/inventory?fy=${activeFY}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  const { data: uoms = [] } = useQuery({
    queryKey: ["uom"],
    queryFn: async () => (await api.get("/products/uom")).data,
  });

  const balanceMap = useMemo(() => {
    const map: Record<number, number> = {};
    inventoryBalance.forEach((i: any) => { map[i.id] = Number(i.balance_qty || 0); });
    return map;
  }, [inventoryBalance]);

  const stockItemMap = useMemo(() => {
    const map: Record<number, any> = {};
    stockItems.forEach((s: any) => { map[s.id] = s; });
    return map;
  }, [stockItems]);

  const { register, handleSubmit, reset, watch, setValue, control, formState: { errors } } = useForm({
    defaultValues: {
      movement_no: "",
      movement_date: new Date().toISOString().split("T")[0],
      ledger_id: "",
      ref_no: "",
      narration: "",
    },
  });

  // Auto-fill UOM and calculate amounts (Taxable, GST Amt, Total Amt)
  const handleLineItemChange = (index: number, field: string, value: any) => {
    setLineItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          if (field === "stock_item_id") {
            const stockItem = stockItemMap[Number(value)];
            if (stockItem?.uom_id) {
              updated.uom_id = String(stockItem.uom_id);
            } else {
              updated.uom_id = "";
            }
          }
          if (field === "quantity" || field === "rate" || field === "gst_percent") {
            const q = Number(field === "quantity" ? value : item.quantity) || 0;
            const r = Number(field === "rate" ? value : item.rate) || 0;
            const gstP = Number(field === "gst_percent" ? value : item.gst_percent) || 0;
            
            const taxable = q > 0 && r > 0 ? (q * r) : 0;
            const gstAmt = taxable > 0 && gstP > 0 ? ((taxable * gstP) / 100) : 0;
            const totalAmt = taxable + gstAmt;

            updated.taxable_amount = taxable > 0 ? taxable.toFixed(2) : "";
            updated.gst_amount = gstAmt > 0 ? gstAmt.toFixed(2) : "0.00";
            updated.amount = totalAmt > 0 ? totalAmt.toFixed(2) : "";
          }
          return updated;
        }
        return item;
      })
    );
  };

  const handleAddLineItem = () => {
    setLineItems((prev) => [...prev, { stock_item_id: "", quantity: "", rate: "", gst_percent: "0", taxable_amount: "", gst_amount: "0.00", amount: "", uom_id: "" }]);
  };

  const handleRemoveLineItem = (index: number) => {
    if (lineItems.length === 1) return;
    setLineItems((prev) => prev.filter((_, i) => i !== index));
  };

  useEffect(() => {
    if (open) {
      if (editing) {
        reset({
          movement_no: editing.movement_no || "",
          movement_date: editing.movement_date || new Date().toISOString().split("T")[0],
          ledger_id: String(editing.ledger_id || ""),
          ref_no: editing.ref_no || "",
          narration: editing.narration || "",
        });

        let parsedItems: any[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }

        if (parsedItems && parsedItems.length > 0) {
          setLineItems(parsedItems.map((item: any) => {
            const q = Number(item.quantity) || 0;
            const r = Number(item.rate) || 0;
            const gstP = Number(item.gst_percent) || 0;
            const taxable = item.taxable_amount !== undefined ? Number(item.taxable_amount) : (q * r);
            const gstAmt = item.gst_amount !== undefined ? Number(item.gst_amount) : ((taxable * gstP) / 100);
            const totalAmt = item.amount !== undefined ? Number(item.amount) : (taxable + gstAmt);
            return {
              stock_item_id: String(item.stock_item_id || ""),
              quantity: String(item.quantity || ""),
              rate: String(item.rate || ""),
              gst_percent: String(item.gst_percent ?? "0"),
              taxable_amount: taxable > 0 ? taxable.toFixed(2) : "",
              gst_amount: gstAmt > 0 ? gstAmt.toFixed(2) : "0.00",
              amount: totalAmt > 0 ? totalAmt.toFixed(2) : "",
              uom_id: String(item.uom_id || "")
            };
          }));
        } else {
          const q = Number(editing.quantity) || 0;
          const r = Number(editing.rate) || 0;
          const gstP = Number(editing.gst_percent) || 0;
          const taxable = editing.taxable_amount !== undefined ? Number(editing.taxable_amount) : (q * r);
          const gstAmt = editing.gst_amount !== undefined ? Number(editing.gst_amount) : ((taxable * gstP) / 100);
          const totalAmt = editing.amount !== undefined ? Number(editing.amount) : (taxable + gstAmt);
          setLineItems([{
            stock_item_id: String(editing.stock_item_id || ""),
            quantity: String(editing.quantity || ""),
            rate: String(editing.rate || ""),
            gst_percent: String(editing.gst_percent ?? "0"),
            taxable_amount: taxable > 0 ? taxable.toFixed(2) : "",
            gst_amount: gstAmt > 0 ? gstAmt.toFixed(2) : "0.00",
            amount: totalAmt > 0 ? totalAmt.toFixed(2) : "",
            uom_id: String(editing.uom_id || "")
          }]);
        }
      } else {
        reset({
          movement_no: "",
          movement_date: new Date().toISOString().split("T")[0],
          ledger_id: "",
          ref_no: "",
          narration: "",
        });
        setLineItems([{ stock_item_id: "", quantity: "", rate: "", gst_percent: "0", taxable_amount: "", gst_amount: "0.00", amount: "", uom_id: "" }]);

        const seqType = movementType === "Inward" ? "inventory_inward" : "inventory_outward";
        api.get(`/sequences/preview/${seqType}`)
          .then((res) => setValue("movement_no", res.data.next_no))
          .catch((e) => console.error(e));
      }
    }
  }, [open, editing, reset, movementType, setValue]);

  const totalQty = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const totalTaxableAmount = lineItems.reduce((sum, item) => {
    const q = Number(item.quantity) || 0;
    const r = Number(item.rate) || 0;
    return sum + (q * r);
  }, 0);
  const totalGstAmount = lineItems.reduce((sum, item) => {
    const q = Number(item.quantity) || 0;
    const r = Number(item.rate) || 0;
    const gstP = Number(item.gst_percent) || 0;
    return sum + ((q * r * gstP) / 100);
  }, 0);
  const grandTotalAmount = totalTaxableAmount + totalGstAmount;

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const validItems = lineItems.filter(item => item.stock_item_id && Number(item.quantity) > 0);
      if (validItems.length === 0) {
        alert("Please add at least one stock item with a valid quantity.");
        return Promise.reject("No valid items");
      }

      const payload = {
        ...data,
        movement_type: movementType,
        stock_item_id: Number(validItems[0].stock_item_id),
        ledger_id: data.ledger_id ? Number(data.ledger_id) : null,
        quantity: totalQty,
        rate: Number(validItems[0].rate) || 0,
        amount: grandTotalAmount > 0 ? grandTotalAmount : totalTaxableAmount,
        uom_id: validItems[0].uom_id ? Number(validItems[0].uom_id) : null,
        items: validItems.map((item) => {
          const q = Number(item.quantity) || 0;
          const r = Number(item.rate) || 0;
          const gstP = Number(item.gst_percent) || 0;
          const taxable = q * r;
          const gstAmt = (taxable * gstP) / 100;
          const totalAmt = taxable + gstAmt;
          return {
            stock_item_id: Number(item.stock_item_id),
            quantity: q,
            rate: r,
            taxable_amount: Number(taxable.toFixed(2)),
            gst_percent: gstP,
            gst_amount: Number(gstAmt.toFixed(2)),
            amount: Number(totalAmt.toFixed(2)),
            uom_id: item.uom_id ? Number(item.uom_id) : null,
          };
        }),
      };
      return editing
        ? api.put(`/stock/inventory/movements/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/inventory/movements?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      onClose();
    },
    onError: (err: any) => {
      console.error("Save error:", err);
      alert(err.response?.data?.detail || "Failed to save entry. Check duplicate number or missing fields.");
    }
  });

  const willExceed = useMemo(() => {
    if (movementType !== "Outward") return false;
    return lineItems.some(item => {
      if (!item.stock_item_id) return false;
      const balance = balanceMap[Number(item.stock_item_id)] ?? 0;
      return (Number(item.quantity) || 0) > balance;
    });
  }, [lineItems, balanceMap, movementType]);

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xl" fullWidth>
      <DialogTitle sx={{ pb: 1 }}>
        {editing 
          ? `Edit ${movementType === "Inward" ? "Purchase" : movementType}` 
          : `New ${movementType === "Inward" ? "Purchase Entry" : "Stock " + movementType}`}
      </DialogTitle>
      <Divider />
      <DialogContent sx={{ pt: 2 }}>
        <Grid container spacing={2}>
          <Grid size={{ xs: 4 }}>
            <TextField
              label={movementType === "Inward" ? "Purchase No." : "Movement No."}
              fullWidth
              size="small"
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("movement_no", { required: "Required" })}
              error={!!errors.movement_no}
              helperText={errors.movement_no?.message as string}
            />
          </Grid>
          <Grid size={{ xs: 4 }}>
            <TextField
              label="Date"
              type="date"
              fullWidth
              size="small"
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("movement_date", { required: "Required" })}
              error={!!errors.movement_date}
            />
          </Grid>
          <Grid size={{ xs: 4 }}>
            <TextField label="Ref No." fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} {...register("ref_no")} />
          </Grid>
 
          <Grid size={{ xs: 12 }}>
            <Controller
              name="ledger_id"
              control={control}
              render={({ field }) => (
                <LazyAutocomplete 
                  options={ledgers} 
                  getOptionLabel={(o: any) => o.name} 
                  value={ledgers.find((l: any) => l.id === Number(field.value)) || null} 
                  onChange={(_, v) => field.onChange(v ? String(v.id) : "")} 
                  renderInput={(params) => <TextField {...params} label={movementType === "Inward" ? "Supplier / Party (Optional)" : "Issued To / Party (Optional)"} size="small" />} 
                />
              )}
            />
          </Grid>
 
          <Grid size={{ xs: 12 }}>
            <Typography variant="subtitle2" sx={{ color: "#0f5132", fontWeight: 700, mb: 1 }}>Items List</Typography>
            <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
              <Table size="small">
                <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                  <TableRow>
                    <TableCell sx={{ width: 195, minWidth: 185, fontWeight: 700 }}>Stock Item *</TableCell>
                    <TableCell sx={{ width: 115, minWidth: 110, fontWeight: 700 }} align="right">Qty *</TableCell>
                    <TableCell sx={{ width: 110, minWidth: 105, fontWeight: 700 }} align="right">Rate</TableCell>
                    <TableCell sx={{ width: 125, minWidth: 120, fontWeight: 700 }} align="right">Taxable Amt</TableCell>
                    <TableCell sx={{ width: 85, minWidth: 80, fontWeight: 700 }} align="center">GST %</TableCell>
                    <TableCell sx={{ width: 110, minWidth: 105, fontWeight: 700 }} align="right">GST Amt</TableCell>
                    <TableCell sx={{ width: 125, minWidth: 120, fontWeight: 700 }} align="right">Total Amt</TableCell>
                    <TableCell sx={{ width: 45, minWidth: 40 }} align="center">Del</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {lineItems.map((item, idx) => {
                    const currentBalance = item.stock_item_id ? (balanceMap[Number(item.stock_item_id)] ?? 0) : null;
                    const itemExceeds = movementType === "Outward" && currentBalance !== null && (Number(item.quantity) || 0) > currentBalance;
                    
                    const q = Number(item.quantity) || 0;
                    const r = Number(item.rate) || 0;
                    const gstP = Number(item.gst_percent) || 0;
                    const taxable = q * r;
                    const gstAmt = (taxable * gstP) / 100;
                    const totalAmt = taxable + gstAmt;

                    return (
                      <TableRow key={idx}>
                        <TableCell sx={{ width: 195, minWidth: 185, verticalAlign: "top", pt: 1.5 }}>
                          <LazyAutocomplete
                            size="small"
                            options={stockItems}
                            getOptionLabel={(o: any) => o.item_code ? `${o.name} (${o.item_code})` : o.name}
                            value={stockItems.find((s: any) => s.id === Number(item.stock_item_id)) || null}
                            onChange={(_, v) => handleLineItemChange(idx, "stock_item_id", v ? String(v.id) : "")}
                            renderInput={(params) => <TextField {...params} required />}
                            fullWidth
                          />
                          {currentBalance !== null && (
                            <Typography variant="caption" sx={{ color: itemExceeds ? "error.main" : "text.secondary", display: "block", mt: 0.5, ml: 0.5 }}>
                              Bal: {formatQty(currentBalance)} {itemExceeds && "⚠ Exceeds"}
                            </Typography>
                          )}
                        </TableCell>
                        <TableCell sx={{ width: 115, minWidth: 110, verticalAlign: "top", pt: 1.5 }} align="right">
                          <TextField
                            size="small"
                            type="number"
                            value={item.quantity}
                            onChange={(e) => handleLineItemChange(idx, "quantity", e.target.value)}
                            onBlur={(e) => {
                              if (e.target.value !== "") {
                                handleLineItemChange(idx, "quantity", Number(e.target.value).toFixed(3));
                              }
                            }}
                            slotProps={{ htmlInput: { style: { textAlign: "right", paddingLeft: 4, paddingRight: 4 }, step: "0.001", min: 0 } }}
                            required
                            fullWidth
                          />
                        </TableCell>
                        <TableCell sx={{ width: 110, minWidth: 105, verticalAlign: "top", pt: 1.5 }} align="right">
                          <TextField
                            size="small"
                            type="number"
                            value={item.rate}
                            onChange={(e) => handleLineItemChange(idx, "rate", e.target.value)}
                            slotProps={{ htmlInput: { style: { textAlign: "right", paddingLeft: 4, paddingRight: 4 }, step: "0.01", min: 0 } }}
                            fullWidth
                          />
                        </TableCell>
                        <TableCell sx={{ width: 125, minWidth: 120, verticalAlign: "top", pt: 2.2 }} align="right">
                          <Typography variant="body2" sx={{ fontWeight: 600, whiteSpace: "nowrap" }}>
                            {taxable > 0 ? `₹${formatAmount(taxable)}` : "—"}
                          </Typography>
                        </TableCell>
                        <TableCell sx={{ width: 85, minWidth: 80, verticalAlign: "top", pt: 1.5 }} align="center">
                          <TextField
                            select
                            size="small"
                            value={item.gst_percent ?? "0"}
                            onChange={(e) => handleLineItemChange(idx, "gst_percent", e.target.value)}
                            fullWidth
                            slotProps={{ select: { style: { paddingLeft: 4, paddingRight: 4 } } }}
                          >
                            {GST_RATES.map((rate) => (
                              <MenuItem key={rate} value={String(rate)}>
                                {rate}%
                              </MenuItem>
                            ))}
                          </TextField>
                        </TableCell>
                        <TableCell sx={{ width: 110, minWidth: 105, verticalAlign: "top", pt: 2.2 }} align="right">
                          <Typography variant="body2" sx={{ color: gstAmt > 0 ? "#0f5132" : "text.secondary", fontWeight: 600, whiteSpace: "nowrap" }}>
                            {gstAmt > 0 ? `₹${formatAmount(gstAmt)}` : "₹0.00"}
                          </Typography>
                        </TableCell>
                        <TableCell sx={{ width: 125, minWidth: 120, verticalAlign: "top", pt: 2.2 }} align="right">
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#0f5132", whiteSpace: "nowrap" }}>
                            {totalAmt > 0 ? `₹${formatAmount(totalAmt)}` : "—"}
                          </Typography>
                        </TableCell>
                        <TableCell sx={{ width: 45, minWidth: 40, verticalAlign: "top", pt: 2 }} align="center">
                          <IconButton size="small" color="error" disabled={lineItems.length === 1} onClick={() => handleRemoveLineItem(idx)}>
                            <RemoveCircle fontSize="small" />
                          </IconButton>
                        </TableCell>
                      </TableRow>
                    );
                  })}
                  
                  {/* Totals & Add Row */}
                  <TableRow sx={{ bgcolor: "#f4f9f6" }}>
                    <TableCell colSpan={8}>
                      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 2, py: 0.5 }}>
                        <Button size="small" startIcon={<Add />} onClick={handleAddLineItem} sx={{ textTransform: "none", color: "#0f5132", fontWeight: 700 }}>
                          Add Item Row
                        </Button>
                        <Box sx={{ display: "flex", gap: 3, pr: 1, alignItems: "center" }}>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#0f5132" }}>
                            Total Qty: {formatQty(totalQty)}
                          </Typography>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "text.secondary" }}>
                            Taxable Value: ₹{formatAmount(totalTaxableAmount)}
                          </Typography>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#0f5132" }}>
                            Total GST: ₹{formatAmount(totalGstAmount)}
                          </Typography>
                          <Typography variant="subtitle2" sx={{ fontWeight: 800, color: "#0f5132", fontSize: "0.95rem" }}>
                            Grand Total: ₹{formatAmount(grandTotalAmount)}
                          </Typography>
                        </Box>
                      </Box>
                    </TableCell>
                  </TableRow>
                </TableBody>
              </Table>
            </Paper>
          </Grid>

          <Grid size={{ xs: 12 }}>
            <TextField
              label="Narration"
              fullWidth
              size="small"
              multiline
              rows={2}
              slotProps={{ inputLabel: { shrink: true } }}
              {...register("narration")}
            />
          </Grid>

          {willExceed && (
            <Grid size={{ xs: 12 }}>
              <Alert severity="warning" sx={{ py: 0.5 }}>
                One or more outward items exceed available balance.
              </Alert>
            </Grid>
          )}
        </Grid>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" size="small">Cancel</Button>
        <Button
          onClick={handleSubmit((d) => saveMutation.mutate(d))}
          variant="contained"
          size="small"
          disabled={saveMutation.isPending}
          color={movementType === "Inward" ? "success" : "error"}
        >
          {saveMutation.isPending ? "Saving..." : editing ? "Update" : `Save ${movementType}`}
        </Button>
      </DialogActions>
    </Dialog>
  );
}


// ──── Inventory Inward Page ────

export function InventoryInwardPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: companyData = [] } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  const { data: uoms = [] } = useQuery({
    queryKey: ["uom"],
    queryFn: async () => (await api.get("/products/uom")).data,
  });

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["inventory-movements", "Inward", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Inward`)).data,
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inventory/movements/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
    },
  });

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Purchase No.", width: 140 },
    { field: "movement_date", headerName: "Date", width: 110 },
    { field: "ledger_name", headerName: "Supplier / Party", flex: 1, minWidth: 200 },
    {
      field: "quantity", headerName: "Quantity", width: 120, type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data?.uom_symbol || ""}`,
    },
    {
      field: "taxable_amount",
      headerName: "Taxable Amount",
      width: 140,
      type: "numericColumn",
      valueGetter: (p: any) => {
        let itemsList: any[] = [];
        if (typeof p.data?.items === "string") {
          try { itemsList = JSON.parse(p.data.items); } catch (e) {}
        } else if (Array.isArray(p.data?.items)) {
          itemsList = p.data.items;
        }
        if (itemsList && itemsList.length > 0) {
          return itemsList.reduce((sum: number, it: any) => {
            const q = Number(it.quantity) || 0;
            const r = Number(it.rate) || 0;
            return sum + (it.taxable_amount !== undefined ? Number(it.taxable_amount) : (q * r));
          }, 0);
        }
        const amt = Number(p.data?.amount) || 0;
        const gst = Number(p.data?.gst_amount) || 0;
        return p.data?.taxable_amount !== undefined ? Number(p.data.taxable_amount) : Math.max(0, amt - gst);
      },
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    {
      field: "gst_amount",
      headerName: "GST Amount",
      width: 130,
      type: "numericColumn",
      valueGetter: (p: any) => {
        let itemsList: any[] = [];
        if (typeof p.data?.items === "string") {
          try { itemsList = JSON.parse(p.data.items); } catch (e) {}
        } else if (Array.isArray(p.data?.items)) {
          itemsList = p.data.items;
        }
        if (itemsList && itemsList.length > 0) {
          return itemsList.reduce((sum: number, it: any) => {
            const q = Number(it.quantity) || 0;
            const r = Number(it.rate) || 0;
            const gstP = Number(it.gst_percent) || 0;
            const taxable = it.taxable_amount !== undefined ? Number(it.taxable_amount) : (q * r);
            return sum + (it.gst_amount !== undefined ? Number(it.gst_amount) : ((taxable * gstP) / 100));
          }, 0);
        }
        return Number(p.data?.gst_amount) || 0;
      },
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "₹0.00",
    },
    {
      field: "amount",
      headerName: "Total Amount",
      width: 140,
      type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    {
      headerName: "Actions", width: 130, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Print Purchase Invoice">
            <IconButton size="small" color="primary" onClick={() => handlePrintMovement(p.data, companyData, stockItems, ledgers, uoms, "Inward")}>
              <Print fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => { setEditing(p.data); setOpen(true); }}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => {
              if (window.confirm("Delete this purchase entry?")) deleteMutation.mutate(p.data.id);
            }}>
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
        title="Tools Purchase"
        breadcrumbs={[{ label: "Purchase" }, { label: "Tools Purchase" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); setOpen(true); }}
        addLabel="New Purchase"
      />
      <MovementDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
        movementType="Inward"
      />
    </Box>
  );
}


// ──── Inventory Outward Page ────

export function InventoryOutwardPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: companyData = [] } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });

  const { data: uoms = [] } = useQuery({
    queryKey: ["uom"],
    queryFn: async () => (await api.get("/products/uom")).data,
  });

  const { data: movements = [], isLoading, refetch } = useQuery({
    queryKey: ["inventory-movements", "Outward", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}&movement_type=Outward`)).data,
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inventory/movements/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["inventory-movements"] });
      qc.invalidateQueries({ queryKey: ["inventory-balance"] });
    },
  });

  const totalQty = movements.reduce((acc: number, m: any) => acc + Number(m.quantity || 0), 0);
  const totalValue = movements.reduce((acc: number, m: any) => acc + Number(m.amount || 0), 0);

  const summaryCards = (
    <Box sx={{ display: "flex", gap: 2, mb: 1.5 }}>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "error.main", color: "#fff", minWidth: 140, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Outward Qty</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{formatQty(totalQty)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "error.dark", color: "#fff", minWidth: 160, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Outward Value</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>₹{formatAmount(totalValue)}</Typography>
      </Box>
      <Box sx={{ px: 2, py: 1, borderRadius: 2, bgcolor: "primary.main", color: "#fff", minWidth: 120, textAlign: "center" }}>
        <Typography variant="caption" sx={{ opacity: 0.85, display: "block" }}>Total Entries</Typography>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>{movements.length}</Typography>
      </Box>
    </Box>
  );

  const colDefs: ColDef[] = [
    { field: "movement_no", headerName: "Movement No.", width: 150 },
    { field: "movement_date", headerName: "Date", width: 110 },
    {
      field: "stock_item_name",
      headerName: "Stock Item",
      flex: 1,
      minWidth: 180,
      valueGetter: (p: any) => {
        let itemsList: any[] = [];
        if (typeof p.data?.items === "string") {
          try { itemsList = JSON.parse(p.data.items); } catch (e) {}
        } else if (Array.isArray(p.data?.items)) {
          itemsList = p.data.items;
        }
        if (itemsList && itemsList.length > 0) {
          return itemsList
            .map((it: any) => {
              const item = stockItems.find((s: any) => s.id === Number(it.stock_item_id));
              return item ? item.name : `Item #${it.stock_item_id}`;
            })
            .join(", ");
        }
        return p.data?.stock_item_name || "-";
      }
    },
    { field: "item_code", headerName: "Code", width: 100 },
    { field: "ledger_name", headerName: "Issued To / Party", width: 180 },
    {
      field: "quantity", headerName: "Quantity", width: 110, type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data?.uom_symbol || ""}`,
    },
    {
      field: "rate", headerName: "Rate", width: 100, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    {
      field: "amount", headerName: "Amount", width: 120, type: "numericColumn",
      valueFormatter: (p) => p.value ? `₹${formatAmount(p.value)}` : "-",
    },
    { field: "ref_no", headerName: "Ref No.", width: 110 },
    {
      headerName: "Actions", width: 130, sortable: false, filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <Tooltip title="Print Outward Voucher">
            <IconButton size="small" color="primary" onClick={() => handlePrintMovement(p.data, companyData, stockItems, ledgers, uoms, "Outward")}>
              <Print fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => { setEditing(p.data); setOpen(true); }}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => {
              if (window.confirm("Delete this outward entry?")) deleteMutation.mutate(p.data.id);
            }}>
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
        title="Stock Outward"
        breadcrumbs={[{ label: "Inventory" }, { label: "Stock Outward" }]}
      />
      <OrbxGrid
        rowData={movements}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => { setEditing(null); setOpen(true); }}
        addLabel="New Outward"
        summaryCards={summaryCards}
      />
      <MovementDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
        movementType="Outward"
      />
    </Box>
  );
}
