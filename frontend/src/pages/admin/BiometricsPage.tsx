import React, { useState, useEffect, useMemo } from "react";
import {
  Box, Button, TextField, Paper, Typography, Grid, Table, TableHead,
  TableBody, TableRow, TableCell, Chip, Tab, Tabs, MenuItem, Select,
  CircularProgress, Alert, Tooltip
} from "@mui/material";
import SaveIcon from "@mui/icons-material/Save";
import CheckCircleIcon from "@mui/icons-material/CheckCircle";
import CancelIcon from "@mui/icons-material/Cancel";
import EventAvailableIcon from "@mui/icons-material/EventAvailable";
import CalendarMonthIcon from "@mui/icons-material/CalendarMonth";
import TableViewIcon from "@mui/icons-material/TableView";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid, { ColDef } from "../../components/tables/OrbxGrid";
import { useAuthStore } from "../../store";

const _now = new Date();
const todayStr = `${_now.getFullYear()}-${String(_now.getMonth() + 1).padStart(2, "0")}-${String(_now.getDate()).padStart(2, "0")}`;

interface StaffRow {
  ledger_id: number;
  staff_name: string;
  staff_code?: string;
  status: string;
  punch_in: string;
  punch_out: string;
  hours_worked: number;
  ot_hours: number;
  remarks: string;
}

