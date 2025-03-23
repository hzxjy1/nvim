local conf_kit = {}
local data_path = vim.fn.stdpath("data")

function conf_kit.get_conf(path)
	local result, conf = pcall(require, path)

	if result then
		return conf
	else
		return {}
	end
end

local function check_essential(conf)
	local bin_list = conf.essential_bin
	local mason_bin_path = data_path .. "/mason/bin"
	vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH

	local uninstalled = fp.filter(bin_list, function(bin)
		return not lib.is_executable(bin)
	end)

	if #uninstalled > 0 then
		local issue_bar = ""
		for index, bin in ipairs(uninstalled) do
			if index > 1 then
				issue_bar = issue_bar .. ", "
			end
			issue_bar = issue_bar .. bin
		end
		print("Neovim should use these command(s):", issue_bar)
	end
end

local function set_theme(conf)
	local theme = conf.theme
	if theme == nil then
		return
	end

	---@diagnostic disable-next-line: param-type-mismatch
	local ret, _ = pcall(vim.cmd, "colorscheme " .. theme)
	if not ret then
		print("Error loading colorscheme: " .. theme)
	end
end

function conf_kit.do_conf(conf)
	if next(conf) == nil then
		return
	end

	check_essential(conf)
	set_theme(conf)
end

return conf_kit
