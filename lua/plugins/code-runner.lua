local code_runner_conf = {
	mode = "tab",
	filetype = {
		java = {
			"cd $dir &&",
			"javac $fileName &&",
			"java $fileNameWithoutExt",
		},
		python = "python3 -u",
		typescript = "deno run",
		rust = {
			"cd $dir &&",
			"rustc $fileName &&",
			"$dir/$fileNameWithoutExt",
		},
		c = function()
			---@diagnostic disable-next-line: lowercase-global
			c_base = {
				"cd $dir &&",
				"gcc $fileName -o",
				"/tmp/$fileNameWithoutExt",
			}
			local c_exec = {
				"&& /tmp/$fileNameWithoutExt &&",
				"rm /tmp/$fileNameWithoutExt",
			}
			vim.ui.input({ prompt = "Add more args:" }, function(input)
				c_base[4] = input
				vim.print(vim.tbl_extend("force", c_base, c_exec))
				require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
			end)
		end,
	},
}

local config = {
	"CRAG666/code_runner.nvim",
	config = function()
		require("code_runner").setup(code_runner_conf)
	end,
}

return config
