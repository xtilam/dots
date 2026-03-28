local s = require("hot.state")

s.is_copilot_running = function()
	return #vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) > 0
end

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		opts = {
			enabled = s.copilot == 1,
			suggestion = {
				enabled = true,
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
