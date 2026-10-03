```bash
#!/usr/bin/env bash

set -e

# ============================================================
# Configuration
# ============================================================

PROJECT_DIR="$HOME/m3u-tv"

SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/m3u_tv_deploy_key"
SSH_CONFIG="$SSH_DIR/config"
KNOWN_HOSTS="$SSH_DIR/known_hosts"

SSH_HOST="github.com-m3u-tv"


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
# 3. Remove dedicated SSH configuration
# ============================================================

if [ -f "$SSH_CONFIG" ]; then

    echo "⚙️ Removing dedicated SSH configuration..."

    TEMP_CONFIG="$(mktemp)"

    awk -v host="$SSH_HOST" '
        BEGIN { skip=0 }

        $0 == "Host " host {
            skip=1
            next
        }

        /^Host / {
            skip=0
        }

        !skip {
            print
        }
    ' "$SSH_CONFIG" > "$TEMP_CONFIG"

    cat "$TEMP_CONFIG" > "$SSH_CONFIG"
    rm -f "$TEMP_CONFIG"

    echo "✅ SSH configuration cleaned"

else

    echo "ℹ️ SSH config not found"

fi


# ============================================================
# 4. Save and remove dedicated SSH deploy key
# ============================================================

PUBLIC_KEY=""

if [ -f "${SSH_KEY}.pub" ]; then
    PUBLIC_KEY="$(cat "${SSH_KEY}.pub")"
fi

if [ -f "$SSH_KEY" ] || [ -f "${SSH_KEY}.pub" ]; then

    echo "🔑 Removing SSH deploy key..."

    rm -f "$SSH_KEY"
    rm -f "${SSH_KEY}.pub"

    echo "✅ SSH deploy key removed"

else

    echo "ℹ️ SSH deploy key already removed"

fi


# ============================================================
# 5. Warn user about GitHub deploy key
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
    echo "Please make sure you remove this key from the"
    echo "Deploy Keys section of the private m3u-tv repository:"
    echo ""
    echo "  https://github.com/compte-bidon/m3u-tv/settings/keys"
    echo ""
    echo "Public key:"
    echo ""
    echo "  $PUBLIC_KEY"
    echo ""
    echo "⚠️  Make sure this key is deleted from GitHub before"
    echo "    considering the uninstall completely finished."
    echo ""
    echo "========================================"
    echo ""
    echo "Press ENTER to continue..."
    read -r

fi


# ============================================================
# 6. Remove GitHub known_hosts entry
# ============================================================

if [ -f "$KNOWN_HOSTS" ]; then

    echo "🔐 Removing dedicated GitHub known_hosts entry..."

    ssh-keygen -R github.com -f "$KNOWN_HOSTS" >/dev/null 2>&1 || true

    if [ -s "$KNOWN_HOSTS" ]; then
        echo "✅ GitHub known_hosts entry cleaned"
    else
        rm -f "$KNOWN_HOSTS"
        echo "✅ known_hosts removed"
    fi

else

    echo "ℹ️ known_hosts file not found"

fi


# ============================================================
# 7. Clean empty ~/.ssh directory
# ============================================================

if [ -d "$SSH_DIR" ]; then

    rmdir "$SSH_DIR" 2>/dev/null || true

fi


# ============================================================
# Done
# ============================================================

echo ""
echo "========================================"
echo " Uninstallation complete"
echo "========================================"
```