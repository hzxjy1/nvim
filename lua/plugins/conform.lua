local config = {
	"stevearc/conform.nvim",
	config = function()
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		--     pattern = "*",
		--     callback = function(args)
		--         require("conform").format({ bufnr = args.buf })
		--     end,
		-- })

		vim.api.nvim_create_user_command("Fmt", function()
			require("conform").format({ bufnr = vim.fn.bufnr() })
		end, { desc = "Format the current buffer using conform.nvim" })

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
			},
		})
	end,
}

return config
