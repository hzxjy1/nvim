local python_conf = {
    lsp = "pyright",
    linter = "pylint",
    formatter = "default"
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
function python_conf.lsp_setup(lspconfig)
    local setup = {
        filetypes = { "python" }, -- TODO: fix nil index bug
        root_dir = lspconfig.util.root_pattern("setup.py", "setup.cfg", "pyproject.toml", ".git"),
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = true,
                },
            },
        },
        single_file_support = true,
    }
    return setup
end

return python_conf
