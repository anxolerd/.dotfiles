local awful = require("awful")
local gears = require("gears")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local function volumebar()
  local request_command = 'amixer -D pulse sget Master'

  local bar_color = "#74aeab"
  local mute_color = "#ff0000"
  local background_color = "#3a3a3a"

  local icons = {
    [0]  = '🔈',
    [33] = '🔉',
    [66] = '🔊',
  }
  local mute_icon = '🔇'

  local volumebar_icon = wibox.widget.textbox()
  local volumebar_widget = wibox.widget {
      max_value = 1,
      forced_width = 50,
      paddings = 0,
      border_width = 0.5,
      color = bar_color,
      background_color = background_color,
      shape = gears.shape.bar,
      clip = true,
      margins       = {
          top = 10,
          bottom = 10,
      },
      widget = wibox.widget.progressbar
  }

  local update_graphic = function(widget, stdout, _, _, _)
      local mute = string.match(stdout, "%[(o%D%D?)%]")
      local volume = string.match(stdout, "(%d?%d?%d)%%")
      volume = tonumber(string.format("% 3d", volume))

      if mute == "off" then
          widget.color = mute_color
          widget.value = volume / 100;
          volumebar_icon:set_text(mute_icon .. ' ')
      else
          widget.color = bar_color
          widget.value = volume / 100;
          local icon = icons[0]
          for threshold, range_icon in pairs(icons) do
            if volume > threshold then
              icon = range_icon
            end
          end
          volumebar_icon:set_text(icon .. ' ')
      end
  end

  volumebar_widget:connect_signal("button::press", function(_,_,_,button)
      if (button == 4)     then awful.spawn("amixer -D pulse sset Master 5%+", false)
      elseif (button == 5) then awful.spawn("amixer -D pulse sset Master 5%-", false)
      elseif (button == 1) then awful.spawn("amixer -D pulse sset Master toggle", false)
      end

      spawn.easy_async(request_command, function(stdout, stderr, exitreason, exitcode)
          update_graphic(volumebar_widget, stdout, stderr, exitreason, exitcode)
      end)
  end)

  watch(request_command, 1, update_graphic, volumebar_widget)

  return wibox.widget {
    volumebar_icon,
    volumebar_widget,
    layout = wibox.layout.align.horizontal,
  }
end

return volumebar
