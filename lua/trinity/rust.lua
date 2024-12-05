local rust_conf = {
	name = "rust",
	lsp = "rust_analyzer",
	linter = "clippy",
	formatter = "rustfmt",
}

rust_conf.lsp_setup = function()
    -- "root_dir" is too complex
	return {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		single_file_support = true,
		capabilities = {
			experimental = {
				serverStatusNotification = true,
			},
		},
	}
end

return rust_conf
