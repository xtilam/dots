local m = hot.add(...)
local e = m.exports

local constants = require("hot.constants")
local Term = require("hot.float-term").Term
local setup = {}

local ze = nil

function e.open(path, reset)
	local is_dir = vim.fn.isdirectory(path) == 1
	if is_dir then
		dd("Opening directory: " .. path)
		vim.cmd("cd " .. path)
		if reset ~= false and ze then
			ze:close_buf()
		end
	else
		vim.cmd("edit " .. path)
	end
end

function setup.copilot(hk)
	local t = Term:init({
		ft = "copilot",
		cmd = "bash " .. constants.bin_file("copilot-task"),
		dimensions = {
			width = 0.5,
			height = 1,
			x = 1,
			y = 0.5,
		},
	})
	t:hk_global(hk, {
		{ "toggle", t.close },
		{ "<M-l>", t:get_change_demensions_callback({ x = 1 }) },
		{ "<M-h>", t:get_change_demensions_callback({ x = -1 }) },
		{ "<M-->", t:get_change_demensions_callback({ width = 1 }) },
		{ "<M-=>", t:get_change_demensions_callback({ width = -1 }) },
	})
	m:on_clean(t:get_clean_callback())
end

function setup.zellij(hk)
	ze = Term:init({
		cmd = ([[export PROJECT_DIR="$PWD"; (zellij attach {name} ||  zellij -s {name}) && zellij delete-session {name} || true ]]):fm({
			name = [[${PWD//\//\\}]],
		}),
		border = "none",
		auto_close = true,
		dimensions = {
			height = 2,
			width = 1,
		},
	})
	ze:hk_global(hk, {
		{ "toggle", ze.close },
	})
	m:on_clean(ze:get_clean_callback())
end

function setup.projects(hk)
	local t = Term:init({
		cmd = [[dir=$(ff --cd) && nvim-lua --defer 10 -- "require('hot.actions.term').open('$dir', 1)" || true]],
		auto_close = true,
		border = "none",
		dimensions = {
			height = 2,
			width = 0.7,
			x = 1,
		},
	})
	t:hk_global(hk, {
		{ "toggle", t.close },
	})
	m:on_clean(t:get_clean_callback())
end

e.setup = function(hk)
	for name, hk in pairs(hk) do
		local fn = setup[name]
		if fn then
			fn(hk)
		end
	end
end

return e

-- function e.copilot()
-- 	copilot:open()
-- 	if copilot.buf ~= copilot.hk_buf or is_dev then
-- 		copilot.hk_buf = copilot.buf
-- 		-- vim.keymap.set("t", "<M-t>", function()
-- 		-- 	copilot:close()
-- 		-- end, { buffer = copilot.buf, desc = "Close Copilot" })
--
-- 	-- 	vim.keymap.set("t", "<M-l>", function()
-- 	-- 		copilot:update_dimensions("x", 1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-h>", function()
-- 	-- 		copilot:update_dimensions("x", -1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-j>", function()
-- 	-- 		copilot:update_dimensions("height", 1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-k>", function()
-- 	-- 		copilot:update_dimensions("height", -1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-->", function()
-- 	-- 		copilot:update_dimensions("width", -1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-=>", function()
-- 	-- 		copilot:update_dimensions("width", 1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	--
-- 	-- 	vim.keymap.set("t", "<M-=>", function()
-- 	-- 		copilot:update_dimensions("width", 1)
-- 	-- 		copilot:apply_dimensions()
-- 	-- 	end, { buffer = copilot.buf })
-- 	-- end
-- end
