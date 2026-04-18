local m = hot.add(...)

local ensure_installed = {
	"bash",
	"c",
	"diff",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"css",
}

m:auto_cmd("FileType", {
	pattern = ensure_installed,
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	opts = {
		autotag = {
			enable = true,
			filetypes = {
				"html",
				"xml",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"tsx",
				"jsx",
			},
		},
		ensure_installed = ensure_installed,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
		folds = { enable = true },
	},
	config = function()
		require("nvim-treesitter.install").compilers = { "clang", "gcc" }
		require("nvim-treesitter").install(ensure_installed)
		require("nvim-treesitter").setup({
			ensure_installed = ensure_installed,
		})
	end,
}
