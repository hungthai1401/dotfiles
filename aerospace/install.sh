#!/bin/sh

echo "Setting up AeroSpace configuration..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Symlink AeroSpace config file
ln -s "$SCRIPT_DIR/.aerospace.toml" "$HOME/.aerospace.toml"

echo "AeroSpace configuration complete!"
