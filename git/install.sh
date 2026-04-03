#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Git configuration..."

# Symlink git config files
rm -rf ~/.gitconfig
rm -rf ~/.config/git/ignore
rm -rf ~/.config/git/hooks
mkdir -p ~/.config/git
ln -s $SCRIPT_DIR/.gitconfig ~/.gitconfig
ln -s $SCRIPT_DIR/ignore ~/.config/git/ignore
ln -s $SCRIPT_DIR/hooks ~/.config/git/hooks

echo "Git configuration complete!"
