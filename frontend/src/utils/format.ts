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

export function formatDate(
  val: string | Date | null | undefined,
  yearFormat: "4digit" | "2digit" = "4digit"
): string {
  if (!val) return "-";
  try {
    let str = typeof val === "string" ? val.trim() : val.toISOString();
    if (!str) return "-";
    if (/^\d{4}-\d{2}-\d{2}$/.test(str)) {
      const [y, m, d] = str.split("-").map(Number);
      const yStr = yearFormat === "2digit" ? String(y).slice(-2) : String(y);
      return `${String(d).padStart(2, "0")}/${String(m).padStart(2, "0")}/${yStr}`;
    }
    if (typeof val === "string" && !str.endsWith("Z") && !/[+-]\d{2}:\d{2}$/.test(str)) {
      if (str.includes("T")) {
        str = str + "Z";
      } else if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/.test(str)) {
        str = str.replace(" ", "T") + "Z";
      }
    }
    const d = new Date(str);
    if (isNaN(d.getTime())) return String(val);
    const day = String(d.getDate()).padStart(2, "0");
    const month = String(d.getMonth() + 1).padStart(2, "0");
    const year = yearFormat === "2digit" ? String(d.getFullYear()).slice(-2) : String(d.getFullYear());
    return `${day}/${month}/${year}`;
  } catch {
    return String(val);
  }
}

export function formatDateTime(val: string | Date | null | undefined): string {
  if (!val) return "-";
  try {
    let str = typeof val === "string" ? val.trim() : val.toISOString();
    if (!str) return "-";
    if (typeof val === "string" && !str.endsWith("Z") && !/[+-]\d{2}:\d{2}$/.test(str)) {
      if (str.includes("T")) {
        str = str + "Z";
      } else if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/.test(str)) {
        str = str.replace(" ", "T") + "Z";
      }
    }
    const d = new Date(str);
    if (isNaN(d.getTime())) return String(val);
    const day = String(d.getDate()).padStart(2, "0");
    const month = String(d.getMonth() + 1).padStart(2, "0");
    const year = d.getFullYear();
    const timeStr = d.toLocaleTimeString(IN, {
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hour12: true,
    });
    return `${day}/${month}/${year}, ${timeStr}`;
  } catch {
    return String(val);
  }
}
