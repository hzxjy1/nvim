local binding = {}

-- Key binding setup
vim.cmd("set number") -- <F2> will lose efficacy if use "vim.o.number"
vim.cmd("set relativenumber")
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.mouse = "" -- Disable it because I need right click to copy in WSL

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
-- Show number line
map("n", "<F2>", "<cmd>lua require('key_binding').move_roadblock()<CR>", opt)
-- LSP about
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opt) -- TODO: move bindings to plugin setup
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
map("n", "<leader>f", "<cmd>Fmt<CR>", opt)
-- nvim-tree about
map("n", "<C-E>", "<cmd>NvimTreeToggle<CR>", opt)
-- bufferline about
map("n", "<C-h>", "<cmd>BufferLineCyclePrev<CR>", opt)
map("n", "<C-l>", "<cmd>BufferLineCycleNext<CR>", opt)
map("n", "<C-w>", "<cmd>bdelete<CR>", opt)
-- Key binding end

binding.cmp_map = function(module)
	return {
		["<C-n>"] = module.mapping.select_next_item(),
		["<C-p>"] = module.mapping.select_prev_item(),
		["<C-e>"] = module.mapping.close(),
		["<CR>"] = module.mapping.confirm({ select = true, behavior = module.ConfirmBehavior.Replace }),
		["<Tab>"] = module.mapping.select_next_item(),
		["<S-Tab>"] = module.mapping.select_prev_item(),
	}
end

local co = coroutine.create(function()
	local status = true
	local ibl = require("ibl")
	while true do
		status = not status

		if status then
			vim.cmd("set number relativenumber")
		else
			vim.cmd("set nonumber norelativenumber")
		end
		vim.diagnostic.enable(status)
		ibl.update({ enabled = status })

		coroutine.yield()
	end
end)

function binding.move_roadblock()
	coroutine.resume(co)
end

return binding
