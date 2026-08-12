import { useState, useRef, useMemo, useEffect, useCallback, memo, startTransition } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Typography, Paper,
  Table, TableHead, TableRow, TableCell, TableBody, Divider, Autocomplete
} from "@mui/material";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import Print from "@mui/icons-material/Print";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";

const AutocompleteAny = Autocomplete as any;
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";

export const resolveProcessName = (procId: any, processesList: any[]): string => {
  if (!procId) return "";
  const strVal = String(procId).trim();
  if (/^\d+(?:\s*,\s*\d+)*$/.test(strVal)) {
    return strVal.split(",")
      .map(id => processesList.find((p: any) => p.id === Number(id.trim()))?.name || id.trim())
      .filter(Boolean).join(" / ");
  }
  return strVal;
};

interface InwardLineItem {
  product_id: number | string;
  process_id?: number | string;
  inward_id?: number | string;
  quantity: number | string;
  weight: number | string;       // Unit weight
  total_weight: number | string; // qty * weight
}

// ──── Inward Voucher Page ────
export function InwardVoucherPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["stock-inward", activeFY],
    queryFn: async () => (await api.get(`/stock/inward?fy=${activeFY}`)).data,
  });
  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });
  const { data: companyData } = useQuery({ queryKey: ["company"], queryFn: async () => (await api.get("/company/")).data });

  const ledgerMap = useMemo(() => {
    const map: Record<number, string> = {};
    ledgers.forEach((l: any) => map[l.id] = l.name);
    return map;
  }, [ledgers]);

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inward/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["stock-inward"] }),
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to delete inward voucher";
      alert(msg);
    },
  });

  const handlePrintInward = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = {
      showLogo: true,
      inwardPaperSize: "A4",
      inwardTitle: "Inward Challan",
      inwardTerms: "1. Received goods are subject to count & quality checks.\n2. Report discrepancies within 24 hours.",
    };
    if (savedConfig) {
      try {
        printConfig = { ...printConfig, ...JSON.parse(savedConfig) };
      } catch (e) {}
    }

    const logoBase64 = localStorage.getItem("company_logo");
    const logoHtml = (printConfig.showLogo && logoBase64)
      ? `<img src="${logoBase64}" />` : "";
    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = new Date(row.inward_date).toLocaleDateString("en-IN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric"
    }).replace(/\//g, "-");

    const refDateStr = row.ref_date ? new Date(row.ref_date).toLocaleDateString("en-IN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric"
    }).replace(/\//g, "-") : "-";

    const processName = resolveProcessName(row.process_id, processes) || "-";
    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const supplierName = supplierLedger?.name || `Supplier #${row.ledger_id}`;
    const supplierAddress = supplierLedger?.address || "";
    const supplierCityStatePin = [supplierLedger?.city, supplierLedger?.state, supplierLedger?.pincode].filter(Boolean).join(" - ");
    const supplierGstin = supplierLedger?.gstin || "";

    let itemsArray: any[] = [];
    if (typeof row.items === "string") {
      try { itemsArray = JSON.parse(row.items); } catch (e) {}
    } else if (Array.isArray(row.items)) {
      itemsArray = row.items;
    }
    if (!itemsArray || itemsArray.length === 0) {
      itemsArray = [{ product_id: row.product_id, quantity: row.quantity || 0, weight: row.weight || 0, total_weight: row.total_weight || 0 }];
    }

    let rowsHtml = "";
    let printTotalQty = 0;
    let printTotalWeight = 0;

    itemsArray.forEach((item, idx) => {
      const pName = products.find((p: any) => p.id === Number(item.product_id))?.name || `Product #${item.product_id}`;
      const qty = Number(item.quantity) || 0;
      const unitWt = Number(item.weight) || 0;
      const totWt = Number(item.total_weight) || Number((qty * unitWt).toFixed(2));
      printTotalQty += qty;
      printTotalWeight += totWt;
      rowsHtml += `
        <tr>
          <td style="text-align: center;">${idx + 1}</td>
          <td style="font-weight: 600;">${pName}</td>
          <td style="text-align: right;">${formatQty(qty)}</td>
          <td style="text-align: right;">${formatWeight(unitWt)} kg</td>
          <td style="text-align: right; font-weight: 600;">${formatWeight(totWt)} kg</td>
        </tr>
      `;
    });

    const formattedTerms = printConfig.inwardTerms.replace(/\n/g, "<br/>");

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Print Inward - ${row.inward_no}</title>
          <style>
            @page { size: ${getPageSizeCSS(printConfig.inwardPaperSize as any)}; margin: 15mm; }
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
            <h2>${printConfig.inwardTitle.toUpperCase()}</h2>
            <div class="doc-no">Inward No: ${row.inward_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
          </div>
           <div class="address-section">
            <div class="address-column">
              <h3>Supplier Details:</h3>
              <div class="name">${supplierName}</div>
              ${supplierAddress ? `<div class="address-lines">${supplierAddress}</div>` : ""}
              ${supplierCityStatePin ? `<div class="address-lines">${supplierCityStatePin}</div>` : ""}
              ${supplierGstin ? `<div class="gstin">GSTIN: ${supplierGstin}</div>` : ""}
            </div>
            <div class="address-column">
              <h3>Reference Details:</h3>
              <div class="address-lines">Ref Date: ${refDateStr}</div>
              <div class="address-lines">Serial No: ${row.serial_no || "-"}</div>
              <div class="address-lines">Process: ${processName}</div>
            </div>
          </div>
          <table class="items-table">
            <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
              <tr style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
                <th style="width: 5%; text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">S.No</th>
                <th style="width: 50%; background-color: #0f5132 !important; color: #ffffff !important;">Product Details</th>
                <th style="width: 15%; text-align: right; background-color: #0f5132 !important; color: #ffffff !important;">Qty</th>
                <th style="width: 15%; text-align: right; background-color: #0f5132 !important; color: #ffffff !important;">Unit Weight</th>
                <th style="width: 15%; text-align: right; background-color: #0f5132 !important; color: #ffffff !important;">Total Weight</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
            </tbody>
          </table>
          <div class="totals-section">
            <div class="calculation-box">
              <div class="calculation-row">
                <span>Total Quantity:</span>
                <span>${formatQty(printTotalQty)}</span>
              </div>
              <div class="calculation-row grand-total">
                <span>Net Weight (kg):</span>
                <span>${formatWeight(printTotalWeight)} kg</span>
              </div>
            </div>
          </div>
          <div class="bottom-section">
            <div class="narration-box">
              <strong>Narration:</strong> ${row.narration || "-"}
            </div>
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
                <div class="signature-label">Receiver Signature</div>
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
    { field: "inward_no", headerName: "Voucher No.", width: 140 },
    { field: "inward_date", headerName: "Date", width: 100, maxWidth: 100 },
    { field: "ledger_id", headerName: "Supplier Name", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { field: "serial_no", headerName: "Serial No", width: 95, maxWidth: 95 },
    { field: "ref_date", headerName: "Ref Date", width: 90, maxWidth: 90 },
    { field: "quantity", headerName: "Total Qty", width: 95, maxWidth: 95, type: "numericColumn" },
    { field: "total_weight", headerName: "Net Weight (kg)", width: 140, type: "numericColumn", valueFormatter: (p) => `${formatWeight(p.value)} kg` },
    { field: "is_completed", headerName: "Status", width: 80, maxWidth: 80, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Completed" : "Pending"} color={p.value ? "success" : "warning"} /> },
    { headerName: "Actions", width: 130, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Print Slip"><IconButton size="small" onClick={() => handlePrintInward(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => { if (window.confirm(`Delete inward "${p.data.inward_no}"?`)) deleteMutation.mutate(p.data.id); }}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    setOpen(true);
  };

  return (
    <Box>
      <PageHeader
        title="Inward Voucher"
        breadcrumbs={[{ label: "Process Voucher" }, { label: "Inward Voucher" }]}
      />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={() => refetch()}
        onAdd={() => handleOpen()}
        addLabel="New Inward"
      />
      <InwardVoucherDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
      />
    </Box>
  );
}

interface InwardVoucherDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
}

function InwardVoucherDialog({ open, onClose, editing }: InwardVoucherDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [lineItems, setLineItems] = useState<InwardLineItem[]>([
    { product_id: "", quantity: "", weight: "", total_weight: "" }
  ]);

  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });

  const { data: suggestedProcesses = [] } = useQuery({
    queryKey: ["suggested-processes", activeFY],
    queryFn: async () => (await api.get(`/stock/inward/suggested-processes?fy=${activeFY}`)).data
  });

  const productMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    products.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [products]);

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);


  const { register, handleSubmit, reset, watch, setValue } = useForm({
    defaultValues: {
      inward_no: "",
      inward_date: new Date().toISOString().split("T")[0],
      ledger_id: "",
      serial_no: "",
      ref_no: "",
      ref_date: "",
      process_id: "",
      expected_duration_days: 2,
      narration: ""
    }
  });

  useEffect(() => {
    if (open) {
      if (editing) {
        reset({
          inward_no: editing.inward_no || "",
          inward_date: editing.inward_date || new Date().toISOString().split("T")[0],
          ledger_id: editing.ledger_id || "",
          serial_no: editing.serial_no || "",
          ref_no: editing.ref_no || "",
          ref_date: editing.ref_date || "",
          process_id: editing.process_id || "",
          expected_duration_days: editing.expected_duration_days || 2,
          narration: editing.narration || ""
        });
        let parsedItems: InwardLineItem[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }
        if (parsedItems && parsedItems.length > 0) {
          parsedItems = parsedItems.map(item => ({
            ...item,
            total_weight: item.total_weight || Number((Number(item.quantity || 0) * Number(item.weight || 0)).toFixed(2))
          }));
          setLineItems(parsedItems);
        } else {
          const qty = editing.quantity || 0;
          const wt = editing.weight || 0;
          setLineItems([{
            product_id: editing.product_id || "",
            quantity: qty,
            weight: wt,
            total_weight: Number((qty * wt).toFixed(2))
          }]);
        }
      } else {
        reset({
          inward_no: "",
          inward_date: new Date().toISOString().split("T")[0],
          ledger_id: "",
          serial_no: "",
          ref_no: "",
          ref_date: new Date().toISOString().split("T")[0],
          process_id: "",
          expected_duration_days: 2,
          narration: ""
        });
        setLineItems([{ product_id: "", quantity: "", weight: "", total_weight: "" }]);

        api.get("/sequences/preview/stock_inward")
          .then((res) => {
            setValue("inward_no", res.data.next_no);
          })
          .catch((e) => console.error(e));
      }
    }
  }, [open, editing, reset]);

  const totalQty = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const netWeight = lineItems.reduce((sum, item) => sum + (Number(item.total_weight) || 0), 0);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        ...formData,
        process_id: formData.process_id || null,
        product_id: lineItems[0]?.product_id ? Number(lineItems[0].product_id) : null,
        ledger_id: formData.ledger_id ? Number(formData.ledger_id) : null,
        quantity: totalQty,
        weight: netWeight,
        total_weight: netWeight,
        items: lineItems.map((item) => ({
          ...item,
          product_id: item.product_id ? Number(item.product_id) : null,
          quantity: Number(item.quantity) || 0,
          weight: Number(item.weight) || 0,
          total_weight: Number(item.total_weight) || 0,
        })),
        expected_duration_days: formData.expected_duration_days ? Number(formData.expected_duration_days) : null,
        ref_date: formData.ref_date || null,
      };
      return editing
        ? api.put(`/stock/inward/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/inward?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-inward"] });
      qc.invalidateQueries({ queryKey: ["suggested-processes"] });
      onClose();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
      alert("Failed to save Inward Voucher. This usually happens if the Voucher Number already exists. Please verify the Voucher Number and try again.");
    }
  });

  const handleAddLineItem = () => {
    setLineItems((prev) => [...prev, { product_id: "", quantity: "", weight: "", total_weight: "" }]);
    setTimeout(() => {
      const inputs = document.querySelectorAll('[data-field="product"]') as NodeListOf<HTMLInputElement>;
      if (inputs.length > 0) {
        inputs[inputs.length - 1].focus();
      }
    }, 50);
  };

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
        const isWeight = active.getAttribute("data-field") === "weight";
        if (isWeight) {
          const rowIdx = Number(active.getAttribute("data-row-index"));
          if (rowIdx === lineItems.length - 1) {
            handleAddLineItem();
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

  const handleRemoveLineItem = (index: number) => {
    if (lineItems.length === 1) return;
    setLineItems((prev) => prev.filter((_, i) => i !== index));
  };

  const handleLineItemChange = (index: number, field: keyof InwardLineItem, value: any) => {
    setLineItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          if (field === "product_id" && value) {
            const p = products.find((x: any) => x.id === Number(value));
            if (p && p.weight !== undefined && p.weight !== null && p.weight !== "") {
              updated.weight = p.weight;
            }
          }
          updated.total_weight = Number((Number(updated.quantity || 0) * Number(updated.weight || 0)).toFixed(2));
          return updated;
        }
        return item;
      })
    );
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))} onKeyDown={handleKeyDown}>
        <DialogTitle sx={{ fontWeight: 700, color: "#023020" }}>
          {editing ? "Edit Inward Voucher" : "New Inward Voucher"}
        </DialogTitle>
        <DialogContent dividers>
          <Grid container spacing={2}>
            {/* Header Details */}
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("inward_no")} label="Voucher Number *" fullWidth required size="small" disabled />
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("inward_date")} label="Date *" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
            </Grid>
            <Grid size={{ xs: 12, sm: 6 }}>
              <LazyAutocomplete
                size="small"
                value={ledgerMapObj[watch("ledger_id")] || null}
                onChange={(_, val) => setValue("ledger_id", val ? val.id : "")}
                options={ledgers}
                getOptionLabel={(option: any) => option.name || ""}
                noOptionsText="No matching suppliers"
                renderInput={(params) => <TextField {...params} label="Supplier Name *" required={!watch("ledger_id")} />}
              />
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("ref_date")} label="Reference Date" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("serial_no")} label="Serial No" fullWidth size="small" />
            </Grid>
            <Grid size={{ xs: 6, sm: 4 }}>
              <Autocomplete
                size="small"
                freeSolo
                value={watch("process_id") || ""}
                onInputChange={(_, val) => setValue("process_id", val)}
                options={typeof suggestedProcesses[0] === "string" ? suggestedProcesses : suggestedProcesses.map((p: any) => String(p))}
                renderInput={(params) => <TextField {...params} label="Processing" fullWidth />}
              />
            </Grid>
            <Grid size={{ xs: 6, sm: 2 }}>
              <TextField {...register("expected_duration_days")} label="Days" type="number" fullWidth size="small" slotProps={{ htmlInput: { min: 1 } }} />
            </Grid>
 
            {/* Line Items Table */}
            <Grid size={{ xs: 12 }}>
              <Typography sx={{ fontWeight: 600, color: "#023020", mb: 1 }} variant="subtitle2">
                Product Line Items
              </Typography>
              <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                <Table size="small">
                  <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                    <TableRow>
                      <TableCell sx={{ width: 50, fontWeight: 700 }} align="center">S. No</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>Product Name *</TableCell>
                      <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Qty *</TableCell>
                      <TableCell sx={{ width: 140, fontWeight: 700 }} align="right">Unit Weight (kg) *</TableCell>
                      <TableCell sx={{ width: 140, fontWeight: 700 }} align="right">Total Weight (kg)</TableCell>
                      <TableCell sx={{ width: 60 }} align="center">Action</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {lineItems.map((item, idx) => (
                       <TableRow key={idx}>
                         <TableCell align="center">{idx + 1}</TableCell>
                        <TableCell>
                          <LazyAutocomplete
                            size="small"
                            value={productMapObj[item.product_id] || null}
                            onChange={(_, val) => handleLineItemChange(idx, "product_id", val ? val.id : "")}
                            options={products}
                            getOptionLabel={(option: any) => option.name || ""}
                            noOptionsText="No matching products"
                            renderInput={(params) => (
                              <TextField
                                {...params}
                                required={!item.product_id}
                                placeholder="Search Product..."
                                slotProps={{
                                  ...params.slotProps,
                                  htmlInput: {
                                    ...params.slotProps?.htmlInput,
                                    "data-field": "product",
                                    "data-row-index": idx
                                  }
                                }}
                              />
                            )}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={item.quantity}
                            onChange={(e) => handleLineItemChange(idx, "quantity", e.target.value)}
                            fullWidth
                            required
                            slotProps={{ htmlInput: { "data-field": "quantity", "data-row-index": idx } }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={item.weight}
                            onChange={(e) => handleLineItemChange(idx, "weight", e.target.value)}
                            fullWidth
                            slotProps={{
                              input: { readOnly: true },
                              htmlInput: { "data-field": "weight", "data-row-index": idx }
                            }}
                            sx={{
                              bgcolor: "action.hover",
                              "& .MuiInputBase-input": { cursor: "not-allowed", fontWeight: 600 }
                            }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <Typography variant="body2" sx={{ fontWeight: 600, pr: 1 }}>
                            {formatWeight(item.total_weight)} kg
                          </Typography>
                        </TableCell>
                        <TableCell align="center">
                          <IconButton size="small" color="error" onClick={() => handleRemoveLineItem(idx)} disabled={lineItems.length === 1} tabIndex={-1}>
                            <RemoveCircle fontSize="small" />
                          </IconButton>
                        </TableCell>
                      </TableRow>
                     ))}
                  </TableBody>
                </Table>
              </Paper>
              <Button startIcon={<Add />} size="small" onClick={handleAddLineItem} sx={{ mt: 1, textTransform: "none", fontWeight: 600 }}>
                Add Product Line
              </Button>
            </Grid>

            {/* Totals Summary Footer */}
            <Grid size={{ xs: 12 }}>
              <Paper variant="outlined" sx={{ p: 2, bgcolor: "#f4f9f6", borderColor: "#023020", borderRadius: "8px", display: "flex", justifyContent: "space-around", alignItems: "center" }}>
                <Box sx={{ textAlign: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>TOTAL QUANTITY</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 800, color: "#023020" }}>{totalQty}</Typography>
                </Box>
                <Divider orientation="vertical" flexItem />
                <Box sx={{ textAlign: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>NET WEIGHT (KG)</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 800, color: "#023020" }}>{formatWeight(netWeight)} kg</Typography>
                </Box>
              </Paper>
            </Grid>

            <Grid size={{ xs: 12 }}>
              <TextField {...register("narration")} label="Narration / Remarks" fullWidth multiline rows={2} size="small" />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, py: 2, gap: 1 }}>
          <Button onClick={onClose} variant="outlined">Cancel</Button>
          <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save Inward Voucher</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}

// ──── Outward Voucher Page ────
export function OutwardVoucherPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);



  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["stock-outward", activeFY],
    queryFn: async () => (await api.get(`/stock/outward?fy=${activeFY}`)).data,
  });
  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Supplier"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data });
  const { data: companyData } = useQuery({ queryKey: ["company"], queryFn: async () => (await api.get("/company/")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: inwardVouchers = [] } = useQuery({
    queryKey: ["stock-inward-all", activeFY],
    queryFn: async () => (await api.get(`/stock/inward?fy=${activeFY}`)).data,
  });

  const inwardMap = useMemo(() => {
    const map: Record<number | string, string> = {};
    inwardVouchers.forEach((iv: any) => { map[iv.id] = iv.inward_no; });
    return map;
  }, [inwardVouchers]);

  const ledgerMap = useMemo(() => {
    const map: Record<number, string> = {};
    ledgers.forEach((l: any) => map[l.id] = l.name);
    return map;
  }, [ledgers]);

  const productMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    products.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [products]);

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const { register, handleSubmit, reset, watch, setValue } = useForm({ defaultValues: { outward_no: "", outward_date: new Date().toISOString().split("T")[0], product_id: "", ledger_id: "", quantity: 0, rate: 0, amount: 0, narration: "" } });

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = {
        ...data,
        product_id: data.product_id ? Number(data.product_id) : null,
        ledger_id: data.ledger_id ? Number(data.ledger_id) : null,
        quantity: Number(data.quantity) || 0,
        rate: Number(data.rate) || 0,
        amount: Number(data.amount) || 0,
      };
      return editing
        ? api.put(`/stock/outward/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/outward?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-outward"] });
      qc.invalidateQueries({ queryKey: ["product-stock-balance"] });
      qc.invalidateQueries({ queryKey: ["pending-inward"] });
      setOpen(false);
    },
  });
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/outward/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-outward"] });
      qc.invalidateQueries({ queryKey: ["product-stock-balance"] });
      qc.invalidateQueries({ queryKey: ["pending-inward"] });
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to delete outward voucher";
      alert(msg);
    },
  });

  const handleOpen = async (row?: any) => {
    if (row) {
      setEditing(row);
      reset(row);
    } else {
      setEditing(null);
      let nextNo = "";
      try {
        const res = await api.get("/sequences/preview/stock_outward");
        nextNo = res.data.next_no;
      } catch (e) {
        console.error(e);
      }
      reset({
        outward_no: nextNo,
        outward_date: new Date().toISOString().split("T")[0],
        product_id: "",
        ledger_id: "",
        quantity: 0,
        rate: 0,
        amount: 0,
        narration: ""
      });
    }
    setOpen(true);
  };

  const handlePrintOutward = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = {
      showLogo: true,
      outwardPaperSize: "A5",
      outwardTitle: "Delivery Note",
      outwardTerms: "1. Goods once sold/delivered cannot be taken back.\n2. Subject to company terms of carriage.",
    };
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig);
        if (parsed.outwardTitle === "Outward Challan") {
          parsed.outwardTitle = "Delivery Note";
          localStorage.setItem("orbx_print_config", JSON.stringify(parsed));
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

    const dateStr = new Date(row.outward_date).toLocaleDateString("en-IN", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric"
    }).replace(/\//g, "-");

    const removeTime = row.created_at
      ? (() => {
          const d = new Date(row.created_at);
          return d.toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" })
            + " " + d.toLocaleTimeString("en-IN", { hour: "2-digit", minute: "2-digit", hour12: true });
        })()
      : "-";

    const itemsList = (() => {
      try {
        const raw = row.items;
        if (!raw) return [];
        const parsed = typeof raw === "string" ? JSON.parse(raw) : raw;
        return Array.isArray(parsed) ? parsed : [];
      } catch { return []; }
    })();

    // Resolve linked inwards ref_no / serial_no from inward_ids
    const inwardIdList = (() => {
      const ids = row.inward_ids || (row.inward_id ? [row.inward_id] : []);
      if (!Array.isArray(ids)) return [];
      return ids.map((id: number) => {
        const inv = inwardVouchers.find((v: any) => v.id === id);
        return inv ? { ref_no: inv.ref_no, serial_no: inv.serial_no, inward_no: inv.inward_no, items: inv.items, product_id: inv.product_id } : { ref_no: "", serial_no: "", inward_no: `#${id}`, items: null, product_id: null };
      });
    })();
    const supplierRefs = inwardIdList.map((inv: any) => inv.ref_no || inv.serial_no || inv.inward_no).filter(Boolean).join(", ") || row.ref_no || "-";
    const productName = itemsList.length > 0
      ? itemsList.map((it: any) => products.find((p: any) => p.id === Number(it.product_id))?.name || `Product #${it.product_id}`).join(", ")
      : (products.find((p: any) => p.id === row.product_id)?.name || `Product #${row.product_id}`);
    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const supplierName = supplierLedger?.name || `Contractor #${row.ledger_id}`;
    const supplierAddress = supplierLedger?.address || "";
    const contractorGstin = supplierLedger?.gstin || "";
    const supplierCityStatePin = [supplierLedger?.city, supplierLedger?.state, supplierLedger?.pincode].filter(Boolean).join(" - ");

    const formattedTerms = printConfig.outwardTerms.replace(/\n/g, "<br/>");

    const printRows: any[] = [];
    if (itemsList.length > 0) {
      itemsList.forEach((outwardItem: any) => {
        let remainingQty = Number(outwardItem.quantity) || 0;
        const prodId = Number(outwardItem.product_id);
        const itemName = products.find((p: any) => p.id === prodId)?.name || `Product #${prodId}`;
        const outRate = Number(outwardItem.weight) || (remainingQty > 0 ? Number(outwardItem.total_weight || 0) / remainingQty : 0);
        let allocated = false;
        
        const matchingInwards = inwardIdList.filter((inv: any) => {
          if (inv.product_id && Number(inv.product_id) === prodId) return true;
          if (!inv.items) return false;
          try {
            const invItems = typeof inv.items === 'string' ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
            return invItems.some((i: any) => Number(i.product_id) === prodId);
          } catch { return false; }
        });

        if (matchingInwards.length > 0) {
          matchingInwards.forEach((inv: any) => {
            if (remainingQty <= 0) return;
            let invQty = 0;
            if (inv.product_id && Number(inv.product_id) === prodId) {
              invQty = Number(inv.quantity || 0);
            } else {
              try {
                const invItems = typeof inv.items === 'string' ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
                const match = invItems.find((i: any) => Number(i.product_id) === prodId);
                if (match) invQty = Number(match.quantity || 0);
              } catch {}
            }
            if (invQty <= 0) invQty = remainingQty;
            const allocateQty = Math.min(invQty, remainingQty);
            if (allocateQty > 0) {
              
              let itemProcName = "";
              if (outwardItem.process_id) {
                itemProcName = resolveProcessName(outwardItem.process_id, processes);
              } else {
                try {
                  const invItems = typeof inv.items === 'string' ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
                  const match = invItems.find((i: any) => Number(i.product_id) === prodId);
                  if (match && match.process_id) {
                    itemProcName = resolveProcessName(match.process_id, processes);
                  }
                } catch {}
              }

              printRows.push({
                jobNo: inv.ref_no || inv.serial_no || inv.inward_no,
                itemName: itemName,
                processName: itemProcName || "-",
                quantity: allocateQty,
                total_weight: allocateQty * outRate
              });
              remainingQty -= allocateQty;
              allocated = true;
            }
          });
        }
        
        if (remainingQty > 0 || !allocated) {
          let fallbackJobNo = supplierRefs;
          if (matchingInwards.length > 0) {
            const lastInv = matchingInwards[matchingInwards.length - 1];
            fallbackJobNo = lastInv.ref_no || lastInv.serial_no || lastInv.inward_no;
          }

          let itemProcName = "";
          if (outwardItem.process_id) {
            itemProcName = resolveProcessName(outwardItem.process_id, processes);
          }

          printRows.push({
            jobNo: outwardItem.ref_no || outwardItem.serial_no || fallbackJobNo,
            itemName: itemName,
            processName: itemProcName || "-",
            quantity: remainingQty > 0 ? remainingQty : Number(outwardItem.quantity || 0),
            total_weight: (remainingQty > 0 ? remainingQty : Number(outwardItem.quantity || 0)) * outRate
          });
        }
      });
    } else {
      printRows.push({
        jobNo: supplierRefs,
        itemName: productName,
        processName: "-",
        quantity: Number(row.quantity),
        total_weight: Number(row.total_weight || 0)
      });
    }

    printRows.sort((a, b) => (a.jobNo || "").localeCompare(b.jobNo || ""));

    const totalOutwardQty = printRows.reduce((sum, r) => sum + (Number(r.quantity) || 0), 0);
    const totalOutwardWeight = printRows.reduce((sum, r) => sum + (Number(r.total_weight) || 0), 0);

    let rowsHtml = "";
    let currentJobNo: string | null = null;
    let rowspanCount = 0;

    printRows.forEach((r, idx) => {
      if (r.jobNo !== currentJobNo) {
        currentJobNo = r.jobNo;
        rowspanCount = printRows.slice(idx).findIndex((pr) => pr.jobNo !== currentJobNo);
        if (rowspanCount === -1) rowspanCount = printRows.length - idx;
        
        rowsHtml += `<tr>
          <td style="text-align: center; white-space: nowrap;">${idx + 1}</td>
          <td rowspan="${rowspanCount}" style="vertical-align: top; font-weight: 700; padding-top: 8px; white-space: nowrap;">${r.jobNo}</td>
          <td style="font-weight: 600; white-space: nowrap;">${r.itemName}</td>
          <td style="white-space: nowrap;">${r.processName}</td>
          <td style="text-align: right; white-space: nowrap;">${formatQty(r.quantity)}</td>
          <td style="text-align: right; font-weight: 600; white-space: nowrap;">${formatWeight(r.total_weight)} kg</td>
        </tr>`;
      } else {
        rowsHtml += `<tr>
          <td style="text-align: center; white-space: nowrap;">${idx + 1}</td>
          <td style="font-weight: 600; white-space: nowrap;">${r.itemName}</td>
          <td style="white-space: nowrap;">${r.processName}</td>
          <td style="text-align: right; white-space: nowrap;">${formatQty(r.quantity)}</td>
          <td style="text-align: right; font-weight: 600; white-space: nowrap;">${formatWeight(r.total_weight)} kg</td>
        </tr>`;
      }
    });

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Print Outward - ${row.outward_no}</title>
          <style>
            @page { size: ${getPageSizeCSS(printConfig.outwardPaperSize as any)}; margin: 15mm; }
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
            <h2>${printConfig.outwardTitle.toUpperCase()}</h2>
            <div class="doc-no">Outward No: ${row.outward_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
          </div>
          <div class="address-section">
            <div class="address-column">
              <h3>Supplier:</h3>
              <div class="name">${supplierName}</div>
              ${supplierAddress ? `<div class="address-lines">${supplierAddress}</div>` : ""}
              ${supplierCityStatePin ? `<div class="address-lines">${supplierCityStatePin}</div>` : ""}
              ${contractorGstin ? `<div class="gstin">GSTIN: ${contractorGstin}</div>` : ""}
            </div>
            <div class="address-column">
              <h3>Dispatch Details:</h3>
              <div class="address-lines"><strong>Dispatch via:</strong> ${row.dispatch_through || "-"}</div>
              <div class="address-lines"><strong>Time of Removal:</strong> ${removeTime}</div>
              <div class="address-lines" style="white-space: normal; word-wrap: break-word; max-width: 300px;"><strong>Supplier Ref:</strong> ${supplierRefs}</div>
              <div class="address-lines" style="margin-top: 4px;">${row.narration || ""}</div>
            </div>
          </div>
          <table class="items-table">
            <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
              <tr style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
                <th style="width: 50px; text-align: center; white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">S.No</th>
                <th style="width: 120px; white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">Job Order No</th>
                <th style="white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">Product Description</th>
                <th style="white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">NATURE OF PROCESS</th>
                <th style="text-align: right; width: 70px; white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">Quantity</th>
                <th style="text-align: right; width: 120px; white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">Total Wt (kg)</th>
              </tr>
            </thead>
            <tbody>
              ${rowsHtml}
            </tbody>
          </table>
          <div class="totals-section">
            <div class="calculation-box">
              <div class="calculation-row">
                <span>Total Quantity:</span>
                <span>${formatQty(totalOutwardQty)}</span>
              </div>
              <div class="calculation-row grand-total">
                <span>Net Weight (kg):</span>
                <span>${formatWeight(totalOutwardWeight)} kg</span>
              </div>
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
                <div class="signature-label">Receiver Signature</div>
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
    { field: "outward_no", headerName: "Voucher No.", width: 140 },
    { field: "outward_date", headerName: "Date", width: 100, maxWidth: 100 },
    { field: "ledger_id", headerName: "Customer Name", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { field: "serial_no", headerName: "Serial No", width: 95, maxWidth: 95 },
    { field: "inward_id", headerName: "Inward Ref.", width: 160, cellRenderer: (p: any) => {
      const ids = p.data?.inward_ids || (p.data?.inward_id ? [p.data.inward_id] : []);
      const names = ids.map((id: number) => inwardMap[id]).filter(Boolean);
      return names.length > 0 ? names.join(", ") : "-";
    } },
    { field: "quantity", headerName: "Total Qty", width: 95, maxWidth: 95, type: "numericColumn" },
    { field: "total_weight", headerName: "Net Weight (kg)", width: 140, type: "numericColumn", valueFormatter: (p) => `${formatWeight(p.value)} kg` },
    { headerName: "Actions", width: 130, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Print"><IconButton size="small" onClick={() => handlePrintOutward(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];

  return (
    <Box>
      <PageHeader title="Outward Voucher" subtitle="Record outgoing process work" breadcrumbs={[{ label: "Customer Material" }, { label: "Outward Voucher" }]} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={() => refetch()}
        onAdd={() => handleOpen()}
        addLabel="New Outward"
      />
      <OutwardVoucherDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
        inwardMap={inwardMap}
        inwardVouchers={inwardVouchers}
      />
    </Box>
  );
}

interface OutwardVoucherDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
  inwardMap: Record<number | string, string>;
  inwardVouchers: any[];
}
// ─────────────────────────────────────────────────────────────────
// Inward Picker – standalone memo component so it never causes
// the outer OutwardVoucherDialog to re-render when items are added.
// ─────────────────────────────────────────────────────────────────
const InwardPickerDialog = memo(function InwardPickerDialog({
  open,
  onClose,
  pendingInwards,
  selectedInwards,
  onSelect,
  processes,
}: {
  open: boolean;
  onClose: () => void;
  pendingInwards: any[];
  selectedInwards: any[];
  onSelect: (inv: any) => void;
  processes: any[];
}) {
  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ fontWeight: 700, color: "#023020", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <Box>
          Select Pending Inward Voucher
          <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 400, mt: 0.25 }}>
            Click a row to add its items · highlighted rows already added
          </Typography>
        </Box>
        <Button size="small" variant="contained"
          sx={{ bgcolor: "#023020", "&:hover": { bgcolor: "#034d30" }, textTransform: "none" }}
          onClick={onClose}>Done</Button>
      </DialogTitle>
      <DialogContent dividers sx={{ p: 0 }}>
        {pendingInwards.length === 0 ? (
          <Box sx={{ py: 6, textAlign: "center" }}>
            <Typography color="text.secondary">No pending inward vouchers found for this supplier.</Typography>
            <Button sx={{ mt: 2 }} variant="outlined" onClick={onClose}>Continue without selecting</Button>
          </Box>
        ) : (
          <Table size="small">
            <TableHead sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow>
                <TableCell sx={{ fontWeight: 700 }}>Inward No</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Serial / Ref</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Process</TableCell>
                <TableCell sx={{ fontWeight: 700 }} align="right">Balance Qty</TableCell>
                <TableCell sx={{ fontWeight: 700 }} align="right">Net Wt (kg)</TableCell>
                <TableCell sx={{ fontWeight: 700 }} align="right">Items</TableCell>
                <TableCell sx={{ width: 90 }} />
              </TableRow>
            </TableHead>
            <TableBody>
              {pendingInwards.map((inv: any) => {
                let itemCount = 0;
                let itemTotalQty = 0;
                try {
                  const parsed = typeof inv.items === "string" ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
                  if (Array.isArray(parsed) && parsed.length > 0) {
                    itemCount = parsed.length;
                    itemTotalQty = parsed.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
                  }
                } catch {}
                // Balance qty from API (inward minus outward)
                const balanceQty = Number(inv.balance_qty || 0);
                const alreadySelected = selectedInwards.some((s) => s.id === inv.id);
                return (
                  <TableRow key={inv.id} hover
                    sx={{ cursor: alreadySelected ? "default" : "pointer", bgcolor: alreadySelected ? "#e8f5e9" : "inherit" }}
                    onClick={() => !alreadySelected && onSelect(inv)}>
                    <TableCell>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: "#023020" }}>{inv.inward_no}</Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {inv.inward_date ? new Date(inv.inward_date).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }) : "-"}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" color="text.secondary">
                        {[inv.serial_no && `S: ${inv.serial_no}`, inv.ref_no && `Ref: ${inv.ref_no}`].filter(Boolean).join(" · ") || "-"}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" color="text.secondary">{resolveProcessName(inv.process_id, processes) || "-"}</Typography>
                    </TableCell>
                    <TableCell align="right">
                      <Typography variant="body2" sx={{ fontWeight: 700, color: balanceQty > 0 ? "#023020" : "text.secondary" }}>
                        {balanceQty > 0 ? balanceQty.toLocaleString() : "-"}
                      </Typography>
                    </TableCell>
                    <TableCell align="right">
                      <Typography variant="body2" sx={{ fontWeight: 600 }}>{formatWeight(inv.total_weight)} kg</Typography>
                    </TableCell>
                    <TableCell align="right">
                      <Typography variant="body2">{itemCount > 0 ? `${itemCount} item${itemCount !== 1 ? "s" : ""}` : "-"}</Typography>
                    </TableCell>
                    <TableCell align="center">
                      {alreadySelected ? (
                        <Typography variant="caption" sx={{ color: "#023020", fontWeight: 700 }}>✓ Added</Typography>
                      ) : (
                        <Button size="small" variant="contained"
                          sx={{ textTransform: "none", fontWeight: 600, bgcolor: "#023020", "&:hover": { bgcolor: "#034d30" } }}
                          onClick={(e) => { e.stopPropagation(); onSelect(inv); }}>
                          Add
                        </Button>
                      )}
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        )}
      </DialogContent>
    </Dialog>
  );
});

