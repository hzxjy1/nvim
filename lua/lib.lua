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
