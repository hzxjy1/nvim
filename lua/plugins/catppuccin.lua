local config = {
	"catppuccin/nvim",
	config = function()
		require("catppuccin").setup({})
		if conf.theme == "catppuccin" then
			vim.cmd.colorscheme("catppuccin")
		end
	end,
}

if conf.theme == "catppuccin" then
	config.priority = 1000
end

return config
