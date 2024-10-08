require('lazy').setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
})

local status, mason = pcall(require, "mason")
if not status then
	vim.notify("Could not find meson.")
	return
end

local status, lspconfig = pcall(require, "lspconfig")
if not status then
	vim.notify("Could not find meson.")
	return
end

local status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status then
	vim.notify("Could not find meson.")
	return
end

mason.setup({})
lspconfig.setup({})
mason_lspconfig.setup({})

