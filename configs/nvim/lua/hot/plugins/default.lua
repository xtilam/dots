return {
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
	{ "nvimtools/hydra.nvim" },
	{
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
	},
	require("hot.plugins.conform"),
	require("hot.plugins.flash_nvim"),
	require("hot.plugins.telescope"),
	require("hot.plugins.treesitter"),
	require("hot.plugins.noice"),
	require("hot.plugins.cmp"),
	require("hot.plugins.copilot"),
	require("hot.plugins.markmap"),
	require("hot.plugins.themes"),
	require("hot.plugins.which-key"),
	require("hot.plugins.lualine"),
	require("hot.plugins.indent-blank"),
  -- require("hot.plugins.emmet-vim"),
}
