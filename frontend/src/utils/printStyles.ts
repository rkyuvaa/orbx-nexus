export const COMMON_PRINT_CSS = `
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
  
  * { -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; color-adjust: exact !important; box-sizing: border-box; }
  
  html, body { min-height: 100vh; height: 100%; margin: 0; padding: 0; }
  body { display: flex; flex-direction: column; font-family: 'Inter', sans-serif; color: #1a1a1a; background-color: #fff; line-height: 1.5; font-size: 11px; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  
  /* Header & Branding */
  .header-container { display: flex; justify-content: space-between; align-items: center; border-bottom: 0.5px solid #198754; padding-bottom: 12px; margin-bottom: 16px; }
  .logo-wrapper { flex: 0 0 120px; }
  .logo-wrapper img { max-height: 60px; max-width: 120px; object-fit: contain; }
  .company-details { flex: 1; text-align: center; margin-right: 120px; }
  .company-details h1 { margin: 0; font-size: 22px; color: #0f5132; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
  .company-details p { margin: 3px 0 0 0; font-size: 11px; color: #2d3748; }
  .company-details .gstin { font-weight: 700; color: #0f5132; }
  
  /* Document Title & Meta */
  .title-section { display: flex; justify-content: flex-end; align-items: flex-end; flex-direction: column; margin-bottom: 16px; border-bottom: 0.5px solid #198754; padding-bottom: 8px; }
  .title-section h2 { margin: 0 0 4px 0; font-size: 18px; color: #0f5132; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; }
  .title-section .doc-no { font-size: 13px; color: #0f5132; font-weight: 700; }
  .title-section .doc-date { font-size: 11px; color: #2d3748; margin-top: 2px; }
  
  /* Addresses */
  .address-section { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 16px; }
  .address-column h3 { margin: 0 0 6px 0; font-size: 11px; color: #0f5132; font-weight: 700; text-transform: uppercase; border-bottom: 0.5px solid #198754; padding-bottom: 2px; }
  .address-column .name { font-size: 12px; font-weight: 700; color: #000000; margin-bottom: 4px; text-transform: uppercase; }
  .address-column .address-lines { color: #2d3748; line-height: 1.4; margin-bottom: 4px; }
  .address-column .gstin { font-weight: 600; color: #0f5132; }
  
  /* Green Theme Table - Vertical Column Separation Only, No Horizontal Row Lines */
  table.items-table { width: 100%; border-collapse: collapse; margin-bottom: 16px; border: 0.5px solid #198754; }
  table.items-table thead tr { background-color: #0f5132 !important; color: #ffffff !important; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  table.items-table th { background-color: #0f5132 !important; color: #ffffff !important; border: 0.5px solid #198754 !important; padding: 8px 6px; font-weight: 700; font-size: 11px; text-transform: uppercase; text-align: left; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  table.items-table td { padding: 8px 6px; border-left: 0.5px solid #198754; border-right: 0.5px solid #198754; border-top: none; border-bottom: none; color: #000000; font-size: 11px; }
  table.items-table tr { border-bottom: none; }
  table.items-table tfoot tr, table.items-table tr.total-row { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; background-color: #f0fdf4 !important; font-weight: 700; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  table.items-table tfoot td, table.items-table tr.total-row td { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; border-left: 0.5px solid #198754; border-right: 0.5px solid #198754; color: #0f5132; font-size: 11px; }

  /* Totals Section Above Bottom Section */
  .totals-section { display: flex; justify-content: flex-end; margin-top: auto; margin-bottom: 16px; }
  .calculation-box { display: flex; flex-direction: column; align-items: flex-end; min-width: 280px; }
  .calculation-row { display: flex; justify-content: space-between; width: 100%; padding: 4px 8px; color: #1a1a1a; font-size: 11px; }
  .calculation-row.grand-total { border-top: 0.5px solid #198754; border-bottom: 0.5px solid #198754; background-color: #f0fdf4 !important; padding: 8px; margin-top: 4px; font-size: 13px; font-weight: 700; color: #0f5132; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  .amount-in-words { font-size: 11px; font-style: italic; color: #0f5132; text-align: right; margin-top: 6px; font-weight: 600; }

  /* Bottom Section Pinned to Very Bottom of Page */
  .bottom-section { margin-top: 8px; padding-top: 12px; border-top: 0.5px solid #198754; page-break-inside: avoid; }
  .narration-box { font-size: 11px; margin-bottom: 12px; color: #1a1a1a; background-color: #f0fdf4 !important; padding: 8px 12px; border-left: 3px solid #0f5132; border-radius: 4px; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }
  .narration-box strong { color: #0f5132; }
  
  .terms-box { font-size: 10.5px; color: #2d3748; margin-bottom: 16px; }
  .terms-box h4 { margin: 0 0 6px 0; font-size: 11px; color: #0f5132; font-weight: 700; text-transform: uppercase; }
  .terms-box ol { margin: 0; padding-left: 18px; color: #2d3748; }
  .terms-box li { margin-bottom: 3px; }

  .signatures-container { display: flex; justify-content: space-between; margin-top: 30px; }
  .signature-block { text-align: center; width: 180px; }
  .signature-line { border-bottom: 0.5px solid #198754; margin-bottom: 6px; height: 30px; }
  .signature-label { font-size: 10px; color: #0f5132; font-weight: 600; }
  .thank-you-note { text-align: center; font-size: 10px; color: #0f5132; margin-top: 16px; font-weight: 600; }
`;

export function getPageSizeCSS(paperSize: "A4" | "A5"): string {
  if (paperSize === "A5") return "A5 landscape";
  return "A4";
}

export function injectPrintStyles(css: string): void {
  if (document.getElementById("orbx-print-styles")) return;
  const style = document.createElement("style");
  style.id = "orbx-print-styles";
  style.textContent = css;
  document.head.appendChild(style);
}
