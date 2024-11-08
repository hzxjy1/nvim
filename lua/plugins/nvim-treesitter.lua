local config = {
    "nvim-treesitter/nvim-treesitter",
    -- { { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" } },
    config = function()
        require("nvim-treesitter.configs").setup({})
    end
}

return config
