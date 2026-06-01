#!/bin/sh

echo "Setting up kctx..."

# Create /usr/local/bin if it doesn't exist
mkdir -p /usr/local/bin

# Download kctx
if curl -L https://raw.githubusercontent.com/hungthai1401/kctx/main/kctx -o /usr/local/bin/kctx; then
  chmod +x /usr/local/bin/kctx
  echo "kctx setup complete!"
else
  echo "Failed to download kctx"
  exit 1
fi
