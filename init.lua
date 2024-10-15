local lib = require("lib")
require("key_binding")

local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    --'hrsh7th/nvim-cmp',
    --'lukas-reineke/indent-blankline.nvim',
    'nvim-tree/nvim-tree.lua',
    'akinsho/bufferline.nvim',
}

local module_table = {
    mason = false,
    lspconfig = lib.lspconfig_setup,
    ["mason-lspconfig"] = false,
    ["nvim-tree"] = false,
    bufferline = false,
}

if lib.check_lazynvim(plugin_list) then
    lib.load_and_setup_modules(module_table)
end
