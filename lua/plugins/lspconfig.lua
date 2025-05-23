local config = {
	"neovim/nvim-lspconfig",
	config = function()
		local lang_conf = lib.module_loader("trinity") -- HACK: util.get_conf need import
		local lspconfig = require("lspconfig")
		if conf.disabled_lsp == nil then
			conf.disabled_lsp = {}
		end
		fp.map(lang_conf, function(obj)
			if obj.lsp ~= nil and not vim.tbl_contains(conf.disabled_lsp, obj.name) then
				lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
			end
		end)
	end,
}

return config
