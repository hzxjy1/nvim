local binding = {}

-- Key binding setup
vim.cmd("set number") -- <F2> will lose efficacy if use "vim.o.number"
vim.cmd("cnoreabbrev Q! q!") -- 手残
-- vim.cmd("set relativenumber")
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.opencode_opts = {}
vim.o.mouse = "" -- Disable it because I need right click to copy in WSL
vim.o.autoread = true
vim.opt.timeoutlen = 1500

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
-- Indent code in visual mode
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)
-- Move the selected text up or down
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)
-- Move up and down four lines
map("n", "<C-j>", "4j", opt)
map("n", "<C-k>", "4k", opt)
-- Save something
map("n", "<C-s>", ":w<CR>", opt)
map("i", "<C-s>", "<Esc>:w<CR>a", opt)
-- Quick quit
map("n", "<BS>", "<Esc>:q<CR>", opt)
-- Show/hide number line
map("n", "<F2>", "<cmd>lua require('tookit/sign_colunm').toggle()<CR>", opt)
-- Quick quit
map("n", "<C-q>", "<cmd>bdelete<CR>", opt)
-- Key binding end

vim.keymap.set("n", "<leader>/", function()
	local orig_reg = vim.fn.getreg('"')
	local orig_regtype = vim.fn.getregtype('"')

	vim.cmd("normal! vawy")

	local word = vim.fn.getreg('"')

	vim.fn.setreg('"', orig_reg, orig_regtype)
	local escaped = vim.fn.escape(word, "[\\/.*$^~[]]")
	escaped = vim.trim(escaped)

	vim.fn.setreg("/", escaped)
	vim.cmd("normal! n")
end, {
	desc = "Search for the current word",
	noremap = true,
	silent = true,
})

-- OSC 52 cilpboard configuration, exclude the vte like gnome terminal
if os.getenv("VTE_VERSION") == nil then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
map("v", "<leader>c", '"+y', opt)

binding.cmp_map = function(module)
	return {
		["<C-e>"] = module.mapping.close(),
		["<CR>"] = module.mapping.confirm({ select = true, behavior = module.ConfirmBehavior.Replace }),
		["<Tab>"] = module.mapping.select_next_item(),
		["<S-Tab>"] = module.mapping.select_prev_item(),
	}
end

return binding
