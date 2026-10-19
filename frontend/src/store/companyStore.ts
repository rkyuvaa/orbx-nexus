import { create } from "zustand";
import { persist } from "zustand/middleware";
import api from "../api/client";

export interface CompanyData {
  id?: number;
  name: string;
  address?: string | null;
  city?: string | null;
  state?: string | null;
  pincode?: string | null;
  phone?: string | null;
  mobile?: string | null;
  email?: string | null;
  gstin?: string | null;
  pan?: string | null;
  tan?: string | null;
  financial_year_start_month?: number | null;
  logo?: string | null;
  logo_path?: string | null;

  show_logo?: boolean;
  voucher_paper_size?: "A4" | "A5";
  inward_paper_size?: "A4" | "A5";
  outward_paper_size?: "A4" | "A5";
  bill_paper_size?: "A4" | "A5";
  report_paper_size?: "A4" | "A5";
  grid_paper_size?: "A4" | "A5";

  voucher_title?: string | null;
  voucher_terms?: string | null;
  inward_title?: string | null;
  inward_terms?: string | null;
  outward_title?: string | null;
  outward_terms?: string | null;
  bill_title?: string | null;
  bill_terms?: string | null;
}

export interface PrintConfigData {
  showLogo: boolean;
  voucherPaperSize: "A4" | "A5";
  inwardPaperSize: "A4" | "A5";
  outwardPaperSize: "A4" | "A5";
  billPaperSize: "A4" | "A5";
  reportPaperSize: "A4" | "A5";
  gridPaperSize: "A4" | "A5";

  voucherTitle: string;
  voucherTerms: string;
  inwardTitle: string;
  inwardTerms: string;
  outwardTitle: string;
  outwardTerms: string;
  billTitle: string;
  billTerms: string;
}

export const DEFAULT_PRINT_CONFIG: PrintConfigData = {
  showLogo: true,
  voucherPaperSize: "A5",
  inwardPaperSize: "A4",
  outwardPaperSize: "A5",
  billPaperSize: "A4",
  reportPaperSize: "A4",
  gridPaperSize: "A4",

  voucherTitle: "Voucher Receipt",
  voucherTerms: "1. Subject to local jurisdiction.\n2. This is a computer-generated voucher and requires no physical signature.",
  inwardTitle: "Inward Challan",
  inwardTerms: "1. Received goods are subject to count & quality checks.\n2. Report discrepancies within 24 hours.",
  outwardTitle: "Delivery Note",
  outwardTerms: "1. Goods once sold/delivered cannot be taken back.\n2. Subject to company terms of carriage.",
  billTitle: "Labour Bill Invoice",
  billTerms: "1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.",
};

/**
 * Pre-decodes an image in the browser memory using HTMLImageElement.decode().
 * Ensures that the raster/vector data is ready for instant rendering in printouts.
 */
export async function preloadAndDecodeImage(src: string): Promise<boolean> {
  if (!src) return false;
  return new Promise<boolean>((resolve) => {
    try {
      const img = new Image();
      let resolved = false;

      const finish = async () => {
        if (resolved) return;
        resolved = true;
        if (typeof img.decode === "function") {
          try {
            await img.decode();
          } catch {
            // decode failure is non-fatal if onload succeeded
          }
        }
        resolve(true);
      };

      img.onload = finish;
      img.onerror = () => {
        if (!resolved) {
          resolved = true;
          resolve(false);
        }
      };

      img.src = src;

      // Handle already-cached or instantaneous data URLs
      if (img.complete && img.naturalWidth > 0) {
        finish();
      }

      // 3s fallback timeout so caller is never blocked
      setTimeout(() => {
        if (!resolved) {
          resolved = true;
          resolve(false);
        }
      }, 3000);
    } catch {
      resolve(false);
    }
  });
}

interface CompanyState {
  company: CompanyData | null;
  logoBase64: string | null;
  printConfig: PrintConfigData;
  isInitialized: boolean;
  isLoading: boolean;
  error: string | null;

  setCompany: (company: CompanyData | null) => void;
  fetchCompany: (force?: boolean) => Promise<CompanyData | null>;
  ensureReady: () => Promise<CompanyData | null>;
  invalidate: () => void;
}

