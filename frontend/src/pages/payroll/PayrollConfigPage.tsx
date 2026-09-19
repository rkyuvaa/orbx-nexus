import { useState, useMemo, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Grid, TextField, Typography, Paper,
  MenuItem, Switch, FormControlLabel, Chip, IconButton, Tooltip,
  Table, TableHead, TableBody, TableRow, TableCell, Alert,
  CircularProgress, Tab, Tabs,
  FormGroup, FormControl, FormLabel, Checkbox
} from "@mui/material";
import Save from "@mui/icons-material/Save";
import Add from "@mui/icons-material/Add";
import Delete from "@mui/icons-material/Delete";
import RouterIcon from "@mui/icons-material/Router";
import AccessTimeIcon from "@mui/icons-material/AccessTime";
import EventBusyIcon from "@mui/icons-material/EventBusy";
import CalendarMonthIcon from "@mui/icons-material/CalendarMonth";
import NetworkCheckIcon from "@mui/icons-material/NetworkCheck";
import PageHeader from "../../components/PageHeader";
import api from "../../api/client";

const BREADCRUMBS = [{ label: "Salary and Wages" }, { label: "Configuration" }];

const WEEK_DAYS = [
  { value: "0", label: "Sunday" },
  { value: "1", label: "Monday" },
  { value: "2", label: "Tuesday" },
  { value: "3", label: "Wednesday" },
  { value: "4", label: "Thursday" },
  { value: "5", label: "Friday" },
  { value: "6", label: "Saturday" },
];

const PROTOCOLS = ["ZKTeco", "ESSL", "TCP", "HTTP", "SDK"];

const DEFAULT_CONFIG = {
  device_name: "",
  device_ip: "",
  device_port: 4370,
  device_protocol: "ZKTeco",
  auto_sync: false,
  shift_name: "General Shift",
  shift_start: "09:00",
  shift_end: "18:00",
  ot_after_hours: 8.0,
  grace_minutes: 15,
  week_off_days: "0",
  working_days_per_month: 26,
};

