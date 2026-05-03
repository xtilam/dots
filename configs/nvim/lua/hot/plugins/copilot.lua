hot.add(...)

local s = require("hot.state")

function s.set_copilot(value)
	local isRunning = #vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) > 0
	local check_value = value == 1
	if check_value ~= isRunning then
		if value then
			vim.cmd.Copilot("enable")
		else
			vim.cmd.Copilot("disable")
		end
	end

	s.copilot = value
end

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		opts = {
			enabled = false,
			suggestion = {
				auto_trigger = true,
				trigger_on_accept = true,
				debounce = 25,
				keymap = {
					accept = "<C-t>",
					next = "<C-Left>",
					prev = "<C-Right>",
					dismiss = "<C-\\>",
				},
			},
			panel = { enabled = true },
		},
	},
}
