-- ~/.config/nvim/lua/plugins/rustaceanvim.lua
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- optional
    ft = { "rust" }, -- optional, lazy-load on Rust files
    rocks = { enabled = false }, -- <— turn off LuaRocks
  },
}
