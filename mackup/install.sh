#!/bin/sh

echo "Setting up Mackup configuration..."

# Symlink the Mackup config file to the home directory
ln -s $(pwd)/.mackup.cfg $HOME/.mackup.cfg
# Symlink the applications directory to the home directory
ln -s $(pwd)/applications $HOME/.mackup

echo "Mackup configuration complete!"
