import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Chip, Card, CardContent, Grid, Typography, Tooltip } from "@mui/material";
import Lock from "@mui/icons-material/Lock";
import Check from "@mui/icons-material/Check";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import { alpha } from "@mui/material/styles";

const ACCENT = "#00a86b";

export default function FinancialYearsPage() {
  const qc = useQueryClient();
  const { data: years = [], isLoading } = useQuery({
    queryKey: ["financial-years"],
    queryFn: async () => (await api.get("/financial-years/")).data,
  });

  const setActiveMutation = useMutation({
    mutationFn: (id: number) => api.patch(`/financial-years/${id}/set-active`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["financial-years"] }),
  });
  const lockMutation = useMutation({
    mutationFn: (id: number) => api.patch(`/financial-years/${id}/lock`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ["financial-years"] }),
  });

  return (
    <Box>
      <PageHeader
        title="Financial Years"
        subtitle="Manage financial year schemas"
        breadcrumbs={[{ label: "Administrator" }, { label: "Financial Years" }]}
      />
      <Grid container spacing={2}>
        {years.map((fy: any) => (
          <Grid key={fy.id} size={{ xs: 12, sm: 6, md: 4 }}>
            <Card sx={{ position: "relative", border: fy.is_active ? `2px solid ${ACCENT}` : undefined }}>
              {fy.is_active && (
                <Box sx={{ position: "absolute", top: 12, right: 12 }}>
                  <Chip label="ACTIVE" size="small" sx={{ bgcolor: alpha(ACCENT, 0.15), color: ACCENT, fontWeight: 700 }} />
                </Box>
              )}
              <CardContent sx={{ p: 2.5 }}>
                <Typography variant="h6" sx={{ fontWeight: 700 }}>{fy.label}</Typography>
                <Typography sx={{ mb: 1, display: "block" }} variant="caption" color="text.secondary">{fy.schema_name}</Typography>
                <Typography variant="body2" color="text.secondary" sx={{ fontSize: "0.75rem" }}>
                  {fy.start_date} → {fy.end_date}
                </Typography>
                {fy.is_locked && (
                  <Chip icon={<Lock sx={{ fontSize: "14px !important" }} />} label="Locked" size="small" color="error" sx={{ mt: 1 }} />
                )}
                <Box sx={{ mt: 2, display: "flex", gap: 1, flexWrap: "wrap" }}>
                  {!fy.is_active && !fy.is_locked && (
                    <Button size="small" variant="outlined" startIcon={<Check />}
                      onClick={() => setActiveMutation.mutate(fy.id)} disabled={setActiveMutation.isPending}>
                      Set Active
                    </Button>
                  )}
                  {!fy.is_locked && (
                    <Button size="small" variant="outlined" color="error" startIcon={<Lock />}
                      onClick={() => lockMutation.mutate(fy.id)} disabled={lockMutation.isPending}>
                      Lock Year
                    </Button>
                  )}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}
