local config = {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    -- dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({})
    end
}

return config
