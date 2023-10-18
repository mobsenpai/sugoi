local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

-- Notification list
local label = wibox.widget({
	text = "Notifications",
	align = "center",
	widget = wibox.widget.textbox,
})

local notifs_clear = wibox.widget({
	markup = "<span foreground='" .. beautiful.red .. "'> 󰅙 </span>",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
	_G.notif_center_reset_notifs_container()
end)))

local notifs_empty = wibox.widget({
	forced_height = dpi(300),
	widget = wibox.container.background,
	{
		layout = wibox.layout.flex.vertical,
		{
			markup = "<span foreground='" .. beautiful.bg_urgent .. "'>No notifications</span>",
			font = beautiful.font,
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
	},
})

local notifs_container = wibox.widget({
	forced_width = dpi(240),
	forced_height = dpi(715),
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(10),
	spacing_widget = {
		top = dpi(2),
		bottom = dpi(2),
		left = dpi(6),
		right = dpi(6),
		widget = wibox.container.margin,
		{
			widget = wibox.container.background,
		},
	},
})

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
	notifs_container:reset(notifs_container)
	notifs_container:insert(1, notifs_empty)
	remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
	notifs_container:remove_widgets(box)

	if #notifs_container.children == 0 then
		notifs_container:insert(1, notifs_empty)
		remove_notifs_empty = true
	end
end

local create_notif = function(icon, n, width)
	local time = os.date("%H:%M:%S")

	local icon_widget = wibox.widget({
		widget = wibox.container.constraint,
		{
			widget = wibox.container.margin,
			margins = dpi(20),
			{
				widget = wibox.widget.imagebox,
				image = icon,
				clip_shape = gears.shape.circle,
				halign = "center",
				valign = "center",
			},
		},
	})

	local title_widget = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = 50,
		forced_width = dpi(200),
		{
			widget = wibox.widget.textbox,
			text = n.title,
			align = "left",
			forced_width = dpi(200),
		},
	})

	local time_widget = wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.fg_normal,
		fg = beautiful.bg_normal,
		{
			widget = wibox.container.margin,
			margins = { left = dpi(10), right = dpi(10), top = dpi(4), bottom = dpi(4) },
			{
				widget = wibox.widget.textbox,
				text = time,
				align = "right",
				valign = "bottom",
			},
		},
	})

	local text_notif = wibox.widget({
		markup = n.message,
		align = "left",
		forced_width = dpi(165),
		widget = wibox.widget.textbox,
	})

	local box = wibox.widget({
		widget = wibox.container.background,
		forced_height = dpi(120),
		bg = beautiful.black_alt,
		{
			layout = wibox.layout.align.horizontal,
			icon_widget,
			{
				widget = wibox.container.margin,
				margins = dpi(10),
				{
					layout = wibox.layout.align.vertical,
					expand = "none",
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(10),
						{
							layout = wibox.layout.align.horizontal,
							expand = "none",
							title_widget,
							nil,
							time_widget,
						},
						text_notif,
					},
				},
			},
		},
	})

	box:buttons(gears.table.join(awful.button({}, 1, function()
		_G.notif_center_remove_notif(box)
	end)))

	return box
end

notifs_container:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if #notifs_container.children == 1 then
			return
		end
		notifs_container:insert(1, notifs_container.children[#notifs_container.children])
		notifs_container:remove(#notifs_container.children)
	end),

	awful.button({}, 5, nil, function()
		if #notifs_container.children == 1 then
			return
		end
		notifs_container:insert(#notifs_container.children + 1, notifs_container.children[1])
		notifs_container:remove(1)
	end)
))

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
	if #notifs_container.children == 1 and remove_notifs_empty then
		notifs_container:reset(notifs_container)
		remove_notifs_empty = false
	end

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.awesome_icon
	end

	notifs_container:insert(1, create_notif(appicon, n, width))
end)

local notifs = wibox.widget({
	spacing = dpi(10),
	layout = wibox.layout.fixed.vertical,
	{
		widget = wibox.container.margin,
		margins = dpi(10),
		{
			layout = wibox.layout.align.horizontal,
			label,
			nil,
			notifs_clear,
		},
	},
	notifs_container,
})

-- Main window
local main = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	{
		widget = wibox.container.margin,
		margins = dpi(10),
		{
			layout = wibox.layout.fixed.vertical,
			fill_space = true,
			spacing = dpi(10),
			notifs,
		},
	},
})

local notif_center = awful.popup({
	shape = helpers.rrect(beautiful.border_radius),
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.widget_border_color,
	minimum_height = dpi(585),
	maximum_height = dpi(585),
	minimum_width = dpi(500),
	maximum_width = dpi(500),
	placement = function(d)
		awful.placement.bottom_right(d, { honor_workarea = true, margins = dpi(5) + beautiful.border_width * 2 })
	end,
	widget = main,
})

-- Summon functions
awesome.connect_signal("summon::notif_center", function()
	notif_center.visible = not notif_center.visible
end)

-- Hide on click on other windows
client.connect_signal("button::press", function()
	notif_center.visible = false
end)

awesome.connect_signal("summon::dismiss", function()
	naughty.destroy_all_notifications()
	notif_center.visible = false
end)
