local lua_conf = {
    lsp = "lua_ls",
    linter = "default",
    formatter = "default"
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
lua_conf.lsp_setup = function()
    return {
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
return lua_conf
