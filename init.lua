-- TODO: sshfs?
-- WARN: Slow start !! Boot is too slow

---@diagnostic disable: lowercase-global -- Lowercase for compatibility
lib = require("lib")
fp = require("tookit/functional")
local conf_kit = require("tookit/conf_kit")
conf = conf_kit.get_conf("conf")

require("key_binding")

---@diagnostic disable
local wish_list = {
	-- TODO: Accomplish them

	--"folke/which-key.nvim"
	--"karb94/neoscroll.nvim"
	--"azabiong/vim-highlighter"
	--"RRethy/vim-illuminate"
}

local plugin_path = "plugins"
local plugin_list = lib.module_loader(plugin_path)
if not lib.lazynvim_bootstrap(plugin_list) then
	print("Unable to load plugins")
end

conf_kit.do_conf(conf)
