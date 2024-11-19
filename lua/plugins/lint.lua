local config = {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			c = { "clangtidy" },
			cpp = { "clangtidy" },
		}

		-- Linting after the file is saved
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function()
				lint.try_lint()
			end,
		})

		vim.api.nvim_create_user_command("Lint", function()
			print("Linting...")
			lint.try_lint()
		end, {})
	end,
}

return config
