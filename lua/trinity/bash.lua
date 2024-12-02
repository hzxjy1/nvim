local bash_conf = {
	name = "bash",
	lsp = "bashls",
	linter = "shellcheck",
	formatter = "shfmt",
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

-- https://github.com/stevearc/conform.nvim/issues/424
bash_conf.self_setup = function()
	vim.api.nvim_create_autocmd("BufRead", {
		pattern = "*.sh",
		command = "set filetype=bash",
	})

	vim.api.nvim_create_autocmd("BufNewFile", {
		pattern = "*.sh",
		command = "set filetype=bash",
	})
end

return bash_conf
