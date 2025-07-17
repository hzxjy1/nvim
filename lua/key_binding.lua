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
vim.o.mouse = "" -- Disable it because I need right click to copy in WSL
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
-- LSP
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opt)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
map("n", "gH", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
map("n", "<leader>f", "<cmd>Fmt<CR>", opt)
-- nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opt)
-- bufferline
map("n", "<C-h>", "<cmd>BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", "<cmd>BufferLineCycleNext<CR>", opt)
map("n", "<C-q>", "<cmd>bdelete<CR>", opt)
-- code runner
map("n", "<leader>rr", "<cmd>wa<CR><cmd>RunCode<CR>", opt)
-- erase
map("v", "<leader>ec", "<cmd>EraseCommit<CR>", opt)
map("v", "<leader>ep", "<cmd>ErasePlus<CR>", opt)
-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opt)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opt)
map("n", "<leader>fa", "<cmd>Telescope aerial<cr>", opt)
-- aerial
map("n", "<leader>cs", "<cmd>AerialToggle<CR>", opt)
-- bookmarks
map("n", "<leader>mm", "<cmd>lua require('bookmarks').bookmark_toggle()<CR>", opt)
map("n", "<leader>mn", "<cmd>lua require('bookmarks').bookmark_next()<CR>", opt)
map("n", "<leader>mp", "<cmd>lua require('bookmarks').bookmark_prev()<CR>", opt)
-- gitsigns
map("v", "<leader>rh", "<cmd>lua require('gitsigns').reset_hunk()<CR>", opt)
map("n", "<leader>nh", "<cmd>lua require('gitsigns').next_hunk()<CR>", opt)
map("n", "<leader>ph", "<cmd>lua require('gitsigns').prev_hunk()<CR>", opt)
-- which-key
map("n", "<leader>?", "<cmd>lua require('which-key').show({ global = false })<CR>", opt)
-- diffview
map("n", "<leader>do", "<cmd>DiffviewOpen<CR>", opt)
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", opt)
-- Key binding end

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
