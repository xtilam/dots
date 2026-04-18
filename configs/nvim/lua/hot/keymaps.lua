local m = hot.add(..., true)
local km = require("hot.autokey").km
local act = require("hot.actions.default")
local buf = require("utils.vim_buf")
local s = require("hot.state")

m:on_reload(function()
	if s.copilot ~= 1 then
		vim.cmd("Copilot disable")
		return
	end
	if not s.is_copilot_running() then
		vim.cmd("Copilot enable")
	end
end)

km:clear()

km:del("", "<C-s>")
km:del("", "<C-w>")
km:set({ "n" }, "tt", vim.lsp.buf.rename, { desc = "Rename Lsp" })
km:set({ "n", "v", "i" }, "<C-s>", require("hot.actions.write_file"), { desc = "Write file" })
km:set({ "n" }, "<leader>ww", require("hot.actions.write_file"), { desc = "Write file" })
km:set({ "n" }, "<leader>ww", require("hot.actions.write_file"), { desc = "Write file" })
km:set("n", "<M-q>", "<cmd>qa!<CR>", { desc = "Close nvim" })
km:set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
km:set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
km:set("t", "<M-q>", "<cmd>bd!<CR>", { desc = "Terminal normal mode" })
km:set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Find word" })
km:set("n", "<leader>fh", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
km:set("n", "<leader>ff", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in buffer" })
km:set("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
km:set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
km:set("n", "<leader>fl", "<cmd>nohlsearch<CR>")
km:set("n", "<leader>fs", "<cmd>e ~/dev-configs/configs/nvim/lua/hot/state.lua<CR>", { desc = "Setting state" })
km:set("n", "<M-l>", "<C-i>", { noremap = true, silent = true })
km:set("n", "<M-h>", "<C-o>", { noremap = true, silent = true })
km:set("n", "th", "[%", { remap = true, desc = "Go to matching pair" })
km:set("n", "tl", "]%", { remap = true, desc = "Go to matching pair" })
km:set("n", "gs", require("flash").treesitter, { desc = "Flash Treesitter" })
km:set({ "n", "i" }, "<M-S-F>", act.format_code, { desc = "Conform format" })
km:set({ "n" }, "<leader>cf", act.format_code, { desc = "Conform format" })
km:set("n", "<leader>cc", _fn("(f)copy(f())", buf.file_path), { desc = "Copy path" })
km:set("n", "<leader>cd", _fn("(f)copy(f())", vim.fn.getcwd), { desc = "Copy CWD" })
km:set({ "n", "i", "v" }, "<M-n>", bind(act.tere, "yazi"), { desc = "Tere yazi" })
km:set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
km:set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
km:set("n", "tw", require("hot.hydra.window").start, { desc = "Window Mode" })
km:set("n", "tv", "gvo<Esc>", { desc = "Go to end last visual" })
km:set("v", "u", function() end, { desc = "Override lowercase" })

require("hot.actions.term").setup({
	copilot = "<M-t>",
	projects = "<M-p>",
	zellij = "<M-m>",
})

km:set("n", "<M-u>", function() end, { desc = "No action" })
