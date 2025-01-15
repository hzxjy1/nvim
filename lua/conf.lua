local settings = {
	use_luarocks = true,
	essential_bin = { "luarocks", "npm", "git", "rg", "black", "stylua" }, -- TODO: Interact with trinity
	disable_lsp = {},
}

return settings
