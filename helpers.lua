local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local awful = require("awful")
local gears = require("gears")
local helpers = {}

-- Mouse hover
-- =============================================
function helpers.add_hover_cursor(w, hover_cursor)
	local original_cursor = "left_ptr"

	w:connect_signal("mouse::enter", function()
		local w = _G.mouse.current_wibox
		if w then
			w.cursor = hover_cursor
		end
	end)

	w:connect_signal("mouse::leave", function()
		local w = _G.mouse.current_wibox
		if w then
			w.cursor = original_cursor
		end
	end)
end

-- Create rounded rectangle shape (in one line)
-- =============================================
helpers.rrect = function(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- Raise or spawn
-- =============================================
function helpers.run_or_raise(match, move, spawn_cmd, spawn_args)
	local matcher = function(c)
		return awful.rules.match(c, match)
	end

	-- Find and raise
	local found = false
	for c in awful.client.iterate(matcher) do
		found = true
		c.minimized = false
		if move then
			c:move_to_tag(mouse.screen.selected_tag)
			client.focus = c
		else
			c:jump_to()
		end
		break
	end

	-- Spawn if not found
	if not found then
		awful.spawn(spawn_cmd, spawn_args)
	end
end

-- Run raise or minimize a client (scratchpad style)
-- =============================================
function helpers.scratchpad(match, spawn_cmd, spawn_args)
	local cf = client.focus
	if cf and awful.rules.match(cf, match) then
		cf.minimized = true
	else
		helpers.run_or_raise(match, true, spawn_cmd, spawn_args)
	end
end

function helpers.volume_control(step)
	local cmd
	if step == 0 then
		cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
	else
		sign = step > 0 and "+" or ""
		cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ " ..
				sign .. tostring(step) .. "%"
	end
	awful.spawn.with_shell(cmd)
end

return helpers
