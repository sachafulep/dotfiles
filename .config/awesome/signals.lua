local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local functions = require("functions")

client.connect_signal(
    "manage",
    function(c)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end
)

client.connect_signal(
	"unmanage",
	function(c)
		functions.grab_focus()
	end
)

client.connect_signal(
    "request::titlebars",
    function(c)
        local buttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        local args = {size = dpi(35)}

        if c.class == "Xfce4-terminal" then
            args = {
                size = dpi(35),
                bg_normal = "#0C0919",
                bg_focus = "#0C0919",
                fg_normal = "#FFFFFF",
                fg_focus = "#FFFFFF"
            }
        end

        if c.class == "Spotify" then
            args = {
                size = dpi(35),
                bg_normal = "#FFA789",
                bg_focus = "#FFA789",
                fg_normal = "#FFFFFF",
                fg_focus = "#FFFFFF"
            }
        end

        local titlebar = awful.titlebar(c, args)

        titlebar:setup {
            {
                -- Left
                widget = wibox.container.margin,
                top = 11,
                bottom = 10,
                right = 0,
                left = 10,
                {
                    awful.titlebar.widget.closebutton(c),
                    awful.titlebar.widget.minimizebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    layout = wibox.layout.fixed.horizontal(),
                    spacing = 7
                }
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal(
-- "mouse::enter",
-- function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end
-- )

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

client.connect_signal (
	"manage",
	function(c)
		if c.class == "Spotify" then
			c.screen = 3  
		end
	end
)
-- }}}
