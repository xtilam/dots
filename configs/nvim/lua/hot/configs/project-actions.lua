local m = hot.add(...)
local e = m.exports
local AutoKey = require("hot.autokey").AutoKey
local local_config_path = {}

local define = m:get("pd", function()
	local m = require("hot.configs.project-define")
	m.act = e
	return m
end)

local config_api = {
	ze = function()
		return require("hot.actions.term").ze().config.dimensions
	end,
	term = function(name)
		if name == "ze" then
			return require("hot.actions.term").ze()
		end
	end,
	hk = m:get("hk", AutoKey.new),
	load_dir = function(dir)
		e.load_config(dir .. "/nvim.lua")
	end,
}

function e.config(d)
	local_config_path = {}
	config_api.configs = nil
	config_api.hk:clear(true)
	define.setup(d, e)
end

function e.load_config(config_path)
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
		dd("Loaded config: ", config_path)
	else
		dd("Not found config: ", config_path)
	end
end

function e.trust(d, opts)
	local startWith = opts.startWith
	if opts then
		if opts.parrent_dir then
			startWith = opts.parrent_dir
		end

		if startWith then
			if d:sub(1, #startWith) ~= startWith then
				return
			end
		else
			return
		end
	end

	local_config_path[startWith .. "/nvim.lua"] = true
	local_config_path.root = d .. "/nvim.lua"
	local_config_path["nvim.lua"] = true
	local_config_path["./nvim.lua"] = true
	local_config_path[local_config_path.root] = true
	config_api.configs = opts
	e.load_config(local_config_path.root)
end
--------------------------------------
e.on_change_dir = function()
	local path = vim.fn.getcwd()
	vim.defer_fn(function()
		e.config(path)
	end, 1)
end

m:auto_cmd("DirChanged", e.on_change_dir)
m:auto_cmd("DirChanged", e.on_change_dir)
m:on_reload(e.on_change_dir)

if m.reloaded == 0 then
	dd("First load, run on_change_dir")
	e.on_change_dir()
end

m:auto_cmd("BufWritePost", {
	pattern = "*/nvim.lua",
	callback = function(evt)
		local isOk, err = pcall(function()
			if local_config_path[evt.file] or (evt and evt.file == "nvim.lua") then
				config_api.hk:clear(true)
				e.load_config(local_config_path.root)
			else
				dd("Not reload config: " .. evt.file, local_config_path.root)
			end
		end)

		if not isOk then
			dd("Error reloading config: " .. err)
		end
	end,
})

hot.event_onchange_dir = e.on_change_dir
return e
