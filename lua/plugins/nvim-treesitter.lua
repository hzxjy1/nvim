local util = require("../trinity/util")
local not_a_lang = { "javascriptreact", "typescriptreact" }
local name_list = fp.map(util.name_selecter(util.get_conf("trinity")), function(e)
	if not lib.is_include(not_a_lang, e) then
		return e
	end
end)

local setup = {
	ensure_installed = name_list,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	-- rainbow = { enable = true, extended_mode = true, max_file_lines = nil }
}

local config = {
	"nvim-treesitter/nvim-treesitter",
	-- dependencies = { "p00f/nvim-ts-rainbow" }, -- Have a unknown error Vim:E475 in debian12
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup(setup)
	end,
}

return config
