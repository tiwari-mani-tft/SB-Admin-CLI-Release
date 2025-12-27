#!/bin/bash
set -e

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

case "$OS" in
  linux|darwin) ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

ARCHIVE="sbadmin-$OS-$ARCH.tar.gz"
BIN="sbadmin-$OS-$ARCH"
URL="https://github.com/kha-javed-tft/Selfbest_admin_cli/releases/download/staging-latest/$ARCHIVE"

echo "Downloading sbadmin (staging)..."
curl -fL "$URL" -o "$ARCHIVE"

tar -xzf "$ARCHIVE"
chmod +x "$BIN"
sudo mv "$BIN" /usr/local/bin/sbadmin-staging
rm -f "$ARCHIVE"

echo "✅ sbadmin-staging installed"
sbadmin-staging version
