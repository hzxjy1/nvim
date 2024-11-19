-- TODO: Add docker support
local config = {
	"amitds1997/remote-nvim.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("remote-nvim").setup({})
	end,
}

return config
