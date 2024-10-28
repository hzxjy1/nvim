-- TODO: Fix :checkhealth warn & error --> luarocks
-- TODO: Add shell support
-- TODO: Need a plugin for git
local lib = require("lib")
require("key_binding")

local nvim_cmp = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline", -- Might unused
        -- Snip
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets"
    }
}

local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    nvim_cmp,
    'nvim-tree/nvim-tree.lua',
    'akinsho/bufferline.nvim',
    'windwp/nvim-autopairs',
    'mfussenegger/nvim-lint',
    --'lukas-reineke/indent-blankline.nvim', -- TODO: Accomplish them -- TODO: Need plugin_list classification
    --'nvim-treesitter/nvim-treesitter' First slove
    --'nvim-telescope/telescope.nvim'
    --'lewis6991/gitsigns.nvim'
    --'stevearc/aerial.nvim'
    --'CRAG666/code_runner.nvim'
    --'nvimdev/lspsaga.nvim'
}
-- TODO: Auto load plugins
local lua_modules = { "mason", "lspconfig", "mason-lspconfig", "nvim-tree", "bufferline", "cmp", "nvim-autopairs",
    "luasnip", "lint" }

local serpent = require("serpent")
local ret = lib.module_loader("plugins_re")
print(serpent.block(ret))

if lib.lazynvim_bootstrap(plugin_list) then
    lib.load_modules("plugins", lua_modules)
end
