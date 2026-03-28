local M = {}
local modules_data = {}
local auto_reload_modules = {}
local stack_loaded = {}

_G.hot = M

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

local function init_module()
	local module = {}
	local cache = {}
	local fn = {}
	local auto_cmds = {}

	module.cache = cache

	cache.get = function(key, default_value)
		if cache[key] == nil then
			if type(default_value) == "function" then
				cache[key] = default_value()
			else
				cache[key] = default_value
			end
		end
		return cache[key]
	end
	cache.fn = function(name, callback)
		local fn_idx = cache.get("_fn_idx_" .. name, #fn + 1)
		fn[fn_idx] = callback
		return function(...)
			return fn[fn_idx](...)
		end
	end
	module.on_reload = function(callback, fallback_on_hot)
		if module.hot then
			callback()
		elseif fallback_on_hot then
			fallback_on_hot()
		end
	end
	module.clear_auto_cmds = function()
		for _, id in ipairs(auto_cmds) do
			vim.api.nvim_del_autocmd(id)
		end
		auto_cmds = {}
	end
	module.lazy = function(callback)
		if not module.hot then
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				callback = callback,
			})
		else
			callback()
		end
		return module
	end

	function module.auto_cmd(...)
		local args = { ... }
		local ok, id = pcall(vim.api.nvim_create_autocmd, unpack(args))
		if ok then
			table.insert(auto_cmds, id)
			return id
		else
			dd("Error creating autocmd:", args, id)
		end
	end
	module.get = function()
		return module.cache, module.hot
	end
	return module
end

function M.add(module, is_auto_reload)
	local data = modules_data[module]
	if data == nil then
		data = init_module()
		modules_data[module] = data
	else
		data.hot = true
		data.clear_auto_cmds()
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
