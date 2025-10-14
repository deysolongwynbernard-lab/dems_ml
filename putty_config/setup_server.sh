#!/bin/bash
# DEMS ML Server Setup Script
# Run this script on your Linux/Unix server to set up the environment

echo "========================================"
echo "DEMS ML Server Setup Script"
echo "========================================"
echo ""

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y

# Install Python 3 and pip if not already installed
echo "Installing Python 3 and pip..."
sudo apt-get install -y python3 python3-pip python3-venv

# Install additional system dependencies
echo "Installing system dependencies..."
sudo apt-get install -y build-essential libssl-dev libffi-dev python3-dev

# Create project directory
PROJECT_DIR="/opt/dems_ml"
echo "Creating project directory: $PROJECT_DIR"
sudo mkdir -p $PROJECT_DIR
sudo chown $USER:$USER $PROJECT_DIR

# Copy project files (assuming they're uploaded via SCP/SFTP)
echo "Setting up project structure..."
cd $PROJECT_DIR

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install Python requirements
echo "Installing Python requirements..."
pip install --upgrade pip
pip install -r python/requirements.txt

# Create systemd service for automatic execution
echo "Creating systemd service..."
sudo tee /etc/systemd/system/dems-ml.service > /dev/null <<EOF
[Unit]
Description=DEMS ML Prediction System
After=network.target

[Service]
Type=oneshot
User=$USER
WorkingDirectory=$PROJECT_DIR
Environment=PATH=$PROJECT_DIR/venv/bin
ExecStart=$PROJECT_DIR/venv/bin/python $PROJECT_DIR/python/run_predictor.py --days 14
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create cron job for regular execution (every 6 hours)
echo "Setting up cron job for regular execution..."
(crontab -l 2>/dev/null; echo "0 */6 * * * cd $PROJECT_DIR && $PROJECT_DIR/venv/bin/python $PROJECT_DIR/python/run_predictor.py --days 14 >> $PROJECT_DIR/dems_ml.log 2>&1") | crontab -

# Create log rotation configuration
echo "Setting up log rotation..."
sudo tee /etc/logrotate.d/dems-ml > /dev/null <<EOF
$PROJECT_DIR/dems_ml.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 $USER $USER
}
EOF

# Set up SSH key authentication (optional)
echo "Setting up SSH key authentication..."
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    echo "SSH key generated. Add the public key to your authorized_keys:"
    cat ~/.ssh/id_rsa.pub
fi

# Create monitoring script
echo "Creating monitoring script..."
tee $PROJECT_DIR/monitor_dems.sh > /dev/null <<'EOF'
#!/bin/bash
# DEMS ML Monitoring Script

PROJECT_DIR="/opt/dems_ml"
LOG_FILE="$PROJECT_DIR/dems_ml.log"

echo "========================================"
echo "DEMS ML System Status"
echo "========================================"
echo "Timestamp: $(date)"
echo ""

# Check if virtual environment exists
if [ -d "$PROJECT_DIR/venv" ]; then
    echo "✅ Virtual environment: OK"
else
    echo "❌ Virtual environment: Missing"
fi

# Check if Python requirements are installed
if [ -f "$PROJECT_DIR/venv/bin/python" ]; then
    echo "✅ Python environment: OK"
else
    echo "❌ Python environment: Missing"
fi

# Check last execution
if [ -f "$LOG_FILE" ]; then
    echo "✅ Log file exists"
    echo "Last execution: $(tail -n 5 $LOG_FILE | head -n 1)"
else
    echo "❌ Log file missing"
fi

# Check cron job
if crontab -l | grep -q "dems_ml"; then
    echo "✅ Cron job: Configured"
else
    echo "❌ Cron job: Not configured"
fi

# Check systemd service
if systemctl is-enabled dems-ml.service >/dev/null 2>&1; then
    echo "✅ Systemd service: Enabled"
else
    echo "⚠️ Systemd service: Not enabled"
fi

echo ""
echo "========================================"
EOF

chmod +x $PROJECT_DIR/monitor_dems.sh

# Create manual execution script
echo "Creating manual execution script..."
tee $PROJECT_DIR/run_manual.sh > /dev/null <<'EOF'
#!/bin/bash
# Manual DEMS ML Execution Script

PROJECT_DIR="/opt/dems_ml"
cd $PROJECT_DIR

echo "========================================"
echo "DEMS ML Manual Execution"
echo "========================================"
echo "Starting at: $(date)"
echo ""

# Activate virtual environment
source venv/bin/activate

# Run the prediction system
echo "Running DEMS ML prediction system..."
python python/run_predictor.py --days 14

echo ""
echo "Execution completed at: $(date)"
echo "========================================"

# Deactivate virtual environment
deactivate
EOF

chmod +x $PROJECT_DIR/run_manual.sh

echo ""
echo "========================================"
echo "Server setup completed!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Copy your project files to: $PROJECT_DIR"
echo "2. Test the setup: $PROJECT_DIR/run_manual.sh"
echo "3. Monitor the system: $PROJECT_DIR/monitor_dems.sh"
echo "4. Enable systemd service: sudo systemctl enable dems-ml.service"
echo "5. Start the service: sudo systemctl start dems-ml.service"
echo ""
echo "The system will automatically run every 6 hours via cron job."
echo "Logs are available at: $PROJECT_DIR/dems_ml.log"
echo ""
