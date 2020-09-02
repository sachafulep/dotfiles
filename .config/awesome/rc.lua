local awful = require("awful")
require("error")
require("rules")
require("signals")
require("menu")
local keys = require("keys")

awful.util.spawn("picom -b")
awful.util.spawn("/home/sacha/Documents/scripts/monitors.sh")
awful.util.spawn("wal -i /home/sacha/Pictures/Abstract3.jpg")
-- awful.util.spawn("/home/sacha/Documents/scripts/polybar.sh")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating
}
