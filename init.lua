-- TODO: Fix :checkhealth warn & error -> luarocks TODO: Fix clipboard -> copy buffer rsync
-- TODO: Need inlay hints especially RUST!!! -> rustaceanvim
-- TODO: Add ui switch key_binding
-- TODO: Add cmd to reload conf manually
-- TODO: Use external resp instead of copy
-- TODO: Force save while in non-root
-- TODO: Auto update
-- TODO: Auto format and disable function
-- BUG: Theme will cover line display

---@diagnostic disable: lowercase-global -- Lowercase for compatibility
lib = require("lib")
fp = require("tookit/functional")

require("key_binding")

---@diagnostic disable
local wish_list = {
	-- TODO: Accomplish them

	--'nvim-telescope/telescope.nvim'
	--'stevearc/aerial.nvim'
	--'CRAG666/code_runner.nvim'
	--'nvimdev/lspsaga.nvim'
	--"folke/which-key.nvim"
	--"karb94/neoscroll.nvim"
	--"azabiong/vim-highlighter"
    --"RRethy/vim-illuminate"
}

lib.check_essential(require("conf").essential_bin)

local plugin_path = "plugins"
local plugin_list = lib.module_loader(plugin_path)
if not lib.lazynvim_bootstrap(plugin_list) then
	print("Unable to load plugins")
end

-- Set skin
vim.cmd[[colorscheme monokai-pro-octagon]]

lib.check_update()
