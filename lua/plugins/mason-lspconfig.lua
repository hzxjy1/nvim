local util = require("../trinity/util")
local install_list = util.lsp_selecter(util.get_conf("trinity"))

local mason_lspconfig_setup = {
	ensure_installed = install_list,
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
