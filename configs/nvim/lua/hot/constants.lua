local e = hot.add(...).exports

e.bin_path = vim.fn.stdpath("config") .. "/bin/"
e.bin_file = function(name)
	return e.bin_path .. name
end

e.nvim_remote = e.bin_path .. "nvim_remote_open.sh"
e.tere_task = e.bin_path .. "tere_task.sh"
e.zellij_task = e.bin_path .. "zellij.sh"

return e
