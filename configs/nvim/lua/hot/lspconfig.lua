local m = hot.add(..., true)

function add(name)
	local module = "hot.lsp." .. name
	require(module)
	hot.add(module)
end

function setup()
	add("luals")
	add("tsls")
	add("jsonls")
	add("rust")
	add("tailwindcss")
	add("clangd")
	add("zig")

	vim.lsp.enable({ "html", "cssls" })
	vim.lsp.enable({ "bashls" })

end

return setup
