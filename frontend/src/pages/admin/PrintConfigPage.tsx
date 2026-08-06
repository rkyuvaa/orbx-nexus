import { useState, useEffect } from "react";
import { Box, Button, Grid, TextField, Switch, FormControlLabel, MenuItem, Paper, Typography, Divider } from "@mui/material";
import Save from "@mui/icons-material/Save";
import Refresh from "@mui/icons-material/Refresh";
import PageHeader from "../../components/PageHeader";

interface PrintConfig {
  showLogo: boolean;
  
  voucherPaperSize: "A4" | "A5";
  inwardPaperSize: "A4" | "A5";
  outwardPaperSize: "A4" | "A5";
  billPaperSize: "A4" | "A5";
  reportPaperSize: "A4" | "A5";
  gridPaperSize: "A4" | "A5";

  voucherPrefix: string;
  voucherSuffix: string;
  voucherNextNo: number;
  voucherPadding: number;

  inwardPrefix: string;
  inwardSuffix: string;
  inwardNextNo: number;
  inwardPadding: number;

  outwardPrefix: string;
  outwardSuffix: string;
  outwardNextNo: number;
  outwardPadding: number;

  billPrefix: string;
  billSuffix: string;
  billNextNo: number;
  billPadding: number;

  voucherTitle: string;
  voucherTerms: string;
  inwardTitle: string;
  inwardTerms: string;
  outwardTitle: string;
  outwardTerms: string;
  billTitle: string;
  billTerms: string;

  adjustmentPrefix: string;
  adjustmentSuffix: string;
  adjustmentNextNo: number;
  adjustmentPadding: number;
}

const DEFAULTS: PrintConfig = {
  showLogo: true,
  
  voucherPaperSize: "A5",
  inwardPaperSize: "A4",
  outwardPaperSize: "A5",
  billPaperSize: "A4",
  reportPaperSize: "A4",
  gridPaperSize: "A4",

  voucherPrefix: "VCH/",
  voucherSuffix: "/26-27",
  voucherNextNo: 1,
  voucherPadding: 4,

  inwardPrefix: "INW/",
  inwardSuffix: "",
  inwardNextNo: 1,
  inwardPadding: 4,

  outwardPrefix: "OUT/",
  outwardSuffix: "",
  outwardNextNo: 1,
  outwardPadding: 4,

  billPrefix: "LBL/",
  billSuffix: "/26-27",
  billNextNo: 1,
  billPadding: 4,

  voucherTitle: "Voucher Receipt",
  voucherTerms: "1. Subject to local jurisdiction.\n2. This is a computer-generated voucher and requires no physical signature.",
  inwardTitle: "Inward Challan",
  inwardTerms: "1. Received goods are subject to count & quality checks.\n2. Report discrepancies within 24 hours.",
  outwardTitle: "Delivery Note",
  outwardTerms: "1. Goods once sold/delivered cannot be taken back.\n2. Subject to company terms of carriage.",
  billTitle: "Labour Bill Invoice",
  billTerms: "1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.",
  adjustmentPrefix: "ADJ/",
  adjustmentSuffix: "",
  adjustmentNextNo: 1,
  adjustmentPadding: 4,
};

