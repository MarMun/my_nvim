#!/bin/bash
os=$(uname)

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

# Check if on release-0.11 branch
git checkout release-0.11 || {
  echo "Failed to switch to release-0.11"
  exit 1
}

# Pull the latest changes
git pull origin release-0.11 || {
  echo "Failed to pull latest updates"
  exit 1
}

# Check for clipboard dependencies
if [ "$os" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo ""
    echo "Homebrew is not installed but required for build dependencies."
    echo ""
    read -p "Install Homebrew automatically? [Y/n]: " response
    if [[ "$response" =~ ^[Yy]$ ]] || [ -z "$response" ]; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null || true
      echo "Homebrew installed. Installing build dependencies..."
      brew install cmake ninja libtool automake pkg-config gettext || {
        echo "Failed to install build dependencies via Homebrew"
        exit 1
      }
    else
      echo "Cannot continue without Homebrew. Exiting."
      exit 1
    fi
  else
    echo "Installing build dependencies with Homebrew..."
    brew install cmake ninja libtool automake pkg-config gettext || {
      echo "Failed to install build dependencies via Homebrew"
      exit 1
    }
  fi
else
  if ! dpkg -l | grep -q "libx11-dev"; then
    echo "Installing X11 clipboard dependencies..."
    sudo apt-get update
    sudo apt-get install -y libx11-dev libxmu-dev libxext-dev || {
      echo "Failed to install X11 dev libraries - clipboard will not work"
    }
  fi
fi

# Clear CMake cache
rm -rf "$NEOVIM_DIR/.deps" "$NEOVIM_DIR/build" || {
  echo "CMake cache clear failed"
  exit 1
}

# Build Neovim with local install prefix and clipboard support
make CMAKE_BUILD_TYPE=Release \
     CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local" \
     DEPS_CMAKE_FLAGS="-DENABLE_XCLIP=ON" || {
  echo "Build failed"
  exit 1
}

# Install Neovim (no sudo needed for local install)
make install || {
  echo "Installation failed"
  exit 1
}

echo "Neovim upset!"
