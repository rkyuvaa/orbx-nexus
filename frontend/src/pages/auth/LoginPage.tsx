import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, TextField, Button, Typography, Alert,
  CircularProgress, InputAdornment, IconButton,
} from "@mui/material";
import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";
import Lock from "@mui/icons-material/Lock";
import Person from "@mui/icons-material/Person";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { alpha, useTheme } from "@mui/material/styles";
import api from "../../api/client";
import { useAuthStore, useUIStore } from "../../store";

const schema = z.object({
  username: z.string().min(1, "Username is required"),
  password: z.string().min(1, "Password is required"),
});

type FormData = z.infer<typeof schema>;

export default function LoginPage() {
  const navigate = useNavigate();
  const { setAuth } = useAuthStore();
  const { themeMode } = useUIStore();
  const theme = useTheme();
  
  const isDark = themeMode === "dark";
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<FormData>({ resolver: zodResolver(schema) });

  const onSubmit = async (data: FormData) => {
    setLoading(true);
    setError(null);
    try {
      const formData = new FormData();
      formData.append("username", data.username);
      formData.append("password", data.password);
      const res = await api.post("/auth/login", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setAuth(res.data.access_token, res.data.user);
      navigate("/");
    } catch (err: any) {
      setError(err.response?.data?.detail || "Login failed. Please check your credentials.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <Typography sx={{ mb: 0.5, fontWeight: 700 }} variant="h6">
        Welcome back
      </Typography>
      <Typography sx={{ mb: 3 }} variant="body2" color="text.secondary">
        Sign in to your account to continue
      </Typography>

      {error && (
        <Alert severity="error" sx={{ mb: 2, fontSize: "0.8rem", borderRadius: 2, textAlign: "left" }}>
          {error}
        </Alert>
      )}

      <Box
        component="form"
        onSubmit={handleSubmit(onSubmit)}
        sx={{ display: "flex", flexDirection: "column", gap: 2.5 }}
      >
        <TextField
          {...register("username")}
          label="Username"
          fullWidth
          error={!!errors.username}
          helperText={errors.username?.message}
          autoComplete="username"
          autoFocus
          sx={{
            "& .MuiOutlinedInput-root": {
              "&.Mui-focused .MuiInputAdornment-root .MuiSvgIcon-root": {
                color: "primary.main",
                transform: "scale(1.05)",
              },
              "& .MuiSvgIcon-root": {
                transition: "all 0.2s ease",
              }
            }
          }}
          slotProps={{
            input: {
              startAdornment: (
                <InputAdornment position="start">
                  <Person sx={{ color: "text.secondary", fontSize: 20 }} />
                </InputAdornment>
              ),
            }
          }}
        />
        <TextField
          {...register("password")}
          label="Password"
          type={showPassword ? "text" : "password"}
          fullWidth
          error={!!errors.password}
          helperText={errors.password?.message}
          autoComplete="current-password"
          sx={{
            "& .MuiOutlinedInput-root": {
              "&.Mui-focused .MuiInputAdornment-root .MuiSvgIcon-root": {
                color: "primary.main",
                transform: "scale(1.05)",
              },
              "& .MuiSvgIcon-root": {
                transition: "all 0.2s ease",
              }
            }
          }}
          slotProps={{
            input: {
              startAdornment: (
                <InputAdornment position="start">
                  <Lock sx={{ color: "text.secondary", fontSize: 20 }} />
                </InputAdornment>
              ),
              endAdornment: (
                <InputAdornment position="end">
                  <IconButton
                    onClick={() => setShowPassword((s) => !s)}
                    edge="end"
                    size="small"
                    sx={{ color: "text.secondary" }}
                  >
                    {showPassword ? <VisibilityOff fontSize="small" /> : <Visibility fontSize="small" />}
                  </IconButton>
                </InputAdornment>
              ),
            }
          }}
        />

        <Button
          type="submit"
          variant="contained"
          fullWidth
          size="large"
          disabled={loading}
          sx={{
            mt: 1.5,
            py: 1.6,
            fontSize: "0.95rem",
            fontWeight: 700,
            borderRadius: 2,
            transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
            position: "relative",
            overflow: "hidden",
            boxShadow: `0 4px 14px 0 ${alpha(theme.palette.primary.main, 0.4)}`,
            "&:hover": {
              boxShadow: `0 6px 20px 0 ${alpha(theme.palette.primary.main, 0.5)}`,
              transform: "translateY(-1px)",
            },
            "&:active": {
              transform: "translateY(1px)",
            }
          }}
        >
          {loading ? <CircularProgress size={22} sx={{ color: isDark ? "#000" : "#fff" }} /> : "Sign In"}
        </Button>
      </Box>
    </>
  );
}
