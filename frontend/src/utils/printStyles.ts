export const GLOBAL_PRINT_FOOTER_CSS = `
  @page {
    @bottom-left {
      content: "Powered by OrbX | orbx.in";
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 8pt;
      font-weight: 500;
      color: #555555;
      vertical-align: bottom;
      padding-bottom: 0;
    }
    @bottom-right {
      content: "Pages " counter(page) "/" counter(pages);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 8pt;
      font-weight: 500;
      color: #555555;
      vertical-align: bottom;
      padding-bottom: 0;
    }
  }

  /* Prevent duplicate or legacy footers during print */
  @media print {
    .footer-info, .orbx-screen-footer, .no-print-footer, .footer {
      display: none !important;
    }
  }

  /* On-screen preview fallback if viewed in browser tab prior to print */
  .orbx-screen-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 10px;
    font-size: 8pt;
    font-family: 'Inter', sans-serif;
    color: #555555;
    border-top: 0.5px solid #e0e0e0;
    margin-top: 20px;
  }
`;

export const COMMON_PRINT_CSS = `
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
  
  * { -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; color-adjust: exact !important; box-sizing: border-box; }
  
  html, body { margin: 0; padding: 0; }
  body { font-family: 'Inter', sans-serif; color: #1a1a1a; background-color: #fff; line-height: 1.35; font-size: 10.5px; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }

  /* =========================================================================
     GLOBAL ORBX BRANDED PRINT FOOTER & DYNAMIC PAGE NUMBERING
     ========================================================================= */
  @page {
    @bottom-left {
      content: "Powered by OrbX | orbx.in";
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 8pt;
      font-weight: 500;
      color: #555555;
      vertical-align: bottom;
      padding-bottom: 0;
    }
    @bottom-right {
      content: "Pages " counter(page) "/" counter(pages);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 8pt;
      font-weight: 500;
      color: #555555;
      vertical-align: bottom;
      padding-bottom: 0;
    }
  }

  /* Prevent duplicate or legacy footers during print */
  @media print {
    .footer-info, .orbx-screen-footer, .no-print-footer, .footer {
      display: none !important;
    }
  }

  /* On-screen preview fallback if viewed in browser tab prior to print */
  .orbx-screen-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 10px;
    font-size: 8pt;
    font-family: 'Inter', sans-serif;
    color: #555555;
    border-top: 0.5px solid #e0e0e0;
    margin-top: 20px;
  }
  
  /* Header & Branding */
  .header-container { display: flex; justify-content: space-between; align-items: center; border-bottom: 0.5px solid #198754; padding-bottom: 8px; margin-bottom: 10px; }
  .logo-wrapper { flex: 0 0 150px; }
  .logo-wrapper img { max-height: 75px; max-width: 150px; object-fit: contain; }
  .company-details { flex: 1; text-align: center; margin-right: 150px; }
  .company-details h1 { margin: 0; font-size: 20px; color: #0f5132; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
  .company-details p { margin: 2px 0 0 0; font-size: 10px; color: #2d3748; }
  .company-details .gstin { font-weight: 700; color: #0f5132; }
  
  /* Document Title & Meta */
  .title-section { display: flex; justify-content: flex-end; align-items: flex-end; flex-direction: column; margin-bottom: 10px; border-bottom: 0.5px solid #198754; padding-bottom: 6px; }
  .title-section h2 { margin: 0 0 2px 0; font-size: 16px; color: #0f5132; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; }
  .title-section .doc-no { font-size: 12px; color: #0f5132; font-weight: 700; }
  .title-section .doc-date { font-size: 10px; color: #2d3748; margin-top: 1px; }
  
  /* Addresses */
  .address-section { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 10px; }
  .address-column h3 { margin: 0 0 4px 0; font-size: 10px; color: #0f5132; font-weight: 700; text-transform: uppercase; border-bottom: 0.5px solid #198754; padding-bottom: 2px; }
  .address-column .name { font-size: 11.5px; font-weight: 700; color: #000000; margin-bottom: 2px; text-transform: uppercase; }
  .address-column .address-lines { color: #2d3748; line-height: 1.35; margin-bottom: 2px; font-size: 10px; }
  .address-column .gstin { font-weight: 600; color: #0f5132; font-size: 10px; }
  
  /* Green Theme Table - Multi-page friendly & Compact row spacing */
  table.items-table { width: 100%; border-collapse: collapse; margin-bottom: 10px; border: 0.5px solid #198754; page-break-inside: auto; }
  table.items-table thead { display: table-header-group; }
  table.items-table thead tr { background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; page-break-inside: avoid; }
  table.items-table th { background-color: #0f5132 !important; color: #ffffff !important; border: 0.5px solid #198754 !important; padding: 5px 6px; font-weight: 700; font-size: 10px; text-transform: uppercase; text-align: left; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  table.items-table tbody tr { page-break-inside: avoid; page-break-after: auto; }
  table.items-table td { padding: 4.5px 6px; border-left: 0.5px solid #198754; border-right: 0.5px solid #198754; border-top: none; border-bottom: none; color: #000000; font-size: 10px; line-height: 1.3; }
  table.items-table tr { border-bottom: none; }
  table.items-table tfoot { display: table-row-group; page-break-inside: avoid; }
  table.items-table tfoot tr, table.items-table tr.total-row { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; background-color: #f0fdf4 !important; font-weight: 700; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; page-break-inside: avoid; }
  table.items-table tfoot td, table.items-table tr.total-row td { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; border-left: 0.5px solid #198754; border-right: 0.5px solid #198754; color: #0f5132; font-size: 10.5px; padding: 5px 6px; }

  /* Totals Section */
  .totals-section { display: flex; justify-content: flex-end; margin-bottom: 10px; page-break-inside: avoid; }
  .calculation-box { display: flex; flex-direction: column; align-items: flex-end; min-width: 260px; }
  .calculation-row { display: flex; justify-content: space-between; width: 100%; padding: 3px 6px; color: #1a1a1a; font-size: 10px; }
  .calculation-row.grand-total { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; background-color: #f0fdf4 !important; padding: 6px 8px; margin-top: 3px; font-size: 12px; font-weight: 700; color: #0f5132; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  .amount-in-words { font-size: 10px; font-style: italic; color: #0f5132; text-align: right; margin-top: 4px; font-weight: 600; }

  /* Bottom Section */
  .bottom-section { margin-top: 6px; padding-top: 8px; border-top: 0.5px solid #198754; page-break-inside: avoid; }
  .narration-box { font-size: 10px; margin-bottom: 8px; color: #1a1a1a; background-color: #f0fdf4 !important; padding: 6px 10px; border-left: 3px solid #0f5132; border-radius: 4px; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  .narration-box strong { color: #0f5132; }
  
  .terms-box { font-size: 9.5px; color: #2d3748; margin-bottom: 8px; }
  .terms-box h4 { margin: 0 0 3px 0; font-size: 10px; color: #0f5132; font-weight: 700; text-transform: uppercase; }
  .terms-box ol { margin: 0; padding-left: 16px; color: #2d3748; }
  .terms-box li { margin-bottom: 2px; }

  .signatures-container { display: flex; justify-content: space-between; margin-top: 18px; }
  .signature-block { text-align: center; width: 180px; }
  .signature-line { border-bottom: 0.5px solid #198754; margin-bottom: 4px; height: 22px; }
  .signature-label { font-size: 9.5px; color: #0f5132; font-weight: 600; }
  .thank-you-note { text-align: center; font-size: 9.5px; color: #0f5132; margin-top: 8px; font-weight: 600; }
`;

import { useCompanyStore, preloadAndDecodeImage } from "../store";

export function getPageSizeCSS(paperSize: "A4" | "A5"): string {
  if (paperSize === "A5") return "A5 landscape";
  return "A4 portrait";
}

/**
 * Returns company logo HTML with reliable fallback to centralized store and cached values.
 * Resolves asynchronously pre-decoded logo data and maintains localStorage synchronization.
 */
export function getCompanyLogoHtml(showLogo?: boolean, companyData?: any): string {
  const store = useCompanyStore.getState();
  const comp = (Array.isArray(companyData) ? companyData[0] : companyData) || store.company;

  const shouldShow = showLogo !== undefined ? showLogo : (comp?.show_logo ?? store.printConfig?.showLogo ?? true);
  if (!shouldShow) return "";

  const logoSrc = comp?.logo_path || store.company?.logo_path || localStorage.getItem("company_logo") || "/logo-light.svg";

  if (logoSrc && logoSrc !== "/logo-light.svg") {
    try {
      localStorage.setItem("company_logo", logoSrc);
    } catch {}
  }

  return logoSrc ? `<img src="${logoSrc}" alt="Logo" class="company-logo-img" />` : "";
}

/**
 * Resolves complete company information for print headers, falling back seamlessly
 * to the centralized persistent store if the local page query has not yet resolved.
 */
