@echo off
REM DEMS ML File Upload Script
REM This script uploads the project files to the server using PSCP

echo ========================================
echo DEMS ML File Upload to Server
echo ========================================
echo.

REM Configuration variables - UPDATE THESE FOR YOUR SERVER
set SERVER_HOST=your-server-ip-or-domain.com
set SERVER_USER=your-username
set SERVER_PORT=22
set REMOTE_PATH=/opt/dems_ml
set LOCAL_PATH=%~dp0..

REM PSCP executable path - adjust if needed
set PSCP_PATH="C:\Program Files\PuTTY\pscp.exe"

REM Check if PSCP is available
if not exist %PSCP_PATH% (
    echo ERROR: PSCP not found at %PSCP_PATH%
    echo Please install PuTTY or update the PSCP_PATH variable
    pause
    exit /b 1
)

echo Uploading DEMS ML project files to server...
echo Server: %SERVER_HOST%
echo User: %SERVER_USER%
echo Remote Path: %REMOTE_PATH%
echo Local Path: %LOCAL_PATH%
echo.

REM Create remote directory
echo Creating remote directory...
%PSCP_PATH% -P %SERVER_PORT% -batch -q -scp -r %LOCAL_PATH%\python %SERVER_USER%@%SERVER_HOST%:%REMOTE_PATH%/

if %errorlevel% neq 0 (
    echo ❌ Failed to upload Python files!
    pause
    exit /b 1
)

REM Upload configuration files
echo Uploading configuration files...
%PSCP_PATH% -P %SERVER_PORT% -batch -q -scp putty_config/server_commands.txt %SERVER_USER%@%SERVER_HOST%:%REMOTE_PATH%/
%PSCP_PATH% -P %SERVER_PORT% -batch -q -scp putty_config/setup_server.sh %SERVER_USER%@%SERVER_HOST%:%REMOTE_PATH%/

if %errorlevel% neq 0 (
    echo ❌ Failed to upload configuration files!
    pause
    exit /b 1
)

echo.
echo ✅ Files uploaded successfully!
echo.
echo Next steps:
echo 1. SSH to your server: %SERVER_USER%@%SERVER_HOST%
echo 2. Run the setup script: chmod +x %REMOTE_PATH%/setup_server.sh && %REMOTE_PATH%/setup_server.sh
echo 3. Test the system: %REMOTE_PATH%/run_manual.sh
echo.

pause
