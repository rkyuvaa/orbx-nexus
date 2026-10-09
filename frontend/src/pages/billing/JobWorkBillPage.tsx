import { useState, useMemo, useEffect, useCallback, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Menu, Autocomplete,
  Typography, Paper, Table, TableHead, TableRow, TableCell, TableBody,
  Checkbox, FormControlLabel, Alert
} from "@mui/material";
import * as XLSX from "xlsx";
import Add from "@mui/icons-material/Add";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import CheckCircle from "@mui/icons-material/CheckCircle";
import Print from "@mui/icons-material/Print";
import Description from "@mui/icons-material/Description";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import WarningAmber from "@mui/icons-material/WarningAmber";
import { useForm, Controller } from "react-hook-form";
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

    const firstQty = Number(itemsArray[0]?.quantity);
    if (!isNaN(firstQty) && firstQty > 0) {
      return firstQty;
    }
  }

  return Number(row.quantity || 0);
};

export const isOutwardLinkedToInward = (out: any, inwId: number): boolean => {
  if (!out || !inwId) return false;
  if (Number(out.inward_id) === inwId) return true;
  const outInwardIds: number[] = (() => {
    if (Array.isArray(out.inward_ids)) return out.inward_ids.map(Number);
    if (typeof out.inward_ids === "string") {
      try { return (JSON.parse(out.inward_ids) as any[]).map(Number); } catch {}
    }
    return [];
  })();
  if (outInwardIds.includes(inwId)) return true;
  const rawItems: any[] = (() => {
    if (Array.isArray(out.items)) return out.items;
    if (typeof out.items === "string" && out.items.trim() !== "") {
      try { return JSON.parse(out.items); } catch {}
    }
    return [];
  })();
  return rawItems.some((it: any) => it.inward_id !== undefined && it.inward_id !== null && Number(it.inward_id) === inwId);
};

export const isOutwardLinkedToInwardAny = (out: any, inwIdSet: Set<number>): boolean => {
  if (!out || inwIdSet.size === 0) return false;
  if (out.inward_id && inwIdSet.has(Number(out.inward_id))) return true;
  const outInwardIds: number[] = (() => {
    if (Array.isArray(out.inward_ids)) return out.inward_ids.map(Number);
    if (typeof out.inward_ids === "string") {
      try { return (JSON.parse(out.inward_ids) as any[]).map(Number); } catch {}
    }
    return [];
  })();
  if (outInwardIds.some((id: number) => inwIdSet.has(id))) return true;
  const rawItems: any[] = (() => {
    if (Array.isArray(out.items)) return out.items;
    if (typeof out.items === "string" && out.items.trim() !== "") {
      try { return JSON.parse(out.items); } catch {}
    }
    return [];
  })();
  return rawItems.some((it: any) => it.inward_id !== undefined && it.inward_id !== null && inwIdSet.has(Number(it.inward_id)));
};

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
    if (isOutwardLinkedToInward(out, inwId)) {
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
    return isOutwardLinkedToInward(out, inwId) ? rawItems : [];
  }
};


