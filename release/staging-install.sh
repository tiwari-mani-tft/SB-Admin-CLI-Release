#!/bin/bash
set -e

REPO="kha-javed-tft/Selfbest_admin_cli"

# -----------------------------
# Detect OS / ARCH
# -----------------------------
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

case "$OS" in
  linux|darwin) ;;
  *) echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

ARCHIVE="sbadmin-$OS-$ARCH.tar.gz"
BIN="sbadmin-$OS-$ARCH"

# -----------------------------
# Find latest pre-release
# -----------------------------
echo "🔍 Detecting latest sbadmin pre-release..."

TAG=$(curl -s "https://api.github.com/repos/$REPO/releases" \
  | grep '"prerelease": true' -B 5 \
  | grep '"tag_name"' \
  | head -n1 \
  | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$TAG" ]; then
  echo "❌ No pre-release found for sbadmin"
  exit 1
fi

echo "🏷️  Found pre-release tag: $TAG"

URL="https://github.com/$REPO/releases/download/$TAG/$ARCHIVE"

# -----------------------------
# Download & install
# -----------------------------
echo "⬇️  Downloading sbadmin (staging)..."
curl -fL "$URL" -o "$ARCHIVE"

echo "📦 Extracting..."
tar -xzf "$ARCHIVE"

chmod +x "$BIN"
sudo mv "$BIN" /usr/local/bin/sbadmin-staging
rm -f "$ARCHIVE"

echo "✅ sbadmin-staging installed successfully"
sbadmin-staging version
