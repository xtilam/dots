local util = require("lspconfig.util")
local root_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}
local config = {
	default_config = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_dir = util.root_pattern(root_files),
		single_file_support = true,
		log_level = vim.lsp.protocol.MessageType.Warning,
	},
}

vim.lsp.config("lua_ls", config)
vim.lsp.enable("lua_ls")
