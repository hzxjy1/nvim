# AGENTS.md

This file is for coding agents working in this Neovim configuration.

## Project shape

- This repo is a personal Neovim config, not a packaged Lua library or app.
- Entry point: `init.lua`.
- Core helpers live in `lua/tookit/` and `lua/lib.lua`.
- Plugin specs live in `lua/plugins/` and are loaded through Lazy.
- Language-specific metadata lives in `lua/trinity/`.
- There is no dedicated CI config, test framework, or external build system checked in.

## External agent rules

- No `.cursor/rules/` directory was found.
- No `.cursorrules` file was found.
- No `.github/copilot-instructions.md` file was found.
- Treat this document as the repository-specific instruction source unless new rule files are added later.

## Working assumptions

- Changes should keep the config lightweight and KISS-oriented, matching `README.md`.
- Prefer minimal, targeted edits over broad refactors.
- Expect the repo to be used inside Neovim rather than as a standalone Lua program.

## Build and bootstrap commands

- `nvim --headless "+Lazy! sync" +qa`
  - Install or sync plugins declared in `lua/plugins/`.
- `nvim --headless "+TSUpdateSync" +qa`
  - Rebuild or update Treesitter parsers after parser-related changes.
- `nvim --headless +qa`
  - Fast startup smoke test for the whole config.

## Lint and format commands

- Formatting is configured in-editor through Conform in `lua/plugins/conform.lua`.
- Lua formatting is mapped to `stylua` via `lua/trinity/lua.lua`.
- CLI format command, if `stylua` is installed:
  - `stylua init.lua lua`
- CLI format check, if `stylua` is installed:
  - `stylua --check init.lua lua`
- In-editor formatting:
  - `:Fmt`
- In-editor lint trigger:
  - `:Lint`
- If you add Lua code and cannot run `stylua`, at least preserve the surrounding file style exactly.

## Test commands

- Primary smoke test:
  - `nvim --headless +qa`
- Focused self-test that already exists:
  - `nvim --headless "+lua require('tookit.functional').test()" +qa`
- Useful targeted module load check for one file:
  - `nvim --headless "+lua require('plugins.conform')" +qa`
  - Replace `plugins.conform` with the module you changed.
- Useful single-file syntax/load check while editing one Lua file:
  - `nvim --headless "+luafile lua/tookit/functional.lua" +qa`
  - Replace the path with the file you changed.
- After editing `lua/trinity/` or LSP setup, run startup plus one focused `require(...)` or `luafile` check.
- After editing `lua/tookit/functional.lua`, run its built-in self-test.

## Single-test guidance

- There is no Jest/Pytest-style single-test runner in this repo.
- The closest equivalents are:
  - a targeted headless `require(...)` command for one module,
  - a targeted `luafile` execution for one file,
  - or the built-in `require('tookit.functional').test()` self-test.
- Prefer the narrowest command that proves your change did not break loading.

## Files and responsibilities

- `init.lua`
  - Sets globals `lib`, `fp`, and `conf`, loads key bindings, then bootstraps plugins.
- `lua/lib.lua`
  - Shared utility entry point and exported helpers.
- `lua/plugins/`
  - One plugin spec per file, typically returning a single Lazy plugin table named `config`.
- `lua/trinity/`
  - Per-language capability definitions such as LSP, linter, formatter, and setup hooks.
- `lua/conf_template.lua`
  - Example user-facing configuration values and expected keys.

## Code style

- Keep modules small and single-purpose.
- Use `local` for almost everything.
- Return a table from each module.
- Prefer early returns over deep nesting.
- Preserve the current straightforward, utility-first style instead of adding elaborate abstractions.

## Imports and module loading

- Put `require(...)` calls at the top of the file unless lazy loading inside a callback is intentional.
- Alias imported modules to concise locals like `util`, `binding`, `lint`, or `lspconfig`.
- For optional dependencies or fragile loads, use `pcall(require, ...)`.
- New code should prefer canonical module names such as `require("tookit.functional")`.
- Do not introduce circular dependencies.

## Formatting conventions

- Match the surrounding file's indentation and whitespace exactly.
- The config sets `tabstop`, `softtabstop`, and `shiftwidth` to `4`, with `expandtab = true`; use four-space logical indentation unless the file clearly uses a different existing style.
- Keep one blank line between logical blocks.
- Avoid lining up fields with manual spacing.
- Keep lines reasonably short for Neovim editing, but readability matters more than arbitrary wrapping.

## Types and annotations

- Lua language server support is enabled through `.luarc.json` and `lua/trinity/lua.lua`.
- Use EmmyLua-style annotations only when they add real value.
- Add `---@param`, `---@return`, or diagnostic suppressions for non-obvious APIs or Lua LS edge cases.
- Prefer shaping data clearly over relying on heavy annotation blocks.

## Naming conventions

- Use `snake_case` for local variables, functions, and module fields.
- Use descriptive table names such as `config`, `setup`, `settings`, `name_list`, or `python_conf`.
- Plugin spec files usually expose a local `config` table and `return config`.
- Language descriptors in `lua/trinity/` typically use `*_conf` tables.
- Do not rename existing modules casually; filenames are part of the runtime module graph.

## API and configuration patterns

- Plugin files usually return a Lazy spec table with keys like the plugin repo, `config`, `dependencies`, `build`, or `event`.
- Helper modules usually export functions by assigning onto a local table and returning it.
- `lua/trinity/` modules commonly expose `name`, `lsp`, `linter`, `formatter`, and sometimes `lsp_setup` or `self_setup`.

## Error handling

- Use `pcall(...)` around optional loads, user config, colorscheme loads, and other runtime-sensitive operations.
- Prefer concise user-facing messages via `print(...)` or `vim.api.nvim_echo(...)` when startup should continue.
- Return `false`, `{}`, or `nil` consistently when a helper is designed to fail softly.
- Use `assert(...)` only for true invariants or self-tests, not routine runtime conditions.

## Globals and side effects

- `init.lua` intentionally creates globals `lib`, `fp`, and `conf`.
- Do not add more globals unless there is a very strong reason.
- Prefer local state inside modules over mutating shared global state.

## Comments and docs

- Keep comments sparse and useful.
- Explain why, not what, when the code is already readable.
- Update comments when behavior changes.

## Editing guidance for agents

- Preserve existing spelling and file names even if they are imperfect, unless the task is explicitly to rename them.
- Avoid broad formatting-only diffs.
- Do not replace working simple code with framework-heavy patterns.
- When adding a new plugin, follow the one-file-per-plugin pattern under `lua/plugins/`.

## Validation checklist

- Run the narrowest relevant headless check for the module you changed.
- Run `nvim --headless +qa` for any non-trivial change.
- If you changed formatting-sensitive Lua, run `stylua` when available.
- Mention any command you could not run because a tool such as `stylua` is missing.
