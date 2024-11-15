-- TODO: Fix :checkhealth warn & error -> luarocks TODO: Fix clipboard -> copy buffer rsync
-- TODO: Add shell && python && rust support
-- TODO: python need formatter
-- TODO: Need inlay hints especially RUST!!! -> rustaceanvim
-- TODO: Need a plugin for git
-- TODO: Check out what plugins can be loaded lazily -> lazyload clangd
-- TODO: Add ui switch key_binding
-- TODO: fmt while enter normal mode
-- TODO: Add cmd to reload conf manually

---@diagnostic disable: lowercase-global
-- Lowercase for compatibility -- TODO: Del unuseful import
lib = require("lib")
fp = require("functional")

require("key_binding")
local wish_list = {
	--'lukas-reineke/indent-blankline.nvim', -- TODO: Accomplish them
	--'nvim-telescope/telescope.nvim'
	--'lewis6991/gitsigns.nvim'
	--'stevearc/aerial.nvim'
	--'CRAG666/code_runner.nvim'
	--'nvimdev/lspsaga.nvim'
	--"folke/which-key.nvim"
	--'tpope/vim-obsession'
	--'rmagatti/auto-session'
	--"karb94/neoscroll.nvim"
	--"azabiong/vim-highlighter"
}

lib.check_essential(require("conf").essential_bin)

local plugin_path = "plugins"
local plugin_list = lib.module_loader(plugin_path)
if not lib.lazynvim_bootstrap(plugin_list) then
	print("Unable to load plugins")
end
