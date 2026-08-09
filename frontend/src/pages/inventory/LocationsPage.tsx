import { useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  Box, Button, Dialog, DialogTitle, DialogContent, DialogActions,
  TextField, Grid, IconButton, Tooltip, MenuItem, Tabs, Tab,
  Typography, Paper, Chip
} from "@mui/material";
import Edit from "@mui/icons-material/Edit";
import Delete from "@mui/icons-material/Delete";
import SwapHoriz from "@mui/icons-material/SwapHoriz";
import RemoveCircle from "@mui/icons-material/RemoveCircle";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";
import { formatQty } from "../../utils/format";

const today = new Date().toISOString().split("T")[0];

export default function LocationsPage() {
  const [tabValue, setTabValue] = useState(0);
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();

  // Location Dialog state
  const [locOpen, setLocOpen] = useState(false);
  const [editingLoc, setEditingLoc] = useState<any>(null);

  // Movement Dialog state
  const [moveOpen, setMoveOpen] = useState(false);
  const [moveType, setMoveType] = useState<"Transfer" | "Consumption">("Transfer");

  // Queries
  const { data: locations = [], isLoading: isLocsLoading, refetch: refetchLocs } = useQuery({
    queryKey: ["locations"],
    queryFn: async () => (await api.get("/stock/locations")).data,
  });

  const { data: processes = [] } = useQuery({
    queryKey: ["processes"],
    queryFn: async () => (await api.get("/products/processes/all")).data,
  });

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { data: locationBalances = [], isLoading: isBalancesLoading, refetch: refetchBalances } = useQuery({
    queryKey: ["locations-balances", activeFY],
    queryFn: async () => (await api.get(`/stock/locations/balances?fy=${activeFY}`)).data,
  });

  const { data: movements = [], isLoading: isMovementsLoading, refetch: refetchMovements } = useQuery({
    queryKey: ["location-movements", activeFY],
    queryFn: async () =>
      (await api.get(`/stock/inventory/movements?fy=${activeFY}`)).data.filter(
        (m: any) => m.movement_type === "Transfer" || m.movement_type === "Consumption"
      ),
  });

  // Shift filters for Consumption Report
  const [p1Id, setP1Id] = useState<string>("");
  const [p1From, setP1From] = useState<string>(today);
  const [p1To, setP1To] = useState<string>(today);
  const [p2Id, setP2Id] = useState<string>("");
  const [p2From, setP2From] = useState<string>(today);
  const [p2To, setP2To] = useState<string>(today);

  const { data: contractors = [] } = useQuery({
    queryKey: ["ledgers-contractors"],
    queryFn: async () => (await api.get("/ledgers/?ledger_type=Contractor")).data,
  });

  const { data: consumptionReport = [], isLoading: isConsLoading, refetch: refetchCons } = useQuery({
    queryKey: ["consumption-report", activeFY, p1Id, p1From, p1To, p2Id, p2From, p2To],
    queryFn: async () => {
      const params: any = { fy: activeFY };
      if (p1Id) {
        params.p1_id = p1Id;
        params.p1_from = p1From;
        params.p1_to = p1To;
      }
      if (p2Id) {
        params.p2_id = p2Id;
        params.p2_from = p2From;
        params.p2_to = p2To;
      }
      if (!p1Id && !p2Id) {
        return [];
      }
      return (await api.get("/stock/locations/consumption-report", { params })).data;
    },
  });

  // Mutate Locations
  const saveLocMutation = useMutation({
    mutationFn: (data: any) =>
      editingLoc
        ? api.put(`/stock/locations/${editingLoc.id}`, data)
        : api.post("/stock/locations", data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["locations"] });
      setLocOpen(false);
    },
  });

  const deleteLocMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/locations/${id}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["locations"] });
    },
  });

  // Mutate Movements
  const saveMoveMutation = useMutation({
    mutationFn: (data: any) => {
      const isTransfer = moveType === "Transfer";
      const payload = {
        movement_no: data.movement_no,
        movement_date: data.movement_date,
        movement_type: moveType,
        stock_item_id: Number(data.stock_item_id),
        quantity: Number(data.quantity),
        rate: 0,
        amount: 0,
        narration: data.narration,
        location_id: isTransfer ? (data.location_id ? Number(data.location_id) : null) : Number(data.location_id),
        to_location_id: isTransfer ? Number(data.to_location_id) : null,
      };
      return api.post(`/stock/inventory/movements?fy=${activeFY}`, payload);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["location-movements"] });
      qc.invalidateQueries({ queryKey: ["locations-balances"] });
      qc.invalidateQueries({ queryKey: ["process-consumption"] });
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
      setMoveOpen(false);
    },
  });

  const deleteMoveMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/stock/inventory/movements/${id}?fy=${activeFY}`),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["location-movements"] });
      qc.invalidateQueries({ queryKey: ["locations-balances"] });
      qc.invalidateQueries({ queryKey: ["process-consumption"] });
      qc.invalidateQueries({ queryKey: ["stock-items-balance"] });
    },
  });

  // Location Form
  const { register: regLoc, handleSubmit: handleSubLoc, reset: resetLoc, control: controlLoc } = useForm();
  // Movement Form
  const { register: regMove, handleSubmit: handleSubMove, reset: resetMove, control: controlMove, watch: watchMove, formState: { errors } } = useForm();

  // Balance mapping for quick lookup: [location_id_or_null][stock_item_id] -> balance_qty
  const balanceLookupMap = useMemo(() => {
    const map: Record<string, number> = {};
    locationBalances.forEach((b: any) => {
      const locKey = b.location_id === null ? "main" : String(b.location_id);
      map[`${locKey}_${b.stock_item_id}`] = Number(b.balance_qty || 0);
    });
    return map;
  }, [locationBalances]);

  // Selected values for validation in Transfer/Consumption dialog
  const selectedSrcLoc = watchMove("location_id");
  const selectedMoveItem = watchMove("stock_item_id");
  const availableQty = useMemo(() => {
    if (!selectedMoveItem) return 0;
    const locKey = selectedSrcLoc ? String(selectedSrcLoc) : "main";
    return balanceLookupMap[`${locKey}_${selectedMoveItem}`] ?? 0;
  }, [selectedMoveItem, selectedSrcLoc, balanceLookupMap]);

  // Grids Column Definitions
  const locationColDefs: ColDef[] = [
    { field: "name", headerName: "Location Name", flex: 1, minWidth: 200 },
    { field: "code", headerName: "Code", width: 150 },
    { field: "process_name", headerName: "Associated Process", flex: 1, minWidth: 200, valueFormatter: (p) => p.value || "None (General Store)" },
    {
      headerName: "Actions",
      width: 120,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <Box sx={{ display: "flex", gap: 1, alignItems: "center", height: "100%" }}>
          <IconButton size="small" onClick={() => {
            setEditingLoc(p.data);
            resetLoc({
              name: p.data.name,
              code: p.data.code || "",
              process_id: p.data.process_id || "",
            });
            setLocOpen(true);
          }}>
            <Edit fontSize="small" />
          </IconButton>
          <IconButton size="small" color="error" onClick={() => {
            if (window.confirm("Are you sure you want to delete this location?")) {
              deleteLocMutation.mutate(p.data.id);
            }
          }}>
            <Delete fontSize="small" />
          </IconButton>
        </Box>
      ),
    },
  ];

  const balanceColDefs: ColDef[] = [
    { field: "location_name", headerName: "Location", flex: 1, minWidth: 150 },
    { field: "process_name", headerName: "Process", flex: 1, minWidth: 150, valueFormatter: (p) => p.value || "General Store" },
    { field: "stock_item_name", headerName: "Tool / Consumable", flex: 1.5, minWidth: 200 },
    { field: "item_code", headerName: "Item Code", width: 120 },
    {
      field: "balance_qty",
      headerName: "Available Stock",
      width: 150,
      type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data.uom_symbol || ""}`,
    },
  ];

  const movementColDefs: ColDef[] = [
    { field: "movement_no", headerName: "Ref No.", width: 130 },
    { field: "movement_date", headerName: "Date", width: 110 },
    {
      field: "movement_type",
      headerName: "Type",
      width: 130,
      cellRenderer: (p: any) => {
        const isTransfer = p.value === "Transfer";
        return (
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.5, color: isTransfer ? "primary.main" : "warning.main", fontWeight: 600 }}>
            {isTransfer ? <SwapHoriz fontSize="small" /> : <RemoveCircle fontSize="small" />}
            {p.value}
          </Box>
        );
      },
    },
    { field: "stock_item_name", headerName: "Item Name", flex: 1.5, minWidth: 180 },
    {
      field: "quantity",
      headerName: "Quantity",
      width: 120,
      type: "numericColumn",
      valueFormatter: (p) => `${formatQty(p.value)} ${p.data.uom_symbol || ""}`,
    },
    { field: "location_name", headerName: "From", flex: 1, minWidth: 130, valueFormatter: (p) => p.value || "Main Store" },
    { field: "to_location_name", headerName: "To", flex: 1, minWidth: 130, valueFormatter: (p) => p.value || "Consumed" },
    { field: "narration", headerName: "Narration", flex: 1.2, minWidth: 150 },
    {
      headerName: "Actions",
      width: 80,
      sortable: false,
      filter: false,
      cellRenderer: (p: any) => (
        <IconButton size="small" color="error" onClick={() => {
          if (window.confirm("Delete this movement entry?")) {
            deleteMoveMutation.mutate(p.data.id);
          }
        }}>
          <Delete fontSize="small" />
        </IconButton>
      ),
    },
  ];

  const consumptionColDefs: ColDef[] = [
    {
      field: "shift_label",
      headerName: "Shift",
      width: 110,
      cellRenderer: (p: any) => (
        <Chip
          label={p.value}
          size="small"
          color={p.value === "1st Shift" ? "primary" : "secondary"}
          variant="outlined"
          sx={{ fontWeight: 600, fontSize: "0.75rem" }}
        />
      ),
    },
    { field: "contractor_name", headerName: "Contractor", flex: 1.5, minWidth: 150 },
    { field: "location_name", headerName: "Location", flex: 1.2, minWidth: 130 },
    { field: "date", headerName: "Date", width: 110 },
    { field: "inward_no", headerName: "Inward No", width: 130 },
    { field: "inward_ref", headerName: "Inward Ref", width: 130 },
    {
      field: "qty",
      headerName: "Qty",
      width: 110,
      type: "numericColumn",
      valueFormatter: (p) => formatQty(p.value),
    },
    {
      field: "weight",
      headerName: "Weight",
      width: 130,
      type: "numericColumn",
      valueFormatter: (p) => p.value !== undefined && p.value !== null ? `${Number(p.value).toFixed(3)} kg` : "-",
    },
  ];

  return (
    <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5 }}>
      <PageHeader
        title="Location Inventory"
        subtitle="Manage locations and track tools/consumables issue and consumption"
        breadcrumbs={[{ label: "Inventory" }, { label: "Locations" }]}
      />

      <Tabs value={tabValue} onChange={(_, val) => setTabValue(val)} sx={{ borderBottom: 1, borderColor: "divider", mb: 1 }}>
        <Tab label="Locations" />
        <Tab label="Location Stock" />
        <Tab label="Transactions (Issue & Consume)" />
        <Tab label="Consumption Report" />
      </Tabs>

      {/* TAB 0: LOCATIONS CRUD */}
      {tabValue === 0 && (
        <OrbxGrid
          rowData={locations}
          columnDefs={locationColDefs}
          loading={isLocsLoading}
          onRefresh={refetchLocs}
          onAdd={() => {
            setEditingLoc(null);
            resetLoc({ name: "", code: "", process_id: "" });
            setLocOpen(true);
          }}
          addLabel="Add Location"
        />
      )}

      {/* TAB 1: LOCATION BALANCES */}
      {tabValue === 1 && (
        <OrbxGrid
          rowData={locationBalances}
          columnDefs={balanceColDefs}
          loading={isBalancesLoading}
          onRefresh={refetchBalances}
        />
      )}

      {/* TAB 2: TRANSACTIONS LIST & RECORDING */}
      {tabValue === 2 && (
        <Box sx={{ display: "flex", flexDirection: "column", gap: 1.5 }}>
          <Box sx={{ display: "flex", justifyContent: "flex-end", gap: 1 }}>
            <Button
              variant="contained"
              startIcon={<SwapHoriz />}
              onClick={() => {
                setMoveType("Transfer");
                resetMove({
                  movement_no: `TR-${Date.now().toString().slice(-6)}`,
                  movement_date: today,
                  stock_item_id: "",
                  location_id: "",
                  to_location_id: "",
                  quantity: "",
                  narration: "Material Issued to Location",
                });
                setMoveOpen(true);
              }}
            >
              Transfer / Issue
            </Button>
            <Button
              variant="contained"
              color="warning"
              startIcon={<RemoveCircle />}
              onClick={() => {
                setMoveType("Consumption");
                resetMove({
                  movement_no: `CS-${Date.now().toString().slice(-6)}`,
                  movement_date: today,
                  stock_item_id: "",
                  location_id: "",
                  quantity: "",
                  narration: "Consumable used in process",
                });
                setMoveOpen(true);
              }}
            >
              Track Consumption
            </Button>
          </Box>
          <OrbxGrid
            rowData={movements}
            columnDefs={movementColDefs}
            loading={isMovementsLoading}
            onRefresh={refetchMovements}
          />
        </Box>
      )}

      {/* TAB 3: SHIFT-WISE CONTRACTOR CONSUMPTION REPORT */}
      {tabValue === 3 && (
        <Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>
          <Paper variant="outlined" sx={{ p: 2, bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.01)" : "rgba(0,0,0,0.01)", borderRadius: "12px" }}>
            <Typography variant="subtitle2" sx={{ mb: 1.5, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.5px", color: "text.secondary" }}>
              Shift Comparison Filters
            </Typography>
            <Grid container spacing={2}>
              {/* 1st Shift Filters */}
              <Grid size={{ xs: 12, md: 6 }}>
                <Box sx={{ p: 1.5, border: "1px solid", borderColor: "divider", borderRadius: "8px", height: "100%", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.01)" : "rgba(0,0,0,0.005)" }}>
                  <Typography variant="body2" sx={{ fontWeight: 700, mb: 1.5, color: "primary.main" }}>
                    1st Shift Config
                  </Typography>
                  <Grid container spacing={1.5}>
                    <Grid size={{ xs: 12 }}>
                      <TextField
                        select
                        label="1st Shift Person (Contractor)"
                        fullWidth
                        size="small"
                        value={p1Id}
                        onChange={(e) => setP1Id(e.target.value)}
                        slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                      >
                        <MenuItem value=""><em>None / Unassigned</em></MenuItem>
                        {contractors.map((c: any) => (
                          <MenuItem key={c.id} value={c.id}>{c.name}</MenuItem>
                        ))}
                      </TextField>
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField
                        type="date"
                        label="From Date"
                        fullWidth
                        size="small"
                        value={p1From}
                        onChange={(e) => setP1From(e.target.value)}
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField
                        type="date"
                        label="To Date"
                        fullWidth
                        size="small"
                        value={p1To}
                        onChange={(e) => setP1To(e.target.value)}
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                  </Grid>
                </Box>
              </Grid>

              {/* 2nd Shift Filters */}
              <Grid size={{ xs: 12, md: 6 }}>
                <Box sx={{ p: 1.5, border: "1px solid", borderColor: "divider", borderRadius: "8px", height: "100%", bgcolor: (t) => t.palette.mode === "dark" ? "rgba(255,255,255,0.01)" : "rgba(0,0,0,0.005)" }}>
                  <Typography variant="body2" sx={{ fontWeight: 700, mb: 1.5, color: "secondary.main" }}>
                    2nd Shift Config
                  </Typography>
                  <Grid container spacing={1.5}>
                    <Grid size={{ xs: 12 }}>
                      <TextField
                        select
                        label="2nd Shift Person (Contractor)"
                        fullWidth
                        size="small"
                        value={p2Id}
                        onChange={(e) => setP2Id(e.target.value)}
                        slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                      >
                        <MenuItem value=""><em>None / Unassigned</em></MenuItem>
                        {contractors.map((c: any) => (
                          <MenuItem key={c.id} value={c.id}>{c.name}</MenuItem>
                        ))}
                      </TextField>
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField
                        type="date"
                        label="From Date"
                        fullWidth
                        size="small"
                        value={p2From}
                        onChange={(e) => setP2From(e.target.value)}
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                    <Grid size={{ xs: 6 }}>
                      <TextField
                        type="date"
                        label="To Date"
                        fullWidth
                        size="small"
                        value={p2To}
                        onChange={(e) => setP2To(e.target.value)}
                        slotProps={{ inputLabel: { shrink: true } }}
                      />
                    </Grid>
                  </Grid>
                </Box>
              </Grid>
            </Grid>
          </Paper>

          <OrbxGrid
            rowData={consumptionReport}
            columnDefs={consumptionColDefs}
            loading={isConsLoading}
            onRefresh={refetchCons}
          />
        </Box>
      )}

      {/* Location Create/Edit Dialog */}
      <Dialog open={locOpen} onClose={() => setLocOpen(false)} maxWidth="xs" fullWidth>
        <form onSubmit={handleSubLoc((d) => saveLocMutation.mutate(d))}>
          <DialogTitle>{editingLoc ? "Edit Location" : "Add New Location"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 12 }}>
                <TextField {...regLoc("name")} label="Location Name *" fullWidth required slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <TextField {...regLoc("code")} label="Location Code" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="process_id"
                  control={controlLoc}
                  render={({ field }) => (
                    <TextField
                      {...field}
                      select
                      label="Associate with Process"
                      fullWidth
                      slotProps={{ inputLabel: { shrink: true } }}
                    >
                      <MenuItem value=""><em>None (General Store / Main Stock)</em></MenuItem>
                      {processes.map((p: any) => (
                        <MenuItem key={p.id} value={p.id}>{p.name}</MenuItem>
                      ))}
                    </TextField>
                  )}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setLocOpen(false)} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveLocMutation.isPending}>Save</Button>
          </DialogActions>
        </form>
      </Dialog>

      {/* Movement Create Dialog */}
      <Dialog open={moveOpen} onClose={() => setMoveOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubMove((d) => saveMoveMutation.mutate(d))}>
          <DialogTitle>Record Stock {moveType === "Transfer" ? "Transfer / Issue" : "Consumption"}</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}>
                <TextField {...regMove("movement_no")} label="Ref No. *" fullWidth required slotProps={{ htmlInput: { readOnly: true }, inputLabel: { shrink: true } }} />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField {...regMove("movement_date")} label="Date" type="date" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>

              <Grid size={{ xs: 12 }}>
                <Controller
                  name="stock_item_id"
                  control={controlMove}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={stockItems}
                      getOptionLabel={(o: any) => `${o.name} (${o.item_code || "No Code"})`}
                      value={stockItems.find((s: any) => s.id === field.value) || null}
                      onChange={(_, v) => field.onChange(v ? v.id : "")}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="Select Tool / Consumable *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                        />
                      )}
                    />
                  )}
                />
              </Grid>

              {/* Source Location */}
              <Grid size={{ xs: 6 }}>
                <Controller
                  name="location_id"
                  control={controlMove}
                  rules={moveType === "Consumption" ? { required: "Required" } : {}}
                  render={({ field }) => (
                    <TextField
                      {...field}
                      select
                      label={moveType === "Transfer" ? "Source Location (From)" : "Location *" }
                      fullWidth
                      slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                    >
                      {moveType === "Transfer" && <MenuItem value="">Main Store</MenuItem>}
                      {locations.map((l: any) => (
                        <MenuItem key={l.id} value={l.id}>{l.name}</MenuItem>
                      ))}
                    </TextField>
                  )}
                />
              </Grid>

              {/* Destination Location (Only for Transfer) */}
              {moveType === "Transfer" && (
                <Grid size={{ xs: 6 }}>
                  <Controller
                    name="to_location_id"
                    control={controlMove}
                    rules={{ required: "Required" }}
                    render={({ field, fieldState }) => (
                      <TextField
                        {...field}
                        select
                        label="Destination Location (To) *"
                        fullWidth
                        error={!!fieldState.error}
                        helperText={fieldState.error?.message}
                        slotProps={{ select: { displayEmpty: true }, inputLabel: { shrink: true } }}
                      >
                        <MenuItem value="" disabled>Select Location</MenuItem>
                        {locations.map((l: any) => (
                          <MenuItem key={l.id} value={l.id} disabled={String(l.id) === String(selectedSrcLoc)}>{l.name}</MenuItem>
                        ))}
                      </TextField>
                    )}
                  />
                </Grid>
              )}

              {/* Available Stock Indicator */}
              {selectedMoveItem && (
                <Grid size={{ xs: 12 }}>
                  <Paper variant="outlined" sx={{ p: 1.5, bgcolor: "action.hover" }}>
                    <Typography variant="body2" sx={{ fontWeight: 500 }}>
                      Available quantity in source location:{" "}
                      <span style={{ fontWeight: 700, color: availableQty > 0 ? "success.main" : "error.main" }}>
                        {formatQty(availableQty)}
                      </span>
                    </Typography>
                  </Paper>
                </Grid>
              )}

              <Grid size={{ xs: 6 }}>
                <TextField
                  {...regMove("quantity", {
                    required: "Required",
                    validate: (v) => Number(v) > 0 || "Quantity must be greater than 0"
                  })}
                  label="Quantity *"
                  type="number"
                  fullWidth
                  error={!!errors?.quantity}
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>

              <Grid size={{ xs: 6 }}>
                <TextField {...regMove("narration")} label="Narration" fullWidth slotProps={{ inputLabel: { shrink: true } }} />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setMoveOpen(false)} variant="outlined">Cancel</Button>
            <Button type="submit" variant="contained" disabled={saveMoveMutation.isPending || (selectedMoveItem && Number(watchMove("quantity")) > availableQty)}>
              Save
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}
