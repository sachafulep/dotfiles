local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local bar = {}

function update_volume_widget(widget)
    local volume_command = "/home/sacha/Documents/scripts/volume.sh"

    awful.spawn.easy_async(
        volume_command,
        function(stdout, stderr, reason, exit_code)
            widget.text = "VOL " .. stdout
        end
    )
end

function toggle_systray(widget)
    awful.spawn.easy_async(
        "pgrep steam",
        function(stdout, stderr, reason, exit_code)
            local steamIsOn = string.len(stdout) ~= 0
            if steamIsOn == false then
                widget:set_forced_width(0)
            else
                widget:set_forced_width(nil)
            end
        end
    )
end

function clock()
    local textclock_widget = wibox.widget.textclock('<span font="SF Mono 20"> %H:%M </span>')
    return create_block(textclock_widget)
end

function date()
    local textclock_date_widget = wibox.widget.textclock('<span font="SF Mono 20"> %a, %b %d </span>')
    return create_block(textclock_date_widget)
end

function volume()
    local textbox_widget =
        wibox.widget {
        font = "SF Mono 20",
        valign = "top",
        align = "center",
        forced_width = 130,
        widget = wibox.widget.textbox
    }

    local volume_widget =
        wibox.widget(
        {
            top = 18,
            textbox_widget,
            widget = wibox.container.margin
        }
    )

    update_volume_widget(textbox_widget)

    awesome.connect_signal(
        "volume",
        function()
            update_volume_widget(textbox_widget)
        end
    )

    return create_block(volume_widget)
end

function systray()
    local systray = wibox.widget.systray()
    local block = create_block(systray)
    toggle_systray(block)

    systray:connect_signal(
        "widget::layout_changed",
        function()
            toggle_systray(block)
        end
    )

    return block
end

function cpu()
    local textbox_widget =
        wibox.widget {
        font = "SF Mono 20",
        valign = "top",
        align = "left",
        forced_width = 110,
        widget = wibox.widget.textbox
    }

    local cpu_widget =
        wibox.widget(
        {
            top = 18,
            left = 25,
            textbox_widget,
            widget = wibox.container.margin
        }
    )

    awful.widget.watch(
        "/home/sacha/Documents/scripts/cpu.sh",
        1,
        function(widget, stdout)
            local string = string.gsub(stdout, "\n", "")
            local number = tonumber(string)
            local rounded_number = math.floor(number + 0.5)
            local new_string = tostring(rounded_number)

            textbox_widget.text = "CPU " .. new_string
        end
    )

    return create_block(cpu_widget)
end

function memory()
    local textbox_widget =
        wibox.widget {
        font = "SF Mono 20",
        valign = "top",
        align = "left",
        forced_width = 110,
        widget = wibox.widget.textbox
    }

    local mem_widget =
        wibox.widget(
        {
            top = 18,
            left = 40,
            textbox_widget,
            widget = wibox.container.margin
        }
    )

    awful.widget.watch(
        "/home/sacha/Documents/scripts/memory.sh",
        1,
        function(widget, stdout)
            local string = string.gsub(stdout, "\n", "")
            local number = tonumber(string) / 1000
            -- local new_string = string.sub(tostring(number), 0, 3)
            local new_string = string.sub(tostring(number), 0, 1)

            textbox_widget.text = "MEM " .. new_string
        end
    )

    return create_block(mem_widget)
end

function create_block(child)
    local rounded_rect = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end

    local parent =
        wibox.widget(
        {
            {
                {
                    child,
                    right = 30,
                    left = 30,
                    widget = wibox.container.margin
                },
                bg = "#0C0919",
                fg = "#D9CADD",
                shape = rounded_rect,
                widget = wibox.container.background
            },
            layout = wibox.layout.align.horizontal
        }
    )

    return parent
end

function bar.create_wibar(s)
    s.mywibox =
        awful.wibar(
        {
            position = "bottom",
            screen = s,
            height = 90,
            bg = "#00000000"
        }
    )

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 20,
                cpu(),
                memory()
            },
            left = 20,
            bottom = 20,
            widget = wibox.container.margin
        },
        {
            -- Middle widget
            layout = wibox.layout.fixed.horizontal
        },
        {
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = 20,
                systray(),
                volume(),
                date(),
                clock()
            },
            right = 20,
            bottom = 20,
            widget = wibox.container.margin
        }
    }
end

return bar
