-- TODO: <C-r>w close buffer
-- TODO：Resume tabs when enter a project
-- TODO: Fix :checkhealth warn & error
local lib = require("lib")
require("key_binding")

local nvim_cmp = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
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
    --'lukas-reineke/indent-blankline.nvim', -- TODO: Accomplish them -- TODO: Need plugin_list classification
    --'nvim-treesitter/nvim-treesitter'
    --'nvim-telescope/telescope.nvim'
    --'lewis6991/gitsigns.nvim'
    --'stevearc/aerial.nvim'
    --'CRAG666/code_runner.nvim'
}

local lua_modules = { "mason", "lspconfig", "mason-lspconfig", "nvim-tree", "bufferline", "cmp", "nvim-autopairs" }

if lib.check_lazynvim(plugin_list) then
    lib.load_modules(lua_modules)
end
