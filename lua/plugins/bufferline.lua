local config = {
	"akinsho/bufferline.nvim",
	event = "BufReadPre",
	keys = {
		{ "<C-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
		{ "<C-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
	},
	-- dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({})
	end,
}

return config
