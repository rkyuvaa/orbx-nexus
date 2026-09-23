import { useState, useMemo, useEffect, useCallback, useRef, memo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Menu, Autocomplete,
  Typography, Paper, Table, TableHead, TableRow, TableCell, TableBody,
  Checkbox, FormControlLabel
} from "@mui/material";
import * as XLSX from "xlsx";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Refresh from "@mui/icons-material/Refresh";
import CheckCircle from "@mui/icons-material/CheckCircle";
import Print from "@mui/icons-material/Print";
import Description from "@mui/icons-material/Description";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import { useForm } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";

import OrbxGrid from "../../components/tables/OrbxGrid";

import { useAuthStore } from "../../store";

import { LazyAutocomplete } from "../../components/LazyAutocomplete";

import { toWords } from "../../utils/numberToWords";

import { COMMON_PRINT_CSS, getPageSizeCSS } from "../../utils/printStyles";

import { formatQty, formatWeight, formatAmount } from "../../utils/format";
import { resolveProcessName } from "../process-voucher/ProcessVoucherPages";

const AutocompleteAny = Autocomplete as any;

function WorkDetailsActionMenu({
  row,
  onPrint,
  onExportExcel
}: {
  row: any;
  onPrint: (row: any) => void;
  onExportExcel: (row: any) => void;
}) {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const open = Boolean(anchorEl);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.stopPropagation();
    setAnchorEl(e.currentTarget);
  };

  const handleClose = (e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    setAnchorEl(null);
  };

  return (
    <>
      <Tooltip title="Work Details">
        <IconButton size="small" onClick={handleClick}>
          <Description fontSize="small" />
        </IconButton>
      </Tooltip>
      <Menu
        anchorEl={anchorEl}
        open={open}
        onClose={() => handleClose()}
        onClick={(e) => e.stopPropagation()}
        slotProps={{ paper: { sx: { borderRadius: "8px", minWidth: 170, boxShadow: 3 } } }}
      >
        <MenuItem onClick={(e) => { handleClose(e); onPrint(row); }}>
          <Print fontSize="small" sx={{ mr: 1, color: "#023020" }} /> Print
        </MenuItem>
        <MenuItem onClick={(e) => { handleClose(e); onExportExcel(row); }}>
          <Description fontSize="small" sx={{ mr: 1, color: "#1d6f42" }} /> Download Excel
        </MenuItem>
      </Menu>
    </>
  );
}



export const getBillShotBlastingWeight = (
  row: any,
  processMap: Record<number | string, any> = {},
  processesList: any[] = []
): number => {
  if (!row) return 0;

  let itemsArray: any[] = [];
  if (typeof row.items === "string") {
    try {
      itemsArray = JSON.parse(row.items);
    } catch (e) {
      itemsArray = [];
    }
  } else if (Array.isArray(row.items)) {
    itemsArray = row.items;
  }

  if (itemsArray && itemsArray.length > 0) {
    // 1. Try to find items matching "shot" in process name, code, or resolved name
    const shotItems = itemsArray.filter((item: any) => {
      const proc = processMap[item.process_id] || processesList.find((p: any) => p.id === Number(item.process_id));
      const name = (proc && (proc.name || proc.process_name || proc.process_code)) || "";
      if (/shot/i.test(name)) return true;
      const resolved = resolveProcessName(item.process_id, processesList);
      return /shot/i.test(resolved);
    });

    if (shotItems.length > 0) {
      const sumShotQty = shotItems.reduce((sum: number, it: any) => sum + (Number(it.quantity) || 0), 0);
      if (sumShotQty > 0) return sumShotQty;
    }

    // 2. All items start with shotblasting only, so the first item's quantity covers all
    const firstQty = Number(itemsArray[0]?.quantity);
    if (!isNaN(firstQty) && firstQty > 0) {
      return firstQty;
    }
  }

  return Number(row.quantity || 0);
};

// Extract outward line items belonging exclusively to a specific inward ID.
export const getOutwardLinesForInward = (out: any, inwId: number): any[] => {
  if (!out || !inwId) return [];
  let rawItems: any[] = [];
  if (Array.isArray(out.items) && out.items.length > 0) {
    rawItems = out.items;
  } else if (typeof out.items === "string" && out.items.trim() !== "") {
    try {
      const parsed = JSON.parse(out.items);
      if (Array.isArray(parsed) && parsed.length > 0) rawItems = parsed;
    } catch (e) {}
  }

  if (rawItems.length === 0) {
    const outHeaderInwardId = Number(out.inward_id);
    let headerMatch = outHeaderInwardId === inwId;
    if (!headerMatch) {
      const outInwardIds: number[] = (() => {
        if (Array.isArray(out.inward_ids)) return out.inward_ids.map(Number);
        if (typeof out.inward_ids === "string") {
          try { return (JSON.parse(out.inward_ids) as any[]).map(Number); } catch {}
        }
        return [];
      })();
      headerMatch = outInwardIds.includes(inwId);
    }
    if (headerMatch) {
      return [{
        product_id: out.product_id || "",
        process_id: out.process_id || "",
        quantity: out.total_weight || out.weight || 0,
        total_weight: out.total_weight || out.weight || 0,
        weight: out.total_weight || out.weight || 0,
        inward_id: inwId,
      }];
    }
    return [];
  }

  const anyHasInwardId = rawItems.some(
    (item: any) => item.inward_id !== undefined && item.inward_id !== null && item.inward_id !== ""
  );

  if (anyHasInwardId) {
    return rawItems.filter((item: any) => Number(item.inward_id) === inwId);
  } else {
    const outHeaderInwardId = Number(out.inward_id);
    let headerMatch = outHeaderInwardId === inwId;
    if (!headerMatch) {
      const outInwardIds: number[] = (() => {
        if (Array.isArray(out.inward_ids)) return out.inward_ids.map(Number);
        if (typeof out.inward_ids === "string") {
          try { return (JSON.parse(out.inward_ids) as any[]).map(Number); } catch {}
        }
        return [];
      })();
      headerMatch = outInwardIds.includes(inwId);
    }
    return headerMatch ? rawItems : [];
  }
};

