local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local wibox = require("wibox")
local gears = require("gears")
local bar = require("bar")

terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {
        "quit",
        function()
            awesome.quit()
        end
    }
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
            {"open terminal", terminal}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        set_wallpaper(s)
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.suit.tile)

        if s.index == 1 then
            bar.create_wibar(s)
        end
    end
)
