string.fm = function(str, map, template)
	local rs = str:gsub("{(" .. (template or "[%w_]+") .. ")}", map)
	return rs
end
