import { createBrowserRouter, Navigate } from "react-router-dom";
import AppShell from "../components/layout/AppShell";
import LoginPage from "../pages/auth/LoginPage";
import DashboardPage from "../pages/dashboard/DashboardPage";
import AccountsGroupPage from "../pages/accounts/AccountsGroupPage";
import LedgerPage from "../pages/accounts/LedgerPage";
import { ProductRegisterPage, ProcessRegisterPage, ProcessGroupsPage, RateRegisterPage, UoMPage } from "../pages/process/ProcessInfoPages";
import { InwardVoucherPage, OutwardVoucherPage } from "../pages/process-voucher/ProcessVoucherPages";
import LabourBillPage from "../pages/labour-bill/LabourBillPage";
import {
  ContractorAdvancePaymentPage, ContractorAdvanceReceiptPage,
  SalaryVoucherPage
} from "../pages/payroll/PayrollPages";
import {
  PaymentVoucherPage, ReceiptVoucherPage, ContraVoucherPage,
  JournalVoucherPage, PurchaseVoucherPage
} from "../pages/vouchers/AccountsVoucherPages";
import {
  DayBookReport, InwardRegisterReport, OutwardRegisterReport,
  LabourBillRegisterReport, TrialBalanceReport, PendingBillsReport,
  StockInHandReport, StockSummaryReport
} from "../pages/reports/ReportPages";
import UserManagementPage from "../pages/admin/UserManagementPage";
import BiometricsPage from "../pages/admin/BiometricsPage";
import BackupsPage from "../pages/admin/BackupsPage";
import AuditLogsPage from "../pages/admin/AuditLogsPage";
import FinancialYearsPage from "../pages/admin/FinancialYearsPage";
import PrintConfigPage from "../pages/admin/PrintConfigPage";
import CompanyPage from "../pages/master/CompanyPage";
import StockTransferPage from "../pages/inventory/StockTransferPage";
import DocumentNumberingPage from "../pages/settings/DocumentNumberingPage";
import ContractorPages from "../pages/contractor/ContractorPages";
import StockItemsPage from "../pages/inventory/StockItemsPage";
import StockAdjustmentPage from "../pages/inventory/StockAdjustmentPage";
import { InventoryInwardPage, InventoryOutwardPage } from "../pages/inventory/InventoryMovementPages";
import LocationsPage from "../pages/inventory/LocationsPage";
import { useAuthStore } from "../store";

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { token } = useAuthStore();
  if (!token) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

export const router = createBrowserRouter([
  { path: "/login", element: <LoginPage /> },
  {
    path: "/",
    element: <ProtectedRoute><AppShell /></ProtectedRoute>,
    children: [
      { path: "", element: <DashboardPage /> },

      // Master
      { path: "master/company", element: <CompanyPage /> },
      { path: "master/statutory", element: <CompanyPage /> },
      { path: "master/suppliers", element: <LedgerPage ledgerType="Account" title="Supplier" breadcrumbs={[{ label: "Masters" }, { label: "Supplier" }]} /> },

      // Accounts Info
      { path: "accounts/groups", element: <AccountsGroupPage /> },
      { path: "accounts/staff", element: <LedgerPage ledgerType="Staff" title="Staff Ledgers" breadcrumbs={[{ label: "Accounts Info" }, { label: "Staff Ledgers" }]} /> },

      // Inventory
      { path: "inventory/stock-in-hand", element: <StockInHandReport /> },
      { path: "inventory/stock-summary", element: <StockSummaryReport /> },
      { path: "inventory/tools-consumables", element: <StockItemsPage /> },
      { path: "inventory/uom", element: <UoMPage /> },
      { path: "inventory/inward",  element: <InventoryInwardPage /> },
      { path: "inventory/outward", element: <InventoryOutwardPage /> },
      { path: "inventory/adjustments", element: <StockAdjustmentPage /> },
      { path: "inventory/locations", element: <LocationsPage /> },

      // Purchase
      { path: "purchase/tools-consumables", element: <InventoryInwardPage /> },

      // Process Info
      { path: "process/products", element: <ProductRegisterPage /> },
      { path: "process/processes", element: <ProcessRegisterPage /> },
      { path: "process/groups", element: <ProcessGroupsPage /> },
      { path: "process/rates", element: <RateRegisterPage /> },

      // Process Voucher
      { path: "process-voucher/inward", element: <InwardVoucherPage /> },
      { path: "process-voucher/outward", element: <OutwardVoucherPage /> },

      // Labour Bill
      { path: "labour-bill", element: <LabourBillPage /> },

      // Payroll
      { path: "payroll/contractors", element: <LedgerPage ledgerType="Contractor" title="Contractor" breadcrumbs={[{ label: "HR and Payroll" }, { label: "Contractor" }]} /> },
      { path: "payroll/salary", element: <SalaryVoucherPage /> },

      // Contractor Voucher
      { path: "contractor/rates", element: <ContractorPages type="rates" /> },
      { path: "contractor/job-work", element: <ContractorPages type="job-work" /> },
      { path: "contractor/advance-payment", element: <ContractorAdvancePaymentPage /> },
      { path: "contractor/advance-receipt", element: <ContractorAdvanceReceiptPage /> },
      { path: "contractor/payment", element: <ContractorPages type="payment" /> },

      // Accounts Voucher
      { path: "vouchers/payment", element: <PaymentVoucherPage /> },
      { path: "vouchers/receipt", element: <ReceiptVoucherPage /> },
      { path: "vouchers/contra", element: <ContraVoucherPage /> },
      { path: "vouchers/journal", element: <JournalVoucherPage /> },
      { path: "vouchers/purchase", element: <PurchaseVoucherPage /> },

      // Inventory Stock Transfer
      { path: "inventory/stock-transfer", element: <StockTransferPage /> },

      // Reports
      { path: "reports/day-book", element: <DayBookReport /> },
      { path: "reports/ledger-account", element: <DayBookReport /> },
      { path: "reports/inward-register", element: <InwardRegisterReport /> },
      { path: "reports/outward-register", element: <OutwardRegisterReport /> },
      { path: "reports/labour-bill-register", element: <LabourBillRegisterReport /> },
      { path: "reports/trial-balance", element: <TrialBalanceReport /> },
      { path: "reports/pending-bills", element: <PendingBillsReport /> },
      { path: "reports/receivables", element: <PendingBillsReport /> },
      { path: "reports/payables", element: <PendingBillsReport /> },
      { path: "reports/staff-salary", element: <LabourBillRegisterReport /> },
      { path: "reports/monthly", element: <DayBookReport /> },
      { path: "reports/stock-in-hand", element: <StockInHandReport /> },
      { path: "reports/stock-summary", element: <StockSummaryReport /> },

      // Admin
      { path: "admin/users", element: <UserManagementPage /> },
      { path: "admin/financial-years", element: <FinancialYearsPage /> },
      { path: "settings/document-numbering", element: <DocumentNumberingPage /> },
      { path: "settings/print-config", element: <PrintConfigPage /> },
      { path: "biometrics", element: <BiometricsPage /> },
      { path: "backups", element: <BackupsPage /> },
      { path: "audit", element: <AuditLogsPage /> },
      { path: "*", element: <Navigate to="/" replace /> },
    ],
  },
]);
