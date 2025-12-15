#!/bin/bash

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

case "$OS" in
  linux) OS="linux" ;;
  darwin) OS="darwin" ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

BIN="sbadmin-$OS-$ARCH"

echo "⬇️ Downloading $BIN..."

curl -LO "https://github.com/tiwari-mani-tft/SB-Admin-CLI-Release/releases/latest/download/$BIN"
chmod +x "$BIN"
sudo mv "$BIN" /usr/local/bin/sbadmin

echo "🎉 Installation complete!"
sbadmin version
