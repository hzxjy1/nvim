local lib = {}
local fp = require("tookit.functional")

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

return lib
