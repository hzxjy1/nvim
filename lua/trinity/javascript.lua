local javascript_conf = {
	name = "alias",
	alias = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
	lsp = "ts_ls",
	linter = nil,
	formatter = "biome",
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
javascript_conf.lsp_setup = function()
	return {
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
	}
end

return javascript_conf
