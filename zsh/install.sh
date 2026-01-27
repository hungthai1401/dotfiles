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

echo "Setting up Zsh configuration..."

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $(pwd)/.zshrc $HOME/.zshrc
ln -s $(pwd)/dracula.zsh-theme $ZSH/themes
ln -s $(pwd)/aliases.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/aliases.zsh
ln -s $(pwd)/path.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/path.zsh
ln -s $(pwd)/tmux.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/tmux.zsh
ln -s $(pwd)/utils.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/utils.zsh
ln -s $(pwd)/fzf.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/fzf.zsh
ln -s $(pwd)/go.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/go.zsh
ln -s $(pwd)/catppuccin_mocha-zsh-syntax-highlighting.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/catppuccin_mocha-zsh-syntax-highlighting.zsh

echo "Installing Oh My Zsh plugins..."

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jessarcher/zsh-artisan.git ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/artisan
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-syntax-highlighting

echo "Zsh setup complete!"
