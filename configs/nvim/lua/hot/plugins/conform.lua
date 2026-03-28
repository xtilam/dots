local m = hot.add(...)
local state = require("hot.state")

local cfg = {
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		sh = { "shfmt" },
		nix = { "nixfmt" },
		fish = { "custom_fish_indent" },
		kdl = { "custom_kdlfmt" },
	},
	formatters = {
		custom_fish_indent = {
			command = "sh",
			args = { "-c", "fish_indent | unexpand -t 4" },
		},
		custom_kdlfmt = {
			command = "sh",
			args = function()
				return { "-c", "kdlfmt format --kdl-version=$1 - | unexpand -t 4", "--", "v" .. state.kdlversion }
			end,
		},
	},
}

m.on_reload(function()
	local conform = require("conform")
	conform.formatters_by_ft = cfg.formatters_by_ft
	conform.formatters = cfg.formatters
end)

return {
	"stevearc/conform.nvim",
	opts = cfg,
}
