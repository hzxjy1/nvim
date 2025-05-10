local config = {
	"hzxjy1/config-sync.nvim",
	-- dir = "~/project/sub/config-sync.nvim",
	config = function()
		require("config-sync").setup({ target_branch = "master" })
	end,
}

return config
