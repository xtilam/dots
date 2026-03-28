local M = {}

function M.is_file()
	return vim.bo.buftype == ""
end

function M.dir()
	if M.is_file() then
		return vim.fn.expand("%:p:h")
	end
end

function M.file_path()
	if M.is_file() then
		return vim.fn.expand("%:p")
	end
end

return M
