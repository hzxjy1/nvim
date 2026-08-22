local config = {
	"nickjvandyke/opencode.nvim",
	version = "*",
	keys = {
		{
			"<leader>oa",
			function() require("opencode").ask("@this: ", { submit = true }) end,
			mode = { "n", "x" },
			desc = "Ask opencode",
		},
	},
}

return config
