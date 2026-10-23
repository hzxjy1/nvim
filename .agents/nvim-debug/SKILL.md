---
name: nvim-debug
description: Drive an isolated, real Neovim instance through tmux to reproduce errors, test keymaps, and read exact :messages and Ex output. Use this whenever you need to see what Neovim actually does on screen — a mapping that does not fire, an error popup, a statusline change, or text that only shows up in :messages — instead of guessing from a headless run or from source. It is also the right tool when you want to confirm a keymap resolves to what you think it does. Triggers: nvim debug, debug nvim, test nvim keymap, nvim keymap not working, tmux nvim, 调试 nvim.
---

# Neovim Debugging (tmux-driven real instance)

A small driver script runs a dedicated Neovim inside a tmux session (session `nvimdbg`, pane `nvimdbg:0.0`), so you can send real keystrokes, look at the real screen, and tear it down afterwards. Your interactive Neovim is never touched.

## When to use it

Use it when the answer only exists in a live UI:

- A keymap or key sequence silently does nothing, or you need to confirm what it resolves to.
- An Ex command's effect, or the error popup it raises, needs confirming.
- You need the exact, complete, greppable text of `:messages`.
- Cursor movement, window layout, or statusline behavior matters.

Do **not** use it for:

- Headless smoke tests — `nvim --headless +qa` is faster and leaves no session behind.
- Breakpoint debugging — this skill drives keys and Ex commands only. It has no DAP support, no variable inspection.

## Prerequisites

`tmux` plus `nvim`; the script itself runs under `nvim -l`, because there is no standalone Lua interpreter in this environment.

```bash
tmux -V                    # verified on 3.8
nvim --version | head -1   # verified on v0.12.6
```

Run the commands from the repository root so the relative script path resolves. `S` is just the script path:

```bash
S=.agents/nvim-debug/scripts/nvimdbg.lua
```

tmux needs a PTY: it opens `/dev/ptmx` read-write for every pane. Agent file sandboxes that only allow writes under the workspace (Landlock-style `workspace-write` policies) reject that `O_RDWR` open with `EACCES`. The fork itself succeeds, but tmux reports the child's failure as `create window failed: fork failed: Permission denied`, which is easy to misread as a process restriction. The script then prints `error: tmux new-session failed` and exits non-zero. Run the driver outside such a sandbox, or with permission to open `/dev/ptmx`; otherwise use `nvim --headless` for deterministic checks.

## Quick start

```bash
nvim -l $S start          # idempotent; prints "session already alive" if already running
nvim -l $S send ihello    # type literal text "ihello"
nvim -l $S send Escape
nvim -l $S ex "echo 1+1"  # run :echo 1+1
nvim -l $S capture -S 100 # screen plus 100 lines of scrollback
nvim -l $S messages       # exact :messages text
nvim -l $S stop           # tear the session down now
```

Every subcommand writes its result to stdout, so `... | grep -i error` works directly. `send` and `ex` already return the settled screen, and `messages`/`redir` return exact text, so you rarely need a follow-up `capture` — only for scrollback or for state that changed after they returned.

## Subcommands

