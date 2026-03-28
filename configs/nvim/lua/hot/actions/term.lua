local cache = hot.add(...).cache
local M = cache.get("m", {})
local fterm = require("FTerm")
local is_dev = 1

local copilot = cache.get("copilot", function()
	local term = fterm:new({
		ft = "copilot",
		cmd = "copilot",
		dimensions = {
			height = 0.5,
			width = 0.5,
		},
	})

	term.state = { posx = "center", posy = "center" }
	return term
end)

function M.copilot()
	copilot.config.dimensions.x = 0
	copilot:open()
	if copilot.buf ~= copilot.hk_buf or is_dev then
		copilot.hk_buf = copilot.buf
		vim.keymap.set("t", "<C-t>", function()
			copilot:close()
		end, { buffer = copilot.buf, desc = "Close Copilot" })

		vim.keymap.set("t", "<M-h>", function()
			copilot.state.posx = "left"
			copilot:update_state()
			copilot:resize()
		end, { buffer = copilot.buf, desc = "Resize Copilot" })

		vim.keymap.set("t", "<M-l>", function()
			copilot.state.posx = "right"
			copilot:update_state()
			copilot:resize()
		end, { buffer = copilot.buf, desc = "Resize Copilot" })

		vim.keymap.set("t", "<M-i>", function()
			copilot.state.posx = "center"
			copilot:update_state()
			copilot:resize()
		end, { buffer = copilot.buf, desc = "Resize Copilot" })
	end
end

pcall(function()
	local U = require("FTerm.utils")
	local A = vim.api
	local fn = vim.fn
	local cmd = A.nvim_command
	local pos_inc = { 0, 0.5, 1 }
	local size_inc = { 0.25, 0.5, 0.75, 1 }

	local Term = require("FTerm.terminal")
	function Term:resize()
		self:close()
		self:open()
		-- local cfg = self.config
		-- local dim = U.get_dimension(cfg.dimensions)
		-- vim.api.nvim_win_set_config(self.buf, {
		-- 	border = cfg.border,
		-- 	relative = "editor",
		-- 	style = "minimal",
		-- 	width = dim.width,
		-- 	height = dim.height,
		-- 	col = dim.col,
		-- 	row = dim.row,
		-- })
	end
end)
return M
