local temp_buf_id = nil
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		local netrw_buf = vim.api.nvim_get_current_buf()

		vim.cmd("enew")
		temp_buf_id = vim.api.nvim_get_current_buf()

		vim.bo[temp_buf_id].buftype = "nofile"
		vim.bo[temp_buf_id].bufhidden = "wipe"

		pcall(vim.api.nvim_buf_delete, netrw_buf, { force = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			once = true,
			callback = function()
				local current_buf = vim.api.nvim_get_current_buf()

				if temp_buf_id and current_buf ~= temp_buf_id then
					if vim.api.nvim_buf_is_valid(temp_buf_id) then
						pcall(vim.api.nvim_buf_delete, temp_buf_id, { force = true })
						temp_buf_id = nil 
					end
				end
			end,
		})
	end,
})
