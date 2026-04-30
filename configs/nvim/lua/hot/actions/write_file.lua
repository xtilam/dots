local cache = hot.add(...)

return function()
	if vim.bo.buftype ~= "" then
		return
	end
	vim.cmd("write")
end
