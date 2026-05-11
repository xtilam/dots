local m = hot.add(...)
local e = m.exports

require("utils.capture")

local buf = require("utils.vim_buf")
local tere_task = require("hot.constants").tere_task
local ze = require("hot.actions.term").ze

function e.open(path, reset)
	local is_dir = vim.fn.isdirectory(path) == 1
	if is_dir then
		dd("Opening directory: " .. path)
		vim.cmd("cd " .. path)
		if reset ~= false and ze then
			hot.event_onchange_dir()
			ze():close_buf()
		end
	else
		vim.cmd("edit " .. path)
	end
end

function e.tere(action)
	local cwd = vim.fn.getcwd()
	local file_path = buf.is_file() and buf.file_path() or cwd
	vim.fn.jobstart({
		"bash",
		tere_task,
		vim.fn.getcwd(),
		file_path,
	})
end

function e.format_code()
	if not vim.bo.filetype then
		return
	end
	require("conform").format({ buffn = vim.bo })
end

_G.hot.action_open = e.open

return e
