local m = hot.add(...)
local e = m.exports
local AutoKey = require("hot.autokey").AutoKey
local l = {}
local local_config_path = {}
local config_api = {
	ze = function()
		return require("hot.actions.term").ze().config.dimensions
	end,
	hk = m:get("hk", AutoKey.new),
	load_dir = function(dir)
		l.load_local_config(dir .. "/nvim.lua")
	end,
}

function l.config(d)
	local_config_path = {}
	config_api.configs = nil
	config_api.hk:clear(true)
	l.use_local_config(d, { parrent_dir = "/home/z41/funix/C" })
end

function l.load_local_config(config_path)
	if vim.fn.filereadable(config_path) == 1 then
		local isOk, rs = pcall(dofile, config_path)
		if not isOk then
			dd("Error loading config: " .. rs)
			return
		else
			if type(rs) == "function" then
				local isOk, err = pcall(rs, config_api)
				if not isOk then
					dd("Error running config: " .. err)
					return
				end
			end
		end
		dd("Loaded config: " .. config_path)
	else
		dd("Not found config: " .. config_path)
	end
end

function l.use_local_config(d, opts)
	if opts then
		local startWith = opts.startWith
		if opts.parrent_dir then
			startWith = opts.parrent_dir
		end
		local_config_path[startWith .. "/nvim.lua"] = true
		if startWith then
			if d:sub(1, #startWith) ~= startWith then
				return
			end
		end
	end

	local_config_path.root = d .. "/nvim.lua"
	local_config_path["nvim.lua"] = true
	local_config_path["./nvim.lua"] = true
	local_config_path[local_config_path.root] = true
	config_api.hk:clear()
	config_api.configs = opts
	l.load_local_config(local_config_path.root)
end
--------------------------------------
e.on_change_dir = function()
	local path = vim.fn.getcwd()
	vim.defer_fn(function()
		l.config(path)
	end, 1)
end

m:auto_cmd("DirChanged", e.on_change_dir)
m:auto_cmd("DirChanged", e.on_change_dir)
m:on_reload(e.on_change_dir)

m:auto_cmd("BufWritePost", {
	pattern = "*/nvim.lua",
	callback = function(evt)
		local isOk, err = pcall(function()
			if local_config_path[evt.file] or (evt and evt.file == "nvim.lua") then
				dd("Reload config: " .. evt.file)
				l.load_local_config(local_config_path.root)
			else
				dd("Not reload config: " .. evt.file, local_config_path)
			end
		end)

		if not isOk then
			dd("Error reloading config: " .. err)
		end
	end,
})
hot.event_onchange_dir = e.on_change_dir
return e
