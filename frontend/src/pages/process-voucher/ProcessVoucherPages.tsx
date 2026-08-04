import { useState, useRef, useMemo, useEffect, useCallback, memo, startTransition } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Typography, Paper,
  Table, TableHead, TableRow, TableCell, TableBody, Divider, Autocomplete
} from "@mui/material";
import { Add, Edit, Delete, Refresh, Print, RemoveCircle } from "@mui/icons-material";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";
import { formatQty, formatWeight, formatAmount } from "../../utils/format";

interface InwardLineItem {
  product_id: number | string;
  process_id?: number | string;
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

    const processName = processes.find((p: any) => p.id === row.process_id)?.name || "-";
    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const supplierName = supplierLedger?.name || `Supplier #${row.ledger_id}`;
    const supplierAddress = supplierLedger?.address || "";
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


  const generateNextInwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        const prefix = config.inwardPrefix || "INW/";
        const suffix = config.inwardSuffix || "";
        const nextNo = config.inwardNextNo || 1;
        const padding = config.inwardPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}${suffix}`;
      } catch (e) {}
    }
    return `INW/${String(1).padStart(4, "0")}`;
  };

  const incrementInwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        if (config.inwardNextNo !== undefined) {
          config.inwardNextNo = Number(config.inwardNextNo) + 1;
          localStorage.setItem("orbx_print_config", JSON.stringify(config));
        }
      } catch (e) {}
    }
  };

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
          inward_no: generateNextInwardNo(),
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
      if (!editing) incrementInwardNo();
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
              <TextField {...register("inward_no")} label="Voucher Number *" fullWidth required size="small" />
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
                          <IconButton size="small" color="error" onClick={() => handleRemoveLineItem(idx)} disabled={lineItems.length === 1}>
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

  const generateNextOutwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        const prefix = config.outwardPrefix || "OUT/";
        const suffix = config.outwardSuffix || "";
        const nextNo = config.outwardNextNo || 1;
        const padding = config.outwardPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}${suffix}`;
      } catch (e) {}
    }
    return `OUT/${String(1).padStart(4, "0")}`;
  };

  const incrementOutwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        if (config.outwardNextNo !== undefined) {
          config.outwardNextNo = Number(config.outwardNextNo) + 1;
          localStorage.setItem("orbx_print_config", JSON.stringify(config));
        }
      } catch (e) {}
    }
  };

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
      if (!editing) incrementOutwardNo();
      qc.invalidateQueries({ queryKey: ["stock-outward"] });
      setOpen(false);
    },
  });
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/outward/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["stock-outward"] }),
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to delete outward voucher";
      alert(msg);
    },
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    reset(row || {
      outward_no: generateNextOutwardNo(),
      outward_date: new Date().toISOString().split("T")[0],
      product_id: "",
      ledger_id: "",
      quantity: 0,
      rate: 0,
      amount: 0,
      narration: ""
    });
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
                itemProcName = processes.find((p: any) => p.id === Number(outwardItem.process_id))?.name || "";
              } else {
                try {
                  const invItems = typeof inv.items === 'string' ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
                  const match = invItems.find((i: any) => Number(i.product_id) === prodId);
                  if (match && match.process_id) {
                    itemProcName = processes.find((p: any) => p.id === Number(match.process_id))?.name || "";
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
            itemProcName = processes.find((p: any) => p.id === Number(outwardItem.process_id))?.name || "";
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
                <th style="white-space: nowrap; background-color: #0f5132 !important; color: #ffffff !important;">Nature of Business</th>
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
              <div class="calculation-row grand-total">
                <span style="margin-right: 12px;">Net Weight (kg):</span>
                <span>${formatWeight(row.total_weight)} kg</span>
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
}: {
  open: boolean;
  onClose: () => void;
  pendingInwards: any[];
  selectedInwards: any[];
  onSelect: (inv: any) => void;
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
                      <Typography variant="body2" color="text.secondary">{inv.process_id || "-"}</Typography>
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
    { product_id: "", process_id: "", quantity: "", weight: "", total_weight: "" }
  ]);
  const [inwardPickerOpen, setInwardPickerOpen] = useState(false);
  const [pickerLedgerId, setPickerLedgerId] = useState<number | null>(null);
  // Array of selected inward objects (supports multiple)
  const [selectedInwards, setSelectedInwards] = useState<any[]>([]);
  // Ref mirror so handleInwardSelect can read latest value without being a dependency
  const selectedInwardsRef = useRef<any[]>([]);
  selectedInwardsRef.current = selectedInwards;

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

  // Build a map of "productId_processId" -> balance qty from the selected inward(s)
  const lineItemBalanceMap = useMemo(() => {
    const map: Record<string, { productId: number; processId: number | null; quantity: number; balance: number; productName: string }> = {};
    selectedInwards.forEach((inv) => {
      let lineItems: any[] = [];
      try {
        lineItems = typeof inv.line_items_balance === "string"
          ? JSON.parse(inv.line_items_balance)
          : (Array.isArray(inv.line_items_balance) ? inv.line_items_balance : []);
      } catch {}
      // Fallback to inward items JSONB if no line_items_balance
      if (lineItems.length === 0) {
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
        const key = `${pid}_${li.process_id ?? ""}`;
        if (!map[key]) {
          const prod = productMapObj[pid];
          map[key] = {
            productId: pid,
            processId: li.process_id ?? null,
            quantity: Number(li.quantity) || 0,
            balance: Number(li.balance_qty ?? li.quantity) || 0,
            productName: prod?.name || `Product #${pid}`,
          };
        }
      });
    });
    return map;
  }, [selectedInwards, productMapObj]);

  // Line items available for outward = from the selected inward(s)
  const availableLineItems = useMemo(() => {
    if (selectedInwards.length === 0) return products;
    return Object.values(lineItemBalanceMap).filter((li) => li.balance > 0);
  }, [selectedInwards, lineItemBalanceMap, products]);

  // Enrich products with stock balance for the dropdown.
  // When inwards are linked, still use productBalanceMap (real stock balance)
  // instead of lineItemBalanceMap (which only subtracts inward-linked outward).
  const productOptions = useMemo(() => {
    if (selectedInwards.length === 0) {
      return products.map((p: any) => ({ ...p, balance: productBalanceMap[p.id] ?? null }));
    }
    // Inwards selected: filter to products appearing in selected inwards,
    // but use the actual stock balance from productBalanceMap.
    const availableProductIds = new Set(
      Object.values(lineItemBalanceMap).map((li: any) => li.productId)
    );
    // Editing: selected inwards may be minimal objects without product data —
    // fall back to showing all products when lineItemBalanceMap is empty.
    if (availableProductIds.size === 0) {
      return products.map((p: any) => ({ ...p, balance: productBalanceMap[p.id] ?? null }));
    }
    return products
      .filter((p: any) => availableProductIds.has(p.id))
      .map((p: any) => {
        const mapEntry = Object.values(lineItemBalanceMap).find(
          (li: any) => li.productId === p.id
        );
        return {
          ...p,
          balance: productBalanceMap[p.id] ?? null,
          processId: mapEntry?.processId ?? null,
        };
      });
  }, [products, productBalanceMap, selectedInwards, lineItemBalanceMap]);

  const generateNextOutwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        const prefix = config.outwardPrefix || "OUT/";
        const suffix = config.outwardSuffix || "";
        const nextNo = config.outwardNextNo || 1;
        const padding = config.outwardPadding || 4;
        return `${prefix}${String(nextNo).padStart(padding, "0")}${suffix}`;
      } catch (e) {}
    }
    return `OUT/${String(1).padStart(4, "0")}`;
  };

  const incrementOutwardNo = () => {
    const savedConfig = localStorage.getItem("orbx_print_config");
    if (savedConfig) {
      try {
        const config = JSON.parse(savedConfig);
        if (config.outwardNextNo !== undefined) {
          config.outwardNextNo = Number(config.outwardNextNo) + 1;
          localStorage.setItem("orbx_print_config", JSON.stringify(config));
        }
      } catch (e) {}
    }
  };

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
      if (editing) {
        reset({
          outward_no: editing.outward_no || "",
          outward_date: editing.outward_date || new Date().toISOString().split("T")[0],
          ledger_id: editing.ledger_id || "",
          narration: editing.narration || "",
          dispatch_through: editing.dispatch_through || "",
        });
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
          setLineItems([{ product_id: editing.product_id || "", quantity: qty, weight: wt, total_weight: Number((qty * wt).toFixed(2)) }]);
        }
      } else {
        reset({
          outward_no: generateNextOutwardNo(),
          outward_date: new Date().toISOString().split("T")[0],
          ledger_id: "",
          narration: "",
          dispatch_through: "",
        });
        setLineItems([{ product_id: "", quantity: "", weight: "", total_weight: "" }]);
        setSelectedInwards([]);
        setInwardPickerOpen(false);
        setPickerLedgerId(null);
      }
    }
  }, [open, editing, reset, inwardMap]);

  const handleSupplierChange = useCallback((val: any) => {
    const id = val ? val.id : "";
    setValue("ledger_id", id);
    if (!editing && id) {
      setPickerLedgerId(id);
      setInwardPickerOpen(true);
    }
  }, [editing, setValue]);

  // Add the selected inward to the list — does NOT auto-populate line items.
  // User must manually choose product & quantity so they can acknowledge the balance qty.
  const handleInwardSelect = useCallback((inward: any) => {
    // Duplicate guard using ref (no closure over state)
    if (selectedInwardsRef.current.find((s) => s.id === inward.id)) return;

    // Update selected list immediately so the chip appears right away
    setSelectedInwards((prev) => {
      if (prev.find((s) => s.id === inward.id)) return prev;
      return [...prev, inward];
    });
    // Keep picker open for multi-select
    // Line items are NOT auto-populated — user selects manually
  }, []); // stable — reads selectedInwards via ref

  const handleRemoveSelectedInward = useCallback((id: number) => {
    setSelectedInwards((prev) => prev.filter((s) => s.id !== id));
  }, []);


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
      if (!editing) incrementOutwardNo();
      qc.invalidateQueries({ queryKey: ["stock-outward"] });
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
              <TextField {...register("outward_no")} label="Voucher Number *" fullWidth required size="small" />
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

            {/* Linked Inwards chips */}
            {selectedInwards.length > 0 && (
              <Grid size={{ xs: 12 }}>
                <Box sx={{ display: "flex", flexWrap: "wrap", gap: 1, alignItems: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 700 }}>Linked Inwards:</Typography>
                  {selectedInwards.map((inv) => {
                    let balanceQty = 0;
                    try {
                      const parsed = typeof inv.items === "string" ? JSON.parse(inv.items) : (Array.isArray(inv.items) ? inv.items : []);
                      if (Array.isArray(parsed) && parsed.length > 0) {
                        balanceQty = parsed.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
                      }
                    } catch {}
                    if (!balanceQty) balanceQty = Number(inv.quantity || 0);
                    return (
                    <Box key={inv.id} sx={{
                      display: "inline-flex", alignItems: "center", gap: 0.5,
                      bgcolor: "#e8f5e9", border: "1px solid #023020",
                      borderRadius: "8px", px: 1.5, py: 0.5
                    }}>
                      <Box>
                        <Typography variant="caption" sx={{ fontWeight: 700, color: "#023020", display: "block", lineHeight: 1.2 }}>
                          {inv.inward_no || `#${inv.id}`}
                        </Typography>
                        {(inv.serial_no || inv.ref_no) && (
                          <Typography variant="caption" color="text.secondary" sx={{ fontSize: "0.65rem", lineHeight: 1.2, display: "block" }}>
                            {[inv.serial_no && `S: ${inv.serial_no}`, inv.ref_no && `Ref: ${inv.ref_no}`].filter(Boolean).join(" · ")}
                          </Typography>
                        )}
                        <Typography variant="caption" sx={{ fontSize: "0.7rem", lineHeight: 1.4, display: "block", color: "warning.dark", fontWeight: 700 }}>
                          ⚠ Balance Qty: {balanceQty > 0 ? balanceQty.toLocaleString() : "—"} — please enter qty below
                        </Typography>
                      </Box>
                      <IconButton size="small" sx={{ p: 0, ml: 0.5, color: "#023020" }} onClick={() => handleRemoveSelectedInward(inv.id)}>
                        <Typography sx={{ fontSize: 12, lineHeight: 1 }}>✕</Typography>
                      </IconButton>
                    </Box>
                    );
                  })}
                  <Button size="small" variant="text" sx={{ textTransform: "none", fontWeight: 600, color: "#023020" }}
                    onClick={() => { setPickerLedgerId(Number(watch("ledger_id")) || null); setInwardPickerOpen(true); }}>
                    + Add more
                  </Button>
                </Box>
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
                      <TableCell sx={{ width: 40, fontWeight: 700 }} align="center">S. No</TableCell>
                      <TableCell sx={{ width: "30%", fontWeight: 700 }}>Product Name *</TableCell>
                      <TableCell sx={{ width: 220, fontWeight: 700 }}>Process</TableCell>
                      <TableCell sx={{ width: 90, fontWeight: 700 }} align="right">Stock Bal</TableCell>
                      <TableCell sx={{ width: 90, fontWeight: 700 }} align="right">Qty *</TableCell>
                      <TableCell sx={{ width: 130, fontWeight: 700 }} align="right">Unit Wt (kg) *</TableCell>
                      <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Total Wt (kg)</TableCell>
                      <TableCell sx={{ width: 50 }} align="center">Del</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {lineItems.map((item, idx) => (
                      <TableRow key={idx}>
                        <TableCell align="center">{idx + 1}</TableCell>
                        <TableCell>
                          <LazyAutocomplete
                            size="small"
                            value={(() => {
                              if (selectedInwards.length > 0) {
                                return availableLineItems.find((li: any) => li.productId === Number(item.product_id))
                                  || productMapObj[item.product_id] || null;
                              }
                              return productMapObj[item.product_id] || null;
                            })()}
                            onChange={(_, val: any) => {
                              if (val) {
                                const prodId = val.productId ?? val.id ?? "";
                                const processId = val.processId ?? "";
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
                                handleLineItemChange(idx, "weight", "");
                              }
                            }}
                            options={productOptions}
                            getOptionLabel={(option: any) => option.productName || option.name || ""}
                            noOptionsText={selectedInwards.length > 0 ? "No products from selected inward(s)" : "No matching products"}
                            renderOption={({ key, ...otherProps }: any, option: any) => {
                              const bal = option.balance;
                              return (
                                <li key={key} {...otherProps}>
                                  <Box sx={{ width: "100%", py: 0.25 }}>
                                    <Typography variant="body2">{option.productName || option.name}</Typography>
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
                                placeholder={selectedInwards.length > 0 ? "Select from inwarded items..." : "Search Product..."}
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
                            options={processes.filter((p: any) => p.is_active || p.id === Number(item.process_id))}
                            getOptionLabel={(option: any) => option.name || ""}
                            noOptionsText="No processes"
                            renderInput={(params) => <TextField {...params} placeholder="Select process..." />}
                            renderOption={({ key, ...otherProps }: any, option) => (
                              <li key={key} {...otherProps}><Typography variant="body2" sx={{ whiteSpace: "nowrap" }}>{option.name}</Typography></li>
                            )}
                          />
                        </TableCell>
                          {/* Balance Stock qty for this line item (from productBalanceMap) */}
                        <TableCell align="right">
                          {(() => {
                            const bal = item.product_id ? productBalanceMap[Number(item.product_id)] : undefined;
                            return bal !== undefined ? (
                              <Box sx={{ textAlign: "right" }}>
                                <Typography variant="body2" sx={{
                                  fontWeight: 700,
                                  color: bal > 0 ? "success.main" : "error.main"
                                }}>
                                  {formatWeight(bal)}
                                </Typography>
                                {Number(item.quantity) > bal && (
                                  <Typography variant="caption" sx={{ color: "error.main", fontSize: "0.6rem" }}>⚠ Over</Typography>
                                )}
                              </Box>
                            ) : (
                              <Typography variant="body2" color="text.disabled">—</Typography>
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
                          <IconButton size="small" color="error" onClick={() => handleRemoveLineItem(idx)} disabled={lineItems.length === 1}>
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
          <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save Outward Voucher</Button>
        </DialogActions>
      </form>

      {/* Picker rendered as a separate memo component – no re-render coupling with the outer dialog */}
      <InwardPickerDialog
        open={inwardPickerOpen}
        onClose={() => setInwardPickerOpen(false)}
        pendingInwards={pendingInwards}
        selectedInwards={selectedInwards}
        onSelect={handleInwardSelect}
      />
    </Dialog>
  );
}
