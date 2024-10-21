local mason_lspconfig = require("mason-lspconfig")

local mason_lspconfig_setup = {
    ensure_installed = { "lua_ls", "ts_ls" },
    automatic_installation = true,
}
mason_lspconfig.setup(mason_lspconfig_setup)