export default function PayrollConfigPage() {
  const qc = useQueryClient();
  const [saveSuccess, setSaveSuccess] = useState(false);
  const [activeTab, setActiveTab] = useState(0);

  // ── Config state ──
  const [cfg, setCfg] = useState<any>(DEFAULT_CONFIG);

  // ── Connection test state ──
  const [testResult, setTestResult] = useState<{ success: boolean; message: string } | null>(null);

  // ── Holiday form state ──
  const [newDate, setNewDate] = useState("");
  const [newName, setNewName] = useState("");
  const [newDesc, setNewDesc] = useState("");
  const [holidayYear, setHolidayYear] = useState(new Date().getFullYear());

  // ── Week off days set ──
  const weekOffSet = useMemo(() => {
    const raw = cfg.week_off_days;
    if (raw === null || raw === undefined || raw === "") return new Set<string>();
    const parts = String(raw).split(",").map((s: string) => s.trim()).filter(Boolean);
    return new Set<string>(parts);
  }, [cfg.week_off_days]);

  const toggleWeekOff = (day: string) => {
    const s = new Set(weekOffSet);
    if (s.has(day)) s.delete(day);
    else s.add(day);
    const updated = Array.from(s).sort().join(",");
    setCfg((c: any) => ({ ...c, week_off_days: updated }));
  };

  // ── Fetch config ──
  const { data: serverConfig, isLoading: cfgLoading } = useQuery({
    queryKey: ["payroll-config"],
    queryFn: async () => {
      const res = await api.get("/payroll/config-settings/");
      return res.data;
    },
  });

  // Populate state when server data is loaded/updated
  useEffect(() => {
    if (serverConfig) {
      const merged = { ...DEFAULT_CONFIG, ...serverConfig };
      Object.keys(merged).forEach((k) => {
        if (merged[k] === null) {
          merged[k] = (DEFAULT_CONFIG as any)[k] ?? "";
        }
      });
      setCfg(merged);
    }
  }, [serverConfig]);

  // ── Fetch holidays ──
  const { data: holidays = [], isLoading: hdLoading, refetch: refetchHolidays } = useQuery({
    queryKey: ["payroll-holidays", holidayYear],
    queryFn: async () => (await api.get(`/payroll/config-settings/holidays?year=${holidayYear}`)).data,
  });

  // ── Save config ──
  const saveMutation = useMutation({
    mutationFn: async () => {
      const { id, created_at, updated_at, ...payload } = cfg;

      if (payload.device_port === "" || payload.device_port == null) payload.device_port = 4370;
      if (payload.ot_after_hours === "" || payload.ot_after_hours == null) payload.ot_after_hours = 8.0;
      if (payload.grace_minutes === "" || payload.grace_minutes == null) payload.grace_minutes = 15;
      if (payload.working_days_per_month === "" || payload.working_days_per_month == null) payload.working_days_per_month = 26;

      const res = await api.put("/payroll/config-settings/", payload);
      return res.data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["payroll-config"] });
      setSaveSuccess(true);
      setTimeout(() => setSaveSuccess(false), 3500);
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to save configuration";
      alert(typeof msg === "string" ? msg : JSON.stringify(msg));
    },
  });

  // ── Test connection ──
  const testConnMutation = useMutation({
    mutationFn: async () => {
      setTestResult(null);
      const res = await api.post("/payroll/config-settings/test-connection", {
        device_ip: cfg.device_ip,
        device_port: cfg.device_port || 4370,
        device_protocol: cfg.device_protocol || "ZKTeco",
      });
      return res.data;
    },
    onSuccess: (data: any) => setTestResult(data),
    onError: (err: any) => {
      const msg = err?.response?.data?.detail || err?.message || "Failed to test connection";
      setTestResult({ success: false, message: msg });
    },
  });

  // ── Add holiday ──
  const addHolidayMutation = useMutation({
    mutationFn: async () => {
      if (!newDate || !newName.trim()) throw new Error("Date and name are required");
      await api.post("/payroll/config-settings/holidays", {
        holiday_date: newDate,
        holiday_name: newName.trim(),
        description: newDesc.trim() || null,
      });
    },
    onSuccess: () => { setNewDate(""); setNewName(""); setNewDesc(""); refetchHolidays(); },
    onError: (err: any) => alert(err?.response?.data?.detail || err?.message || "Failed to add holiday"),
  });

  // ── Delete holiday ──
  const deleteHolidayMutation = useMutation({
    mutationFn: async (id: number) => { await api.delete(`/payroll/config-settings/holidays/${id}`); },
    onSuccess: () => refetchHolidays(),
    onError: () => alert("Failed to delete holiday"),
  });

  const set = (key: string) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const val = e.target.value;
    setCfg((c: any) => ({ ...c, [key]: val }));
  };

  const setNum = (key: string) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const val = e.target.value;
    setCfg((c: any) => ({ ...c, [key]: val === "" ? "" : Number(val) }));
  };

  const setBool = (key: string) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setCfg((c: any) => ({ ...c, [key]: e.target.checked }));
  };

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5, width: "100%" }}>
      {/* ── Top Header with Action Button ── */}
      <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 1 }}>
        <PageHeader
          title="Payroll Configuration"
          subtitle="Configure biometric machine, shifts, holidays and week off settings"
          breadcrumbs={BREADCRUMBS}
        />
        {activeTab !== 3 && (
          <Button
            variant="contained"
            color="success"
            startIcon={<Save />}
            onClick={() => saveMutation.mutate()}
            disabled={saveMutation.isPending}
            sx={{ fontWeight: 700, px: 3, height: 40 }}
          >
            {saveMutation.isPending ? "Saving..." : "Save Configuration"}
          </Button>
        )}
      </Box>

      {saveSuccess && (
        <Alert severity="success" sx={{ mb: 1 }}>
          Configuration saved successfully!
        </Alert>
      )}

      {cfgLoading ? (
        <Box sx={{ display: "flex", justifyContent: "center", py: 6 }}>
          <CircularProgress />
        </Box>
      ) : (
        <Paper variant="outlined" sx={{ borderRadius: "12px", width: "100%" }}>
          {/* ── Tab Bar ── */}
          <Box sx={{ borderBottom: "1px solid #e2e8f0", bgcolor: "#f8fafc", borderTopLeftRadius: "12px", borderTopRightRadius: "12px" }}>
            <Tabs
              value={activeTab}
              onChange={(_, v) => setActiveTab(v)}
              variant="scrollable"
              scrollButtons="auto"
              sx={{
                "& .MuiTab-root": { fontWeight: 600, textTransform: "none", minHeight: 52, fontSize: "0.875rem" },
                "& .Mui-selected": { color: "#0f5132 !important" },
                "& .MuiTabs-indicator": { bgcolor: "#0f5132", height: 3 },
              }}
            >
              <Tab
                icon={<RouterIcon sx={{ fontSize: 18 }} />}
                iconPosition="start"
                label="Biometric Machine"
              />
              <Tab
                icon={<AccessTimeIcon sx={{ fontSize: 18 }} />}
                iconPosition="start"
                label="Shift Timings"
              />
              <Tab
                icon={<EventBusyIcon sx={{ fontSize: 18 }} />}
                iconPosition="start"
                label={
                  <Box sx={{ display: "flex", alignItems: "center", gap: 0.8 }}>
                    Week Off Days
                    <Chip label={`${weekOffSet.size}`} size="small" color="warning" sx={{ fontSize: "0.7rem", height: 18 }} />
                  </Box>
                }
              />
              <Tab
                icon={<CalendarMonthIcon sx={{ fontSize: 18 }} />}
                iconPosition="start"
                label={
                  <Box sx={{ display: "flex", alignItems: "center", gap: 0.8 }}>
                    Holidays
                    <Chip label={`${holidays.length}`} size="small" color="secondary" sx={{ fontSize: "0.7rem", height: 18 }} />
                  </Box>
                }
              />
            </Tabs>
          </Box>

          {/* ── Tab Panels ── */}
          <Box sx={{ p: 3 }}>

            {/* ── Tab 0: Biometric Machine ── */}
            {activeTab === 0 && (
              <Box>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2.5 }}>
                  Configure the biometric punch-in/out device connection settings.
                </Typography>
                <Grid container spacing={2}>
                  <Grid size={{ xs: 12, sm: 4 }}>
                    <TextField
                      label="Device Name / Description"
                      value={cfg.device_name ?? ""}
                      onChange={set("device_name")}
                      fullWidth
                      placeholder="e.g. Front Gate ZK-U980"
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 4 }}>
                    <TextField
                      label="IP Address"
                      value={cfg.device_ip ?? ""}
                      onChange={set("device_ip")}
                      fullWidth
                      placeholder="e.g. 192.168.1.100"
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="Port"
                      value={cfg.device_port ?? ""}
                      onChange={setNum("device_port")}
                      type="number"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="Protocol"
                      value={cfg.device_protocol || "ZKTeco"}
                      onChange={set("device_protocol")}
                      select
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    >
                      {PROTOCOLS.map((p) => <MenuItem key={p} value={p}>{p}</MenuItem>)}
                    </TextField>
                  </Grid>
                  <Grid size={{ xs: 12 }} sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", flexWrap: "wrap", gap: 2, pt: 1 }}>
                    <FormControlLabel
                      control={
                        <Switch checked={Boolean(cfg.auto_sync)} onChange={setBool("auto_sync")} color="success" />
                      }
                      label={
                        <Typography variant="body2" sx={{ fontWeight: 600 }}>
                          Enable Auto-Sync (pull punches from device automatically)
                        </Typography>
                      }
                    />
                    <Button
                      variant="outlined"
                      color="primary"
                      startIcon={<NetworkCheckIcon />}
                      onClick={() => testConnMutation.mutate()}
                      disabled={testConnMutation.isPending || !cfg.device_ip?.trim()}
                      sx={{ fontWeight: 600, px: 2.5 }}
                    >
                      {testConnMutation.isPending ? "Testing Connection..." : "Test Connection"}
                    </Button>
                  </Grid>

                  {testResult && (
                    <Grid size={{ xs: 12 }}>
                      <Alert severity={testResult.success ? "success" : "error"} onClose={() => setTestResult(null)}>
                        {testResult.message}
                      </Alert>
                    </Grid>
                  )}
                </Grid>
              </Box>
            )}

            {/* ── Tab 1: Shift Timings ── */}
            {activeTab === 1 && (
              <Box>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2.5 }}>
                  Define the default shift schedule and overtime / grace period rules.
                </Typography>
                <Grid container spacing={2}>
                  <Grid size={{ xs: 12, sm: 4 }}>
                    <TextField
                      label="Shift Name"
                      value={cfg.shift_name ?? ""}
                      onChange={set("shift_name")}
                      fullWidth
                      placeholder="e.g. General Shift"
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="Shift Start Time"
                      value={cfg.shift_start ?? "09:00"}
                      onChange={set("shift_start")}
                      type="time"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="Shift End Time"
                      value={cfg.shift_end ?? "18:00"}
                      onChange={set("shift_end")}
                      type="time"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="OT After (hours)"
                      value={cfg.ot_after_hours ?? ""}
                      onChange={setNum("ot_after_hours")}
                      type="number"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true }, htmlInput: { step: "0.5", min: "1" } }}
                      helperText="Hours beyond which OT is counted"
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 2 }}>
                    <TextField
                      label="Grace Period (mins)"
                      value={cfg.grace_minutes ?? ""}
                      onChange={setNum("grace_minutes")}
                      type="number"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true }, htmlInput: { min: "0", max: "60" } }}
                      helperText="Late arrival grace time"
                    />
                  </Grid>
                  <Grid size={{ xs: 12, sm: 4 }}>
                    <TextField
                      label="Working Days per Month (default)"
                      value={cfg.working_days_per_month ?? ""}
                      onChange={setNum("working_days_per_month")}
                      type="number"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true }, htmlInput: { min: "20", max: "31" } }}
                      helperText="Used to calculate per-day salary from monthly salary"
                    />
                  </Grid>
                </Grid>
              </Box>
            )}

            {/* ── Tab 2: Week Off Days ── */}
            {activeTab === 2 && (
              <Box>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2.5 }}>
                  Select the days that are weekly off. These will be excluded from attendance calculations.
                </Typography>
                <FormControl component="fieldset">
                  <FormLabel component="legend" sx={{ fontWeight: 600, mb: 1.5, color: "#92400e" }}>
                    Select Weekly Off Days
                  </FormLabel>
                  <FormGroup row sx={{ gap: 1.5, flexWrap: "wrap" }}>
                    {WEEK_DAYS.map((day) => (
                      <Paper
                        key={day.value}
                        variant="outlined"
                        onClick={() => toggleWeekOff(day.value)}
                        sx={{
                          px: 2, py: 1.2,
                          cursor: "pointer",
                          borderRadius: "8px",
                          border: weekOffSet.has(day.value) ? "2px solid #d97706" : "1px solid #e2e8f0",
                          bgcolor: weekOffSet.has(day.value) ? "#fef3c7" : "background.paper",
                          display: "flex", alignItems: "center", gap: 1,
                          transition: "all 0.15s",
                          "&:hover": { borderColor: "#d97706", bgcolor: "#fffbeb" },
                          userSelect: "none",
                        }}
                      >
                        <Checkbox
                          checked={weekOffSet.has(day.value)}
                          onChange={() => toggleWeekOff(day.value)}
                          onClick={(e) => e.stopPropagation()}
                          color="warning"
                          size="small"
                          sx={{ p: 0 }}
                        />
                        <Typography variant="body2" sx={{ fontWeight: weekOffSet.has(day.value) ? 700 : 500 }}>
                          {day.label}
                        </Typography>
                      </Paper>
                    ))}
                  </FormGroup>
                </FormControl>
                <Box sx={{ mt: 3, display: "flex", gap: 1, flexWrap: "wrap", alignItems: "center" }}>
                  <Typography variant="body2" color="text.secondary" sx={{ mr: 1 }}>Selected:</Typography>
                  {WEEK_DAYS.filter((d) => weekOffSet.has(d.value)).map((d) => (
                    <Chip key={d.value} label={d.label} color="warning" size="small" sx={{ fontWeight: 700 }} />
                  ))}
                  {weekOffSet.size === 0 && (
                    <Typography variant="body2" color="text.secondary" sx={{ fontStyle: "italic" }}>
                      No weekly off days selected — all 7 days are considered working days.
                    </Typography>
                  )}
                </Box>
              </Box>
            )}

            {/* ── Tab 3: Holidays ── */}
            {activeTab === 3 && (
              <Box>
                {/* Year filter + Add form */}
                <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
                  <TextField
                    label="Year"
                    type="number"
                    value={holidayYear}
                    onChange={(e) => setHolidayYear(Number(e.target.value))}
                    size="small"
                    sx={{ width: 110 }}
                    slotProps={{ inputLabel: { shrink: true } }}
                  />
                  <Typography variant="body2" color="text.secondary">
                    Showing holidays for {holidayYear}
                  </Typography>
                </Box>

                <Paper variant="outlined" sx={{ p: 2, mb: 2.5, bgcolor: "#faf5ff", borderRadius: "8px", border: "1px dashed #a78bfa" }}>
                  <Typography variant="subtitle2" sx={{ fontWeight: 700, color: "#7c3aed", mb: 1.5 }}>
                    Add New Holiday
                  </Typography>
                  <Grid container spacing={2} sx={{ alignItems: "center" }}>
                    <Grid size={{ xs: 12, sm: 3 }}>
                      <TextField
                        label="Date *"
                        type="date"
                        value={newDate}
                        onChange={(e) => setNewDate(e.target.value)}
                        fullWidth
                        size="small"
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                    <Grid size={{ xs: 12, sm: 4 }}>
                      <TextField
                        label="Holiday Name *"
                        value={newName}
                        onChange={(e) => setNewName(e.target.value)}
                        fullWidth
                        size="small"
                        placeholder="e.g. Diwali, Republic Day..."
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                    <Grid size={{ xs: 12, sm: 4 }}>
                      <TextField
                        label="Description (optional)"
                        value={newDesc}
                        onChange={(e) => setNewDesc(e.target.value)}
                        fullWidth
                        size="small"
                        placeholder="Optional note"
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                    <Grid size={{ xs: 12, sm: 1 }}>
                      <Button
                        variant="contained"
                        color="secondary"
                        startIcon={<Add />}
                        onClick={() => addHolidayMutation.mutate()}
                        disabled={addHolidayMutation.isPending || !newDate || !newName.trim()}
                        fullWidth
                        sx={{ fontWeight: 700 }}
                      >
                        Add
                      </Button>
                    </Grid>
                  </Grid>
                </Paper>

                {hdLoading ? (
                  <Box sx={{ py: 3, textAlign: "center" }}><CircularProgress size={24} /></Box>
                ) : holidays.length === 0 ? (
                  <Alert severity="info">No holidays added for {holidayYear}. Use the form above to add holidays.</Alert>
                ) : (
                  <Table size="small">
                    <TableHead>
                      <TableRow sx={{ bgcolor: "#f3f0ff" }}>
                        <TableCell sx={{ fontWeight: 700 }}>#</TableCell>
                        <TableCell sx={{ fontWeight: 700 }}>Date</TableCell>
                        <TableCell sx={{ fontWeight: 700 }}>Day</TableCell>
                        <TableCell sx={{ fontWeight: 700 }}>Holiday Name</TableCell>
                        <TableCell sx={{ fontWeight: 700 }}>Description</TableCell>
                        <TableCell sx={{ fontWeight: 700 }} align="center">Action</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {holidays.map((h: any, idx: number) => {
                        const dt = new Date(h.holiday_date);
                        const dayName = dt.toLocaleDateString("en-IN", { weekday: "long" });
                        const dateStr = dt.toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
                        return (
                          <TableRow key={h.id} sx={{ "&:hover": { bgcolor: "#faf5ff" } }}>
                            <TableCell sx={{ color: "text.secondary" }}>{idx + 1}</TableCell>
                            <TableCell sx={{ fontWeight: 600 }}>{dateStr}</TableCell>
                            <TableCell>
                              <Chip
                                label={dayName}
                                size="small"
                                variant="outlined"
                                color={["Saturday", "Sunday"].includes(dayName) ? "warning" : "default"}
                              />
                            </TableCell>
                            <TableCell sx={{ fontWeight: 700 }}>{h.holiday_name}</TableCell>
                            <TableCell sx={{ color: "text.secondary", fontSize: "0.8rem" }}>{h.description || "—"}</TableCell>
                            <TableCell align="center">
                              <Tooltip title="Remove Holiday">
                                <IconButton
                                  size="small"
                                  color="error"
                                  onClick={() => {
                                    if (window.confirm(`Remove holiday "${h.holiday_name}"?`)) {
                                      deleteHolidayMutation.mutate(h.id);
                                    }
                                  }}
                                >
                                  <Delete fontSize="small" />
                                </IconButton>
                              </Tooltip>
                            </TableCell>
                          </TableRow>
                        );
                      })}
                    </TableBody>
                  </Table>
                )}
              </Box>
            )}

            {/* ── Save Button at bottom of settings tabs ── */}
            {activeTab !== 3 && (
              <Box sx={{ display: "flex", justifyContent: "flex-end", mt: 3, pt: 2, borderTop: "1px solid #e2e8f0" }}>
                <Button
                  variant="contained"
                  color="success"
                  startIcon={<Save />}
                  onClick={() => saveMutation.mutate()}
                  disabled={saveMutation.isPending}
                  size="large"
                  sx={{ fontWeight: 700, px: 4 }}
                >
                  {saveMutation.isPending ? "Saving..." : "Save Configuration"}
                </Button>
              </Box>
            )}
          </Box>
        </Paper>
      )}
    </Box>
  );
}
