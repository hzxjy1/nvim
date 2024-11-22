local python_conf = {
	name = "python",
	lsp = "pyright",
	linter = nil,
	formatter = "black",
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
python_conf.lsp_setup = function(lspconfig)
	local setup = {
		filetypes = { "python" }, -- TODO: fix nil index bug
		root_dir = lspconfig.util.root_pattern("setup.py", "setup.cfg", "pyproject.toml", ".git"),
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
				},
			},
		},
		single_file_support = true,
	}
	return setup
end

return python_conf
