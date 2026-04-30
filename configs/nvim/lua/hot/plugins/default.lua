local plugins = table.filter_no({
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "slant",
				always_show_bufferline = true,
				show_buffer_close_icons = true,
			},
		},
	},
	{ "neovim/nvim-lspconfig", config = require("hot.lspconfig") },
	cc.no({ "nvimtools/hydra.nvim" }),
	cc._o({
		"numToStr/FTerm.nvim",
		config = function()
			require("FTerm").setup({
				border = "double",
				dimensions = {
					height = 0.9,
					width = 0.9,
				},
			})
		end,
	}),
	require("hot.plugins.conform"),
	require("hot.plugins.flash_nvim"),
	require("hot.plugins.telescope"),
	require("hot.plugins.treesitter"),
	cc.require("hot.plugins.noice"),
	cc.require("hot.plugins.copilot"),
	cc.require("hot.plugins.cmp"),
	require("hot.plugins.markmap"),
	require("hot.plugins.themes"),
	require("hot.plugins.which-key"),
	cc.require("hot.plugins.lualine"),
	require("hot.plugins.indent-blank"),
	require("hot.plugins.nvim-ts-autotag"),
	-- require("hot.plugins.emmet-vim"),
}, nil)

return plugins
