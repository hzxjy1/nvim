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

local mason_lspconfig_setup = {
	ensure_installed = get_install_list(),
	automatic_installation = true,
}

function mason_lspconfig_setup:clangd_check()
	local lsp = "clangd"
	if lib.is_executable(lsp) then
		for i, item in ipairs(self.ensure_installed) do
			if item == lsp then
				table.remove(self.ensure_installed, i)
				break
			end
		end
	end
	return self
end

local config = {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		require("mason-lspconfig").setup(mason_lspconfig_setup:clangd_check())
	end,
}

return config
