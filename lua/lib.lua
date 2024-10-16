local lib = {}

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

function lib.check_lazynvim(plugin_list)
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

function lib.load_and_setup_modules(list)
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

-- TODO: Move to setup.lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
lib.lspconfig_setup = function(module)
    module.lua_ls.setup({ -- TODO: Install some lsp via lua script
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
    })
end

-- https://github.com/hrsh7th/nvim-cmp/blob/main/README.md#setup
lib.cmp_setup = function(module)
    local temp_setting = {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
        },
        sources = module.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        })
    }

    module.setup(temp_setting)
end

return lib
