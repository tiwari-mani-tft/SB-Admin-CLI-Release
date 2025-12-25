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
  linux) OS="linux" ;;
  darwin) OS="darwin" ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

ARCHIVE="sbadmin-$OS-$ARCH.tar.gz"
BIN="sbadmin-$OS-$ARCH"
URL="https://github.com/tiwari-mani-tft/SB-Admin-CLI-Release/releases/latest/download/$ARCHIVE"

echo "Downloading $ARCHIVE..."
curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE"

chmod +x "$BIN"
sudo mv "$BIN" /usr/local/bin/sbadmin

rm -f "$ARCHIVE"

echo "Binary installed at /usr/local/bin/sbadmin"

# ---------------------------------------------------
# 🔥 COMPLETION SETUP
# ---------------------------------------------------

echo "Setting up shell completion..."

# Bash completion
if [ -n "$BASH_VERSION" ]; then
  COMPLETION_DIR="$HOME/.bash_completion.d"
  mkdir -p "$COMPLETION_DIR"
  sbadmin completion bash > "$COMPLETION_DIR/sbadmin"

  # Ensure bash loads completion scripts
  if ! grep -q "bash_completion.d" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# sbadmin bash completion
for f in ~/.bash_completion.d/*; do
  [ -r "$f" ] && source "$f"
done
EOF
  fi

  echo "✔ Bash completion installed"
fi

# Zsh completion
if [ -n "$ZSH_VERSION" ]; then
  COMPLETION_DIR="$HOME/.zsh/completions"
  mkdir -p "$COMPLETION_DIR"
  sbadmin completion zsh > "$COMPLETION_DIR/_sbadmin"

  if ! grep -q "compinit" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" <<'EOF'

# sbadmin zsh completion
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit
EOF
  fi

  echo "✔ Zsh completion installed"
fi

echo "Installation complete 🎉"
echo "Restart your terminal or run: exec \$SHELL"

sbadmin version
