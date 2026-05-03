local m = hot.add(...)
local e = m.exports

local constants = require("hot.constants")
local Term = require("hot.float-term").Term
local setup = {}
local ze = nil
function cacheTerm(name, opts)
	local term = m:get(name, function()
		return Term:init(opts)
	end)
	for k, v in pairs(opts) do
		term.config[k] = v
	end
	return term
end

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
	local t = cacheTerm("copilot", {
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
		{
			"toggle",
			t.toggle,
		},
		{ "<M-q>", bind(t.toggle, t) },
		{ "<M-l>", t:get_change_demensions_callback({ x = 1 }) },
		{ "<M-h>", t:get_change_demensions_callback({ x = -1 }) },
		{ "<M-->", t:get_change_demensions_callback({ width = -1 }) },
		{ "<M-=>", t:get_change_demensions_callback({ width = 1 }) },
	})
	m:on_clean(t:get_clean_callback())
end

function setup.zellij(hk)
	ze = Term:init({
		cmd = ([[export PROJECT_DIR="$PWD"; (zellij attach {name} ||  zellij -s {name}) && zellij delete-session {name} || true ]]):fm({
			name = [[${PWD//\//_}]],
		}),
		border = "none",
		auto_close = true,
		dimensions = {
			height = 2,
			width = 1,
			x = 1,
		},
	})
	ze:hk_global(hk, {
		{ "toggle", ze.close },
		{ "<M-S-L>", ze:get_change_demensions_callback({ x = 1 }) },
		{ "<M-S-H>", ze:get_change_demensions_callback({ x = -1 }) },
		{ "<M-->", ze:get_change_demensions_callback({ width = -1 }) },
		{ "<M-=>", ze:get_change_demensions_callback({ width = 1 }) },
	})
	m:on_clean(ze:get_clean_callback())
end

function setup.projects(hk)
	local t = cacheTerm("projects", {
		cmd = [[dir=$(ff --cd) && nvim-lua --defer 10 -- "hot.action_open(v[1])" -- -s "$dir" || true]],
		auto_close = true,
		border = "none",
		dimensions = {
			height = 2,
			width = 0.7,
			x = 1,
			y = 0,
		},
	})
	t:hk_global(hk, {
		{ "toggle", t.close },
	})

	m:on_clean(t:get_clean_callback())
end

e.setup = function(hk)
	if ze then
		ze:close_buf()
		ze = nil
	end

	for name, hk in pairs(hk) do
		local fn = setup[name]
		if fn then
			fn(hk)
		end
	end
end

e.ze = function()
	return ze
end

return e
