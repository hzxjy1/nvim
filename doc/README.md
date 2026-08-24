# Usage Guide

Usage guide for this personal Neovim configuration. KISS-first, lightweight, utility-first.

## Prerequisites

- **Neovim 0.12+** (tested on 0.12.4)
- **git** — plugin management (lazy.nvim auto-installs)
- **npm** (optional) — some LSP servers install via npm (e.g. typescript-language-server); when missing, those LSPs are automatically dropped from the install list
- **ripgrep** (recommended) — default `essential_bin` check
- **Language toolchains** (as needed) — gcc (C), python3, deno (TypeScript), bash-language-server, etc.

## First-run bootstrap

1. Clone the repo into the config directory:
   ```bash
   git clone <repo> ~/.config/nvim
   ```
2. Open Neovim; lazy.nvim installs all plugins on first run:
   ```bash
   nvim
   ```
   Or sync headlessly:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   ```
3. Install Treesitter parsers:
   ```bash
   nvim --headless "+TSUpdateSync" +qa
   ```
4. LSP servers are auto-installed by Mason from the language metadata in `lua/trinity/` (triggered when opening a matching file type).

## conf.lua customization

Copy `lua/conf_template.lua` to `lua/conf.lua` (gitignored, personal settings stay local):

```lua
local settings = {
	-- Active colorscheme. Valid values: "monokai-pro" (installed),
	-- "catppuccin" (run `:Lazy sync` to install).
	theme = "monokai-pro",

	-- Commands that must be on PATH; missing ones trigger a WARN at startup.
	-- mason/bin is always prepended to PATH.
	essential_bin = { "rg" },

	-- LSP servers to exclude from Mason auto-install.
	-- Values are trinity entry names (see lua/trinity/).
	disabled_lsp = { "cpp" },

	-- Plugin spec files (without .lua) to skip loading entirely.
	-- Their keymaps die with them (see lua/plugins/).
	disabled_plugin = { "todo-comments" },
}

return settings
```

## High-value keybindings

`<leader>` is the space bar.

### Editor

| Key | Action |
|---|---|
| `<C-s>` | Save |
| `<BS>` | Quit current window |
| `<C-q>` | Close current buffer |
| `<C-j>` / `<C-k>` | Move 4 lines up/down |
| `<F2>` | Focus mode toggle (line numbers / diagnostics / sign column) |
| `<leader>/` | Search for the current word |
| `<leader>c` | Copy to clipboard (OSC52) |
| Visual `<` / `>` | Indent |
| Visual `J` / `K` | Move selected lines up/down |

### LSP (buffer-local, active after LSP attaches)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gh` | Hover documentation |
| `gH` | Open diagnostic float |
| `<leader>ca` | Code action |

### Plugins

| Key | Action | Plugin |
|---|---|---|
| `<leader>ff` | Find files | telescope |
| `<leader>fg` | Live grep | telescope |
| `<leader>fa` | Symbol outline | telescope + aerial |
| `<leader>cs` | Toggle symbol outline | aerial |
| `<leader>e` | Toggle file tree | nvim-tree |
| `<C-h>` / `<C-l>` | Previous/next buffer | bufferline |
| `<leader>f` | Format current buffer | conform |
| `<leader>rr` | Run code | code-runner |
| `<leader>ec` / `<leader>ep` | Erase commit/plus (visual) | eraser |
| `<leader>rh` | Reset hunk (visual) | gitsigns |
| `<leader>nh` / `<leader>ph` | Next/previous hunk | gitsigns |
| `<leader>?` | Show keymap hints | which-key |
| `<leader>do` / `<leader>dc` | Open/close diffview | diffview |

### Completion (nvim-cmp)

| Key | Action |
|---|---|
| `<C-e>` | Close completion menu |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Next/previous candidate |

## Directory structure

- `init.lua` — entry point: globals `lib`/`fp`/`conf`, keybinding load, plugin bootstrap
- `lua/lib.lua` — shared utility entry point
- `lua/tookit/` — core helper modules (functional, module_loader, conf_kit, etc.)
- `lua/plugins/` — one plugin spec per file (lazy.nvim)
- `lua/trinity/` — language metadata (single source of truth for LSP/linter/formatter)
- `lua/key_binding.lua` — editor keymaps and options (plugin keymaps live in each spec's `keys`)
- `lua/conf_template.lua` — config template (copy to `conf.lua`)