local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
local function lspconfig_setup(module)
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
    ["mason-lspconfig"] = false
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
              { out, "WarningMsg" },
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
