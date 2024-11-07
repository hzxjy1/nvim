local config = {
    "neovim/nvim-lspconfig",
    config = function()
        local lang_conf = require("lib").module_loader("trinity") -- TODO: Param loaded by conf.lua
        local lspconfig = require("lspconfig")
        local fp = require("functional")
        fp.map(lang_conf,function (obj)
            lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
        end)
    end
}

return config
