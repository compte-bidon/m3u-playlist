#!/usr/bin/env bash

set -e

# ============================================================
# Configuration
# ============================================================

PRIVATE_REPO="git@github.com:compte-bidon/m3u-tv.git"
PROJECT_DIR="$HOME/m3u-tv"

SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/m3u_tv_deploy_key"
SSH_CONFIG="$SSH_DIR/m3u_tv_config"
KNOWN_HOSTS="$SSH_DIR/m3u_tv_known_hosts"

SSH_HOST="github.com-m3u-tv"


# ============================================================
# Helpers
# ============================================================

echo "========================================"
echo " M3U Playlist Installer"
echo "========================================"
echo ""


# ============================================================
# 1. Install Git and OpenSSH
# ============================================================

echo "📦 Checking dependencies..."

if command -v git >/dev/null 2>&1; then
    echo "✅ Git is already installed"
else
    echo "📦 Installing Git..."

    sudo apt update
    sudo apt install -y git

    echo "✅ Git installed"
fi

if command -v ssh >/dev/null 2>&1; then
    echo "✅ OpenSSH is already installed"
else
    echo "📦 Installing OpenSSH client..."

    sudo apt update
    sudo apt install -y openssh-client

    echo "✅ OpenSSH installed"
fi


# ============================================================
# 2. Create ~/.ssh
# ============================================================

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"


# ============================================================
# 3. Generate dedicated SSH deploy key
# ============================================================

if [ -f "$SSH_KEY" ]; then
    echo "✅ SSH deploy key already exists"
else
    echo "🔐 Generating SSH deploy key..."

    ssh-keygen \
        -t ed25519 \
        -f "$SSH_KEY" \
        -N "" \
        -C "m3u-tv-deploy-key"

    echo "✅ SSH deploy key generated"
fi

chmod 600 "$SSH_KEY"
chmod 644 "${SSH_KEY}.pub"


# ============================================================
# 4. Configure dedicated GitHub known_hosts
# ============================================================

echo "🔐 Checking GitHub host key..."

touch "$KNOWN_HOSTS"
chmod 600 "$KNOWN_HOSTS"

if ssh-keygen -F github.com -f "$KNOWN_HOSTS" >/dev/null 2>&1; then
    echo "✅ github.com is already in dedicated known_hosts"
else
    echo "➕ Adding github.com to dedicated known_hosts..."

    ssh-keyscan -H github.com >> "$KNOWN_HOSTS"

    echo "✅ github.com added to dedicated known_hosts"
fi


# ============================================================
# 5. Configure dedicated SSH config
# ============================================================

echo "⚙️ Configuring dedicated SSH..."

cat > "$SSH_CONFIG" <<EOF
Host $SSH_HOST
    HostName github.com
    User git
    IdentityFile $SSH_KEY
    IdentitiesOnly yes
    UserKnownHostsFile $KNOWN_HOSTS
    StrictHostKeyChecking yes
EOF

chmod 600 "$SSH_CONFIG"

echo "✅ Dedicated SSH configuration ready"


# ============================================================
# 6. Test deploy key access to the private repository
# ============================================================

echo "🔌 Testing GitHub deploy key access..."

if git \
    -c core.sshCommand="ssh -F $SSH_CONFIG" \
    ls-remote "$PRIVATE_REPO" >/dev/null 2>&1; then

    echo "✅ GitHub deploy key has access to m3u-tv"

else

    # ========================================================
    # 7. First-time setup: ask user to add deploy key
    # ========================================================

    echo ""
    echo "========================================"
    echo " ACTION REQUIRED"
    echo "========================================"
    echo ""
    echo "This device is not yet authorized to access"
    echo "the private m3u-tv repository."
    echo ""
    echo "Add the following SSH key as a DEPLOY KEY"
    echo "to the private GitHub repository:"
    echo ""
    echo "  https://github.com/compte-bidon/m3u-tv/settings/keys"
    echo ""
    echo "Public key:"
    echo ""
    cat "${SSH_KEY}.pub"
    echo ""
    echo "========================================"
    echo ""
    echo "IMPORTANT:"
    echo "  - Give the key READ-ONLY access."
    echo "  - Do NOT enable 'Allow write access'."
    echo ""
    echo "After adding the key to GitHub, press ENTER"
    echo "to continue."
    echo ""

    read -r

    # --------------------------------------------------------
    # Test again after the user added the key
    # --------------------------------------------------------

    echo "🔌 Testing GitHub deploy key access again..."

    if git \
        -c core.sshCommand="ssh -F $SSH_CONFIG" \
        ls-remote "$PRIVATE_REPO" >/dev/null 2>&1; then

        echo "✅ GitHub deploy key authorized for m3u-tv"

    else

        echo ""
        echo "❌ GitHub deploy key access failed."
        echo ""
        echo "Make sure that:"
        echo "  1. The public key was added to the"
        echo "     Deploy Keys section of m3u-tv."
        echo "  2. The key was added to the correct repository."
        echo "  3. The key was added as READ-ONLY."
        echo ""
        echo "Once done, run this installation script again."
        echo ""

        exit 1
    fi
fi


# ============================================================
# 8. Clone or update private repository
# ============================================================

echo ""
echo "📂 Checking private repository..."

if [ -d "$PROJECT_DIR/.git" ]; then

    echo "✅ Private repository already exists"
    echo "🔄 Updating repository..."

    git -C "$PROJECT_DIR" \
        -c core.sshCommand="ssh -F $SSH_CONFIG" \
        pull

else

    # If the directory exists but isn't a Git repository,
    # don't overwrite it.
    if [ -e "$PROJECT_DIR" ]; then
        echo ""
        echo "❌ $PROJECT_DIR already exists but is not a Git repository."
        echo "Please remove or rename it before running the installer."
        exit 1
    fi

    echo "📥 Cloning private repository..."

    git \
        -c core.sshCommand="ssh -F $SSH_CONFIG" \
        clone "$PRIVATE_REPO" "$PROJECT_DIR"
fi


# ============================================================
# 9. Configure repository to permanently use deploy key
# ============================================================

echo "⚙️ Configuring repository SSH authentication..."

git -C "$PROJECT_DIR" config \
    core.sshCommand "ssh -F $SSH_CONFIG"

echo "✅ Repository SSH authentication configured"


# ============================================================
# 10. Run private installer
# ============================================================

echo ""
echo "🚀 Running private installer..."
echo ""

exec bash "$PROJECT_DIR/install.sh"