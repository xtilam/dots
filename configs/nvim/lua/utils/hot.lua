local M = {}
local modules_data = {}
local auto_reload_modules = {}
local stack_loaded = {}

_G.hot = M
_G.hot.debugger = false

local function try_call(func, ...)
	local isOk, rs = pcall(func, ...)
	if not isOk then
		if _G.hot.debugger then
			dd("Error calling function:", rs)
		end
		return nil
	end
	return rs
end

local function try_load(module_name)
	local success, result = pcall(require, module_name)
	if not success then
		dd("Error loading module:", module_name, result)
		return nil
	end
	table.insert(stack_loaded, module_name)
	return result
end

function reset(module_name)
	if modules_data[module_name] == nil then
		return
	end
	package.loaded[module_name] = nil
	for module, _ in pairs(auto_reload_modules) do
		package.loaded[module] = nil
	end

	try_load(module_name)
	for module, _ in pairs(auto_reload_modules) do
		try_load(module)
	end

	if #stack_loaded > 0 then
		dd("Reloaded module:", stack_loaded)
	end

	stack_loaded = {}
end

local Cache = {}
Cache.__index = Cache
local Module = {}
Module.__index = Module

function Cache:new()
	return setmetatable({}, Cache)
end

function Cache:get(key, default_value, ...)
	local entry = self[key]
	local should_update = false
	local deps = { ... }

	if entry == nil then
		should_update = true
	else
		local entry_deps = entry[2]
		if #entry_deps ~= #deps then
			should_update = true
		else
			for i = 1, #deps do
				if entry_deps[i] ~= deps[i] then
					should_update = true
					break
				end
			end
		end
	end

	if should_update then
		local value
		if type(default_value) == "function" then
			value = default_value()
		else
			value = default_value
		end
		self[key] = { value, { ... } }
		return value
	end

	return entry[1]
end

function Cache:reset(key, ...)
  self[key] = nil
  return self:get(key, ...)
end

function Cache:fn(name, callback, ...)
	return self:get("_fn_" .. name, function()
		return callback
	end, ...)
end

function Module:new()
	return setmetatable({
		cache = Cache:new(),
		exports = {},
		reloaded = 0,
		_cleanup = {},
		_auto_cmds = {},
	}, Module)
end

function Module:on_reload(callback)
	if self.reloaded > 0 then
		try_call(callback)
	end
end

function Module:on_clean(callback)
	table.insert(self._cleanup, callback)
end

function Module:auto_cmd(...)
	local args = { ... }
	local id = try_call(vim.api.nvim_create_autocmd, unpack(args))
	if id ~= nil then
		table.insert(self._auto_cmds, id)
	end
end

function Module:run_cleanup()
	for i = 1, #self._cleanup do
		try_call(self._cleanup[i])
	end

	for i = 1, #self._auto_cmds do
		try_call(vim.api.nvim_del_autocmd, self._auto_cmds[i])
	end
	self._cleanup = {}
end

function Module:fn(...)
	return self.cache:fn(...)
end

function Module:get(...)
	return self.cache:get(...)
end

function Module:reset(...)
	return self.cache:reset(...)
end

function M.add(module, is_auto_reload)
	local data = modules_data[module]
	if data == nil then
		data = Module:new()
		modules_data[module] = data
	else
		data.reloaded = data.reloaded + 1
		data:run_cleanup()
	end

	if is_auto_reload then
		auto_reload_modules[module] = true
	end

	return data
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("AutoReloadLua", { clear = true }),
	pattern = { os.getenv("HOME") .. "/dev-configs/configs/nvim/lua/**/*.lua" },
	callback = function(args)
		local path = vim.fn.fnamemodify(args.file, ":p")
		local module_name = path:match("lua/(.-)%.lua$")
		if module_name then
			module_name = module_name:gsub("/", ".")
			package.loaded[module_name] = nil
			reset(module_name)
		end
	end,
})
