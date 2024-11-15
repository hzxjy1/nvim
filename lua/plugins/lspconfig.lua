local config = {
    "neovim/nvim-lspconfig",
    config = function()
        local lang_conf = lib.module_loader("trinity") -- TODO: Param loaded by conf.lua
        local lspconfig = require("lspconfig")
        fp.map(lang_conf,function (obj)
            lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
        end)
    end
}

return config
