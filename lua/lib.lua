local lib = {}
local config_path = vim.fn.stdpath("config")
if type(config_path) == "table" then
	config_path = config_path[1]
end

lib.module_loader = require("tookit.module_loader").load
lib.lazynvim_bootstrap=require("tookit.lazynvim").load

function lib.deepcopy(orig)
	local copy = {}
	for k, v in pairs(orig) do
		if type(v) == "table" then
			copy[k] = lib.deepcopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function lib.is_array(t)
	local i = 0
	for _ in pairs(t) do
		i = i + 1
		if t[i] == nil then
			return false
		end
	end
	return true
end

function lib.unique_array(arr)
	local res = {}
	local hash = {}
	for _, v in ipairs(arr) do
		if not hash[v] then
			res[#res + 1] = v
			hash[v] = true
		end
	end
	return res
end

function lib.flatten(array) -- WARN: Have potential risk
	return fp.reduce(array, function(acc, row)
		if not lib.is_array(row) then
			table.insert(acc, row)
			return acc
		end
		for _, val in pairs(row) do
			table.insert(acc, val)
		end
		return acc
	end, {})
end

---@diagnostic disable: missing-fields
local function check_update_co()
	local git = "git"
	local spawn_result = 0
	local branch = "master"

	vim.loop.spawn("sh", {
		args = { "-c", string.format('[ "$(git branch --show-current)" = "%s" ] && exit 0 || exit 1', branch) },
		stdio = {},
		cwd = config_path,
	}, function(code)
		spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	-- Is not the expect branch
	if spawn_result ~= 0 then
		return
	end

	vim.loop.spawn(git, {
		args = { "fetch" },
		stdio = {},
		cwd = config_path,
	}, function(code)
		spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if spawn_result ~= 0 then
		print("Unable check update, command 'git fetch' return exit-code " .. spawn_result)
		return
	end

	-- Stop update while repo has some untracked commit
	vim.loop.spawn(git, {
		args = { "diff", "--exit-code" },
		stdio = {},
		cwd = config_path,
	}, function(code)
		spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if spawn_result ~= 0 then
		return
	end

	vim.loop.spawn(git, {
		args = { "diff", "--exit-code", "origin/master" },
		stdio = {},
		cwd = config_path,
	}, function(code)
		spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if spawn_result ~= 0 then
		print("Update available, updating...")
	else
		return
	end

	vim.loop.spawn(git, {
		args = { "pull" },
		stdio = {},
		cwd = config_path,
	}, function(code)
		spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if spawn_result == 0 then
		-- Unavailable, idk
		-- vim.notify("The update was successful", vim.log.levels.INFO, { timeout = 2000 })
		print("The update was successful")
	else
		print("Unable update, command 'git pull' return exit-code " .. spawn_result)
	end
end

function lib.check_update()
	Update_co = coroutine.create(check_update_co)
	coroutine.resume(Update_co)
end

-- 摆了 I give up
function lib.inlay_hint()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function()
			if vim.lsp.inlay_hint then
				vim.lsp.inlay_hint.enable(true, { 0 })
			end
		end,
	})
end

function lib.is_executable(bin)
	return vim.fn.executable(bin) ~= 0
end

function lib.module_is_loaded(module_name)
	return package.loaded[module_name] ~= nil
end

function lib.is_include(array, value)
	if array == nil then
		return false
	end
	for _, i in ipairs(array) do
		if i == value then
			return true
		end
	end
	return false
end

function lib.print(table)
	print(vim.inspect(table))
end

return lib
