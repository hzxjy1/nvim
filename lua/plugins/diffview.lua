local config = {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({ use_icons = false })
	end,
}

return config
