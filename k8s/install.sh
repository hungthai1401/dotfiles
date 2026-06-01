#!/bin/sh

echo "Setting up kctx..."

# Create /usr/local/bin if it doesn't exist (requires sudo)
if [ ! -d "/usr/local/bin" ]; then
  echo "Creating /usr/local/bin directory (requires sudo)..."
  sudo mkdir -p /usr/local/bin
fi

# Download kctx
if curl -L https://raw.githubusercontent.com/hungthai1401/kctx/main/kctx -o /tmp/kctx; then
  sudo mv /tmp/kctx /usr/local/bin/kctx
  sudo chmod +x /usr/local/bin/kctx
  echo "kctx setup complete!"
else
  echo "Failed to download kctx"
  exit 1
fi
