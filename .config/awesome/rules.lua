local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("keys")

beautiful.init("/home/sacha/.config/awesome/themes/default/theme.lua")

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.centered,
      floating = false
    }
  },
  -- Floating clients.
  {
    rule_any = {
      instance = {},
      class = {
        "Arandr",
        "Gpick",
        "main.py"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
        "Open File"
      },
      role = {
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = {floating = true}
  },
  -- Add titlebars to normal clients and dialogs
  {
    rule_any = {
      type = {"normal", "dialog"}
    },
    properties = {titlebars_enabled = true}
  },
  {
    rule_any = {
      class = {"Polybar"}
    },
    properties = {border_width = 0, dockable = true, focusable = false, floating = true}
  },
  {
    rule_any = {
      class = {"main.py"}
    },
    properties = {titlebars_enabled = false}
  }
}
