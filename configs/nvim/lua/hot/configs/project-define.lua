local m = hot.add(...)
local e = m.exports


e.setup = function(dir)
  local trust = e.act.trust
	trust(dir, { parrent_dir = "/home/z41/funix/C" })
	trust(dir, { parrent_dir = "/home/z41/projects/mindmap" })
	trust(dir, { parrent_dir = "/home/z41/projects/zig-memory" })
	trust(dir, { parrent_dir = "/home/z41/projects/bun-memo" })
end

e.act = m:on_reload(function(require)
	return require("hot.configs.project-actions")
end)



return m.exports
