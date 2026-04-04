#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$PROJECT_DIR/.venv"
PYTHON_BIN="python3.13"

echo "🚀 Starting service..."

# 1. Create venv if missing
if [ ! -d "$VENV_DIR" ]; then
    echo "🐍 Creating virtual environment..."
    $PYTHON_BIN -m venv "$VENV_DIR"
fi

# 2. Activate venv
source "$VENV_DIR/bin/activate"

# 3. Update pip + dependencies
echo "📦 Updating dependencies..."
pip install --upgrade pip
pip install --upgrade -r "$PROJECT_DIR/requirements.txt"

# 4. Start server
echo "🌐 Launching server..."
exec python "$PROJECT_DIR/server.py"