// In-flight promise tracker to deduplicate concurrent requests across the app
let inFlightCompanyPromise: Promise<CompanyData | null> | null = null;

export const useCompanyStore = create<CompanyState>()(
  persist(
    (set, get) => ({
      company: null,
      logoBase64: null,
      printConfig: DEFAULT_PRINT_CONFIG,
      isInitialized: false,
      isLoading: false,
      error: null,

      setCompany: (company) => {
        if (!company) {
          try {
            localStorage.removeItem("company_logo");
          } catch {}
          set({ company: null, logoBase64: null, isInitialized: true, isLoading: false, error: null });
          return;
        }

        const logo = company.logo_path || company.logo || null;

        const printConfig: PrintConfigData = {
          showLogo: company.show_logo ?? true,
          voucherPaperSize: company.voucher_paper_size ?? "A5",
          inwardPaperSize: company.inward_paper_size ?? "A4",
          outwardPaperSize: company.outward_paper_size ?? "A5",
          billPaperSize: company.bill_paper_size ?? "A4",
          reportPaperSize: company.report_paper_size ?? "A4",
          gridPaperSize: company.grid_paper_size ?? "A4",

          voucherTitle: company.voucher_title ?? DEFAULT_PRINT_CONFIG.voucherTitle,
          voucherTerms: company.voucher_terms ?? DEFAULT_PRINT_CONFIG.voucherTerms,
          inwardTitle: company.inward_title ?? DEFAULT_PRINT_CONFIG.inwardTitle,
          inwardTerms: company.inward_terms ?? DEFAULT_PRINT_CONFIG.inwardTerms,
          outwardTitle: company.outward_title ?? DEFAULT_PRINT_CONFIG.outwardTitle,
          outwardTerms: company.outward_terms ?? DEFAULT_PRINT_CONFIG.outwardTerms,
          billTitle: company.bill_title ?? DEFAULT_PRINT_CONFIG.billTitle,
          billTerms: company.bill_terms ?? DEFAULT_PRINT_CONFIG.billTerms,
        };

        // Cache logo and print config for legacy references and instant synchronous reads
        if (logo) {
          try {
            localStorage.setItem("company_logo", logo);
          } catch {}
          preloadAndDecodeImage(logo).catch(() => {});
        } else {
          try {
            localStorage.removeItem("company_logo");
          } catch {}
        }

        try {
          localStorage.setItem("orbx_print_config", JSON.stringify(printConfig));
        } catch {}

        set({
          company,
          logoBase64: logo,
          printConfig,
          isInitialized: true,
          isLoading: false,
          error: null,
        });
      },

      fetchCompany: async (force = false) => {
        const token = localStorage.getItem("orbx_token");
        if (!token) {
          return null;
        }

        const current = get().company;
        if (!force && current && get().isInitialized) {
          return current;
        }

        if (inFlightCompanyPromise) {
          return inFlightCompanyPromise;
        }

        set({ isLoading: true, error: null });

        inFlightCompanyPromise = (async () => {
          try {
            const res = await api.get("/company/");
            const data: CompanyData = res.data;
            if (data) {
              get().setCompany(data);
              if (data.logo_path) {
                await preloadAndDecodeImage(data.logo_path);
              }
            }
            return data;
          } catch (err: any) {
            if (err.response?.status === 404) {
              get().setCompany(null);
              return null;
            }
            const msg = err.response?.data?.detail || err.message || "Failed to fetch company details";
            set({ error: msg, isLoading: false });
            return current;
          } finally {
            inFlightCompanyPromise = null;
          }
        })();

        return inFlightCompanyPromise;
      },

      ensureReady: async () => {
        const current = get().company;
        if (current && get().isInitialized) {
          if (current.logo_path) {
            preloadAndDecodeImage(current.logo_path).catch(() => {});
          }
          return current;
        }
        return get().fetchCompany();
      },

      invalidate: () => {
        set({ company: null, logoBase64: null, isInitialized: false, isLoading: false, error: null });
        try {
          localStorage.removeItem("company_logo");
          localStorage.removeItem("orbx_print_config");
        } catch {}
      },
    }),
    {
      name: "orbx-company",
      partialize: (state) => ({
        company: state.company,
        logoBase64: state.logoBase64,
        printConfig: state.printConfig,
        isInitialized: state.isInitialized,
      }),
    }
  )
);
