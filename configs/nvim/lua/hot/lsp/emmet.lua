vim.lsp.config("emmet_ls", {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = {
		"css",
		"eruby",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"svelte",
		"pug",
		"typescriptreact",
		"vue",
	},
	init_options = {
		html = {
			options = {
				["bem.enabled"] = true,
			},
		},
	},
})

vim.lsp.enable("emmet_ls")
