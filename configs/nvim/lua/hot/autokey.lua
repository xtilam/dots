local cache = hot.add(...).cache
cache.get("hk", {})
local M = {}

function M.del(...)
	local args = { ... }
	local mode = args[1]
	local key = args[2]
	pcall(vim.keymap.del, mode, key)
end

function M.set(...)
	local mode, key, _, opts = ...
	local is_ok = pcall(vim.keymap.set, ...)
	if not is_ok then
		dd("Failed to set keymap:", mode, key)
		return
	end

	table.insert(cache.hk, { mode, key })
end

function M.clear()
	for _, v in ipairs(cache.hk) do
		M.del(v[1], v[2])
	end
	cache.hk = {}
end


return M
