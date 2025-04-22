local lib = {}
local config_path = vim.fn.stdpath("config")
local data_path = vim.fn.stdpath("data")
if type(config_path) == "table" then
	config_path = config_path[1]
end

-- https://www.lazyvim.org/configuration/lazy.nvim
local function download_lazynvim(lazypath)
	print("Download lazynvim from github...")
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
			}, true, {})
			return false
		end
	end
	return true
end

local function grep_module(type)
	return function(file)
		if type == "plugins" then
			return file:match("%.lua$") and not lib.is_include(conf.disabled_plugin, file:gsub("%.lua$", ""))
		elseif type == "trinity" then
			return file:match("%.lua$") and file ~= "util.lua"
		else
			return true
		end
	end
end
-- TODO: Move to a new file
local function do_module_loader(modules_path)
	local luafile_list = vim.fn.readdir(config_path .. "/lua/" .. modules_path)
	local do_map = function(file)
		local plugin_name = file:sub(1, -5)
		local plugin_location = modules_path .. "." .. plugin_name
		local status, module = pcall(require, plugin_location)
		if not status then
			print("Cannot load module: " .. plugin_location .. "\nError: " .. module)
		else
			return module
		end
	end

	local plugin_list = fp.map(fp.filter(luafile_list, grep_module(modules_path)), do_map)

	-- lib.print(plugin_list)
	return plugin_list
end

lib.module_loader = require("tookit/functional").memoize(do_module_loader)

function lib.lazynvim_bootstrap(plugin_list)
	local lazypath = data_path .. "/lazy/lazy.nvim"
	vim.opt.rtp:prepend(lazypath)
	local status, lazy = pcall(require, "lazy")
	if status then
		lazy.setup(plugin_list)
		return true
	else
		return download_lazynvim(lazypath)
	end
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
