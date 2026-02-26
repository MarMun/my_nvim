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
