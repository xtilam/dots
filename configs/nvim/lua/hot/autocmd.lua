vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.cmd("setlocal winhl=Normal:Normal")
	end,
})
