@echo off
REM DEMS ML Task Scheduler Setup Script
REM This script creates a Windows Task Scheduler entry for automatic execution

echo ========================================
echo DEMS ML Task Scheduler Setup
echo ========================================
echo.

REM Configuration variables
set TASK_NAME="DEMS ML Auto-Run"
set SCRIPT_PATH="%~dp0auto_run_dems.bat"
set DESCRIPTION="Automatically runs DEMS ML prediction system on server"

echo Creating Windows Task Scheduler entry...
echo Task Name: %TASK_NAME%
echo Script Path: %SCRIPT_PATH%
echo.

REM Create the scheduled task
schtasks /create ^
    /tn %TASK_NAME% ^
    /tr "\"%SCRIPT_PATH%\"" ^
    /sc daily ^
    /st 08:00 ^
    /ru "SYSTEM" ^
    /f ^
    /sd %date% ^
    /ed 12/31/2025

if %errorlevel% equ 0 (
    echo ✅ Task Scheduler entry created successfully!
    echo.
    echo Task Details:
    echo - Name: %TASK_NAME%
    echo - Schedule: Daily at 8:00 AM
    echo - Script: %SCRIPT_PATH%
    echo - Run as: SYSTEM
    echo.
    echo You can modify the schedule using Task Scheduler GUI or:
    echo schtasks /change /tn %TASK_NAME% /sc hourly /mo 6
    echo (This would change it to run every 6 hours)
) else (
    echo ❌ Failed to create Task Scheduler entry!
    echo Please run this script as Administrator.
)

echo.
echo ========================================
echo Setup completed!
echo ========================================
echo.
pause
