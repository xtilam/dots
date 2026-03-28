local hm = hot.add(...)
local m = hm.cache.get("m", {})
local fterm = require("FTerm")
if m.kill then
	m.kill()
end

local cli = ([[export PROJECT_DIR="$PWD"; (zellij attach {name} ||  zellij -s {name}) && zellij delete-session {name} || true ]]):fm({
	name = [[${PWD//\//\\}]],
})

local zellij_ft = fterm:new({
	cmd = cli,
	border = "none",
	auto_close = true,
	dimensions = {
		height = 2,
		width = 1,
	},
})

zellij_ft.buf_hk = -1

m.open = function()
	zellij_ft:open()
	local buf = zellij_ft.buf
	if zellij_ft.buf_hk ~= buf then
		zellij_ft.buf_hk = buf
		vim.keymap.set("t", "<M-m>", function()
			zellij_ft:close()
		end, { buffer = buf, desc = "Close Zellij" })

		vim.keymap.set({ "t", "n", "i" }, "<M-p>", function()
			zellij_ft:close()
			require("hot.actions.default").projects()
		end, { buffer = buf, desc = "Close Zellij" })
	end
end

m.kill = function()
	local buf = zellij_ft.buf
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
end

return m
