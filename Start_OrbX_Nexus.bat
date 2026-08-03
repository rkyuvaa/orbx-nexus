@echo off
title OrbX Nexus ERP Launcher
color 0A

echo ====================================================
echo    OrbX Nexus - Enterprise Manufacturing ERP
echo ====================================================
echo.

:: 1. Start Docker Databases
echo [1/3] Starting Database Services (PostgreSQL & Redis)...
cd /d "D:\OrbX Nexus"
docker compose up -d
if errorlevel 1 (
    echo [WARNING] Docker Compose failed. Please ensure Docker Desktop is running!
    pause
)

:: 2. Start Backend Server
echo [2/3] Starting FastAPI Backend (Port 8000)...
start "OrbX Nexus Backend" /min cmd /c "cd /d D:\OrbX Nexus\backend && .\venv\Scripts\python main.py"

:: 3. Start Frontend Server
echo [3/3] Starting Vite React Frontend (Port 5173)...
start "OrbX Nexus Frontend" /min cmd /c "cd /d D:\OrbX Nexus\frontend && npm run dev"

echo.
echo ====================================================
echo  Launching ERP Dashboard in your browser...
echo  Default Login: admin / admin@orbx
echo ====================================================
echo.

:: Wait for servers to spin up
timeout /t 4 /nobreak >nul

:: Open browser
start http://localhost:5173/

exit
