local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}
-- local module_list = {"mason","lspconfig","mason-lspconfig"}
local module_list = {"mason", "mason-lspconfig"}

function Check_lazynvim()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    vim.opt.rtp:prepend(lazypath)
    local status, lazy = pcall(require, "lazy")
    if status then
	print("load lazy")
        lazy.setup(plugin_list)
	return true
    else
	return Download_lazynvim(lazypath)
    end
end

-- https://www.lazyvim.org/configuration/lazy.nvim
function Download_lazynvim(lazypath)
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
end

function Load_and_setup_modules(list)
    for _, mname in ipairs(list) do
        local status, instance = pcall(require, mname)
        if not status then
            vim.notify("Could not find module: " .. mname .. "\nError: " .. instance, vim.log.levels.ERROR)
            return nil
        end

        instance.setup({}) -- TODO: Add setup() parameters if needed.
    end
end

if Check_lazynvim() then
    Load_and_setup_modules(module_list)
end


-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
require("lspconfig").lua_ls.setup { -- TODO: Install some lsp via lua script
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
