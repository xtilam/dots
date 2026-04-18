local m = hot.add(...)
local e = m.exports

require("utils.capture")

local zellij = require("hot.zellij")
local buf = require("utils.vim_buf")
local nvim_lua = vim.fn.exepath("nvim-lua")

function e.open(path, reset)
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

function e.tere(action)
	local cwd = vim.fn.getcwd()
	local file_path = buf.is_file() and buf.file_path() or cwd

	local cli = table.concat({
		"tere",
		action,
		"-e 'NVIM=" .. vim.v.servername .. "'",
		string.format("-a '%s --defer 10 -- %s -- -s'", nvim_lua, "vim.cmd.edit(v[1])"),
		string.format("-c '%s'", vim.fn.getcwd()),
		string.format("-t '%s'", file_path),
	}, " ")

	os.capture(cli)
end

function e.format_code()
	if not vim.bo.filetype then
		return
	end
	require("conform").format({ buffn = vim.bo })
end

return e
