# .pi Configuration for my_nvim

## Repository Mapping

| Key | Value |
|-----|-------|
| **Repository** | `MarMun/my_nvim` |
| **Local Path** | `~/.my_nvim` |
| **SSH Key** | `~/.ssh/my_nvim-deploy` |
| **Push Command** | `GIT_SSH_COMMAND="ssh -i ~/.ssh/my_nvim-deploy" git push origin main` |

## Project Context

- **Purpose**: Personal Neovim configuration
- **Type**: Dotfiles / Editor config
- **Default Branch**: `main`
- **Plugin Manager**: lazy.nvim (Lua-based)

## Notes

- Uses dedicated deploy key: `my_nvim-deploy`

### Key Directories
- `lua/` - Main config (init.lua, plugins/, core/)
- `after/` - ftplugin overrides
- `backup/` - Session backups (gitignored)

### Preferences
- Keep config modular in `lua/core/`
- Plugins in `lua/plugins/` with lazy-loading
- LSP preferences: TypeScript, Python, Go, Rust

## Key Learnings

### Build System
- **CMake cache clearing required**: When switching branches (0.10 → 0.11), must `rm -rf .deps build/` before rebuilding
- **Local install prefix**: Use `CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"` to avoid sudo
- **Runtime path mismatch**: Binary version must match runtime version. If nvim loads wrong runtime (e.g., `/usr/local/share/nvim/runtime` instead of `~/.local/share/nvim/runtime`), you'll get errors like `attempt to call method 'match' (a nil value)`

### Config Setup
- **Config path**: Neovim expects config at `~/.config/nvim/`. If using custom location (`~/.my_nvim/`), create symlink: `ln -sf ~/.my_nvim ~/.config/nvim`

### Dependencies
- **lazygit required**: `<leader>gg` keymap requires `lazygit` binary installed (not just git). Install to `~/.local/bin/lazygit`
