local M = hot.add(...).cache.get("m", {})

M.bin_path = vim.fn.stdpath("config") .. "/bin/"
M.bin_file = function(name)
	return M.bin_path .. name
end

M.nvim_remote = M.bin_path .. "nvim_remote_open.sh"

return M
