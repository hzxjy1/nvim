local config = {
	"hzxjy1/eraser.nvim",
	keys = {
		{ "<leader>ec", "<cmd>EraseCommit<CR>", mode = "v", desc = "Erase commit" },
		{ "<leader>ep", "<cmd>ErasePlus<CR>", mode = "v", desc = "Erase plus" },
	},
	-- dir = "~/project/sub/eraser.nvim",
	config = function()
		require("eraser").setup({ retain_blank = false })
	end,
}

return config
