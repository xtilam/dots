local m = hot.add(...)

local function add_which_key()
	local wk = require("which-key")
	wk.add({
		{ "t", mode = "n", desc = "Custom" },
		{ "<leader>f", desc = "Telescope" },
		{ "<leader>b", desc = "Buffer" },
		{ "<leader>c", desc = "File, Code" },
		{ "<leader>n", desc = "Notification" },
		{ "<leader>a", desc = "AI" },
	})
end

m:on_reload(add_which_key)

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup({
			preset = "helix",
			spec = {},
			delay = 0,
			icons = {
				breadcrumb = "»",
				separator = "➜",
				group = "+",
			},
			triggers = {
				{ "<auto>", mode = "nixsoot" },
				{ "t", mode = { "n" } },
			},
		})
		add_which_key()
	end,
}
