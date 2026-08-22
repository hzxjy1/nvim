local config = {
	"nvim-tree/nvim-tree.lua",
	event = "BufWinEnter",
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
	},
	config = function()
		require("nvim-tree").setup({
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
		})
	end,
}

return config
