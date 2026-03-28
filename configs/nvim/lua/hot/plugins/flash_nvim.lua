return {
	"folke/flash.nvim",
	event = "VeryLazy",
	vscode = true,
	opts = {
		modes = {
			char = {
				enabled = false,
			},
		},
	},

	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},

		{
			"S",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
	},
}
