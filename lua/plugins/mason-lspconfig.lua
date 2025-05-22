local util = require("../trinity/util")
local trinity = util.get_conf("trinity")
local has_npm_dep = require("../tookit/has_npm_dep")

local function get_install_list()
	if conf.disabled_lsp == nil then
		conf.disabled_lsp = {}
	end

	return lib.unique_array(util.lsp_selecter(fp.filter(trinity, function(item)
		return not vim.tbl_contains(conf.disabled_lsp, item.name)
	end)))
end

local function executable_check(exec_list)
	return function(ensure_installed)
		return fp.filter(ensure_installed, function(item)
			return not (vim.tbl_contains(exec_list, item) and vim.fn.executable(item) == 1)
		end)
	end
end

local speculate = [[
    exec_list : ensure_installed :
        return fp.filter(ensure_installed, function(item)
               return not (vim.tbl_contains(exec_list, item) and vim.fn.executable(item) == 1)
        end)
]]

local config = {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local lspconfig = require("mason-lspconfig")
		has_npm_dep.init(lspconfig, require("mason-registry"))

		local mason_lspconfig_setup = {
			ensure_installed = has_npm_dep.filter(true)(executable_check({ "clangd" })(get_install_list())),
			automatic_installation = true,
		}
		-- lib.print(mason_lspconfig_setup.ensure_installed)
		lspconfig.setup(mason_lspconfig_setup)
	end,
}

return config
