#!/bin/bash
set -e

TAG="${1:-latest}"

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

URL="https://github.com/kha-javed-tft/Selfbest_admin_cli/releases/download/$TAG/$ARCHIVE"

echo "Downloading sbadmin ($TAG)..."
curl -fL "$URL" -o "$ARCHIVE"

tar -xzf "$ARCHIVE"
chmod +x "$BIN"

TARGET="sbadmin"
if [[ "$TAG" == staging* ]]; then
  TARGET="sbadmin-staging"
fi

sudo mv "$BIN" /usr/local/bin/$TARGET
rm -f "$ARCHIVE"

echo "✅ Installed $TARGET ($TAG)"
$TARGET version
