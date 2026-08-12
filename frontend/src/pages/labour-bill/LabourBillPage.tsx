import { useState, useMemo, useEffect, useCallback, useRef, memo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Chip, Tooltip, MenuItem, Autocomplete,
  Typography, Paper, Table, TableHead, TableRow, TableCell, TableBody,
  Checkbox, FormControlLabel
} from "@mui/material";
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
    queryKey: ["inward-vouchers-list"],
    queryFn: async () => (await api.get(`/stock/inward?fy=${activeFY}`)).data
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



    // Resolve linked outward vouchers

    const outwardIds = parseJsonArray(row.outward_ids);

    const linkedOutwards = outwardIds

      .map((id: number) => outwardVouchers.find((v: any) => v.id === id))

      .filter(Boolean);



    // Resolve linked inward vouchers: bill's own inward_id + every inward referenced by linked outwards

    const inwardIdSet = new Set<number | string>();

    if (row.inward_id !== undefined && row.inward_id !== null) inwardIdSet.add(row.inward_id);

    linkedOutwards.forEach((out: any) => {

      const outInwardIds = out.inward_ids

        ? parseJsonArray(out.inward_ids)

        : (out.inward_id !== undefined && out.inward_id !== null ? [out.inward_id] : []);

      outInwardIds.forEach((inwId: number | string) => inwardIdSet.add(inwId));

    });

    const linkedInwards = Array.from(inwardIdSet)

      .map((id: number | string) => inwardVouchers.find((v: any) => v.id === Number(id)))

      .filter(Boolean);



    // Build combined rows: one line per outward item with linked inward columns on the same row

    const reportRows: any[] = [];

    linkedOutwards.forEach((out: any) => {

      const linkedInvForOut = (() => {

        const ids = out.inward_ids

          ? parseJsonArray(out.inward_ids)

          : (out.inward_id !== undefined && out.inward_id !== null ? [out.inward_id] : []);

        return ids.map((id: number | string) => inwardVouchers.find((v: any) => v.id === Number(id))).filter(Boolean);

      })();

      const outItems = parseJsonArray(out.items);

      const pushReportRow = (item: any, outInv: any[]) => {

        reportRows.push({

          inward_no: outInv.map((v: any) => v.inward_no).filter(Boolean).join(", ") || "-",

          ref: outInv.map((v: any) => v.ref_no || v.serial_no).filter(Boolean).join(", ") || "-",

          inward_date: outInv.map((v: any) => toDateStr(v.inward_date)).filter((d: string) => d !== "-").join(", ") || "-",

          outward_no: out.outward_no,

          outward_date: out.outward_date,

          productName: products.find((p: any) => p.id === Number(item.product_id))?.name || `Product #${item.product_id}`,

          processName: resolveProcessName(item.process_id || out.process_id, processes) || "-",

          quantity: item.quantity || 0,

          weight: item.total_weight || item.weight || 0,

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

    if (reportRows.length === 0 && linkedInwards.length > 0) {

      linkedInwards.forEach((inv: any) => {

        const invItems = parseJsonArray(inv.items);

        const invRef = inv.ref_no || inv.serial_no || "-";

        if (invItems.length === 0) {

          reportRows.push({

            inward_no: inv.inward_no,

            ref: invRef,

            inward_date: toDateStr(inv.inward_date),

            outward_no: "-",

            outward_date: "-",

            productName: products.find((p: any) => p.id === Number(inv.product_id))?.name || `Product #${inv.product_id}`,

            processName: "-",

            quantity: inv.quantity || 0,

            weight: inv.total_weight || inv.weight || 0,

          });

        } else {

          invItems.forEach((item: any) => {

            reportRows.push({

              inward_no: inv.inward_no,

              ref: invRef,

              inward_date: toDateStr(inv.inward_date),

              outward_no: "-",

              outward_date: "-",

              productName: products.find((p: any) => p.id === Number(item.product_id))?.name || `Product #${item.product_id}`,

              processName: "-",

              quantity: item.quantity || 0,

              weight: item.total_weight || item.weight || 0,

            });

          });

        }

      });

    }



    const totalQty = reportRows.reduce((sum, r) => sum + (Number(r.quantity) || 0), 0);

    const totalWeight = reportRows.reduce((sum, r) => sum + (Number(r.weight) || 0), 0);



    let reportRowsHtml = "";

    if (reportRows.length === 0) {

      reportRowsHtml = `<tr><td colspan="10" style="text-align: center; padding: 12px;">No linked inward / outward vouchers</td></tr>`;

    } else {

      reportRows.forEach((r, idx) => {

        reportRowsHtml += `

          <tr>

            <td style="text-align: center;">${idx + 1}</td>

            <td style="font-weight: 600; white-space: nowrap;">${r.inward_no}</td>

            <td style="white-space: nowrap;">${r.ref}</td>

            <td style="white-space: nowrap;">${r.inward_date}</td>

            <td style="font-weight: 600; white-space: nowrap;">${r.outward_no}</td>

            <td style="white-space: nowrap;">${r.outward_date}</td>

            <td style="font-weight: 600;">${r.productName}</td>

            <td style="white-space: nowrap;">${r.processName}</td>

            <td style="text-align: right; white-space: nowrap;">${formatQty(r.quantity)}</td>

            <td style="text-align: right; font-weight: 600; white-space: nowrap;">${formatWeight(r.weight)} kg</td>

          </tr>`;

      });

      reportRowsHtml += `

          <tr class="total-row">

            <td colspan="8" style="text-align: right;">Total</td>

            <td style="text-align: right;">${formatQty(totalQty)}</td>

            <td style="text-align: right; font-weight: 700;">${formatWeight(totalWeight)} kg</td>

          </tr>`;

    }



    printWindow.document.write(`

      <!DOCTYPE html>

      <html>

        <head>

          <title>Print Work Details - ${row.bill_no}</title>

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

              <tr style="background-color: #0f5132 !important; color: #ffffff !important;">

                <th style="width: 40px; text-align: center; background-color: #0f5132 !important; color: #ffffff !important;">S.NO</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">INWARD NO</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">REF NO</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">INWARD DATE</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">OUTWARD NO</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">OUTWARD DATE</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">PRODUCT</th>

                <th style="background-color: #0f5132 !important; color: #ffffff !important;">PROCESS</th>

                <th style="text-align: right; width: 90px; background-color: #0f5132 !important; color: #ffffff !important;">QTY</th>

                <th style="text-align: right; width: 110px; background-color: #0f5132 !important; color: #ffffff !important;">WEIGHT (KG)</th>

              </tr>

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

  const colDefs: ColDef[] = [
    { field: "bill_no", headerName: "Bill No.", width: 110 },
    { field: "bill_date", headerName: "Date", width: 95 },
    { field: "ledger_id", headerName: "Supplier", width: 180, valueGetter: (p) => ledgerMap[p.data?.ledger_id] || p.data?.ledger_id || "" },
    { field: "quantity", headerName: "Weight", width: 80, type: "numericColumn", valueFormatter: (p) => formatWeight(p.value) },
    { field: "total_amount", headerName: "Total Amount", width: 130, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value || p.data?.net_amount)}` },
    { field: "is_paid", headerName: "Status", width: 90, cellRenderer: (p: any) => <Chip size="small" label={p.value ? "Paid" : "Pending"} color={p.value ? "success" : "warning"} /> },
    { headerName: "Actions", width: 200, sortable: false, filter: false, cellRenderer: (p: any) => (
      <Box sx={{ display: "flex", gap: 0.5, alignItems: "center", height: "100%" }}>
        <Tooltip title="Work Details"><IconButton size="small" onClick={() => handlePrintLabourWorkDetails(p.data)}><Description fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Print Bill"><IconButton size="small" onClick={() => handlePrintLabourBill(p.data)}><Print fontSize="small" /></IconButton></Tooltip>
        {!p.data.is_paid && <Tooltip title="Mark Paid"><IconButton size="small" color="success" onClick={() => markPaidMutation.mutate(p.data.id)}><CheckCircle fontSize="small" /></IconButton></Tooltip>}
        <Tooltip title="Edit"><IconButton size="small" onClick={() => handleOpen(p.data)}><Edit fontSize="small" /></IconButton></Tooltip>
        <Tooltip title="Delete"><IconButton size="small" color="error" onClick={() => deleteMutation.mutate(p.data.id)}><Delete fontSize="small" /></IconButton></Tooltip>
      </Box>
    )},
  ];



  return (

    <Box>

      <PageHeader

        title="Labour Bill"

        breadcrumbs={[{ label: "Labour Bill" }]}

      />

      <OrbxGrid

        rowData={bills}

        columnDefs={colDefs}

        loading={isLoading}

        onRefresh={refetch}

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

// Secondary Dialog: OutwardPicker
interface OutwardPickerProps {
  open: boolean;
  onClose: () => void;
  pendingOutwards: any[];
  selectedOutwards: any[];
  onSelect: (voucher: any) => void;
}

const OutwardPicker = memo(function OutwardPicker({ open, onClose, pendingOutwards, selectedOutwards, onSelect }: OutwardPickerProps) {
  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle sx={{ fontWeight: 700, color: "#023020", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <Box>
          Select Pending Outward Voucher
          <Typography variant="body2" color="text.secondary" sx={{ fontWeight: 400, mt: 0.25 }}>
            Click a row to add its items · highlighted rows already added
          </Typography>
        </Box>
        <Button size="small" variant="contained"
          sx={{ bgcolor: "#023020", "&:hover": { bgcolor: "#034d30" }, textTransform: "none" }}
          onClick={onClose}>Done</Button>
      </DialogTitle>
      <DialogContent dividers sx={{ p: 0 }}>
        {pendingOutwards.length === 0 ? (
          <Box sx={{ py: 6, textAlign: "center" }}>
            <Typography color="text.secondary">No pending outward vouchers found for this supplier.</Typography>
            <Button sx={{ mt: 2 }} variant="outlined" onClick={onClose}>Continue without selecting</Button>
          </Box>
        ) : (
          <Table size="small">
            <TableHead sx={{ bgcolor: "#f4f9f6" }}>
              <TableRow>
                <TableCell sx={{ fontWeight: 700 }}>Outward No</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Serial / Ref</TableCell>
                <TableCell sx={{ fontWeight: 700 }}>Process</TableCell>
                <TableCell sx={{ fontWeight: 700 }} align="right">Weight (kg)</TableCell>
                <TableCell sx={{ width: 90 }} />
              </TableRow>
            </TableHead>
            <TableBody>
              {pendingOutwards.map((out: any) => {
                const alreadySelected = selectedOutwards.some((s) => s.id === out.id);
                return (
                  <TableRow key={out.id} hover
                    sx={{ cursor: alreadySelected ? "default" : "pointer", bgcolor: alreadySelected ? "#e8f5e9" : "inherit" }}
                    onClick={() => !alreadySelected && onSelect(out)}>
                    <TableCell>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: "#023020" }}>{out.outward_no}</Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {out.outward_date ? new Date(out.outward_date).toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" }) : "-"}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" color="text.secondary">
                        {out.ref_no || "-"}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" color="text.secondary">{out.process_id || "-"}</Typography>
                    </TableCell>
                    <TableCell align="right">
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>
                        {formatWeight(out.total_weight || out.weight || 0)}
                      </Typography>
                    </TableCell>
                    <TableCell align="center">
                      {alreadySelected ? (
                        <Typography variant="caption" sx={{ color: "#023020", fontWeight: 700 }}>✓ Added</Typography>
                      ) : (
                        <Button size="small" variant="contained"
                          sx={{ textTransform: "none", fontWeight: 600, bgcolor: "#023020", "&:hover": { bgcolor: "#034d30" } }}
                          onClick={(e) => { e.stopPropagation(); onSelect(out); }}>
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

function LabourBillDialog({ open, onClose, editing }: LabourBillDialogProps) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [selectedOutwards, setSelectedOutwards] = useState<any[]>([]);
  const [outwardPickerOpen, setOutwardPickerOpen] = useState(false);
  const [lineItems, setLineItems] = useState<any[]>([
    { product_id: "", process_id: "", quantity: "", rate: "", amount: "" }
  ]);
  const [freightOpen, setFreightOpen] = useState(false);
  const [freightItem, setFreightItem] = useState<any>({ process_id: "", quantity: "", rate: "", amount: "" });

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

  const handleSupplierChange = (val: any) => {
    setValue("ledger_id", val ? val.id : "");
    setSelectedOutwards([]);
    setLineItems([{ product_id: "", process_id: "", quantity: "", rate: "", amount: "" }]);
  };

  const [enableRoundOff, setEnableRoundOff] = useState(true);

  const getCompanyRate = (productId: any, processId: any) => {
    const proc = processes.find((p: any) => p.id === Number(processId));
    return proc ? proc.company_rate || 0 : 0;
  };

  const getShotBlastingWeight = () => {
    const shotItem = lineItems.find((item: any) => {
      const proc = processMapObj[item.process_id];
      const name = (proc && proc.name) || "";
      return /shot/i.test(name);
    });
    return Number(shotItem?.quantity) || 0;
  };

  const handleFreightChange = (field: string, value: any) => {
    setFreightItem((prev: any) => {
      const updated = { ...prev, [field]: value };
      if (field === "process_id") {
        updated.quantity = getShotBlastingWeight();
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

  const handleOutwardSelect = (out: any) => {
    setSelectedOutwards((prev) => [...prev, out]);

    let rawItems: any[] = [];
    if (out.items && Array.isArray(out.items) && out.items.length > 0) {
      rawItems = out.items;
    } else if (typeof out.items === "string") {
      try {
        const parsed = JSON.parse(out.items);
        if (Array.isArray(parsed) && parsed.length > 0) rawItems = parsed;
      } catch (e) {}
    }

    if (rawItems.length === 0) {
      rawItems = [{
        product_id: out.product_id || "",
        process_id: out.process_id || "",
        quantity: out.total_weight || out.weight || 0,
      }];
    }

    const newItems: any[] = [];
    rawItems.forEach((item: any) => {
      const productId = item.product_id || out.product_id || "";
      const processIdStr = String(item.process_id || out.process_id || "");
      const totalWeightVal = Number(item.total_weight || item.weight || (Number(item.quantity) * Number(item.weight)) || out.total_weight || (Number(out.quantity) * Number(out.weight)) || 0);

      const proc = processes.find((p: any) => p.id === Number(processIdStr));
      if (proc && proc.process_ids) {
        const childIds = proc.process_ids.split(",").map((x: string) => x.trim()).filter(Boolean);
        childIds.forEach((cid: string) => {
          const childProc = processes.find((p: any) => p.id === Number(cid));
          if (childProc) {
            const rateVal = getCompanyRate(productId, childProc.id);
            if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) {
              setValue("gst_percent", childProc.gst_percent);
            }
            newItems.push({
              product_id: productId,
              process_id: childProc.id,
              quantity: totalWeightVal,
              rate: rateVal,
              amount: Number((totalWeightVal * rateVal).toFixed(2))
            });
          }
        });
      } else if (proc && proc.process_code && proc.process_code.includes(" / ")) {
        const parts = proc.process_code.split("/").map((p: any) => p.trim()).filter(Boolean);
        parts.forEach((part: any) => {
          const childProc = processes.find((p: any) => p.process_code === part);
          if (childProc) {
            const rateVal = getCompanyRate(productId, childProc.id);
            if (childProc.gst_percent !== undefined && childProc.gst_percent !== null) {
              setValue("gst_percent", childProc.gst_percent);
            }
            newItems.push({
              product_id: productId,
              process_id: childProc.id,
              quantity: totalWeightVal,
              rate: rateVal,
              amount: Number((totalWeightVal * rateVal).toFixed(2))
            });
          }
        });
      } else {
        const rateVal = getCompanyRate(productId, processIdStr);
        if (proc && proc.gst_percent !== undefined && proc.gst_percent !== null) {
          setValue("gst_percent", proc.gst_percent);
        }
        newItems.push({
          product_id: productId,
          process_id: processIdStr ? Number(processIdStr) : "",
          quantity: totalWeightVal,
          rate: rateVal,
          amount: Number((totalWeightVal * rateVal).toFixed(2))
        });
      }
    });

    const mergeProcessItems = (items: any[]) => {
      const merged: Record<number | string, any> = {};
      items.forEach((item) => {
        if (!item.process_id) {
          const tempKey = `temp_${Math.random()}`;
          merged[tempKey] = { ...item };
        } else {
          const key = Number(item.process_id);
          if (merged[key]) {
            merged[key].quantity = Number(merged[key].quantity || 0) + Number(item.quantity || 0);
            merged[key].amount = Number((merged[key].quantity * Number(merged[key].rate || 0)).toFixed(2));
          } else {
            merged[key] = { ...item };
          }
        }
      });
      return Object.values(merged);
    };

    setLineItems((prev) => {
      let combined = [];
      if (prev.length === 1 && !prev[0].product_id && !prev[0].process_id && !prev[0].quantity) {
        combined = newItems;
      } else {
        combined = [...prev, ...newItems];
      }
      return mergeProcessItems(combined);
    });
  };

  const handleRemoveSelectedOutward = (id: number) => {
    const updated = selectedOutwards.filter((o) => o.id !== id);
    setSelectedOutwards(updated);
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
        // Restore selected outwards
        const outwardIdList = (() => {
          const ids = editing.outward_ids || [];
          if (!Array.isArray(ids)) return [];
          return ids.map((id: number) => {
            const out = outwardVouchers.find((v: any) => v.id === id);
            return {
              id,
              outward_no: out?.outward_no || `#${id}`,
              outward_date: out?.outward_date || "",
              ref_no: out?.ref_no || "",
              process_id: out?.process_id || "",
              quantity: out?.quantity || 0,
              items: out?.items || null
            };
          });
        })();
        setSelectedOutwards(outwardIdList);

        let parsedItems: any[] = [];
        if (typeof editing.items === "string") {
          try { parsedItems = JSON.parse(editing.items); } catch (e) {}
        } else if (Array.isArray(editing.items)) {
          parsedItems = editing.items;
        }

        if (parsedItems && parsedItems.length > 0) {
          setLineItems(parsedItems);
        } else {
          setLineItems([{
            product_id: editing.product_id || "",
            process_id: editing.process_id || "",
            quantity: editing.quantity || "",
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
          setFreightItem({ ...parsedFreight[0] });
          setFreightOpen(true);
        } else {
          setFreightItem({ process_id: "", quantity: "", rate: "", amount: "" });
          setFreightOpen(false);
        }

        reset(editing);
      } else {
        setSelectedOutwards([]);
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
  }, [open, editing, reset, outwardVouchers, setValue]);

  const saveMutation = useMutation({
    mutationFn: (formData: any) => {
      const payload = {
        bill_no: formData.bill_no,
        bill_date: formData.bill_date,
        ledger_id: Number(formData.ledger_id),
        inward_id: selectedOutwards.length > 0 ? selectedOutwards[0].inward_id : null,
        product_id: lineItems[0]?.product_id ? Number(lineItems[0].product_id) : null,
        process_id: lineItems[0]?.process_id ? Number(lineItems[0].process_id) : null,
        quantity: totalQty,
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
      alert("Failed to save Labour Bill. This usually happens if the Bill Number already exists. Please verify the Bill Number and try again.");
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
                <TextField {...register("bill_no")} label="Bill No. *" fullWidth required size="small" disabled />
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

              {/* Linked Outward Vouchers */}
              <Grid size={{ xs: 12 }}>
                <Box sx={{ display: "flex", flexWrap: "wrap", gap: 1, alignItems: "center" }}>
                  <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 700 }}>Linked Outward Vouchers:</Typography>
                  {selectedOutwards.map((out) => (
                    <Box key={out.id} sx={{
                      display: "inline-flex", alignItems: "center", gap: 0.5,
                      bgcolor: "#e8f5e9", border: "1px solid #023020",
                      borderRadius: "8px", px: 1.5, py: 0.5
                    }}>
                      <Box>
                        <Typography variant="caption" sx={{ fontWeight: 700, color: "#023020", display: "block", lineHeight: 1.2 }}>
                          {out.outward_no || `#${out.id}`}
                        </Typography>
                        {out.ref_no && (
                          <Typography variant="caption" color="text.secondary" sx={{ fontSize: "0.65rem", lineHeight: 1.2, display: "block" }}>
                            Ref: {out.ref_no}
                          </Typography>
                        )}
                        <Typography variant="caption" sx={{ fontSize: "0.7rem", lineHeight: 1.4, display: "block", color: "text.primary" }}>
                          Wt: {formatWeight(out.total_weight || out.weight || 0)} kg
                        </Typography>
                      </Box>
                      <IconButton size="small" sx={{ p: 0, ml: 0.5, color: "#023020" }} onClick={() => handleRemoveSelectedOutward(out.id)}>
                        <Typography sx={{ fontSize: 12, lineHeight: 1 }}>✕</Typography>
                      </IconButton>
                    </Box>
                  ))}
                  <Button size="small" variant="text" sx={{ textTransform: "none", fontWeight: 600, color: "#023020" }}
                    disabled={!selectedLedger}
                    onClick={() => setOutwardPickerOpen(true)}>
                    + Add Outward Vouchers
                  </Button>
                </Box>
              </Grid>

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
                              slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
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
                            <IconButton size="small" color="error" disabled={lineItems.length === 1} onClick={() => handleRemoveLineItem(idx)}>
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
                              slotProps={{ htmlInput: { style: { textAlign: "right" } } }}
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
                            <IconButton size="small" color="error" onClick={handleToggleFreight}>
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

      <OutwardPicker
        open={outwardPickerOpen}
        onClose={() => setOutwardPickerOpen(false)}
        pendingOutwards={supplierOutwardVouchers}
        selectedOutwards={selectedOutwards}
        onSelect={handleOutwardSelect}
      />
    </>
  );
}