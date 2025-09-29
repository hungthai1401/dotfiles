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

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Run individual application install scripts
echo "Setting up individual applications..."

# Find and execute all install.sh scripts in subdirectories
for install_script in */install.sh; do
    if [ -f "$install_script" ]; then
        tool_name=$(dirname "$install_script")
        echo "Setting up $tool_name..."
        ./"$install_script"
    fi
done

# Set macOS preferences - we will run this last because this will reload the shell
source ./macos/.macos

echo "Setup complete!"
