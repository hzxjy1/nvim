local plugin_list = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
}
-- local module_list = {"mason","lspconfig","mason-lspconfig"}
local module_list = {"mason", "mason-lspconfig"}

require('lazy').setup(plugin_list)

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

Load_and_setup_modules(module_list)

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
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
