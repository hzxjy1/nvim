-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
local lua_ls_setup = {
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

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
local ts_ls_setup = {
    filetypes = {
        "javascript",
        "typescript",
        -- "vue",
    },
}

local config = {
    "neovim/nvim-lspconfig",
    config = function()
        local lang_conf = require("lib").module_loader("trinity") -- TODO: Param loaded by conf.lua
        local lspconfig = require("lspconfig")
        local fp = require("functional")
        fp.map(lang_conf,function (obj)
            lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
        end)
        lspconfig.lua_ls.setup(lua_ls_setup)
        lspconfig.ts_ls.setup(ts_ls_setup)
    end
}

return config
