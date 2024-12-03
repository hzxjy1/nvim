local json_conf = {
	name = "json",
	lsp = "jsonls",
	linter = nil,
	formatter = "biome",
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
json_conf.lsp_setup = function(lspconfig)
	return {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		init_options = {
			provideFormatter = false,
		},
		root_dir = lspconfig.util.find_git_ancestor,
		single_file_support = true,
	}
end

return json_conf
