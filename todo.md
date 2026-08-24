# TODO

## High Priority

- [ ] Fix `lua/tookit/lazynvim.lua` bootstrap flow so first-time install can clone plugins and continue into `require("lazy").setup(...)` without requiring a Neovim restart. *(deferred: subsumed by vim.pack migration)*
- [ ] Audit plugin specs and add real lazy-loading triggers (`keys`, `cmd`, `event`, `ft`) for currently eager plugins such as `lua/plugins/telescope.lua`, `lua/plugins/gitsigns.lua`, `lua/plugins/conform.lua`, and `lua/plugins/mason.lua`. *(partially done: Flaw 5 moved maps into `keys`, making telescope/aerial/diffview/eraser/code-runner/codecompanion/opencode lazy; gitsigns/conform/which-key kept eager via `lazy = false`)*
- [x] Refactor `lua/trinity/util.lua` so `self_setup()` is not executed during formatter/linter selection; move side effects into explicit plugin setup stages to avoid duplicate autocmd registration.
- [x] Verify and fix `lua/tookit/has_npm_dep.lua` filtering logic so missing `npm` reduces npm-based installs instead of preserving them.
- [x] Harden `lua/tookit/sign_colunm.lua` by wrapping optional plugin requires in `pcall(require, ...)` so the `F2` toggle degrades safely when a plugin is unavailable.
- [x] Fix nil-hole truncation in `lua/tookit/module_loader.lua`: a failing plugin spec leaves a nil hole in `fp.map` output, and `ipairs` in `lib.flatten`/`fp.reduce` stops at the first hole, silently dropping every plugin after the broken one.
- [x] Fix `lua/plugins/avante.lua` contradictory spec: `lazy = false` (line 6) forces eager startup load and defeats its own `event = "VeryLazy"`; drop `lazy = false`. *(resolved by deleting the plugin entirely)*

## Architectural Flaws (design review)

Priority order: Flaw 2 → 3 → 4 → 1 → 5. Target designs below all REMOVE code rather than add abstraction.

