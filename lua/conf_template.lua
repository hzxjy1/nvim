-- Copy this file to conf.lua and adjust values.
-- conf.lua is gitignored, so your personal settings stay local.
local settings = {
	-- Active colorscheme. Valid values: "monokai-pro" (installed),
	-- "catppuccin" (spec present, run `:Lazy sync` to install).
	-- Unset to keep the default colorscheme.
	theme = "monokai-pro",

	-- Commands that must be on PATH; missing ones trigger a WARN at startup.
	-- mason/bin is always prepended to PATH, so Mason-installed binaries count.
	essential_bin = { "rg" },

	-- LSP servers to exclude from Mason auto-install.
	-- Values are trinity entry names (see lua/trinity/).
	disabled_lsp = { "cpp" },

	-- Plugin spec files (without .lua) to skip loading entirely.
	-- Their keymaps die with them (see lua/plugins/).
	disabled_plugin = { "todo-comments" },
}

return settings