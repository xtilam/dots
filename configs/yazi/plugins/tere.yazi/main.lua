local M = {}

function M.setup()
	ps.sub_remote("force-close", function(code)
    os.execute("clear")
    os.exit(code)
	end)
end

function M.entry() end

return M
