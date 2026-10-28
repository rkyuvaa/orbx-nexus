import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, Typography, Paper, Chip,
  MenuItem, Divider, CircularProgress, Alert
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Print from "@mui/icons-material/Print";
import Calculate from "@mui/icons-material/Calculate";
import EventAvailable from "@mui/icons-material/EventAvailable";
import CalendarMonth from "@mui/icons-material/CalendarMonth";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore, useCompanyStore } from "../../store";
import { formatAmount } from "../../utils/format";
import { COMMON_PRINT_CSS, getCompanyLogoHtml, PRINT_TRIGGER_SCRIPT, ensurePrintReady, resolveCompanyDetails, getGlobalPrintFooterHtml, getPageSizeCSS } from "../../utils/printStyles";
import { toWords } from "../../utils/numberToWords";

const today = new Date().toISOString().split("T")[0];

// Reusable voucher form + grid for Payment/Receipt, Staff/Contractor
function VoucherModule({
  title,
  breadcrumbs,
  endpoint,
  queryKey,
  ledgerType,
  paymentType,
}: any) {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: [queryKey, activeFY],
    queryFn: async () => (await api.get(`${endpoint}?fy=${activeFY}&ledger_type=${ledgerType}&payment_type=${paymentType}`)).data,
  });

  const { data: companyData } = useQuery({ queryKey: ["company"], queryFn: async () => (await api.get("/company/")).data });

  const { data: rawLedgers = [] } = useQuery({
    queryKey: ["ledgers", ledgerType],
    queryFn: async () => (await api.get(`/ledgers/?ledger_type=${ledgerType}&is_active=true`)).data,
  });

  const ledgers = useMemo(() => {
    return rawLedgers.filter((l: any) =>
      !l.name.includes("(Staff Advance)") &&
      !l.name.includes("(Contractor Advance)")
    );
  }, [rawLedgers]);

  const { register, handleSubmit, reset, control } = useForm({
    defaultValues: { voucher_no: "", voucher_date: today, ledger_id: "", payment_type: paymentType, ledger_type: ledgerType, amount: 0, narration: "" },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const payload = { ...data, payment_type: paymentType, ledger_type: ledgerType };
      if (editing) {
        return api.put(`${endpoint}/${editing.id}?fy=${activeFY}`, payload);
      }
      return api.post(`${endpoint}?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: [queryKey] });
      setOpen(false);
      setEditing(null);
    },
    onError: (err: any) => alert(`Failed to save. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`${endpoint.replace("/advances", `/advances/${id}`)}?fy=${activeFY}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: [queryKey] }),
    onError: (err: any) => alert(`Failed to delete. ${err?.response?.data?.detail || err.message || ""}`),
  });

  const handleDeleteRow = (id: number) => {
    if (window.confirm("Delete this record? This cannot be undone.")) {
      deleteMutation.mutate(id);
    }
  };

  const handleEditRow = (row: any) => {
    setEditing(row);
    reset({
      voucher_no: row.voucher_no || "",
      voucher_date: row.voucher_date || today,
      ledger_id: row.ledger_id || "",
      payment_type: paymentType,
      ledger_type: ledgerType,
      amount: row.amount || 0,
      narration: row.narration || "",
    });
    setOpen(true);
  };

  const handlePrintVoucher = (row: any) => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const savedConfig = localStorage.getItem("orbx_print_config");
    let printConfig = { showLogo: true, billPaperSize: "A5", voucherPaperSize: "A5" };
    if (savedConfig) {
      try { printConfig = { ...printConfig, ...JSON.parse(savedConfig) }; } catch (e) {}
    }

    const compData = (Array.isArray(companyData) ? companyData[0] : companyData) || useCompanyStore.getState().company;
    const logoHtml = getCompanyLogoHtml(printConfig.showLogo, compData);
    const cName = compData?.name || compData?.company_name || "SRI METAL";
    const cAddress = compData?.address || [compData?.address_line1, compData?.address_line2].filter(Boolean).join(", ") || "";
    const cCityStatePin = [compData?.city, compData?.state, compData?.pincode].filter(Boolean).join(" - ");
    const cPhone = compData?.phone || compData?.mobile ? `Tel: ${[compData?.phone, compData?.mobile].filter(Boolean).join(" / ")}` : "";
    const cEmail = compData?.email ? `Email: ${compData?.email}` : "";
    const cTax = compData?.gstin ? `GSTIN: ${compData?.gstin}` : "";

    const dateStr = new Date(row.voucher_date).toLocaleDateString("en-IN", {
      day: "2-digit", month: "2-digit", year: "numeric"
    }).replace(/\//g, "-");

    const l = ledgers.find((item: any) => item.id === row.ledger_id || item.id === Number(row.ledger_id));
    const code = row.staff_code || row.ledger_code || l?.ledger_code || "";
    const name = row.staff_name || row.ledger_name || l?.name || row.ledger_id;
    const designation = l?.designation || row.designation || "";
    const department = l?.department || row.department || "";
    const contactPhone = l?.mobile || l?.phone || "";

    const isPayment = paymentType === "Payment";
    const docTitle = isPayment ? `ADVANCE PAYMENT VOUCHER` : `ADVANCE RECEIPT VOUCHER`;
    const partyRoleLabel = isPayment ? "PAID TO (BENEFICIARY):" : "RECEIVED FROM:";
    const amountVal = Number(row.amount || 0);
    const amountInWordsStr = amountVal > 0 ? toWords(amountVal) : "";
    const paperSize = printConfig.voucherPaperSize || printConfig.billPaperSize || "A4";

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>${docTitle} - ${row.voucher_no}</title>
          <style>
            @page { size: ${paperSize} portrait; margin: 10mm; }
            ${COMMON_PRINT_CSS}
            .signatures-container { margin-top: 35px; page-break-inside: avoid; }
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
            <h2>${docTitle}</h2>
            <div class="doc-no">Voucher No: <strong>${row.voucher_no}</strong></div>
            <div class="doc-date">Date: <strong>${dateStr}</strong></div>
          </div>

          <!-- Beneficiary & Voucher Meta Section -->
          <div class="address-section" style="margin-top: 10px; margin-bottom: 12px;">
            <div class="address-column">
              <h3>${partyRoleLabel}</h3>
              <div class="name">${name}</div>
              ${code ? `<div style="font-size: 10px; color: #334155; margin-top: 2px;"><strong>${ledgerType} Code:</strong> ${code}</div>` : ""}
              ${designation ? `<div style="font-size: 10px; color: #334155; margin-top: 1px;"><strong>Designation:</strong> ${designation}</div>` : ""}
              ${department ? `<div style="font-size: 10px; color: #334155; margin-top: 1px;"><strong>Department:</strong> ${department}</div>` : ""}
              ${contactPhone ? `<div style="font-size: 10px; color: #334155; margin-top: 1px;"><strong>Contact:</strong> ${contactPhone}</div>` : ""}
            </div>
            <div class="address-column">
              <h3>VOUCHER PARTICULARS:</h3>
              <div style="font-size: 10px; color: #334155; margin-bottom: 2px;"><strong>Voucher Type:</strong> Advance ${paymentType}</div>
              <div style="font-size: 10px; color: #334155; margin-bottom: 2px;"><strong>Category:</strong> ${ledgerType} Ledger</div>
              <div style="font-size: 10px; color: #334155; margin-bottom: 2px;"><strong>Payment Mode:</strong> Cash / Bank</div>
              <div style="font-size: 10px; color: #334155; margin-bottom: 2px;"><strong>Posting Date:</strong> ${dateStr}</div>
            </div>
          </div>

          <!-- Particulars Table -->
          <table class="items-table" style="width: 100%; margin-top: 12px; border-collapse: collapse;">
            <thead>
              <tr>
                <th style="width: 40px; text-align: center;">#</th>
                <th style="text-align: left;">Particulars / Description</th>
                <th style="width: 130px; text-align: right;">Amount (₹)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style="text-align: center; vertical-align: top; padding-top: 8px;">1</td>
                <td style="padding-top: 8px; padding-bottom: 8px;">
                  <div style="font-weight: 700; font-size: 11px; text-transform: uppercase; color: #0f5132;">
                    Advance ${paymentType} — ${ledgerType}
                  </div>
                  <div style="font-size: 10px; color: #475569; margin-top: 3px;">
                    ${isPayment
                      ? `Being advance payment disbursed to ${name}${code ? ` (${code})` : ""}`
                      : `Being advance repayment / refund received from ${name}${code ? ` (${code})` : ""}`
                    }
                  </div>
                  ${row.narration ? `
                    <div style="margin-top: 5px; font-size: 10px; color: #1e293b; background-color: #f1f5f9; padding: 4px 8px; border-radius: 4px; display: inline-block;">
                      <strong>Narration:</strong> ${row.narration}
                    </div>
                  ` : ""}
                </td>
                <td style="text-align: right; font-weight: 700; font-size: 12px; vertical-align: top; padding-top: 8px;">
                  ₹${formatAmount(amountVal)}
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr class="total-row">
                <td colspan="2" style="text-align: right; text-transform: uppercase; font-weight: 700; font-size: 11px;">
                  Total Amount (${paymentType === 'Payment' ? 'Paid' : 'Received'})
                </td>
                <td style="text-align: right; font-weight: 800; font-size: 13px; color: #0f5132;">
                  ₹${formatAmount(amountVal)}
                </td>
              </tr>
            </tfoot>
          </table>

          <!-- Amount In Words -->
          ${amountInWordsStr ? `
            <div style="margin-top: 8px; padding: 8px 12px; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 10.5px; color: #0f5132;">
              <strong>AMOUNT IN WORDS:</strong> ${amountInWordsStr.replace(/^Rupees:\s*/i, "").replace(/\s*Rupees Only$/i, "").trim().toUpperCase()} RUPEES ONLY
            </div>
          ` : ""}

          <!-- Three Signature Blocks: Issued By, Received By, Authorised Signatory -->
          <div class="signatures-container" style="margin-top: 45px; page-break-inside: avoid;">
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">
                ${isPayment ? "Issued By" : "Received By"}<br/>
                <span style="font-size: 8.5px; color: #64748b;">(Accounts / Cashier)</span>
              </div>
            </div>
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">
                ${isPayment ? "Received By" : "Paid / Deposited By"}<br/>
                <span style="font-size: 8.5px; color: #64748b;">(${name})</span>
              </div>
            </div>
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">
                Authorised Signatory<br/>
                <span style="font-size: 8.5px; color: #64748b;">For ${cName}</span>
              </div>
            </div>
          </div>

          ${getGlobalPrintFooterHtml()}
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140 },
    { field: "voucher_date", headerName: "Date", width: 100 },
    {
      field: "ledger_id",
      headerName: ledgerType === "Staff" ? "Staff Member" : "Contractor",
      width: 220,
      cellRenderer: (p: any) => {
        const l = ledgers.find((item: any) => item.id === p.value || item.id === Number(p.value));
        const code = p.data?.staff_code || p.data?.ledger_code || l?.ledger_code;
        const name = p.data?.staff_name || p.data?.ledger_name || l?.name || p.value;
        return (
          <Box>
            <span style={{ fontWeight: 600 }}>{name}</span>
            {code && <span style={{ fontSize: "0.75rem", color: "#64748b", marginLeft: "6px" }}>({code})</span>}
          </Box>
        );
      }
    },
    { field: "amount", headerName: "Amount", width: 120, type: "numericColumn", valueFormatter: (p) => `₹${formatAmount(p.value)}` },
    { field: "narration", headerName: "Narration", flex: 1 },
    {
      headerName: "Actions",
      width: 130,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 0.5 }}>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => handleEditRow(p.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Print A5 Voucher">
            <IconButton size="small" color="primary" onClick={() => handlePrintVoucher(p.data)}>
              <Print fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton size="small" color="error" onClick={() => handleDeleteRow(p.data.id)}>
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <PageHeader title={title} breadcrumbs={breadcrumbs} />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={async () => {
          setEditing(null);
          let nextNo = "";
          try {
            const ltype = ledgerType.toLowerCase();
            const ptype = paymentType.toLowerCase();
            const seqType = ltype === "contractor" ? `job_work_advance_${ptype}` : `${ltype}_advance_${ptype}`;
            const res = await api.get(`/sequences/preview/${seqType}`);
            nextNo = res.data.next_no;
          } catch (e) {
            console.error(e);
          }
          reset({
            voucher_no: nextNo,
            voucher_date: today,
            ledger_id: "",
            payment_type: paymentType,
            ledger_type: ledgerType,
            amount: 0,
            narration: "",
          });
          setOpen(true);
        }}
        addLabel="New Entry"
      />
      <Dialog open={open} onClose={() => { setOpen(false); setEditing(null); }} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>{editing ? `Edit ${title}` : title}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 6 }}><TextField {...register("voucher_date")} label="Date *" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><Controller name="ledger_id" control={control} rules={{ required: "Required" }} render={({ field, fieldState }) => (
                <LazyAutocomplete options={ledgers} getOptionLabel={(o: any) => `${o.name}${o.ledger_code ? ` (${o.ledger_code})` : ""}`} value={ledgers.find((l: any) => l.id === field.value) || null} onChange={(_, v) => field.onChange(v ? v.id : "")} renderInput={(params) => <TextField {...params} label={`${ledgerType === "Staff" ? "Staff Member" : ledgerType} *`} error={!!fieldState.error} helperText={fieldState.error?.message} />} />
              )} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("amount")} label="Amount" type="number" fullWidth slotProps={{ inputLabel: { shrink: true } }} /></Grid>
              <Grid size={{ xs: 12 }}><TextField {...register("narration")} label="Narration" fullWidth multiline rows={2} slotProps={{ inputLabel: { shrink: true } }} /></Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => { setOpen(false); setEditing(null); }} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}

export function StaffAdvancePaymentPage() {
  return <VoucherModule title="Advance Payment (Staff)" queryKey="staff-advance-pay" endpoint="/payroll/advances" ledgerType="Staff" paymentType="Payment" breadcrumbs={[{ label: "Salary and Wages" }, { label: "Advance Payment" }]} />;
}
export function StaffAdvanceReceiptPage() {
  return <VoucherModule title="Advance Receipt (Staff)" queryKey="staff-advance-rec" endpoint="/payroll/advances" ledgerType="Staff" paymentType="Receipt" breadcrumbs={[{ label: "Salary and Wages" }, { label: "Advance Receipt" }]} />;
}
export function ContractorAdvancePaymentPage() {
  return <VoucherModule title="Advance Payment (Contractor)" queryKey="cont-advance-pay" endpoint="/payroll/advances" ledgerType="Contractor" paymentType="Payment" breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Advance Payment" }]} />;
}
export function ContractorAdvanceReceiptPage() {
  return <VoucherModule title="Advance Receipt (Contractor)" queryKey="cont-advance-rec" endpoint="/payroll/advances" ledgerType="Contractor" paymentType="Receipt" breadcrumbs={[{ label: "Contractor Voucher" }, { label: "Advance Receipt" }]} />;
}

const MONTH_NAMES = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

const DAY_NAMES = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

function getWeeklyPayCycle(referenceDateStr?: string, payoutDayName: string = "Saturday") {
  const d = referenceDateStr ? new Date(referenceDateStr) : new Date();
  if (isNaN(d.getTime())) return { from_date: "", to_date: "", payout_date: "" };

  const targetDayIdx = DAY_NAMES.indexOf(payoutDayName) >= 0 ? DAY_NAMES.indexOf(payoutDayName) : 6;
  const currentDayIdx = d.getDay();

  // Find the anchor payout date (most relevant payout date <= referenceDate, or referenceDate if it is on payoutDay)
  let diff = currentDayIdx - targetDayIdx;
  if (diff < 0) diff += 7;

  const payoutDate = new Date(d);
  payoutDate.setDate(d.getDate() - diff);

  // to_date = payoutDate - 1 day (e.g. Friday if payout is Saturday)
  const toDate = new Date(payoutDate);
  toDate.setDate(payoutDate.getDate() - 1);

  // from_date = payoutDate - 7 days (e.g. previous Saturday)
  const fromDate = new Date(payoutDate);
  fromDate.setDate(payoutDate.getDate() - 7);

  const formatDateYMD = (dt: Date) => {
    const y = dt.getFullYear();
    const m = String(dt.getMonth() + 1).padStart(2, "0");
    const day = String(dt.getDate()).padStart(2, "0");
    return `${y}-${m}-${day}`;
  };

  return {
    from_date: formatDateYMD(fromDate),
    to_date: formatDateYMD(toDate),
    payout_date: formatDateYMD(payoutDate)
  };
}

function formatDisplayDate(dateStr?: string) {
  if (!dateStr) return "";
  try {
    const parts = String(dateStr).split("T")[0].split("-");
    if (parts.length === 3) return `${parts[2]}-${parts[1]}-${parts[0]}`;
    return dateStr;
  } catch {
    return dateStr;
  }
}

export function SalaryVoucherPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [viewVoucher, setViewVoucher] = useState<any>(null);

  const { data: items = [], isLoading, refetch } = useQuery({
    queryKey: ["salary-vouchers", activeFY],
    queryFn: async () => (await api.get(`/payroll/salary?fy=${activeFY}`)).data,
  });

  const { data: payrollConfig } = useQuery({
    queryKey: ["payroll-config"],
    queryFn: async () => (await api.get("/payroll/config-settings/")).data,
  });
  const configuredPayoutDay = payrollConfig?.payout_day || "Saturday";

  const { data: ledgers = [] } = useQuery({
    queryKey: ["ledgers", "Staff"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Staff&is_active=true")).data
  });

  const staffMembers = useMemo(() => {
    return ledgers.filter((l: any) => 
      !l.name.includes("(Staff Advance)") && 
      !l.name.includes("(Contractor Advance)")
    );
  }, [ledgers]);

  const staffMap = useMemo(() => {
    const map: Record<number, any> = {};
    ledgers.forEach((l: any) => { map[l.id] = l; });
    return map;
  }, [ledgers]);

  const { register, handleSubmit, reset, control, setValue, watch, getValues } = useForm({
    defaultValues: {
      voucher_no: "",
      voucher_date: today,
      ledger_id: "" as any,
      pay_period_type: "Monthly",
      from_date: "",
      to_date: "",
      month: new Date().getMonth() + 1,
      year: new Date().getFullYear(),
      pay_type: "Daily",
      days_worked: 0,
      total_hours: 0,
      hourly_rate: 0,
      basic_salary: 0,
      per_day_salary: 0,
      payable_amount: 0,
      allowances: 0,
      deductions: 0,
      net_salary: 0,
      narration: "",
    },
  });

  const watchLedgerId = watch("ledger_id");
  const watchPayPeriodType = watch("pay_period_type") || "Monthly";
  const watchFromDate = watch("from_date");
  const watchToDate = watch("to_date");
  const watchVoucherDate = watch("voucher_date");
  const watchMonth = Number(watch("month") || (new Date().getMonth() + 1));
  const watchYear = Number(watch("year") || new Date().getFullYear());
  const watchPayType = watch("pay_type");
  const watchTotalHours = watch("total_hours");
  const watchHourlyRate = watch("hourly_rate");
  const watchDaysWorked = watch("days_worked");
  const watchPerDaySalary = watch("per_day_salary");
  const watchAllowances = watch("allowances");
  const watchDeductions = watch("deductions");
  const watchBasicSalary = watch("basic_salary");

  const isWeekly = watchPayPeriodType === "Weekly";

  // Fetch real-time attendance stats from biometric entries for chosen staff & period
  const { data: attendanceStats, isFetching: isStatsLoading } = useQuery({
    queryKey: [
      "staff-attendance-stats", activeFY, watchLedgerId,
      isWeekly ? "weekly" : "monthly",
      isWeekly ? watchFromDate : watchMonth,
      isWeekly ? watchToDate : watchYear
    ],
    queryFn: async () => {
      if (!watchLedgerId) return null;
      let url = `/payroll/staff-attendance-stats?fy=${activeFY}&ledger_id=${watchLedgerId}&month=${watchMonth}&year=${watchYear}&pay_period_type=${watchPayPeriodType}`;
      if (isWeekly && watchFromDate && watchToDate) {
        url += `&from_date=${watchFromDate}&to_date=${watchToDate}`;
      }
      return (await api.get(url)).data;
    },
    enabled: Boolean(
      open && watchLedgerId && 
      (isWeekly ? (watchFromDate && watchToDate) : (watchMonth && watchYear))
    ),
  });

  // When attendanceStats updates for a new entry, auto-populate working days, per-day salary, and payable
  useEffect(() => {
    if (attendanceStats && open && !editing) {
      const isHourly = Boolean(
        attendanceStats.is_hourly ||
        attendanceStats.staff_category === "Labour" ||
        Number(attendanceStats.hourly_rate || 0) > 0
      );
      const workingDays = Number(attendanceStats.working_days ?? 0);
      const totalHours = Number(attendanceStats.total_hours ?? 0);
      const hourlyRate = Number(attendanceStats.hourly_rate ?? 0);
      const perDay = Number(attendanceStats.per_day_salary ?? 0);
      const basic = Number(attendanceStats.basic_salary ?? 0);

      const payableCalc = isHourly
        ? Math.round((totalHours * hourlyRate) * 100) / 100
        : Math.round((workingDays * perDay) * 100) / 100;

      const al = Number(getValues("allowances") || 0);
      const ded = Number(getValues("deductions") || 0);
      const netCalc = Math.round((payableCalc + al - ded) * 100) / 100;

      setValue("pay_type", isHourly ? "Hourly" : "Daily");
      setValue("total_hours", totalHours);
      setValue("hourly_rate", hourlyRate);
      setValue("days_worked", workingDays);
      setValue("per_day_salary", perDay);
      setValue("basic_salary", basic);
      setValue("payable_amount", payableCalc);
      setValue("net_salary", netCalc);
    }
  }, [attendanceStats, open, editing, setValue, getValues]);

  // Reactive calculation: Payable
  const payable = useMemo(() => {
    if (watchPayType === "Hourly") {
      const th = Number(watchTotalHours || 0);
      const hr = Number(watchHourlyRate || 0);
      return Math.round((th * hr) * 100) / 100;
    }
    const dw = Number(watchDaysWorked || 0);
    const pds = Number(watchPerDaySalary || 0);
    return Math.round((dw * pds) * 100) / 100;
  }, [watchPayType, watchTotalHours, watchHourlyRate, watchDaysWorked, watchPerDaySalary]);

  // Reactive calculation: Net Salary = Payable + Allowances - Deductions
  const netSalary = useMemo(() => {
    const al = Number(watchAllowances || 0);
    const ded = Number(watchDeductions || 0);
    return Math.round((payable + al - ded) * 100) / 100;
  }, [payable, watchAllowances, watchDeductions]);

  // Keep form values in sync with calculated amounts
  useEffect(() => {
    setValue("payable_amount", payable);
    setValue("net_salary", netSalary);
  }, [payable, netSalary, setValue]);

  const saveMutation = useMutation({
    mutationFn: (data: any) => {
      const isWk = (data.pay_period_type || watchPayPeriodType) === "Weekly";
      const payload = {
        ...data,
        pay_period_type: data.pay_period_type || (watchPayPeriodType === "Weekly" ? "Weekly" : "Monthly"),
        from_date: isWk ? (data.from_date || watchFromDate || null) : null,
        to_date: isWk ? (data.to_date || watchToDate || null) : null,
        pay_type: data.pay_type || (watchPayType === "Hourly" ? "Hourly" : "Daily"),
        days_worked: Number(data.days_worked || 0),
        total_hours: Number(data.total_hours || 0),
        hourly_rate: Number(data.hourly_rate || 0),
        per_day_salary: Number(data.per_day_salary || 0),
        payable_amount: Number(payable || 0),
        basic_salary: Number(data.basic_salary || 0),
        allowances: Number(data.allowances || 0),
        deductions: Number(data.deductions || 0),
        net_salary: Number(netSalary || 0),
      };
      if (editing) {
        return api.put(`/payroll/salary/${editing.id}?fy=${activeFY}`, payload);
      }
      return api.post(`/payroll/salary?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["salary-vouchers"] });
      setOpen(false);
      setEditing(null);
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || err?.message || "Failed to save salary voucher");
    }
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/payroll/salary/${id}?fy=${activeFY}`),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ["salary-vouchers"] }); },
    onError: () => alert("Failed to delete salary voucher."),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: async (rows: any[]) => {
      await Promise.all(rows.map((r) => api.delete(`/payroll/salary/${r.id}?fy=${activeFY}`)));
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["salary-vouchers"] });
    },
    onError: (err: any) => {
      alert(err?.response?.data?.detail || "Failed to delete selected salary vouchers");
    },
  });

  const handleEditRow = (row: any) => {
    setEditing(row);
    const isHourly = row.pay_type === "Hourly" || (Number(row.hourly_rate) > 0 && !Number(row.per_day_salary));
    const isWk = row.pay_period_type === "Weekly" || Boolean(row.from_date && row.to_date);
    reset({
      voucher_no: row.voucher_no || "",
      voucher_date: row.voucher_date ? row.voucher_date.split("T")[0] : today,
      ledger_id: row.ledger_id || "",
      pay_period_type: isWk ? "Weekly" : "Monthly",
      from_date: row.from_date ? row.from_date.split("T")[0] : "",
      to_date: row.to_date ? row.to_date.split("T")[0] : "",
      month: row.month || (new Date().getMonth() + 1),
      year: row.year || new Date().getFullYear(),
      pay_type: isHourly ? "Hourly" : "Daily",
      days_worked: Number(row.days_worked || 0),
      total_hours: Number(row.total_hours || 0),
      hourly_rate: Number(row.hourly_rate || 0),
      basic_salary: Number(row.basic_salary || 0),
      per_day_salary: Number(row.per_day_salary || (Number(row.days_worked) ? (row.payable_amount || row.basic_salary) / row.days_worked : 0)),
      payable_amount: Number(row.payable_amount || 0),
      allowances: Number(row.allowances || 0),
      deductions: Number(row.deductions || 0),
      net_salary: Number(row.net_salary || 0),
      narration: row.narration || "",
    });
    setOpen(true);
  };

  const colDefs: ColDef[] = [
    { field: "voucher_no", headerName: "Voucher No.", width: 140, cellRenderer: (p) => <span style={{ fontWeight: 700 }}>{p.value}</span> },
    { field: "voucher_date", headerName: "Date", width: 105, valueFormatter: (p) => formatDisplayDate(p.value) },
    {
      field: "ledger_id",
      headerName: "Staff Member",
      flex: 1,
      minWidth: 170,
      cellRenderer: (p) => {
        const staff = staffMap[p.value];
        const name = p.data?.staff_name || staff?.name || p.value;
        const code = p.data?.staff_code || staff?.ledger_code;
        return (
          <Box>
            <span style={{ fontWeight: 600 }}>{name}</span>
            {code && <span style={{ fontSize: "0.75rem", color: "#64748b", marginLeft: "6px" }}>({code})</span>}
          </Box>
        );
      }
    },
    {
      field: "month",
      headerName: "Period / Cycle",
      width: 145,
      cellRenderer: (p) => {
        if (p.data?.pay_period_type === "Weekly" || (p.data?.from_date && p.data?.to_date)) {
          return (
            <Chip
              label={`W: ${formatDisplayDate(p.data.from_date)} - ${formatDisplayDate(p.data.to_date)}`}
              size="small"
              color="warning"
              variant="outlined"
              sx={{ fontWeight: 700, fontSize: "0.72rem" }}
            />
          );
        }
        return `${MONTH_NAMES[(p.value || 1) - 1] || p.value} ${p.data?.year || ""}`;
      }
    },
    {
      field: "days_worked",
      headerName: "Duration / Days",
      width: 140,
      type: "numericColumn",
      cellRenderer: (p) => {
        const isHourly = p.data?.pay_type === "Hourly" || (Number(p.data?.hourly_rate) > 0 && !Number(p.data?.per_day_salary));
        if (isHourly) {
          return (
            <Chip
              label={`${p.data?.total_hours || 0} hrs`}
              size="small"
              color="warning"
              variant="outlined"
              sx={{ fontWeight: 700, fontSize: "0.75rem" }}
            />
          );
        }
        return (
          <Chip
            label={`${p.value || 0} days`}
            size="small"
            color="primary"
            variant="outlined"
            sx={{ fontWeight: 700, fontSize: "0.75rem" }}
          />
        );
      }
    },
    {
      field: "payable_amount",
      headerName: "Payable Amount",
      width: 145,
      type: "numericColumn",
      cellRenderer: (p) => {
        const amt = p.value || (Number(p.data?.days_worked || 0) * Number(p.data?.per_day_salary || 0));
        return (
          <span style={{ fontWeight: 700, color: "#166534" }}>
            ₹{formatAmount(amt)}
          </span>
        );
      }
    },
    {
      field: "net_salary",
      headerName: "Net Salary",
      width: 125,
      type: "numericColumn",
      cellRenderer: (p) => (
        <Typography component="span" variant="body2" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
          ₹{formatAmount(p.value || 0)}
        </Typography>
      )
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 120,
      sortable: false,
      cellRenderer: (p) => (
        <Box onClick={(e) => e.stopPropagation()} sx={{ display: "flex", gap: 0.5 }}>
          <Tooltip title="View / Print Voucher Slip">
            <IconButton size="small" color="info" onClick={() => setViewVoucher(p.data)}>
              <Print fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit Voucher">
            <IconButton size="small" color="primary" onClick={() => handleEditRow(p.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete Voucher">
            <IconButton
              size="small"
              color="error"
              onClick={() => {
                if (window.confirm(`Are you sure you want to delete Salary Voucher ${p.data.voucher_no}?`)) {
                  deleteMutation.mutate(p.data.id);
                }
              }}
            >
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  const handlePrintSalarySlip = async (row: any) => {
    if (!row) return;
    await ensurePrintReady();
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;

    const compData = useCompanyStore.getState().company;
    const { name: cName, address: cAddress, cityStatePin: cCityStatePin, phone: cPhone, email: cEmail, gstin: cTax } = resolveCompanyDetails(compData);
    const logoHtml = getCompanyLogoHtml(true, compData);

    const isWeekly = row.pay_period_type === "Weekly" || Boolean(row.from_date && row.to_date);
    const fromDate = row.from_date;
    const toDate = row.to_date;
    const periodStr = isWeekly && fromDate && toDate
      ? `${formatDisplayDate(fromDate)} to ${formatDisplayDate(toDate)} (Weekly Pay)`
      : `${MONTH_NAMES[(row.month || 1) - 1]} ${row.year}`;

    const staffName = row.staff_name || staffMap[row.ledger_id]?.name || `Staff #${row.ledger_id}`;
    const staffCode = row.staff_code ? ` (${row.staff_code})` : "";
    const workingDays = row.days_worked || 0;
    const perDaySalary = row.per_day_salary || 0;
    const payableAmount = row.payable_amount || (Number(workingDays) * Number(perDaySalary));
    const allowances = row.allowances || 0;
    const deductions = row.deductions || 0;
    const netSalary = row.net_salary || 0;

    const isHourly = row.pay_type === "Hourly" || (Number(row.hourly_rate) > 0 && !Number(row.per_day_salary));
    const descStr = isHourly
      ? `Working Hours (${row.total_hours || 0} Hours × ₹${formatAmount(row.hourly_rate || 0)}/hr)`
      : `Working Days (${workingDays} Days × ₹${formatAmount(perDaySalary)})`;

    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>Salary Slip - ${row.voucher_no || staffName}</title>
          <style>
            @page { size: A4 portrait; margin: 10mm; }
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

          <div class="title-section" style="align-items: center; border-bottom: 1.5px solid #0f5132; margin-bottom: 10px;">
            <h2 style="font-size: 15px; margin-bottom: 3px;">STAFF SALARY VOUCHER SLIP</h2>
            <div style="font-size: 11px; font-weight: 600; color: #2d3748;">Period: ${periodStr}</div>
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin: 10px 0; border: 0.5px solid #198754; padding: 8px 10px; background-color: #f8fafc;">
            <div>
              <div style="font-size: 9.5px; color: #555;">Voucher No: <strong style="font-size: 11px; color: #000;">${row.voucher_no || "-"}</strong></div>
              <div style="font-size: 9.5px; color: #555; margin-top: 3px;">Date: <strong style="font-size: 11px; color: #000;">${formatDisplayDate(row.voucher_date)}</strong></div>
            </div>
            <div>
              <div style="font-size: 9.5px; color: #555;">Staff Name: <strong style="font-size: 11.5px; color: #0f5132;">${staffName}${staffCode}</strong></div>
              ${fromDate && toDate ? `
                <div style="font-size: 9.5px; color: #555; margin-top: 4px;">
                  Work Period: <strong style="font-size: 10.5px; color: #0f5132;">From: ${formatDisplayDate(fromDate)} &nbsp; To: ${formatDisplayDate(toDate)}</strong>
                </div>
              ` : ""}
            </div>
          </div>

          <table class="items-table">
            <thead>
              <tr>
                <th>Description</th>
                <th style="text-align: right; width: 140px;">Amount</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>${descStr}</td>
                <td style="text-align: right;">₹${formatAmount(payableAmount)}</td>
              </tr>
              <tr>
                <td>Allowances / Incentives (+)</td>
                <td style="text-align: right;">₹${formatAmount(allowances)}</td>
              </tr>
              <tr>
                <td>Deductions / Advances (-)</td>
                <td style="text-align: right; color: #c53030;">₹${formatAmount(deductions)}</td>
              </tr>
            </tbody>
            <tfoot>
              <tr class="total-row">
                <td style="font-weight: 700; text-transform: uppercase;">Net Payable Salary</td>
                <td style="text-align: right; font-weight: 800; font-size: 12px; color: #0f5132;">₹${formatAmount(netSalary)}</td>
              </tr>
            </tfoot>
          </table>

          ${row.narration ? `
            <div class="narration-box" style="margin-top: 8px;">
              <strong>Narration:</strong> ${row.narration}
            </div>
          ` : ""}

          <div class="signatures-container" style="margin-top: 25px;">
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">Staff Signature</div>
            </div>
            <div class="signature-block">
              <div class="signature-line"></div>
              <div class="signature-label">Authorized Signatory for ${cName}</div>
            </div>
          </div>

          ${getGlobalPrintFooterHtml()}
          ${PRINT_TRIGGER_SCRIPT}
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <Box>
      <PageHeader
        title="Salary Voucher"
        subtitle="Staff monthly salary vouchers calculated from daily attendance (Working Days × Per Day Salary)"
        breadcrumbs={[{ label: "Payroll Voucher" }, { label: "Salary Voucher" }]}
      />
      <OrbxGrid
        rowData={items}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onBulkDelete={async (rows) => {
          await bulkDeleteMutation.mutateAsync(rows);
        }}
        onAdd={async () => {
          setEditing(null);
          let nextNo = "";
          try {
            const res = await api.get("/sequences/preview/salary_voucher");
            nextNo = res.data.next_no;
          } catch (e) {
            console.error(e);
          }
          reset({
            voucher_no: nextNo,
            month: new Date().getMonth() + 1,
            year: new Date().getFullYear(),
            voucher_date: today,
            pay_type: "Daily",
            pay_period_type: "Monthly",
            from_date: "",
            to_date: "",
            days_worked: 0,
            total_hours: 0,
            hourly_rate: 0,
            basic_salary: 0,
            per_day_salary: 0,
            payable_amount: 0,
            allowances: 0,
            deductions: 0,
            net_salary: 0,
            ledger_id: "",
            narration: "",
          });
          setOpen(true);
        }}
        addLabel="New Salary"
      />

      {/* CREATE / EDIT SALARY VOUCHER DIALOG */}
      <Dialog open={open} onClose={() => { setOpen(false); setEditing(null); }} maxWidth="md" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle sx={{ fontWeight: 800, color: "text.primary" }}>
            {editing ? `Edit Salary Voucher (${editing.voucher_no})` : "New Staff Salary Voucher"}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 12, sm: 6 }}>
                <TextField {...register("voucher_no")} label="Voucher No. *" fullWidth required disabled slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12, sm: 6 }}>
                <TextField
                  {...register("voucher_date")}
                  label="Voucher Date *"
                  type="date"
                  fullWidth
                  slotProps={{ inputLabel: { shrink: true } }}
                  onChange={(e) => {
                    setValue("voucher_date", e.target.value);
                    if (watchPayPeriodType === "Weekly") {
                      const cycle = getWeeklyPayCycle(e.target.value, configuredPayoutDay);
                      setValue("from_date", cycle.from_date);
                      setValue("to_date", cycle.to_date);
                    }
                  }}
                />
              </Grid>

              {/* Staff Member Selector */}
              <Grid size={{ xs: 12, sm: 6 }}>
                <Controller
                  name="ledger_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={staffMembers}
                      getOptionLabel={(o: any) => `${o.name}${o.ledger_code ? ` (${o.ledger_code})` : ""}${o.per_day_salary ? ` [₹${o.per_day_salary}/day]` : o.basic_salary ? ` [₹${o.basic_salary}/mo]` : ""}`}
                      value={staffMembers.find((l: any) => l.id === field.value) || ledgers.find((l: any) => l.id === field.value) || null}
                      onChange={(_, v) => {
                        field.onChange(v ? v.id : "");
                        if (v && !editing) {
                          const isLabour = v.staff_category === "Labour" || Number(v.hourly_rate || 0) > 0;
                          if (isLabour) {
                            setValue("pay_period_type", "Weekly");
                            setValue("pay_type", "Hourly");
                            const cycle = getWeeklyPayCycle(getValues("voucher_date") || today, configuredPayoutDay);
                            setValue("from_date", cycle.from_date);
                            setValue("to_date", cycle.to_date);
                          } else {
                            setValue("pay_period_type", "Monthly");
                            setValue("pay_type", "Daily");
                          }
                        }
                      }}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="Select Staff Member *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                        />
                      )}
                    />
                  )}
                />
              </Grid>

              {/* Pay Period Frequency: Weekly vs Monthly */}
              <Grid size={{ xs: 12, sm: 6 }}>
                <Box
                  sx={{
                    p: 1.1,
                    borderRadius: "8px",
                    border: "1px solid",
                    borderColor: "divider",
                    bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(255, 255, 255, 0.02)" : "#f8fafc",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    gap: 1
                  }}
                >
                  <Box sx={{ display: "flex", alignItems: "center", gap: 0.8 }}>
                    <CalendarMonth fontSize="small" color="primary" />
                    <Box>
                      <Typography variant="body2" sx={{ fontWeight: 700, fontSize: "0.8rem", lineHeight: 1.1 }}>
                        Pay Period:
                      </Typography>
                      <Typography variant="caption" color="text.secondary" sx={{ fontSize: "0.7rem" }}>
                        {watchPayPeriodType === "Weekly" ? `Weekly (${configuredPayoutDay})` : "Monthly"}
                      </Typography>
                    </Box>
                  </Box>
                  <Box sx={{ display: "flex", gap: 0.8 }}>
                    <Button
                      size="small"
                      variant={watchPayPeriodType === "Weekly" ? "contained" : "outlined"}
                      color={watchPayPeriodType === "Weekly" ? "warning" : "inherit"}
                      onClick={() => {
                        setValue("pay_period_type", "Weekly");
                        const cycle = getWeeklyPayCycle(watchVoucherDate || today, configuredPayoutDay);
                        setValue("from_date", cycle.from_date);
                        setValue("to_date", cycle.to_date);
                      }}
                      sx={{ fontWeight: 700, fontSize: "0.75rem", py: 0.3, px: 1.2, textTransform: "none", minWidth: 0 }}
                    >
                      Weekly Pay
                    </Button>
                    <Button
                      size="small"
                      variant={watchPayPeriodType === "Monthly" ? "contained" : "outlined"}
                      color={watchPayPeriodType === "Monthly" ? "primary" : "inherit"}
                      onClick={() => setValue("pay_period_type", "Monthly")}
                      sx={{ fontWeight: 700, fontSize: "0.75rem", py: 0.3, px: 1.2, textTransform: "none", minWidth: 0 }}
                    >
                      Monthly
                    </Button>
                  </Box>
                </Box>
              </Grid>

              {/* Period Date Pickers: From / To for Weekly, Month / Year for Monthly */}
              {watchPayPeriodType === "Weekly" ? (
                <>
                  <Grid size={{ xs: 6, sm: 3 }}>
                    <TextField
                      {...register("from_date")}
                      label="Period From Date *"
                      type="date"
                      fullWidth
                      value={watchFromDate || ""}
                      onChange={(e) => setValue("from_date", e.target.value)}
                      slotProps={{ inputLabel: { shrink: true } }}
                      helperText={`Prev ${configuredPayoutDay}`}
                    />
                  </Grid>
                  <Grid size={{ xs: 6, sm: 3 }}>
                    <TextField
                      {...register("to_date")}
                      label="Period To Date *"
                      type="date"
                      fullWidth
                      value={watchToDate || ""}
                      onChange={(e) => setValue("to_date", e.target.value)}
                      slotProps={{ inputLabel: { shrink: true } }}
                      helperText="Day before payout"
                    />
                  </Grid>
                </>
              ) : (
                <>
                  <Grid size={{ xs: 6, sm: 3 }}>
                    <TextField
                      select
                      {...register("month")}
                      label="Payroll Month *"
                      fullWidth
                      value={watchMonth}
                      onChange={(e) => setValue("month", Number(e.target.value))}
                      slotProps={{ inputLabel: { shrink: true } }}
                    >
                      {MONTH_NAMES.map((name, i) => (
                        <MenuItem key={i + 1} value={i + 1}>{name}</MenuItem>
                      ))}
                    </TextField>
                  </Grid>
                  <Grid size={{ xs: 6, sm: 3 }}>
                    <TextField
                      {...register("year")}
                      label="Payroll Year *"
                      type="number"
                      fullWidth
                      value={watchYear}
                      onChange={(e) => setValue("year", Number(e.target.value))}
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                </>
              )}

              {/* Real-time Attendance Stats Banner */}
              {watchLedgerId && (
                <Grid size={{ xs: 12 }}>
                  <Paper
                    variant="outlined"
                    sx={{
                      p: 2,
                      bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(255, 255, 255, 0.02)" : "#fcfdfc",
                      borderRadius: "8px",
                      borderColor: "divider"
                    }}
                  >
                    <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 1.5, flexWrap: "wrap", gap: 1 }}>
                      <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "text.primary", display: "flex", alignItems: "center", gap: 0.8 }}>
                        <EventAvailable fontSize="small" color="primary" />
                        {isWeekly && watchFromDate && watchToDate
                          ? `Attendance Record for ${formatDisplayDate(watchFromDate)} to ${formatDisplayDate(watchToDate)} (${attendanceStats?.days_in_period || 7} Days Weekly Cycle)`
                          : `Attendance Record for ${MONTH_NAMES[watchMonth - 1]} ${watchYear} (${attendanceStats?.days_in_month || 30} Calendar Days)`}
                      </Typography>
                      {isStatsLoading ? (
                        <Chip icon={<CircularProgress size={12} color="inherit" />} label="Fetching attendance..." size="small" variant="outlined" />
                      ) : attendanceStats ? (
                        <Box sx={{ display: "flex", gap: 0.8, alignItems: "center" }}>
                          <Chip
                            size="small"
                            label={watchPayType === "Hourly" ? `Total Hours: ${attendanceStats.total_hours} hrs` : `Working Days: ${attendanceStats.working_days} Days`}
                            color={watchPayType === "Hourly" ? "warning" : "success"}
                            sx={{ fontWeight: 800 }}
                          />
                          <Chip
                            size="small"
                            label={watchPayType === "Hourly" ? "Hour-Wise Pay" : "Daily/Monthly Salary"}
                            variant="outlined"
                            color={watchPayType === "Hourly" ? "warning" : "primary"}
                            sx={{ fontWeight: 700 }}
                          />
                        </Box>
                      ) : null}
                    </Box>

                    <Grid container spacing={1}>
                      <Grid size={{ xs: 6, sm: 2.4 }}>
                        <Box sx={{ p: 1, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4", borderRadius: "6px", textAlign: "center", border: "1px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.3)" : "#bbf7d0" }}>
                          <Typography variant="caption" sx={{ color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#166534", fontWeight: 700 }}>PRESENT</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#15803d" }}>
                            {attendanceStats?.present_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Full Day (1.0)</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 2.4 }}>
                        <Box sx={{ p: 1, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(245, 158, 11, 0.1)" : "#fffbeb", borderRadius: "6px", textAlign: "center", border: "1px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(245, 158, 11, 0.3)" : "#fde68a" }}>
                          <Typography variant="caption" sx={{ color: (theme) => theme.palette.mode === "dark" ? "#fbbf24" : "#92400e", fontWeight: 700 }}>HALF DAY</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "#fbbf24" : "#b45309" }}>
                            {attendanceStats?.half_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Half Day (0.5)</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 2.4 }}>
                        <Box sx={{ p: 1, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(239, 68, 68, 0.1)" : "#fef2f2", borderRadius: "6px", textAlign: "center", border: "1px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(239, 68, 68, 0.3)" : "#fecaca" }}>
                          <Typography variant="caption" sx={{ color: (theme) => theme.palette.mode === "dark" ? "#f87171" : "#991b1b", fontWeight: 700 }}>ABSENT</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "#f87171" : "#b91c1c" }}>
                            {attendanceStats?.absent_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Unpaid</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 2.4 }}>
                        <Box sx={{ p: 1, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(59, 130, 246, 0.1)" : "#eff6ff", borderRadius: "6px", textAlign: "center", border: "1px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(59, 130, 246, 0.3)" : "#bfdbfe" }}>
                          <Typography variant="caption" sx={{ color: (theme) => theme.palette.mode === "dark" ? "#60a5fa" : "#1e40af", fontWeight: 700 }}>WORKING DAYS</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "#60a5fa" : "#1d4ed8" }}>
                            {attendanceStats?.working_days ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Present + 0.5×Half</Typography>
                        </Box>
                      </Grid>
                      <Grid size={{ xs: 6, sm: 2.4 }}>
                        <Box sx={{ p: 1, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(249, 115, 22, 0.1)" : "#fff7ed", borderRadius: "6px", textAlign: "center", border: "1px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(249, 115, 22, 0.3)" : "#fed7aa" }}>
                          <Typography variant="caption" sx={{ color: (theme) => theme.palette.mode === "dark" ? "#fb923c" : "#c2410c", fontWeight: 700 }}>TOTAL HOURS</Typography>
                          <Typography variant="h6" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "#fb923c" : "#ea580c" }}>
                            {attendanceStats?.total_hours ?? 0}
                          </Typography>
                          <Typography variant="caption" sx={{ color: "text.secondary", fontSize: "0.68rem" }}>Logged Hours</Typography>
                        </Box>
                      </Grid>
                    </Grid>

                    {attendanceStats && attendanceStats.total_ot_hours > 0 && (
                      <Typography variant="caption" sx={{ mt: 1, display: "block", color: "text.secondary" }}>
                        Logged Overtime: <strong>{attendanceStats.total_ot_hours} hrs</strong> | Total Working Hours: <strong>{attendanceStats.total_hours} hrs</strong>
                      </Typography>
                    )}
                  </Paper>
                </Grid>
              )}

              {/* Formula & Calculation Banner */}
              <Grid size={{ xs: 12 }}>
                <Box
                  sx={{
                    p: 1.5,
                    bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.08)" : "#f0fdf4",
                    borderRadius: "8px",
                    border: "1px solid",
                    borderColor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.3)" : "#86efac",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    flexWrap: "wrap",
                    gap: 1
                  }}
                >
                  <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                    <Calculate sx={{ color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#15803d" }} />
                    <Typography variant="body2" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#15803d" }}>
                      {watchPayType === "Hourly"
                        ? `Formula: Working Hours (${watchTotalHours || 0} hrs) × Hourly Rate (₹${watchHourlyRate || 0}) = Payable Amount: ₹${formatAmount(payable)}`
                        : `Formula: Working Days (${watchDaysWorked || 0}) × Per Day Salary (₹${watchPerDaySalary || 0}) = Payable Amount: ₹${formatAmount(payable)}`
                      }
                    </Typography>
                  </Box>
                  <Box sx={{ display: "flex", gap: 1, alignItems: "center" }}>
                    {attendanceStats && attendanceStats.advance_balance > 0 && (
                      <Chip
                        label={`Advance Due: ₹${formatAmount(attendanceStats.advance_balance)}`}
                        color="warning"
                        variant="filled"
                        sx={{ fontWeight: 800, fontSize: "0.82rem" }}
                      />
                    )}
                    <Chip
                      label={`Payable: ₹${formatAmount(payable)}`}
                      color={watchPayType === "Hourly" ? "warning" : "success"}
                      sx={{ fontWeight: 800, fontSize: "0.85rem" }}
                    />
                  </Box>
                </Box>
              </Grid>

              {/* Wage Type, Duration & Rate Inputs */}
              <Grid size={{ xs: 12, sm: 3 }}>
                <Controller
                  name="pay_type"
                  control={control}
                  render={({ field }) => (
                    <TextField
                      {...field}
                      select
                      size="small"
                      label="Wage Type *"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    >
                      <MenuItem value="Daily">Daily / Monthly (Days Worked)</MenuItem>
                      <MenuItem value="Hourly">Hour-Wise Pay (Hours Worked)</MenuItem>
                    </TextField>
                  )}
                />
              </Grid>

              {watchPayType === "Hourly" ? (
                <>
                  <Grid size={{ xs: 12, sm: 3 }}>
                    <TextField
                      {...register("total_hours")}
                      label="Working Hours (Attendance) *"
                      type="number"
                      size="small"
                      fullWidth
                      required
                      slotProps={{
                        inputLabel: { shrink: true },
                        htmlInput: { step: "0.25", min: "0" }
                      }}
                      helperText={`Total hours worked in ${MONTH_NAMES[watchMonth - 1]}`}
                    />
                  </Grid>

                  <Grid size={{ xs: 12, sm: 3 }}>
                    <TextField
                      {...register("hourly_rate")}
                      label="Hourly Rate (₹ / Hour) *"
                      type="number"
                      size="small"
                      fullWidth
                      required
                      slotProps={{
                        inputLabel: { shrink: true },
                        htmlInput: { step: "0.01", min: "0" }
                      }}
                      helperText="Hourly wage rate"
                    />
                  </Grid>
                </>
              ) : (
                <>
                  <Grid size={{ xs: 12, sm: 3 }}>
                    <TextField
                      {...register("days_worked")}
                      label="Working Days (Attendance) *"
                      type="number"
                      size="small"
                      fullWidth
                      required
                      slotProps={{
                        inputLabel: { shrink: true },
                        htmlInput: { step: "0.5", min: "0" }
                      }}
                      helperText="Present days + 0.5 × Half days"
                    />
                  </Grid>

                  <Grid size={{ xs: 12, sm: 3 }}>
                    <TextField
                      {...register("per_day_salary")}
                      label="Per Day Salary (₹) *"
                      type="number"
                      size="small"
                      fullWidth
                      required
                      slotProps={{
                        inputLabel: { shrink: true },
                        htmlInput: { step: "0.01", min: "0" }
                      }}
                      helperText={
                        watchBasicSalary && attendanceStats?.days_in_month
                          ? `Monthly ₹${watchBasicSalary} ÷ ${attendanceStats.days_in_month}d = ₹${(Number(watchBasicSalary) / attendanceStats.days_in_month).toFixed(2)}/d`
                          : "Daily wage rate for calculation"
                      }
                    />
                  </Grid>
                </>
              )}

              <Grid size={{ xs: 12, sm: 3 }}>
                <TextField
                  label="Payable Amount (₹) *"
                  type="number"
                  size="small"
                  fullWidth
                  value={payable}
                  disabled
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { style: { fontWeight: 800, color: "#166534" } }
                  }}
                  helperText={watchPayType === "Hourly" ? "Working Hours × Hourly Rate" : "Working Days × Per Day Salary"}
                />
              </Grid>

              {/* Allowances, Deductions, Net Salary */}
              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  {...register("allowances")}
                  label="Allowances / Bonus (+) (₹)"
                  type="number"
                  fullWidth
                  placeholder="0.00"
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { step: "0.01", min: "0" }
                  }}
                />
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <Box>
                  <TextField
                    {...register("deductions")}
                    label="Deductions / Advance (-) (₹)"
                    type="number"
                    fullWidth
                    placeholder="0.00"
                    slotProps={{
                      inputLabel: { shrink: true },
                      htmlInput: { step: "0.01", min: "0" }
                    }}
                    helperText={
                      attendanceStats && attendanceStats.advance_balance > 0
                        ? `Staff has ₹${formatAmount(attendanceStats.advance_balance)} advance due`
                        : "Salary deductions or advance recovered"
                    }
                  />
                  {attendanceStats && attendanceStats.advance_balance > 0 && !editing && (
                    <Button
                      size="small"
                      variant="text"
                      color="warning"
                      onClick={() => {
                        const dedAmt = Math.min(payable, Number(attendanceStats.advance_balance || 0));
                        setValue("deductions", dedAmt);
                      }}
                      sx={{ fontSize: "0.72rem", py: 0.2, px: 0.5, textTransform: "none", fontWeight: 700 }}
                    >
                      Deduct Advance (₹{formatAmount(attendanceStats.advance_balance)})
                    </Button>
                  )}
                </Box>
              </Grid>

              <Grid size={{ xs: 12, sm: 4 }}>
                <TextField
                  label="Net Payable Salary (₹) *"
                  type="number"
                  fullWidth
                  value={netSalary}
                  disabled
                  slotProps={{
                    inputLabel: { shrink: true },
                    htmlInput: { style: { fontWeight: 900, fontSize: "1.05rem" } }
                  }}
                  helperText="Payable + Allowances - Deductions"
                />
              </Grid>

              <Grid size={{ xs: 12 }}>
                <TextField
                  {...register("narration")}
                  label="Narration / Remarks"
                  fullWidth
                  multiline
                  rows={2}
                  placeholder="e.g. Salary for September 2026 based on biometric attendance register"
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2.5, gap: 1 }}>
            <Button onClick={() => { setOpen(false); setEditing(null); }} variant="outlined">Cancel</Button>
            <Button
              type="submit"
              variant="contained"
              disabled={saveMutation.isPending}
              sx={{ fontWeight: 700, px: 3 }}
            >
              {saveMutation.isPending ? "Saving..." : editing ? "Update Voucher" : "Save Salary Voucher"}
            </Button>
          </DialogActions>
        </form>
      </Dialog>

      {/* VIEW / PRINT SALARY SLIP DIALOG */}
      <Dialog open={!!viewVoucher} onClose={() => setViewVoucher(null)} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ fontWeight: 800, color: "text.primary", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span>Staff Salary Voucher Slip</span>
          <Button
            size="small"
            variant="contained"
            startIcon={<Print />}
            onClick={() => handlePrintSalarySlip(viewVoucher)}
          >
            Print
          </Button>
        </DialogTitle>
        <DialogContent dividers>
          {viewVoucher && (
            <Box sx={{ p: 1 }}>
              <Box sx={{ textAlign: "center", mb: 2 }}>
                <Typography variant="h6" sx={{ fontWeight: 800, color: "text.primary" }}>
                  SALARY VOUCHER
                </Typography>
                <Typography variant="body2" sx={{ color: "text.secondary" }}>
                  Period: {viewVoucher.pay_period_type === "Weekly" || (viewVoucher.from_date && viewVoucher.to_date)
                    ? `${formatDisplayDate(viewVoucher.from_date)} to ${formatDisplayDate(viewVoucher.to_date)} (Weekly Pay)`
                    : `${MONTH_NAMES[(viewVoucher.month || 1) - 1]} ${viewVoucher.year}`}
                </Typography>
              </Box>

              <Paper variant="outlined" sx={{ p: 1.5, mb: 2, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(255, 255, 255, 0.03)" : "#f8fafc" }}>
                <Grid container spacing={1}>
                  <Grid size={6}>
                    <Typography variant="caption" color="text.secondary">Voucher No:</Typography>
                    <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.voucher_no}</Typography>
                  </Grid>
                  <Grid size={6}>
                    <Typography variant="caption" color="text.secondary">Date:</Typography>
                    <Typography variant="body2" sx={{ fontWeight: 700 }}>{formatDisplayDate(viewVoucher.voucher_date)}</Typography>
                  </Grid>
                  <Grid size={12}>
                    <Typography variant="caption" color="text.secondary">Staff Name:</Typography>
                    <Typography variant="body1" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                      {viewVoucher.staff_name || staffMap[viewVoucher.ledger_id]?.name || `Staff #${viewVoucher.ledger_id}`}
                      {viewVoucher.staff_code && ` (${viewVoucher.staff_code})`}
                    </Typography>
                  </Grid>
                  {viewVoucher.from_date && viewVoucher.to_date && (
                    <Grid size={12}>
                      <Typography variant="caption" color="text.secondary">Work Period Dates:</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                        From: {formatDisplayDate(viewVoucher.from_date)} &nbsp; To: {formatDisplayDate(viewVoucher.to_date)} ({viewVoucher.pay_period_type || "Weekly"})
                      </Typography>
                    </Grid>
                  )}
                </Grid>
              </Paper>

              <Typography variant="subtitle2" sx={{ fontWeight: 700, mb: 1, color: "text.primary" }}>
                Attendance & Salary Calculation:
              </Typography>
              <Paper variant="outlined" sx={{ p: 2, mb: 2 }}>
                {viewVoucher.pay_type === "Hourly" || (Number(viewVoucher.hourly_rate) > 0 && !Number(viewVoucher.per_day_salary)) ? (
                  <>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider" }}>
                      <Typography variant="body2">Working Hours (from Attendance):</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.total_hours || 0} Hours</Typography>
                    </Box>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider" }}>
                      <Typography variant="body2">Hourly Rate:</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>₹{formatAmount(viewVoucher.hourly_rate || 0)} / hr</Typography>
                    </Box>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.75, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4", px: 1, borderRadius: "4px", mt: 0.5 }}>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#166534" }}>
                        Payable Amount (Working Hours × Rate):
                      </Typography>
                      <Typography variant="body2" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#166534" }}>
                        ₹{formatAmount(viewVoucher.payable_amount || (Number(viewVoucher.total_hours || 0) * Number(viewVoucher.hourly_rate || 0)))}
                      </Typography>
                    </Box>
                  </>
                ) : (
                  <>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider" }}>
                      <Typography variant="body2">Working Days (from Attendance):</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>{viewVoucher.days_worked} Days</Typography>
                    </Box>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider" }}>
                      <Typography variant="body2">Per Day Salary Rate:</Typography>
                      <Typography variant="body2" sx={{ fontWeight: 700 }}>₹{formatAmount(viewVoucher.per_day_salary || 0)}</Typography>
                    </Box>
                    <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.75, bgcolor: (theme) => theme.palette.mode === "dark" ? "rgba(22, 196, 127, 0.1)" : "#f0fdf4", px: 1, borderRadius: "4px", mt: 0.5 }}>
                      <Typography variant="body2" sx={{ fontWeight: 700, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#166534" }}>
                        Payable Amount (Working Days × Rate):
                      </Typography>
                      <Typography variant="body2" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#166534" }}>
                        ₹{formatAmount(viewVoucher.payable_amount || (Number(viewVoucher.days_worked || 0) * Number(viewVoucher.per_day_salary || 0)))}
                      </Typography>
                    </Box>
                  </>
                )}
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider", mt: 1 }}>
                  <Typography variant="body2">Allowances / Incentives (+):</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 600 }}>₹{formatAmount(viewVoucher.allowances || 0)}</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 0.5, borderBottom: "1px dashed", borderColor: "divider" }}>
                  <Typography variant="body2">Deductions / Advances (-):</Typography>
                  <Typography variant="body2" sx={{ fontWeight: 600, color: "error.main" }}>₹{formatAmount(viewVoucher.deductions || 0)}</Typography>
                </Box>
                <Box sx={{ display: "flex", justifyContent: "space-between", py: 1, mt: 1, borderTop: "2px solid", borderColor: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                  <Typography variant="subtitle1" sx={{ fontWeight: 800, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>Net Payable Salary:</Typography>
                  <Typography variant="h6" sx={{ fontWeight: 900, color: (theme) => theme.palette.mode === "dark" ? "primary.main" : "#0f5132" }}>
                    ₹{formatAmount(viewVoucher.net_salary || 0)}
                  </Typography>
                </Box>
              </Paper>

              {viewVoucher.narration && (
                <Typography variant="caption" sx={{ color: "text.secondary", display: "block", fontStyle: "italic" }}>
                  Narration: {viewVoucher.narration}
                </Typography>
              )}
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewVoucher(null)}>Close</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
