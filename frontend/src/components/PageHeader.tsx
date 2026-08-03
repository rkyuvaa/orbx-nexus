import { useEffect, ReactNode } from "react";
import { useUIStore } from "../store";
import { Box } from "@mui/material";

interface PageHeaderProps {
  title: string;
  subtitle?: string;
  breadcrumbs?: { label: string; path?: string }[];
  actions?: ReactNode;
}

export default function PageHeader({ title, subtitle, breadcrumbs, actions }: PageHeaderProps) {
  const { setHeaderState } = useUIStore();

  useEffect(() => {
    setHeaderState({ title, breadcrumbs });
  }, [title, breadcrumbs, setHeaderState]);

  if (!actions) return null;

  return (
    <Box sx={{ mb: 2, display: "flex", justifyContent: "flex-end", alignItems: "center", width: "100%" }}>
      <Box sx={{ display: "flex", gap: 1.5, alignItems: "center" }}>
        {actions}
      </Box>
    </Box>
  );
}
