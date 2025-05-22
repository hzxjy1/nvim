local has_npm_dep = {}

function has_npm_dep.init(lspconfig, registry)
	local map = lspconfig.get_mappings()
	has_npm_dep.mapping = map.lspconfig_to_package or map.lspconfig_to_mason
	has_npm_dep.registry = registry
end

function has_npm_dep.check(lsp_name)
	-- https://github.com/LazyVim/LazyVim/issues/6039#issuecomment-2856502153
	local lsp_full_name = has_npm_dep.mapping[lsp_name]
	local bin = has_npm_dep.registry.get_package(lsp_full_name).spec.bin[lsp_full_name]
	if bin and bin:match("^npm:") then
		return true
	else
		return false
	end
end

function has_npm_dep.filter(trigger)
	return function(lsp_name_list)
		local npm = vim.fn.executable("npm") == 1
		local flitered_list = {}
		for _, v in ipairs(lsp_name_list) do
			if trigger == (npm or has_npm_dep.check(v)) then
				table.insert(flitered_list, v)
			end
		end
		return flitered_list
	end
end

return has_npm_dep
