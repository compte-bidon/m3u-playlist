#!/usr/bin/env bash

set -e

# ============================================================
# Configuration
# ============================================================

PROJECT_DIR="$HOME/m3u-tv"

SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/m3u_tv_deploy_key"
SSH_CONFIG="$SSH_DIR/m3u_tv_config"
KNOWN_HOSTS="$SSH_DIR/m3u_tv_known_hosts"


# ============================================================
# Helpers
# ============================================================

echo "========================================"
echo " M3U TV Uninstaller"
echo "========================================"
echo ""


# ============================================================
# 1. Run M3U web server repository uninstall script
# ============================================================

if [ -f "$PROJECT_DIR/uninstall.sh" ]; then

    echo "🧹 Running M3U web server uninstall script..."
    echo ""

    bash "$PROJECT_DIR/uninstall.sh"

    echo ""
    echo "✅ M3U web server uninstall completed"

else

    echo "ℹ️ M3U web server uninstall script not found"
    echo "   Skipping M3U web server application cleanup"

fi


# ============================================================
# 2. Remove M3U web server repository
# ============================================================

if [ -d "$PROJECT_DIR" ]; then

    echo "🗑️ Removing M3U web server repository..."

    rm -rf "$PROJECT_DIR"

    echo "✅ M3U web server repository removed"

else

    echo "ℹ️ M3U web server repository already removed"

fi


# ============================================================
# 3. Save public key before removing SSH files
# ============================================================

PUBLIC_KEY=""

if [ -f "${SSH_KEY}.pub" ]; then
    PUBLIC_KEY="$(cat "${SSH_KEY}.pub")"
fi


# ============================================================
# 4. Remove dedicated SSH configuration
# ============================================================

if [ -f "$SSH_CONFIG" ]; then

    echo "⚙️ Removing dedicated SSH configuration..."

    rm -f "$SSH_CONFIG"

    echo "✅ Dedicated SSH configuration removed"

else

    echo "ℹ️ Dedicated SSH configuration already removed"

fi


# ============================================================
# 5. Remove dedicated known_hosts
# ============================================================

if [ -f "$KNOWN_HOSTS" ]; then

    echo "🔐 Removing dedicated GitHub known_hosts..."

    rm -f "$KNOWN_HOSTS"

    echo "✅ Dedicated GitHub known_hosts removed"

else

    echo "ℹ️ Dedicated GitHub known_hosts already removed"

fi


# ============================================================
# 6. Remove dedicated SSH deploy key
# ============================================================

if [ -f "$SSH_KEY" ] || [ -f "${SSH_KEY}.pub" ]; then

    echo "🔑 Removing SSH deploy key..."

    rm -f "$SSH_KEY"
    rm -f "${SSH_KEY}.pub"

    echo "✅ SSH deploy key removed"

else

    echo "ℹ️ SSH deploy key already removed"

fi


# ============================================================
# 7. Warn user about GitHub deploy key
# ============================================================

if [ -n "$PUBLIC_KEY" ]; then

    echo ""
    echo "========================================"
    echo " ⚠️  IMPORTANT: REMOVE DEPLOY KEY"
    echo "========================================"
    echo ""
    echo "The SSH deploy key has been removed from this device."
    echo ""
    echo "However, the public key is still registered on GitHub."
    echo ""
    echo "Please remove this key from the Deploy Keys section"
    echo "of the private m3u-tv repository:"
    echo ""
    echo "  https://github.com/compte-bidon/m3u-tv/settings/keys"
    echo ""
    echo "Public key:"
    echo ""
    echo "  $PUBLIC_KEY"
    echo ""
    echo "⚠️  The local uninstall is complete, but this key"
    echo "    must also be removed from GitHub."
    echo ""
    echo "========================================"
    echo ""
    echo "Press ENTER to continue..."
    read -r </dev/tty

fi


# ============================================================
# Done
# ============================================================

echo ""
echo "========================================"
echo " Uninstallation complete"
echo "========================================"