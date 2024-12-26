local lib = {}

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

function lib.module_loader(modules_path)
	local config_path = vim.fn.stdpath("config") .. "/lua/"
	local plugin_list = {}
	for _, file in ipairs(vim.fn.readdir(config_path .. modules_path)) do
		if file:match("%.lua$") and file ~= "util.lua" then
			local plugin_name = file:sub(1, -5)
			local plugin_location = modules_path .. "." .. plugin_name
			local status, module = pcall(require, plugin_location)
			if not status then
				-- Skip
				print("Cannot load module: " .. plugin_location .. "\nError: " .. module)
			else
				table.insert(plugin_list, module)
			end
		end
	end
	return plugin_list
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

function lib.luarocks_bootstrap() -- TODO: Need complete
end

function lib.check_essential(bin_list)
	local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin"
	vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

	local uninstalled = fp.filter(bin_list, function(bin)
		return not lib.is_executable(bin)
	end)

	if #uninstalled > 0 then
		local issue_bar = ""
		for index, bin in ipairs(uninstalled) do
			if index > 1 then
				issue_bar = issue_bar .. ", "
			end
			issue_bar = issue_bar .. bin
		end
		print("Neovim should use these command(s):", issue_bar)
	end
end

---@diagnostic disable: missing-fields
local function check_update_co()
	local git = "git"
	Spawn_result = 0

	vim.loop.spawn(git, {
		args = { "fetch" },
		stdio = { nil, nil, nil },
	}, function(code)
		Spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if Spawn_result ~= 0 then
		print("Unable check update, command 'git fetch' return exit-code " .. Spawn_result)
		return
	end

	vim.loop.spawn(git, {
		args = { "diff", "--exit-code", "origin/master" },
		stdio = { nil, nil, nil },
	}, function(code)
		Spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if Spawn_result ~= 0 then
		print("Update available, updating...")
	else
		return
	end

	vim.loop.spawn(git, {
		args = { "pull" },
		stdio = { nil, nil, nil },
	}, function(code)
		Spawn_result = code
		coroutine.resume(Update_co)
	end)

	coroutine.yield()
	if Spawn_result == 0 then
		-- Unavailable, idk
		-- vim.notify("The update was successful", vim.log.levels.INFO, { timeout = 2000 })
		print("The update was successful")
	else
		print("Unable update, command 'git pull' return exit-code " .. Spawn_result)
	end
end

function lib.check_update()
	Update_co = coroutine.create(check_update_co)
	coroutine.resume(Update_co)
end

function lib.is_executable(bin)
	return vim.fn.executable(bin) ~= 0
end

function lib.module_is_loaded(module_name)
	return package.loaded[module_name] ~= nil
end

function lib.print(table)
	local status, serpent = pcall(require, "tookit/serpent/serpent")
	if status then
		print(serpent.block(table))
	end
end

return lib
