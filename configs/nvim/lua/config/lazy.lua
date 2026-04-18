local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.fn.serverstart()
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("utils.hot")
require("utils.common")


-- Setup lazy.nvim
require("lazy").setup({
	spec = require("hot.plugins.default"),
	change_detection = {
		enabled = false,
		notify = false,
	},
	checker = { enabled = true, notify = false },
})

require("config.mappings")
require("config.autocmds")
require("hot.options")
require("hot.keymaps")
