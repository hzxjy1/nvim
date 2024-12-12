-- TODO: Use Gitsigns toggle_signs in <F2>
local config = {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({ current_line_blame = true, numhl = true })
	end,
}

return config
