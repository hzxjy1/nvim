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

-- TODO: Use vim.tbl_contains
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
