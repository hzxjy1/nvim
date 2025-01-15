local function is_in(array, value)
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

local config = {
	"neovim/nvim-lspconfig",
	config = function()
		local lang_conf = lib.module_loader("trinity")
		local lspconfig = require("lspconfig")
		fp.map(lang_conf, function(obj)
			if obj.lsp ~= nil and not is_in(conf.disable_lsp, obj.name) then
				lspconfig[obj.lsp].setup(obj.lsp_setup(lspconfig))
			end
		end)
	end,
}

return config
