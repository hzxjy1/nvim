-- In Archlinux WSL2. The configuration of luasnip take effect only after a restart of WSL.
local config = {
    "L3MON4D3/LuaSnip",
    config = function()
        local luasnip = require("luasnip")
        require('luasnip.loaders.from_vscode').load()
        luasnip.setup({})
    end
}

return config
