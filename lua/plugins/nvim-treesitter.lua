local function get_install_list()
    local lang_conf = lib.module_loader("trinity")
    local list = {}
    fp.map(lang_conf, function(entity)
        if entity.name == 'alias' then
            for _, value in ipairs(entity.alias) do
                table.insert(list, value)
            end
            return
        end
        table.insert(list, entity.name)
    end)
    return list
end

local setup = {
    ensure_installed = get_install_list(),
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    -- rainbow = { enable = true, extended_mode = true, max_file_lines = nil }
}

local config = {
    "nvim-treesitter/nvim-treesitter",
    -- dependencies = { "p00f/nvim-ts-rainbow" }, -- Have a unknown error Vim:E475 in debian12
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup(setup)
    end
}

return config
