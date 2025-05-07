local util = require("../trinity/util")
local trinity = util.get_conf("trinity")

local function get_install_list()
	if conf.disabled_lsp == nil then
		return trinity
	end

	return lib.unique_array(util.lsp_selecter(fp.filter(trinity, function(item)
		return not lib.is_include(conf.disabled_lsp, item.name)
	end)))
end

local function executable_check(exec_list)
	return function(ensure_installed)
		return fp.filter(ensure_installed, function(item)
			return not (vim.tbl_contains(exec_list, item) and vim.fn.executable(item) == 1)
		end)
	end
end

local mason_lspconfig_setup = {
	ensure_installed = executable_check({ "clangd" })(get_install_list()),
	automatic_installation = true,
}

local config = {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		require("mason-lspconfig").setup(mason_lspconfig_setup)
	end,
}

return config
