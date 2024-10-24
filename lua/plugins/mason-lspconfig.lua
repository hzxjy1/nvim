if not require("lib").module_is_loaded("mason") then
    require("plugins.mason")
end
local mason_lspconfig = require("mason-lspconfig")

local mason_lspconfig_setup = {
    ensure_installed = { "lua_ls", "ts_ls" },
    automatic_installation = true,
}

function mason_lspconfig_setup:clangd_check()
    local lsp = "clangd"
    if os.execute("command -v " .. lsp) ~= 0 then
        table.insert(self.ensure_installed, lsp)
    end
    return self
end

mason_lspconfig.setup(mason_lspconfig_setup:clangd_check())
