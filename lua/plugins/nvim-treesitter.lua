local setup = {
    ensure_installed = { "c", "lua" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    rainbow = { enable = true, extended_mode = true, max_file_lines = nil }
}

local config = {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "p00f/nvim-ts-rainbow" },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup(setup)
    end
}

return config
