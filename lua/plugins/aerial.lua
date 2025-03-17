local config = {
	"stevearc/aerial.nvim",
	config = function()
		require("aerial").setup({
			backends = { "lsp", "treesitter", "markdown" },
			-- layout = {
			-- 	max_width = { 40, 0.2 },
			-- 	min_width = 20,
			-- },
			close_behavior = "auto",
			filter_kind = false,
			show_guides = true,
		})
	end,
}

return config
