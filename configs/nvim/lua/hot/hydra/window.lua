local cache = hot.add(...).cache
local m = cache.get("m", {})

local hydra = require("hydra")
local lualine = require("lualine")
local state = require("hot.state")

vim.api.nvim_set_hl(0, "HydraCursor", { fg = "#ffffff", bg = "#ff0000" })

m.win = hydra({
	name = "Window",
	mode = "n",
	body = "<leader>whi",
	config = {
		hint = false,
		on_key = function()
			lualine.refresh({ force = true })
		end,
		on_exit = cache.fn("w_exit", function()
			state.hydra_mode = ""
			vim.api.nvim_set_hl(0, "Cursor", { bg = "#ffffff" })
			vim.opt.guicursor = vim.opt.guicursor:remove("n:HydraCursor")
		end),
	},
	heads = {
		{ "h", "<C-w>h" },
		{ "j", "<C-w>j" },
		{ "k", "<C-w>k" },
		{ "l", "<C-w>l" },
		{ "n", "<C-w>v" },
		{ "v", "<C-w>v" },
		{ "s", "<C-w>s" },
		{ "x", "<C-w>x" },
		{ "o", "<C-w>o" },
		{ "q", "<C-w>q" },
		{ "<S-L>", "<cmd>:vertical resize -2<CR>" },
		{ "<S-H>", "<cmd>:vertical resize +2<CR>" },
		{ "<S-J>", "<cmd>10:wincmd +<CR>" },
		{ "<S-K>", "<cmd>10:wincmd -<CR>" },
		{ "<Esc>", nil, { exit = true } },
	},
})

m.start = cache.fn("start", function()
	state.hydra_mode = "Window"
	lualine.refresh({ force = true })
	vim.opt.guicursor = vim.opt.guicursor:append("n:HydraCursor")
	m.win:activate()
end)

-- vim.opt.termguicolors = true
-- vim.api.nvim_set_hl(0, "TermCursor", { bg = "#ff0000", fg = "#ff0000" })
-- vim.opt.guicursor = "n:block-Cursor"
-- vim.opt.guicursor.append("n:FakeBlock")

return m