export default function BiometricsPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  const [activeTab, setActiveTab] = useState(0);
  const [entryDate, setEntryDate] = useState(todayStr);
  const [rows, setRows] = useState<StaffRow[]>([]);
  const [saveSuccessMsg, setSaveSuccessMsg] = useState("");

  // Monthly summary tab state
  const [selectedMonth, setSelectedMonth] = useState(_now.getMonth() + 1);
  const [selectedYear, setSelectedYear] = useState(_now.getFullYear());

  // 1. Fetch Daily Staff Attendance for selected date
  const { data: dailyData = [], isLoading: isDailyLoading, refetch: refetchDaily } = useQuery({
    queryKey: ["daily-staff-attendance", activeFY, entryDate],
    queryFn: async () => (await api.get(`/biometrics/daily-staff?fy=${activeFY}&entry_date=${entryDate}`)).data,
  });

  // Populate editable rows when dailyData changes
  useEffect(() => {
    if (dailyData && Array.isArray(dailyData)) {
      const formatted = dailyData.map((d: any) => ({
        ledger_id: d.ledger_id,
        staff_name: d.staff_name,
        staff_code: d.staff_code || "",
        status: d.status || "Present",
        punch_in: d.punch_in ? d.punch_in.substring(0, 5) : "09:00",
        punch_out: d.punch_out ? d.punch_out.substring(0, 5) : "18:00",
        hours_worked: Number(d.hours_worked ?? 8.0),
        ot_hours: Number(d.ot_hours ?? 0.0),
        remarks: d.remarks || "",
      }));
      setRows(formatted);
    }
  }, [dailyData]);

  // 2. Save Daily Attendance Bulk Mutation
  const saveMutation = useMutation({
    mutationFn: async () => {
      const payload = {
        entry_date: entryDate,
        entries: rows.map((r) => ({
          ledger_id: r.ledger_id,
          status: r.status,
          punch_in: r.punch_in,
          punch_out: r.punch_out,
          hours_worked: Number(r.hours_worked || 0),
          ot_hours: Number(r.ot_hours || 0),
          remarks: r.remarks || "",
        })),
      };
      return (await api.post(`/biometrics/daily-bulk?fy=${activeFY}`, payload)).data;
    },
    onSuccess: (data) => {
      qc.invalidateQueries({ queryKey: ["daily-staff-attendance"] });
      qc.invalidateQueries({ queryKey: ["biometrics"] });
      qc.invalidateQueries({ queryKey: ["attendance-summary"] });
      setSaveSuccessMsg(data.message || "Daily attendance saved successfully!");
      setTimeout(() => setSaveSuccessMsg(""), 4000);
    },
    onError: (err: any) => {
      alert("Failed to save attendance. Please try again.");
    },
  });

  // KPI Stats for Daily Entry
  const kpiStats = useMemo(() => {
    const total = rows.length;
    const present = rows.filter((r) => r.status === "Present").length;
    const halfDay = rows.filter((r) => r.status === "Half Day").length;
    const absent = rows.filter((r) => r.status === "Absent").length;
    const leave = rows.filter((r) => r.status === "On Leave").length;
    return { total, present, halfDay, absent, leave };
  }, [rows]);

  // Quick Action: Mark All
  const handleMarkAll = (statusVal: string) => {
    setRows((prev) =>
      prev.map((r) => ({
        ...r,
        status: statusVal,
        hours_worked: statusVal === "Present" ? 8.0 : statusVal === "Half Day" ? 4.0 : 0.0,
        punch_in: statusVal === "Absent" || statusVal === "On Leave" ? "" : r.punch_in || "09:00",
        punch_out: statusVal === "Absent" || statusVal === "On Leave" ? "" : r.punch_out || "18:00",
      }))
    );
  };

  // Handle row changes
  const handleRowChange = (index: number, field: keyof StaffRow, val: any) => {
    setRows((prev) =>
      prev.map((r, idx) => {
        if (idx === index) {
          const updated = { ...r, [field]: val };
          if (field === "status") {
            if (val === "Present") {
              updated.hours_worked = 8.0;
              if (!updated.punch_in) updated.punch_in = "09:00";
              if (!updated.punch_out) updated.punch_out = "18:00";
            } else if (val === "Half Day") {
              updated.hours_worked = 4.0;
              if (!updated.punch_in) updated.punch_in = "09:00";
              if (!updated.punch_out) updated.punch_out = "13:00";
            } else if (val === "Absent" || val === "On Leave") {
              updated.hours_worked = 0.0;
              updated.punch_in = "";
              updated.punch_out = "";
            }
          }
          return updated;
        }
        return r;
      })
    );
  };

  // 3. Fetch Monthly Summary Data
  const { data: monthlyData = [], isLoading: isMonthlyLoading } = useQuery({
    queryKey: ["attendance-summary", activeFY, selectedMonth, selectedYear],
    queryFn: async () =>
      (await api.get(`/biometrics/attendance-summary?fy=${activeFY}&month=${selectedMonth}&year=${selectedYear}`)).data,
    enabled: activeTab === 1,
  });

  // 4. Fetch Raw Attendance Logs Data
  const { data: rawLogs = [], isLoading: isLogsLoading, refetch: refetchLogs } = useQuery({
    queryKey: ["biometrics", activeFY],
    queryFn: async () => (await api.get(`/biometrics/?fy=${activeFY}`)).data,
    enabled: activeTab === 2,
  });

  const rawColDefs: ColDef[] = [
    { field: "entry_date", headerName: "Date", width: 110 },
    { field: "ledger_name", headerName: "Staff Member", flex: 1 },
    { field: "status", headerName: "Status", width: 110,
      cellRenderer: (p: any) => (
        <Chip
          label={p.value} size="small"
          color={p.value === "Present" ? "success" : p.value === "Absent" ? "error" : p.value === "Half Day" ? "warning" : "info"}
          sx={{ fontSize: "0.7rem", fontWeight: 700 }}
        />
      )
    },
    { field: "punch_in", headerName: "Punch In", width: 110 },
    { field: "punch_out", headerName: "Punch Out", width: 110 },
    { field: "hours_worked", headerName: "Work Hrs", width: 100, type: "numericColumn" },
    { field: "ot_hours", headerName: "OT Hrs", width: 90, type: "numericColumn" },
    { field: "device_log_id", headerName: "Remarks / Log", width: 160 },
  ];

  return (
    <Box>
      <PageHeader
        title="Staff Attendance & Wages Register"
        subtitle="Daily staff attendance recording, overtime tracking, and monthly payroll registers"
        breadcrumbs={[{ label: "Salary and Wages" }, { label: "Attendance" }]}
      />

      {/* Main Tabs Navigation */}
      <Paper variant="outlined" sx={{ mb: 2, borderRadius: "8px" }}>
        <Tabs
          value={activeTab}
          onChange={(_, val) => setActiveTab(val)}
          sx={{
            px: 2,
            "& .MuiTab-root": { fontWeight: 700, minHeight: 48, fontSize: "0.9rem" },
            "& .Mui-selected": { color: "#0f5132 !important" },
            "& .MuiTabs-indicator": { backgroundColor: "#0f5132", height: 3 }
          }}
        >
          <Tab icon={<EventAvailableIcon fontSize="small" />} iconPosition="start" label="Daily Staff Attendance" />
          <Tab icon={<CalendarMonthIcon fontSize="small" />} iconPosition="start" label="Monthly Attendance Register" />
          <Tab icon={<TableViewIcon fontSize="small" />} iconPosition="start" label="Attendance Logs History" />
        </Tabs>
      </Paper>

      {/* TAB 0: DAILY STAFF ATTENDANCE ENTRY */}
      {activeTab === 0 && (
        <Box>
          {/* Controls Bar */}
          <Paper variant="outlined" sx={{ p: 2, mb: 2, borderRadius: "8px", bgcolor: "#fcfdfc" }}>
            <Grid container spacing={2} sx={{ alignItems: "center" }}>
              <Grid size={{ xs: 12, md: 3 }}>
                <TextField
                  label="Select Attendance Date *"
                  type="date"
                  size="small"
                  fullWidth
                  value={entryDate}
                  onChange={(e) => setEntryDate(e.target.value)}
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>
              <Grid size={{ xs: 12, md: 5 }}>
                <Box sx={{ display: "flex", gap: 1 }}>
                  <Button
                    variant="outlined"
                    color="success"
                    size="small"
                    startIcon={<CheckCircleIcon />}
                    onClick={() => handleMarkAll("Present")}
                    sx={{ fontWeight: 700, borderRadius: "6px" }}
                  >
                    Mark All Present
                  </Button>
                  <Button
                    variant="outlined"
                    color="error"
                    size="small"
                    startIcon={<CancelIcon />}
                    onClick={() => handleMarkAll("Absent")}
                    sx={{ fontWeight: 700, borderRadius: "6px" }}
                  >
                    Mark All Absent
                  </Button>
                </Box>
              </Grid>
              <Grid size={{ xs: 12, md: 4 }} sx={{ textAlign: { md: "right" } }}>
                <Button
                  variant="contained"
                  size="medium"
                  startIcon={saveMutation.isPending ? <CircularProgress size={18} color="inherit" /> : <SaveIcon />}
                  onClick={() => saveMutation.mutate()}
                  disabled={saveMutation.isPending || rows.length === 0}
                  sx={{
                    bgcolor: "#0f5132",
                    px: 3,
                    py: 1,
                    fontWeight: 700,
                    borderRadius: "6px",
                    "&:hover": { bgcolor: "#0a3822" }
                  }}
                >
                  {saveMutation.isPending ? "Saving Attendance..." : "Save Daily Attendance"}
                </Button>
              </Grid>
            </Grid>
          </Paper>

          {/* Success Alert Banner */}
          {saveSuccessMsg && (
            <Alert severity="success" sx={{ mb: 2, fontWeight: 600 }}>
              {saveSuccessMsg}
            </Alert>
          )}

          {/* KPI Summary Cards */}
          <Grid container spacing={2} sx={{ mb: 2 }}>
            <Grid size={{ xs: 6, sm: 2.4 }}>
              <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center", borderRadius: "8px", bgcolor: "#f8fafc" }}>
                <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 700 }}>TOTAL STAFF</Typography>
                <Typography variant="h5" sx={{ fontWeight: 800, color: "#1e293b" }}>{kpiStats.total}</Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 2.4 }}>
              <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center", borderRadius: "8px", bgcolor: "#f0fdf4", borderColor: "#bbf7d0" }}>
                <Typography variant="caption" sx={{ fontWeight: 700, color: "#166534" }}>PRESENT</Typography>
                <Typography variant="h5" sx={{ fontWeight: 800, color: "#15803d" }}>{kpiStats.present}</Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 2.4 }}>
              <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center", borderRadius: "8px", bgcolor: "#fffbeb", borderColor: "#fde68a" }}>
                <Typography variant="caption" sx={{ fontWeight: 700, color: "#92400e" }}>HALF DAY</Typography>
                <Typography variant="h5" sx={{ fontWeight: 800, color: "#b45309" }}>{kpiStats.halfDay}</Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 2.4 }}>
              <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center", borderRadius: "8px", bgcolor: "#fef2f2", borderColor: "#fecaca" }}>
                <Typography variant="caption" sx={{ fontWeight: 700, color: "#991b1b" }}>ABSENT</Typography>
                <Typography variant="h5" sx={{ fontWeight: 800, color: "#b91c1c" }}>{kpiStats.absent}</Typography>
              </Paper>
            </Grid>
            <Grid size={{ xs: 6, sm: 2.4 }}>
              <Paper variant="outlined" sx={{ p: 1.5, textAlign: "center", borderRadius: "8px", bgcolor: "#eff6ff", borderColor: "#bfdbfe" }}>
                <Typography variant="caption" sx={{ fontWeight: 700, color: "#1e40af" }}>ON LEAVE</Typography>
                <Typography variant="h5" sx={{ fontWeight: 800, color: "#1d4ed8" }}>{kpiStats.leave}</Typography>
              </Paper>
            </Grid>
          </Grid>

          {/* Attendance Table */}
          <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
            {isDailyLoading ? (
              <Box sx={{ p: 4, textAlign: "center" }}>
                <CircularProgress size={32} sx={{ color: "#0f5132" }} />
                <Typography variant="body2" sx={{ mt: 1, color: "text.secondary" }}>Loading staff list...</Typography>
              </Box>
            ) : rows.length === 0 ? (
              <Box sx={{ p: 4, textAlign: "center" }}>
                <Typography variant="body1" sx={{ fontWeight: 600, color: "text.secondary" }}>
                  No active staff members found in Staff / Salary Ledgers.
                </Typography>
                <Typography variant="caption" color="text.secondary">
                  Please create staff members under Masters → Ledgers (Group: Staff / Salary).
                </Typography>
              </Box>
            ) : (
              <Table size="small">
                <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                  <TableRow>
                    <TableCell sx={{ width: 50, fontWeight: 700, textAlign: "center" }}>#</TableCell>
                    <TableCell sx={{ fontWeight: 700, minWidth: 200 }}>Staff Name</TableCell>
                    <TableCell sx={{ width: 160, fontWeight: 700 }}>Attendance Status</TableCell>
                    <TableCell sx={{ width: 110, fontWeight: 700 }}>In Time</TableCell>
                    <TableCell sx={{ width: 110, fontWeight: 700 }}>Out Time</TableCell>
                    <TableCell sx={{ width: 100, fontWeight: 700, textAlign: "right" }}>Work Hrs</TableCell>
                    <TableCell sx={{ width: 100, fontWeight: 700, textAlign: "right" }}>OT Hrs</TableCell>
                    <TableCell sx={{ fontWeight: 700, minWidth: 160 }}>Remarks / Notes</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {rows.map((row, idx) => {
                    const statusColor =
                      row.status === "Present" ? "#16a34a" :
                      row.status === "Half Day" ? "#d97706" :
                      row.status === "Absent" ? "#dc2626" : "#2563eb";

                    return (
                      <TableRow key={row.ledger_id} hover sx={{ bgcolor: idx % 2 === 0 ? "#ffffff" : "#fafdfb" }}>
                        <TableCell align="center" sx={{ fontWeight: 600, color: "text.secondary" }}>{idx + 1}</TableCell>
                        <TableCell>
                          <Typography variant="body2" sx={{ fontWeight: 700, color: "#1e293b" }}>
                            {row.staff_name}
                          </Typography>
                          {row.staff_code && (
                            <Typography variant="caption" sx={{ color: "text.secondary" }}>Code: {row.staff_code}</Typography>
                          )}
                        </TableCell>
                        <TableCell>
                          <Select
                            size="small"
                            value={row.status}
                            onChange={(e) => handleRowChange(idx, "status", e.target.value)}
                            fullWidth
                            sx={{
                              fontSize: "0.85rem",
                              fontWeight: 700,
                              color: statusColor,
                              height: 36,
                              "& .MuiOutlinedInput-notchedOutline": { borderColor: statusColor }
                            }}
                          >
                            <MenuItem value="Present">🟢 Present</MenuItem>
                            <MenuItem value="Half Day">🟠 Half Day</MenuItem>
                            <MenuItem value="Absent">🔴 Absent</MenuItem>
                            <MenuItem value="On Leave">🔵 On Leave</MenuItem>
                          </Select>
                        </TableCell>
                        <TableCell>
                          <TextField
                            type="time"
                            size="small"
                            value={row.punch_in}
                            onChange={(e) => handleRowChange(idx, "punch_in", e.target.value)}
                            disabled={row.status === "Absent" || row.status === "On Leave"}
                            slotProps={{ htmlInput: { style: { padding: "6px 8px", fontSize: "0.85rem" } } }}
                          />
                        </TableCell>
                        <TableCell>
                          <TextField
                            type="time"
                            size="small"
                            value={row.punch_out}
                            onChange={(e) => handleRowChange(idx, "punch_out", e.target.value)}
                            disabled={row.status === "Absent" || row.status === "On Leave"}
                            slotProps={{ htmlInput: { style: { padding: "6px 8px", fontSize: "0.85rem" } } }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={row.hours_worked}
                            onChange={(e) => handleRowChange(idx, "hours_worked", Number(e.target.value))}
                            disabled={row.status === "Absent"}
                            slotProps={{ htmlInput: { style: { textAlign: "right", padding: "6px 8px", fontSize: "0.85rem", fontWeight: 700 } } }}
                          />
                        </TableCell>
                        <TableCell align="right">
                          <TextField
                            type="number"
                            size="small"
                            value={row.ot_hours}
                            onChange={(e) => handleRowChange(idx, "ot_hours", Number(e.target.value))}
                            placeholder="0.0"
                            slotProps={{ htmlInput: { style: { textAlign: "right", padding: "6px 8px", fontSize: "0.85rem" } } }}
                          />
                        </TableCell>
                        <TableCell>
                          <TextField
                            size="small"
                            fullWidth
                            placeholder="e.g. Permission / On field"
                            value={row.remarks}
                            onChange={(e) => handleRowChange(idx, "remarks", e.target.value)}
                            slotProps={{ htmlInput: { style: { padding: "6px 8px", fontSize: "0.85rem" } } }}
                          />
                        </TableCell>
                      </TableRow>
                    );
                  })}
                </TableBody>
              </Table>
            )}
          </Paper>
        </Box>
      )}

      {/* TAB 1: MONTHLY ATTENDANCE REGISTER */}
      {activeTab === 1 && (
        <Box>
          <Paper variant="outlined" sx={{ p: 2, mb: 2, borderRadius: "8px" }}>
            <Grid container spacing={2} sx={{ alignItems: "center" }}>
              <Grid size={{ xs: 6, md: 3 }}>
                <TextField
                  select
                  label="Select Month"
                  size="small"
                  fullWidth
                  value={selectedMonth}
                  onChange={(e) => setSelectedMonth(Number(e.target.value))}
                >
                  {["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"].map((m, i) => (
                    <MenuItem key={i + 1} value={i + 1}>{m}</MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid size={{ xs: 6, md: 3 }}>
                <TextField
                  type="number"
                  label="Year"
                  size="small"
                  fullWidth
                  value={selectedYear}
                  onChange={(e) => setSelectedYear(Number(e.target.value))}
                />
              </Grid>
            </Grid>
          </Paper>

          <Paper variant="outlined" sx={{ borderRadius: "8px", overflow: "hidden" }}>
            {isMonthlyLoading ? (
              <Box sx={{ p: 4, textAlign: "center" }}>
                <CircularProgress size={32} sx={{ color: "#0f5132" }} />
              </Box>
            ) : monthlyData.length === 0 ? (
              <Box sx={{ p: 3, textAlign: "center" }}>
                <Typography color="text.secondary">No attendance records found for this month.</Typography>
              </Box>
            ) : (
              <Table size="small">
                <TableHead sx={{ bgcolor: "#f4f9f6" }}>
                  <TableRow>
                    <TableCell sx={{ fontWeight: 700 }}>#</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Staff Name</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "#15803d" }} align="right">Present Days</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "#b45309" }} align="right">Half Days</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "#b91c1c" }} align="right">Absent Days</TableCell>
                    <TableCell sx={{ fontWeight: 700, color: "#1d4ed8" }} align="right">Leave Days</TableCell>
                    <TableCell sx={{ fontWeight: 700 }} align="right">Total Work Hours</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {monthlyData.map((row: any, idx: number) => (
                    <TableRow key={row.id} hover>
                      <TableCell>{idx + 1}</TableCell>
                      <TableCell sx={{ fontWeight: 700 }}>{row.ledger}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700, color: "#15803d" }}>{row.present_days}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700, color: "#b45309" }}>{row.half_days}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700, color: "#b91c1c" }}>{row.absent_days}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700, color: "#1d4ed8" }}>{row.leave_days || 0}</TableCell>
                      <TableCell align="right" sx={{ fontWeight: 700 }}>{row.total_hours} hrs</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </Paper>
        </Box>
      )}

      {/* TAB 2: ATTENDANCE LOGS HISTORY */}
      {activeTab === 2 && (
        <Box>
          <OrbxGrid rowData={rawLogs} columnDefs={rawColDefs} loading={isLogsLoading} onRefresh={refetchLogs} />
        </Box>
      )}
    </Box>
  );
}