export default function PrintConfigPage() {
  const [config, setConfig] = useState<PrintConfig>(DEFAULTS);

  useEffect(() => {
    const saved = localStorage.getItem("orbx_print_config");
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        if (parsed.outwardTitle === "Outward Challan") {
          parsed.outwardTitle = "Delivery Note";
          localStorage.setItem("orbx_print_config", JSON.stringify(parsed));
        }
        setConfig({ ...DEFAULTS, ...parsed });
      } catch (e) {
        setConfig(DEFAULTS);
      }
    }
  }, []);

  const handleSave = () => {
    localStorage.setItem("orbx_print_config", JSON.stringify(config));
    alert("Print & Document configurations saved successfully!");
  };

  const handleReset = () => {
    if (window.confirm("Are you sure you want to reset to default configurations?")) {
      setConfig(DEFAULTS);
      localStorage.setItem("orbx_print_config", JSON.stringify(DEFAULTS));
    }
  };

  // Helper to preview numbering format live
  const getPreview = (prefix: string, nextNo: number, padding: number, suffix: string) => {
    const padded = String(nextNo).padStart(padding || 0, "0");
    return `${prefix}${padded}${suffix}`;
  };

  return (
    <Box>
      <PageHeader
        title="Print Configurations"
        subtitle="Customize printed slips, invoices, document numbering formats, and paper layouts"
        breadcrumbs={[{ label: "Settings" }, { label: "Print Configurations" }]}
        actions={
          <>
            <Button variant="outlined" startIcon={<Refresh />} onClick={handleReset} size="small">Reset to Defaults</Button>
            <Button variant="contained" startIcon={<Save />} onClick={handleSave} size="small">Save Changes</Button>
          </>
        }
      />

      <Paper variant="outlined" sx={{ p: 3, borderRadius: "12px", mt: 1 }}>
        <Grid container spacing={3}>
          <Grid size={{ xs: 12 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: "#023020" }}>General Layout Settings</Typography>
            <FormControlLabel
              control={
                <Switch
                  checked={config.showLogo}
                  onChange={(e) => setConfig({ ...config, showLogo: e.target.checked })}
                  color="primary"
                />
              }
              label="Print Company Logo on Header"
            />
          </Grid>
          
          {/* VOUCHER FORMAT */}
          <Grid size={{ xs: 12 }} sx={{ mt: 2 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Vouchers configuration (Payment / Receipt / Contra / Journal / Purchase)</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Print Title"
              value={config.voucherTitle}
              onChange={(e) => setConfig({ ...config, voucherTitle: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Paper Size"
              value={config.voucherPaperSize}
              onChange={(e: any) => setConfig({ ...config, voucherPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Terms & Conditions / Footer Text"
              value={config.voucherTerms}
              onChange={(e) => setConfig({ ...config, voucherTerms: e.target.value })}
              fullWidth
              multiline
              rows={2}
              size="small"
            />
          </Grid>

          {/* Voucher Numbering */}
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Voucher Prefix"
              value={config.voucherPrefix}
              onChange={(e) => setConfig({ ...config, voucherPrefix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Next Number"
              type="number"
              value={config.voucherNextNo}
              onChange={(e) => setConfig({ ...config, voucherNextNo: parseInt(e.target.value) || 1 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Padding Digits"
              type="number"
              value={config.voucherPadding}
              onChange={(e) => setConfig({ ...config, voucherPadding: parseInt(e.target.value) || 0 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Voucher Suffix"
              value={config.voucherSuffix}
              onChange={(e) => setConfig({ ...config, voucherSuffix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }} sx={{ display: "flex", alignItems: "center" }}>
            <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary" }}>
              Preview: <span style={{ color: "#023020", fontFamily: "monospace" }}>{getPreview(config.voucherPrefix, config.voucherNextNo, config.voucherPadding, config.voucherSuffix)}</span>
            </Typography>
          </Grid>

          {/* INWARD FORMAT */}
          <Grid size={{ xs: 12 }} sx={{ mt: 3 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Inward Voucher configuration</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Print Title"
              value={config.inwardTitle}
              onChange={(e) => setConfig({ ...config, inwardTitle: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Paper Size"
              value={config.inwardPaperSize}
              onChange={(e: any) => setConfig({ ...config, inwardPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Terms & Conditions / Footer Text"
              value={config.inwardTerms}
              onChange={(e) => setConfig({ ...config, inwardTerms: e.target.value })}
              fullWidth
              multiline
              rows={2}
              size="small"
            />
          </Grid>

          {/* Inward Numbering */}
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Inward Prefix"
              value={config.inwardPrefix}
              onChange={(e) => setConfig({ ...config, inwardPrefix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Next Number"
              type="number"
              value={config.inwardNextNo}
              onChange={(e) => setConfig({ ...config, inwardNextNo: parseInt(e.target.value) || 1 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Padding Digits"
              type="number"
              value={config.inwardPadding}
              onChange={(e) => setConfig({ ...config, inwardPadding: parseInt(e.target.value) || 0 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Inward Suffix"
              value={config.inwardSuffix}
              onChange={(e) => setConfig({ ...config, inwardSuffix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }} sx={{ display: "flex", alignItems: "center" }}>
            <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary" }}>
              Preview: <span style={{ color: "#023020", fontFamily: "monospace" }}>{getPreview(config.inwardPrefix, config.inwardNextNo, config.inwardPadding, config.inwardSuffix)}</span>
            </Typography>
          </Grid>

          {/* OUTWARD FORMAT */}
          <Grid size={{ xs: 12 }} sx={{ mt: 3 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Outward Voucher configuration</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Print Title"
              value={config.outwardTitle}
              onChange={(e) => setConfig({ ...config, outwardTitle: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Paper Size"
              value={config.outwardPaperSize}
              onChange={(e: any) => setConfig({ ...config, outwardPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Terms & Conditions / Footer Text"
              value={config.outwardTerms}
              onChange={(e) => setConfig({ ...config, outwardTerms: e.target.value })}
              fullWidth
              multiline
              rows={2}
              size="small"
            />
          </Grid>

          {/* Outward Numbering */}
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Outward Prefix"
              value={config.outwardPrefix}
              onChange={(e) => setConfig({ ...config, outwardPrefix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Next Number"
              type="number"
              value={config.outwardNextNo}
              onChange={(e) => setConfig({ ...config, outwardNextNo: parseInt(e.target.value) || 1 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Padding Digits"
              type="number"
              value={config.outwardPadding}
              onChange={(e) => setConfig({ ...config, outwardPadding: parseInt(e.target.value) || 0 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Outward Suffix"
              value={config.outwardSuffix}
              onChange={(e) => setConfig({ ...config, outwardSuffix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }} sx={{ display: "flex", alignItems: "center" }}>
            <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary" }}>
              Preview: <span style={{ color: "#023020", fontFamily: "monospace" }}>{getPreview(config.outwardPrefix, config.outwardNextNo, config.outwardPadding, config.outwardSuffix)}</span>
            </Typography>
          </Grid>

          {/* LABOUR BILL FORMAT */}
          <Grid size={{ xs: 12 }} sx={{ mt: 3 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Labour Bill configuration</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Print Title"
              value={config.billTitle}
              onChange={(e) => setConfig({ ...config, billTitle: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Paper Size"
              value={config.billPaperSize}
              onChange={(e: any) => setConfig({ ...config, billPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 6 }}>
            <TextField
              label="Terms & Conditions / Footer Text"
              value={config.billTerms}
              onChange={(e) => setConfig({ ...config, billTerms: e.target.value })}
              fullWidth
              multiline
              rows={2}
              size="small"
            />
          </Grid>

          {/* Labour Bill Numbering */}
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Bill Prefix"
              value={config.billPrefix}
              onChange={(e) => setConfig({ ...config, billPrefix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              label="Next Number"
              type="number"
              value={config.billNextNo}
              onChange={(e) => setConfig({ ...config, billNextNo: parseInt(e.target.value) || 1 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Padding Digits"
              type="number"
              value={config.billPadding}
              onChange={(e) => setConfig({ ...config, billPadding: parseInt(e.target.value) || 0 })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField
              label="Bill Suffix"
              value={config.billSuffix}
              onChange={(e) => setConfig({ ...config, billSuffix: e.target.value })}
              fullWidth
              size="small"
            />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }} sx={{ display: "flex", alignItems: "center" }}>
            <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary" }}>
              Preview: <span style={{ color: "#023020", fontFamily: "monospace" }}>{getPreview(config.billPrefix, config.billNextNo, config.billPadding, config.billSuffix)}</span>
            </Typography>
          </Grid>
          <Grid size={{ xs: 12 }} sx={{ mt: 3 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Stock Adjustment Numbering</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField label="Adj. Prefix" value={config.adjustmentPrefix} onChange={(e) => setConfig({ ...config, adjustmentPrefix: e.target.value })} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField label="Next Number" type="number" value={config.adjustmentNextNo} onChange={(e) => setConfig({ ...config, adjustmentNextNo: parseInt(e.target.value) || 1 })} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField label="Padding Digits" type="number" value={config.adjustmentPadding} onChange={(e) => setConfig({ ...config, adjustmentPadding: parseInt(e.target.value) || 0 })} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }}>
            <TextField label="Adj. Suffix" value={config.adjustmentSuffix} onChange={(e) => setConfig({ ...config, adjustmentSuffix: e.target.value })} fullWidth size="small" />
          </Grid>
          <Grid size={{ xs: 12, sm: 2 }} sx={{ display: "flex", alignItems: "center" }}>
            <Typography variant="caption" sx={{ fontWeight: 600, color: "text.secondary" }}>
              Preview: <span style={{ color: "#023020", fontFamily: "monospace" }}>{getPreview(config.adjustmentPrefix, config.adjustmentNextNo, config.adjustmentPadding, config.adjustmentSuffix)}</span>
            </Typography>
          </Grid>
          <Grid size={{ xs: 12 }} sx={{ mt: 3 }}>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1, color: "#023020" }}>Report & Grid Print Settings</Typography>
            <Divider sx={{ mb: 2 }} />
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Report Paper Size"
              value={config.reportPaperSize}
              onChange={(e: any) => setConfig({ ...config, reportPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
          <Grid size={{ xs: 12, sm: 3 }}>
            <TextField
              select
              label="Grid Print Paper Size"
              value={config.gridPaperSize}
              onChange={(e: any) => setConfig({ ...config, gridPaperSize: e.target.value })}
              fullWidth
              size="small"
            >
              <MenuItem value="A4">A4 (Full Page)</MenuItem>
              <MenuItem value="A5">A5 (Half Page landscape)</MenuItem>
            </TextField>
          </Grid>
        </Grid>
      </Paper>
    </Box>
  );
}
