local config = {
	"tomasky/bookmarks.nvim",
	config = function()
		local bookmarks = require("bookmarks")
		-- This function fixes a bug that could prevent icons from loading properly
		vim.api.nvim_create_autocmd("LspAttach", {
			pattern = "*",
			callback = function()
				bookmarks.refresh()
			end,
			desc = "Initialize bookmarks on first load",
		})
		bookmarks.setup({ save_file = vim.fn.stdpath("data") .. "/bookmarks" })
	end,
}

return config