export function OutwardVoucherDialog({ open, onClose, editing, inwardMap, inwardVouchers }: OutwardVoucherDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const [lineItems, setLineItems] = useState<any[]>([
    { product_id: "", process_id: "", inward_id: "", quantity: "", weight: "", total_weight: "" }
  ]);
  const [pickerLedgerId, setPickerLedgerId] = useState<number | null>(null);
  // Array of selected inward objects (supports multiple)
  const [selectedInwards, setSelectedInwards] = useState<any[]>([]);
  // Ref mirror so handleInwardSelect can read latest value without being a dependency
  const selectedInwardsRef = useRef<any[]>([]);
  selectedInwardsRef.current = selectedInwards;
  // Product Entry Section states
  const [activeInward, setActiveInward] = useState<any | null>(null);
  const [entryProduct, setEntryProduct] = useState<any | null>(null);
  const [entryProcess, setEntryProcess] = useState<any | null>(null);
  const [entryQty, setEntryQty] = useState<string>("");
  const [entryWeight, setEntryWeight] = useState<string>("");

  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: productBalances = [] } = useQuery({
    queryKey: ["product-stock-balance", activeFY],
    queryFn: async () => (await api.get(`/products/stock-balance?fy=${activeFY}`)).data,
    staleTime: 30_000,
  });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: ledgers = [] } = useQuery({ queryKey: ["ledgers", "Supplier"], queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data });
  const { data: allLedgers = [] } = useQuery({ queryKey: ["ledgers-all"], queryFn: async () => (await api.get("/ledgers/")).data });

  // Pending inward vouchers — pre-fetched as soon as a supplier is chosen,
  // so the picker opens instantly (no loading delay after click)
  const { data: pendingInwards = [] } = useQuery({
    queryKey: ["pending-inward", activeFY, pickerLedgerId],
    queryFn: async () => (await api.get(`/stock/inward/pending-outward?fy=${activeFY}${pickerLedgerId ? `&ledger_id=${pickerLedgerId}` : ""}`)).data,
    enabled: !!pickerLedgerId,   // pre-fetch the moment supplier is picked
    staleTime: 30_000,           // cache 30s so re-opening is instant
  });

  const sortedPendingInwards = useMemo(() => {
    return [...pendingInwards].sort((a: any, b: any) => {
      return (a.inward_no || "").localeCompare(b.inward_no || "", undefined, { numeric: true, sensitivity: 'base' });
    });
  }, [pendingInwards]);

  const productMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    products.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [products]);

  const productBalanceMap = useMemo(() => {
    const map: Record<number, number> = {};
    productBalances.forEach((pb: any) => { map[pb.id] = Number(pb.balance_qty || 0); });
    return map;
  }, [productBalances]);

  const processMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    processes.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [processes]);

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const allLedgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    allLedgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [allLedgers]);

  // Enrich selectedInwards with line_items_balance and balance_qty from pendingInwards
  const enrichedSelectedInwards = useMemo(() => {
    return selectedInwards.map((sel) => {
      const match = pendingInwards.find((p: any) => p.id === sel.id);
      if (match) {
        return {
          ...sel,
          line_items_balance: match.line_items_balance,
          balance_qty: match.balance_qty,
        };
      }
      return sel;
    });
  }, [selectedInwards, pendingInwards]);

  // Map of product quantities in the voucher currently being edited (to add back to stock balance to prevent double-deduction)
  const editingProductQtyMap = useMemo(() => {
    if (!editing) return {};
    const map: Record<number, number> = {};
    let items: any[] = [];
    if (typeof editing.items === "string") {
      try { items = JSON.parse(editing.items); } catch {}
    } else if (Array.isArray(editing.items)) {
      items = editing.items;
    }
    if (items.length > 0) {
      items.forEach((it: any) => {
        const pid = Number(it.product_id);
        if (pid) {
          map[pid] = (map[pid] || 0) + (Number(it.quantity) || 0);
        }
      });
    } else if (editing.product_id) {
      map[Number(editing.product_id)] = (map[Number(editing.product_id)] || 0) + (Number(editing.quantity) || 0);
    }
    return map;
  }, [editing]);

  // Build a map of "productId_processId" -> balance qty from the selected inward(s)
  const lineItemBalanceMap = useMemo(() => {
    const map: Record<string, { key: string; inwardId: number; inwardNo: string; productId: number; processId: number | null; quantity: number; balance: number; productName: string }> = {};
    enrichedSelectedInwards.forEach((inv) => {
      let lineItems: any[] = [];
      try {
        lineItems = typeof inv.line_items_balance === "string"
          ? JSON.parse(inv.line_items_balance)
          : (Array.isArray(inv.line_items_balance) ? inv.line_items_balance : []);
      } catch {}
      // Fallback to inward items JSONB if no line_items_balance property is present
      const hasLineItemsBalance = inv.line_items_balance !== undefined && inv.line_items_balance !== null;
      if (!hasLineItemsBalance) {
        try {
          const rawItems = typeof inv.items === "string" ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
          if (rawItems.length > 0) {
            lineItems = rawItems.map((it: any) => ({
              product_id: Number(it.product_id),
              process_id: it.process_id ? Number(it.process_id) : null,
              quantity: Number(it.quantity) || 0,
              balance_qty: Number(it.quantity) || 0,
            }));
          } else if (inv.product_id) {
            lineItems = [{
              product_id: Number(inv.product_id), process_id: null,
              quantity: Number(inv.quantity || 0),
              balance_qty: Number(inv.balance_qty || inv.quantity || 0)
            }];
          }
        } catch {}
      }
      lineItems.forEach((li: any) => {
        const pid = Number(li.product_id);
        if (!pid) return;
        const key = `${inv.id}_${pid}_${li.process_id ?? ""}`;
        if (!map[key]) {
          const prod = productMapObj[pid];
          map[key] = {
            key,
            inwardId: inv.id,
            inwardNo: inv.inward_no,
            productId: pid,
            processId: li.process_id ?? null,
            quantity: Number(li.quantity) || 0,
            balance: Number(li.balance_qty ?? li.quantity) || 0,
            productName: prod?.name || `Product #${pid}`,
          };
        } else {
          map[key].quantity += Number(li.quantity) || 0;
          map[key].balance += Number(li.balance_qty ?? li.quantity) || 0;
        }
      });
    });

    // Add back quantities of the voucher currently being edited, so we display the correct pre-outward balance
    if (editing) {
      let editingItems: any[] = [];
      if (typeof editing.items === "string") {
        try { editingItems = JSON.parse(editing.items); } catch {}
      } else if (Array.isArray(editing.items)) {
        editingItems = editing.items;
      }
      if (editingItems.length > 0) {
        editingItems.forEach((it: any) => {
          const pid = Number(it.product_id);
          if (pid) {
            const targetInwardId = it.inward_id || editing.inward_id || "";
            if (targetInwardId) {
              const key = `${targetInwardId}_${pid}_${it.process_id ?? ""}`;
              if (!map[key]) {
                const prod = productMapObj[pid];
                const inv = enrichedSelectedInwards.find((s) => s.id === Number(targetInwardId));
                map[key] = {
                  key,
                  inwardId: Number(targetInwardId),
                  inwardNo: inv?.inward_no || `#${targetInwardId}`,
                  productId: pid,
                  processId: it.process_id ?? null,
                  quantity: Number(it.quantity) || 0,
                  balance: Number(it.quantity) || 0,
                  productName: prod?.name || `Product #${pid}`,
                };
              } else {
                map[key].balance += Number(it.quantity) || 0;
              }
            }
          }
        });
      } else if (editing.product_id) {
        const pid = Number(editing.product_id);
        const targetInwardId = editing.inward_id || "";
        if (targetInwardId) {
          const key = `${targetInwardId}_${pid}_${editing.process_id ?? ""}`;
          if (!map[key]) {
            const prod = productMapObj[pid];
            const inv = enrichedSelectedInwards.find((s) => s.id === Number(targetInwardId));
            map[key] = {
              key,
              inwardId: Number(targetInwardId),
              inwardNo: inv?.inward_no || `#${targetInwardId}`,
              productId: pid,
              processId: editing.process_id ?? null,
              quantity: Number(editing.quantity) || 0,
              balance: Number(editing.quantity) || 0,
              productName: prod?.name || `Product #${pid}`,
            };
          } else {
            map[key].balance += Number(editing.quantity) || 0;
          }
        }
      }
    }

    return map;
  }, [enrichedSelectedInwards, productMapObj, editing]);

  // Line items available for outward = from the selected inward(s)
  const availableLineItems = useMemo(() => {
    if (enrichedSelectedInwards.length === 0) return products;
    return Object.values(lineItemBalanceMap).filter((li) => li.balance > 0);
  }, [enrichedSelectedInwards, lineItemBalanceMap, products]);

  // Enrich products with stock balance for the dropdown.
  // When inwards are linked, use the accumulated balance from selected inwards.
  const productOptions = useMemo(() => {
    if (enrichedSelectedInwards.length === 0) {
      return products.map((p: any) => {
        const dbBal = productBalanceMap[p.id] ?? null;
        const editingQty = editingProductQtyMap[p.id] ?? 0;
        return {
          ...p,
          balance: dbBal !== null ? dbBal + editingQty : null,
        };
      });
    }
    // Inwards selected: return the separate entries from lineItemBalanceMap
    return Object.values(lineItemBalanceMap).map((li: any) => {
      return {
        ...li,
        id: `${li.inwardId}_${li.productId}_${li.processId ?? ""}`, // unique ID for autocomplete option
        name: `${li.productName} (Inward: ${li.inwardNo})`,
      };
    });
  }, [products, productBalanceMap, enrichedSelectedInwards, lineItemBalanceMap, editingProductQtyMap]);

  const getProductBalance = useCallback((productId: number, processId: number | null, inwardId: number | null) => {
    if (enrichedSelectedInwards.length > 0) {
      if (inwardId) {
        const key = `${inwardId}_${productId}_${processId ?? ""}`;
        if (lineItemBalanceMap[key]) {
          return lineItemBalanceMap[key].balance;
        }
        if (processId !== null) {
          const fallbackKey = `${inwardId}_${productId}_`;
          return lineItemBalanceMap[fallbackKey]?.balance ?? 0;
        }
        return 0;
      }
      // Fallback: sum over all linked inwards if no inwardId is specified
      return Object.values(lineItemBalanceMap)
        .filter((li) => li.productId === productId && (processId ? li.processId === processId : true))
        .reduce((sum, li) => sum + li.balance, 0);
    }
    const dbBal = productBalanceMap[productId] ?? 0;
    const editingQty = editingProductQtyMap[productId] ?? 0;
    return dbBal + editingQty;
  }, [enrichedSelectedInwards, lineItemBalanceMap, productBalanceMap, editingProductQtyMap]);

  const getLiveStockForProductProcessInward = useCallback((productId: number, processId: number | null, inwardId: number | null) => {
    if (!inwardId) return 0;
    const initialBal = getProductBalance(productId, processId, inwardId);
    
    // Check if the inward has a process-specific stock for this product
    const exactKey = `${inwardId}_${productId}_${processId ?? ""}`;
    const hasExactInwardStock = !!lineItemBalanceMap[exactKey];
    
    const usedQty = lineItems
      .filter((it) => {
        const matchesProductAndInward = Number(it.product_id) === productId && Number(it.inward_id) === inwardId;
        if (!matchesProductAndInward) return false;
        
        if (hasExactInwardStock) {
          return Number(it.process_id) === processId;
        } else {
          return true; // consumes from the process-less pool
        }
      })
      .reduce((sum, it) => sum + (Number(it.quantity) || 0), 0);
      
    return Math.max(0, initialBal - usedQty);
  }, [lineItemBalanceMap, getProductBalance, lineItems]);

  const { register, handleSubmit, reset, watch, setValue } = useForm({
    defaultValues: {
      outward_no: "",
      outward_date: new Date().toISOString().split("T")[0],
      ledger_id: "",
      narration: "",
      dispatch_through: "",
    }
  });

  useEffect(() => {
    if (open) {
      setActiveInward(null);
      setEntryProduct(null);
      setEntryProcess(null);
      setEntryQty("");
      setEntryWeight("");
      if (editing) {
        reset({
          outward_no: editing.outward_no || "",
          outward_date: editing.outward_date || new Date().toISOString().split("T")[0],
          ledger_id: editing.ledger_id || "",
          narration: editing.narration || "",
          dispatch_through: editing.dispatch_through || "",
        });
        setPickerLedgerId(Number(editing.ledger_id) || null);
        // Restore selected inwards from editing record
        const inwardIdList = (() => {
          const ids = editing.inward_ids || (editing.inward_id ? [editing.inward_id] : []);
          if (!Array.isArray(ids)) return [];
          return ids.map((id: number) => {
            const inv = inwardVouchers.find((v: any) => v.id === id);
            return {
              id,
              inward_no: inwardMap[id] || `#${id}`,
              serial_no: inv?.serial_no || "",
              ref_no: inv?.ref_no || "",
              items: inv?.items || null,
            };
          });
        })();
        setSelectedInwards(inwardIdList);
        setActiveInward(inwardIdList[0] || null);
        let parsedItems: InwardLineItem[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }
        if (parsedItems && parsedItems.length > 0) {
          parsedItems = parsedItems.map(item => ({
            ...item,
            inward_id: item.inward_id || editing.inward_id || "",
            total_weight: item.total_weight || Number((Number(item.quantity || 0) * Number(item.weight || 0)).toFixed(2))
          }));
          setLineItems(parsedItems);
        } else {
          const qty = editing.quantity || 0;
          const wt = editing.weight || 0;
          setLineItems([{ product_id: editing.product_id || "", process_id: editing.process_id || "", inward_id: editing.inward_id || "", quantity: qty, weight: wt, total_weight: Number((qty * wt).toFixed(2)) }]);
        }
      } else {
        reset({
          outward_no: "",
          outward_date: new Date().toISOString().split("T")[0],
          ledger_id: "",
          narration: "",
          dispatch_through: "",
        });
        setLineItems([{ product_id: "", quantity: "", weight: "", total_weight: "" }]);
        setSelectedInwards([]);
        setPickerLedgerId(null);

        api.get("/sequences/preview/stock_outward")
          .then((res) => {
            setValue("outward_no", res.data.next_no);
          })
          .catch((e) => console.error(e));
      }
    }
  }, [open, editing, reset, inwardMap]);

  const handleSupplierChange = useCallback((val: any) => {
    const id = val ? val.id : "";
    setValue("ledger_id", id);
    setPickerLedgerId(id ? Number(id) : null);
    setSelectedInwards([]); // Clear previously selected inwards
    setActiveInward(null);
    setEntryProduct(null);
    setEntryProcess(null);
    setEntryQty("");
    setEntryWeight("");
  }, [setValue]);

  // Link the selected inward to the voucher
  const handleInwardSelect = useCallback((inward: any) => {
    setActiveInward(inward);
    setSelectedInwards((prev) => {
      if (prev.find((s) => s.id === inward.id)) return prev;
      return [...prev, inward];
    });
  }, []);

  const handleRemoveSelectedInward = useCallback((id: number) => {
    setActiveInward(null);
    setSelectedInwards((prev) => prev.filter((s) => s.id !== id));
  }, []);

  // Memoized lists & values for the Product Entry Section
  const entryProductOptions = useMemo(() => {
    if (!activeInward) return [];
    const productIds = new Set<number>();
    Object.values(lineItemBalanceMap).forEach((li) => {
      if (li.inwardId === activeInward.id) {
        productIds.add(li.productId);
      }
    });
    return products.filter((p: any) => productIds.has(p.id));
  }, [activeInward, lineItemBalanceMap, products]);

  const entryProcessOptions = useMemo(() => {
    if (!activeInward || !entryProduct) return [];
    const procIds = new Set<number | string | null>();
    Object.values(lineItemBalanceMap).forEach((li) => {
      if (li.inwardId === activeInward.id && li.productId === entryProduct.id) {
        procIds.add(li.processId);
      }
    });
    return processes.filter((p: any) => procIds.has(p.id));
  }, [activeInward, entryProduct, lineItemBalanceMap, processes]);

  const entryLiveStockBal = useMemo(() => {
    if (!activeInward || !entryProduct) return 0;
    const inwardId = activeInward.id;
    const productId = entryProduct.id;
    const processId = entryProcess ? entryProcess.id : null;
    return getLiveStockForProductProcessInward(productId, processId, inwardId);
  }, [activeInward, entryProduct, entryProcess, getLiveStockForProductProcessInward]);

  const entryTotalWeight = useMemo(() => {
    const qty = Number(entryQty) || 0;
    const wt = Number(entryWeight) || 0;
    return Number((qty * wt).toFixed(2));
  }, [entryQty, entryWeight]);

  const entryQtyError = useMemo(() => {
    if (!entryQty) return "";
    const qty = Number(entryQty);
    if (qty <= 0) return "Quantity must be greater than 0";
    if (qty > entryLiveStockBal) {
      return `Qty exceeds available stock (${formatQty(entryLiveStockBal)})`;
    }
    return "";
  }, [entryQty, entryLiveStockBal]);

  useEffect(() => {
    if (entryProduct && activeInward) {
      setEntryWeight(entryProduct.weight ? String(entryProduct.weight) : "0");
      const match = Object.values(lineItemBalanceMap).find(
        (li) => li.inwardId === activeInward.id && li.productId === entryProduct.id
      );
      if (match && match.processId) {
        const procObj = processes.find((p: any) => p.id === match.processId);
        if (procObj) setEntryProcess(procObj);
      } else {
        setEntryProcess(null);
      }
    } else {
      setEntryWeight("");
      setEntryProcess(null);
    }
  }, [entryProduct, activeInward, lineItemBalanceMap, processes]);

  const handleAddProductEntry = useCallback(() => {
    if (!activeInward || !entryProduct || !entryProcess || !entryQty || entryQtyError) return;
    const qty = Number(entryQty);
    const wt = Number(entryWeight) || 0;

    const newRow = {
      product_id: entryProduct.id,
      process_id: entryProcess.id,
      inward_id: activeInward.id,
      quantity: qty,
      weight: wt,
      total_weight: entryTotalWeight,
    };

    setLineItems((prev) => {
      const hasOnlyBlank = prev.length === 1 && !prev[0].product_id;
      const base = hasOnlyBlank ? [] : prev;
      return [...base, newRow];
    });

    setEntryProduct(null);
    setEntryProcess(null);
    setEntryQty("");
    setEntryWeight("");
  }, [activeInward, entryProduct, entryProcess, entryQty, entryWeight, entryTotalWeight, entryQtyError]);

  const totalQty = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const netWeight = lineItems.reduce((sum, item) => sum + (Number(item.total_weight) || 0), 0);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        outward_no: formData.outward_no,
        outward_date: formData.outward_date,
        // Store first inward_id for backward compat, and all ids in narration/items
        inward_id: selectedInwards.length > 0 ? selectedInwards[0].id : null,
        inward_ids: selectedInwards.map((s) => s.id),
        product_id: lineItems[0]?.product_id ? Number(lineItems[0].product_id) : null,
        ledger_id: formData.ledger_id ? Number(formData.ledger_id) : null,
        quantity: totalQty,
        rate: 0,
        amount: 0,
        weight: netWeight,
        total_weight: netWeight,
        narration: formData.narration || null,
        dispatch_through: formData.dispatch_through || null,
        // Read serial_no and ref_no from the first selected inward (not from manual input)
        serial_no: selectedInwards.length > 0 ? (selectedInwards[0].serial_no || null) : null,
        ref_no: selectedInwards.length > 0 ? (selectedInwards[0].ref_no || null) : null,
        items: lineItems.map((item) => ({
          ...item,
          product_id: item.product_id ? Number(item.product_id) : null,
          process_id: item.process_id ? Number(item.process_id) : null,
          quantity: Number(item.quantity) || 0,
          weight: Number(item.weight) || 0,
          total_weight: Number(item.total_weight) || 0,
        })),
      };
      return editing
        ? api.put(`/stock/outward/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/stock/outward?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["stock-outward"] });
      qc.invalidateQueries({ queryKey: ["product-stock-balance"] });
      qc.invalidateQueries({ queryKey: ["pending-inward"] });
      onClose();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
      alert("Failed to save Outward Voucher. This usually happens if the Voucher Number already exists. Please verify the Voucher Number and try again.");
    }
  });

  const handleAddLineItem = useCallback(() => {
    setLineItems((prev) => [...prev, { product_id: "", quantity: "", weight: "", total_weight: "" }]);
    setTimeout(() => {
      const inputs = document.querySelectorAll('[data-field="product"]') as NodeListOf<HTMLInputElement>;
      if (inputs.length > 0) inputs[inputs.length - 1].focus();
    }, 50);
  }, []);

  const handleRemoveLineItem = useCallback((index: number) => {
    if (lineItems.length === 1) return;
    setLineItems((prev) => prev.filter((_, i) => i !== index));
  }, [lineItems.length]);

  const handleLineItemChange = useCallback((index: number, field: keyof InwardLineItem, value: any) => {
    setLineItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          updated.total_weight = Number((Number(updated.quantity || 0) * Number(updated.weight || 0)).toFixed(2));
          return updated;
        }
        return item;
      })
    );
  }, []);

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
        const isWeight = active.getAttribute("data-field") === "weight";
        if (isWeight) {
          const rowIdx = Number(active.getAttribute("data-row-index"));
          if (rowIdx === lineItems.length - 1) {
            handleAddLineItem();
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
        <DialogTitle sx={{ fontWeight: 700, color: "#023020" }}>
          {editing ? "Edit Outward Voucher" : "New Outward Voucher"}
        </DialogTitle>
        <DialogContent dividers>
          <Grid container spacing={2}>
            {/* Header Details */}
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("outward_no")} label="Voucher Number *" fullWidth required size="small" disabled slotProps={{ inputLabel: { shrink: true } }} />
            </Grid>
            <Grid size={{ xs: 6, sm: 3 }}>
              <TextField {...register("outward_date")} label="Date *" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
            </Grid>
            <Grid size={{ xs: 12, sm: 4 }}>
              <LazyAutocomplete
                size="small"
                value={ledgerMapObj[watch("ledger_id")] || null}
                onChange={(_, val) => handleSupplierChange(val)}
                options={ledgers}
                getOptionLabel={(option: any) => option.name || ""}
                noOptionsText="No matching suppliers"
                renderInput={(params) => <TextField {...params} label="Supplier Name *" required={!watch("ledger_id")} />}
              />
            </Grid>
            <Grid size={{ xs: 6, sm: 2 }}>
              <TextField {...register("dispatch_through")} label="Dispatch through" fullWidth size="small" placeholder="Transport / Vehicle details" />
            </Grid>

            {/* Linked Inwards selection */}
            {watch("ledger_id") && (
              <Grid size={{ xs: 12 }}>
                <Box sx={{ display: "flex", flexWrap: "wrap", gap: 1, alignItems: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 700, mr: 0.5 }}>
                    Linked Inwards:
                  </Typography>
                  {(() => {
                    if (!activeInward) return null;
                    const inv = enrichedSelectedInwards.find((s) => s.id === activeInward.id) || activeInward;
                    return (
                      <Box key={inv.id} sx={{
                        display: "inline-flex", alignItems: "center", gap: 0.5,
                        bgcolor: "#e8f5e9", border: "1.5px solid #023020",
                        borderRadius: "999px", px: 1.5, py: 0.4,
                        boxShadow: "0 1px 3px rgba(2,48,32,0.10)",
                      }}>
                        <Typography variant="caption" sx={{ fontWeight: 700, color: "#023020", lineHeight: 1.4 }}>
                          {inv.inward_no || `#${inv.id}`}
                        </Typography>
                        {(inv.serial_no || inv.ref_no) && (
                          <Typography variant="caption" color="text.secondary" sx={{ fontSize: "0.65rem", lineHeight: 1.4 }}>
                            · {[inv.serial_no && `S: ${inv.serial_no}`, inv.ref_no && `Ref: ${inv.ref_no}`].filter(Boolean).join(" · ")}
                          </Typography>
                        )}
                        <IconButton size="small" sx={{ p: 0, ml: 0.25, color: "#023020" }} onClick={() => handleRemoveSelectedInward(inv.id)}>
                          <Typography sx={{ fontSize: 11, lineHeight: 1 }}>✕</Typography>
                        </IconButton>
                      </Box>
                    );
                  })()}
                  
                  {/* Inline Autocomplete selector instead of Dialog Popup */}
                  <Box sx={{ width: 260, display: "inline-block" }}>
                    <LazyAutocomplete
                      size="small"
                      value={null}
                      onChange={(_, val: any) => {
                        if (val) handleInwardSelect(val);
                      }}
                      options={sortedPendingInwards.filter(
                        (inv: any) => 
                          !selectedInwards.some((s) => s.id === inv.id) &&
                          Number(inv.balance_qty || 0) > 0
                      )}
                      getOptionLabel={(option: any) => {
                        const refStr = [option.serial_no && `S: ${option.serial_no}`, option.ref_no && `Ref: ${option.ref_no}`].filter(Boolean).join(" · ");
                        return `${option.inward_no} ${refStr ? `(${refStr})` : ""}`;
                      }}
                      noOptionsText="No pending inwards"
                      renderInput={(params) => <TextField {...params} placeholder="Search / link inward..." size="small" />}
                      renderOption={(props, option: any) => {
                        const { key, ...otherProps } = props;
                        const balanceQty = Number(option.balance_qty || 0);
                        const dateStr = option.inward_date ? new Date(option.inward_date).toLocaleDateString("en-IN", { day: "2-digit", month: "short" }) : "";
                        const refStr = [option.serial_no && `S: ${option.serial_no}`, option.ref_no && `Ref: ${option.ref_no}`].filter(Boolean).join(" · ");
                        return (
                          <li key={key} {...otherProps}>
                            <Box sx={{ display: "flex", justifyContent: "space-between", width: "100%", py: 0.25 }}>
                              <Box>
                                <Typography variant="body2" sx={{ fontWeight: 700, color: "#023020" }}>
                                  {option.inward_no} {dateStr && `(${dateStr})`}
                                </Typography>
                                {refStr && (
                                  <Typography variant="caption" color="text.secondary" sx={{ display: "block", fontSize: "0.75rem" }}>
                                    {refStr}
                                  </Typography>
                                )}
                              </Box>
                              <Box sx={{ textAlign: "right", ml: 2 }}>
                                <Typography variant="caption" sx={{ fontWeight: 700, color: balanceQty > 0 ? "success.main" : "text.secondary" }}>
                                  Bal: {balanceQty.toLocaleString()}
                                </Typography>
                              </Box>
                            </Box>
                          </li>
                        );
                      }}
                    />
                  </Box>
                </Box>
              </Grid>
            )}

            {/* Product Entry Section */}
            {watch("ledger_id") && activeInward && (
              <Grid size={{ xs: 12 }}>
                <Paper variant="outlined" sx={{ p: 2, bgcolor: "#f9fcfb", borderColor: "#023020", borderRadius: "8px" }}>
                  <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#023020", mb: 1.5 }}>
                    Quick Product Entry
                  </Typography>
                  <Grid container spacing={2} sx={{ alignItems: "flex-start" }}>
                    <Grid size={{ xs: 12, sm: 4.5 }}>
                      <Autocomplete
                        size="small"
                        value={entryProduct}
                        onChange={(_, val) => setEntryProduct(val)}
                        options={entryProductOptions}
                        getOptionLabel={(option: any) => option.name || ""}
                        renderInput={(params) => (
                          <TextField
                            {...params}
                            label="Product Name *"
                            required
                            placeholder="Select product..."
                          />
                        )}
                      />
                    </Grid>
                    <Grid size={{ xs: 12, sm: 3.0 }}>
                      <Autocomplete
                        size="small"
                        value={entryProcess}
                        onChange={(_, val) => setEntryProcess(val)}
                        options={processes.filter((p: any) => 
                          (p.is_active || (entryProcess && p.id === entryProcess.id)) && 
                          (p.process_ids || (p.process_code && p.process_code.includes(" / ")))
                        )}
                        getOptionLabel={(option: any) => option.name || ""}
                        disabled={!entryProduct}
                        renderInput={(params) => <TextField {...params} label="Process *" required />}
                      />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 1.1 }}>
                      <TextField
                        size="small"
                        label="Stock Bal"
                        value={entryProduct ? formatWeight(entryLiveStockBal) : "—"}
                        disabled
                        slotProps={{ htmlInput: { style: { textAlign: "right", fontWeight: 700, color: entryLiveStockBal > 0 ? "#0f5132" : "#dc3545" } } }}
                        fullWidth
                      />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 1.1 }}>
                      <TextField
                        size="small"
                        label="Qty *"
                        type="number"
                        value={entryQty}
                        onChange={(e) => setEntryQty(e.target.value)}
                        disabled={!entryProduct || !entryProcess}
                        error={!!entryQtyError}
                        helperText={entryQtyError}
                        slotProps={{ htmlInput: { min: 1, style: { textAlign: "right" } } }}
                        fullWidth
                      />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 1.1 }}>
                      <TextField
                        size="small"
                        label="Unit Wt *"
                        type="number"
                        value={entryWeight}
                        onChange={(e) => setEntryWeight(e.target.value)}
                        disabled={!entryProduct}
                        slotProps={{ htmlInput: { min: 0, style: { textAlign: "right" } } }}
                        fullWidth
                      />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 1.2 }}>
                      <TextField
                        size="small"
                        label="Total Wt"
                        value={entryTotalWeight ? `${formatWeight(entryTotalWeight)} kg` : "—"}
                        disabled
                        slotProps={{ htmlInput: { style: { textAlign: "right", fontWeight: 600 } } }}
                        fullWidth
                      />
                    </Grid>
                    <Grid size={{ xs: 12 }} sx={{ display: "flex", justifyContent: "flex-end", mt: 1 }}>
                      <Button
                        variant="contained"
                        onClick={handleAddProductEntry}
                        disabled={!activeInward || !entryProduct || !entryProcess || !entryQty || !!entryQtyError}
                        sx={{ bgcolor: "#023020", "&:hover": { bgcolor: "#034d30" }, textTransform: "none", fontWeight: 700, height: 38, px: 4 }}
                      >
                        Add Product
                      </Button>
                    </Grid>
                  </Grid>
                </Paper>
              </Grid>
            )}

            {/* Line Items Table */}
            <Grid size={{ xs: 12 }}>
              <Typography sx={{ fontWeight: 600, color: "#023020", mb: 1 }} variant="subtitle2">
                Product Line Items
              </Typography>
              <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                <Table size="small">
                  <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                    <TableRow>
                      <TableCell sx={{ width: 100, fontWeight: 700 }} align="center">Inward No</TableCell>
                      <TableCell sx={{ width: "30%", fontWeight: 700 }}>Product Name *</TableCell>
                      <TableCell sx={{ width: 190, fontWeight: 700 }}>Process</TableCell>
                      <TableCell sx={{ width: 100, fontWeight: 700 }} align="right">Stock Bal</TableCell>
                      <TableCell sx={{ width: 130, fontWeight: 700 }} align="right">Qty *</TableCell>
                      <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Unit Wt (kg) *</TableCell>
                      <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Total Wt (kg)</TableCell>
                      <TableCell sx={{ width: 50 }} align="center">Del</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {lineItems.map((item, idx) => {
                      const lineInwardNo = (() => {
                        if (item.inward_id) {
                          return inwardMap[item.inward_id] ||
                            selectedInwards.find((s: any) => s.id === Number(item.inward_id))?.inward_no ||
                            `#${item.inward_id}`;
                        }
                        if (enrichedSelectedInwards.length === 1)
                          return enrichedSelectedInwards[0].inward_no || `#${enrichedSelectedInwards[0].id}`;
                        return `#${idx + 1}`;
                      })();
                      return (
                       <TableRow key={idx}>
                         <TableCell align="center">
                           <Box sx={{
                             display: "inline-flex", alignItems: "center",
                             bgcolor: "#e8f5e9", border: "1.5px solid #023020",
                             borderRadius: "999px", px: 1, py: 0.2,
                           }}>
                             <Typography variant="caption" sx={{ fontWeight: 700, color: "#023020", whiteSpace: "nowrap", lineHeight: 1.4 }}>
                               {lineInwardNo}
                             </Typography>
                           </Box>
                         </TableCell>
                        <TableCell>
                          <LazyAutocomplete
                            size="small"
                            value={(() => {
                              if (enrichedSelectedInwards.length > 0) {
                                const targetInwardId = item.inward_id || (enrichedSelectedInwards.length === 1 ? enrichedSelectedInwards[0].id : null);
                                return productOptions.find((opt: any) => 
                                  opt.productId === Number(item.product_id) && 
                                  (targetInwardId ? opt.inwardId === Number(targetInwardId) : true) &&
                                  (item.process_id ? opt.processId === Number(item.process_id) : true)
                                ) || productMapObj[item.product_id] || null;
                              }
                              return productMapObj[item.product_id] || null;
                            })()}
                            onChange={(_, val: any) => {
                              if (val) {
                                const prodId = val.productId ?? val.id ?? "";
                                const processId = val.processId ?? "";
                                const inwardId = val.inwardId ?? "";
                                const prodObj = productMapObj[prodId];
                                const unitWt = val.weight ?? prodObj?.weight ?? 0;
                                setLineItems((prev) =>
                                  prev.map((it, i) => {
                                    if (i === idx) {
                                      const qty = Number(it.quantity || 0);
                                      const wt = Number(unitWt || 0);
                                      return {
                                        ...it,
                                        product_id: prodId,
                                        process_id: processId,
                                        inward_id: inwardId,
                                        weight: wt,
                                        total_weight: Number((qty * wt).toFixed(2)),
                                      };
                                    }
                                    return it;
                                  })
                                );
                              } else {
                                handleLineItemChange(idx, "product_id", "");
                                handleLineItemChange(idx, "process_id", "");
                                handleLineItemChange(idx, "inward_id", "");
                                handleLineItemChange(idx, "weight", "");
                              }
                            }}
                            options={productOptions}
                            getOptionLabel={(option: any) => option.productName || option.name || ""}
                            noOptionsText={enrichedSelectedInwards.length > 0 ? "No products from selected inward(s)" : "No matching products"}
                            renderOption={({ key, ...otherProps }: any, option: any) => {
                              const bal = option.balance;
                              return (
                                <li key={key} {...otherProps}>
                                  <Box sx={{ width: "100%", py: 0.25 }}>
                                    <Typography variant="body2">{option.name || option.productName}</Typography>
                                    {bal !== undefined && bal !== null && (
                                      <Typography variant="caption" sx={{ color: bal > 0 ? "success.main" : "error.main", fontWeight: 600 }}>
                                        Available Stock: {formatWeight(bal)}
                                      </Typography>
                                    )}
                                  </Box>
                                </li>
                              );
                            }}
                            renderInput={(params) => (
                              <TextField
                                {...params}
                                required={!item.product_id}
                                placeholder={enrichedSelectedInwards.length > 0 ? "Select from inwarded items..." : "Search Product..."}
                                slotProps={{
                                  ...params.slotProps,
                                  htmlInput: {
                                    ...params.slotProps?.htmlInput,
                                    "data-field": "product",
                                    "data-row-index": idx
                                  }
                                }}
                              />
                            )}
                          />

                        </TableCell>
                        <TableCell sx={{ width: 220, whiteSpace: "nowrap" }}>
                          <Autocomplete
                            size="small"
                            value={processMapObj[item.process_id ?? ""] || null}
                            onChange={(_, val) => handleLineItemChange(idx, "process_id", val ? val.id : "")}
                            options={processes.filter((p: any) => 
                              (p.is_active || p.id === Number(item.process_id)) && 
                              (p.process_ids || (p.process_code && p.process_code.includes(" / ")))
                            )}
                            getOptionLabel={(option: any) => option.name || ""}
                            noOptionsText="No processes"
                            renderInput={(params) => <TextField {...params} placeholder="Select process..." />}
                            renderOption={(props, option) => {
                              const { key, ...otherProps } = props;
                              return (
                                <li key={key} {...otherProps}>
                                  <Typography variant="body2" sx={{ fontSize: "0.8rem", whiteSpace: "nowrap" }}>
                                    {option.name}
                                  </Typography>
                                </li>
                              );
                            }}
                          />
                        </TableCell>
                          {/* Balance Stock qty for this line item (from productBalanceMap) */}
                        <TableCell align="right">
                          {(() => {
                            if (!item.product_id) return <Typography variant="body2" color="text.disabled">—</Typography>;
                            const prodId = Number(item.product_id);
                            const processId = item.process_id ? Number(item.process_id) : null;
                            const inwardId = item.inward_id ? Number(item.inward_id) : null;
                            const initialBal = getProductBalance(prodId, processId, inwardId);
                            const remainingBal = getLiveStockForProductProcessInward(prodId, processId, inwardId);
                            
                            const exactKey = `${inwardId}_${prodId}_${processId ?? ""}`;
                            const hasExactInwardStock = !!lineItemBalanceMap[exactKey];
                            const totalQtyEntered = lineItems
                              .filter((it) => {
                                const matchesProductAndInward = Number(it.product_id) === prodId && Number(it.inward_id) === inwardId;
                                if (!matchesProductAndInward) return false;
                                if (hasExactInwardStock) {
                                  return Number(it.process_id) === processId;
                                } else {
                                  return true;
                                }
                              })
                              .reduce((sum, it) => sum + (Number(it.quantity) || 0), 0);
                            const isOver = totalQtyEntered > initialBal;
                            return (
                              <Box sx={{ textAlign: "right" }}>
                                <Typography variant="body2" sx={{
                                  fontWeight: 700,
                                  color: isOver ? "error.main" : "success.main"
                                }}>
                                  {formatWeight(remainingBal)}
                                </Typography>
                                {isOver && (
                                  <Typography variant="caption" sx={{ color: "error.main", fontSize: "0.6rem" }}>⚠ Over</Typography>
                                )}
                              </Box>
                            );
                          })()}
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={item.quantity}
                            onChange={(e) => handleLineItemChange(idx, "quantity", e.target.value)}
                            fullWidth
                            required
                            slotProps={{ htmlInput: { "data-field": "quantity", "data-row-index": idx } }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={item.weight}
                            onChange={(e) => handleLineItemChange(idx, "weight", e.target.value)}
                            fullWidth
                            slotProps={{
                              input: { readOnly: true },
                              htmlInput: { "data-field": "weight", "data-row-index": idx }
                            }}
                            sx={{
                              bgcolor: "action.hover",
                              "& .MuiInputBase-input": { cursor: "not-allowed", fontWeight: 600 }
                            }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <Typography variant="body2" sx={{ fontWeight: 600, pr: 1 }}>
                            {formatWeight(item.total_weight)} kg
                          </Typography>
                        </TableCell>
                        <TableCell align="center">
                          <IconButton size="small" color="error" onClick={() => handleRemoveLineItem(idx)} disabled={lineItems.length === 1} tabIndex={-1}>
                            <RemoveCircle fontSize="small" />
                          </IconButton>
                        </TableCell>
                      </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              </Paper>
              <Button startIcon={<Add />} size="small" onClick={handleAddLineItem} sx={{ mt: 1, textTransform: "none", fontWeight: 600 }}>
                Add Product Line
              </Button>
            </Grid>

            {/* Totals Summary Footer */}
            <Grid size={{ xs: 12 }}>
              <Paper variant="outlined" sx={{ p: 2, bgcolor: "#f4f9f6", borderColor: "#023020", borderRadius: "8px", display: "flex", justifyContent: "space-around", alignItems: "center" }}>
                <Box sx={{ textAlign: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>TOTAL QUANTITY</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 800, color: "#023020" }}>{totalQty}</Typography>
                </Box>
                <Divider orientation="vertical" flexItem />
                <Box sx={{ textAlign: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>NET WEIGHT (KG)</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 800, color: "#023020" }}>{formatWeight(netWeight)} kg</Typography>
                </Box>
              </Paper>
            </Grid>

            <Grid size={{ xs: 12 }}>
              <TextField {...register("narration")} label="Narration / Remarks" fullWidth multiline rows={2} size="small" />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, py: 2, gap: 1 }}>
          <Button onClick={onClose} variant="outlined">Cancel</Button>
          <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save Outward Voucher</Button>
        </DialogActions>
      </form>

    </Dialog>
  );
}
