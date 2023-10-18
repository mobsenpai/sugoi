local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local awful = require("awful")
local gears = require("gears")
local helpers = {}

-- Mouse hover
-- ===================================================================
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
-- ===================================================================
function helpers.rrect(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- Raise or spawn
-- ===================================================================
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
-- ===================================================================
function helpers.scratchpad(match, spawn_cmd, spawn_args)
	local cf = client.focus
	if cf and awful.rules.match(cf, match) then
		cf.minimized = true
	else
		helpers.run_or_raise(match, true, spawn_cmd, spawn_args)
	end
end

-- Resize DWIM (Do What I Mean)
-- ===================================================================
-- Resize client or factor
-- Constants
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05
---------------
function helpers.resize_dwim(c, direction)
	if c and c.floating then
		if direction == "up" then
			c:relative_move(0, 0, 0, -floating_resize_amount)
		elseif direction == "down" then
			c:relative_move(0, 0, 0, floating_resize_amount)
		elseif direction == "left" then
			c:relative_move(0, 0, -floating_resize_amount, 0)
		elseif direction == "right" then
			c:relative_move(0, 0, floating_resize_amount, 0)
		end
	elseif awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
		if direction == "up" then
			awful.client.incwfact(-tiling_resize_factor)
		elseif direction == "down" then
			awful.client.incwfact(tiling_resize_factor)
		elseif direction == "left" then
			awful.tag.incmwfact(-tiling_resize_factor)
		elseif direction == "right" then
			awful.tag.incmwfact(tiling_resize_factor)
		end
	end
end

-- Change volume
-- ===================================================================
function helpers.volume_control(step)
	local cmd
	if step == 0 then
		cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
	else
		sign = step > 0 and "+" or ""
		cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ "
			.. sign
			.. tostring(step)
			.. "%"
	end
	awful.spawn.with_shell(cmd)
end

-- Quick markup
-- ===================================================================
function helpers.colorize_text(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

-- Lighten or darken hex colors
-- ===================================================================
-- Rounds to whole number
local function round(num)
	return math.floor(num + 0.5)
end
-- Rounds to hundredths
local function roundH(num)
	return math.floor((num * 100) + 0.5) / 100
end

-- Converts hexadecimal color to HSL
-- Lightness (L) is changed based on amt
-- Converts HSL back to hex
-- amt (0-100) can be negative to darken or positive to lighten
-- The amt specified is added to the color's existing Lightness
-- e.g., (#000000, 25) L = 25 but (#404040, 25) L = 50

function helpers.lighten(hex_color, amt)
	local r, g, b, a
	local hex = hex_color:gsub("#", "")
	if #hex < 6 then
		local t = {}
		for i = 1, #hex do
			local char = hex:sub(i, i)
			t[i] = char .. char
		end
		hex = table.concat(t)
	end
	r = tonumber(hex:sub(1, 2), 16) / 255
	g = tonumber(hex:sub(3, 4), 16) / 255
	b = tonumber(hex:sub(5, 6), 16) / 255
	if #hex ~= 6 then
		a = roundH(tonumber(hex:sub(7, 8), 16) / 255)
	end

	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local c = max - min

	-- Hue
	local h
	if c == 0 then
		h = 0
	elseif max == r then
		h = ((g - b) / c) % 6
	elseif max == g then
		h = ((b - r) / c) + 2
	elseif max == b then
		h = ((r - g) / c) + 4
	end
	h = h * 60

	-- Luminance
	local l = (max + min) * 0.5

	-- Saturation
	local s
	if l == 0 then
		s = 0
	elseif l <= 0.5 then
		s = c / (l * 2)
	elseif l > 0.5 then
		s = c / (2 - (l * 2))
	end

	local H, S, L, A
	H = round(h) / 360
	S = round(s * 100) / 100
	L = round(l * 100) / 100

	amt = amt / 100
	if L + amt > 1 then
		L = 1
	elseif L + amt < 0 then
		L = 0
	else
		L = L + amt
	end

	local R, G, B
	if S == 0 then
		R, G, B = round(L * 255), round(L * 255), round(L * 255)
	else
		local function hue2rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * (6 * t)
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end
		local q
		if L < 0.5 then
			q = L * (1 + S)
		else
			q = L + S - (L * S)
		end
		local p = 2 * L - q
		R = round(hue2rgb(p, q, (H + 1 / 3)) * 255)
		G = round(hue2rgb(p, q, H) * 255)
		B = round(hue2rgb(p, q, (H - 1 / 3)) * 255)
	end

	if a ~= nil then
		A = round(a * 255)
		return string.format("#" .. "%.2x%.2x%.2x%.2x", R, G, B, A)
	else
		return string.format("#" .. "%.2x%.2x%.2x", R, G, B)
	end
end

return helpers
-- EOF ------------------------------------------------------------------------
