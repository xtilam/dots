return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup({
			preset = "helix",
			spec = {},
			delay = 0, -- Nhấn t là hiện menu luôn, đéo chờ đợi gì hết
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
	end,

	-- keys = {
	-- 	"<leader>",
	-- 	"<c-w>",
	-- 	'"',
	-- 	"'",
	-- 	"`",
	-- 	"c",
	-- 	"v",
	-- 	"g",
	-- 	"t",
	-- },
}
