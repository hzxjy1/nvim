local config = {
	"neovim/nvim-lspconfig",
	config = function()
		local lang_conf = lib.module_loader("trinity") -- HACK: util.get_conf need import
		local lspconfig = require("lspconfig")
		fp.map(lang_conf, function(obj)
			if obj.lsp ~= nil and not lib.is_include(conf.disabled_lsp, obj.name) then
				lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
			end
		end)
	end,
}

return config
