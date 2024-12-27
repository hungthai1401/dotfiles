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
ln -sw $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -sw $(pwd)/zsh/dracula.zsh-theme "$ZSH/themes"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-autosuggestions

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Symlink the Mackup config file to the home directory
ln -s $(pwd)/.mackup.cfg $HOME/.mackup.cfg
# Symlink the Mackup directory to the home directory
ln -s $(pwd)/mackup $HOME/.mackup

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos