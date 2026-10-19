export const GLOBAL_PRINT_FOOTER_CSS = `
  /* =========================================================================
     GLOBAL ORBX BRANDED PRINT FOOTER & DYNAMIC PAGE NUMBERING
     ========================================================================= */
  .orbx-global-print-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-sizing: border-box;
    width: 100%;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 8pt;
    font-weight: 500;
    color: #555555;
    line-height: 1.2;
  }

  @media screen {
    .orbx-print-page {
      margin-bottom: 25px;
      border-bottom: 1px dashed #cbd5e1;
      padding-bottom: 15px;
    }
    .orbx-global-print-footer {
      position: relative;
      margin-top: 25px;
      padding: 8px 10px;
      border-top: 0.5px solid #e0e0e0;
    }
  }

  @media print {
    html, body {
      margin: 0 !important;
      padding: 0 !important;
      background: #ffffff !important;
    }
    .orbx-print-page {
      page-break-after: always !important;
      break-after: page !important;
      page-break-inside: avoid !important;
      break-inside: avoid !important;
      box-sizing: border-box !important;
      display: flex !important;
      flex-direction: column !important;
      justify-content: space-between !important;
      height: 100vh !important;
      max-height: 100vh !important;
      overflow: hidden !important;
    }
    .orbx-print-page:last-child {
      page-break-after: avoid !important;
      break-after: avoid !important;
    }
    .orbx-print-page-content {
      flex: 1 1 auto !important;
    }
    .orbx-global-print-footer {
      flex: 0 0 auto !important;
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      width: 100% !important;
      background: transparent !important;
      padding: 0 4px !important;
      box-sizing: border-box !important;
      margin-top: auto !important;
    }
    .footer-info, .orbx-screen-footer, .no-print-footer, .footer {
      display: none !important;
    }
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
  .orbx-global-print-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-sizing: border-box;
    width: 100%;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 8pt;
    font-weight: 500;
    color: #555555;
    line-height: 1.2;
  }

  @media screen {
    .orbx-print-page {
      margin-bottom: 25px;
      border-bottom: 1px dashed #cbd5e1;
      padding-bottom: 15px;
    }
    .orbx-global-print-footer {
      position: relative;
      margin-top: 25px;
      padding: 8px 10px;
      border-top: 0.5px solid #e0e0e0;
    }
  }

  @media print {
    html, body {
      margin: 0 !important;
      padding: 0 !important;
      background: #ffffff !important;
    }
    .orbx-print-page {
      page-break-after: always !important;
      break-after: page !important;
      page-break-inside: avoid !important;
      break-inside: avoid !important;
      box-sizing: border-box !important;
      display: flex !important;
      flex-direction: column !important;
      justify-content: space-between !important;
      height: 100vh !important;
      max-height: 100vh !important;
      overflow: hidden !important;
    }
    .orbx-print-page:last-child {
      page-break-after: avoid !important;
      break-after: avoid !important;
    }
    .orbx-print-page-content {
      flex: 1 1 auto !important;
    }
    .orbx-global-print-footer {
      flex: 0 0 auto !important;
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      width: 100% !important;
      background: transparent !important;
      padding: 0 4px !important;
      box-sizing: border-box !important;
      margin-top: auto !important;
    }
    .footer-info, .orbx-screen-footer, .no-print-footer, .footer {
      display: none !important;
    }
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

    function getElementTotalHeight(el) {
      if (!el) return 0;
      var style = window.getComputedStyle ? window.getComputedStyle(el) : null;
      var mt = style ? (parseFloat(style.marginTop) || 0) : 0;
      var mb = style ? (parseFloat(style.marginBottom) || 0) : 0;
      return el.offsetHeight + mt + mb;
    }

    function paginateDocumentForPrint() {
      try {
        var table = document.querySelector('table.items-table, table');
        if (!table) return;

        var headHtml = (document.head ? document.head.innerHTML : "") + " " + (document.title || "");
        var isLandscape = /landscape/i.test(headHtml);
        var isA5 = /a5/i.test(headHtml);

        var marginMm = 10;
        var mMatch = headHtml.match(/margin:\s*(\d+)mm/i);
        if (mMatch && mMatch[1]) {
          marginMm = parseInt(mMatch[1], 10);
        }
        var pxPerMm = 3.779527559;
        var totalSheetHeightPx = (isA5 ? 148 : (isLandscape ? 210 : 297)) * pxPerMm;
        var marginTotalPx = marginMm * pxPerMm * 2;
        var usablePageHeight = totalSheetHeightPx - marginTotalPx;

        var footerHeight = 28;
        var safetyBuffer = 18;
        var contentMaxHeight = usablePageHeight - footerHeight - safetyBuffer;

        // Collect top elements before table
        var topElements = [];
        var prev = table.previousElementSibling;
        while (prev) {
          if (prev.tagName !== 'SCRIPT' && prev.tagName !== 'STYLE') {
            topElements.unshift(prev);
          }
          prev = prev.previousElementSibling;
        }
        var topHeight = 0;
        topElements.forEach(function(el) { topHeight += getElementTotalHeight(el); });

        var thead = table.querySelector('thead');
        var theadHeight = thead ? getElementTotalHeight(thead) : 0;
        var tfoot = table.querySelector('tfoot');

        // Collect bottom elements after table (excluding footer and scripts)
        var bottomElements = [];
        var next = table.nextElementSibling;
        while (next) {
          if (!next.classList.contains('orbx-global-print-footer') && next.tagName !== 'SCRIPT' && next.tagName !== 'STYLE') {
            bottomElements.push(next);
          }
          next = next.nextElementSibling;
        }
        var bottomHeight = 0;
        bottomElements.forEach(function(el) { bottomHeight += getElementTotalHeight(el); });

        // Group rows atomically (honoring rowspan)
        var allRows = Array.from(table.querySelectorAll('tbody > tr'));
        var atomicGroups = [];
        var rIdx = 0;
        while (rIdx < allRows.length) {
          var tr = allRows[rIdx];
          var maxRs = 1;
          var cells = tr.querySelectorAll('td, th');
          cells.forEach(function(c) {
            var rs = parseInt(c.getAttribute('rowspan') || '1', 10);
            if (rs > maxRs) maxRs = rs;
          });
          var groupRows = [];
          var groupHeight = 0;
          for (var k = 0; k < maxRs && rIdx < allRows.length; k++) {
            groupRows.push(allRows[rIdx]);
            groupHeight += allRows[rIdx].offsetHeight;
            rIdx++;
          }
          atomicGroups.push({ rows: groupRows, height: groupHeight });
        }

        // Check if entire content fits in 1 page cleanly
        var totalRowsHeight = atomicGroups.reduce(function(sum, g) { return sum + g.height; }, 0);
        var totalDocContentHeight = topHeight + theadHeight + totalRowsHeight + bottomHeight;

        if (totalDocContentHeight <= contentMaxHeight) {
          // Document fits on exactly 1 page
          var footer = document.querySelector('.orbx-global-print-footer');
          if (footer) {
            var currSpan = footer.querySelector('.orbx-curr-page');
            var totalSpan = footer.querySelector('.orbx-total-pages');
            if (currSpan) currSpan.textContent = '1';
            if (totalSpan) totalSpan.textContent = '1';
          }
          return;
        }

        // Multi-page document: distribute atomic groups into pages
        var pagesData = [];
        var currentPageRows = [];
        var currentHeight = topHeight + theadHeight;

        for (var g = 0; g < atomicGroups.length; g++) {
          var grp = atomicGroups[g];
          if (currentHeight + grp.height > contentMaxHeight && currentPageRows.length > 0) {
            pagesData.push(currentPageRows);
            currentPageRows = [];
            currentHeight = theadHeight;
          }
          currentPageRows.push(grp);
          currentHeight += grp.height;
        }

        var bottomFitsOnLast = (currentHeight + bottomHeight <= contentMaxHeight);
        if (!bottomFitsOnLast && currentPageRows.length > 0) {
          pagesData.push(currentPageRows);
          currentPageRows = [];
          currentHeight = theadHeight;
        }
        pagesData.push(currentPageRows);

        var totalPages = pagesData.length;

        // Cache exact column widths from rendered header to ensure perfect alignment
        var tableClass = table.className;
        var tableStyle = table.getAttribute('style') || '';
        var colWidths = [];
        if (thead) {
          var lastHeaderRow = thead.querySelector('tr:last-child');
          if (lastHeaderRow) {
            var thList = lastHeaderRow.querySelectorAll('th, td');
            thList.forEach(function(th) {
              colWidths.push(th.getBoundingClientRect().width);
            });
          }
        }

        var container = document.createElement('div');
        container.id = 'orbx-paginated-container';

        for (var p = 0; p < totalPages; p++) {
          var pageDiv = document.createElement('div');
          pageDiv.className = 'orbx-print-page';
          pageDiv.setAttribute('data-page', (p + 1) + '/' + totalPages);

          var pageContent = document.createElement('div');
          pageContent.className = 'orbx-print-page-content';

          if (p === 0) {
            topElements.forEach(function(el) {
              pageContent.appendChild(el.cloneNode(true));
            });
          }

          var pageGroups = pagesData[p];
          if (pageGroups.length > 0 || (p === totalPages - 1 && !bottomFitsOnLast)) {
            var pageTable = document.createElement('table');
            pageTable.className = tableClass;
            pageTable.style.width = '100%';
            pageTable.style.tableLayout = 'fixed';
            if (tableStyle) {
              pageTable.style.cssText = tableStyle + '; width: 100% !important; table-layout: fixed !important;';
            }

            if (thead) {
              var clonedThead = thead.cloneNode(true);
              if (colWidths.length > 0) {
                var lastClonedRow = clonedThead.querySelector('tr:last-child');
                if (lastClonedRow) {
                  var clonedThs = lastClonedRow.querySelectorAll('th, td');
                  clonedThs.forEach(function(th, idx) {
                    if (colWidths[idx]) {
                      th.style.width = colWidths[idx] + 'px';
                      th.style.minWidth = colWidths[idx] + 'px';
                      th.style.maxWidth = colWidths[idx] + 'px';
                    }
                  });
                }
              }
              pageTable.appendChild(clonedThead);
            }

            var pageTbody = document.createElement('tbody');
            pageGroups.forEach(function(grp) {
              grp.rows.forEach(function(r) {
                pageTbody.appendChild(r.cloneNode(true));
              });
            });
            pageTable.appendChild(pageTbody);

            if (tfoot && p === totalPages - 1) {
              pageTable.appendChild(tfoot.cloneNode(true));
            }

            pageContent.appendChild(pageTable);
          }

          if (p === totalPages - 1) {
            bottomElements.forEach(function(el) {
              pageContent.appendChild(el.cloneNode(true));
            });
          }

          pageDiv.appendChild(pageContent);

          var pageFooter = document.createElement('div');
          pageFooter.className = 'orbx-global-print-footer';
          pageFooter.innerHTML = '<span class="orbx-footer-left">Powered by OrbX | orbx.in</span><span class="orbx-footer-right">Pages ' + (p + 1) + '/' + totalPages + '</span>';
          pageDiv.appendChild(pageFooter);

          container.appendChild(pageDiv);
        }

        document.body.innerHTML = '';
        document.body.appendChild(container);
      } catch (e) {
        console.error("Pagination error:", e);
      }
    }

    function initPrintProcess() {
      var img = document.querySelector('.logo-wrapper img, .logo-container img, img.company-logo-img');
      if (img && (!img.complete || img.naturalWidth === 0)) {
        var hasTriggered = false;
        var onReady = function() {
          if (hasTriggered) return;
          hasTriggered = true;
          paginateDocumentForPrint();
          triggerPrint();
        };
        img.onload = onReady;
        img.onerror = onReady;
        setTimeout(onReady, 2000);
        return;
      }

      paginateDocumentForPrint();
      triggerPrint();
    }

    if (document.readyState === 'complete') {
      initPrintProcess();
    } else {
      window.addEventListener('load', initPrintProcess);
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
 * Returns the HTML for the branded global OrbX print and preview footer.
 * Formatted with exact specifications:
 * Left: "Powered by OrbX | orbx.in"
 * Right: "Pages 1/1" (dynamically synchronized)
 */
export function getGlobalPrintFooterHtml(): string {
  return `
    <div class="orbx-global-print-footer" id="orbx-global-print-footer">
      <span class="orbx-footer-left">Powered by OrbX | orbx.in</span>
      <span class="orbx-footer-right">Pages <span class="orbx-curr-page">1</span>/<span class="orbx-total-pages">1</span></span>
    </div>
  `;
}

