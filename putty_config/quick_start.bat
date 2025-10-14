@echo off
REM DEMS ML Quick Start Script
REM This script provides an easy way to get started with the DEMS ML auto-run setup

echo ========================================
echo DEMS ML Quick Start Setup
echo ========================================
echo.
echo This script will help you set up automatic execution of your
echo DEMS ML prediction system on a remote server.
echo.

REM Check if PuTTY is installed
set PUTTY_PATH="C:\Program Files\PuTTY\putty.exe"
if not exist %PUTTY_PATH% (
    echo ❌ PuTTY is not installed!
    echo.
    echo Please download and install PuTTY from:
    echo https://www.putty.org/
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
)

echo ✅ PuTTY is installed
echo.

REM Get server configuration from user
echo Please provide your server configuration:
echo.
set /p SERVER_HOST="Server IP or Domain: "
set /p SERVER_USER="Username: "
set /p SERVER_PORT="SSH Port (default 22): "

if "%SERVER_PORT%"=="" set SERVER_PORT=22

echo.
echo Configuration Summary:
echo - Server: %SERVER_HOST%
echo - User: %SERVER_USER%
echo - Port: %SERVER_PORT%
echo.
set /p CONFIRM="Is this correct? (y/n): "

if /i not "%CONFIRM%"=="y" (
    echo Setup cancelled.
    pause
    exit /b 0
)

echo.
echo Updating configuration files...

REM Update auto_run_dems.bat
powershell -Command "(Get-Content 'auto_run_dems.bat') -replace 'your-server-ip-or-domain.com', '%SERVER_HOST%' | Set-Content 'auto_run_dems.bat'"
powershell -Command "(Get-Content 'auto_run_dems.bat') -replace 'your-username', '%SERVER_USER%' | Set-Content 'auto_run_dems.bat'"
powershell -Command "(Get-Content 'auto_run_dems.bat') -replace 'set SERVER_PORT=22', 'set SERVER_PORT=%SERVER_PORT%' | Set-Content 'auto_run_dems.bat'"

REM Update upload_to_server.bat
powershell -Command "(Get-Content 'upload_to_server.bat') -replace 'your-server-ip-or-domain.com', '%SERVER_HOST%' | Set-Content 'upload_to_server.bat'"
powershell -Command "(Get-Content 'upload_to_server.bat') -replace 'your-username', '%SERVER_USER%' | Set-Content 'upload_to_server.bat'"
powershell -Command "(Get-Content 'upload_to_server.bat') -replace 'set SERVER_PORT=22', 'set SERVER_PORT=%SERVER_PORT%' | Set-Content 'upload_to_server.bat'"

echo ✅ Configuration files updated
echo.

REM Ask user what they want to do next
echo What would you like to do next?
echo.
echo 1. Upload files to server and set up server environment
echo 2. Set up Windows Task Scheduler for automatic execution
echo 3. Test the connection manually
echo 4. Exit
echo.
set /p CHOICE="Enter your choice (1-4): "

if "%CHOICE%"=="1" (
    echo.
    echo Starting file upload and server setup...
    call upload_to_server.bat
) else if "%CHOICE%"=="2" (
    echo.
    echo Setting up Windows Task Scheduler...
    call task_scheduler_setup.bat
) else if "%CHOICE%"=="3" (
    echo.
    echo Testing connection...
    %PUTTY_PATH% -ssh %SERVER_USER%@%SERVER_HOST% -P %SERVER_PORT%
) else if "%CHOICE%"=="4" (
    echo.
    echo Setup completed. You can run the scripts manually later.
) else (
    echo.
    echo Invalid choice. Setup completed.
)

echo.
echo ========================================
echo Quick Start Setup Completed!
echo ========================================
echo.
echo Next steps:
echo 1. If you chose option 1, follow the instructions on the server
echo 2. If you chose option 2, your system will run automatically
echo 3. You can always run 'auto_run_dems.bat' manually
echo 4. Check the README.md file for detailed instructions
echo.
pause
