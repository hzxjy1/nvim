local ok_ibl, ibl = pcall(require, "ibl")
local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
local ok_marks, marks = pcall(require, "marks")
local transformer = {}
local status = true
-- marks.nvim only offers a plain toggle_signs(), mirror its state to avoid desync
local marks_shown = true

function transformer.toggle()
	status = not status

	if status then
		vim.cmd("set number relativenumber")
	else
		vim.cmd("set nonumber norelativenumber")
	end
	vim.diagnostic.enable(status)
	vim.lsp.inlay_hint.enable(status)
	if ok_ibl then
		ibl.update({ enabled = status })
	end
	if ok_gitsigns then
		gitsigns.toggle_signs(status)
		gitsigns.toggle_current_line_blame(status)
	end
	if ok_marks and marks_shown ~= status then
		marks.toggle_signs()
		marks_shown = status
	end
end

return transformer
