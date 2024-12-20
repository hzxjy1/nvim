local config = {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({ enabled = true, suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" } })
	end,
}

return config
