local M = {}

function M.setup()
	ps.sub_remote("hello", function(body)
		ya.notify({
			-- Title.
			title = "Hello, World!",
			-- Content.
			content = "Test",
			-- Timeout.
			timeout = 6.5,
			-- Level, available values: "info", "warn", and "error", default is "info".
			level = "info",
		})
    -- os.exit(0)
		return { "Hello, world!" }
	end)
end

function M.entry() end
return M
