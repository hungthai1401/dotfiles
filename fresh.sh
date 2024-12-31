#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -s $(pwd)/zsh/dracula.zsh-theme $ZSH/themes
ln -s $(pwd)/zsh/aliases.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/aliases.zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-autosuggestions

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Force link PHP 8.1
brew link --overwrite --force shivammathur/php/php@8.1

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Removes .tmux.conf from $HOME (if it exists) and symlinks the .tmux.conf file from the .dotfiles
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf $HOME/.tmux.conf
ln -s $(pwd)/tmux/.tmux.conf $HOME/.tmux.conf

# Symlink the Mackup config file to the home directory
ln -s $(pwd)/.mackup.cfg $HOME/.mackup.cfg
# Symlink the Mackup directory to the home directory
ln -s $(pwd)/mackup $HOME/.mackup

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos