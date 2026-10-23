-- nvimdbg.lua: drive an isolated, real Neovim instance through tmux (run with nvim -l).
local SESSION = "nvimdbg"
local TARGET = "nvimdbg:0.0"
local WORKDIR = "/tmp/nvimdbg"
local REDIR_FILE = WORKDIR .. "/redir.txt"
local TTL_PID_FILE = WORKDIR .. "/ttl.pid"
local TTL_SECONDS = 1800

local function sh(cmd)
  local p = io.popen(cmd)
  if not p then
    return ""
  end
  local out = p:read("*a")
  p:close()
  return (out:gsub("%s+$", ""))
end

local function shq(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- os.execute returns a raw wait status on LuaJIT/POSIX (0 means success) but a
-- boolean on Lua 5.2+. Normalize so a failed command is actually detected.
local function exec_ok(cmd)
  local ok = os.execute(cmd)
  if type(ok) == "number" then
    return ok == 0
  end
  return ok == true
end

-- Under nvim -l, print() goes to stderr; write to stdout so callers can pipe the output.
local function out(s)
  io.stdout:write(s .. "\n")
end

local function sleep_ms(ms)
  vim.uv.sleep(ms)
end

local function capture_pane()
  return sh("tmux capture-pane -p -t " .. TARGET .. " 2>/dev/null")
end

-- Settle: return the final screen once it stops changing, or when the timeout expires.
local function settle()
  local prev = ""
  local final = ""
  -- hrtime is a monotonic clock; vim.uv.now() would freeze here because the
  -- event loop never runs, which would make the deadline below unreachable.
  local start = vim.uv.hrtime()
  while true do
    sleep_ms(300)
    local cur = capture_pane()
    if cur ~= "" and cur == prev then
      final = cur
      break
    end
    if (vim.uv.hrtime() - start) / 1e6 > 5000 then
      final = cur
      break
    end
    prev = cur
  end
  return final
end

-- TTL timer: a detached setsid process group that kills the session after sleeping.
local function arm_ttl()
  local f = io.open(TTL_PID_FILE, "r")
  if f then
    local pid = f:read("*l")
    f:close()
    if pid and pid ~= "" then
      os.execute("kill -- -" .. pid .. " 2>/dev/null")
    end
  end
  local cmd = string.format(
    "setsid sh -c 'sleep %d && tmux kill-session -t %s' >/dev/null 2>&1 & echo $!",
    TTL_SECONDS, SESSION
  )
  local pid = sh(cmd)
  local wf = io.open(TTL_PID_FILE, "w")
  if wf then
    wf:write(pid)
    wf:close()
  end
end

local function kill_ttl()
  local f = io.open(TTL_PID_FILE, "r")
  if f then
    local pid = f:read("*l")
    f:close()
    if pid and pid ~= "" then
      os.execute("kill -- -" .. pid .. " 2>/dev/null")
    end
  end
  os.remove(TTL_PID_FILE)
end

local function session_alive()
  return sh("tmux has-session -t " .. SESSION .. " 2>/dev/null && echo yes") == "yes"
end

local function pane_dead()
  local out = sh("tmux list-panes -t " .. TARGET .. " -F '#{pane_dead}' 2>/dev/null")
  return out == "1"
end

local function start_session(clean)
  if session_alive() then
    sh("tmux kill-session -t " .. SESSION)
  end
  if not exec_ok("mkdir -p " .. WORKDIR) then
    out("error: cannot create " .. WORKDIR)
    os.exit(1)
  end
  local scratch = WORKDIR .. "/scratch.txt"
  local f = io.open(scratch, "w")
  if f then
    f:write("nvim-debug scratch buffer\n")
    f:close()
  end
  -- Drop the swap file left by a previous crash, so an E325 prompt cannot block startup.
  local swap_name = scratch:gsub("/", "%%") .. ".swp"
  os.remove(vim.fn.stdpath("state") .. "/swap/" .. swap_name)
  local nvim_cmd = clean and "nvim --clean scratch.txt" or "nvim scratch.txt"
  local cmd = string.format(
    "tmux new-session -d -s %s -x 200 -y 50 -c %s %s",
    SESSION, WORKDIR, nvim_cmd
  )
  if not exec_ok(cmd) then
    out("error: tmux new-session failed (tmux reports the reason on stderr)")
    os.exit(1)
  end
  local screen = settle()
  arm_ttl()
  out(screen)
end

local function is_special_key(k)
  local specials = {
    Enter = true, Escape = true, Esc = true, Space = true, Tab = true,
    BSpace = true, Up = true, Down = true, Left = true, Right = true,
    Home = true, End = true, PageUp = true, PageDown = true, Insert = true,
    Delete = true,
  }
  if specials[k] then
    return true
  end
  -- Modifier prefixes: C-x / M-x (Ctrl / Alt). The dash must be escaped:
  -- in a Lua pattern an unescaped "-" is a lazy quantifier, so "^[Cc]-"
  -- would match the empty prefix of every string and mark all input special.
  if k:match("^[Cc]%-") or k:match("^[Mm]%-") then
    return true
  end
  return false
end

local function cmd_start()
  if session_alive() and not pane_dead() then
    out("session already alive")
    arm_ttl()
    os.exit(0)
  end
  start_session(false)
end

local function cmd_clean()
  if session_alive() and not pane_dead() then
    out("session already alive")
    arm_ttl()
    os.exit(0)
  end
  start_session(true)
end

local function cmd_stop()
  kill_ttl()
  if session_alive() then
    sh("tmux kill-session -t " .. SESSION)
  else
    out("no session")
  end
  os.exit(0)
end

local function cmd_restart()
  kill_ttl()
  if session_alive() then
    sh("tmux kill-session -t " .. SESSION)
  end
  start_session(false)
end

local function cmd_status()
  local s = session_alive() and "alive" or "dead"
  local n = "dead"
  if s == "alive" then
    n = pane_dead() and "dead" or "alive"
  end
  local ttl = "none"
  local f = io.open(TTL_PID_FILE, "r")
  if f then
    local pid = f:read("*l")
    f:close()
    if pid and pid ~= "" then
      ttl = "armed/" .. pid
    end
  end
  out("session=" .. s)
  out("nvim=" .. n)
  out("ttl=" .. ttl)
end

local function cmd_send(args)
  for _, k in ipairs(args) do
    if is_special_key(k) then
      sh("tmux send-keys -t " .. TARGET .. " " .. shq(k))
    else
      sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(k))
    end
  end
  out(settle())
