#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up tmux configuration..."

# Removes .tmux.conf from $HOME (if it exists) and symlinks the .tmux.conf file from the .dotfiles
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf $HOME/.tmux.conf
ln -s $SCRIPT_DIR/.tmux.conf $HOME/.tmux.conf

echo "tmux configuration complete!"
