import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Box, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, Grid } from "@mui/material";
import { useForm, Controller } from "react-hook-form";
import { ColDef } from "../../components/tables/OrbxGrid";
import api from "../../api/client";
import PageHeader from "../../components/PageHeader";
import OrbxGrid from "../../components/tables/OrbxGrid";
import { LazyAutocomplete } from "../../components/LazyAutocomplete";
import { useAuthStore } from "../../store";

const today = new Date().toISOString().split("T")[0];

export default function StockTransferPage() {
  const { activeFY } = useAuthStore();
  const qc = useQueryClient();
  const [open, setOpen] = useState(false);

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ["transfer", activeFY],
    queryFn: async () => (await api.get(`/stock/transfer?fy=${activeFY}`)).data,
  });

  const { data: stockItems = [] } = useQuery({
    queryKey: ["stock-items"],
    queryFn: async () => (await api.get("/products/stock-items")).data,
  });

  const { register, handleSubmit, reset, control } = useForm({
    defaultValues: {
      transfer_no: "",
      transfer_date: today,
      from_stock_item_id: "",
      to_stock_item_id: "",
      quantity: 0,
      narration: "",
    },
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => api.post(`/stock/transfer?fy=${activeFY}`, data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["transfer"] });
      setOpen(false);
    },
  });

  const colDefs: ColDef[] = [
    { field: "transfer_no", headerName: "Transfer No.", width: 140 },
    { field: "transfer_date", headerName: "Date", width: 100 },
    { field: "from_stock_item_id", headerName: "From Item", width: 150 },
    { field: "to_stock_item_id", headerName: "To Item", width: 150 },
    { field: "quantity", headerName: "Quantity", width: 80, type: "numericColumn" },
    { field: "narration", headerName: "Narration", flex: 1 },
  ];

  return (
    <Box>
      <PageHeader title="Stock Transfer" breadcrumbs={[{ label: "Inventory" }, { label: "Stock Transfer" }]} />
      <OrbxGrid
        rowData={data}
        columnDefs={colDefs}
        loading={isLoading}
        onRefresh={refetch}
        onAdd={() => {
          reset({
            transfer_no: "",
            transfer_date: today,
            from_stock_item_id: "",
            to_stock_item_id: "",
            quantity: 0,
            narration: "",
          });
          setOpen(true);
        }}
        addLabel="Add Entry"
      />
      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))}>
          <DialogTitle>New Stock Transfer</DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 0.5 }}>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("transfer_no")} label="Transfer No. *" fullWidth required />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField
                  {...register("transfer_date")}
                  label="Date"
                  type="date"
                  fullWidth
                  slotProps={{ inputLabel: { shrink: true } }}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="from_stock_item_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={stockItems}
                      getOptionLabel={(o: any) => o.name}
                      value={stockItems.find((s: any) => s.id === field.value) || null}
                      onChange={(_, v) => field.onChange(v ? v.id : "")}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="From Item *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                        />
                      )}
                    />
                  )}
                />
              </Grid>
              <Grid size={{ xs: 12 }}>
                <Controller
                  name="to_stock_item_id"
                  control={control}
                  rules={{ required: "Required" }}
                  render={({ field, fieldState }) => (
                    <LazyAutocomplete
                      options={stockItems}
                      getOptionLabel={(o: any) => o.name}
                      value={stockItems.find((s: any) => s.id === field.value) || null}
                      onChange={(_, v) => field.onChange(v ? v.id : "")}
                      renderInput={(params) => (
                        <TextField
                          {...params}
                          label="To Item *"
                          error={!!fieldState.error}
                          helperText={fieldState.error?.message}
                        />
                      )}
                    />
                  )}
                />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("quantity")} label="Quantity" type="number" fullWidth />
              </Grid>
              <Grid size={{ xs: 6 }}>
                <TextField {...register("narration")} label="Narration" fullWidth />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions sx={{ px: 3, pb: 2, gap: 1 }}>
            <Button onClick={() => setOpen(false)} variant="outlined">
              Cancel
            </Button>
            <Button type="submit" variant="contained" disabled={saveMutation.isPending}>
              Save
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}
