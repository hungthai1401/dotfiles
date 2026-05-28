#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up AeroSpace configuration..."

# Symlink AeroSpace config file
ln -s $SCRIPT_DIR/.aerospace.toml $HOME/.aerospace.toml

echo "AeroSpace configuration complete!"
