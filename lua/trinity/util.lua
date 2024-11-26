local util = {}

util.get_conf = lib.module_loader

local function selecter_common(lang_conf, table_member)
	local table = {}
	fp.map(lang_conf, function(entity)
		if entity[table_member] ~= nil then
			if entity.name == "alias" then -- Deal alias
				for _, value in ipairs(entity.alias) do
					table[value] = { entity[table_member] }
				end
			else
				table[entity.name] = { entity[table_member] }
			end
		end
	end)
	return table
end

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
	return selecter_common(lang_conf, "linter")
end

function util.formatter_selecter(lang_conf)
	return selecter_common(lang_conf, "formatter")
end

return util