export default function LabourBillPage() {

  const { activeFY } = useAuthStore();

  const qc = useQueryClient();

  const [open, setOpen] = useState(false);

  const [editing, setEditing] = useState<any>(null);



  // Search input states



  const { data: bills = [], isLoading, refetch } = useQuery({

    queryKey: ["labour-bills", activeFY],

    queryFn: async () => (await api.get(`/labour-bills/?fy=${activeFY}`)).data,

  });



  const { data: ledgers = [] } = useQuery({

    queryKey: ["ledgers", "Account"],

    queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data,

  });

  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });

  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });

  const { data: companyData } = useQuery({ queryKey: ["company"], queryFn: async () => (await api.get("/company/")).data });
  const { data: outwardVouchers = [] } = useQuery<any>({
    queryKey: ["outward-vouchers"],
    queryFn: async () => (await api.get(`/stock/outward?fy=${activeFY}`)).data
  });
  const { data: inwardVouchers = [] } = useQuery<any>({
    queryKey: ["inward-vouchers-list", activeFY],
    queryFn: async () => (await api.get(`/stock/inward/pending-outward?fy=${activeFY}`)).data
  });



  const ledgerMap = useMemo(() => {

    const map: Record<number, string> = {};

    ledgers.forEach((l: any) => map[l.id] = l.name);

    return map;

  }, [ledgers]);



  const ledgerMapObj = useMemo(() => {

    const map: Record<number | string, any> = {};

    ledgers.forEach((l: any) => { map[l.id] = l; });

    return map;

  }, [ledgers]);



  const productMapObj = useMemo(() => {

    const map: Record<number | string, any> = {};

    products.forEach((p: any) => { map[p.id] = p; });

    return map;

  }, [products]);



  const processMapObj = useMemo(() => {

    const map: Record<number | string, any> = {};

    processes.forEach((p: any) => { map[p.id] = p; });

    return map;

  }, [processes]);



  const today = new Date().toISOString().split("T")[0];



  const markPaidMutation = useMutation({

    mutationFn: (id: number) => api.patch(`/labour-bills/${id}/mark-paid?fy=${activeFY}&payment_date=${today}`),

    onSuccess: () => qc.invalidateQueries({ queryKey: ["labour-bills"] }),

  });



  const deleteMutation = useMutation({

    mutationFn: (id: number) => api.delete(`/labour-bills/${id}?fy=${activeFY}`),

    onSuccess: () => qc.invalidateQueries({ queryKey: ["labour-bills"] }),

  });



  const handleOpen = (row?: any) => {

    setEditing(row || null);

    setOpen(true);

  };



  const handlePrintLabourBill = (row: any) => {

    const printWindow = window.open("", "_blank");

    if (!printWindow) return;



    // Load custom configuration

    const savedConfig = localStorage.getItem("orbx_print_config");

    let printConfig = {

      showLogo: true,

      billPaperSize: "A4",

      billTitle: "Labour Bill Invoice",

      billTerms: "1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.",

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



    // Company details

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;

    const cName = compData?.name || "SRI METAL";

    const cAddress1 = compData?.address || "";

    const cAddress2 = "";

    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");

    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";

    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";

    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";



    const dateStr = new Date(row.bill_date).toLocaleDateString("en-IN", {

      day: "2-digit",

      month: "2-digit",

      year: "numeric"

    }).replace(/\//g, "-");



    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);

    const supplierName = supplierLedger?.name || `Supplier #${row.ledger_id}`;
    const supplierAddr1 = supplierLedger?.address || [supplierLedger?.address_line1, supplierLedger?.address_line2].filter(Boolean).join(", ") || "";
    const supplierCityStatePin = [supplierLedger?.city, supplierLedger?.state, supplierLedger?.pincode].filter(Boolean).join(" - ");
    const supplierPhone = supplierLedger?.phone || supplierLedger?.mobile ? `Tel: ${[supplierLedger?.phone, supplierLedger?.mobile].filter(Boolean).join(" / ")}` : "";
    const supplierGstin = supplierLedger?.gstin || "";

    const outwardIds = Array.isArray(row.outward_ids)
      ? row.outward_ids
      : (typeof row.outward_ids === "string"
        ? (() => { try { return JSON.parse(row.outward_ids); } catch { return []; } })()
        : []);
    
    const linkedOutwards = (outwardIds || []).map((id: number) => {
      return outwardVouchers.find((v: any) => v.id === id);
    }).filter(Boolean);

    // Resolve all linked inward vouchers for these outward vouchers
    const resolvedInwardRefs = new Set<string>();
    linkedOutwards.forEach((out: any) => {
      const outInwardIds = out.inward_ids 
        ? (Array.isArray(out.inward_ids) ? out.inward_ids : (typeof out.inward_ids === 'string' ? (() => { try { return JSON.parse(out.inward_ids); } catch { return []; } })() : []))
        : (out.inward_id ? [out.inward_id] : []);
        
      (outInwardIds || []).forEach((inwId: number) => {
        const inv = inwardVouchers.find((v: any) => v.id === inwId);
        if (inv) {
          const ref = inv.ref_no || inv.serial_no || inv.inward_no;
          if (ref) resolvedInwardRefs.add(ref);
        }
      });
      // Fallback to outward's own ref_no if no inwards matched
      if (out.ref_no) resolvedInwardRefs.add(out.ref_no);
    });

    const supplierRefs = Array.from(resolvedInwardRefs).join(", ") || "-";

    const productName = products.find((p: any) => p.id === row.product_id)?.name || `Product #${row.product_id}`;
    const processName = resolveProcessName(row.process_id, processes) || "-";
    const formattedTerms = printConfig.billTerms ? printConfig.billTerms.replace(/\n/g, "<br/>") : "";

    let freightArray: any[] = [];
    if (typeof row.freight_items === "string") {
      try { freightArray = JSON.parse(row.freight_items); } catch (e) {}
    } else if (Array.isArray(row.freight_items)) {
      freightArray = row.freight_items;
    }
    if (!Array.isArray(freightArray)) freightArray = [];
    const freightAmount = freightArray.reduce((sum: number, f: any) => sum + (Number(f.amount) || 0), 0);
    const taxableBasePrint = Number(row.amount || 0) + freightAmount;

    const gstP = Number(row.gst_percent || 0);
    const cgstP = Number(row.cgst_percent !== undefined && row.cgst_percent !== null ? row.cgst_percent : (gstP / 2));
    const sgstP = Number(row.sgst_percent !== undefined && row.sgst_percent !== null ? row.sgst_percent : (gstP / 2));
    const cgstAmt = row.cgst_amount !== undefined && row.cgst_amount !== null ? Number(row.cgst_amount) : Number(((taxableBasePrint * cgstP) / 100).toFixed(2));
    const sgstAmt = row.sgst_amount !== undefined && row.sgst_amount !== null ? Number(row.sgst_amount) : Number(((taxableBasePrint * sgstP) / 100).toFixed(2));
    const roundOffVal = Number(row.round_off || 0);
    const netPayableVal = Number(row.net_amount || row.total_amount || 0);
    const amountInWordsStr = toWords(netPayableVal);

    let itemsArray: any[] = [];
    if (typeof row.items === "string") {
      try { itemsArray = JSON.parse(row.items); } catch (e) {}
    } else if (Array.isArray(row.items)) {
      itemsArray = row.items;
    }
    if (!itemsArray || itemsArray.length === 0) {
      itemsArray = [{ product_id: row.product_id, process_id: row.process_id, quantity: row.quantity || 0, rate: row.rate || 0, amount: row.amount || 0 }];
    }

    let itemsHtml = "";
    itemsArray.forEach((item, idx) => {
      const prName = resolveProcessName(item.process_id, processes) || (row.process_id ? processName : "-");
      const pObj = products.find((p: any) => p.id === Number(item.product_id));
      const uomStr = item.uom || pObj?.uom || "KG";
      itemsHtml += `
        <tr>
          <td style="text-align: center;">${idx + 1}</td>
          <td style="font-weight: 600;">${prName}</td>
          <td style="text-align: right;">${formatWeight(item.quantity)}</td>
          <td style="text-align: center;">${uomStr}</td>
          <td style="text-align: right;">₹${formatAmount(item.rate)}</td>
          <td style="text-align: right; font-weight: 600;">₹${formatAmount(item.amount)}</td>
        </tr>
      `;
    });

    let freightHtml = "";
    if (freightArray.length > 0) {
      const freightRows = freightArray.map((f) => {
        const prName = resolveProcessName(f.process_id, processes) || "-";
        return `
          <tr>
            <td style="width: 50px; text-align: center;"></td>
            <td style="font-weight: 600; color: #0f5132;">${prName}</td>
            <td style="text-align: right; width: 110px;">${formatWeight(f.quantity)}</td>
            <td style="text-align: center; width: 80px;">KG</td>
            <td style="text-align: right; width: 100px;">₹${formatAmount(f.rate)}</td>
            <td style="text-align: right; width: 120px; font-weight: 700;">₹${formatAmount(f.amount)}</td>
          </tr>
        `;
      }).join("");
      freightHtml = `
        <table class="items-table">
          <tbody>
            ${freightRows}
          </tbody>
        </table>
      `;
    }

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Print Labour Bill - ${row.bill_no}</title>
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
              ${cAddress2 ? `<p>${cAddress2}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">GSTIN: ${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section">
            <h2>LABOUR BILL</h2>
            <div class="doc-no">Bill No: ${row.bill_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
            ${supplierRefs && supplierRefs !== "-" ? `<div class="doc-date">Supplier Ref: ${supplierRefs}</div>` : ""}
          </div>
          <div class="address-section">
            <div class="address-column" style="width: 100%;">
              <h3>SUPPLIER DETAILS:</h3>
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
                <th style="width: 50px; text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">S.NO</th>
                <th style="background-color: #0f5132 !important; color: #ffffff !important;">PROCESS</th>
                <th style="text-align: right; width: 110px; background-color: #0f5132 !important; color: #ffffff !important;">WEIGHT (KG)</th>
                <th style="text-align: center; width: 80px; background-color: #0f5132 !important; color: #ffffff !important;">UOM</th>
                <th style="text-align: right; width: 100px; background-color: #0f5132 !important; color: #ffffff !important;">RATE</th>
                <th style="text-align: right; width: 120px; background-color: #0f5132 !important; color: #ffffff !important;">SUBTOTAL</th>
              </tr>
            </thead>
            <tbody>
              ${itemsHtml}
            </tbody>
          </table>
          ${freightHtml}
          <div class="totals-section">
            <div class="calculation-box">
              <div class="calculation-row">
                <span>Taxable Subtotal:</span>
                <span>₹${formatAmount(row.amount)}</span>
              </div>
              <div class="calculation-row">
                <span>CGST (${cgstP}%):</span>
                <span>₹${formatAmount(cgstAmt)}</span>
              </div>
              <div class="calculation-row">
                <span>SGST (${sgstP}%):</span>
                <span>₹${formatAmount(sgstAmt)}</span>
              </div>
              ${roundOffVal !== 0 ? `
                <div class="calculation-row">
                  <span>Round Off:</span>
                  <span>${roundOffVal > 0 ? "+" : ""}₹${formatAmount(roundOffVal)}</span>
                </div>
              ` : ""}
              <div class="calculation-row grand-total">
                <span>Net Payable Amount:</span>
                <span>₹${formatAmount(netPayableVal)}</span>
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
                <div class="signature-label">Supplier Signature</div>
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

  const handlePrintLabourWorkDetails = (row: any) => {

    const printWindow = window.open("", "_blank");

    if (!printWindow) return;



    // Load custom configuration

    const savedConfig = localStorage.getItem("orbx_print_config");

    let printConfig = {

      showLogo: true,

      billPaperSize: "A4",

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



    // Company details

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;

    const cName = compData?.name || "SRI METAL";

    const cAddress1 = compData?.address || "";

    const cAddress2 = "";

    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");

    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";

    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";

    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";



    const dateStr = new Date(row.bill_date).toLocaleDateString("en-IN", {

      day: "2-digit",

      month: "2-digit",

      year: "numeric"

    }).replace(/\//g, "-");



    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);

    const supplierName = supplierLedger?.name || `Supplier #${row.ledger_id}`;

    const supplierAddr1 = supplierLedger?.address || [supplierLedger?.address_line1, supplierLedger?.address_line2].filter(Boolean).join(", ") || "";

    const supplierCityStatePin = [supplierLedger?.city, supplierLedger?.state, supplierLedger?.pincode].filter(Boolean).join(" - ");

    const supplierPhone = supplierLedger?.phone || supplierLedger?.mobile ? `Tel: ${[supplierLedger?.phone, supplierLedger?.mobile].filter(Boolean).join(" / ")}` : "";

    const supplierGstin = supplierLedger?.gstin || "";



    const parseJsonArray = (x: any): any[] => {

      if (typeof x === "string") {

        try { return JSON.parse(x); } catch (e) { return []; }

      }

      return Array.isArray(x) ? x : [];

    };



    const toDateStr = (val: any): string => {

      if (!val) return "-";

      try {

        return new Date(val).toLocaleDateString("en-IN", {

          day: "2-digit",

          month: "2-digit",

          year: "numeric"

        }).replace(/\//g, "-");

      } catch (e) { return "-"; }

    };



    const storedOutwardIds = parseJsonArray(row.outward_ids).map(Number);

    // Resolve linked outward vouchers:
    // If bill has explicitly stored outward_ids, use ONLY those outward vouchers.
    // Otherwise fallback to outwards matching row.inward_ids or row.inward_id.
    const linkedOutwards: any[] = (() => {
      if (storedOutwardIds.length > 0) {
        return outwardVouchers.filter((out: any) => storedOutwardIds.includes(out.id));
      }
      const billInwardIds = parseJsonArray(row.inward_ids).map(Number);
      if (billInwardIds.length === 0 && row.inward_id) {
        billInwardIds.push(Number(row.inward_id));
      }
      const inwSet = new Set<number>(billInwardIds);
      if (inwSet.size > 0) {
        return outwardVouchers.filter((out: any) => {
          const outInwardIds = out.inward_ids
            ? parseJsonArray(out.inward_ids).map(Number)
            : (out.inward_id !== undefined && out.inward_id !== null ? [Number(out.inward_id)] : []);
          return outInwardIds.some((id: number) => inwSet.has(id));
        });
      }
      return [];
    })();

    // Gather ALL inward IDs referenced by the bill or its linked outwards
    const billInwardIdSet = new Set<number>();
    parseJsonArray(row.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
    if (row.inward_id) billInwardIdSet.add(Number(row.inward_id));

    linkedOutwards.forEach((out: any) => {
      if (out.inward_id) billInwardIdSet.add(Number(out.inward_id));
      parseJsonArray(out.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
      parseJsonArray(out.items).forEach((item: any) => {
        if (item.inward_id) billInwardIdSet.add(Number(item.inward_id));
      });
    });

    const billAllInwardIds: number[] = Array.from(billInwardIdSet);

    // Step 3: Resolve linked inward vouchers: from billAllInwardIds, checking inwardVouchers
    const linkedInwards = billAllInwardIds
      .map((id: number) => inwardVouchers.find((v: any) => v.id === id))
      .filter(Boolean);



    // Build combined rows: one line per outward item with linked inward columns on the same row

    const resolveSeparateProcesses = (procId: any): string => {

      if (!procId) return "-";

      const proc = processes.find((p: any) => p.id === Number(procId));

      if (proc && proc.process_ids) {

        const pids = String(proc.process_ids).split(",").map((x: string) => x.trim()).filter(Boolean);

        const names = pids

          .map((pid: string) => processes.find((p: any) => p.id === Number(pid))?.name || pid)

          .filter(Boolean);

        return names.join(" / ") || "-";

      }

      return resolveProcessName(procId, processes) || "-";

    };



    const collectInwardLines = (invList: any[], prodId: number): any[] => {

      const lines: any[] = [];

      invList.forEach((inv: any) => {

        const invItems = parseJsonArray(inv.items);

        if (invItems.length === 0) {

          if (inv.product_id && Number(inv.product_id) === prodId) {

            lines.push({ quantity: inv.quantity || 0, weight: inv.total_weight || inv.weight || 0 });

          }

        } else {

          invItems.forEach((i: any) => {

            if (Number(i.product_id) === prodId) {

              lines.push({ quantity: i.quantity || 0, weight: i.total_weight || i.weight || 0 });

            }

          });

        }

      });

      return lines;

    };



    const billItems = (() => {
      let parsed: any[] = [];
      if (typeof row.items === "string") {
        try { parsed = JSON.parse(row.items); } catch (e) {}
      } else if (Array.isArray(row.items)) {
        parsed = row.items;
      }
      return parsed;
    })();

    const uniqueActiveProcesses: any[] = [];
    const seenProcIds = new Set<number>();
    billItems.forEach((item: any) => {
      if (item.process_id) {
        const proc = processes.find((p: any) => p.id === Number(item.process_id));
        if (proc && !seenProcIds.has(proc.id)) {
          seenProcIds.add(proc.id);
          uniqueActiveProcesses.push(proc);
        }
      }
    });

    if (uniqueActiveProcesses.length === 0 && row.process_id) {
      const proc = processes.find((p: any) => p.id === Number(row.process_id));
      if (proc) {
        uniqueActiveProcesses.push(proc);
      }
    }

    const isProcessInRow = (targetProcId: number, rowProcId: any): boolean => {
      if (!rowProcId) return false;
      if (Number(rowProcId) === targetProcId) return true;
      const rowProc = processes.find((p: any) => p.id === Number(rowProcId));
      if (rowProc) {
        if (rowProc.process_ids) {
          const childIds = String(rowProc.process_ids).split(",").map((x: string) => Number(x.trim())).filter(Boolean);
          if (childIds.includes(targetProcId)) return true;
        }
        if (rowProc.process_code && rowProc.process_code.includes(" / ")) {
          const parts = rowProc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          const targetProc = processes.find((p: any) => p.id === targetProcId);
          if (targetProc && parts.includes(targetProc.process_code)) return true;
        }
      }
      const targetProc = processes.find((p: any) => p.id === Number(targetProcId));
      if (targetProc) {
        if (targetProc.process_ids) {
          const childIds = String(targetProc.process_ids).split(",").map((x: string) => Number(x.trim())).filter(Boolean);
          if (childIds.includes(Number(rowProcId))) return true;
        }
        if (targetProc.process_code && targetProc.process_code.includes(" / ")) {
          const parts = targetProc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          if (rowProc && parts.includes(rowProc.process_code)) return true;
        }
      }
      return false;
    };

    const reportRows: any[] = [];

    // Use billAllInwardIds declared above for item-level filtering
    const billInwardIds = billAllInwardIds;

    linkedOutwards.forEach((out: any) => {

      // Resolve inwards for this outward — search linkedInwards first (covers completed), then inwardVouchers
      const linkedInvForOut = (() => {
        const ids = out.inward_ids
          ? parseJsonArray(out.inward_ids)
          : (out.inward_id !== undefined && out.inward_id !== null ? [out.inward_id] : []);
        return ids.map((id: number | string) => {
          const numId = Number(id);
          return linkedInwards.find((v: any) => v.id === numId) || inwardVouchers.find((v: any) => v.id === numId);
        }).filter(Boolean);
      })();

      // Get ALL items for this outward, filtered to only inwards that belong to this bill
      const rawOutItems = parseJsonArray(out.items);
      let outItems: any[];
      if (rawOutItems.length > 0) {
        const anyHasInwardId = rawOutItems.some(
          (i: any) => i.inward_id !== undefined && i.inward_id !== null && i.inward_id !== ""
        );
        if (anyHasInwardId && billInwardIds.length > 0) {
          outItems = rawOutItems.filter((i: any) => billInwardIds.includes(Number(i.inward_id)));
        } else {
          outItems = rawOutItems;
        }
      } else {
        outItems = [];
      }

      const pushReportRow = (item: any, outInv: any[]) => {

        const itemProcId = item.process_id || out.process_id;
        if (uniqueActiveProcesses.length > 0) {
          const matchesAnyActive = uniqueActiveProcesses.some((proc: any) => isProcessInRow(proc.id, itemProcId));
          if (!matchesAnyActive) return;
        }

        // Narrow to the specific inward for this item if it has an item-level inward_id
        let itemInvList = outInv;
        if (item.inward_id) {
          const specificInv = linkedInwards.find((v: any) => v.id === Number(item.inward_id))
            || inwardVouchers.find((v: any) => v.id === Number(item.inward_id));
          if (specificInv) itemInvList = [specificInv];
        }

        const prodId = Number(item.product_id);

        const invLines = collectInwardLines(itemInvList, prodId);

        const invQty = invLines.reduce((sum, l) => sum + (Number(l.quantity) || 0), 0);

        const invWeight = invLines.reduce((sum, l) => sum + (Number(l.weight) || 0), 0);

        reportRows.push({

          ref: itemInvList.map((v: any) => v.ref_no || v.serial_no).filter(Boolean).join(", ") || "-",

          inward_date: itemInvList.map((v: any) => toDateStr(v.inward_date)).filter((d: string) => d !== "-").join(", ") || "-",

          productName: products.find((p: any) => p.id === prodId)?.name || `Product #${item.product_id}`,

          inward_qty: invLines.length > 0 ? invQty : null,

          inward_weight: invLines.length > 0 ? invWeight : null,

          outward_no: out.outward_no,

          outward_date: out.outward_date,

          outward_qty: item.quantity || 0,

          outward_weight: item.total_weight || item.weight || 0,

          processName: resolveSeparateProcesses(item.process_id || out.process_id),

          processId: item.process_id || out.process_id,

        });

      };

      if (outItems.length === 0) {

        pushReportRow(out, linkedInvForOut);

      } else {

        outItems.forEach((item: any) => {

          const prodId = Number(item.product_id);

          const productMatched = linkedInvForOut.filter((inv: any) => {

            if (inv.product_id && Number(inv.product_id) === prodId) return true;

            const invItems = parseJsonArray(inv.items);

            return invItems.some((i: any) => Number(i.product_id) === prodId);

          });

          pushReportRow(item, productMatched.length > 0 ? productMatched : linkedInvForOut);

        });

      }

    });



    // Fallback: bill with inwards but no linked outwards

    if (reportRows.length === 0 && linkedOutwards.length === 0 && linkedInwards.length > 0) {

      linkedInwards.forEach((inv: any) => {

        const invItems = parseJsonArray(inv.items);

        const invRef = inv.ref_no || inv.serial_no || "-";

        const pushInvRow = (item: any) => {

          reportRows.push({

            ref: invRef,

            inward_date: toDateStr(inv.inward_date),

            productName: products.find((p: any) => p.id === Number(item.product_id))?.name || `Product #${item.product_id}`,

            inward_qty: item.quantity || 0,

            inward_weight: item.total_weight || item.weight || 0,

            outward_no: "-",

            outward_date: "-",

            outward_qty: null,

            outward_weight: null,

            processName: "-",

            processId: null,

          });

        };

        if (invItems.length === 0) {

          pushInvRow(inv);

        } else {
      invItems.forEach((item: any) => pushInvRow(item));
        }

      });

    }



    const rawTotalOutwardWeight = reportRows.reduce((sum, r) => sum + (Number(r.outward_weight) || 0), 0);
    const billTotalWeight = Number(row.quantity) > 0 ? Number(row.quantity) : rawTotalOutwardWeight;
    const weightScaleFactor = (billTotalWeight > 0 && rawTotalOutwardWeight > 0)
      ? billTotalWeight / rawTotalOutwardWeight
      : 1;

    const scaledReportRows = reportRows.map((r) => {
      const rawOutW = Number(r.outward_weight) || 0;
      const rawInwW = Number(r.inward_weight) || 0;
      const rawOutQ = Number(r.outward_qty) || 0;
      const rawInwQ = Number(r.inward_qty) || 0;

      return {
        ...r,
        outward_weight: rawOutW > 0 ? rawOutW * weightScaleFactor : r.outward_weight,
        inward_weight: rawInwW > 0 ? rawInwW * weightScaleFactor : r.inward_weight,
        outward_qty: rawOutQ > 0 ? Math.max(1, Math.round(rawOutQ * weightScaleFactor)) : r.outward_qty,
        inward_qty: rawInwQ > 0 ? Math.max(1, Math.round(rawInwQ * weightScaleFactor)) : r.inward_qty,
        raw_outward_weight: rawOutW,
      };
    });

    const totalInwardQty = scaledReportRows.reduce((sum, r) => sum + (Number(r.inward_qty) || 0), 0);
    const totalInwardWeight = scaledReportRows.reduce((sum, r) => sum + (Number(r.inward_weight) || 0), 0);
    const totalOutwardQty = scaledReportRows.reduce((sum, r) => sum + (Number(r.outward_qty) || 0), 0);
    const totalOutwardWeight = billTotalWeight;

    const fmtCell = (v: any, fmt: (x: any) => string): string =>
      v === null || v === undefined || v === "" || v === "-" ? "-" : fmt(v);

    const fmtWeightCell = (v: any): string => {
      const s = fmtCell(v, formatWeight);
      return s === "-" ? "-" : `${s} kg`;
    };

    const processTotals: Record<number, number> = {};
    uniqueActiveProcesses.forEach(proc => {
      processTotals[proc.id] = reportRows.reduce((sum, r) => {
        if (isProcessInRow(proc.id, r.processId)) {
          return sum + (Number(r.outward_weight) || 0);
        }
        return sum;
      }, 0);
    });

    let reportRowsHtml = "";

    if (scaledReportRows.length === 0) {
      const totalColSpan = 9 + (uniqueActiveProcesses.length || 1);
      reportRowsHtml = `<tr><td colspan="${totalColSpan}" style="text-align: center; padding: 12px;">No linked inward / outward vouchers</td></tr>`;
    } else {
      scaledReportRows.forEach((r) => {
        let processColsHtml = "";
        if (uniqueActiveProcesses.length === 0) {
          processColsHtml += `<td style="text-align: center; color: #a0aec0;">-</td>`;
        } else {
          uniqueActiveProcesses.forEach((proc, pIdx) => {
            const matches = isProcessInRow(proc.id, r.processId);
            const isLast = pIdx === uniqueActiveProcesses.length - 1;
            const borderStyle = isLast ? "" : "border-right: 1px solid #198754 !important;";
            
            if (matches) {
              const rawTotal = processTotals[proc.id] || 0;
              const billItem = billItems.find((it: any) => Number(it.process_id) === proc.id);
              const billedQty = billItem && Number(billItem.quantity) > 0 ? Number(billItem.quantity) : 0;
              const cellWeight = (billedQty > 0 && rawTotal > 0)
                ? (r.raw_outward_weight / rawTotal) * billedQty
                : Number(r.outward_weight) || 0;

              processColsHtml += `<td style="text-align: right; font-weight: 500; ${borderStyle}">${fmtWeightCell(cellWeight)}</td>`;
            } else {
              processColsHtml += `<td style="text-align: center; color: #a0aec0; ${borderStyle}">-</td>`;
            }
          });
        }

        reportRowsHtml += `
          <tr>
            <td style="font-weight: 600; white-space: nowrap;">${r.ref}</td>
            <td style="white-space: nowrap;">${r.inward_date}</td>
            <td style="font-weight: 600;">${r.productName}</td>
            <td style="text-align: right; white-space: nowrap;">${fmtCell(r.inward_qty, formatQty)}</td>
            <td style="text-align: right; font-weight: 600; white-space: nowrap; border-right: 2px solid #0f5132 !important;">${fmtWeightCell(r.inward_weight)}</td>
            <td style="font-weight: 600; white-space: nowrap;">${r.outward_no}</td>
            <td style="white-space: nowrap;">${r.outward_date}</td>
            <td style="text-align: right; white-space: nowrap;">${fmtCell(r.outward_qty, formatQty)}</td>
            <td style="text-align: right; font-weight: 600; white-space: nowrap; border-right: 2px solid #0f5132 !important;">${fmtWeightCell(r.outward_weight)}</td>
            ${processColsHtml}
          </tr>`;
      });

      let processTotalsHtml = "";
      if (uniqueActiveProcesses.length === 0) {
        processTotalsHtml += `<td style="text-align: center; color: #0f5132; font-weight: 700;">-</td>`;
      } else {
      uniqueActiveProcesses.forEach((proc, idx) => {
        const isLast = idx === uniqueActiveProcesses.length - 1;
        const borderStyle = isLast ? "" : "border-right: 1px solid #198754 !important;";
        const billItem = billItems.find((it: any) => Number(it.process_id) === proc.id);
        const finalVal = billItem && Number(billItem.quantity) > 0 ? Number(billItem.quantity) : (processTotals[proc.id] * weightScaleFactor);
        processTotalsHtml += `
          <td style="text-align: right; font-weight: 700; color: #0f5132; ${borderStyle}">
            ${formatWeight(finalVal)} kg
          </td>
        `;
      });
      }

      reportRowsHtml += `
          <tr class="total-row">
            <td colspan="3" style="text-align: right; font-weight: 700; color: #0f5132;">Total</td>
            <td style="text-align: right; font-weight: 700; color: #0f5132;">${formatQty(totalInwardQty)}</td>
            <td style="text-align: right; font-weight: 700; color: #0f5132; border-right: 2px solid #0f5132 !important;">${formatWeight(totalInwardWeight)} kg</td>
            <td></td>
            <td></td>
            <td style="text-align: right; font-weight: 700; color: #0f5132;">${formatQty(totalOutwardQty)}</td>
            <td style="text-align: right; font-weight: 700; color: #0f5132; border-right: 2px solid #0f5132 !important;">${formatWeight(totalOutwardWeight)} kg</td>
            ${processTotalsHtml}
          </tr>`;
    }

    const processingColSpan = uniqueActiveProcesses.length || 1;
    const superHeaderHtml = `
      <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
        <th colspan="5" style="text-align: center; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">Inward Details</th>
        <th colspan="4" style="text-align: center; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">Outward details</th>
        <th colspan="${processingColSpan}" style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">Processing</th>
      </tr>
    `;

    let subHeaderHtml = `
      <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
        <th style="background-color: #0f5132 !important; color: #ffffff !important;">inward ref no</th>
        <th style="background-color: #0f5132 !important; color: #ffffff !important;">Date</th>
        <th style="background-color: #0f5132 !important; color: #ffffff !important;">Product</th>
        <th style="text-align: right; width: 60px; background-color: #0f5132 !important; color: #ffffff !important;">Qty</th>
        <th style="text-align: right; width: 90px; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">Weight</th>
        <th style="background-color: #0f5132 !important; color: #ffffff !important;">Outward No</th>
        <th style="background-color: #0f5132 !important; color: #ffffff !important;">Date</th>
        <th style="text-align: right; width: 60px; background-color: #0f5132 !important; color: #ffffff !important;">Qty</th>
        <th style="text-align: right; width: 90px; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">Weight</th>
    `;

    if (uniqueActiveProcesses.length === 0) {
      subHeaderHtml += `<th style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">Process Weight</th>`;
    } else {
      uniqueActiveProcesses.forEach((proc, idx) => {
        const isLast = idx === uniqueActiveProcesses.length - 1;
        const borderStyle = isLast ? "" : "border-right: 1px solid rgba(255,255,255,0.3) !important;";
        subHeaderHtml += `
          <th style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important; ${borderStyle}">
            <div style="font-size: 0.75rem; margin-bottom: 2px; text-transform: uppercase;">${proc.name}</div>
            <div style="font-size: 0.65rem; font-weight: normal; opacity: 0.85;">weight</div>
          </th>
        `;
      });
    }
    subHeaderHtml += `</tr>`;

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Print Work Details - ${row.bill_no}</title>
          <style>
            @page { size: A4 landscape; margin: 10mm; }
            ${COMMON_PRINT_CSS}
            /* Custom Table Borders overriding COMMON_PRINT_CSS to match the image grid */
            table.items-table { border-collapse: collapse; width: 100%; border: 1.5px solid #0f5132 !important; }
            table.items-table th, table.items-table td { border: 1px solid #198754 !important; padding: 6px 8px !important; }
            table.items-table thead tr { border: 1px solid #198754 !important; }
            table.items-table tr { border: 1px solid #198754 !important; }
          </style>
        </head>
        <body>
          <div class="header-container">
            <div class="logo-wrapper">${logoHtml}</div>
            <div class="company-details">
              <h1>${cName}</h1>
              ${cAddress1 ? `<p>${cAddress1}</p>` : ""}
              ${cAddress2 ? `<p>${cAddress2}</p>` : ""}
              ${cCityStatePin ? `<p>${cCityStatePin}</p>` : ""}
              <p>${[cPhone, cEmail].filter(Boolean).join(" | ")}</p>
              ${cTax ? `<p class="gstin">GSTIN: ${cTax}</p>` : ""}
            </div>
          </div>
          <div class="title-section">
            <h2>WORK DETAILS</h2>
            <div class="doc-no">Bill No: ${row.bill_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
          </div>
          <div class="address-section">
            <div class="address-column" style="width: 100%;">
              <h3>SUPPLIER DETAILS:</h3>
              <div class="name">${supplierName}</div>
              ${supplierAddr1 ? `<div class="address-lines">${supplierAddr1}</div>` : ""}
              ${supplierCityStatePin ? `<div class="address-lines">${supplierCityStatePin}</div>` : ""}
              ${supplierPhone ? `<div class="address-lines">${supplierPhone}</div>` : ""}
              ${supplierGstin ? `<div class="gstin">GSTIN: ${supplierGstin}</div>` : ""}
            </div>
          </div>
          <table class="items-table">
            <thead style="background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
              ${superHeaderHtml}
              ${subHeaderHtml}
            </thead>
            <tbody>
              ${reportRowsHtml}
            </tbody>
          </table>

          <div class="signatures-container">

            <div class="signature-block">

              <div class="signature-line"></div>

              <div class="signature-label">Prepared By</div>

            </div>

            <div class="signature-block">

              <div class="signature-line"></div>

              <div class="signature-label">Authorized Signatory for ${cName}</div>

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

  const handleExportLabourWorkDetailsExcel = (row: any) => {
    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "SRI METAL";
    const cAddress = [compData?.address, compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(", ");
    const cGstin = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = row.bill_date
      ? new Date(row.bill_date).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-")
      : "";
    const supplierLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const supplierName = supplierLedger?.name || `Supplier #${row.ledger_id}`;
    const supplierGstin = supplierLedger?.gstin ? `GSTIN: ${supplierLedger.gstin}` : "";

    const parseJsonArray = (x: any): any[] => {
      if (typeof x === "string") {
        try { return JSON.parse(x); } catch (e) { return []; }
      }
      return Array.isArray(x) ? x : [];
    };

    const toDateStr = (val: any): string => {
      if (!val) return "-";
      try {
        return new Date(val).toLocaleDateString("en-IN", { day: "2-digit", month: "2-digit", year: "numeric" }).replace(/\//g, "-");
      } catch (e) { return "-"; }
    };

    const storedOutwardIds = parseJsonArray(row.outward_ids).map(Number);

    // Resolve linked outward vouchers:
    // If bill has explicitly stored outward_ids, use ONLY those outward vouchers.
    // Otherwise fallback to outwards matching row.inward_ids or row.inward_id.
    const linkedOutwards: any[] = (() => {
      if (storedOutwardIds.length > 0) {
        return outwardVouchers.filter((out: any) => storedOutwardIds.includes(out.id));
      }
      const billInwardIds = parseJsonArray(row.inward_ids).map(Number);
      if (billInwardIds.length === 0 && row.inward_id) {
        billInwardIds.push(Number(row.inward_id));
      }
      const inwSet = new Set<number>(billInwardIds);
      if (inwSet.size > 0) {
        return outwardVouchers.filter((out: any) => {
          const outInwardIds = out.inward_ids
            ? parseJsonArray(out.inward_ids).map(Number)
            : (out.inward_id !== undefined && out.inward_id !== null ? [Number(out.inward_id)] : []);
          return outInwardIds.some((id: number) => inwSet.has(id));
        });
      }
      return [];
    })();

    // Gather ALL inward IDs referenced by the bill or its linked outwards
    const billInwardIdSet = new Set<number>();
    parseJsonArray(row.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
    if (row.inward_id) billInwardIdSet.add(Number(row.inward_id));

    linkedOutwards.forEach((out: any) => {
      if (out.inward_id) billInwardIdSet.add(Number(out.inward_id));
      parseJsonArray(out.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
      parseJsonArray(out.items).forEach((item: any) => {
        if (item.inward_id) billInwardIdSet.add(Number(item.inward_id));
      });
    });

    const billAllInwardIds: number[] = Array.from(billInwardIdSet);

    // Step 3: Resolve linked inward vouchers: from billAllInwardIds, checking inwardVouchers
    const linkedInwards = billAllInwardIds
      .map((id: number) => inwardVouchers.find((v: any) => v.id === id))
      .filter(Boolean);

    const resolveSeparateProcesses = (procId: any): string => {
      if (!procId) return "-";
      const proc = processes.find((p: any) => p.id === Number(procId));
      if (proc && proc.process_ids) {
        const pids = String(proc.process_ids).split(",").map((x: string) => x.trim()).filter(Boolean);
        const names = pids
          .map((pid: string) => processes.find((p: any) => p.id === Number(pid))?.name || pid)
          .filter(Boolean);
        return names.join(" / ") || "-";
      }
      return resolveProcessName(procId, processes) || "-";
    };

    const collectInwardLines = (invList: any[], prodId: number): any[] => {
      const lines: any[] = [];
      invList.forEach((inv: any) => {
        const invItems = parseJsonArray(inv.items);
        if (invItems.length === 0) {
          if (inv.product_id && Number(inv.product_id) === prodId) {
            lines.push({ quantity: inv.quantity || 0, weight: inv.total_weight || inv.weight || 0 });
          }
        } else {
          invItems.forEach((i: any) => {
            if (Number(i.product_id) === prodId) {
              lines.push({ quantity: i.quantity || 0, weight: i.total_weight || i.weight || 0 });
            }
          });
        }
      });
      return lines;
    };

    const billItems = (() => {
      let parsed: any[] = [];
      if (typeof row.items === "string") {
        try { parsed = JSON.parse(row.items); } catch (e) {}
      } else if (Array.isArray(row.items)) {
        parsed = row.items;
      }
      return parsed;
    })();

    const uniqueActiveProcesses: any[] = [];
    const seenProcIds = new Set<number>();
    billItems.forEach((item: any) => {
      if (item.process_id) {
        const proc = processes.find((p: any) => p.id === Number(item.process_id));
        if (proc && !seenProcIds.has(proc.id)) {
          seenProcIds.add(proc.id);
          uniqueActiveProcesses.push(proc);
        }
      }
    });

    if (uniqueActiveProcesses.length === 0 && row.process_id) {
      const proc = processes.find((p: any) => p.id === Number(row.process_id));
      if (proc) uniqueActiveProcesses.push(proc);
    }

    const isProcessInRow = (targetProcId: number, rowProcId: any): boolean => {
      if (!rowProcId) return false;
      if (Number(rowProcId) === targetProcId) return true;
      const rowProc = processes.find((p: any) => p.id === Number(rowProcId));
      if (rowProc) {
        if (rowProc.process_ids) {
          const childIds = String(rowProc.process_ids).split(",").map((x: string) => Number(x.trim())).filter(Boolean);
          if (childIds.includes(targetProcId)) return true;
        }
        if (rowProc.process_code && rowProc.process_code.includes(" / ")) {
          const parts = rowProc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          const targetProc = processes.find((p: any) => p.id === targetProcId);
          if (targetProc && parts.includes(targetProc.process_code)) return true;
        }
      }
      const targetProc = processes.find((p: any) => p.id === Number(targetProcId));
      if (targetProc) {
        if (targetProc.process_ids) {
          const childIds = String(targetProc.process_ids).split(",").map((x: string) => Number(x.trim())).filter(Boolean);
          if (childIds.includes(Number(rowProcId))) return true;
        }
        if (targetProc.process_code && targetProc.process_code.includes(" / ")) {
          const parts = targetProc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          if (rowProc && parts.includes(rowProc.process_code)) return true;
        }
      }
      return false;
    };

    const reportRows: any[] = [];

    // Use billAllInwardIds declared above for item-level filtering
    const billInwardIds = billAllInwardIds;

    linkedOutwards.forEach((out: any) => {
      // Resolve inwards for this outward — search linkedInwards first (covers completed), then inwardVouchers
      const linkedInvForOut = (() => {
        const ids = out.inward_ids
          ? parseJsonArray(out.inward_ids)
          : (out.inward_id !== undefined && out.inward_id !== null ? [out.inward_id] : []);
        return ids.map((id: number | string) => {
          const numId = Number(id);
          return linkedInwards.find((v: any) => v.id === numId) || inwardVouchers.find((v: any) => v.id === numId);
        }).filter(Boolean);
      })();

      // Get ALL items for this outward, filtered to only inwards that belong to this bill
      const rawOutItems = parseJsonArray(out.items);
      let outItems: any[];
      if (rawOutItems.length > 0) {
        const anyHasInwardId = rawOutItems.some(
          (i: any) => i.inward_id !== undefined && i.inward_id !== null && i.inward_id !== ""
        );
        if (anyHasInwardId && billInwardIds.length > 0) {
          outItems = rawOutItems.filter((i: any) => billInwardIds.includes(Number(i.inward_id)));
        } else {
          outItems = rawOutItems;
        }
      } else {
        outItems = [];
      }

      const pushReportRow = (item: any, outInv: any[]) => {
        const itemProcId = item.process_id || out.process_id;
        if (uniqueActiveProcesses.length > 0) {
          const matchesAnyActive = uniqueActiveProcesses.some((proc: any) => isProcessInRow(proc.id, itemProcId));
          if (!matchesAnyActive) return;
        }

        // Narrow to the specific inward for this item if it has an item-level inward_id
        let itemInvList = outInv;
        if (item.inward_id) {
          const specificInv = linkedInwards.find((v: any) => v.id === Number(item.inward_id))
            || inwardVouchers.find((v: any) => v.id === Number(item.inward_id));
          if (specificInv) itemInvList = [specificInv];
        }

        const prodId = Number(item.product_id);
        const invLines = collectInwardLines(itemInvList, prodId);
        const invQty = invLines.reduce((sum, l) => sum + (Number(l.quantity) || 0), 0);
        const invWeight = invLines.reduce((sum, l) => sum + (Number(l.weight) || 0), 0);

        reportRows.push({
          ref: itemInvList.map((v: any) => v.ref_no || v.serial_no).filter(Boolean).join(", ") || "-",
          inward_date: itemInvList.map((v: any) => toDateStr(v.inward_date)).filter((d: string) => d !== "-").join(", ") || "-",
          productName: products.find((p: any) => p.id === prodId)?.name || `Product #${item.product_id}`,
          inward_qty: invLines.length > 0 ? invQty : null,
          inward_weight: invLines.length > 0 ? invWeight : null,
          outward_no: out.outward_no,
          outward_date: toDateStr(out.outward_date),
          outward_qty: item.quantity || 0,
          outward_weight: item.total_weight || item.weight || 0,
          processName: resolveSeparateProcesses(item.process_id || out.process_id),
          processId: item.process_id || out.process_id,
        });
      };

      if (outItems.length === 0) {
        pushReportRow(out, linkedInvForOut);
      } else {
        outItems.forEach((item: any) => {
          const prodId = Number(item.product_id);
          const productMatched = linkedInvForOut.filter((inv: any) => {
            if (inv.product_id && Number(inv.product_id) === prodId) return true;
            const invItems = parseJsonArray(inv.items);
            return invItems.some((i: any) => Number(i.product_id) === prodId);
          });
          pushReportRow(item, productMatched.length > 0 ? productMatched : linkedInvForOut);
        });
      }
    });

    if (reportRows.length === 0 && linkedOutwards.length === 0 && linkedInwards.length > 0) {
      linkedInwards.forEach((inv: any) => {
        const invItems = parseJsonArray(inv.items);
        const invRef = inv.ref_no || inv.serial_no || "-";
        const pushInvRow = (item: any) => {
          reportRows.push({
            ref: invRef,
            inward_date: toDateStr(inv.inward_date),
            productName: products.find((p: any) => p.id === Number(item.product_id))?.name || `Product #${item.product_id}`,
            inward_qty: item.quantity || 0,
            inward_weight: item.total_weight || item.weight || 0,
            outward_no: "-",
            outward_date: "-",
            outward_qty: null,
            outward_weight: null,
            processName: "-",
            processId: null,
          });
        };
        if (invItems.length === 0) pushInvRow(inv);
        else invItems.forEach((item: any) => pushInvRow(item));
      });
    }

    const rawTotalOutwardWeight = reportRows.reduce((sum, r) => sum + (Number(r.outward_weight) || 0), 0);
    const billTotalWeight = Number(row.quantity) > 0 ? Number(row.quantity) : rawTotalOutwardWeight;
    const weightScaleFactor = (billTotalWeight > 0 && rawTotalOutwardWeight > 0)
      ? billTotalWeight / rawTotalOutwardWeight
      : 1;

    const scaledReportRows = reportRows.map((r) => {
      const rawOutW = Number(r.outward_weight) || 0;
      const rawInwW = Number(r.inward_weight) || 0;
      const rawOutQ = Number(r.outward_qty) || 0;
      const rawInwQ = Number(r.inward_qty) || 0;

      return {
        ...r,
        outward_weight: rawOutW > 0 ? rawOutW * weightScaleFactor : r.outward_weight,
        inward_weight: rawInwW > 0 ? rawInwW * weightScaleFactor : r.inward_weight,
        outward_qty: rawOutQ > 0 ? Math.max(1, Math.round(rawOutQ * weightScaleFactor)) : r.outward_qty,
        inward_qty: rawInwQ > 0 ? Math.max(1, Math.round(rawInwQ * weightScaleFactor)) : r.inward_qty,
        raw_outward_weight: rawOutW,
      };
    });

    const totalInwardQty = scaledReportRows.reduce((sum, r) => sum + (Number(r.inward_qty) || 0), 0);
    const totalInwardWeight = scaledReportRows.reduce((sum, r) => sum + (Number(r.inward_weight) || 0), 0);
    const totalOutwardQty = scaledReportRows.reduce((sum, r) => sum + (Number(r.outward_qty) || 0), 0);
    const totalOutwardWeight = billTotalWeight;

    const processTotals: Record<number, number> = {};
    uniqueActiveProcesses.forEach((proc) => {
      processTotals[proc.id] = reportRows.reduce((sum, r) => {
        if (isProcessInRow(proc.id, r.processId)) {
          return sum + (Number(r.outward_weight) || 0);
        }
        return sum;
      }, 0);
    });

    const excelRows: any[][] = [];

    // Header info rows
    excelRows.push([cName]);
    if (cAddress) excelRows.push([cAddress]);
    if (cGstin) excelRows.push([cGstin]);
    excelRows.push([]);
    excelRows.push(["WORK DETAILS"]);
    excelRows.push([`Bill No: ${row.bill_no}`, "", `Date: ${dateStr}`]);
    excelRows.push([`Supplier: ${supplierName} ${supplierGstin ? `(${supplierGstin})` : ""}`]);
    excelRows.push([]);

    // Super Header row
    const superHeader = [
      "Inward Details", "", "", "", "",
      "Outward Details", "", "", ""
    ];
    if (uniqueActiveProcesses.length === 0) {
      superHeader.push("Processing");
    } else {
      superHeader.push("Processing");
      for (let i = 1; i < uniqueActiveProcesses.length; i++) {
        superHeader.push("");
      }
    }
    excelRows.push(superHeader);

    // Sub Header row
    const subHeader = [
      "inward ref no", "Date", "Product", "Qty", "Weight (kg)",
      "Outward No", "Date", "Qty", "Weight (kg)"
    ];
    if (uniqueActiveProcesses.length === 0) {
      subHeader.push("Process Weight (kg)");
    } else {
      uniqueActiveProcesses.forEach((proc: any) => {
        subHeader.push(`${proc.name} (kg)`);
      });
    }
    excelRows.push(subHeader);

    const toExcelNum = (val: any): number | string => {
      if (val === null || val === undefined || val === "" || val === "-") return "-";
      const num = typeof val === "number" ? val : Number(String(val).replace(/,/g, ""));
      if (isNaN(num)) return "-";
      return Number(num.toFixed(3));
    };

    // Data rows
    scaledReportRows.forEach((r) => {
      const rowData: any[] = [
        r.ref,
        r.inward_date,
        r.productName,
        toExcelNum(r.inward_qty),
        toExcelNum(r.inward_weight),
        r.outward_no,
        r.outward_date,
        toExcelNum(r.outward_qty),
        toExcelNum(r.outward_weight)
      ];

      if (uniqueActiveProcesses.length === 0) {
        rowData.push("-");
      } else {
        uniqueActiveProcesses.forEach((proc: any) => {
          if (isProcessInRow(proc.id, r.processId)) {
            const rawTotal = processTotals[proc.id] || 0;
            const billItem = billItems.find((it: any) => Number(it.process_id) === proc.id);
            const billedQty = billItem && Number(billItem.quantity) > 0 ? Number(billItem.quantity) : 0;
            const cellWeight = (billedQty > 0 && rawTotal > 0)
              ? (r.raw_outward_weight / rawTotal) * billedQty
              : Number(r.outward_weight) || 0;
            rowData.push(toExcelNum(cellWeight));
          } else {
            rowData.push("-");
          }
        });
      }
      excelRows.push(rowData);
    });

    // Total Row
    const totalRow: any[] = [
      "Total", "", "",
      toExcelNum(totalInwardQty),
      toExcelNum(totalInwardWeight),
      "", "",
      toExcelNum(totalOutwardQty),
      toExcelNum(totalOutwardWeight)
    ];
    if (uniqueActiveProcesses.length === 0) {
      totalRow.push("-");
    } else {
      uniqueActiveProcesses.forEach((proc: any) => {
        const billItem = billItems.find((it: any) => Number(it.process_id) === proc.id);
        const finalVal = billItem && Number(billItem.quantity) > 0 ? Number(billItem.quantity) : processTotals[proc.id];
        totalRow.push(toExcelNum(finalVal));
      });
    }
    excelRows.push(totalRow);

    const ws = XLSX.utils.aoa_to_sheet(excelRows);
    const colWidths = (excelRows[6] || excelRows[5])?.map((_, colIdx) => {
      let maxLen = 12;
      excelRows.forEach((r) => {
        const val = String(r[colIdx] || "");
        if (val.length > maxLen) maxLen = val.length;
      });
      return { wch: Math.min(maxLen + 2, 40) };
    });
    if (colWidths) ws["!cols"] = colWidths;

    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Work Details");
    const safeBillNo = String(row.bill_no || "Bill").replace(/[/\\?%*:|"<>]/g, "_");
    XLSX.writeFile(wb, `WorkDetails_${safeBillNo}.xlsx`);
  };

  const colDefs: ColDef[] = [
    { field: "bill_no", headerName: "Bill No.", width: 110 },
    { field: "bill_date", headerName: "Date", width: 95 },
    { field: "ledger_id", headerName: "Supplier", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { 
      field: "quantity", 
      headerName: "Weight", 
      width: 80, 
      type: "numericColumn", 
      valueGetter: (p) => getBillShotBlastingWeight(p.data, processMapObj, processes),
      valueFormatter: (p) => formatWeight(p.value) 
    },
    { field: "total_amount", headerName: "Total Amount", width: 130, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value || p.data?.net_amount)}` },
    { field: "is_paid", headerName: "Status", width: 90, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Paid" : "Pending"} color={p.value ? "success" : "warning"} /> },
    { headerName: "Actions", width: 200, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <WorkDetailsActionMenu
          row={p.data}
          onPrint={handlePrintLabourWorkDetails}
          onExportExcel={handleExportLabourWorkDetailsExcel}
        />
        <Tooltip title="Print Bill"><IconButton size="small" onClick={() => handlePrintLabourBill(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        {!p.data.is_paid && <Tooltip title="Mark Paid"><IconButton size="small" color="success" onClick={() => markPaidMutation.mutate(p.data.id)}><CheckCircle fontSize="small" /></IconButton></Tooltip>}
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => { if (window.confirm(`Delete labour bill "${p.data.bill_no}"?`)) deleteMutation.mutate(p.data.id); }}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];



  return (

    <Box>

      <PageHeader

        title="Labour Bill"

        breadcrumbs={[{ label: "Billing" }]}

      />

      <OrbxGrid

        rowData={bills}

        columnDefs={colDefs}

        loading={isLoading}

        onRefresh={refetch}

        onBulkDelete={async (rows) => {
          await Promise.all(rows.map((r) => deleteMutation.mutateAsync(r.id)));
        }}

        onAdd={() => handleOpen()}

        addLabel="New Bill"

      />



      <LabourBillDialog

        open={open}

        onClose={() => setOpen(false)}

        editing={editing}

      />

    </Box>

  );

}



interface LabourBillDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
}



function LabourBillDialog({ open, onClose, editing }: LabourBillDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [selectedInwards, setSelectedInwards] = useState<any[]>([]);
  const [lineItems, setLineItems] = useState<any[]>([
    { product_id: "", process_id: "", quantity: "", rate: "", amount: "" }
  ]);
  const [freightOpen, setFreightOpen] = useState(false);
  const [freightItem, setFreightItem] = useState<any>({ process_id: "", quantity: "", rate: "", amount: "" });

  const { data: bills = [] } = useQuery<any[]>({
    queryKey: ["labour-bills", activeFY],
    queryFn: async () => (await api.get(`/labour-bills/?fy=${activeFY}`)).data,
    enabled: open
  });
  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers", "Account"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Account")).data,
  });
  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: rates = [] } = useQuery({ queryKey: ["rates"], queryFn: async () => (await api.get("/products/rates/all")).data });
  const { data: outwardVouchers = [] } = useQuery<any>({
    queryKey: ["outward-vouchers"],
    queryFn: async () => (await api.get(`/stock/outward?fy=${activeFY}`)).data,
    enabled: open
  });
  const { data: inwardVouchers = [] } = useQuery<any>({
    queryKey: ["inward-vouchers-list", activeFY],
    queryFn: async () => (await api.get(`/stock/inward/pending-outward?fy=${activeFY}`)).data,
    enabled: open
  });

  const inwardMap = useMemo(() => {
    const map: Record<number, any> = {};
    inwardVouchers.forEach((inv: any) => {
      if (inv.id) map[inv.id] = inv;
    });
    return map;
  }, [inwardVouchers]);

  const billedOutwardIdsSet = useMemo(() => {
    const set = new Set<number>();
    bills.forEach((b: any) => {
      if (editing && b.id === editing.id) return;
      const oids = Array.isArray(b.outward_ids)
        ? b.outward_ids
        : (typeof b.outward_ids === "string"
          ? (() => { try { return JSON.parse(b.outward_ids); } catch { return []; } })()
          : []);
      (oids || []).forEach((id: number) => {
        if (id) set.add(Number(id));
      });
    });
    return set;
  }, [bills, editing]);

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const productMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    products.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [products]);

  const processMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    processes.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [processes]);

  const today = new Date().toISOString().split("T")[0];

  const { register, handleSubmit, reset, watch, setValue } = useForm({
    defaultValues: { bill_no: "", bill_date: today, ledger_id: "", gst_percent: "" as any, narration: "", dispatch_through: "" },
  });

  const selectedLedger = watch("ledger_id");

  const supplierOutwardVouchers = useMemo(() => {
    if (!selectedLedger) return [];
    return outwardVouchers.filter((v: any) => v.ledger_id === Number(selectedLedger));
  }, [outwardVouchers, selectedLedger]);

  const eligibleInwardNumbers = useMemo(() => {
    if (!selectedLedger) return [];
    const supplierInwards = inwardVouchers.filter((inv: any) => inv.ledger_id === Number(selectedLedger));

    return supplierInwards
      .map((inv: any) => {
        const linkedOutwards = supplierOutwardVouchers.filter((out: any) => getOutwardLinesForInward(out, inv.id).length > 0);
        const unbilledOutwards = linkedOutwards.filter((out: any) => !billedOutwardIdsSet.has(out.id));
        const unbilledOutwardCount = unbilledOutwards.length;
        
        const unbilledWeight = unbilledOutwards.reduce((sum: number, o: any) => {
          const lines = getOutwardLinesForInward(o, inv.id);
          const weightForInward = lines.reduce((s: number, item: any) => s + Number(item.total_weight || item.weight || 0), 0);
          return sum + weightForInward;
        }, 0);
        const outwardNos = unbilledOutwards.map((o: any) => o.outward_no || `#${o.id}`).filter(Boolean).join(", ");

        const overallBal = Number(inv.balance_qty ?? 0);
        let lineItemsAllZero = true;
        if (inv.line_items_balance) {
          try {
            const lBalArray = typeof inv.line_items_balance === "string" ? JSON.parse(inv.line_items_balance) : inv.line_items_balance;
            if (Array.isArray(lBalArray) && lBalArray.length > 0) {
              lineItemsAllZero = lBalArray.every((it: any) => Number(it.balance_qty || 0) <= 0.0001);
            }
          } catch {}
        }
        const isFullyCompleted = linkedOutwards.length > 0 && overallBal <= 0.0001 && lineItemsAllZero;

        return {
          ...inv,
          linkedOutwards,
          unbilledOutwards,
          unbilledOutwardCount,
          unbilledWeight,
          outwardNos,
          isOutwardCompleted: isFullyCompleted,
          hasUnbilledOutward: unbilledOutwardCount > 0 && unbilledWeight > 0.0001,
        };
      })
      .filter((inv: any) => inv.isOutwardCompleted && inv.hasUnbilledOutward);
  }, [inwardVouchers, selectedLedger, supplierOutwardVouchers, billedOutwardIdsSet, inwardMap]);

  // Derive selectedOutwards from selectedInwards
  const selectedOutwards = useMemo(() => {
    const all: any[] = [];
    selectedInwards.forEach((inw: any) => {
      const outs = (inw.unbilledOutwards && inw.unbilledOutwards.length > 0)
        ? inw.unbilledOutwards
        : ((inw.linkedOutwards && inw.linkedOutwards.length > 0)
          ? inw.linkedOutwards
          : supplierOutwardVouchers.filter((out: any) => getOutwardLinesForInward(out, inw.id).length > 0));
      outs.forEach((out: any) => {
        if (!all.find((o) => o.id === out.id)) all.push(out);
      });
    });
    return all;
  }, [selectedInwards, supplierOutwardVouchers]);

  const [enableRoundOff, setEnableRoundOff] = useState(true);

  const getCompanyRate = (productId: any, processId: any) => {
    const proc = processes.find((p: any) => p.id === Number(processId));
    return proc ? proc.company_rate || 0 : 0;
  };

  const getShotBlastingWeight = () => {
    const shotItems = lineItems.filter((item: any) => {
      const proc = processMapObj[item.process_id] || processes.find((p: any) => p.id === Number(item.process_id));
      const name = (proc && (proc.name || proc.process_name || proc.process_code)) || "";
      if (/shot/i.test(name)) return true;
      const resolved = resolveProcessName(item.process_id, processes);
      return /shot/i.test(resolved);
    });
    if (shotItems.length > 0) {
      const sumQty = shotItems.reduce((sum: number, it: any) => sum + (Number(it.quantity) || 0), 0);
      if (sumQty > 0) return sumQty;
    }
    return Number(lineItems[0]?.quantity) || 0;
  };

  // selectedInwardId: when provided, only outward items belonging to that inward are included.
  const computeLineItemsFromOutwards = (outs: any[], selectedInwardId: number | null = null) => {
    const newItems: any[] = [];
    outs.forEach((out: any) => {
      const rawItems = selectedInwardId !== null ? getOutwardLinesForInward(out, selectedInwardId) : (out.items || []);

      rawItems.forEach((item: any) => {
        const productId = item.product_id || out.product_id || "";
        const processIdStr = String(item.process_id || out.process_id || "");
        const totalWeightVal = Number(item.total_weight || item.weight || out.total_weight || (Number(out.quantity) * Number(out.weight)) || 0);
        const proc = processes.find((p: any) => p.id === Number(processIdStr));
        if (proc && proc.process_ids) {
          const childIds = proc.process_ids.split(",").map((x: string) => x.trim()).filter(Boolean);
          childIds.forEach((cid: string) => {
            const childProc = processes.find((p: any) => p.id === Number(cid));
            if (childProc) {
              const rateVal = getCompanyRate(productId, childProc.id);
              if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) setValue("gst_percent", childProc.gst_percent);
              newItems.push({ product_id: productId, process_id: childProc.id, quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
            }
          });
        } else if (proc && proc.process_code && proc.process_code.includes(" / ")) {
          const parts = proc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          parts.forEach((part: any) => {
            const childProc = processes.find((p: any) => p.process_code === part);
            if (childProc) {
              const rateVal = getCompanyRate(productId, childProc.id);
              if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) setValue("gst_percent", childProc.gst_percent);
              newItems.push({ product_id: productId, process_id: childProc.id, quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
            }
          });
        } else {
          const rateVal = getCompanyRate(productId, processIdStr);
          if (proc && proc.gst_percent !== undefined && proc.gst_percent !== null) setValue("gst_percent", proc.gst_percent);
          newItems.push({ product_id: productId, process_id: processIdStr ? Number(processIdStr) : "", quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
        }
      });
    });

    const merged: Record<number | string, any> = {};
    newItems.forEach((item) => {
      if (!item.process_id) {
        merged[`temp_${Math.random()}`] = { ...item };
      } else {
        const key = Number(item.process_id);
        if (merged[key]) {
          const sumQty = Number(merged[key].quantity || 0) + Number(item.quantity || 0);
          merged[key].quantity = sumQty.toFixed(3);
          merged[key].amount = Number((sumQty * Number(merged[key].rate || 0)).toFixed(2));
        } else {
          merged[key] = { ...item, quantity: Number(item.quantity || 0).toFixed(3) };
        }
      }
    });
    const result = Object.values(merged);
    return result.length > 0 ? result : [{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }];
  };

  const handleInwardSelectionChange = (newSelected: any[]) => {
    setSelectedInwards(newSelected);

    if (newSelected.length === 0) {
      setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
      return;
    }

    const selectedInwardIds = newSelected.map((i: any) => Number(i.id));

    // Deduplicate outward vouchers linked to the selected inwards
    const outwardMap = new Map<number, any>();
    newSelected.forEach((inw: any) => {
      const outs = (inw.unbilledOutwards && inw.unbilledOutwards.length > 0)
        ? inw.unbilledOutwards
        : ((inw.linkedOutwards && inw.linkedOutwards.length > 0)
          ? inw.linkedOutwards
          : supplierOutwardVouchers.filter((out: any) => getOutwardLinesForInward(out, inw.id).length > 0));
      outs.forEach((out: any) => {
        if (out && out.id) outwardMap.set(out.id, out);
      });
    });

    const uniqueOutwards = Array.from(outwardMap.values());
    const parseArray = (x: any): any[] => {
      if (typeof x === "string") {
        try { return JSON.parse(x); } catch { return []; }
      }
      return Array.isArray(x) ? x : [];
    };

    const newItems: any[] = [];
    uniqueOutwards.forEach((out: any) => {
      const rawOutItems = parseArray(out.items);
      let outItems: any[] = [];
      if (rawOutItems.length > 0) {
        const anyHasInwardId = rawOutItems.some(
          (i: any) => i.inward_id !== undefined && i.inward_id !== null && i.inward_id !== ""
        );
        if (anyHasInwardId) {
          outItems = rawOutItems.filter((i: any) => selectedInwardIds.includes(Number(i.inward_id)));
        } else {
          const outHeaderInwardIds: number[] = (() => {
            if (Array.isArray(out.inward_ids)) return out.inward_ids.map(Number);
            if (typeof out.inward_ids === "string") {
              try { return parseArray(out.inward_ids).map(Number); } catch {}
            }
            if (out.inward_id !== undefined && out.inward_id !== null) return [Number(out.inward_id)];
            return [];
          })();
          if (outHeaderInwardIds.some((id: number) => selectedInwardIds.includes(id))) {
            outItems = rawOutItems;
          }
        }
      }

      outItems.forEach((item: any) => {
        const productId = item.product_id || out.product_id || "";
        const processIdStr = String(item.process_id || out.process_id || "");
        const totalWeightVal = Number(item.total_weight || item.weight || out.total_weight || (Number(out.quantity) * Number(out.weight)) || 0);
        const proc = processes.find((p: any) => p.id === Number(processIdStr));
        if (proc && proc.process_ids) {
          const childIds = proc.process_ids.split(",").map((x: string) => x.trim()).filter(Boolean);
          childIds.forEach((cid: string) => {
            const childProc = processes.find((p: any) => p.id === Number(cid));
            if (childProc) {
              const rateVal = getCompanyRate(productId, childProc.id);
              if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) setValue("gst_percent", childProc.gst_percent);
              newItems.push({ product_id: productId, process_id: childProc.id, quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
            }
          });
        } else if (proc && proc.process_code && proc.process_code.includes(" / ")) {
          const parts = proc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
          parts.forEach((part: any) => {
            const childProc = processes.find((p: any) => p.process_code === part);
            if (childProc) {
              const rateVal = getCompanyRate(productId, childProc.id);
              if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) setValue("gst_percent", childProc.gst_percent);
              newItems.push({ product_id: productId, process_id: childProc.id, quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
            }
          });
        } else {
          const rateVal = getCompanyRate(productId, processIdStr);
          if (proc && proc.gst_percent !== undefined && proc.gst_percent !== null) setValue("gst_percent", proc.gst_percent);
          newItems.push({ product_id: productId, process_id: processIdStr ? Number(processIdStr) : "", quantity: totalWeightVal, rate: rateVal, amount: Number((totalWeightVal * rateVal).toFixed(2)) });
        }
      });
    });

    if (newItems.length === 0) {
      setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
      return;
    }

    // Merge items by process_id
    const merged: Record<number | string, any> = {};
    newItems.forEach((item: any) => {
      if (!item.process_id) {
        merged[`temp_${Math.random()}`] = { ...item };
      } else {
        const key = Number(item.process_id);
        if (merged[key]) {
          const sumQty = Number(merged[key].quantity || 0) + Number(item.quantity || 0);
          merged[key].quantity = sumQty.toFixed(3);
          merged[key].amount = Number((sumQty * Number(merged[key].rate || 0)).toFixed(2));
        } else {
          merged[key] = { ...item, quantity: Number(item.quantity || 0).toFixed(3) };
        }
      }
    });
    const result = Object.values(merged);
    setLineItems(result.length > 0 ? result : [{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
  };

  const handleSupplierChange = (val: any) => {
    setValue("ledger_id", val ? val.id : "");
    handleInwardSelectionChange([]);
  };

  const handleAddLineItem = () => {
    setLineItems((prev) => [...prev, { product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
  };

  const handleRemoveLineItem = (index: number) => {
    if (lineItems.length === 1) return;
    setLineItems((prev) => prev.filter((_, i) => i !== index));
  };

  const handleLineItemChange = (index: number, field: string, value: any) => {
    setLineItems((prev) =>
      prev.map((item, i) => {
        if (i === index) {
          const updated = { ...item, [field]: value };
          if (field === "process_id" || field === "product_id") {
            const procId = field === "process_id" ? value : item.process_id;
            const prodId = field === "product_id" ? value : item.product_id;
            updated.rate = getCompanyRate(prodId, procId);
            if (field === "process_id") {
              const proc = processes.find((p: any) => p.id === Number(value));
              if (proc && proc.gst_percent !== undefined && proc.gst_percent !== null) {
                setValue("gst_percent", proc.gst_percent);
              }
            }
          }
          if (field === "quantity" || field === "rate" || field === "process_id" || field === "product_id") {
            updated.amount = Number((Number(updated.quantity || 0) * Number(updated.rate || 0)).toFixed(2));
          }
          return updated;
        }
        return item;
      })
    );
  };

  const handleFreightChange = (field: string, value: any) => {
    setFreightItem((prev: any) => {
      const updated = { ...prev, [field]: value };
      if (field === "process_id") {
        updated.quantity = getShotBlastingWeight().toFixed(3);
        updated.rate = getCompanyRate(undefined, value);
      }
      if (field === "process_id" || field === "quantity" || field === "rate") {
        updated.amount = Number((Number(updated.quantity || 0) * Number(updated.rate || 0)).toFixed(2));
      }
      return updated;
    });
  };

  const handleToggleFreight = () => {
    if (freightOpen) {
      setFreightItem({ process_id: "", quantity: "", rate: "", amount: "" });
    }
    setFreightOpen((prev) => !prev);
  };

  const gstPercent = Number(watch("gst_percent")) || 0;
  const cgstPercent = Number((gstPercent / 2).toFixed(2));
  const sgstPercent = Number((gstPercent / 2).toFixed(2));

  const totalQty = lineItems.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
  const subtotalAmount = lineItems.reduce((sum, item) => sum + (Number(item.amount) || 0), 0);
  const freightAmount = Number(freightItem.amount) || 0;
  const taxableBase = subtotalAmount + freightAmount;

  const cgstAmount = Number(((taxableBase * cgstPercent) / 100).toFixed(2));
  const sgstAmount = Number(((taxableBase * sgstPercent) / 100).toFixed(2));
  const totalGstAmount = Number((cgstAmount + sgstAmount).toFixed(2));

  const unroundedTotal = taxableBase + totalGstAmount;
  const netAmount = enableRoundOff ? Math.round(unroundedTotal) : Number(unroundedTotal.toFixed(2));
  const roundOffAmount = Number((netAmount - unroundedTotal).toFixed(2));

  useEffect(() => {
    if (open) {
      if (editing) {
        const outwardIdList = (() => {
          const ids = editing.outward_ids || [];
          if (!Array.isArray(ids)) return [];
          return ids.map((id: number) => outwardVouchers.find((v: any) => v.id === id)).filter(Boolean);
        })();

        const matchedInwardIds = new Set<number>();
        if (editing.inward_id) matchedInwardIds.add(editing.inward_id);
        outwardIdList.forEach((out: any) => {
          if (out.inward_id) matchedInwardIds.add(out.inward_id);
          if (Array.isArray(out.inward_ids)) out.inward_ids.forEach((id: number) => matchedInwardIds.add(id));
        });
        const matchedInws = inwardVouchers.filter((inv: any) => matchedInwardIds.has(inv.id));
        setSelectedInwards(matchedInws);

        let parsedItems: any[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }

        if (parsedItems && parsedItems.length > 0) {
          setLineItems(parsedItems.map((item: any) => ({
            ...item,
            quantity: item.quantity !== undefined && item.quantity !== "" && item.quantity !== null ? Number(item.quantity).toFixed(3) : ""
          })));
        } else {
          setLineItems([{
            product_id: editing.product_id || "",
            process_id: editing.process_id || "",
            quantity: editing.quantity !== undefined && editing.quantity !== "" && editing.quantity !== null ? Number(editing.quantity).toFixed(3) : "",
            rate: editing.rate || "",
            amount: editing.amount || ""
          }]);
        }

        let parsedFreight: any[] = [];
        if (typeof editing.freight_items === "string") {
          try { parsedFreight = JSON.parse(editing.freight_items); } catch (e) {}
        } else if (Array.isArray(editing.freight_items)) {
          parsedFreight = editing.freight_items;
        }
        if (parsedFreight && parsedFreight.length > 0) {
          setFreightItem({ 
            ...parsedFreight[0],
            quantity: parsedFreight[0].quantity !== undefined && parsedFreight[0].quantity !== "" && parsedFreight[0].quantity !== null ? Number(parsedFreight[0].quantity).toFixed(3) : ""
          });
          setFreightOpen(true);
        } else {
          setFreightItem({ process_id: "", quantity: "", rate: "", amount: "" });
          setFreightOpen(false);
        }

        reset(editing);
      } else {
        setSelectedInwards([]);
        setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
        setFreightItem({ process_id: "", quantity: "", rate: "", amount: "" });
        setFreightOpen(false);
        reset({
          bill_no: "",
          bill_date: today,
          ledger_id: "",
          gst_percent: "" as any,
          narration: "",
          dispatch_through: ""
        });
        api.get("/sequences/preview/labour_bill")
          .then((res) => {
            setValue("bill_no", res.data.next_no);
          })
          .catch((e) => console.error(e));
      }
    }
  }, [open, editing, reset, outwardVouchers, inwardVouchers, setValue]);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const shotWeight = getShotBlastingWeight();
      const finalWeight = shotWeight > 0 ? shotWeight : (Number(lineItems[0]?.quantity) || totalQty);
      const payload = {
        bill_no: formData.bill_no,
        bill_date: formData.bill_date,
        ledger_id: Number(formData.ledger_id),
        inward_id: selectedInwards.length > 0 ? selectedInwards[0].id : null,
        inward_ids: selectedInwards.map((i) => i.id),
        product_id: lineItems[0]?.product_id ? Number(lineItems[0].product_id) : null,
        process_id: lineItems[0]?.process_id ? Number(lineItems[0].process_id) : null,
        quantity: finalWeight,
        rate: lineItems[0]?.rate ? Number(lineItems[0].rate) : 0,
        amount: subtotalAmount,
        gst_percent: gstPercent,
        gst_amount: totalGstAmount,
        cgst_percent: cgstPercent,
        cgst_amount: cgstAmount,
        sgst_percent: sgstPercent,
        sgst_amount: sgstAmount,
        round_off: roundOffAmount,
        net_amount: netAmount,
        total_amount: netAmount,
        narration: formData.narration || null,
        dispatch_through: formData.dispatch_through || null,
        items: lineItems.map((item) => ({
          product_id: item.product_id ? Number(item.product_id) : null,
          process_id: item.process_id ? Number(item.process_id) : null,
          quantity: Number(item.quantity) || 0,
          rate: Number(item.rate) || 0,
          amount: Number(item.amount) || 0
        })),
        outward_ids: selectedOutwards.map((o) => o.id),
        freight_items: freightItem.process_id ? [{
          process_id: Number(freightItem.process_id),
          quantity: Number(freightItem.quantity) || 0,
          rate: Number(freightItem.rate) || 0,
          amount: Number(freightItem.amount) || 0
        }] : []
      };
      return editing
        ? api.put(`/labour-bills/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/labour-bills/?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["labour-bills"] });
      onClose();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
      const detailMsg = error.response?.data?.detail;
      const msg = typeof detailMsg === "string" ? detailMsg : (detailMsg ? JSON.stringify(detailMsg) : "Failed to save Labour Bill. This usually happens if the Bill Number already exists. Please verify the Bill Number and try again.");
      alert(msg);
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
    <>
      <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))} onKeyDown={handleKeyDown}>
          <DialogTitle sx={{ fontWeight: 700, color: "#023020" }}>
            {editing ? "Edit Labour Bill" : "New Labour Bill"}
          </DialogTitle>
          <DialogContent dividers>
            <Grid container spacing={2}>
              {/* Header Details */}
              <Grid size={{ xs: 6, sm: 2 }}>
                <TextField {...register("bill_no")} label="Bill No. *" fullWidth required size="small" disabled={Boolean(editing)} />
              </Grid>
              <Grid size={{ xs: 6, sm: 2 }}>
                <TextField {...register("bill_date")} label="Date *" type="date" fullWidth size="small" slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12, sm: 5 }}>
                <LazyAutocomplete
                  size="small"
                  value={ledgerMapObj[watch("ledger_id")] || null}
                  onChange={(_, val) => handleSupplierChange(val)}
                  options={ledgers}
                  getOptionLabel={(option: any) => option.name || ""}
                  noOptionsText="No matching suppliers"
                  renderInput={(params) => <TextField {...params} label="Supplier *" required={!watch("ledger_id")} />}
                />
              </Grid>
              <Grid size={{ xs: 12, sm: 3 }}>
                <TextField {...register("dispatch_through")} label="Dispatch Through" fullWidth size="small" placeholder="Transport details" />
              </Grid>

              {/* Multi Inward Number Selection with Checkboxes */}
              {selectedLedger && (
                <Grid size={{ xs: 12 }}>
                  <AutocompleteAny
                    multiple
                    disableCloseOnSelect
                    size="small"
                    fullWidth
                    value={selectedInwards}
                    onChange={(_: any, val: any) => handleInwardSelectionChange(val || [])}
                    options={eligibleInwardNumbers}
                    getOptionLabel={(option: any) => {
                      if (!option) return "";
                      const sNo = option.serial_no || option.ref_no;
                      return `${option.inward_no}${sNo ? ` (${sNo})` : ""}`;
                    }}
                    isOptionEqualToValue={(option: any, val: any) => option.id === val.id}
                    renderOption={(props: any, option: any, { selected }: any) => {
                      const sNo = option.serial_no || option.ref_no;
                      const dStr = option.inward_date ? new Date(option.inward_date).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }) : "";
                      const outsStr = option.outwardNos || (option.unbilledOutwards || []).map((o: any) => o.outward_no || `#${o.id}`).filter(Boolean).join(", ");
                      return (
                        <Box component="li" {...props} key={option.id} sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", py: 0.75, width: "100%" }}>
                          <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                            <Checkbox
                              size="small"
                              checked={selected}
                              sx={{ p: 0.5, color: "#023020", "&.Mui-checked": { color: "#023020" } }}
                            />
                            <Box>
                              <Typography variant="body2" sx={{ fontWeight: 700, color: "#023020" }}>
                                {option.inward_no} {sNo ? <Typography component="span" variant="caption" color="text.secondary">({sNo})</Typography> : null}
                              </Typography>
                              <Typography variant="caption" color="text.secondary" sx={{ display: "block" }}>
                                {dStr}{outsStr ? ` · Outwards: ${outsStr}` : ""}
                              </Typography>
                            </Box>
                          </Box>
                          <Chip
                            size="small"
                            label={`${formatWeight(option.unbilledWeight)} kg`}
                            sx={{ bgcolor: "#e8f5e9", color: "#023020", fontWeight: 700, fontSize: "0.7rem", ml: 2 }}
                          />
                        </Box>
                      );
                    }}
                    renderTags={(value: any[], getTagProps: any) =>
                      value.map((option: any, index: number) => {
                        const { key, ...tagProps } = getTagProps({ index });
                        const sNo = option.serial_no || option.ref_no;
                        const outsStr = option.outwardNos || (option.unbilledOutwards || []).map((o: any) => o.outward_no || `#${o.id}`).filter(Boolean).join(", ");
                        return (
                          <Chip
                            key={option.id}
                            label={`Inward: ${option.inward_no}${sNo ? ` (${sNo})` : ""}${outsStr ? ` (Out: ${outsStr})` : ""} • ${formatWeight(option.unbilledWeight || 0)} kg`}
                            size="small"
                            {...tagProps}
                            sx={{
                              bgcolor: "#e8f5e9",
                              color: "#023020",
                              fontWeight: 700,
                              border: "1px solid #023020",
                              borderRadius: "16px",
                              m: "2px !important"
                            }}
                          />
                        );
                      })
                    }
                    noOptionsText="No completed Inwards are available for Labour Billing."
                    renderInput={(params: any) => (
                      <TextField
                        {...params}
                        label="Select Inward Number(s) *"
                        placeholder="Tick checkboxes to select inward numbers..."
                        helperText={`${eligibleInwardNumbers.length} completed inward record(s) available — tick checkboxes to select multiple`}
                      />
                    )}
                  />
                </Grid>
              )}

              {/* Line Items Table */}
              <Grid size={{ xs: 12 }}>
                <Typography sx={{ fontWeight: 600, color: "#023020", mb: 1 }} variant="subtitle2">
                  Bill Line Items
                </Typography>
                <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                  <Table size="small">
                    <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                      <TableRow>
                        <TableCell sx={{ width: 40, fontWeight: 700 }} align="center">S. No</TableCell>
                        <TableCell sx={{ width: "50%", fontWeight: 700 }}>Process *</TableCell>
                        <TableCell sx={{ width: 100, fontWeight: 700 }} align="right">Weight (kg) *</TableCell>
                        <TableCell sx={{ width: 110, fontWeight: 700 }} align="right">Rate *</TableCell>
                        <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Amount</TableCell>
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
                              value={processMapObj[item.process_id] || null}
                              onChange={(_, val) => handleLineItemChange(idx, "process_id", val ? val.id : "")}
                              options={processes.filter((p: any) => 
                                (p.is_active || p.id === Number(item.process_id)) && 
                                (p.process_ids || (p.process_code && p.process_code.includes(" / ")))
                              )}
                              getOptionLabel={(option: any) => option.name || ""}
                              noOptionsText="No matching processes"
                              renderInput={(params) => <TextField {...params} required={!item.process_id} />}
                            />
                          </TableCell>
                          <TableCell>
                            <TextField
                              size="small"
                              type="number"
                              value={item.quantity}
                              onChange={(e) => handleLineItemChange(idx, "quantity", e.target.value)}
                              onBlur={(e) => {
                                const val = e.target.value;
                                if (val !== "") {
                                  handleLineItemChange(idx, "quantity", Number(val).toFixed(3));
                                }
                              }}
                              slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.001" } }}
                              required
                            />
                          </TableCell>
                          <TableCell>
                            <TextField
                              size="small"
                              type="number"
                              value={item.rate}
                              onChange={(e) => handleLineItemChange(idx, "rate", e.target.value)}
                              slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
                              required
                            />
                          </TableCell>
                          <TableCell align="right">
                            <Typography variant="body2" sx={{ fontWeight: 600 }}>
                              ₹{formatAmount(item.amount)}
                            </Typography>
                          </TableCell>
                          <TableCell align="center">
                            <IconButton size="small" color="error" disabled={lineItems.length === 1} onClick={() => handleRemoveLineItem(idx)} tabIndex={-1}>
                              <RemoveCircle fontSize="small" />
                            </IconButton>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </Paper>
                <Button size="small" variant="text" startIcon={<Add />} sx={{ mt: 1, textTransform: "none", color: "#023020", fontWeight: 600 }} onClick={handleAddLineItem}>
                  Add Item Row
                </Button>
                {!freightOpen && (
                  <Button size="small" variant="outlined" startIcon={<Add />} sx={{ ml: 1, mt: 1, textTransform: "none", color: "#023020", borderColor: "#023020", fontWeight: 600 }} onClick={handleToggleFreight}>
                    Add Freight Section
                  </Button>
                )}
              </Grid>

              {freightOpen && (
                <Grid size={{ xs: 12 }}>
                  <Typography sx={{ fontWeight: 600, color: "#023020", mb: 1 }} variant="subtitle2">
                    Freight / Other Charges
                  </Typography>
                  <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                    <Table size="small">
                      <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                        <TableRow>
                          <TableCell sx={{ width: "50%", fontWeight: 700 }}>Process *</TableCell>
                          <TableCell sx={{ width: 100, fontWeight: 700 }} align="right">Weight (kg) *</TableCell>
                          <TableCell sx={{ width: 110, fontWeight: 700 }} align="right">Rate *</TableCell>
                          <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Amount</TableCell>
                          <TableCell sx={{ width: 50 }} align="center">Del</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        <TableRow>
                          <TableCell>
                            <LazyAutocomplete
                              size="small"
                              value={processMapObj[freightItem.process_id] || null}
                              onChange={(_, val) => handleFreightChange("process_id", val ? val.id : "")}
                              options={processes.filter((p: any) =>
                                (p.is_active || p.id === Number(freightItem.process_id)) &&
                                (p.process_ids || (p.process_code && p.process_code.includes(" / ")))
                              )}
                              getOptionLabel={(option: any) => option.name || ""}
                              noOptionsText="No matching processes"
                              renderInput={(params) => <TextField {...params} required={!freightItem.process_id} />}
                            />
                          </TableCell>
                          <TableCell>
                            <TextField
                              size="small"
                              type="number"
                              value={freightItem.quantity}
                              onChange={(e) => handleFreightChange("quantity", e.target.value)}
                              onBlur={(e) => {
                                const val = e.target.value;
                                if (val !== "") {
                                  handleFreightChange("quantity", Number(val).toFixed(3));
                                }
                              }}
                              slotProps={{ htmlInput: { style: { textAlign: "right" }, step: "0.001" } }}
                              required
                            />
                          </TableCell>
                          <TableCell>
                            <TextField
                              size="small"
                              type="number"
                              value={freightItem.rate}
                              onChange={(e) => handleFreightChange("rate", e.target.value)}
                              slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
                              required
                            />
                          </TableCell>
                          <TableCell align="right">
                            <Typography variant="body2" sx={{ fontWeight: 600 }}>
                              ₹{formatAmount(freightItem.amount)}
                            </Typography>
                          </TableCell>
                          <TableCell align="center">
                            <IconButton size="small" color="error" onClick={handleToggleFreight} tabIndex={-1}>
                              <RemoveCircle fontSize="small" />
                            </IconButton>
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </Paper>
                </Grid>
              )}

              {/* Subtotals & Taxes & Round Off */}
              <Grid size={{ xs: 12 }}>
                <Paper variant="outlined" sx={{ p: 2, bgcolor: "#f8fafc", borderRadius: "8px" }}>
                  <Grid container spacing={2} sx={{ alignItems: "center" }}>
                    <Grid size={{ xs: 12, sm: 2 }}>
                      <TextField label="Taxable Subtotal" type="number" fullWidth size="small" value={subtotalAmount} slotProps={{ input: { readOnly: true } }} />
                    </Grid>
                    <Grid size={{ xs: 12, sm: 2 }}>
                      <TextField label="Freight" type="number" fullWidth size="small" value={freightAmount} slotProps={{ input: { readOnly: true } }} />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 2 }}>
                      <TextField {...register("gst_percent")} label="GST %" type="number" fullWidth size="small" slotProps={{ htmlInput: { step: "any" } }} />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 2 }}>
                      <TextField label={`CGST (${cgstPercent}%)`} type="number" fullWidth size="small" value={cgstAmount} slotProps={{ input: { readOnly: true } }} />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 2 }}>
                      <TextField label={`SGST (${sgstPercent}%)`} type="number" fullWidth size="small" value={sgstAmount} slotProps={{ input: { readOnly: true } }} />
                    </Grid>
                    <Grid size={{ xs: 6, sm: 2 }}>
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <TextField label="Round Off" type="number" fullWidth size="small" value={roundOffAmount} slotProps={{ input: { readOnly: true } }} />
                        <FormControlLabel
                          control={<Checkbox checked={enableRoundOff} onChange={(e) => setEnableRoundOff(e.target.checked)} size="small" color="success" />}
                          label="Auto"
                          sx={{ m: 0, whiteSpace: "nowrap" }}
                        />
                      </Box>
                    </Grid>
                    <Grid size={{ xs: 12 }}>
                      <Box sx={{ display: "flex", justifyContent: "flex-end", alignItems: "center", gap: 2, pt: 1, borderTop: "1px solid #cbd5e1" }}>
                        <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#0f5132" }}>
                          Net Payable Amount:
                        </Typography>
                        <Typography variant="h6" sx={{ fontWeight: 800, color: "#0f5132" }}>
                          ₹{formatAmount(netAmount)}
                        </Typography>
                      </Box>
                    </Grid>
                  </Grid>
                </Paper>
              </Grid>

              <Grid size={{ xs: 12 }}>
                <TextField {...register("narration")} label="Narration" fullWidth size="small" />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={onClose} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>
    </>
  );
}