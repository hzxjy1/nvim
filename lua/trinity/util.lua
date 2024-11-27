local util = {}

util.get_conf = lib.module_loader

local function selecter_common(lang_conf, table_member, is_array)
	local lang_table = {}
	fp.map(lang_conf, function(entity)
		if entity[table_member] ~= nil then
			local key = (entity.name == "alias") and entity.alias or { entity.name }
			for _, value in ipairs(key) do
				if is_array then
					table.insert(lang_table, value)
				else
					lang_table[value] = { entity[table_member] }
				end
			end
		end
	end)
	return lang_table
end

function util.name_selecter(lang_conf)
	-- local array = {}
	-- fp.map(lang_conf, function(entity)
	-- 	if entity.name == "alias" then -- Deal alias
	-- 		for _, value in ipairs(entity.alias) do
	-- 			table.insert(array, value)
	-- 		end
	-- 	end
	-- 	table.insert(array, entity.name)
	-- end)
	-- return array
	return selecter_common(lang_conf, "name", true)
end

function util.lsp_selecter(lang_conf)
	return fp.map(lang_conf, function(entity)
		return entity.lsp
	end)
end

function util.linter_selecter(lang_conf)
	return selecter_common(lang_conf, "linter", false)
end

function util.formatter_selecter(lang_conf)
	return selecter_common(lang_conf, "formatter", false)
end

return util
