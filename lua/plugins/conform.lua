local util = require("../trinity/util")
local fmt_list = util.formatter_selecter(util.get_conf("trinity"))

local config = {
	"stevearc/conform.nvim",
	config = function()
		vim.api.nvim_create_user_command("Fmt", function()
			require("conform").format({ bufnr = vim.fn.bufnr() })
		end, { desc = "Format the current buffer using conform.nvim" })

		require("conform").setup({ formatters_by_ft = fmt_list })
	end,
}

return config
