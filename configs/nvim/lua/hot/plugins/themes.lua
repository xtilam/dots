local m = hot.add(...)

-- local function term_color()
-- end

local set_theme = function(theme)
	vim.defer_fn(function()
		vim.cmd.colorscheme(theme)
		-- term_color()
	end, 1)
end

local tokyo = {
	"folke/tokyonight.nvim",
	config = function()
		require("tokyonight").setup({
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			terminal_colors = false,
		})
		set_theme("tokyonight")
	end,
}

m:on_reload(tokyo.config)
return tokyo
