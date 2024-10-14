local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    --'hrsh7th/nvim-cmp',
    'nvim-tree/nvim-tree.lua',
}

-- Key binding setup
vim.wo.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
-- Ctrl+S, you know what it do
map("n", "<C-s>", ":w<CR>", opt)
map("i", "<C-s>", "<Esc>:w<CR>a", opt)
-- Quick quit
map("n", "q", "<Esc>:q<CR>", opt)
-- Lsp about
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opt)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opt)
-- nvim-tree about
map("n", "<C-t>", "<cmd>NvimTreeToggle<CR>", opt)
-- Key binding end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
local lspconfig_setup = function(module)
    module.lua_ls.setup { -- TODO: Install some lsp via lua script
        on_init = function(client)
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT'
                },

                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        "${3rd}/luv/library" -- Related to vim.uv
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    }
end

-- local module_list = {"mason","lspconfig","mason-lspconfig"}
local module_table = {
    mason = false,
    lspconfig = lspconfig_setup,
    ["mason-lspconfig"] = false,
    ["nvim-tree"] = false,
}

-- TODO: Move then to lib.lua
-- https://www.lazyvim.org/configuration/lazy.nvim
local function download_lazynvim(lazypath)
    print("Download lazynvim from github...")
    if not vim.uv.fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
            }, true, {})
            return false
        end
    end
    return true
end

local function check_lazynvim()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    vim.opt.rtp:prepend(lazypath)
    local status, lazy = pcall(require, "lazy")
    if status then
        lazy.setup(plugin_list)
        return true
    else
        return download_lazynvim(lazypath)
    end
end

local function load_and_setup_modules(list)
    for mname, callback in pairs(list) do
        local status, instance = pcall(require, mname)
        if not status then
            vim.notify("Could not find module: " .. mname .. "\nError: " .. instance, vim.log.levels.ERROR)
            return nil
        end

        if not callback then
            instance.setup({})
        else
            callback(instance)
        end
    end
end

if check_lazynvim() then
    load_and_setup_modules(module_table)
end
