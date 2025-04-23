local util = {}

util.get_conf = lib.module_loader

--- A filter of trinity members
--- @param lang_conf table Trinity members extracted in trinity folder
--- @param table_member string Specify which item of lang_conf will be selected
--- @param is_array boolean Return selected items as array; otherwise, return {item_name, item} binding.
--- @param extra function|nil Optional, an additional operation to execute before processing each entity
--- @return table A table containing the selected values
local function selecter_common(lang_conf, table_member, is_array, extra)
	local lang_table = {}
	fp.map(lang_conf, function(entity)
		if extra ~= nil then
			entity = extra(entity)
		end
		if entity[table_member] ~= nil then
			-- AI has generated some strange code that I never detect before the debug func lib.print is created
			local value = entity.name
			if is_array then
				table.insert(lang_table, value)
			else
				lang_table[value] = entity[table_member]
			end
		end
	end)
	return lang_table
end

function util.name_selecter(lang_conf)
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
	return selecter_common(lang_conf, "formatter", false, function(entity)
		if entity.self_setup ~= nil then
			entity.self_setup()
		end
		local temp = lib.deepcopy(entity)
		temp.formatter = { entity.formatter }
		return temp
	end)
end

return util