| Subcommand | What it does | Example |
|---|---|---|
| `start` | Start nvim. Idempotent: if the session is alive it re-arms the TTL instead of restarting. | `nvim -l $S start` |
| `clean` | Same as `start`, but launches `nvim --clean` for a control run with no user config. | `nvim -l $S clean` |
| `stop` | Kill the TTL timer and destroy the session. A missing session counts as success. | `nvim -l $S stop` |
| `restart` | `stop` followed by `start` (with the normal config). | `nvim -l $S restart` |
| `status` | Print three lines: `session=alive|dead`, `nvim=alive|dead` (did the pane's nvim exit?), `ttl=armed/<pid>|none`. | `nvim -l $S status` |
| `send <keys...>` | Send each argument as keystrokes: known key names as keys, everything else literally. | `nvim -l $S send ihello Escape dd` |
| `ex <command...>` | Leave insert mode, then run one Ex command (adds `:` and Enter for you). | `nvim -l $S ex "echo 1+1"` |
| `capture [-S N]` | Dump the pane, optionally including N lines of scrollback. | `nvim -l $S capture -S 100` |
| `messages` | Exact `:messages` text via `redir`; falls back to a pager screenshot if that fails. | `nvim -l $S messages` |
| `redir <ex-command...>` | Exact output of any Ex command, via `redir`. | `nvim -l $S redir "set number?"` |

Special keys accepted by `send`: `Enter`, `Escape`/`Esc`, `Space`, `Tab`, `BSpace`, `Up`/`Down`/`Left`/`Right`, `Home`, `End`, `PageUp`, `PageDown`, `Insert`, `Delete`, plus the `C-x`/`M-x` modifier prefixes (e.g. `C-a`, `M-j`). Anything else is typed literally, so `send dd` sends the two characters `d` `d` rather than the delete-line key.

## Reading output: screen vs. redir

- **`capture`** answers "what does the UI look like" — statusline, error popup, cursor position, window layout. Use `-S N` when the history matters, for example after `:messages` opened a pager. ANSI escapes are stripped, which keeps the output easy to read.
- **`messages` / `redir`** answers "what exactly did it print". Both use the same three-step `:redir! > file` flow so nothing is truncated by the pager, and they return plain text that you can grep and compare. Use them whenever you want to assert on output rather than eyeball a screenshot.
- Transient output such as `:echo` never enters `:messages` — it only lives on the command line, so read it from `capture`. Use `:echomsg` or `:echoerr` when you need the text to show up in `messages` and `redir`.

## Typical recipes

Reproduce an error:

```bash
nvim -l $S start
nvim -l $S ex "e /path/to/file.lua"
nvim -l $S send G
nvim -l $S messages | grep -iE "error|E[0-9]+"
```

Check whether a mapping is defined and what it calls:

```bash
nvim -l $S redir "verbose nmap <leader>ff"
```

The `Last set from <file>` line names the config file that defined it, which is usually the answer to "why does this key do that".

Compare behavior with and without your config:

```bash
nvim -l $S clean
nvim -l $S send ihello
nvim -l $S restart   # back to the normal config
```

## Raw tmux commands (fallback)

The script wraps these, but knowing them helps when you drive tmux yourself:

- `tmux send-keys -t nvimdbg:0.0 -l "text"` sends literals. Without `-l` tmux parses the text as key names, which is why `-l "dd"` types characters while a bare `dd` is looked up as a key.
- `tmux send-keys -t nvimdbg:0.0 Enter` — Enter has to be a separate call.
- `tmux capture-pane -p -t nvimdbg:0.0` prints the pane; `-S -N` includes N scrollback lines; `-e` keeps ANSI escapes.
- Target syntax is `session:pane`, i.e. `nvimdbg:0.0`.

## Known behaviors

- The session self-destructs after a fixed 30-minute TTL. `start` and `restart` reset the clock; `stop` kills the TTL timer's process group.
- Scratch working directory is `/tmp/nvimdbg`, with `scratch.txt` as the initial buffer. To open a real file, use `ex "e <path>"`.
- The scratch buffer's stale swap file is removed on start, so a previous crash does not block startup with an E325 prompt.
- If nvim inside the pane has exited, `start` notices the dead pane and starts a fresh session.
- Pane size is fixed at 200x50 (`tmux new-session -x 200 -y 50`), so wide output wraps consistently.
- The `ex` subcommand presses Escape first, which is why it is safe to call while the instance sits in insert mode — and why it always drops you back to normal mode.
- `send` sends all its arguments back-to-back with no delay and waits once at the end. If you are testing something sensitive to `timeoutlen` (the 1000 ms default governs how `Esc` plus a following key is parsed), split the keys across several `send` calls so each one settles. The built-in settle loop samples every 300 ms and gives up after 5 s.
