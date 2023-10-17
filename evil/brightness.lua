-- Provides:
-- evil::brightness
--      value (integer)
local awful = require("awful")

local function emit()
	awful.spawn.with_line_callback('sh -c "light -G"', {
		stdout = function(line)
			local value = math.floor(tonumber(line))
			awesome.emit_signal("evil::brightness", value)
		end,
	})
end

-- Run once to initialize widgets
emit()

-- Subscribe to backlight changes
-- Requires inotify-tools
local subscribe = [[ bash -c "while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done"]]

-- Kill old inotifywait process
awful.spawn.easy_async_with_shell(
	"ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		-- Update brightness status with each line printed
		awful.spawn.with_line_callback(subscribe, {
			stdout = function()
				emit()
			end,
		})
	end
)
