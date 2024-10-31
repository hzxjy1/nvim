local mason_lspconfig_setup = {
    ensure_installed = { "lua_ls", "ts_ls" },
    automatic_installation = true,
}

function mason_lspconfig_setup:clangd_check()
    local lsp = "clangd"
    if os.execute("command -v " .. lsp) ~= 0 then -- TODO: Use func in lib.lua
        table.insert(self.ensure_installed, lsp)
    end
    return self
end

local config = {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup(mason_lspconfig_setup:clangd_check())
    end
}

return config
