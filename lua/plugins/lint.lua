local lint = require('lint')

lint.linters_by_ft = {
    c = { 'clangtidy' },
    cpp = { 'clangtidy' },
}

-- Linting after the file is saved
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
