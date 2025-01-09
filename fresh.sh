#!/bin/sh

echo "Setting up your Mac..."

# Check for Xcode Command Line Tools and install if we don't have it
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait until the installation is done
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    echo "Xcode Command Line Tools installation complete!"
fi

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
ln -s $(pwd)/zsh/path.zsh ${ZSH_CUSTOM:-~/$ZSH/custom}/path.zsh

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/zsh-vi-mode
git clone https://github.com/jessarcher/zsh-artisan.git ${ZSH_CUSTOM:-~/$ZSH/custom}/plugins/artisan

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Force link PHP 8.1
brew link --overwrite --force shivammathur/php/php@8.1

# Set up fzf key bindings and fuzzy completion
$(brew --prefix)/opt/fzf/install

# Install Delve - a debugger for the Go programming language
# See: https://github.com/go-delve/delve
go install github.com/go-delve/delve/cmd/dlv@latest

# Removes .tmux.conf from $HOME (if it exists) and symlinks the .tmux.conf file from the .dotfiles
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf $HOME/.tmux.conf
ln -s $(pwd)/tmux/.tmux.conf $HOME/.tmux.conf

# Symlink the Mackup config file to the home directory
ln -s $(pwd)/.mackup.cfg $HOME/.mackup.cfg
# Symlink the Mackup directory to the home directory
ln -s $(pwd)/mackup $HOME/.mackup

# Symlink git config files
rm -rf ~/.gitconfig
rm -rf ~/.config/git/ignore
rm -rf ~/.config/git/hooks
mkdir -p ~/.config/git
ln -s $(pwd)/git/.gitconfig ~/.gitconfig
ln -s $(pwd)/git/ignore ~/.config/git/ignore
ln -s $(pwd)/git/hooks ~/.config/git/hooks

# Inspired by https://github.com/holman/dotfiles
# find the installers and run them iteratively
#find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos