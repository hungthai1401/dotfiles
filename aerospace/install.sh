#!/bin/sh

echo "Setting up AeroSpace configuration..."

# Symlink AeroSpace config file
ln -s $(pwd)/.aerospace.toml $HOME/.aerospace.toml

echo "AeroSpace configuration complete!"
