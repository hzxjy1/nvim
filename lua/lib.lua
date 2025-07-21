local lib = {}
local config_path = vim.fn.stdpath("config")
if type(config_path) == "table" then
	config_path = config_path[1]
end

lib.module_loader = require("tookit.module_loader").load
lib.lazynvim_bootstrap = require("tookit.lazynvim").load

function lib.unique_array(arr)
	local hash = {}
	return fp.filter(arr, function(v)
		if not hash[v] then
			hash[v] = true
			return true
		else
			return false
		end
	end)
end

function lib.flatten(array)
	return fp.reduce(array, function(acc, row)
		if not vim.isarray(row) then
			table.insert(acc, row)
			return acc
		else
			vim.list_extend(acc, row)
		end
		return acc
	end, {})
end

function lib.get_os_name()
	return vim.loop.os_uname().sysname
end

return lib
