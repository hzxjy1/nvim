local config = {
	"hzxjy1/eraser.nvim",
	-- dir = "~/project/sub/eraser.nvim",
	config = function()
		require("eraser").setup({ retain_blank = false })
	end,
}

return config
