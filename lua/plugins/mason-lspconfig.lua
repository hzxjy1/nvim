local util = require("../trinity/util")
local trinity = util.get_conf("trinity")

local function get_install_list()
	local disabled_lsp = fp.map(conf.disabled_lsp, function(e)
		if e == "c" or e == "cpp" then
			return "alias"
		else
			return e
		end
	end)

	local filterd_trinity = fp.filter(trinity, function(item)
		if lib.is_include(disabled_lsp, item.name) then
			return false
		end
		return true
	end)

	return util.lsp_selecter(filterd_trinity)
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
