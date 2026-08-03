import { useEffect, ReactNode } from "react";
import { useUIStore } from "../store";
import { Box, Typography } from "@mui/material";

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

  return (
    <Box
      sx={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        width: "100%",
        py: 0.75,
        px: 0.5,
        mb: 0.5,
      }}
    >
      <Box sx={{ display: "flex", flexDirection: "column" }}>
        <Typography
          variant="h5"
          component="h1"
          sx={{
            fontWeight: 700,
            fontSize: "1.25rem",
            color: "text.primary",
            letterSpacing: "-0.015em",
            lineHeight: 1.2,
          }}
        >
          {title}
        </Typography>
        {subtitle && (
          <Typography variant="body2" sx={{ color: "text.secondary", mt: 0.25, fontSize: "0.8rem" }}>
            {subtitle}
          </Typography>
        )}
      </Box>
      {actions && (
        <Box sx={{ display: "flex", gap: 1.5, alignItems: "center" }}>
          {actions}
        </Box>
      )}
    </Box>
  );
}
