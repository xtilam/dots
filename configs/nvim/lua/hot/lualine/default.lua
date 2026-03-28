local hm = hot.add(...)
local cache = hm.cache
local M = cache.get("_m", {})
local state = require("hot.state")

M.show_macro = {
	cache.fn("show_macro", function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "󰑋  Recording @" .. recording_register
		end
	end),
}

M.copilot = {
	cache.fn("copilot", function()
		local status = require("copilot.api").status.data.status
		local icon = ""
		if status == "InProgress" then
			icon = "?"
		elseif status == "Warning" then
			icon = ""
		end
		return icon .. " "
	end),
	cond = function()
    return state.is_copilot_running()
	end,
	color = cache.fn("copilot_color", function()
		return { fg = "#6cc644" }
	end),
}

M.custom_mode = {
	cache.fn("hydra", function()
		return state.hydra_mode or ""
	end),
	color = cache.fn("hydra_color", function()
		return { fg = "#ff0000", bold = true }
	end),
}

return M