export default function JobWorkBillPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: bills = [], isLoading, refetch } = useQuery({
    queryKey: ["job-work-bills", activeFY],
    queryFn: async () => (await api.get(`/job-work-bills/?fy=${activeFY}`)).data,
  });

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
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
    queryFn: async () => (await api.get(`/stock/inward?fy=${activeFY}`)).data
  });

  const ledgerMap = useMemo(() => {
    const map: Record<number, string> = {};
    ledgers.forEach((l: any) => map[l.id] = l.name);
    return map;
  }, [ledgers]);

  const processMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    processes.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [processes]);

  const today = new Date().toISOString().split("T")[0];

  const markPaidMutation = useMutation({
    mutationFn: (id: number) => api.patch(`/job-work-bills/${id}/mark-paid?fy=${activeFY}&payment_date=${today}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["job-work-bills"] }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/job-work-bills/${id}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["job-work-bills"] }),
  });

  const handleOpen = (row?: any) => {
    setEditing(row || null);
    setOpen(true);
  };

  const handlePrintJobWorkBill = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = {
      showLogo: true,
      billPaperSize: "A4",
      billTitle: "Job Work Bill Invoice",
      billTerms: "1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.",
    };
    if (savedConfig) {
      try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch (e) {}
    }

    const logoBase64 = localStorage.getItem("company_logo");
    const logoHtml = (printConfig.showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "Company";
    const cAddress1 = compData?.address || "";
    const cAddress2 = "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = new Date(row.bill_date).toLocaleDateString("en-IN", {
      day: "2-digit", month: "2-digit", year: "numeric"
    }).replace(/\//g, "-");

    const customerLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const customerName = customerLedger?.name || `Customer #${row.ledger_id}`;
    const customerAddr1 = customerLedger?.address || [customerLedger?.address_line1, customerLedger?.address_line2].filter(Boolean).join(", ") || "";
    const customerCityStatePin = [customerLedger?.city, customerLedger?.state, customerLedger?.pincode].filter(Boolean).join(" - ");
    const customerPhone = customerLedger?.phone || customerLedger?.mobile ? `Tel: ${[customerLedger?.phone, customerLedger?.mobile].filter(Boolean).join(" / ")}` : "";
    const customerGstin = customerLedger?.gstin || "";

    const outwardIds = Array.isArray(row.outward_ids)
      ? row.outward_ids
      : (typeof row.outward_ids === "string"
        ? (() => { try { return JSON.parse(row.outward_ids); } catch { return []; } })()
        : []);
    
    const linkedOutwards = (outwardIds || []).map((id: number) => outwardVouchers.find((v: any) => v.id === id)).filter(Boolean);

    const parseJsonArray = (x: any): any[] => {
      if (typeof x === "string") {
        try { return JSON.parse(x); } catch (e) { return []; }
      }
      return Array.isArray(x) ? x : [];
    };

    const billInwardIds: number[] = [];
    parseJsonArray(row.inward_ids).forEach((id: any) => { if (id) billInwardIds.push(Number(id)); });
    if (billInwardIds.length === 0 && row.inward_id) {
      billInwardIds.push(Number(row.inward_id));
    }

    const resolvedInwardRefs = new Set<string>();
    billInwardIds.forEach((inwId: number) => {
      const inv = inwardVouchers.find((v: any) => v.id === inwId);
      if (inv) {
        const ref = inv.ref_no || inv.serial_no || inv.inward_no;
        if (ref) resolvedInwardRefs.add(ref);
      }
    });

    if (resolvedInwardRefs.size === 0) {
      linkedOutwards.forEach((out: any) => {
        if (out.ref_no) resolvedInwardRefs.add(out.ref_no);
      });
    }

    const inwardRefs = Array.from(resolvedInwardRefs).join(", ") || "-";
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
    } else {
      itemsArray.sort((a: any, b: any) => {
        const rankA = getProcessOrderRank(a.process_id, processes);
        const rankB = getProcessOrderRank(b.process_id, processes);
        if (rankA !== rankB) return rankA - rankB;
        const nameA = (resolveProcessName(a.process_id, processes) || "").toLowerCase();
        const nameB = (resolveProcessName(b.process_id, processes) || "").toLowerCase();
        return nameA.localeCompare(nameB);
      });
    }

    let itemsHtml = "";
    itemsArray.forEach((item, idx) => {
      const prName = resolveProcessName(item.process_id, processes) || "-";
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
          <title>Print Job Work Bill - ${row.bill_no}</title>
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
            <h2>JOB WORK BILL</h2>
            <div class="doc-no">Bill No: ${row.bill_no}</div>
            <div class="doc-date">Date: ${dateStr}</div>
            ${inwardRefs && inwardRefs !== "-" ? `<div class="doc-date">Inward Ref: ${inwardRefs}</div>` : ""}
          </div>
          <div class="address-section">
            <div class="address-column" style="width: 100%;">
              <h3>CUSTOMER DETAILS:</h3>
              <div class="name">${customerName}</div>
              ${customerAddr1 ? `<div class="address-lines">${customerAddr1}</div>` : ""}
              ${customerCityStatePin ? `<div class="address-lines">${customerCityStatePin}</div>` : ""}
              ${customerPhone ? `<div class="address-lines">${customerPhone}</div>` : ""}
              ${customerGstin ? `<div class="gstin">GSTIN: ${customerGstin}</div>` : ""}
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
                <div class="signature-label">Customer Signature</div>
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

  const buildJobWorkDetailsReportData = (row: any) => {
    const compData = Array.isArray(companyData) ? companyData[0] : companyData;
    const cName = compData?.name || "Company";
    const cAddress1 = compData?.address || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${compData?.phone || compData?.mobile}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData.gstin}` : "";

    const dateStr = row.bill_date ? new Date(row.bill_date).toLocaleDateString("en-IN", {
      day: "2-digit", month: "2-digit", year: "numeric"
    }).replace(/\//g, "-") : "-";

    const customerLedger = ledgers.find((l: any) => l.id === row.ledger_id);
    const customerName = customerLedger?.name || `Customer #${row.ledger_id}`;
    const customerAddr1 = customerLedger?.address || [customerLedger?.address_line1, customerLedger?.address_line2].filter(Boolean).join(", ") || "";
    const customerCityStatePin = [customerLedger?.city, customerLedger?.state, customerLedger?.pincode].filter(Boolean).join(" - ");
    const customerPhone = customerLedger?.phone || customerLedger?.mobile ? `Tel: ${[customerLedger?.phone, customerLedger?.mobile].filter(Boolean).join(" / ")}` : "";
    const customerGstin = customerLedger?.gstin || "";

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
          day: "2-digit", month: "2-digit", year: "numeric"
        }).replace(/\//g, "-");
      } catch (e) { return "-"; }
    };

    // STRICT: Only inwards belonging to THIS bill!
    const billInwardIdSet = new Set<number>();
    parseJsonArray(row.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
    if (row.inward_id) billInwardIdSet.add(Number(row.inward_id));

    const storedOutwardIds = parseJsonArray(row.outward_ids).map(Number);
    if (billInwardIdSet.size === 0 && storedOutwardIds.length > 0) {
      storedOutwardIds.forEach((oid: number) => {
        const out = outwardVouchers.find((o: any) => o.id === oid);
        if (out) {
          if (out.inward_id) billInwardIdSet.add(Number(out.inward_id));
          parseJsonArray(out.inward_ids).forEach((id: any) => { if (id) billInwardIdSet.add(Number(id)); });
          parseJsonArray(out.items).forEach((it: any) => { if (it.inward_id) billInwardIdSet.add(Number(it.inward_id)); });
        }
      });
    }

    const billAllInwardIds: number[] = Array.from(billInwardIdSet);
    const linkedInwards = billAllInwardIds
      .map((id: number) => {
        const found = inwardVouchers.find((v: any) => v.id === id);
        if (found) return found;
        return { id, inward_no: `#${id}`, ref_no: `#${id}`, items: [] };
      })
      .filter(Boolean);

    // Keep inwards strictly in stable order so all lines for an inward remain contiguous
    linkedInwards.sort((a: any, b: any) => {
      const dateA = a.inward_date ? new Date(a.inward_date).getTime() : 0;
      const dateB = b.inward_date ? new Date(b.inward_date).getTime() : 0;
      if (dateA !== dateB) return dateA - dateB;
      const numA = (a.ref_no || a.serial_no || a.inward_no || "").toLowerCase();
      const numB = (b.ref_no || b.serial_no || b.inward_no || "").toLowerCase();
      if (numA !== numB) return numA.localeCompare(numB, undefined, { numeric: true });
      return Number(a.id || 0) - Number(b.id || 0);
    });

    const resolveSeparateProcesses = (procId: any): string => {
      if (!procId) return "-";
      const proc = processes.find((p: any) => p.id === Number(procId));
      if (proc && proc.process_ids) {
        const pids = String(proc.process_ids).split(",").map((x: string) => x.trim()).filter(Boolean);
        const names = pids.map((pid: string) => processes.find((p: any) => p.id === Number(pid))?.name || pid).filter(Boolean);
        return names.join(" / ") || "-";
      }
      return resolveProcessName(procId, processes) || "-";
    };

    const billItems: any[] = (() => {
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

    uniqueActiveProcesses.sort((a: any, b: any) => {
      const rankA = getProcessOrderRank(a.id, processes);
      const rankB = getProcessOrderRank(b.id, processes);
      if (rankA !== rankB) return rankA - rankB;
      const nameA = (a.name || "").toLowerCase();
      const nameB = (b.name || "").toLowerCase();
      return nameA.localeCompare(nameB);
    });

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
      return false;
    };

    const reportRows: any[] = [];

    linkedInwards.forEach((inv: any) => {
      const invRef = inv.ref_no || inv.serial_no || inv.inward_no || "-";
      const invDateStr = toDateStr(inv.inward_date);
      const rawInwItems = parseJsonArray(inv.items);

      interface InwProdInfo {
        productId: number;
        productName: string;
        quantity: number;
        weight: number;
      }
      const inwProducts: InwProdInfo[] = [];

      if (rawInwItems.length === 0) {
        const pid = Number(inv.product_id) || 0;
        const pObj = products.find((p: any) => p.id === pid);
        inwProducts.push({
          productId: pid,
          productName: pObj?.name || (pid ? `Product #${pid}` : "-"),
          quantity: Number(inv.quantity) || 0,
          weight: Number(inv.total_weight || inv.weight || 0),
        });
      } else {
        const prodMap = new Map<number, { qty: number; weight: number }>();
        rawInwItems.forEach((it: any) => {
          const pid = Number(it.product_id) || Number(inv.product_id) || 0;
          const q = Number(it.quantity) || 0;
          let w = 0;
          if (it.total_weight !== undefined && it.total_weight !== null && it.total_weight !== "") {
            w = Number(it.total_weight);
          } else if (it.weight !== undefined && it.weight !== null && it.weight !== "") {
            w = Number(it.weight) * (q || 1);
          } else {
            w = q;
          }
          const curr = prodMap.get(pid) || { qty: 0, weight: 0 };
          prodMap.set(pid, { qty: curr.qty + q, weight: curr.weight + w });
        });

        prodMap.forEach((val, pid) => {
          const pObj = products.find((p: any) => p.id === pid);
          inwProducts.push({
            productId: pid,
            productName: pObj?.name || (pid ? `Product #${pid}` : "-"),
            quantity: val.qty,
            weight: val.weight,
          });
        });
      }

      // Outward vouchers linked to THIS specific inward
      const outsForInv = outwardVouchers.filter((out: any) => {
        if (storedOutwardIds.length > 0 && !storedOutwardIds.includes(out.id)) return false;
        return isOutwardLinkedToInward(out, inv.id);
      });

      outsForInv.sort((a: any, b: any) => {
        const dateA = a.outward_date ? new Date(a.outward_date).getTime() : 0;
        const dateB = b.outward_date ? new Date(b.outward_date).getTime() : 0;
        if (dateA !== dateB) return dateA - dateB;
        const noA = (a.outward_no || "").toLowerCase();
        const noB = (b.outward_no || "").toLowerCase();
        return noA.localeCompare(noB, undefined, { numeric: true });
      });

      inwProducts.forEach((inwProd) => {
        const outRowsForProd: any[] = [];

        outsForInv.forEach((out: any) => {
          const rawOutItems = parseJsonArray(out.items);
          let matchingLines: any[] = [];

          if (rawOutItems.length > 0) {
            const tagged = rawOutItems.filter((it: any) => Number(it.inward_id) === inv.id);
            if (tagged.length > 0) {
              matchingLines = tagged;
            } else {
              const outInwardIds = parseJsonArray(out.inward_ids).map(Number);
              if (out.inward_id) outInwardIds.push(Number(out.inward_id));
              const uniqueOutInwIds = Array.from(new Set(outInwardIds));
              if (uniqueOutInwIds.length <= 1) {
                matchingLines = rawOutItems;
              } else {
                matchingLines = rawOutItems.filter((it: any) => {
                  const itemPid = Number(it.product_id);
                  return inwProd.productId ? itemPid === inwProd.productId : true;
                });
              }
            }

            if (inwProd.productId && matchingLines.length > 1) {
              const byProd = matchingLines.filter((it: any) => Number(it.product_id) === inwProd.productId);
              if (byProd.length > 0) matchingLines = byProd;
            }
          } else {
            const outPid = Number(out.product_id) || 0;
            if (!inwProd.productId || !outPid || outPid === inwProd.productId) {
              matchingLines = [{
                product_id: out.product_id,
                process_id: out.process_id,
                quantity: out.quantity || 0,
                total_weight: out.total_weight || out.weight || 0,
                weight: out.total_weight || out.weight || 0,
              }];
            }
          }

          matchingLines.forEach((line: any) => {
            const itemProcId = line.process_id || out.process_id;
            if (uniqueActiveProcesses.length > 0) {
              const matchesActive = uniqueActiveProcesses.some((proc: any) => isProcessInRow(proc.id, itemProcId));
              if (!matchesActive) return;
            }

            outRowsForProd.push({
              inward_id: inv.id,
              raw_inward_date: inv.inward_date ? new Date(inv.inward_date).getTime() : 0,
              raw_outward_date: out.outward_date ? new Date(out.outward_date).getTime() : 0,
              ref: invRef,
              inward_date: invDateStr,
              productName: inwProd.productName,
              inward_qty: inwProd.quantity,
              inward_weight: inwProd.weight,
              outward_no: out.outward_no || `#${out.id}`,
              outward_date: toDateStr(out.outward_date),
              outward_qty: Number(line.quantity) || 0,
              outward_weight: Number(line.total_weight || line.weight || 0),
              processName: resolveSeparateProcesses(itemProcId),
              processId: itemProcId,
            });
          });
        });

        if (outRowsForProd.length > 0) {
          reportRows.push(...outRowsForProd);
        } else {
          reportRows.push({
            inward_id: inv.id,
            raw_inward_date: inv.inward_date ? new Date(inv.inward_date).getTime() : 0,
            raw_outward_date: 0,
            ref: invRef,
            inward_date: invDateStr,
            productName: inwProd.productName,
            inward_qty: inwProd.quantity,
            inward_weight: inwProd.weight,
            outward_no: "-",
            outward_date: "-",
            outward_qty: null,
            outward_weight: null,
            processName: "-",
            processId: null,
          });
        }
      });
    });

    const weightScaleFactor = 1;
    const scaledReportRows = reportRows.map((r) => ({
      ...r,
      raw_outward_weight: Number(r.outward_weight) || 0,
    }));

    const processTotals: Record<number, number> = {};
    uniqueActiveProcesses.forEach((proc) => {
      processTotals[proc.id] = reportRows.reduce((sum, r) => {
        if (isProcessInRow(proc.id, r.processId)) {
          return sum + (Number(r.outward_weight) || 0);
        }
        return sum;
      }, 0);
    });

    return {
      cName, cAddress1, cAddress2: "", cCityStatePin, cPhone, cEmail, cTax,
      dateStr, customerName, customerAddr1, customerCityStatePin, customerPhone, customerGstin,
      uniqueActiveProcesses, reportRows, scaledReportRows, processTotals, weightScaleFactor,
      isProcessInRow
    };
  };

  const handlePrintJobWorkDetails = (row: any) => {
    const data = buildJobWorkDetailsReportData(row);
    if (!data) return;
    const {
      cName, cAddress1, cAddress2, cCityStatePin, cPhone, cEmail, cTax,
      dateStr, customerName, customerAddr1, customerCityStatePin, customerPhone, customerGstin,
      uniqueActiveProcesses, scaledReportRows, processTotals, weightScaleFactor,
      isProcessInRow
    } = data;

    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = { showLogo: true, billPaperSize: "A4" };
    if (savedConfig) {
      try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch (e) {}
    }

    const logoBase64 = localStorage.getItem("company_logo");
    const logoHtml = (printConfig.showLogo && logoBase64) ? `<img src="${logoBase64}" />` : "";

    const fmtCell = (v: any, fmt: (n: number) => string): string =>
      v === null || v === undefined || v === "" || v === "-" ? "-" : fmt(v);

    const fmtWeightCell = (v: any): string => {
      const s = fmtCell(v, formatWeight);
      return s === "-" ? "-" : `${s} kg`;
    };

    let reportRowsHtml = "";
    if (scaledReportRows.length === 0) {
      const totalColSpan = 9 + (uniqueActiveProcesses.length || 1);
      reportRowsHtml = `<tr><td colspan="${totalColSpan}" style="text-align: center; padding: 12px;">No linked inward / outward vouchers</td></tr>`;
    } else {
      interface GroupedProduct {
        inward_id: any;
        productName: string;
        inward_qty: any;
        inward_weight: any;
        rowSpan: number;
        transactions: any[];
      }
      interface GroupedRef {
        inward_id?: any;
        ref: string;
        inward_date: string;
        rowSpan: number;
        products: GroupedProduct[];
      }

      const groups: GroupedRef[] = [];
      let currentRefGroup: GroupedRef | null = null;
      let currentProdGroup: GroupedProduct | null = null;

      scaledReportRows.forEach((r) => {
        const isNewRefGroup = !currentRefGroup || (r.inward_id !== undefined && r.inward_id !== null ? currentRefGroup.inward_id !== r.inward_id : (currentRefGroup.ref !== r.ref || currentRefGroup.inward_date !== r.inward_date));
        if (isNewRefGroup) {
          currentRefGroup = { inward_id: r.inward_id, ref: r.ref || "-", inward_date: r.inward_date || "-", rowSpan: 0, products: [] };
          groups.push(currentRefGroup);
          currentProdGroup = null;
        }

        const prodKey = `${r.inward_id}_${r.productName}_${r.inward_qty}_${r.inward_weight}`;
        if (!currentProdGroup || `${currentProdGroup.inward_id}_${currentProdGroup.productName}_${currentProdGroup.inward_qty}_${currentProdGroup.inward_weight}` !== prodKey) {
          currentProdGroup = {
            inward_id: r.inward_id,
            productName: r.productName || "-",
            inward_qty: r.inward_qty,
            inward_weight: r.inward_weight,
            rowSpan: 0,
            transactions: []
          };
          currentRefGroup.products.push(currentProdGroup);
        }

        currentProdGroup.transactions.push(r);
        currentProdGroup.rowSpan++;
        currentRefGroup.rowSpan++;
      });

      groups.forEach((refGroup) => {
        refGroup.products.forEach((prodGroup, prodIdx) => {
          prodGroup.transactions.forEach((r, txnIdx) => {
            const isFirstRef = prodIdx === 0 && txnIdx === 0;
            const isFirstProd = txnIdx === 0;
            const txnBorderBottom = (txnIdx === prodGroup.transactions.length - 1) ? "border-bottom: 1px solid #198754;" : "border-bottom: 1px solid #e2e8f0;";

            let processColsHtml = "";
            if (uniqueActiveProcesses.length === 0) {
              processColsHtml += `<td style="text-align: center; color: #a0aec0; ${txnBorderBottom}">-</td>`;
            } else {
              uniqueActiveProcesses.forEach((proc, pIdx) => {
                const matches = isProcessInRow(proc.id, r.processId);
                const isLast = pIdx === uniqueActiveProcesses.length - 1;
                const borderRight = isLast ? "" : "border-right: 1px solid #198754 !important;";
                if (matches) {
                  const cellWeight = Number(r.outward_weight) || 0;
                  processColsHtml += `<td style="text-align: right; font-weight: 500; white-space: nowrap; ${borderRight} ${txnBorderBottom}">${fmtWeightCell(cellWeight)}</td>`;
                } else {
                  processColsHtml += `<td style="text-align: center; color: #a0aec0; white-space: nowrap; ${borderRight} ${txnBorderBottom}">-</td>`;
                }
              });
            }

            reportRowsHtml += `<tr>`;
            if (isFirstRef) {
              reportRowsHtml += `
                <td rowspan="${refGroup.rowSpan}" style="font-weight: 600; white-space: nowrap; vertical-align: middle; text-align: left; border-bottom: 1px solid #198754;">${refGroup.ref}</td>
                <td rowspan="${refGroup.rowSpan}" style="white-space: nowrap; vertical-align: middle; text-align: left; border-bottom: 1px solid #198754;">${refGroup.inward_date}</td>
              `;
            }
            if (isFirstProd) {
              reportRowsHtml += `
                <td rowspan="${prodGroup.rowSpan}" style="font-weight: 600; text-align: left; vertical-align: middle; border-bottom: 1px solid #198754;">${prodGroup.productName}</td>
                <td rowspan="${prodGroup.rowSpan}" style="text-align: right; white-space: nowrap; vertical-align: middle; border-bottom: 1px solid #198754;">${fmtCell(prodGroup.inward_qty, formatQty)}</td>
                <td rowspan="${prodGroup.rowSpan}" style="text-align: right; font-weight: 600; white-space: nowrap; vertical-align: middle; border-right: 2px solid #0f5132 !important; border-bottom: 1px solid #198754;">${fmtWeightCell(prodGroup.inward_weight)}</td>
              `;
            }

            reportRowsHtml += `
              <td style="font-weight: 600; white-space: nowrap; ${txnBorderBottom}">${r.outward_no}</td>
              <td style="white-space: nowrap; ${txnBorderBottom}">${r.outward_date}</td>
              <td style="text-align: right; white-space: nowrap; ${txnBorderBottom}">${fmtCell(r.outward_qty, formatQty)}</td>
              <td style="text-align: right; font-weight: 600; white-space: nowrap; border-right: 2px solid #0f5132 !important; ${txnBorderBottom}">${fmtWeightCell(r.outward_weight)}</td>
              ${processColsHtml}
            </tr>`;
          });
        });
      });

      let processTotalsHtml = "";
      if (uniqueActiveProcesses.length === 0) {
        processTotalsHtml += `<td style="text-align: center; color: #0f5132; font-weight: 700;">-</td>`;
      } else {
        uniqueActiveProcesses.forEach((proc, idx) => {
          const isLast = idx === uniqueActiveProcesses.length - 1;
          const borderStyle = isLast ? "" : "border-right: 1px solid #198754 !important;";
          const finalVal = (processTotals[proc.id] || 0) * weightScaleFactor;
          processTotalsHtml += `
            <td style="text-align: right; font-weight: 700; color: #0f5132; white-space: nowrap; ${borderStyle}">
              ${formatWeight(finalVal)} kg
            </td>
          `;
        });
      }

      reportRowsHtml += `
        <tr class="total-row" style="background-color: #f0fdf4 !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important;">
          <td colspan="3" style="text-align: right; font-weight: 700; color: #0f5132;">Total</td>
          <td style="text-align: right; font-weight: 700; color: #0f5132;"></td>
          <td style="text-align: right; font-weight: 700; color: #0f5132; border-right: 2px solid #0f5132 !important;"></td>
          <td></td>
          <td></td>
          <td style="text-align: right; font-weight: 700; color: #0f5132;"></td>
          <td style="text-align: right; font-weight: 700; color: #0f5132; border-right: 2px solid #0f5132 !important;"></td>
          ${processTotalsHtml}
        </tr>`;
    }

    const processingColSpan = uniqueActiveProcesses.length || 1;
    const superHeaderHtml = `
      <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
        <th colspan="5" style="text-align: center; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">INWARD DETAILS</th>
        <th colspan="4" style="text-align: center; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">OUTWARD DETAILS</th>
        <th colspan="${processingColSpan}" style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">PROCESSING</th>
      </tr>
    `;

    let subHeaderHtml = `
      <tr style="background-color: #0f5132 !important; color: #ffffff !important;">
        <th style="text-align: left; background-color: #0f5132 !important; color: #ffffff !important;">INWARD<br/>REF NO</th>
        <th style="text-align: left; background-color: #0f5132 !important; color: #ffffff !important;">DATE</th>
        <th style="text-align: left; background-color: #0f5132 !important; color: #ffffff !important;">PRODUCT</th>
        <th style="text-align: right; width: 60px; background-color: #0f5132 !important; color: #ffffff !important;">QTY</th>
        <th style="text-align: right; width: 90px; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">WEIGHT</th>
        <th style="text-align: left; background-color: #0f5132 !important; color: #ffffff !important;">OUTWARD<br/>NO</th>
        <th style="text-align: left; background-color: #0f5132 !important; color: #ffffff !important;">DATE</th>
        <th style="text-align: right; width: 60px; background-color: #0f5132 !important; color: #ffffff !important;">QTY</th>
        <th style="text-align: right; width: 90px; border-right: 2.5px solid #ffffff !important; background-color: #0f5132 !important; color: #ffffff !important;">WEIGHT</th>
    `;

    if (uniqueActiveProcesses.length === 0) {
      subHeaderHtml += `<th style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">PROCESS WEIGHT</th>`;
    } else {
      uniqueActiveProcesses.forEach((proc, idx) => {
        const isLast = idx === uniqueActiveProcesses.length - 1;
        const borderStyle = isLast ? "" : "border-right: 1px solid rgba(255,255,255,0.3) !important;";
        subHeaderHtml += `
          <th style="text-align: center; background-color: #0f5132 !important; color: #ffffff !important; ${borderStyle}">
            ${proc.name.toUpperCase()}<br/>WEIGHT
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
            table.items-table { border-collapse: collapse; width: 100%; border: 1.5px solid #0f5132 !important; }
            table.items-table th, table.items-table td { border: 1px solid #198754 !important; padding: 6px 8px !important; }
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
              <h3>CUSTOMER DETAILS:</h3>
              <div class="name">${customerName}</div>
              ${customerAddr1 ? `<div class="address-lines">${customerAddr1}</div>` : ""}
              ${customerCityStatePin ? `<div class="address-lines">${customerCityStatePin}</div>` : ""}
              ${customerPhone ? `<div class="address-lines">${customerPhone}</div>` : ""}
              ${customerGstin ? `<div class="gstin">GSTIN: ${customerGstin}</div>` : ""}
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

  const handleExportJobWorkDetailsExcel = (row: any) => {
    const data = buildJobWorkDetailsReportData(row);
    if (!data) return;
    const {
      cName, customerName, customerGstin, dateStr,
      uniqueActiveProcesses, scaledReportRows, processTotals, isProcessInRow, weightScaleFactor
    } = data;

    const excelRows: any[][] = [
      [cName],
      ["JOB WORK DETAILS"],
      [`Bill No: ${row.bill_no}`, `Date: ${dateStr}`],
      [`Customer: ${customerName} ${customerGstin ? `(${customerGstin})` : ""}`],
      [],
    ];

    // Super Header row
    const superHeader = [
      "INWARD DETAILS", "", "", "", "",
      "OUTWARD DETAILS", "", "", ""
    ];
    if (uniqueActiveProcesses.length === 0) {
      superHeader.push("PROCESSING");
    } else {
      superHeader.push("PROCESSING");
      for (let i = 1; i < uniqueActiveProcesses.length; i++) {
        superHeader.push("");
      }
    }
    excelRows.push(superHeader);

    // Sub Header row
    const subHeader = [
      "INWARD REF NO", "DATE", "PRODUCT", "QTY", "WEIGHT (kg)",
      "OUTWARD NO", "DATE", "QTY", "WEIGHT (kg)"
    ];
    if (uniqueActiveProcesses.length === 0) {
      subHeader.push("PROCESS WEIGHT (kg)");
    } else {
      uniqueActiveProcesses.forEach((proc: any) => {
        subHeader.push(`${proc.name.toUpperCase()} (kg)`);
      });
    }
    excelRows.push(subHeader);

    const toExcelNum = (val: any): number | string => {
      if (val === null || val === undefined || val === "" || val === "-") return "-";
      const num = typeof val === "number" ? val : Number(String(val).replace(/,/g, ""));
      if (isNaN(num)) return "-";
      return Number(num.toFixed(3));
    };

    const seenForXlsRender = new Set<string>();
    let lastInwIdForXlsRender: any = null;
    let lastRefForXlsRender = "";
    scaledReportRows.forEach((r) => {
      let isDuplicateItem = false;
      if (r.inward_qty !== null && r.inward_weight !== null) {
        const key = `${r.inward_id}_${r.ref}_${r.productName}_${r.inward_qty}_${r.inward_weight}`;
        isDuplicateItem = seenForXlsRender.has(key);
        seenForXlsRender.add(key);
      }
      
      const isSameInward = r.inward_id !== undefined && r.inward_id !== null ? (r.inward_id === lastInwIdForXlsRender) : (r.ref === lastRefForXlsRender);
      lastInwIdForXlsRender = r.inward_id;
      lastRefForXlsRender = r.ref;

      const displayRef = isDuplicateItem || isSameInward ? "" : r.ref;
      const displayDate = isDuplicateItem || isSameInward ? "" : r.inward_date;
      const displayProd = isDuplicateItem ? "" : r.productName;
      const displayInwQty = isDuplicateItem ? null : r.inward_qty;
      const displayInwWeight = isDuplicateItem ? null : r.inward_weight;

      const rowData: any[] = [
        displayRef,
        displayDate,
        displayProd,
        toExcelNum(displayInwQty),
        toExcelNum(displayInwWeight),
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
            const cellWeight = Number(r.outward_weight) || 0;
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
      "",
      "",
      "", "",
      "",
      ""
    ];
    if (uniqueActiveProcesses.length === 0) {
      totalRow.push("-");
    } else {
      uniqueActiveProcesses.forEach((proc: any) => {
        const finalVal = (processTotals[proc.id] || 0) * (weightScaleFactor || 1);
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
    XLSX.writeFile(wb, `JobWorkDetails_${safeBillNo}.xlsx`);
  };

  const colDefs: ColDef[] = [
    { field: "bill_no", headerName: "Bill No.", width: 120 },
    { field: "bill_date", headerName: "Date", width: 100 },
    { field: "ledger_id", headerName: "Customer", width: 220, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.customer_name || "" },
    {
      field: "quantity",
      headerName: "Weight",
      width: 90,
      type: "numericColumn",
      valueGetter: (p) => getBillShotBlastingWeight(p.data, processMapObj, processes),
      valueFormatter: (p) => formatWeight(p.value)
    },
    {
      field: "total_amount",
      headerName: "Total Amount",
      width: 140,
      type: "numericColumn",
      valueFormatter: (p) => `₹${formatAmount(p.value || p.data?.net_amount)}`
    },
    {
      field: "is_paid",
      headerName: "Status",
      width: 100,
      cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Paid" : "Pending"} color={p.value ? "success" : "warning"} />
    },
    {
      headerName: "Actions",
      width: 200,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
          <WorkDetailsActionMenu
            row={p.data}
            onPrint={handlePrintJobWorkDetails}
            onExportExcel={handleExportJobWorkDetailsExcel}
          />
          <Tooltip title="Print Bill"><IconButton size="small" onClick={() => handlePrintJobWorkBill(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
          {!p.data.is_paid && <Tooltip title="Mark Paid"><IconButton size="small" color="success" onClick={() => markPaidMutation.mutate(p.data.id)}><CheckCircle fontSize="small" /></IconButton></Tooltip>}
          <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
          <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => { if (window.confirm(`Delete Job Work bill "${p.data.bill_no}"?`)) deleteMutation.mutate(p.data.id); }}><Delete fontSize="small" /></IconButton></Tooltip>
        </Box>
      )
    },
  ];

  return (
    <Box>
      <PageHeader
        title="Job Work Bill"
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

      <JobWorkBillDialog
        open={open}
        onClose={() => setOpen(false)}
        editing={editing}
      />
    </Box>
  );
}

export const resolveLeafProcessIds = (processIdOrCode: any, processesList: any[]): number[] => {
  if (!processIdOrCode) return [];
  const str = String(processIdOrCode).trim();
  if (!str) return [];

  if (str.includes(",")) {
    const parts = str.split(",").map((s) => s.trim()).filter(Boolean);
    const leafSet = new Set<number>();
    parts.forEach((p) => {
      resolveLeafProcessIds(p, processesList).forEach((id) => leafSet.add(id));
    });
    return Array.from(leafSet);
  }

  const numId = Number(str);
  const proc = !isNaN(numId)
    ? processesList.find((p: any) => p.id === numId)
    : processesList.find((p: any) => p.process_code === str || p.name === str);

  if (!proc) {
    return !isNaN(numId) && numId > 0 ? [numId] : [];
  }

  // 1. Composite process defined with process_ids field (e.g. "1, 2")
  if (proc.process_ids && String(proc.process_ids).trim() !== "") {
    const childIds = String(proc.process_ids).split(",").map((s: string) => s.trim()).filter(Boolean);
    const leafSet = new Set<number>();
    childIds.forEach((cid: string) => {
      resolveLeafProcessIds(cid, processesList).forEach((id) => leafSet.add(id));
    });
    if (leafSet.size > 0) return Array.from(leafSet);
  }

  // 2. Composite process defined with process_code containing "/" (e.g. "SB / FET")
  if (proc.process_code && proc.process_code.includes("/")) {
    const parts = proc.process_code.split("/").map((s: string) => s.trim()).filter(Boolean);
    const leafSet = new Set<number>();
    parts.forEach((part: string) => {
      const childProc = processesList.find((p: any) => p.process_code === part || p.name?.toLowerCase() === part.toLowerCase());
      if (childProc) {
        resolveLeafProcessIds(childProc.id, processesList).forEach((id) => leafSet.add(id));
      }
    });
    if (leafSet.size > 0) return Array.from(leafSet);
  }

  return [proc.id];
};

export const getProcessOrderRank = (procId: any, procList: any[] = []): number => {
  if (!procId) return 99;
  const proc = procList.find((p: any) => p.id === Number(procId));
  const name = (proc?.name || proc?.process_code || resolveProcessName(procId, procList) || "").toLowerCase();
  if (name.includes("shot") || name.includes("blast")) return 1;
  if (name.includes("fettl")) return 2;
  if (name.includes("paint") || name.includes("dipp") || name.includes("gp")) return 3;
  return 10;
};

interface JobWorkBillDialogProps {
  open: boolean;
  onClose: () => void;
  editing: any;
}

function JobWorkBillDialog({ open, onClose, editing }: JobWorkBillDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [selectedInwards, setSelectedInwards] = useState<any[]>([]);
  const [lineItems, setLineItems] = useState<any[]>([
    { product_id: "", process_id: "", quantity: "", rate: "", amount: "" }
  ]);
  const [freightOpen, setFreightOpen] = useState(false);
  const [freightItem, setFreightItem] = useState<any>({ process_id: "", quantity: "", rate: "", amount: "" });
  const [missingRatesWarning, setMissingRatesWarning] = useState<string[]>([]);

  const initialRawWeightRef = useRef<number>(0);
  const initialLineItemsRef = useRef<any[]>([]);

  const { data: bills = [] } = useQuery<any[]>({
    queryKey: ["job-work-bills", activeFY],
    queryFn: async () => (await api.get(`/job-work-bills/?fy=${activeFY}`)).data,
    enabled: open
  });
  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers-all"],
    queryFn: async () => (await api.get("/ledgers/")).data,
  });
  const { data: products = [] } = useQuery({ queryKey: ["products"], queryFn: async () => (await api.get("/products/")).data });
  const { data: processes = [] } = useQuery({ queryKey: ["processes"], queryFn: async () => (await api.get("/products/processes/all")).data });
  const { data: outwardVouchers = [] } = useQuery<any>({
    queryKey: ["outward-vouchers"],
    queryFn: async () => (await api.get(`/stock/outward?fy=${activeFY}`)).data,
    enabled: open
  });
  const { data: inwardVouchers = [] } = useQuery<any>({
    queryKey: ["inward-vouchers-list", activeFY],
    queryFn: async () => (await api.get(`/stock/inward?fy=${activeFY}`)).data,
    enabled: open
  });

  const billedOutwardIdsSet = useMemo(() => {
    const set = new Set<number>();
    bills.forEach((b: any) => {
      if (editing && b.id === editing.id) return;
      const oids = Array.isArray(b.outward_ids)
        ? b.outward_ids
        : (typeof b.outward_ids === "string" ? (() => { try { return JSON.parse(b.outward_ids); } catch { return []; } })() : []);
      (oids || []).forEach((id: number) => { if (id) set.add(Number(id)); });
    });
    return set;
  }, [bills, editing]);

  const billedInwardIdsSet = useMemo(() => {
    const set = new Set<number>();
    bills.forEach((b: any) => {
      if (editing && b.id === editing.id) return;
      if (b.inward_id) set.add(Number(b.inward_id));
      const iids = Array.isArray(b.inward_ids)
        ? b.inward_ids
        : (typeof b.inward_ids === "string" ? (() => { try { return JSON.parse(b.inward_ids); } catch { return []; } })() : []);
      (iids || []).forEach((id: number) => { if (id) set.add(Number(id)); });
    });
    return set;
  }, [bills, editing]);

  const ledgerMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const processMapObj = useMemo(() => {
    const map: Record<number | string, any> = {};
    processes.forEach((p: any) => { map[p.id] = p; });
    return map;
  }, [processes]);

  const today = new Date().toISOString().split("T")[0];

  const { register, handleSubmit, reset, watch, setValue, control } = useForm({
    defaultValues: { bill_no: "", bill_date: today, ledger_id: "", gst_percent: "" as any, narration: "", dispatch_through: "" },
  });

  const selectedLedger = watch("ledger_id");

  const customerOutwardVouchers = useMemo(() => {
    if (!selectedLedger) return [];
    return outwardVouchers.filter((v: any) => v.ledger_id === Number(selectedLedger));
  }, [outwardVouchers, selectedLedger]);

  // STRICT Inward filtering:
  // 1. Belongs to selected customer
  // 2. Corresponding outward transactions are 100% completed (balance <= 0)
  // 3. Has NOT already been billed in any Job Work Bill
  const eligibleInwardNumbers = useMemo(() => {
    if (!selectedLedger) return [];
    const customerInwards = inwardVouchers.filter((inv: any) => inv.ledger_id === Number(selectedLedger));

    return customerInwards
      .map((inv: any) => {
        // Exclude if already billed in another bill
        if (billedInwardIdsSet.has(inv.id)) return null;

        const linkedOutwards = customerOutwardVouchers.filter((out: any) => isOutwardLinkedToInward(out, inv.id));
        const outwardCount = linkedOutwards.length;
        if (outwardCount === 0) return null;

        // Inward balance check:
        let totalInwQty = Number(inv.quantity || 0);
        const rawInwItems = Array.isArray(inv.items)
          ? inv.items
          : (typeof inv.items === "string" ? (() => { try { return JSON.parse(inv.items); } catch { return []; } })() : []);
        if (rawInwItems.length > 0) {
          totalInwQty = rawInwItems.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
        }

        let isFullyCompleted = false;
        if (inv.balance_qty !== undefined && inv.balance_qty !== null) {
          isFullyCompleted = Number(inv.balance_qty) <= 0.001;
        } else {
          let totalOutQty = 0;
          linkedOutwards.forEach((out: any) => {
            const outItems = Array.isArray(out.items)
              ? out.items
              : (typeof out.items === "string" ? (() => { try { return JSON.parse(out.items); } catch { return []; } })() : []);
            if (outItems.length > 0) {
              const tagged = outItems.filter((it: any) => Number(it.inward_id) === inv.id);
              if (tagged.length > 0) {
                totalOutQty += tagged.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
              } else {
                const outInwardIds = Array.isArray(out.inward_ids)
                  ? out.inward_ids
                  : (typeof out.inward_ids === "string" ? (() => { try { return JSON.parse(out.inward_ids); } catch { return []; } })() : []);
                if (outInwardIds.length <= 1) {
                  totalOutQty += outItems.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
                } else {
                  const prodIds = new Set(rawInwItems.map((it: any) => Number(it.product_id)).concat(inv.product_id ? [Number(inv.product_id)] : []));
                  const matched = outItems.filter((it: any) => prodIds.has(Number(it.product_id)));
                  totalOutQty += matched.reduce((s: number, it: any) => s + (Number(it.quantity) || 0), 0);
                }
              }
            } else {
              totalOutQty += Number(out.quantity || 0);
            }
          });
          const balQty = Math.max(0, totalInwQty - totalOutQty);
          isFullyCompleted = balQty <= 0.001;
        }

        if (!isFullyCompleted) return null;

        const outwardNos = linkedOutwards.map((o: any) => o.outward_no || `#${o.id}`).filter(Boolean).join(", ");
        return {
          ...inv,
          linkedOutwards,
          outwardNos,
          isOutwardCompleted: true,
        };
      })
      .filter(Boolean);
  }, [inwardVouchers, selectedLedger, customerOutwardVouchers, billedInwardIdsSet]);

  const selectedOutwards = useMemo(() => {
    const all: any[] = [];
    selectedInwards.forEach((inw: any) => {
      const outs = (inw.linkedOutwards && inw.linkedOutwards.length > 0)
        ? inw.linkedOutwards
        : customerOutwardVouchers.filter((out: any) => isOutwardLinkedToInward(out, inw.id));
      outs.forEach((out: any) => {
        if (!all.find((o) => o.id === out.id)) all.push(out);
      });
    });
    return all;
  }, [selectedInwards, customerOutwardVouchers]);

  const [enableRoundOff, setEnableRoundOff] = useState(true);

  // Single source of truth for rate: Process Register master (company_rate)
  const getCompanyRate = (processId: any): { rate: number; found: boolean; name: string } => {
    const proc = processes.find((p: any) => p.id === Number(processId));
    if (!proc) return { rate: 0, found: false, name: `Process #${processId}` };
    const r = Number(proc.company_rate || 0);
    return { rate: r, found: r > 0, name: proc.name };
  };

  const getShotBlastingWeight = (itemsList?: any[]) => {
    const list = itemsList || lineItems;
    const shotItems = list.filter((item: any) => {
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
    return Number(list[0]?.quantity) || 0;
  };

  const computeRawWeightForInwardsList = useCallback((inws: any[]) => {
    if (!inws || inws.length === 0) return 0;
    let totalRawWeight = 0;
    inws.forEach((inw: any) => {
      let items: any[] = [];
      if (typeof inw.items === "string") {
        try { items = JSON.parse(inw.items); } catch { items = []; }
      } else if (Array.isArray(inw.items)) {
        items = inw.items;
      }

      if (items && items.length > 0) {
        items.forEach((item: any) => {
          if (item.total_weight !== undefined && item.total_weight !== null && item.total_weight !== "") {
            totalRawWeight += Number(item.total_weight);
          } else if (item.weight !== undefined && item.weight !== null && item.weight !== "") {
            totalRawWeight += Number(item.weight) * (Number(item.quantity) || 1);
          }
        });
      } else {
        if (inw.total_weight !== undefined && inw.total_weight !== null && inw.total_weight !== "") {
          totalRawWeight += Number(inw.total_weight);
        } else if (inw.weight !== undefined && inw.weight !== null && inw.weight !== "") {
          totalRawWeight += Number(inw.weight) * (Number(inw.quantity) || 1);
        }
      }
    });
    return totalRawWeight;
  }, []);

  // Strict inward-to-outward process derivation
  const handleInwardSelectionChange = (newSelected: any[]) => {
    setSelectedInwards(newSelected);
    setMissingRatesWarning([]);

    if (newSelected.length === 0) {
      setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
      return;
    }

    const parseItems = (x: any): any[] => {
      if (typeof x === "string") {
        try { return JSON.parse(x); } catch (e) { return []; }
      }
      return Array.isArray(x) ? x : [];
    };

    const missingList: string[] = [];
    const globalProcessWeights = new Map<number, number>();

    newSelected.forEach((inw: any) => {
      const outs = customerOutwardVouchers.filter((out: any) => isOutwardLinkedToInward(out, inw.id));
      const rawInwItems = parseItems(inw.items);

      let inwTotalWeight = 0;
      if (rawInwItems && rawInwItems.length > 0) {
        inwTotalWeight = rawInwItems.reduce((acc: number, it: any) => {
          const w = (it.total_weight !== undefined && it.total_weight !== null && it.total_weight !== "")
            ? Number(it.total_weight)
            : (it.weight !== undefined && it.weight !== null && it.weight !== "")
            ? Number(it.weight) * (Number(it.quantity) || 1)
            : (Number(it.quantity) || 0);
          return acc + (isNaN(w) ? 0 : w);
        }, 0);
      } else {
        inwTotalWeight = (inw.total_weight !== undefined && inw.total_weight !== null && inw.total_weight !== "")
          ? Number(inw.total_weight)
          : (inw.weight !== undefined && inw.weight !== null && inw.weight !== "")
          ? Number(inw.weight) * (Number(inw.quantity) || 1)
          : (Number(inw.quantity) || 0);
      }

      // Track completed outward process weights specifically for this inward
      const inwProcWeightMap = new Map<number, number>();

      outs.forEach((out: any) => {
        const outLines = parseItems(out.items);
        const taggedLines = outLines.filter((l: any) => Number(l.inward_id) === inw.id);

        if (taggedLines.length > 0) {
          // Exactly tagged outward lines for this inward
          taggedLines.forEach((l: any) => {
            const lineWeight = (l.total_weight !== undefined && l.total_weight !== null && l.total_weight !== "")
              ? Number(l.total_weight)
              : (l.weight !== undefined && l.weight !== null && l.weight !== "")
              ? Number(l.weight) * (Number(l.quantity) || 1)
              : (Number(l.quantity) || 0);
            const procRef = l.process_id || out.process_id || inw.process_id;
            const leafIds = resolveLeafProcessIds(procRef, processes);
            leafIds.forEach((leafId: number) => {
              inwProcWeightMap.set(leafId, (inwProcWeightMap.get(leafId) || 0) + lineWeight);
            });
          });
        } else if (outLines.length > 0) {
          const outInwardIds = Array.isArray(out.inward_ids)
            ? out.inward_ids
            : (typeof out.inward_ids === "string" ? (() => { try { return JSON.parse(out.inward_ids); } catch { return []; } })() : []);
          const isSoleInward = outInwardIds.length <= 1;

          if (isSoleInward) {
            outLines.forEach((l: any) => {
              const lineWeight = (l.total_weight !== undefined && l.total_weight !== null && l.total_weight !== "")
                ? Number(l.total_weight)
                : (l.weight !== undefined && l.weight !== null && l.weight !== "")
                ? Number(l.weight) * (Number(l.quantity) || 1)
                : (Number(l.quantity) || 0);
              const procRef = l.process_id || out.process_id || inw.process_id;
              const leafIds = resolveLeafProcessIds(procRef, processes);
              leafIds.forEach((leafId: number) => {
                inwProcWeightMap.set(leafId, (inwProcWeightMap.get(leafId) || 0) + lineWeight);
              });
            });
          } else {
            const inwProdIds = new Set(rawInwItems.map((it: any) => Number(it.product_id)).concat(inw.product_id ? [Number(inw.product_id)] : []));
            const matchedLines = outLines.filter((l: any) => inwProdIds.has(Number(l.product_id)));
            const linesToProcess = matchedLines.length > 0 ? matchedLines : outLines;
            linesToProcess.forEach((l: any) => {
              const lineWeight = (l.total_weight !== undefined && l.total_weight !== null && l.total_weight !== "")
                ? Number(l.total_weight)
                : (l.weight !== undefined && l.weight !== null && l.weight !== "")
                ? Number(l.weight) * (Number(l.quantity) || 1)
                : (Number(l.quantity) || 0);
              const procRef = l.process_id || out.process_id || inw.process_id;
              const leafIds = resolveLeafProcessIds(procRef, processes);
              leafIds.forEach((leafId: number) => {
                inwProcWeightMap.set(leafId, (inwProcWeightMap.get(leafId) || 0) + lineWeight);
              });
            });
          }
        } else {
          // Outward has no line items, use header total_weight and process_id
          const outWeight = (out.total_weight !== undefined && out.total_weight !== null && out.total_weight !== "")
            ? Number(out.total_weight)
            : (out.weight !== undefined && out.weight !== null && out.weight !== "")
            ? Number(out.weight) * (Number(out.quantity) || 1)
            : (Number(out.quantity) || 0);
          const procRef = out.process_id || inw.process_id;
          const leafIds = resolveLeafProcessIds(procRef, processes);
          leafIds.forEach((leafId: number) => {
            inwProcWeightMap.set(leafId, (inwProcWeightMap.get(leafId) || 0) + outWeight);
          });
        }
      });

      // Safety clamp: No process for this inward can exceed the received material weight of this inward
      inwProcWeightMap.forEach((w, leafId) => {
        const billableWeight = inwTotalWeight > 0 ? Math.min(w, inwTotalWeight) : w;
        globalProcessWeights.set(leafId, (globalProcessWeights.get(leafId) || 0) + billableWeight);
      });
    });

    // Anchor Shotblasting to total received inward weight (resolving the 93.76 kg weighment tare variation)
    const totalRawInwardWeight = computeRawWeightForInwardsList(newSelected);
    if (totalRawInwardWeight > 0) {
      globalProcessWeights.forEach((_, leafId) => {
        const proc = processes.find((p: any) => p.id === leafId);
        const name = (proc?.name || proc?.process_code || resolveProcessName(leafId, processes) || "").toLowerCase();
        if (name.includes("shot") || name.includes("blast")) {
          globalProcessWeights.set(leafId, totalRawInwardWeight);
        }
      });
    }

    const newItems: any[] = [];
    globalProcessWeights.forEach((totalProcWeight, leafId) => {
      const proc = processes.find((p: any) => p.id === leafId);
      const { rate, found, name } = getCompanyRate(leafId);
      if (!found) missingList.push(name);
      if (proc && proc.gst_percent !== undefined && proc.gst_percent !== null) {
        setValue("gst_percent", proc.gst_percent);
      }
      const roundedQty = Number(totalProcWeight.toFixed(3));
      newItems.push({
        product_id: "",
        process_id: leafId,
        quantity: roundedQty.toFixed(3),
        rate,
        amount: Number((roundedQty * rate).toFixed(2))
      });
    });

    // Enforce strict order: 1. Shotblasting, 2. Fettling, 3. GP Painting, 4. Others
    newItems.sort((a: any, b: any) => {
      const rankA = getProcessOrderRank(a.process_id, processes);
      const rankB = getProcessOrderRank(b.process_id, processes);
      if (rankA !== rankB) return rankA - rankB;
      const nameA = (resolveProcessName(a.process_id, processes) || "").toLowerCase();
      const nameB = (resolveProcessName(b.process_id, processes) || "").toLowerCase();
      return nameA.localeCompare(nameB);
    });

    if (missingList.length > 0) {
      setMissingRatesWarning(Array.from(new Set(missingList)));
    }

    if (newItems.length === 0) {
      setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
      return;
    }

    setLineItems(newItems);

    // Keep freight item weight synchronized if already configured
    const newShotWeight = getShotBlastingWeight(newItems);
    setFreightItem((prev: any) => {
      if (!prev.process_id) return prev;
      const q = newShotWeight.toFixed(3);
      const amt = Number((newShotWeight * Number(prev.rate || 0)).toFixed(2));
      return {
        ...prev,
        quantity: q,
        amount: amt
      };
    });
  };

  const handleSupplierChange = () => {
    handleInwardSelectionChange([]);
  };

  const handleFreightChange = (field: string, value: any) => {
    setFreightItem((prev: any) => {
      const updated = { ...prev, [field]: value };
      if (field === "process_id") {
        updated.quantity = getShotBlastingWeight().toFixed(3);
        const { rate } = getCompanyRate(value);
        updated.rate = rate;
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

  const initRef = useRef<any>(null);

  useEffect(() => {
    if (open) {
      const currentInit = editing ? editing.id : "new";
      if (initRef.current === currentInit) return;
      initRef.current = currentInit;

      if (editing) {
        const outwardIdList = (() => {
          const ids = editing.outward_ids || [];
          if (!Array.isArray(ids)) return [];
          return ids.map((id: number) => outwardVouchers.find((v: any) => v.id === id)).filter(Boolean);
        })();

        const matchedInwardIds = new Set<number>();
        if (editing.inward_id) matchedInwardIds.add(editing.inward_id);
        if (editing.inward_ids) {
          const rawInwIds = Array.isArray(editing.inward_ids)
            ? editing.inward_ids
            : (typeof editing.inward_ids === "string" ? (() => { try { return JSON.parse(editing.inward_ids); } catch { return []; } })() : []);
          rawInwIds.forEach((id: number) => matchedInwardIds.add(Number(id)));
        }
        if (matchedInwardIds.size === 0) {
          outwardIdList.forEach((out: any) => {
            if (out.inward_id) matchedInwardIds.add(out.inward_id);
            if (Array.isArray(out.inward_ids)) out.inward_ids.forEach((id: number) => matchedInwardIds.add(id));
          });
        }
        const matchedInws = inwardVouchers.filter((inv: any) => matchedInwardIds.has(inv.id));
        setSelectedInwards(matchedInws);

        let parsedItems: any[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }

        let loadedLineItems: any[] = [];
        if (parsedItems && parsedItems.length > 0) {
          loadedLineItems = parsedItems.map((item: any) => ({
            ...item,
            quantity: item.quantity !== undefined && item.quantity !== "" && item.quantity !== null ? Number(item.quantity).toFixed(3) : ""
          }));
        } else {
          loadedLineItems = [{
            product_id: editing.product_id || "",
            process_id: editing.process_id || "",
            quantity: editing.quantity !== undefined && editing.quantity !== "" && editing.quantity !== null ? Number(editing.quantity).toFixed(3) : "",
            rate: editing.rate || "",
            amount: editing.amount || ""
          }];
        }
        if (loadedLineItems.length > 1) {
          loadedLineItems.sort((a: any, b: any) => {
            const rankA = getProcessOrderRank(a.process_id, processes);
            const rankB = getProcessOrderRank(b.process_id, processes);
            if (rankA !== rankB) return rankA - rankB;
            const nameA = (resolveProcessName(a.process_id, processes) || "").toLowerCase();
            const nameB = (resolveProcessName(b.process_id, processes) || "").toLowerCase();
            return nameA.localeCompare(nameB);
          });
        }
        setLineItems(loadedLineItems);
        initialLineItemsRef.current = loadedLineItems;
        initialRawWeightRef.current = computeRawWeightForInwardsList(matchedInws);

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
        setMissingRatesWarning([]);
        initialLineItemsRef.current = [];
        initialRawWeightRef.current = 0;

        reset({
          bill_no: "",
          bill_date: today,
          ledger_id: "",
          gst_percent: "" as any,
          narration: "",
          dispatch_through: ""
        });

        api.get("/sequences/preview/job_work_bill")
          .then((res) => {
            setValue("bill_no", res.data.next_no);
          })
          .catch(() => {
            // Sequence fallback
            setValue("bill_no", "");
          });
      }
    } else {
      initRef.current = null;
    }
  }, [open, editing, reset, setValue, outwardVouchers, inwardVouchers, computeRawWeightForInwardsList]);

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
        ? api.put(`/job-work-bills/${editing.id}?fy=${activeFY}`, payload)
        : api.post(`/job-work-bills/?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["job-work-bills"] });
      onClose();
    },
    onError: (error: any) => {
      const detailMsg = error.response?.data?.detail;
      const msg = typeof detailMsg === "string" ? detailMsg : (detailMsg ? JSON.stringify(detailMsg) : "Failed to save Job Work Bill.");
      alert(msg);
    }
  });

  const handleKeyDown = (e: React.KeyboardEvent<HTMLFormElement>) => {
    if (e.key === "Enter") {
      const active = document.activeElement as HTMLElement;
      if (active && (active.tagName === "BUTTON" || active.tagName === "TEXTAREA")) return;
      e.preventDefault();
      const form = e.currentTarget;
      const focusable = Array.from(
        form.querySelectorAll(
          'input:not([disabled]):not([readonly]), select:not([disabled]), textarea:not([disabled]), [tabindex="0"]:not([disabled])'
        )
      ) as HTMLElement[];
      const index = focusable.indexOf(active);
      if (index > -1 && focusable[index + 1]) {
        focusable[index + 1].focus();
      }
    }
  };

  const hasMissingRates = missingRatesWarning.length > 0;

  return (
    <>
      <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))} onKeyDown={handleKeyDown}>
          <DialogTitle sx={{ fontWeight: 700, color: "#023020" }}>
            {editing ? "Edit Job Work Bill" : "New Job Work Bill"}
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
                <Controller
                  name="ledger_id"
                  control={control}
                  rules={{ required: "Customer is required" }}
                  render={({ field, fieldState }) => {
                    const val: any = field.value;
                    const rawLedgerId = val && typeof val === "object" ? val.id : val;
                    const currentLedger = (rawLedgerId !== undefined && rawLedgerId !== null && rawLedgerId !== "")
                      ? (ledgers.find((l: any) => String(l.id) === String(rawLedgerId)) || (rawLedgerId ? ledgerMapObj[rawLedgerId] : null) || (val && typeof val === "object" ? val : null))
                      : null;

                    return (
                      <Autocomplete
                        size="small"
                        openOnFocus
                        options={ledgers}
                        value={currentLedger}
                        onChange={(_, v: any) => {
                          const selectedObj = typeof v === "object" && v !== null ? v : (v ? ledgers.find((l: any) => String(l.id) === String(v)) : null);
                          const newLedgerId = selectedObj ? selectedObj.id : "";
                          field.onChange(newLedgerId);
                          handleSupplierChange();
                        }}
                        getOptionLabel={(option: any) => (option && typeof option === "object" ? option.name : "") || ""}
                        isOptionEqualToValue={(option: any, v: any) => {
                          if (!option || !v) return option === v;
                          const optId = typeof option === "object" ? option.id : option;
                          const valId = typeof v === "object" ? v.id : v;
                          return String(optId) === String(valId);
                        }}
                        noOptionsText="No matching customers"
                        renderInput={(params) => (
                          <TextField
                            {...params}
                            label="Customer / Company *"
                            required={!field.value}
                            error={!!fieldState.error}
                            helperText={fieldState.error?.message}
                          />
                        )}
                      />
                    );
                  }}
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
                    noOptionsText="No fully completed Inwards are available for Job Work Billing."
                    renderInput={(params: any) => (
                      <TextField
                        {...params}
                        label="Select Eligible Inward Number(s) *"
                        placeholder="Tick checkboxes to select inward numbers..."
                        helperText={`${eligibleInwardNumbers.length} completed inward record(s) available — only fully-dispatched completed inwards appear`}
                      />
                    )}
                  />
                </Grid>
              )}

              {/* Missing Process Rate Warning Alert */}
              {hasMissingRates && (
                <Grid size={{ xs: 12 }}>
                  <Alert severity="error" icon={<WarningAmber />}>
                    <strong>Cannot Save:</strong> The following processes completed on the outward have no configured rate (or rate is ₹0.00) in the Process Register master:
                    <ul style={{ margin: "4px 0 0 16px", padding: 0 }}>
                      {missingRatesWarning.map((name, i) => (
                        <li key={i}><strong>{name}</strong></li>
                      ))}
                    </ul>
                    Please configure their rates in <strong>Process Register Master</strong> before finalizing this bill.
                  </Alert>
                </Grid>
              )}

              {/* Line Items Table - Strictly auto-derived from completed outward processes */}
              <Grid size={{ xs: 12 }}>
                <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1 }}>
                  <Typography sx={{ fontWeight: 600, color: "#023020" }} variant="subtitle2">
                    Bill Line Items (Derived from Completed Outward Processes)
                  </Typography>
                  <Button
                    size="small"
                    variant="outlined"
                    onClick={() => handleInwardSelectionChange(selectedInwards)}
                    sx={{ textTransform: "none", fontSize: "0.75rem", py: 0.25, px: 1, borderColor: "#023020", color: "#023020" }}
                  >
                    Recalculate from Inwards
                  </Button>
                </Box>
                <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
                  <Table size="small">
                    <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                      <TableRow>
                        <TableCell sx={{ width: 40, fontWeight: 700 }} align="center">S. No</TableCell>
                        <TableCell sx={{ width: "50%", fontWeight: 700 }}>Process *</TableCell>
                        <TableCell sx={{ width: 110, fontWeight: 700 }} align="right">Weight (kg) *</TableCell>
                        <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Master Rate (₹) *</TableCell>
                        <TableCell sx={{ width: 120, fontWeight: 700 }} align="right">Amount</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {lineItems.map((item, idx) => (
                        <TableRow key={idx}>
                          <TableCell align="center">{idx + 1}</TableCell>
                          <TableCell>
                            <Typography variant="body2" sx={{ fontWeight: 600 }}>
                              {resolveProcessName(item.process_id, processes) || "-"}
                            </Typography>
                          </TableCell>
                          <TableCell align="right">
                            <Typography variant="body2">{formatWeight(item.quantity)}</Typography>
                          </TableCell>
                          <TableCell align="right">
                            <Typography variant="body2" sx={{ color: Number(item.rate) > 0 ? "text.primary" : "error.main", fontWeight: 600 }}>
                              ₹{formatAmount(item.rate)}
                            </Typography>
                          </TableCell>
                          <TableCell align="right">
                            <Typography variant="body2" sx={{ fontWeight: 600 }}>
                              ₹{formatAmount(item.amount)}
                            </Typography>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </Paper>
                {!freightOpen && (
                  <Button size="small" variant="outlined" startIcon={<Add />} sx={{ mt: 1, textTransform: "none", color: "#023020", borderColor: "#023020", fontWeight: 600 }} onClick={handleToggleFreight}>
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
                      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 2, pt: 1, borderTop: "1px solid #cbd5e1" }}>
                        <Box sx={{ display: "flex", gap: 3, flexWrap: "wrap" }}>
                          <Typography variant="body2" sx={{ color: "#475569", fontWeight: 500 }}>
                            Total Wt (W/O Freight): <Box component="span" sx={{ fontWeight: 700, color: "#1e293b" }}>{totalQty.toFixed(3)} kg</Box>
                          </Typography>
                          <Typography variant="body2" sx={{ color: "#475569", fontWeight: 500 }}>
                            Total Wt (With Freight): <Box component="span" sx={{ fontWeight: 700, color: "#1e293b" }}>{(totalQty + (Number(freightItem.quantity) || 0)).toFixed(3)} kg</Box>
                          </Typography>
                        </Box>
                        <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
                          <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#0f5132" }}>
                            Net Payable Amount:
                          </Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: "#0f5132" }}>
                            ₹{formatAmount(netAmount)}
                          </Typography>
                        </Box>
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
            <Button
              type="submit"
              variant="contained"
              disabled={saveMutation.isPending || hasMissingRates || !lineItems[0]?.process_id}
              sx={{ bgcolor: "#023020" }}
            >
              {saveMutation.isPending ? "Saving..." : "Save Bill"}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </>
  );
}
