# DEMS ML PuTTY Configuration & Auto-Run Setup

This directory contains all the necessary files to set up automatic execution of the DEMS ML prediction system on a remote server using PuTTY.

## 📁 Files Overview

### Configuration Files
- `dems_ml_session.reg` - PuTTY session configuration (Windows Registry)
- `dems_ml_server.ppk` - PuTTY private key file (if using key authentication)

### Windows Scripts
- `auto_run_dems.bat` - Main script for automatic execution
- `task_scheduler_setup.bat` - Sets up Windows Task Scheduler
- `upload_to_server.bat` - Uploads project files to server

### Server Scripts
- `server_commands.txt` - Commands executed on the server
- `setup_server.sh` - Server environment setup script

## 🚀 Quick Setup Guide

### Step 1: Configure Server Details

1. **Edit `auto_run_dems.bat`:**
   ```batch
   set SERVER_HOST=your-server-ip-or-domain.com
   set SERVER_USER=your-username
   set SERVER_PORT=22
   ```

2. **Edit `upload_to_server.bat`:**
   ```batch
   set SERVER_HOST=your-server-ip-or-domain.com
   set SERVER_USER=your-username
   set SERVER_PORT=22
   set REMOTE_PATH=/opt/dems_ml
   ```

3. **Edit `server_commands.txt`:**
   ```bash
   cd /path/to/dems_ml  # Update to your actual project path
   ```

### Step 2: Install PuTTY

Download and install PuTTY from: https://www.putty.org/

### Step 3: Upload Files to Server

1. Run `upload_to_server.bat` to upload your project files
2. SSH to your server and run the setup script:
   ```bash
   chmod +x /opt/dems_ml/setup_server.sh
   /opt/dems_ml/setup_server.sh
   ```

### Step 4: Set Up Automatic Execution

#### Option A: Windows Task Scheduler (Recommended)
1. Run `task_scheduler_setup.bat` as Administrator
2. The system will run daily at 8:00 AM

#### Option B: Manual Execution
1. Run `auto_run_dems.bat` whenever you want to execute the system

## 🔧 Configuration Options

### PuTTY Session Configuration

The `dems_ml_session.reg` file contains a complete PuTTY session configuration. To use it:

1. Double-click the `.reg` file to import it into Windows Registry
2. Open PuTTY and select "dems_ml_server" from the saved sessions
3. Update the HostName and UserName in the registry or PuTTY GUI

### Server Environment

The `setup_server.sh` script will:
- Install Python 3 and required packages
- Create a virtual environment
- Set up cron job for automatic execution (every 6 hours)
- Create systemd service for manual control
- Set up log rotation
- Create monitoring and manual execution scripts

### Execution Schedule

**Default Schedule:**
- Windows Task Scheduler: Daily at 8:00 AM
- Server Cron Job: Every 6 hours

**To modify the schedule:**

Windows (Task Scheduler):
```batch
schtasks /change /tn "DEMS ML Auto-Run" /sc hourly /mo 6
```

Linux (Cron):
```bash
crontab -e
# Change the schedule in the crontab file
```

## 📊 Monitoring & Logs

### Windows Logs
- Log file: `dems_ml_auto_run.log` (in the same directory as the batch file)

### Server Logs
- Log file: `/opt/dems_ml/dems_ml.log`
- System logs: `journalctl -u dems-ml.service`

### Monitoring Script
Run the monitoring script on the server:
```bash
/opt/dems_ml/monitor_dems.sh
```

## 🔐 Security Considerations

1. **SSH Key Authentication (Recommended):**
   - Generate SSH keys on your Windows machine
   - Add the public key to the server's `~/.ssh/authorized_keys`
   - Update the PuTTY session to use key authentication

2. **Password Authentication:**
   - PuTTY will prompt for password each time
   - Consider using Pageant (PuTTY authentication agent) for password caching

3. **Firewall:**
   - Ensure port 22 (SSH) is open on your server
   - Consider changing the default SSH port for additional security

## 🛠️ Troubleshooting

### Common Issues

1. **"PuTTY not found" error:**
   - Install PuTTY or update the `PUTTY_PATH` variable in the batch files

2. **Connection refused:**
   - Check server IP/domain and port
   - Verify SSH service is running on the server
   - Check firewall settings

3. **Permission denied:**
   - Verify username and password/key authentication
   - Check user permissions on the server

4. **Python execution fails:**
   - Run the server setup script: `/opt/dems_ml/setup_server.sh`
   - Check Python virtual environment: `source /opt/dems_ml/venv/bin/activate`

### Manual Testing

Test the connection manually:
```batch
putty.exe -ssh your-username@your-server.com -P 22
```

Test the Python script on the server:
```bash
cd /opt/dems_ml
source venv/bin/activate
python python/run_predictor.py --days 14
```

## 📝 Customization

### Adding More Locations
Edit `server_commands.txt` to run for specific locations:
```bash
python3 python/run_predictor.py --location "SpecificBarangay" --days 14
```

### Changing Execution Frequency
- Windows: Modify Task Scheduler settings
- Linux: Edit crontab entry

### Adding Email Notifications
Add email notification to the batch script or server commands for execution results.

## 📞 Support

For issues with this setup:
1. Check the log files for error messages
2. Verify all configuration variables are correct
3. Test manual execution first
4. Check server resources (disk space, memory, etc.)

---

**Note:** Remember to update all configuration variables with your actual server details before using these scripts.
