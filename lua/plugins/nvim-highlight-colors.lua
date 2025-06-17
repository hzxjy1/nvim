local config = {
	"azabiong/vim-highlighter",
	config = function()
		vim.g.Highlighter = {
			colors = {},
			cursor = false,
			file = vim.fn.stdpath("data") .. "/highlighter.json",
		}

		vim.cmd([[hi HiColor1 guifg=#66ccff guibg=NONE gui=underline]])

		vim.g.Highlighter.cursor = false

		local group = vim.api.nvim_create_augroup("AutoHighlight", { clear = true })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			pattern = "*",
			callback = function()
				local word = vim.fn.expand("<cword>")
				if word and word ~= "" then
					vim.cmd("Hi clear")
					vim.cmd("Hi + " .. word)
				end
			end,
		})

		vim.opt.updatetime = 300
	end,
}

return config