- [x] **Flaw 1 — Globals as implicit back-channel.** `lib`/`fp`/`conf` are ambient; `lib.lua:12` uses `fp`, `module_loader.lua:32,43` uses `lib`/`fp`/`conf`, `trinity/util.lua:3` captures the `lib` global at module load time. The lib ↔ module_loader cycle only survives via init.lua line order. Consequence: modules cannot be loaded in isolation (single-module `luafile` self-tests break); any init.lua reordering fails non-locally. Target: tookit modules take dependencies as parameters (`module_loader.load(path, conf)`); trinity/util requires `tookit.module_loader` canonically; globals stay as init.lua's private convenience, never read inside `lua/tookit` or `lua/trinity`.
- [ ] **Flaw 2 — Custom module_loader serves two masters.** One function acts as lazy.nvim's `import` (worse: nil-hole truncation, print-based errors, filename-keyed disabling) AND owns trinity domain logic (`util.lua` exclusion, `alias`/`like` expansion — the "WTF is 'like'?" comment). Consequences: one broken spec silently drops all later plugins; file renames silently void user `disabled_plugin`; the `like` field needs three files of context. Target: plugins → `require("lazy").setup({ { import = "plugins" } })` with per-spec `enabled` reading conf; trinity → a ~10-line dedicated loader inside `trinity/util.lua`; bootstrap folds into lazy.nvim's official snippet (also fixes the silent first-run plugin-less session). *(deferred: subsumed by vim.pack migration)*
- [x] **Flaw 3 — Trinity has no lifecycle separation.** Declarative metadata and effectful activation share one table and one consumption phase: `self_setup` is smuggled through `selecter_common`'s `extra` hook (`trinity/util.lua:14-16,30-39`), and selection runs at spec-load time in two independent consumers (conform + lint). Consequences: duplicate autocmd registration; activation correctness depends on which selector a consumer happens to call (`name_selecter`/`lsp_selecter` never run `self_setup`). Target: trinity entries become pure data; bash's filetype fix moves to `vim.filetype.add`; selecters become pure functions. Net deletion, not added machinery.
- [x] **Flaw 4 — Conf has no owner.** Defaults are mutated in by readers (`module_loader.lua:6`, `mason-lspconfig.lua:7` both write `conf.X = {}`); `conf_template.lua` is non-authoritative (typo'd keys silently ignored); theme activation is split between two mechanisms — two eager theme plugins that never self-activate, plus `vim.cmd("colorscheme ...")` in `do_conf` which early-returns when `conf.lua` is absent (current state: no theme active at all). Target: `conf_kit.get_conf` normalizes ALL defaults in one place; theme moves into the colorscheme spec's `priority = 1000` + `config` (lazy idiom).
- [x] **Flaw 5 — Keybinding centralization + eager-everything lock in slow startup.** With maps centralized in `key_binding.lua`, no spec can adopt `keys`/`cmd` loading without splitting maps away first; disabling a plugin leaves dead maps behind (`<leader>ff` survives `disabled_plugin = {"telescope"}`); LSP maps are global not buffer-local (`gd` errors in non-LSP buffers). Target: relocate plugin-command maps into their specs' `keys`/`cmd` (the point is map-dies-with-spec association, composing correctly with `disabled_plugin`); move LSP maps into the existing `LspAttach` callback as buffer-local; editor maps stay central.

## Native Integration (Neovim 0.12+, no compatibility concerns)

Personal config: migrate aggressively to native features; drop plugin equivalents instead of maintaining both. *(deferred until Neovim 0.13: 0.12.4 lacks `:packupdate`/`:packdel` commands and `'packlockfile'` option — only the Lua API `vim.pack.add/del/get/update` exists)*

- [ ] Replace lazy.nvim + `lua/tookit/lazynvim.lua` + `lua/tookit/module_loader.lua` with built-in `vim.pack`: `vim.pack.add({ src = ..., version = ... })`, `:packupdate`/`:packdel`, and the native lockfile (`'packlockfile'`, commit it like `lazy-lock.json`). Note: `vim.pack` has NO built-in lazy-load triggers (`load` is boolean or a custom function) — hand-roll a thin `load` helper for `ft`/`keys`/`cmd`/`events` if needed, or accept eager loading for the few plugins that stay. This subsumes Flaw 2 and the bootstrap fix.
- [ ] Replace nvim-lspconfig setup with native `vim.lsp.config` + `vim.lsp.enable()` (0.11+); rework `lua/plugins/mason-lspconfig.lua` and `lua/trinity/` `lsp`/`lsp_setup` fields to emit `vim.lsp.config` tables. Keep mason.nvim only as a binary installer for LSP servers (no native equivalent).
- [ ] Replace nvim-cmp with native completion: `'autocomplete'` option + `vim.lsp.completion.enable()` (0.12 gained the `cmp` option for custom ordering, and `'complete'` flags `"o"`/`"F{func}"` for omnifunc/function sources). Drop cmp.lua and its 6 dependencies; keep buffer-line sources only if a real gap remains.
- [ ] Replace luasnip with native `vim.snippet` (LSP-style snippets) where possible; keep luasnip only if snippet features genuinely require it.
- [ ] Evaluate native `:DiffTool` (0.12) and `:Undotree` (0.12) as replacements for diffview.nvim and any undo-tree needs; diffview's git integration (file history panel) has no native equivalent — keep only that part if used.
- [ ] No native equivalents exist (keep as plugins): telescope, nvim-tree, gitsigns, which-key, conform.nvim, nvim-lint, treesitter (parser management still plugin-side), bufferline. Do not attempt to hand-roll these.
- [ ] After migration: re-run startup timing (init.lua:3 "WARN: Slow start") — dropping lazy.nvim + cmp + lspconfig shims plus the custom loader should cut a large fraction of startup cost; update `nvim --headless +qa` smoke test and AGENTS.md bootstrap commands (`Lazy! sync` → `:packupdate`).

- [x] Gradually reduce implicit globals from `init.lua` (`lib`, `fp`, `conf`) and prefer explicit `require(...)` usage in new and touched modules.
- [x] Normalize module import style to canonical dot paths like `require("tookit.functional")` across the repo.
- [ ] Re-evaluate `lua/tookit/module_loader.lua` and consider replacing custom directory scanning with `lazy.nvim` import/spec facilities. *(deferred: subsumed by vim.pack migration)*
- [x] Clean up long-standing naming and spelling debt in files and identifiers where the runtime impact is manageable.
- [x] Note rename safety: `lua/plugins/whick-key.lua` filename is NOT load-bearing (module name never required externally, zero runtime impact to rename — renamed to `which-key.lua`), while `lua/tookit/` and `lua/tookit/sign_colunm.lua` ARE load-bearing (referenced from init.lua, lib.lua, module_loader.lua, key_binding.lua).
- [x] Remove dead code in `lua/lib.lua`: the `stdpath("config")` table branch (always a string) and deprecated `vim.loop` usage in `get_os_name`.
- [x] Delete `lua/plugins/plugin_template.lua.bak` clutter.

## Performance And Startup

- [x] Load only the active colorscheme eagerly; make inactive themes like `lua/plugins/catppuccin.lua` or `lua/plugins/monokai-pro.lua` lazy or remove unused ones. *(catppuccin removed — never installed; monokai-pro activates via `priority = 1000`)*
- [ ] Convert command-driven plugins such as `lua/plugins/diffview.lua`, `lua/plugins/sudo.lua`, and `lua/plugins/config-sync.lua` to `cmd`-based loading. *(deferred until vim.pack migration)*
- [ ] Move non-critical UI plugins such as `lua/plugins/indent-blankline.lua`, `lua/plugins/neoscroll.lua`, `lua/plugins/vim-illuminate.lua`, and `lua/plugins/which-key.lua` to `VeryLazy` or another later event. *(deferred until vim.pack migration)*
- [x] Migrate plugin-specific mappings from `lua/key_binding.lua` into plugin specs via `keys` so keypresses can trigger lazy loading directly.
- [ ] Add lazy-load triggers for remaining eager plugins with obvious ones: cmp (`event = "InsertEnter"`), nvim-treesitter (`event = { "BufReadPre", "BufNewFile" }`), lint (`event = "BufWritePost"` or VeryLazy), aerial (`cmd = "AerialToggle"`), code-runner (`cmd = "RunCode"`), eraser (`cmd`), todo-comments (`cmd`), nvim-autopairs (`event = "InsertEnter"`). *(partially done via Flaw 5 keys; codecompanion/opencode deleted)*
- [ ] Move `lua/plugins/mason-lspconfig.lua` top-level `LspAttach` autocmd and eager `mason-registry`/`lspconfig.get_mappings()` access out of module-load time (candidate: `event = "LspAttach"` or VeryLazy).
- [x] Re-evaluate AI-assistant redundancy: opencode, avante, and codecompanion all load eagerly; codecompanion is configured with `adapter = "opencode"` (a second UI over the same backend). Consider keeping one. *(resolved: all AI plugins deleted)*

## Reliability And Error Handling

- [x] Add nil checks or `pcall` guards in `lua/tookit/has_npm_dep.lua` around Mason registry/package metadata access.
- [x] Replace silent failures in `lua/tookit/conf_kit.lua` with visible warnings via `vim.notify(..., vim.log.levels.WARN)` where appropriate.
- [ ] Update `lua/plugins/code-runner.lua` to avoid global leakage, and replace fixed `/tmp` paths with `vim.fn.tempname()`. *(skipped by user)*
- [x] Revisit `lua/plugins/nvim-tree.lua` loading strategy so it aligns with actual command/key usage instead of loading on `BufWinEnter`.
- [x] Remove or define the phantom `:CheckUpdate` command called in `lua/tookit/conf_kit.lua:57`; it is defined nowhere in the repo and silently no-ops on every startup.
- [ ] Fix `lua/plugins/code-runner.lua` C-filetype branch: outer function returns nil instead of the `vim.ui.input` result flow, `c_base[4]` gets a nil hole when input is cancelled, and `vim.print(...)` is a debug leftover. *(skipped by user)*
- [x] Note that `lua/conf.lua` is currently absent, so `do_conf` early-returns: no colorscheme is activated at all (default theme) while both theme plugins still load eagerly. Create a `conf.lua` or make theme loading not depend on it. *(theme activation moved into colorscheme specs — no longer depends on conf.lua)*

## Developer Experience And Usability

- [ ] Expand `README.md` with prerequisites, first-run bootstrap steps, `conf.lua` customization, and high-value keybindings.
- [x] Extend `lua/conf_template.lua` so it reflects real configurable options such as theme selection, update behavior, language tooling, and plugin toggles.
- [x] Improve `.luarc.json` to reflect repo globals accurately, or continue reducing globals so LuaLS diagnostics become more useful.
- [ ] Split `lua/key_binding.lua` responsibilities into clearer modules such as options, general keymaps, and plugin keymaps. *(plugin keymaps moved to specs in Flaw 5; options + editor maps remain central)*

## Strengths To Preserve

- [ ] Keep the `lua/trinity/` language-metadata layer and continue evolving it instead of replacing it with ad hoc per-plugin wiring.
- [ ] Preserve the one-plugin-per-file structure in `lua/plugins/`.
- [ ] Keep `lazy-lock.json` committed and up to date to maintain reproducibility. *(note: currently gitignored — decide whether to track it)*
- [ ] Maintain the current lightweight, utility-first style instead of over-engineering the config.
- [ ] Do NOT restructure (verified architecturally sound): `tookit/functional.lua` (pure, zero-dep, self-tested); the trinity *concept* itself (language→tooling single source of truth — the flaw is consumption lifecycle, not the data model); one-file-per-plugin returning `local config`; `conf_kit.get_conf`'s optional-conf-via-pcall pattern; central editor keymaps/options file; `has_npm_dep`'s instinct to quarantine mason-registry internals behind one file.