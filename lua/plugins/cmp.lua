local binding = require("key_binding")
local require_list = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    -- Snip
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
}

-- https://github.com/hrsh7th/nvim-cmp/blob/main/README.md#setup
local cmp_setup = function(cmp)
    return {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        mapping = binding.cmp_map(cmp),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'cmdline' }
        })
    }
end

local config = {
    "hrsh7th/nvim-cmp",
    dependencies = require_list,
    config = function()
        local cmp = require("cmp")
        cmp.setup(cmp_setup(cmp))

        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })

        cmp.setup.cmdline(":", cmp.get_config())
        cmp.event:on( -- autopair for functions
            'confirm_done',
            require('nvim-autopairs.completion.cmp').on_confirm_done()
        )
    end
}

return config
