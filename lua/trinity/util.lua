local util = {}

util.get_conf = lib.module_loader

function util.name_selecter(lang_conf)
	local array = {}
	fp.map(lang_conf, function(entity)
		if entity.name == "alias" then -- Deal alias
			for _, value in ipairs(entity.alias) do
				table.insert(array, value)
			end
		end
		table.insert(array, entity.name)
	end)
	return array
end

function util.lsp_selecter(lang_conf)
	return fp.map(lang_conf, function(entity)
		return entity.lsp
	end)
end

function util.linter_selecter(lang_conf)
	return fp.map(lang_conf, function(entity)
		return entity.linter
	end)
end

function util.formatter_selecter(lang_conf)
	return fp.map(lang_conf, function(entity)
		return entity.formatter
	end)
end

return util
