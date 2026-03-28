require("utils.string")

function _G.dd(...)
	local args = { ... }
	if #args == 1 then
		args = args[1]
	end

	vim.notify(vim.inspect(args))
end

function _G.bind(callback, ...)
	local bound = { ... }
	return function(...)
		local args = { unpack(bound) }
		for _, v in ipairs({ ... }) do
			args[#args + 1] = v
		end
		return callback(unpack(args))
	end
end

function _G.copy(str)
	if str then
		vim.fn.setreg("+", (str or "") .. "")
	end
end

function _G._fn(code, ...)
	local fn_code = ([[return function{code}end]]):fm({ code = code })
	local ok, module = pcall(load, fn_code)
	local fn = function()
		vim.notify("Error in lambda: " .. fn_code, vim.log.levels.ERROR)
	end

	if ok then
		fn = module()
	end

	return bind(fn, ...)
end

function _G.fake_combo(key, delay)
	local keys = vim.api.nvim_replace_termcodes(key, true, false, true)
	local press = function()
		vim.api.nvim_feedkeys(keys, "m", true)
	end
	delay = delay or 0
	if delay < 0 then
		return press
	else
		return bind(vim.defer_fn, press, delay)
	end
end

function _G.try_load(module)
	package.loaded[module] = nil
	local ok, mod = pcall(require, module)
	if not ok then
		vim.notify("Failed to load module: " .. module, vim.log.levels.ERROR)
		return nil
	end
	return mod
end