export function resolveCompanyDetails(companyData?: any) {
  const storeComp = useCompanyStore.getState().company;
  const comp = (Array.isArray(companyData) ? companyData[0] : companyData) || storeComp;

  const name = comp?.name || comp?.company_name || "SRI METAL";
  const address = comp?.address || [comp?.address_line1, comp?.address_line2].filter(Boolean).join(", ") || "";
  const city = comp?.city || "";
  const state = comp?.state || "";
  const pincode = comp?.pincode || "";
  const cityStatePin = [city, state, pincode].filter(Boolean).join(" - ");
  const phone = comp?.phone || comp?.mobile ? `Tel: ${[comp?.phone, comp?.mobile].filter(Boolean).join(" / ")}` : "";
  const email = comp?.email ? `Email: ${comp?.email}` : "";
  const gstin = comp?.gstin ? `GSTIN: ${comp?.gstin}` : "";
  const pan = comp?.pan ? `PAN: ${comp?.pan}` : "";

  return {
    raw: comp,
    name,
    address,
    cityStatePin,
    phone,
    email,
    gstin,
    pan,
    logoPath: comp?.logo_path || null,
    showLogo: comp?.show_logo ?? true,
  };
}

/**
 * Ensures company details and logo are completely initialized and pre-decoded in memory
 * before triggering a print dialog.
 */
export async function ensurePrintReady(): Promise<{
  company: any;
  printConfig: any;
  logoHtml: string;
}> {
  const store = useCompanyStore.getState();
  const company = await store.ensureReady();
  const logoHtml = getCompanyLogoHtml(undefined, company);
  if (company?.logo_path) {
    await preloadAndDecodeImage(company.logo_path).catch(() => {});
  }
  return {
    company,
    printConfig: store.printConfig,
    logoHtml,
  };
}

export const PRINT_TRIGGER_SCRIPT = `
  <script>
    function triggerPrint() {
      window.focus();
      window.print();
      setTimeout(function() { window.close(); }, 750);
    }

    function initPrintWithLogo() {
      var img = document.querySelector('.logo-wrapper img, .logo-container img, img.company-logo-img');
      if (!img) {
        triggerPrint();
        return;
      }

      // If image is already complete and decoded
      if (img.complete && img.naturalWidth > 0) {
        if (typeof img.decode === 'function') {
          img.decode().then(triggerPrint).catch(triggerPrint);
        } else {
          triggerPrint();
        }
        return;
      }

      var hasTriggered = false;
      var onReady = function() {
        if (hasTriggered) return;
        hasTriggered = true;
        if (typeof img.decode === 'function') {
          img.decode().then(triggerPrint).catch(triggerPrint);
        } else {
          triggerPrint();
        }
      };

      img.onload = onReady;
      img.onerror = function() {
        console.warn("Logo failed to load in printout, continuing with print");
        if (hasTriggered) return;
        hasTriggered = true;
        triggerPrint();
      };

      // Safety timeout: Ensure document ALWAYS prints even on slow or failed network
      setTimeout(onReady, 2500);
    }

    if (document.readyState === 'complete') {
      initPrintWithLogo();
    } else {
      window.addEventListener('load', initPrintWithLogo);
    }
  </script>
`;

export function injectPrintStyles(css: string): void {
  if (document.getElementById("orbx-print-styles")) return;
  const style = document.createElement("style");
  style.id = "orbx-print-styles";
  style.textContent = css;
  document.head.appendChild(style);
}

/**
 * Renders the on-screen fallback footer for browser previews when viewed before printing.
 * Hidden automatically during physical print and PDF generation via @media print { display: none !important; }.
 */
export function getGlobalPrintFooterHtml(): string {
  return `
    <div class="orbx-screen-footer">
      <span>Powered by OrbX | orbx.in</span>
      <span>Pages 1/1</span>
    </div>
  `;
}

