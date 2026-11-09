import { useQuery } from "@tanstack/react-query";
import {
  Box, Grid, Card, CardContent, Typography, Skeleton, Chip, useTheme,
} from "@mui/material";
import ReceiptLong from "@mui/icons-material/ReceiptLong";
import Inventory2 from "@mui/icons-material/Inventory2";
import Factory from "@mui/icons-material/Factory";
import People from "@mui/icons-material/People";
import TrendingUp from "@mui/icons-material/TrendingUp";
import TrendingDown from "@mui/icons-material/TrendingDown";
import {
  motion, AnimatePresence,
} from "framer-motion";

const MotionBox = motion(Box);
const MotionSpan = motion("span");
import {
  ResponsiveContainer, XAxis, YAxis, Tooltip, BarChart, Bar, CartesianGrid, Legend,
} from "recharts";
import { alpha } from "@mui/material/styles";
import api from "../../api/client";
import { useAuthStore } from "../../store";

const ACCENT = "#00a86b";

interface DashboardWeeklyData {
  week_start: string;
  week_end: string;
  inward_qty: number;
  inward_weight: number;
  outward_qty: number;
  outward_weight: number;
  purchase_total: number;
  contractor_performance: {
    ledger_id: number | null;
    contractor_name: string;
    bill_count: number;
    total_amount: number;
  }[];
  weekly_trend: {
    week_offset: number;
    label: string;
    inward_qty: number;
    inward_weight: number;
    outward_qty: number;
    outward_weight: number;
    purchase_total: number;
  }[];
}

interface WeeklyKPICardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: React.ReactNode;
  trend?: "up" | "down";
  color?: string;
  loading?: boolean;
}

function WeeklyKPICard({ title, value, subtitle, icon, trend, color = ACCENT, loading }: WeeklyKPICardProps) {
  return (
    <MotionBox
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      sx={{ position: "relative", overflow: "hidden",
        "&::before": { content: '""', position: "absolute", top: 0, left: 0, right: 0, height: 3,
          background: `linear-gradient(90deg, ${color}, ${alpha(color, 0)})` } }}
    >
      <Card sx={{ height: "100%", borderRadius: 2, p: 0 }}>
        <CardContent sx={{ p: 2.5 }}>
          <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", mb: 2 }}>
            <Box sx={{ width: 44, height: 44, borderRadius: 2, bgcolor: alpha(color, 0.12),
              display: "flex", alignItems: "center", justifyContent: "center", color }}>
              {icon}
            </Box>
            {trend && (
              <Chip
                icon={trend === "up" ? <TrendingUp sx={{ fontSize: "14px !important" }} /> : <TrendingDown sx={{ fontSize: "14px !important" }} />}
                label={trend === "up" ? "Up" : "Down"} size="small"
                sx={{ bgcolor: alpha(trend === "up" ? ACCENT : "#ff5252", 0.12), color: trend === "up" ? ACCENT : "#ff5252",
                  fontSize: "0.65rem", height: 22, "& .MuiChip-label": { px: 0.8 } }}
              />
            )}
          </Box>
          {loading ? (
            <><Skeleton width="60%" height={36} /><Skeleton width="80%" height={20} sx={{ mt: 0.5 }} /></>
          ) : (
            <>
              <MotionSpan
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.2 }}
                style={{ display: "block", fontWeight: 700, lineHeight: 1, marginBottom: "8px", fontSize: "1.75rem" }}
              >
                {value}
              </MotionSpan>
              <Typography variant="body2" color="text.secondary" sx={{ fontSize: "0.8rem", mt: 0.5 }}>{title}</Typography>
              {subtitle && <Typography variant="caption" color="text.disabled" sx={{ mt: 0.5, display: "block" }}>{subtitle}</Typography>}
            </>
          )}
        </CardContent>
      </Card>
    </MotionBox>
  );
}

