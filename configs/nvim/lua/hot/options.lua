hot.add(...)
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.confirm = true
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.switchbuf = "useopen,usetab"
vim.g.copilot_no_tab_map = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.showcmdloc = "statusline"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true

-- require("themes.dracula").setup()
if vim.g.neovide then
	vim.o.guifont = "Cascadia Code NF:h14" -- text below applies for VimScript
	vim.g.neovide_no_idle = true
	vim.g.neovide_title_background_color = "0" -- Cái này tùy chọn
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	-- Dòng chính đây:
	vim.g.neovide_input_use_logo = 1
	vim.g.neovide_cursor_animation_length = 0.13
end
