local conf_kit = {}
local data_path = vim.fn.stdpath("data")

local defaults = {
	essential_bin = {},
	disabled_lsp = {},
	disabled_plugin = {},
}

function conf_kit.get_conf(path)
	local result, conf = pcall(require, path)
	if not result then
		conf = {}
	end
	return vim.tbl_extend("force", vim.deepcopy(defaults), conf)
end

local function check_essential(conf)
	local bin_list = conf.essential_bin
	local mason_bin_path = data_path .. "/mason/bin"
	vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

	local uninstalled = fp.filter(bin_list, function(bin)
		return vim.fn.executable(bin) == 0
	end)

	if #uninstalled > 0 then
		local issue_bar = fp.reduce(uninstalled, function(acc, v)
			return acc .. ", " .. v
		end, "")
		vim.notify("Neovim should use these command(s): " .. string.sub(issue_bar, 3), vim.log.levels.WARN)
	end
end

function conf_kit.do_conf(conf)
	check_essential(conf)
end

return conf_kit
