local config = {
	"folke/todo-comments.nvim",
	config = function()
		require("todo-comments").setup({
			keywords = {
				FIX = { icon = "🔧", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = "📝", color = "info" },
				HACK = { icon = "⚡", color = "warning" },
				WARN = { icon = "⚠️", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "🚀", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "ℹ️", color = "hint", alt = { "INFO" } },
				TEST = { icon = "🧪", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		})
	end,
}

return config