end

-- Make sure we are in normal mode; in insert mode a ":" is typed as text.
local function ensure_normal()
  sh("tmux send-keys -t " .. TARGET .. " Escape")
  sleep_ms(100)
end

local function cmd_ex(args)
  local command = table.concat(args, " ")
  ensure_normal()
  sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(":" .. command))
  sh("tmux send-keys -t " .. TARGET .. " Enter")
  out(settle())
end

local function cmd_capture(args)
  local extra = ""
  if args[1] == "-S" and args[2] then
    extra = " -S -" .. args[2]
  end
  out(sh("tmux capture-pane -p -t " .. TARGET .. extra))
end

-- Three-step redir flow: redir! > file, run the command, redir END.
local function redir_run(ex_cmd)
  ensure_normal()
  sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(":redir! > " .. REDIR_FILE))
  sh("tmux send-keys -t " .. TARGET .. " Enter")
  settle()
  sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(":" .. ex_cmd))
  sh("tmux send-keys -t " .. TARGET .. " Enter")
  settle()
  sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(":redir END"))
  sh("tmux send-keys -t " .. TARGET .. " Enter")
  settle()
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  return content
end

local function cmd_messages()
  redir_run("silent messages")
  local content = read_file(REDIR_FILE)
  if content and content ~= "" then
    out(content)
  else
    -- Fallback: :messages opens a pager, so capture the screen and close it with q.
    ensure_normal()
    sh("tmux send-keys -t " .. TARGET .. " -l " .. shq(":messages"))
    sh("tmux send-keys -t " .. TARGET .. " Enter")
    local screen = settle()
    sh("tmux send-keys -t " .. TARGET .. " q")
    out(screen)
  end
end

local function cmd_redir(args)
  local command = table.concat(args, " ")
  redir_run(command)
  local content = read_file(REDIR_FILE)
  if content then
    out(content)
  else
    out("error: cannot read " .. REDIR_FILE)
    os.exit(1)
  end
end

-- Dispatch. Under nvim -l, arg[0] is the script path and real arguments start at arg[1].
local cmd = arg[1]
local args = {}
for i = 2, #arg do
  args[#args + 1] = arg[i]
end

if cmd == "start" then
  cmd_start()
elseif cmd == "clean" then
  cmd_clean()
elseif cmd == "stop" then
  cmd_stop()
elseif cmd == "restart" then
  cmd_restart()
elseif cmd == "status" then
  cmd_status()
elseif cmd == "send" then
  cmd_send(args)
elseif cmd == "ex" then
  cmd_ex(args)
elseif cmd == "capture" then
  cmd_capture(args)
elseif cmd == "messages" then
  cmd_messages()
elseif cmd == "redir" then
  cmd_redir(args)
else
  out("usage: nvim -l nvimdbg.lua <start|clean|stop|restart|status|send|ex|capture|messages|redir> [args...]")
  os.exit(1)
end