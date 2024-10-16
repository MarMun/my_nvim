#!/bin/bash
# Path to your local Neovim repository
NEOVIM_DIR="./neovim_repository"

# Clone the Neovim repository if the directory doesn't exist
if [ ! -d "$NEOVIM_DIR" ]; then
  echo "Cloning Neovim repository..."
  git clone https://github.com/neovim/neovim.git "$NEOVIM_DIR"
fi

# Navigate to the Neovim repository
cd "$NEOVIM_DIR" || {
  echo "Neovim directory not found!"
  exit 1
}

# Check if on release-0.10 branch
git checkout release-0.10 || {
  echo "Failed to switch to release-0.10"
  exit 1
}

# Pull the latest changes
git pull origin release-0.10 || {
  echo "Failed to pull latest updates"
  exit 1
}

# Clear CMake cache
rm -rf "$NEOVIM_DIR/.deps" "$NEOVIM_DIR/build" || {
  echo "CMake cache clear failed"
  exit 1
}

# Build Neovim
make CMAKE_BUILD_TYPE=Release || {
  echo "Build failed"
  exit 1
}

# Install Neovim
sudo make install || {
  echo "Installation failed"
  exit 1
}

echo "Neovim upset!"
