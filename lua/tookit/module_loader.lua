local module_loader = {}

local function grep_module(type)
	return function(file)
		if conf.disabled_plugin == nil then
			conf.disabled_plugin = {}
		end
		if type == "plugins" then
			return file:match("%.lua$") and not vim.tbl_contains(conf.disabled_plugin, (file:gsub("%.lua$", "")))
		elseif type == "trinity" then
			return file:match("%.lua$") and file ~= "util.lua"
		else
			return true
		end
	end
end

local function do_module_loader(modules_path)
	local config_path = vim.fn.stdpath("config")
	local luafile_list = vim.fn.readdir(config_path .. "/lua/" .. modules_path)

	local do_map = function(file)
		local plugin_location = modules_path .. "." .. file:sub(1, -5)
		local status, module = pcall(require, plugin_location)
		if not status then
			print("Cannot load module: " .. plugin_location .. "\nError: " .. module)
			return nil
		end
		if modules_path == "trinity" and module.name == "alias" then
			-- WTF is "like"? It disables multiple language families in mason-lspconfig.lua
			local like = module.alias[1]
			return fp.map(module.alias, function(alia)
				local temp = vim.deepcopy(module)
				temp["name"] = alia
				temp["alias"] = nil
				temp["like"] = like
				return temp
			end)
		end
		return module
	end

	return lib.flatten(fp.map(fp.filter(luafile_list, grep_module(modules_path)), do_map))
end

module_loader.load = require("tookit/functional").memoize(do_module_loader)

return module_loader
