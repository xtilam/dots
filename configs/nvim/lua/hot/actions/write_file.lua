local cache = hot.add(...)

return function()
	if vim.bo.buftype ~= "" then
		return
	end
	local data = vim.cmd("write")
end
