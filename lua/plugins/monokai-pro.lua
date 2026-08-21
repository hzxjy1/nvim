local config = {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup({})
		if conf.theme == "monokai-pro" then
			vim.cmd.colorscheme("monokai-pro")
		end
	end,
}

if conf.theme == "monokai-pro" then
	config.priority = 1000
end

return config
