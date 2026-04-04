#!/usr/bin/env bash

set -e

SETUP_SERVICE="web_m3u_setup"
SERVICE_NAME="m3u_playlist"
GIT_REPO="https://github.com/compte-bidon/m3u-playlist.git"
PROJECT_DIR="$HOME/m3u-playlist"
PYTHON_BIN=""

echo "📁 Project dir: $PROJECT_DIR"

# -----------------------------
# 1. Install Python 3.13 (APT)
# -----------------------------
echo "🐍 Installing/upgrading Python 3.13..."

sudo apt update

sudo apt install -y python3.13 python3.13-venv
echo "✅ Python 3.13 installed and updated"
PYTHON_BIN="$(which python3.13)"
echo "👉 Using Python: $PYTHON_BIN"

# -----------------------------
# 2. Install/upgrade git + clone/pull repo
# -----------------------------
echo "🔧 Installing/upgrading git..."
sudo apt install -y git

echo "📂 Cloning/updating repository..."
if [ -d "$PROJECT_DIR/.git" ]; then
    echo "🔄 Repo already exists, pulling latest..."
    git -C "$PROJECT_DIR" pull
    echo "✅ Repository updated"
else
    git clone "$GIT_REPO" "$PROJECT_DIR"
    echo "✅ Repository cloned"
fi

# -----------------------------
# 3. Install/upgrade unzip
# -----------------------------
echo "📦 Installing/upgrading unzip..."

sudo apt install -y unzip
echo "✅ unzip installed and updated"

# -----------------------------
# 4. Install/upgrade Deno
# -----------------------------
echo "🦕 Installing/upgrading Deno..."

if command -v deno &>/dev/null; then
    echo "🔄 Deno already installed, upgrading..."
    deno upgrade
    echo "✅ Deno upgraded: $(deno --version | head -1)"
else
    curl -fsSL https://deno.land/install.sh | sh -s -- -y
    sudo ln -sf "$HOME/.deno/bin/deno" /usr/local/bin/deno
    echo "✅ Deno installed: $(deno --version | head -1)"
fi

# -----------------------------
# 5. Apply setcap for port 80
# -----------------------------
echo "🔐 Applying capability to bind port 80..."

sudo setcap 'cap_net_bind_service=+ep' "$PYTHON_BIN" || {
    echo "❌ setcap failed. Filesystem may not support capabilities."
    exit 1
}

# -----------------------------
# 6. Create bootup setup service
# -----------------------------
SETUP_FILE="/etc/systemd/system/${SETUP_SERVICE}.service"

echo "⚙️ Creating/updating setup service..."

sudo tee "$SETUP_FILE" > /dev/null <<EOF
[Unit]
Description=${SERVICE_NAME} setup (runs on every boot)
After=network.target
Before=${SERVICE_NAME}.service

[Service]
Type=oneshot
User=$(whoami)
ExecStart=/bin/bash $PROJECT_DIR/install.sh
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable "$SETUP_SERVICE"
echo "✅ Setup service enabled"

# -----------------------------
# 7. Create systemd service for the playlist
# -----------------------------
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "⚙️ Creating/updating systemd service..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=M3U playlist web server
After=network.target ${SETUP_SERVICE}.service
Wants=${SETUP_SERVICE}.service

[Service]
User=$(whoami)
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/start_server.sh
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# -----------------------------
# 8. Reload systemd
# -----------------------------
echo "🔄 Reloading systemd..."
sudo systemctl daemon-reload

# -----------------------------
# 9. Enable & restart
# -----------------------------
echo "🚀 Enabling service..."
sudo systemctl enable "$SERVICE_NAME"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📌 Useful commands:"
echo "----------------------------------------"
echo "Start service:     sudo systemctl start $SERVICE_NAME"
echo "Stop service:      sudo systemctl stop $SERVICE_NAME"
echo "Restart service:   sudo systemctl restart $SERVICE_NAME"
echo "Status:            sudo systemctl status $SERVICE_NAME"
echo "Logs (live):       sudo journalctl -u $SERVICE_NAME -f"
echo "Logs (history):    sudo journalctl -u $SERVICE_NAME"
echo "Disable autostart: sudo systemctl disable $SERVICE_NAME"
echo "----------------------------------------"