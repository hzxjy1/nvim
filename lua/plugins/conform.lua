local config = {
	"stevearc/conform.nvim",
	config = function()
		vim.api.nvim_create_user_command("Fmt", function()
			require("conform").format({ bufnr = vim.fn.bufnr() })
		end, { desc = "Format the current buffer using conform.nvim" })

		require("conform").setup({ -- TODO: use trinity
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
			},
		})
	end,
}

return config
