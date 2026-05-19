table.filter = function(t, callback)
	local i = 1
	while i <= #t do
		if callback(t[i]) then
			i = i + 1
		else
			table.remove(t, i)
		end
	end
	return t
end

table.filter_no = function(t, value)
	return table.filter(t, function(v)
		return v ~= value
	end)
end
table.from = function(length, callback)
	local t = {}
	for i = 1, length do
		t[i] = callback(i)
	end
	return t
end
