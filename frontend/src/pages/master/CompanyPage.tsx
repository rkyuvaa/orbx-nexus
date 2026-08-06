import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Grid, TextField, Typography, IconButton } from "@mui/material";
import Save from "@mui/icons-material/Save";
import Refresh from "@mui/icons-material/Refresh";
import PhotoCamera from "@mui/icons-material/PhotoCamera";
import Delete from "@mui/icons-material/Delete";
import { useForm } from "react-hook-form";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";

export default function CompanyPage() {
  const qc = useQueryClient();
  const [logo, setLogo] = useState<string | null>(null);

  const { data, isLoading } = useQuery({
    queryKey: ["company"],
    queryFn: async () => (await api.get("/company/")).data,
  });

  const { register, handleSubmit, reset } = useForm({ values: data || {} });

  useEffect(() => {
    // Retrieve logo from localStorage on load
    const savedLogo = localStorage.getItem("company_logo");
    if (savedLogo) {
      setLogo(savedLogo);
    }
  }, []);

  const saveMutation = useMutation({
    mutationFn: (d: any) => {
      const payload = { ...d };
      // Pydantic strict integer validation fails on empty strings or strings from text inputs
      if (payload.financial_year_start_month === "") {
        payload.financial_year_start_month = null;
      } else if (payload.financial_year_start_month) {
        payload.financial_year_start_month = Number(payload.financial_year_start_month);
      }
      return api.put("/company/", payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["company"] });
      // Persistent logo save
      if (logo) {
        localStorage.setItem("company_logo", logo);
      } else {
        localStorage.removeItem("company_logo");
      }
      alert("Company info saved successfully!");
    },
    onError: (err: any) => {
      console.error(err);
      alert("Failed to save company info. Please check your inputs.");
    }
  });

  const handleLogoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setLogo(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <Box>
      <PageHeader title="Company Information" subtitle="Manage company master data" breadcrumbs={[{ label: "Master" }, { label: "Company Info" }]}
        actions={<Button variant="outlined" startIcon={<Refresh />} onClick={() => { reset(data); setLogo(localStorage.getItem("company_logo")); }} size="small">Reset</Button>}
      />
      <Box component="form" onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
        <Grid container spacing={2.5}>
          {/* Logo Upload Row */}
          <Grid size={{ xs: 12 }}>
            <Box sx={{ display: "flex", alignItems: "center", gap: 3, p: 2, border: "1px dashed", borderColor: "divider", borderRadius: "12px", mb: 1, bgcolor: "background.paper" }}>
              <Box sx={{ position: "relative" }}>
                {logo ? (
                  <Box
                    component="img"
                    src={logo}
                    sx={{ width: 100, height: 100, borderRadius: "8px", objectFit: "contain", border: "1px solid", borderColor: "divider", p: 0.5 }}
                  />
                ) : (
                  <Box
                    sx={{
                      width: 100,
                      height: 100,
                      borderRadius: "8px",
                      bgcolor: "grey.100",
                      display: "flex",
                      flexDirection: "column",
                      alignItems: "center",
                      justifyContent: "center",
                      border: "1px solid",
                      borderColor: "divider",
                    }}
                  >
                    <Typography sx={{ fontSize: "11px", color: "text.secondary", fontWeight: 600 }}>No Logo</Typography>
                  </Box>
                )}
                {logo && (
                  <IconButton
                    size="small"
                    onClick={() => setLogo(null)}
                    sx={{
                      position: "absolute",
                      top: -10,
                      right: -10,
                      bgcolor: "error.main",
                      color: "white",
                      p: 0.25,
                      "&:hover": { bgcolor: "error.dark" }
                    }}
                  >
                    <Delete sx={{ fontSize: 14 }} />
                  </IconButton>
                )}
              </Box>
              <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
                <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>Company Brand Logo</Typography>
                <Typography variant="caption" color="text.secondary">
                  This logo will be printed on all invoices, bills, and vouchers. Recommended size: 200x200px (PNG/JPG).
                </Typography>
                <Button
                  variant="outlined"
                  component="label"
                  size="small"
                  startIcon={<PhotoCamera />}
                  sx={{ textTransform: "none", alignSelf: "flex-start", borderRadius: "8px" }}
                >
                  Upload Logo
                  <input
                    type="file"
                    accept="image/*"
                    hidden
                    onChange={handleLogoChange}
                  />
                </Button>
              </Box>
            </Box>
          </Grid>

          {[
            { field: "name", label: "Company Name *", xs: 8 },
            { field: "gstin", label: "GSTIN", xs: 4 },
            { field: "address", label: "Address", xs: 12 },
            { field: "city", label: "City", xs: 4 },
            { field: "state", label: "State", xs: 4 },
            { field: "pincode", label: "Pincode", xs: 4 },
            { field: "phone", label: "Phone", xs: 4 },
            { field: "mobile", label: "Mobile", xs: 4 },
            { field: "email", label: "Email", xs: 4 },
            { field: "pan", label: "PAN", xs: 4 },
            { field: "tan", label: "TAN", xs: 4 },
            { field: "financial_year_start_month", label: "FY Start Month (1-12)", xs: 4, type: "number" },
          ].map(({ field, label, xs, type }) => (
            <Grid size={{ xs: xs }} key={field}>
              <TextField {...register(field as any)} label={label} fullWidth type={type || "text"} />
            </Grid>
          ))}
          <Grid size={{ xs: 12 }}>
            <Button type="submit" variant="contained" startIcon={<Save />} size="large" disabled={saveMutation.isPending}>
              {saveMutation.isPending ? "Saving..." : "Save Company Info"}
            </Button>
          </Grid>
        </Grid>
      </Box>
    </Box>
  );
}
