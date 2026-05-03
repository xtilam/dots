local m = hot.add(...)
local e = m.exports

local Term = require("FTerm.terminal")
local U = require("FTerm.utils")
local km = require("hot.autokey").km
local mhk = m:get("mhk", {})
local curTerm = nil

Term.sizes = {
	height = { 0.5, 0.75, 1 },
	width = { 0.2, 0.4, 0.6, 0.8, 1 },
	x = { 0, 0.5, 1 },
}

function Term:close_buf()
	local buf = self.buf
	if buf and vim.api.nvim_buf_is_loaded(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
end

function Term:get_clean_callback()
	local term = self
	return function()
		term:close_buf()
	end
end

function Term:get_change_demensions_callback(config)
	return function()
		for k, v in pairs(config) do
			self:update_dimensions(k, v)
		end
		self:apply_dimensions()
	end
end

function Term:update_dimensions(prop, step)
	local list = self._sizes[prop] or Term.sizes[prop]
	local dimensions = self.config.dimensions
	if not list then
		return
	end
	local idx = 1
	for i = #list, 1, -1 do
		if dimensions[prop] >= list[i] then
			idx = i
			break
		end
	end
	idx = idx + step
	if idx < 1 then
		idx = 1
	elseif idx > #list then
		idx = #list
	end
	local value = list[idx]
	if value then
		dimensions[prop] = value
	end
	return self
end

function Term:config_size(dimensions, sizes)
	if sizes then
		self._sizes = sizes
	else
		self._sizes = {}
	end
	for k, v in pairs(dimensions) do
		if Term.sizes[k] == "table" then
			self.config.dimensions[k] = v
			self.update_dimensions(k, 0)
		end
	end
	self:apply_dimensions(true)
	return self
end
function Term:apply_dimensions(check_win)
	if check_win and not (self.win and U.is_win_valid(self.win)) then
		return
	end

	if self._on_resize then
		pcall(self._on_resize, self.config.dimensions, self)
	end

	self:close()
	self:open()
end

function Term:on_resize(fn)
	if type(fn) ~= "function" then
		fn = nil
	end
	self._on_resize = fn
	return self
end

function Term:start()
	self:open()
	local ghk = self.ghk
	local opts = ghk[3]
	local list_hk = ghk[2]
	if not opts.is_local then
		for hk, term in pairs(mhk) do
			vim.keymap.set("t", hk, function()
				self.ghk.close(self)
				term:start()
			end, { buffer = self.buf })
		end
	end

	for idx = 1, #list_hk do
		local i = list_hk[idx]
		vim.keymap.set(i[1], i[2], i[3], { buffer = self.buf })
	end

	curTerm = self
end
function Term:init(...)
	local term = require("FTerm"):new(...)
	term._sizes = {}
	return term
end

function Term:use_hot_clean(m)
	m:on_clean(self:get_clean_callback())
	return self
end

function Term:hk_global(hk, hk_buf)
	if self.ghk then
		km:del("n", self.ghk[1])
		mhk[self.ghk[1]] = nil
	end

	local close_fn = nil
	local list_hk = {}
	local opts = { is_local = false }
	for _, i in pairs(hk_buf) do
		local mode = "t"
		local bhk = i[1]
		local action = i[2]
		if type(action) == "function" then
			action = bind(action, self)
		else
			goto continue
		end

		if bhk == "toggle" then
			bhk = hk
			close_fn = action
		end

		table.insert(list_hk, { mode, bhk, action })
		::continue::
	end

	km:set("n", hk, bind(self.start, self))
	self.ghk = { hk, list_hk, opts }

	if not close_fn then
		close_fn = self.close
	end
	self.ghk.close = close_fn
	mhk[hk] = self
	return self
end

e.Term = Term
m:auto_cmd("VimResized", {
	pattern = "*",
	callback = function()
		if curTerm then
			curTerm:apply_dimensions(true)
		end
	end,
})
return e
