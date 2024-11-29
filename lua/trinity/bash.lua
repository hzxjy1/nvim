local bash_conf = {
	name = "bash",
	lsp = "bashls",
	linter = nil,
	formatter = nil,
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#bashls
bash_conf.lsp_setup = function(lspconfig)
	return {
		cmd = { "bash-language-server", "start" },
		settings = {
			bashIde = {
				globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			},
		},
		filetypes = { "bash", "sh" },
		root_dir = lspconfig.util.find_git_ancestor,
		single_file_support = true,
	}
end
return bash_conf
