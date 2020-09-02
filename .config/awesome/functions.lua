local awful = require("awful")
local functions = {}

function functions.grab_focus()
	local screen = awful.screen.focused()
	local all_clients = screen.clients
	for i, c in pairs(all_clients) do
		if c:isvisible() then
			client.focus = c
		end
	end
end

return functions
