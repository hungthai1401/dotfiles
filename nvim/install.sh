echo "Setting up Neovim..."

# Check for Neovim and install if we don't have it
if test ! $(which nvim); then
  echo "Please install Neovim first."
  exit 1
fi

echo "Setting up Neovim configuration..."
if [ -f "$HOME/.config/nvim/init.lua" ]; then
  echo "Neovim configuration already exists."
else
  ln -s $(pwd)/init.lua $HOME/.config/nvim/init.lua
fi

if [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
  echo "Neovim lazy-lock.json already exists."
else
  ln -s $(pwd)/lazy-lock.json $HOME/.config/nvim/lazy-lock.json
fi

if [ -d "$HOME/.config/nvim/lua" ]; then
  echo "Neovim lua directory already exists."
else
  ln -s $(pwd)/lua $HOME/.config/nvim/lua
fi

echo "Neovim configuration complete!"
