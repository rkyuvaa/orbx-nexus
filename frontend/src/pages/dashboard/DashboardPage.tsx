import { useQuery } from "@tanstack/react-query";
import {
  Box, Grid, Card, CardContent, Typography, Skeleton, Chip, useTheme,
} from "@mui/material";
import {
  ReceiptLong, PendingActions, Inventory2, Factory, TrendingUp, TrendingDown,
} from "@mui/icons-material";
import {
  ResponsiveContainer, XAxis, YAxis,
  Tooltip, BarChart, Bar, CartesianGrid, Legend,
} from "recharts";
import { alpha } from "@mui/material/styles";
import api from "../../api/client";
import { useAuthStore } from "../../store";
import { formatAmount } from "../../utils/format";

const ACCENT = "#00a86b";

interface DashboardData {
  today_vouchers: number;
  pending_bills: number;
  pending_inward: number;
  today_production: number;
  process_chart: { day: string; inward_qty: number; outward_qty: number; inward_weight: number; outward_weight: number }[];
}

function KPICard({ title, value, subtitle, icon, trend, color = ACCENT, loading }: {
  title: string; value: string | number; subtitle?: string;
  icon: React.ReactNode; trend?: "up" | "down"; color?: string; loading?: boolean;
}) {
  return (
    <Card sx={{ position: "relative", overflow: "hidden",
      "&::before": { content: '""', position: "absolute", top: 0, left: 0, right: 0, height: 3,
        background: `linear-gradient(90deg, ${color}, ${alpha(color, 0)})` } }}>
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
            <Typography variant="h4" sx={{ fontWeight: 700, lineHeight: 1, mb: 0.5 }}>{value}</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ fontSize: "0.8rem" }}>{title}</Typography>
            {subtitle && <Typography variant="caption" color="text.disabled" sx={{ mt: 0.5, display: "block" }}>{subtitle}</Typography>}
          </>
        )}
      </CardContent>
    </Card>
  );
}

export default function DashboardPage() {
  const theme = useTheme();
  const isDark = theme.palette.mode === "dark";
  const { activeFY } = useAuthStore();

  const { data, isLoading } = useQuery<DashboardData>({
    queryKey: ["dashboard", activeFY],
    queryFn: async () => (await api.get(`/reports/dashboard-summary?fy=${activeFY}`)).data,
    refetchInterval: 60_000,
  });

  const fyLabel = activeFY.replace("_", "-");

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

  return (
    <Box sx={{ pb: 3 }}>
      {/* ── KPI Metrics Grid ── */}
      <Grid container spacing={2.5} sx={{ mb: 3 }}>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <KPICard
            title="Today's Vouchers"
            value={data?.today_vouchers ?? 0}
            subtitle="Entries posted today"
            icon={<ReceiptLong />}
            trend="up"
            color={isDark ? "#4ade80" : "#0f5132"}
            loading={isLoading}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <KPICard
            title="Pending Bills"
            value={`₹${((data?.pending_bills ?? 0) / 1000).toFixed(1)}K`}
            subtitle="Unpaid labour bills"
            icon={<PendingActions />}
            trend="down"
            color="#ed6c02"
            loading={isLoading}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <KPICard
            title="Pending Inward"
            value={data?.pending_inward ?? 0}
            subtitle="In-progress inward batches"
            icon={<Inventory2 />}
            color="#0288d1"
            loading={isLoading}
          />
        </Grid>
        <Grid size={{ xs: 12, sm: 6, lg: 3 }}>
          <KPICard
            title="Today's Production"
            value={`${(data?.today_production ?? 0).toFixed(2)} units`}
            subtitle="Stock inward received today"
            icon={<Factory />}
            trend="up"
            color="#7c4dff"
            loading={isLoading}
          />
        </Grid>
      </Grid>

      {/* ── Daily Process Flow (Inward vs Outward) ── */}
      <Grid container spacing={2.5} sx={{ mb: 3 }}>
        <Grid size={{ xs: 12, lg: 8 }}>
          <Card variant="outlined" sx={{ borderRadius: 2 }}>
            <CardContent sx={{ p: 2.5 }}>
              <Box sx={{ display: "flex", justifyContent: "space-between", alignItems: "center", mb: 3 }}>
                <Box>
                  <Typography variant="h6" sx={{ fontWeight: 700 }} color="text.primary">
                    Daily Process Flow (Inward vs Outward Qty)
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Daily Stock Inward Quantity vs Outward Quantity
                  </Typography>
                </Box>
                <Chip
                  label={`FY ${fyLabel}`}
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
                <ResponsiveContainer width="100%" height={270}>
                  <BarChart data={data?.process_chart || []} margin={{ top: 5, right: 10, left: 0, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke={isDark ? "rgba(255,255,255,0.08)" : "#e2e8f0"} />
                    <XAxis dataKey="day" tick={{ fontSize: 11, fill: isDark ? "#94a3b8" : "#64748b" }} />
                    <YAxis tick={{ fontSize: 11, fill: isDark ? "#94a3b8" : "#64748b" }} />
                    <Tooltip {...ttStyle} formatter={(v: number) => [v.toLocaleString(), ""]} />
                    <Legend wrapperStyle={{ fontSize: "0.75rem" }} />
                    <Bar dataKey="inward_qty" name="Inward Qty" fill={isDark ? "#4ade80" : "#0f5132"} radius={[4, 4, 0, 0]} maxBarSize={24} />
                    <Bar dataKey="outward_qty" name="Outward Qty" fill={isDark ? "#38bdf8" : "#0288d1"} radius={[4, 4, 0, 0]} maxBarSize={24} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </CardContent>
          </Card>
        </Grid>

        <Grid size={{ xs: 12, lg: 4 }}>
          <Card variant="outlined" sx={{ height: "100%", borderRadius: 2 }}>
            <CardContent sx={{ p: 2.5 }}>
              <Typography variant="h6" sx={{ fontWeight: 700, mb: 0.5 }}>
                Daily Weight Flow
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2.5 }}>
                Inward Weight vs Outward Weight (Kgs)
              </Typography>
              {isLoading ? (
                <Skeleton variant="rectangular" height={240} sx={{ borderRadius: 2 }} />
              ) : (
                <ResponsiveContainer width="100%" height={240}>
                  <BarChart data={(data?.process_chart || []).slice(-10)} margin={{ top: 5, right: 5, left: 0, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke={isDark ? "rgba(255,255,255,0.08)" : "#e2e8f0"} />
                    <XAxis dataKey="day" tick={{ fontSize: 10, fill: isDark ? "#94a3b8" : "#64748b" }} />
                    <YAxis tick={{ fontSize: 10, fill: isDark ? "#94a3b8" : "#64748b" }} />
                    <Tooltip {...ttStyle} formatter={(v: number) => [`${v.toLocaleString()} kg`, ""]} />
                    <Bar dataKey="inward_weight" name="Inward Wt" fill={isDark ? "#4ade80" : "#0f5132"} radius={[4, 4, 0, 0]} maxBarSize={22} />
                    <Bar dataKey="outward_weight" name="Outward Wt" fill={isDark ? "#38bdf8" : "#0288d1"} radius={[4, 4, 0, 0]} maxBarSize={22} />
                  </BarChart>
                </ResponsiveContainer>
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
              { label: "Labour Bill", path: "/labour-bill", color: "#ed6c02" },
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
    </Box>
  );
}
