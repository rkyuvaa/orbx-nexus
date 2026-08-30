import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Grid,
  IconButton,
  Tooltip,
  Typography,
  Paper,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Chip,
  Alert,
  Tabs,
  Tab,
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import Receipt from "@mui/icons-material/Receipt";
import Payment from "@mui/icons-material/Payment";
import ArrowForward from "@mui/icons-material/ArrowForward";
import ArrowBack from "@mui/icons-material/ArrowBack";
import { useForm, Controller } from "react-hook-form";
import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import dayjs from "dayjs";

import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";
import { formatAmount, formatDate } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];

interface ContractorAdvancePaymentForm {
  entry_no: string;
  entry_date: string;
  ledger_id: string;
  amount: number;
  payment_type: string; // "Advance Payment" or "Advance Receipt"
  narration: string;
  // Note: The backend only supports these fields for contractor advance payments
  // Additional payment details can be added to the narration field
}

interface ContractorAdvanceBalance {
  contractor_id: number;
  contractor_name: string;
  total_advance_payments: number;
  total_advance_receipts: number;
  net_advance_balance: number;
  pending_registers_count: number;
  pending_amount: number;
}

export default function ContractorAdvancePayment() {
  const { activeFY } = useAuthStore();
  const queryClient = useQueryClient();
  
  // State management
  const [openDialog, setOpenDialog] = useState(false);
  const [editingAdvance, setEditingAdvance] = useState<any>(null);
  const [tabValue, setTabValue] = useState<"payments" | "receipts" | "balance">("payments");
  const [selectedContractor, setSelectedContractor] = useState<number | null>(null);
  const [filterFromDate, setFilterFromDate] = useState<string>(dayjs().subtract(30, 'days').format('YYYY-MM-DD'));
  const [filterToDate, setFilterToDate] = useState<string>(today);

  // Queries
  const { data: advanceEntries = [], isLoading, refetch } = useQuery({
    queryKey: ["contractor-advance", activeFY, tabValue, filterFromDate, filterToDate],
    queryFn: async () => {
      const entryType = tabValue === "payments" ? "Advance Payment" : "Advance Receipt";
      let url = `/contractor/?fy=${activeFY}&entry_type=${entryType}`;
      
      if (filterFromDate) url += `&from_date=${filterFromDate}`;
      if (filterToDate) url += `&to_date=${filterToDate}`;
      if (selectedContractor) url += `&ledger_id=${selectedContractor}`;
      
      return (await api.get(url)).data;
    },
  });

  const { data: contractors = [] } = useQuery({
    queryKey: ["ledgers", "Contractor"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Contractor")).data,
  });

  const { data: advanceBalance = [], isLoading: balanceLoading } = useQuery<ContractorAdvanceBalance[]>({
    queryKey: ["contractor-advance-balance", activeFY],
    queryFn: async () => {
      // Calculate advance balances from database
      const payments = await api.get(`/contractor/?fy=${activeFY}&entry_type=Advance Payment`);
      const receipts = await api.get(`/contractor/?fy=${activeFY}&entry_type=Advance Receipt`);
      
      const balanceMap = new Map<number, ContractorAdvanceBalance>();
      
      // Process advance payments
      payments.data.forEach((entry: any) => {
        if (!balanceMap.has(entry.ledger_id)) {
          balanceMap.set(entry.ledger_id, {
            contractor_id: entry.ledger_id,
            contractor_name: entry.contractor_name || "Unknown",
            total_advance_payments: 0,
            total_advance_receipts: 0,
            net_advance_balance: 0,
            pending_registers_count: 0,
            pending_amount: 0,
          });
        }
        const balance = balanceMap.get(entry.ledger_id)!;
        balance.total_advance_payments += Number(entry.amount) || 0;
        balance.net_advance_balance = balance.total_advance_payments - balance.total_advance_receipts;
      });
      
      // Process advance receipts
      receipts.data.forEach((entry: any) => {
        if (!balanceMap.has(entry.ledger_id)) {
          balanceMap.set(entry.ledger_id, {
            contractor_id: entry.ledger_id,
            contractor_name: entry.contractor_name || "Unknown",
            total_advance_payments: 0,
            total_advance_receipts: 0,
            net_advance_balance: 0,
            pending_registers_count: 0,
            pending_amount: 0,
          });
        }
        const balance = balanceMap.get(entry.ledger_id)!;
        balance.total_advance_receipts += Number(entry.amount) || 0;
        balance.net_advance_balance = balance.total_advance_payments - balance.total_advance_receipts;
      });
      
      return Array.from(balanceMap.values());
    },
  });

  // Form setup
  const { register, handleSubmit, reset, control, watch, setValue, formState: { errors } } = useForm<ContractorAdvancePaymentForm>({
    defaultValues: {
      entry_no: "",
      entry_date: today,
      ledger_id: "",
      amount: 0,
      payment_type: "Advance Payment",
      narration: "",
    },
  });



  // Mutations
  const saveMutation = useMutation({
    mutationFn: async (data: ContractorAdvancePaymentForm) => {
      // Create payload with only fields that backend supports
      const payload = {
        entry_no: data.entry_no,
        entry_date: data.entry_date,
        ledger_id: data.ledger_id,
        amount: data.amount,
        entry_type: data.payment_type,
        narration: data.narration || "",
        // Set null/empty values for other required fields
        product_id: null,
        process_id: null,
        rate_id: null,
        quantity: 0,
        rate: 0,
        outward_id: null,
        outward_ids: [],
        items: [],
        register_ids: [],
      };
      
      if (editingAdvance) {
        return await api.put(`/contractor/${editingAdvance.id}?fy=${activeFY}`, payload);
      } else {
        return await api.post(`/contractor/?fy=${activeFY}`, payload);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["contractor-advance"] });
      queryClient.invalidateQueries({ queryKey: ["contractor-advance-balance"] });
      handleCloseDialog();
    },
    onError: (error: any) => {
      console.error("Save error:", error);
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      await api.delete(`/contractor/${id}?fy=${activeFY}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["contractor-advance"] });
      queryClient.invalidateQueries({ queryKey: ["contractor-advance-balance"] });
    },
  });

  // Handlers
  const getDialogTitle = () => {
    const type = editingAdvance?.entry_type === "Advance Receipt" ? "Receipt" : "Payment";
    if (editingAdvance) {
      return `Edit Advance ${type}`;
    }
    // For new entries, we don't know the type until it's set via buttons
    return "New Advance Payment";
  };
  const handleOpenDialog = (advance?: any) => {
    if (advance) {
      setEditingAdvance(advance);
      reset({
        entry_no: advance.entry_no,
        entry_date: advance.entry_date,
        ledger_id: advance.ledger_id,
        amount: advance.amount,
        payment_type: advance.entry_type,
        narration: advance.narration || "",
      });
    } else {
      setEditingAdvance(null);
      reset({
        entry_no: "",
        entry_date: today,
        ledger_id: "",
        amount: 0,
        payment_type: "Advance Payment",
        narration: "",
      });
    }
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setEditingAdvance(null);
  };

  const handleTabChange = (_event: React.SyntheticEvent, newValue: "payments" | "receipts" | "balance") => {
    setTabValue(newValue);
  };

  const handleApplyFilter = () => {
    refetch();
  };

  const handleClearFilter = () => {
    setSelectedContractor(null);
    setFilterFromDate(dayjs().subtract(30, 'days').format('YYYY-MM-DD'));
    setFilterToDate(today);
    refetch();
  };

  // Grid columns
  const advanceColumns = useMemo(() => [
    { field: "entry_no", headerName: "Voucher No", width: 120 },
    { field: "entry_date", headerName: "Date", width: 100, 
      valueFormatter: (params: { value: any }) => formatDate(params.value) },
    { field: "contractor_name", headerName: "Contractor", width: 200 },
    { field: "amount", headerName: "Amount", width: 120, 
      valueFormatter: (params: { value: any }) => formatAmount(params.value) },
    { field: "narration", headerName: "Narration", width: 250 },
    { field: "created_at", headerName: "Created", width: 150, 
      valueFormatter: (params: { value: any }) => formatDate(params.value) },
    {
      field: "actions",
      headerName: "Actions",
      width: 120,
      renderCell: (params: any) => (
        <>
          <Tooltip title="Edit">
            <IconButton size="small" onClick={() => handleOpenDialog(params.data)}>
              <Edit fontSize="small" />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete">
            <IconButton
              size="small"
              color="error"
              onClick={() => {
                if (window.confirm("Delete this advance entry?")) {
                  deleteMutation.mutate(params.data.id);
                }
              }}
            >
              <Delete fontSize="small" />
            </IconButton>
          </Tooltip>
        </>
      ),
    },
  ], []);

  const balanceColumns = useMemo(() => [
    { field: "contractor_name", headerName: "Contractor", width: 250 },
    { field: "total_advance_payments", headerName: "Total Advance Paid", width: 150,
      valueFormatter: (params: { value: any }) => formatAmount(params.value) },
    { field: "total_advance_receipts", headerName: "Total Advance Received", width: 150,
      valueFormatter: (params: { value: any }) => formatAmount(params.value) },
    { field: "net_advance_balance", headerName: "Net Balance", width: 150,
      valueFormatter: (params: { value: any }) => formatAmount(params.value),
      cellStyle: (params: { value: any }) => ({
        color: params.value > 0 ? "#d32f2f" : params.value < 0 ? "#2e7d32" : "inherit",
        fontWeight: "bold",
      }) },
    { field: "pending_registers_count", headerName: "Pending Registers", width: 120 },
    { field: "pending_amount", headerName: "Pending Amount", width: 150,
      valueFormatter: (params: { value: any }) => formatAmount(params.value) },
  ], []);

  // Calculate totals
  const totalAdvancePayments = useMemo(() => 
    advanceEntries.filter((e: any) => e.entry_type === "Advance Payment")
      .reduce((sum: number, entry: any) => sum + (Number(entry.amount) || 0), 0),
    [advanceEntries]
  );

  const totalAdvanceReceipts = useMemo(() => 
    advanceEntries.filter((e: any) => e.entry_type === "Advance Receipt")
      .reduce((sum: number, entry: any) => sum + (Number(entry.amount) || 0), 0),
    [advanceEntries]
  );

  return (
    <Box sx={{ p: 3 }}>
      <PageHeader
        title="Contractor Advance Payment Management"
        subtitle="Manage advance payments and receipts for contractors"
        actions={
          <Box sx={{ display: "flex", gap: 2 }}>
            <Button
              variant="contained"
              startIcon={<Payment />}
              onClick={() => {
                setValue("payment_type", "Advance Payment");
                handleOpenDialog();
              }}
            >
              New Advance Payment
            </Button>
            <Button
              variant="outlined"
              startIcon={<Receipt />}
              onClick={() => {
                setValue("payment_type", "Advance Receipt");
                handleOpenDialog();
              }}
            >
              New Advance Receipt
            </Button>
          </Box>
        }
      />

      {/* Tabs */}
      <Paper sx={{ mt: 3, mb: 3 }}>
        <Tabs value={tabValue} onChange={handleTabChange} sx={{ borderBottom: 1, borderColor: "divider" }}>
          <Tab label="Advance Payments" value="payments" icon={<ArrowForward />} iconPosition="start" />
          <Tab label="Advance Receipts" value="receipts" icon={<ArrowBack />} iconPosition="start" />
          <Tab label="Advance Balance" value="balance" icon={<Receipt />} iconPosition="start" />
        </Tabs>

        {/* Filter Section */}
        <Box sx={{ p: 2, borderBottom: 1, borderColor: "divider", bgcolor: "background.default" }}>
          <Box sx={{ display: "flex", alignItems: "center", gap: 2, flexWrap: "wrap" }}>
            <Grid size={{ xs: 12, sm: 3 }}>
              <FormControl fullWidth size="small">
                <InputLabel>Contractor</InputLabel>
                <Select
                  value={selectedContractor || ""}
                  onChange={(e) => setSelectedContractor(e.target.value as number)}
                  label="Contractor"
                >
                  <MenuItem value="">All Contractors</MenuItem>
                  {contractors.map((c: any) => (
                    <MenuItem key={c.id} value={c.id}>
                      {c.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid size={{ xs: 6, sm: 2 }}>
              <LocalizationProvider dateAdapter={AdapterDayjs}>
                <DatePicker
                  label="From Date"
                  value={dayjs(filterFromDate)}
                  onChange={(date) => setFilterFromDate(date?.format('YYYY-MM-DD') || '')}
                  slotProps={{ textField: { size: "small", fullWidth: true } }}
                />
              </LocalizationProvider>
            </Grid>
            <Grid size={{ xs: 6, sm: 2 }}>
              <LocalizationProvider dateAdapter={AdapterDayjs}>
                <DatePicker
                  label="To Date"
                  value={dayjs(filterToDate)}
                  onChange={(date) => setFilterToDate(date?.format('YYYY-MM-DD') || '')}
                  slotProps={{ textField: { size: "small", fullWidth: true } }}
                />
              </LocalizationProvider>
            </Grid>
            <Grid size={{ xs: 12, sm: 5 }} sx={{ display: "flex", gap: 1, alignItems: "center" }}>
              <Button variant="contained" onClick={handleApplyFilter}>
                Apply Filter
              </Button>
              <Button variant="outlined" onClick={handleClearFilter}>
                Clear
              </Button>
              {tabValue !== "balance" && (
                <Box sx={{ ml: 2, display: "flex", gap: 1 }}>
                  <Chip
                    label={`Total: ${formatAmount(tabValue === "payments" ? totalAdvancePayments : totalAdvanceReceipts)}`}
                    color={tabValue === "payments" ? "primary" : "success"}
                    variant="outlined"
                  />
                  <Chip
                    label={`Count: ${advanceEntries.length}`}
                    variant="outlined"
                  />
                </Box>
              )}
            </Grid>
          </Box>
        </Box>

        {/* Content Area */}
        <Box sx={{ p: 2 }}>
          {tabValue === "balance" ? (
            <>
              <OrbxGrid
                rowData={advanceBalance}
                columnDefs={balanceColumns}
                loading={balanceLoading}
                height={500}
              />
              <Box sx={{ mt: 2, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <Typography variant="body2" color="text.secondary">
                  Shows net advance balance for each contractor (Payments - Receipts)
                </Typography>
                <Typography variant="h6">
                  Total Net Balance: {formatAmount(
                    advanceBalance.reduce((sum: number, b: ContractorAdvanceBalance) => 
                      sum + b.net_advance_balance, 0)
                  )}
                </Typography>
              </Box>
            </>
          ) : (
            <OrbxGrid
              rowData={advanceEntries}
              columnDefs={advanceColumns}
              loading={isLoading}
              height={500}
            />
          )}
        </Box>
      </Paper>

      {/* Advance Payment/Receipt Dialog */}
      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
          <DialogTitle>
            {getDialogTitle()}
          </DialogTitle>
        <form onSubmit={handleSubmit((data) => saveMutation.mutate(data))}>
          <DialogContent>
            <Grid container spacing={2}>
              <Grid size={{ xs: 6 }}>
                <Controller
                  name="entry_date"
                  control={control}
                  rules={{ required: "Date is required" }}
                  render={({ field, fieldState }) => (
                    <LocalizationProvider dateAdapter={AdapterDayjs}>
                      <DatePicker
                        label="Date *"
                        value={field.value ? dayjs(field.value) : null}
                        onChange={(date) => field.onChange(date?.format('YYYY-MM-DD'))}
                        slotProps={{
                          textField: {
                            fullWidth: true,
                            size: "small",
                            error: !!fieldState.error,
                            helperText: fieldState.error?.message,
                          },
                        }}
                      />
                    </LocalizationProvider>
                  )}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("entry_no")}
                  label="Voucher No"
                  fullWidth
                  size="small"
                  slotProps={{ inputLabel: { shrink: true } }}
                  disabled={true}
                  helperText="Auto-generated"
                />
              </Grid>

              <Grid size={{ xs: 12 }}>
                <Controller
                  name="ledger_id"
                  control={control}
                  rules={{ required: "Contractor is required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={contractors}
                      getOptionLabel={(option: any) => option?.name || ""}
                      value={contractors.find((c: any) => c.id === Number(field.value)) || null}
                      onChange={(_event, value) => field.onChange(value?.id || "")}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="Contractor *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                          size="small"
                        />
                      )}
                    />
                  )}
                />
              </Grid>

              <Grid size={{ xs: 6 }}>
                <Controller
                  name="amount"
                  control={control}
                  rules={{ 
                    required: "Amount is required",
                    min: { value: 0.01, message: "Amount must be greater than 0" }
                  }}
                  render={({ field, fieldState }) => (
                    <TextField
                      {...field}
                      label="Amount *"
                      type="number"
                      fullWidth
                      size="small"
                      slotProps={{ inputLabel: { shrink: true } }}
                      error={!!fieldState.error}
                      helperText={fieldState.error?.message}
                      onChange={(e) => field.onChange(Number(e.target.value))}
                    />
                  )}
                />
              </Grid>

              {/* Note: Payment mode, reference no, and bank details fields are not currently supported by the backend
                  These details can be added to the narration field if needed */}

              <Grid size={{ xs: 12 }}>
                <TextField
                  {...register("narration")}
                  label="Narration"
                  fullWidth
                  size="small"
                  multiline
                  rows={2}
                  slotProps={{ inputLabel: { shrink: true } }}
                  placeholder="Purpose of advance payment/receipt"
                />
              </Grid>

              {editingAdvance ? (
                <Grid size={{ xs: 12 }}>
                  <Alert severity="info" sx={{ mt: 1 }}>
                    Use this screen to edit advance payment/receipt details and narration.
                  </Alert>
                </Grid>
              ) : null}
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={handleCloseDialog} variant="outlined">
              Cancel
            </Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>
              {saveMutation.isPending ? "Saving..." : "Save"}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}