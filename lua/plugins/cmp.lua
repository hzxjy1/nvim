local binding = require("key_binding")
local cmp = require("cmp")

-- https://github.com/hrsh7th/nvim-cmp/blob/main/README.md#setup
local cmp_setup = {
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
        { name = 'path' }
    })
}


-- module.event:on( -- autopair for functions
--     'confirm_done',
--     require('nvim-autopairs.completion.cmp').on_confirm_done()
-- )
cmp.setup(cmp_setup)
