local M = hot.add(...).cache.get("m", {})

require("utils.capture")
local zellij = require("hot.zellij")
local buf = require("utils.vim_buf")
local fterm = require("FTerm")
local nvim_lua = vim.fn.exepath("nvim-lua")

M.open = function(path, reset)
	local is_dir = vim.fn.isdirectory(path) == 1
	if is_dir then
		dd("Opening directory: " .. path)
		vim.cmd("cd " .. path)
		if reset ~= false then
			zellij.kill()
		end
	else
		vim.cmd("edit " .. path)
	end
end

local project_ff = fterm:new({
	cmd = [[dir=$(ff p "get-path-project {}") && nvim-lua --defer 10 -- "require('hot.actions.default').open('$dir', 1)" ]],
	auto_close = true,
	dimensions = {
		height = 0.9,
		width = 0.9,
	},
})

function M.tere(action)
	local cwd = vim.fn.getcwd()
	local file_path = buf.is_file() and buf.file_path() or cwd
	local cli = table.concat({
		"tere",
		action,
		"-e 'NVIM=" .. vim.v.servername .. "'",
		string.format("-a '%s --defer 10 -- %s -- -s'", nvim_lua, 'vim.cmd.edit(v[1])'),
		string.format("-c '%s'", vim.fn.getcwd()),
		string.format("-t '%s'", file_path),
	}, " ")

	os.capture(cli)
end

function M.projects()
	project_ff:open()
	local buf = project_ff.buf
	vim.keymap.set("t", "<Esc>", function()
		project_ff:close()
	end, { buffer = buf })
end

function M.format_code()
	if not vim.bo.filetype then
		return
	end
	require("conform").format({ buffn = vim.bo })
end

return M
