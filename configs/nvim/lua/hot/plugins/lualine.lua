local state = require("hot.state")
local m = hot.add(...)

local show_macro = {
	m:fn("show_macro", function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "󰑋  Recording @" .. recording_register
		end
	end),
}

local copilot = {
	m:fn("copilot", function()
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
	color = m:fn("copilot_color", function()
		return { fg = "#6cc644" }
	end),
}
local custom_mode = {
	m:fn("hydra", function()
		return state.hydra_mode or ""
	end),
	color = m:fn("hydra_color", function()
		return { fg = "#ff0000", bold = true }
	end),
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
					refresh_time = 16, -- ~60fps
					events = {
						"WinEnter",
						"BufEnter",
						"BufWritePost",
						"SessionLoadPost",
						"FileChangedShellPost",
						"VimResized",
						"Filetype",
						"CursorMoved",
						"CursorMovedI",
						"ModeChanged",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					custom_mode,
					copilot,
					show_macro,
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
