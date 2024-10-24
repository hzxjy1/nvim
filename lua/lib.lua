local lib = {}

-- https://www.lazyvim.org/configuration/lazy.nvim
local function download_lazynvim(lazypath)
    print("Download lazynvim from github...")
    if not vim.uv.fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
            }, true, {})
            return false
        end
    end
    return true
end

function lib.lazynvim_bootstrap(plugin_list)
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    vim.opt.rtp:prepend(lazypath)
    local status, lazy = pcall(require, "lazy")
    if status then
        lazy.setup(plugin_list)
        return true
    else
        return download_lazynvim(lazypath)
    end
end

function lib.load_modules(modules_path, modules_list)
    -- if modules_list == nil then
        -- TODO: Wait luarocks
        -- local lfs = require("lfs")
    -- end

    for _, module in ipairs(modules_list) do
        require(modules_path .. "." .. module)
    end
end

function lib.module_is_loaded(module_name)
    return package.loaded[module_name] ~= nil
end

return lib
