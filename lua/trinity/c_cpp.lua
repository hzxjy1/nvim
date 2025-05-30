local c_cpp_conf = {
	name = "alias",
	alias = { "c", "cpp" },
	lsp = "clangd",
	linter = "clangtidy",
	formatter = "clang-format",
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
c_cpp_conf.lsp_setup = function(lspconfig)
	return {
		filetypes = { "c", "cpp" },
		root_dir = lspconfig.util.root_pattern(
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			".git"
		),
		single_file_support = true,
	}
end

return c_cpp_conf
