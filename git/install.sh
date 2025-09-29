#!/bin/sh

echo "Setting up Git configuration..."

# Symlink git config files
rm -rf ~/.gitconfig
rm -rf ~/.config/git/ignore
rm -rf ~/.config/git/hooks
mkdir -p ~/.config/git
ln -s $(pwd)/.gitconfig ~/.gitconfig
ln -s $(pwd)/ignore ~/.config/git/ignore
ln -s $(pwd)/hooks ~/.config/git/hooks

echo "Git configuration complete!"
