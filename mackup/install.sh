#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Mackup configuration..."

# Symlink the Mackup config file to the home directory
ln -s $SCRIPT_DIR/.mackup.cfg $HOME/.mackup.cfg
# Symlink the applications directory to the home directory
ln -s $SCRIPT_DIR/applications $HOME/.mackup

echo "Mackup configuration complete!"
