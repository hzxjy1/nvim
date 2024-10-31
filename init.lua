-- TODO: Fix :checkhealth warn & error -> luarocks TODO: Fix clipboard -> copy buffer rsync
-- TODO: Add shell && python && rust support
-- TODO: Need inlay hints especially RUST!!! -> rustaceanvim
-- TODO: Need a plugin for git
-- TODO: Check out what plugins can be loaded lazily
local lib = require("lib")
require("key_binding")
local wish_list = {
    --'lukas-reineke/indent-blankline.nvim', -- TODO: Accomplish them
    --'nvim-treesitter/nvim-treesitter' --TODO: Slove it first
    --'nvim-telescope/telescope.nvim'
    --'lewis6991/gitsigns.nvim'
    --'stevearc/aerial.nvim'
    --'CRAG666/code_runner.nvim'
    --'nvimdev/lspsaga.nvim'
    --"folke/which-key.nvim"
    --"folke/todo-comments.nvim"
}

local plugin_path = "plugins_re"
local plugin_list = lib.module_loader(plugin_path)
-- local serpent = require("serpent")
-- print(serpent.block(plugin_list))
if not lib.lazynvim_bootstrap_re(plugin_list) then
    print("Unable to load plugins")
end
