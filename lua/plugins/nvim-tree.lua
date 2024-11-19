local config = {
	"nvim-tree/nvim-tree.lua",
	event = "BufWinEnter",
	config = function()
		require("nvim-tree").setup({})
	end,
}

return config
