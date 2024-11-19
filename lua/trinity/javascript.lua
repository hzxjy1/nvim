local javascript_conf = {
	name = "javascript",
	lsp = "ts_ls",
	linter = "default",
	formatter = "default",
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
javascript_conf.lsp_setup = function()
	return {
		filetypes = {
			"javascript",
			"typescript",
			-- "vue",
		},
	}
end

return javascript_conf
