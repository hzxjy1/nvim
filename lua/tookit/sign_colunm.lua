local ibl = require("ibl")
local gitsigns = require("gitsigns")
local transformer = {}
local status = true

function transformer.toggle()
	status = not status

	if status then
		vim.cmd("set number relativenumber")
	else
		vim.cmd("set nonumber norelativenumber")
	end
	vim.diagnostic.enable(status)
	ibl.update({ enabled = status })
	gitsigns.toggle_signs(status)
	gitsigns.toggle_current_line_blame(status)
end

return transformer
