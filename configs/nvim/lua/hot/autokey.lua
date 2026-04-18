local m = hot.add(...)
local e = m.exports

local AutoKey = e.AutoKey or {}
AutoKey.__index = AutoKey

function AutoKey:new()
	return setmetatable({ hk = {} }, AutoKey)
end

function AutoKey:del(...)
	local args = { ... }
	local mode = args[1]
	local key = args[2]
	pcall(vim.keymap.del, mode, key)
	self.hk[mode .. key] = nil
end

function AutoKey:set(...)
	local mode, key = ...
	local is_ok = pcall(vim.keymap.set, ...)
	if not is_ok then
		dd("Failed to set keymap:", mode, key)
		return
	end

	if type(mode) == "string" then
		mode = { mode }
	end
	for _, m in ipairs(mode) do
		self.hk[m .. key] = { m, key }
	end
end

function AutoKey:clear()
	local hk = self.hk
	for _, v in pairs(hk) do
		self:del(v[1], v[2])
	end
end

e.AutoKey = AutoKey
e.km = e.km or AutoKey:new()

return e
