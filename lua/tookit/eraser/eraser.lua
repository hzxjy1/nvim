-- TODO: Build it as a nvim plugin
local eraser = {}

--https://github.com/linrongbin16/gitlinker.nvim/blob/master/lua/gitlinker/range.lua#L5
local function is_visual_mode(m)
	return type(m) == "string" and string.upper(m) == "V"
		or string.upper(m) == "CTRL-V"
		or string.upper(m) == "<C-V>"
		or m == "\22"
end

-- https://github.com/linrongbin16/gitlinker.nvim/blob/master/lua/gitlinker/range.lua#L14
local function make_range()
	local m = vim.fn.mode()
	local l1 = nil
	local l2 = nil
	if is_visual_mode(m) then
		vim.cmd([[execute "normal! \<ESC>"]])
		l1 = vim.fn.getpos("'<")[2]
		l2 = vim.fn.getpos("'>")[2]
	else
		l1 = vim.fn.getcurpos()[2]
		l2 = l1
	end
	local lstart = math.min(l1, l2)
	local lend = math.max(l1, l2)
	local o = {
		lstart = lstart,
		lend = lend,
	}
	return o
end

local function get_commit(range_table)
	local query = [[
  (comment) @comment
]]
	local captures = vim.treesitter.query.parse("lua", query)
	local tree = vim.treesitter.get_parser():parse()[1]
	for id, node, metadata in captures:iter_captures(tree:root(), 0, range_table.lstart - 1, range_table.lend) do
		local start_row, start_col, end_row, end_col = node:range()
		start_row = start_row + 1
		end_row = end_row + 1
		print(start_row, start_col, end_row, end_col)
	end
end

function eraser.init()
	vim.api.nvim_create_user_command("EraseCommit", function()
		local range = make_range()
		-- lib.print(range)
		print(range.lend, range.lstart)
		get_commit(range)
	end, {})
	local map = vim.api.nvim_set_keymap
	local opt = { noremap = true, silent = true }
	map("n", "<F4>", "<cmd>EraseCommit<CR>", opt)
	map("v", "<F4>", "<cmd>EraseCommit<CR>", opt)
end

return eraser
