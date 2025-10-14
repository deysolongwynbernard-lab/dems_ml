@echo off
REM DEMS ML Auto-Run Script using PuTTY
REM This script automatically connects to the server and runs the prediction system

echo ========================================
echo DEMS ML Auto-Run Script
echo ========================================
echo.

REM Configuration variables - UPDATE THESE FOR YOUR SERVER
set SERVER_HOST=your-server-ip-or-domain.com
set SERVER_USER=your-username
set SERVER_PORT=22
set PYTHON_PATH=/path/to/python3
set PROJECT_PATH=/path/to/dems_ml
set LOG_FILE=dems_ml_auto_run.log

REM PuTTY executable path - adjust if needed
set PUTTY_PATH="C:\Program Files\PuTTY\putty.exe"
set PSCP_PATH="C:\Program Files\PuTTY\pscp.exe"

REM Check if PuTTY is available
if not exist %PUTTY_PATH% (
    echo ERROR: PuTTY not found at %PUTTY_PATH%
    echo Please install PuTTY or update the PUTTY_PATH variable
    pause
    exit /b 1
)

echo [%date% %time%] Starting DEMS ML Auto-Run...
echo [%date% %time%] Server: %SERVER_HOST%
echo [%date% %time%] User: %SERVER_USER%
echo.

REM Create log entry
echo [%date% %time%] DEMS ML Auto-Run Started >> %LOG_FILE%

REM Run the prediction system on the server
echo Executing prediction system on server...
%PUTTY_PATH% -ssh %SERVER_USER%@%SERVER_HOST% -P %SERVER_PORT% -m putty_config/server_commands.txt -t

if %errorlevel% equ 0 (
    echo [%date% %time%] DEMS ML execution completed successfully >> %LOG_FILE%
    echo.
    echo ✅ DEMS ML execution completed successfully!
) else (
    echo [%date% %time%] DEMS ML execution failed with error code %errorlevel% >> %LOG_FILE%
    echo.
    echo ❌ DEMS ML execution failed!
)

echo.
echo ========================================
echo Auto-Run completed at %date% %time%
echo ========================================
echo.

REM Optional: Keep window open for 10 seconds to see results
timeout /t 10 /nobreak >nul
