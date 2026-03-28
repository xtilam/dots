local m = {}
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

function m.get_spinner()
	local index = math.floor(vim.uv.hrtime() / (100 * 1e6)) % #spinner_frames
	return spinner_frames[index + 1]
end

return m
