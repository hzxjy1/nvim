-- TODO: Add a cmd to strip code commit
-- TODO: Add a cmd to reload conf manually
-- TODO: Use external resp instead of copy <- Might hard to distribute
-- TODO: Force save while in non-root
-- TODO: Auto format and disable function
-- TODO: Can exec shell in nvim
-- TODO: Repair icons
-- TODO: Check npm before some lsp install
-- TODO: Lazy install lsp
-- BUG: Theme will cover line display
-- BUG: Colorscheme does not check if the theme exist
-- BUG: Update check be affected by diffierent branch

---@diagnostic disable: lowercase-global -- Lowercase for compatibility
lib = require("lib")
fp = require("tookit/functional")
conf = require("conf")

require("key_binding")

---@diagnostic disable
local wish_list = {
	-- TODO: Accomplish them

	--'nvim-telescope/telescope.nvim'
	--'stevearc/aerial.nvim'
	--'nvimdev/lspsaga.nvim'
	--"folke/which-key.nvim"
	--"karb94/neoscroll.nvim"
	--"azabiong/vim-highlighter"
	--"RRethy/vim-illuminate"
}

lib.check_essential(conf.essential_bin)

local plugin_path = "plugins"
local plugin_list = lib.module_loader(plugin_path)
if not lib.lazynvim_bootstrap(plugin_list) then
	print("Unable to load plugins")
end

-- Set skin
vim.cmd([[colorscheme monokai-pro-octagon]])

lib.check_update()
