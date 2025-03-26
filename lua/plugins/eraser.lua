local config = {
	"hzxjy1/eraser.nvim",
    -- dir = "~/project/sub/eraser.nvim",
	config = function()
		require("eraser").setup({})
	end,
}

return config
