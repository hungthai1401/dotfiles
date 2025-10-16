echo "Setting up Neovim..."

# Check for Neovim and install if we don't have it
if test ! $(which nvim); then
  echo "Please install Neovim first."
  exit 1
fi

echo "Checking for Neovim configuration directory..."
if [ -d "$HOME/.config/nvim" ]; then
  echo "Neovim configuration directory already exists."
else
  echo "Creating Neovim configuration directory..."
  mkdir -p $HOME/.config/nvim
fi

echo "Setting up Neovim configuration..."
if [ -f "$HOME/.config/nvim/init.lua" ]; then
  echo "Neovim configuration already exists."
else
  ln -s $(pwd)/init.lua $HOME/.config/nvim/init.lua
fi

if [ -d "$HOME/.config/nvim/lua" ]; then
  echo "Neovim lua directory already exists."
else
  ln -s $(pwd)/lua $HOME/.config/nvim/lua
fi

echo "Neovim configuration complete!"
