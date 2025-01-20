local settings = {
	use_luarocks = true,
	essential_bin = { "luarocks", "npm", "git", "rg", "black", "stylua" }, -- TODO: Interact with trinity
	_disable_lsp = {},
}

function settings:get_disable_lsp()
	return fp.map(self._disable_lsp, function(e)
		if e == "c" or e == "cpp" then
			return "alias"
		else
			return e
		end
	end)
end

return settings
