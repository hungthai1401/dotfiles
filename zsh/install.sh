#!/bin/sh

echo "Setting up Oh My Zsh..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  echo "Installing Oh My Zsh..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
  echo "Oh My Zsh installation complete!"
else
  echo "Oh My Zsh already installed."
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Zsh configuration..."

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -s $SCRIPT_DIR/dracula.zsh-theme $ZSH/themes
ln -s $SCRIPT_DIR/aliases.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/aliases.zsh
ln -s $SCRIPT_DIR/path.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/path.zsh
ln -s $SCRIPT_DIR/tmux.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/tmux.zsh
ln -s $SCRIPT_DIR/utils.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/utils.zsh
ln -s $SCRIPT_DIR/fzf.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/fzf.zsh
ln -s $SCRIPT_DIR/go.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/go.zsh
ln -s $SCRIPT_DIR/zsh-syntax-highlighting.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/zsh-syntax-highlighting.zsh

echo "Installing Oh My Zsh plugins..."

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jessarcher/zsh-artisan.git ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/artisan
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-syntax-highlighting

echo "Zsh setup complete!"
