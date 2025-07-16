local function on_attach_hook(lspconfig)
	return function(lang_obj)
		local setup = lang_obj.lsp_setup(lspconfig)
		local original_on_attach = setup.on_attach

		setup.on_attach = function(client, bufnr)
			if original_on_attach then
				original_on_attach(client, bufnr)
			end

			if client.supports_method("textDocument/inlayHint") then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end

		return setup
	end
end

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
				lspconfig[obj.lsp].setup(on_attach_hook(lspconfig)(obj))
			end
		end)
	end,
}

return config