export default function DashboardPage() {
  const theme = useTheme();
  const isDark = theme.palette.mode === "dark";
  const { activeFY } = useAuthStore();

  const { data, isLoading } = useQuery<DashboardWeeklyData>({
    queryKey: ["dashboard-weekly", activeFY],
    queryFn: async () => (await api.get(`/reports/dashboard-weekly?fy=${activeFY}`)).data,
    refetchOnWindowFocus: false,
    refetchOnReconnect: false,
    staleTime: Infinity,
  });

  const weekLabel = data ? `${data.week_start} to ${data.week_end}` : "";

  const ttStyle = {
    contentStyle: {
      backgroundColor: isDark ? "#1e293b" : "#ffffff",
      border: `1px solid ${isDark ? "#334155" : "#cbd5e1"}`,
      borderRadius: 8,
      fontSize: "0.75rem",
      color: isDark ? "#f8fafc" : "#0f172a",
    },
    labelStyle: { color: isDark ? "#94a3b8" : "#64748b" },
  };

  const trendData = data?.weekly_trend || [];
  const contractorData = data?.contractor_performance || [];

  return (
    <Box sx={{ pb: 3 }}>
      <AnimatePresence>
        {!isLoading && (
          <>
            {/* ── Weekly KPI Metrics Grid ── */}
            <Grid container spacing={2.5} sx={{ mb: 3 }}>
              <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
                <WeeklyKPICard
                  title="Week's Inward Weight"
                  value={(data?.inward_weight ?? 0).toLocaleString(undefined, { maximumFractionDigits: 2 })}
                  subtitle="Total inward weight this week"
                  icon={<ReceiptLong />}
                  trend="up"
                  color={isDark ? "#4ade80" : "#0f5132"}
                  loading={isLoading}
                />
              </Grid>
              <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
                <WeeklyKPICard
                  title="Week's Outward Weight"
                  value={(data?.outward_weight ?? 0).toLocaleString(undefined, { maximumFractionDigits: 2 })}
                  subtitle="Total outward weight this week"
                  icon={<Inventory2 />}
                  trend="down"
                  color="#ed6c02"
                  loading={isLoading}
                />
              </Grid>
              <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
                <WeeklyKPICard
                  title="Purchases (Week)"
                  value={`₹${(data?.purchase_total ?? 0).toLocaleString(undefined, { maximumFractionDigits: 0 })}`}
                  subtitle="Job work bills raised this week"
                  icon={<Factory />}
                  trend="up"
                  color="#7c4dff"
                  loading={isLoading}
                />
              </Grid>
              <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
                <WeeklyKPICard
                  title="Top Contractor"
                  value={contractorData[0]?.contractor_name || "—"}
                  subtitle={`${contractorData[0]?.bill_count ?? 0} bill(s) · ₹${(contractorData[0]?.total_amount ?? 0).toLocaleString()}`}
                  icon={<People />}
                  color="#0288d1"
                  loading={isLoading}
                />
              </Grid>
            </Grid>

            {/* ── Weekly Trend Chart (Last 4 Weeks) ── */}
            <Grid container spacing={2.5} sx={{ mb: 3 }}>
              <Grid size={{ xs: 12, lg: 8 }}>
                <Card variant="outlined" sx={{ borderRadius: 2 }}>
                  <CardContent sx={{ p: 2.5 }}>
                    <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 3 }}>
                      <Box>
                        <Typography variant="h6" sx={{ fontWeight: 700 }} color="text.primary">
                          Weekly Trend (Last 4 Weeks)
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          Inward Qty vs Outward Qty vs Purchases
                        </Typography>
                      </Box>
                      <Chip
                        label={`FY ${activeFY.replace("_", "-")}`}
                        size="small"
                        sx={{
                          bgcolor: isDark ? "rgba(74, 222, 128, 0.15)" : "#f0fdf4",
                          color: isDark ? "#4ade80" : "#0f5132",
                          fontWeight: 700,
                        }}
                      />
                    </Box>
                    {isLoading ? (
                      <Skeleton variant="rectangular" height={270} sx={{ borderRadius: 2 }} />
                    ) : (
                      <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ duration: 0.5 }}
                      >
                        <ResponsiveContainer width="100%" height={270}>
                          <BarChart data={trendData} margin={{ top: 5, right: 10, left: 0, bottom: 5 }}>
                            <CartesianGrid strokeDasharray="3 3" stroke={isDark ? "rgba(255,255,255,0.08)" : "#e2e8f0"} />
                            <XAxis dataKey="label" tick={{ fontSize: 11, fill: isDark ? "#94a3b8" : "#64748b" }} />
                            <YAxis tick={{ fontSize: 11, fill: isDark ? "#94a3b8" : "#64748b" }} />
                            <Tooltip {...ttStyle} formatter={(v: number) => [v.toLocaleString(), ""]} />
                            <Legend wrapperStyle={{ fontSize: "0.75rem" }} />
                            <Bar dataKey="inward_qty" name="Inward Qty" fill={isDark ? "#4ade80" : "#0f5132"} radius={[4, 4, 0, 0]} maxBarSize={24} />
                            <Bar dataKey="outward_qty" name="Outward Qty" fill={isDark ? "#38bdf8" : "#0288d1"} radius={[4, 4, 0, 0]} maxBarSize={24} />
                          </BarChart>
                        </ResponsiveContainer>
                      </motion.div>
                    )}
                  </CardContent>
                </Card>
              </Grid>

              <Grid size={{ xs: 12, lg: 4 }}>
                <Card variant="outlined" sx={{ height: "100%", borderRadius: 2 }}>
                  <CardContent sx={{ p: 2.5 }}>
                    <Typography variant="h6" sx={{ fontWeight: 700, mb: 0.5 }}>
                      Contractor Performance
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2.5 }}>
                      Top contractors by job work amount this week
                    </Typography>
                    {isLoading ? (
                      <Skeleton variant="rectangular" height={240} sx={{ borderRadius: 2 }} />
                    ) : (
                      <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.4 }}
                      >
                        {contractorData.length === 0 ? (
                          <Typography variant="body2" color="text.secondary" sx={{ textAlign: "center", py: 2 }}>
                            No contractor bills this week
                          </Typography>
                        ) : (
                          contractorData.map((c, idx) => (
                            <MotionBox
                              key={c.ledger_id ?? idx}
                              initial={{ opacity: 0, x: -10 }}
                              animate={{ opacity: 1, x: 0 }}
                              transition={{ duration: 0.3, delay: idx * 0.1 }}
                              sx={{ mb: 2, pb: 2, borderBottom: "1px solid", borderColor: "divider", last: { mb: 0, pb: 0, borderBottom: "none" } }}
                            >
                              <Box sx={{ display: "flex", justifyContent: "space-between", mb: 0.5 }}>
                                <Typography variant="body2" sx={{ fontWeight: 600, color: "text.primary", fontSize: "0.9rem" }}>
                                  {c.contractor_name}
                                </Typography>
                                <Typography variant="body2" sx={{ fontWeight: 700, fontSize: "0.9rem", color: "text.primary" }}>
                                  ₹{c.total_amount.toLocaleString(undefined, { maximumFractionDigits: 0 })}
                                </Typography>
                              </Box>
                              <Box sx={{ height: 6, width: "100%", bgcolor: alpha("#e2e8f0", 0.5), borderRadius: 3, overflow: "hidden" }}>
                                <Box
                                  component="div"
                                  sx={{ height: "100%", bgGradient: `linear-gradient(to right, ${isDark ? "#4ade80" : "#0f5132"}, ${isDark ? "#38bdf8" : "#0288d1"})`,
                                    width: `${Math.min((c.total_amount / Math.max(...contractorData.map(x => x.total_amount), 1)) * 100, 100)}%`,
                                    borderRadius: 3, transition: "width 0.5s ease-in-out" }}
                                />
                              </Box>
                              <Typography variant="caption" color="text.disabled" sx={{ mt: 0.5, fontSize: "0.7rem" }}>
                                {c.bill_count} bill(s)
                              </Typography>
                            </MotionBox>
                          ))
                        )}
                      </motion.div>
                    )}
                  </CardContent>
                </Card>
              </Grid>
            </Grid>

            {/* ── Quick Navigation Shortcuts ── */}
            <Card variant="outlined" sx={{ borderRadius: 2 }}>
              <CardContent sx={{ p: 2.5 }}>
                <Typography variant="h6" sx={{ fontWeight: 700, mb: 2 }}>
                  Quick Operations
                </Typography>
                <Grid container spacing={2}>
                  {[
                    { label: "Inward Voucher", path: "/process-voucher/inward", color: isDark ? "#4ade80" : "#0f5132" },
                    { label: "Outward Voucher", path: "/process-voucher/outward", color: isDark ? "#38bdf8" : "#0288d1" },
                    { label: "Job Work Bill", path: "/billing/job-work-bill", color: "#ed6c02" },
                    { label: "Payment Voucher", path: "/vouchers/payment", color: "#7c4dff" },
                    { label: "Receipt Voucher", path: "/vouchers/receipt", color: "#2e7d32" },
                    { label: "Stock in Hand", path: "/reports/stock-in-hand", color: "#1976d2" },
                    { label: "Day Book", path: "/reports/day-book", color: "#d32f2f" },
                    { label: "Pending Bills", path: "/reports/pending-bills", color: "#ed6c02" },
                  ].map((item) => (
                    <Grid size={{ xs: 6, sm: 4, md: 3, lg: 1.5 }} key={item.label}>
                      <Box
                        component="a"
                        href={item.path}
                        sx={{
                          display: "flex",
                          flexDirection: "column",
                          alignItems: "center",
                          p: 2,
                          borderRadius: 2,
                          border: "1px solid",
                          borderColor: "divider",
                          bgcolor: "background.paper",
                          textAlign: "center",
                          textDecoration: "none",
                          cursor: "pointer",
                          transition: "all 0.2s ease-in-out",
                          "&:hover": {
                            borderColor: item.color,
                            bgcolor: alpha(item.color, isDark ? 0.12 : 0.04),
                            transform: "translateY(-3px)",
                            boxShadow: `0 4px 12px ${alpha(item.color, isDark ? 0.3 : 0.15)}`,
                          },
                        }}
                      >
                        <Box sx={{ width: 10, height: 10, borderRadius: "50%", bgcolor: item.color, mb: 1 }} />
                        <Typography variant="body2" sx={{ fontSize: "0.8rem", fontWeight: 600, color: "text.primary" }}>
                          {item.label}
                        </Typography>
                      </Box>
                    </Grid>
                  ))}
                </Grid>
              </CardContent>
            </Card>
          </>
        )}
      </AnimatePresence>
    </Box>
  );
}
