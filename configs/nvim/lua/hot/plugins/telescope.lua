return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local action_state = require("telescope.actions.state")

		-- Hàm custom để toggle hidden
		local toggle_hidden = function(prompt_bufnr)
			local current_picker = action_state.get_current_picker(prompt_bufnr)
			local opts = {
				hidden = not current_picker.finder.hidden,
				default_text = current_picker:_get_prompt(),
			}
			-- Đóng cửa sổ hiện tại và mở cái mới với option ngược lại
			require("telescope.actions").close(prompt_bufnr)

			-- Loại bỏ .git thủ công nếu dùng fd
			builtin.find_files({
				hidden = opts.hidden,
				default_text = opts.default_text,
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--exclude", ".git" },
			})
		end

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-h>"] = toggle_hidden,
					},
					n = {
						["<C-h>"] = toggle_hidden,
					},
				},
			},
		})
		telescope.load_extension("fzf")
	end,
}
