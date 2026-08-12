const IN = "en-IN" as const;

export function formatQty(val: number | string | null | undefined): string {
  const n = Number(val || 0);
  return n.toLocaleString(IN, { minimumFractionDigits: 0, maximumFractionDigits: 0 });
}

export function formatWeight(val: number | string | null | undefined): string {
  const n = Number(val || 0);
  return n.toLocaleString(IN, { minimumFractionDigits: 3, maximumFractionDigits: 3 });
}

export function formatAmount(val: number | string | null | undefined): string {
  const n = Number(val || 0);
  return n.toLocaleString(IN, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

export function formatIndian(val: number | string | null | undefined, decimals: number = 0): string {
  const n = Number(val || 0);
  return n.toLocaleString(IN, { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
}

export function formatDate(val: string | null | undefined): string {
  if (!val) return "-";
  try {
    return new Date(val).toLocaleDateString(IN, { day: "2-digit", month: "2-digit", year: "numeric" });
  } catch {
    return val;
  }
}
