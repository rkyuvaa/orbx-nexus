import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box, Card, CardContent, TextField, Button,
  Typography, Alert, CircularProgress, InputAdornment,
  IconButton,
} from "@mui/material";
import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";
import Lock from "@mui/icons-material/Lock";
import Person from "@mui/icons-material/Person";
import LightMode from "@mui/icons-material/LightMode";
import DarkMode from "@mui/icons-material/DarkMode";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { alpha, useTheme, keyframes } from "@mui/material/styles";
import api from "../../api/client";
import { useAuthStore, useUIStore } from "../../store";

const schema = z.object({
  username: z.string().min(1, "Username is required"),
  password: z.string().min(1, "Password is required"),
});

type FormData = z.infer<typeof schema>;

// Animations
const fadeUp = keyframes`
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
`;

const pulseGlow = keyframes`
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.7;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.15);
    opacity: 0.95;
  }
  100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.7;
  }
`;

export default function LoginPage() {
  const navigate = useNavigate();
  const { setAuth } = useAuthStore();
  const { themeMode, toggleThemeMode } = useUIStore();
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
    <Box
      sx={{
        minHeight: "100vh",
        bgcolor: "background.default",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: isDark
          ? `radial-gradient(circle at 15% 15%, ${alpha(theme.palette.primary.main, 0.12)} 0%, ${theme.palette.background.default} 65%)`
          : `radial-gradient(circle at 15% 15%, ${alpha(theme.palette.primary.main, 0.08)} 0%, ${theme.palette.background.default} 70%)`,
        position: "relative",
        overflow: "hidden",
        transition: "background 0.5s ease, background-color 0.5s ease",
      }}
    >
      {/* Background grid pattern */}
      <Box
        sx={{
          position: "absolute",
          inset: 0,
          backgroundImage: `linear-gradient(${alpha(theme.palette.primary.main, isDark ? 0.04 : 0.05)} 1px, transparent 1px), linear-gradient(90deg, ${alpha(theme.palette.primary.main, isDark ? 0.04 : 0.05)} 1px, transparent 1px)`,
          backgroundSize: "64px 64px",
          maskImage: "radial-gradient(circle at 50% 50%, black 40%, transparent 90%)",
          WebkitMaskImage: "radial-gradient(circle at 50% 50%, black 40%, transparent 90%)",
          zIndex: 0,
          transition: "background-image 0.5s ease",
        }}
      />

      {/* Glow orb */}
      <Box
        sx={{
          position: "absolute",
          width: 600,
          height: 600,
          borderRadius: "50%",
          background: `radial-gradient(circle, ${alpha(theme.palette.primary.main, isDark ? 0.12 : 0.08)} 0%, transparent 70%)`,
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          zIndex: 0,
          pointerEvents: "none",
          animation: `${pulseGlow} 10s ease-in-out infinite`,
        }}
      />

      {/* Theme Toggle Button */}
      <IconButton
        onClick={toggleThemeMode}
        sx={{
          position: "absolute",
          top: 24,
          right: 24,
          width: 44,
          height: 44,
          borderRadius: "50%",
          border: "1px solid",
          borderColor: "divider",
          bgcolor: isDark ? "rgba(255, 255, 255, 0.03)" : "rgba(0, 0, 0, 0.02)",
          color: "text.secondary",
          backdropFilter: "blur(8px)",
          zIndex: 10,
          transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
          "&:hover": {
            bgcolor: isDark ? "rgba(255, 255, 255, 0.08)" : "rgba(0, 0, 0, 0.05)",
            color: "primary.main",
            borderColor: alpha(theme.palette.primary.main, 0.3),
            transform: "rotate(15deg) scale(1.05)",
          },
        }}
      >
        {isDark ? <LightMode sx={{ fontSize: 20 }} /> : <DarkMode sx={{ fontSize: 20 }} />}
      </IconButton>

      <Box 
        sx={{ 
          position: "relative", 
          zIndex: 1, 
          width: "100%", 
          maxWidth: 420, 
          px: 2,
          animation: `${fadeUp} 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards`,
        }}
      >
        {/* Logo & Header */}
        <Box sx={{ textAlign: "center", mb: 4 }}>
          <Box
            sx={{
              width: 72,
              height: 72,
              borderRadius: 3,
              background: `linear-gradient(135deg, ${theme.palette.primary.main} 0%, ${isDark ? "#0b965f" : "#0c8052"} 100%)`,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              mx: "auto",
              mb: 2,
              fontSize: "2rem",
              fontWeight: 800,
              color: isDark ? "#08140E" : "#FFFFFF",
              boxShadow: isDark
                ? `0 8px 32px ${alpha(theme.palette.primary.main, 0.25)}`
                : `0 8px 24px ${alpha(theme.palette.primary.main, 0.20)}`,
              transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
              "&:hover": {
                transform: "translateY(-4px) scale(1.05)",
                boxShadow: isDark
                  ? `0 12px 40px ${alpha(theme.palette.primary.main, 0.4)}`
                  : `0 12px 32px ${alpha(theme.palette.primary.main, 0.3)}`,
              }
            }}
          >
            O
          </Box>
          <Typography
            variant="h4"
            sx={{
              fontWeight: 700,
              fontFamily: "'Comfortaa', sans-serif",
              background: `linear-gradient(135deg, ${theme.palette.primary.main} 0%, ${isDark ? "#81f6c9" : "#0c8052"} 100%)`,
              WebkitBackgroundClip: "text",
              WebkitTextFillColor: "transparent",
              WebkitTextStroke: "0.8px currentColor",
              letterSpacing: "-0.03em",
            }}
          >
            OrbX Nexus
          </Typography>
          <Typography sx={{ mt: 0.5 }} variant="body2" color="text.secondary">
            Manufacturing ERP System
          </Typography>
        </Box>

        {/* Login Card */}
        <Card
          sx={{
            background: isDark
              ? `linear-gradient(145deg, ${alpha("#0D1B14", 0.9)} 0%, ${alpha("#08140E", 0.95)} 100%)`
              : `linear-gradient(145deg, rgba(255, 255, 255, 0.9) 0%, rgba(244, 246, 245, 0.95) 100%)`,
            border: `1px solid ${theme.palette.divider}`,
            borderColor: isDark ? "rgba(255, 255, 255, 0.08)" : "rgba(22, 196, 127, 0.15)",
            backdropFilter: "blur(20px)",
            borderRadius: 4,
            boxShadow: isDark
              ? `0 24px 80px ${alpha("#000000", 0.6)}, 0 0 0 1px ${alpha(theme.palette.primary.main, 0.05)}`
              : `0 20px 48px ${alpha(theme.palette.primary.main, 0.06)}, 0 0 0 1px ${alpha(theme.palette.primary.main, 0.02)}`,
            transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
            "&:hover": {
              borderColor: alpha(theme.palette.primary.main, isDark ? 0.3 : 0.4),
              boxShadow: isDark
                ? `0 32px 96px ${alpha("#000000", 0.7)}, 0 0 0 1px ${alpha(theme.palette.primary.main, 0.1)}`
                : `0 28px 64px ${alpha(theme.palette.primary.main, 0.1)}, 0 0 0 1px ${alpha(theme.palette.primary.main, 0.05)}`,
            }
          }}
        >
          <CardContent sx={{ p: 4 }}>
            <Typography sx={{ mb: 0.5, fontWeight: 700 }} variant="h6">
              Welcome back
            </Typography>
            <Typography sx={{ mb: 3 }} variant="body2" color="text.secondary">
              Sign in to your account to continue
            </Typography>

            {error && (
              <Alert severity="error" sx={{ mb: 2, fontSize: "0.8rem", borderRadius: 2 }}>
                {error}
              </Alert>
            )}

            <Box component="form" onSubmit={handleSubmit(onSubmit)} sx={{ display: "flex", flexDirection: "column", gap: 2.5 }}>
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
          </CardContent>
        </Card>

        <Typography sx={{ mt: 3, display: "block", textAlign: "center" }} variant="caption" color="text.disabled">
          OrbX Nexus ERP v2.0 · Sri Metal Manufacturing
        </Typography>
      </Box>
    </Box>
  );
}
