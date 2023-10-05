-- ░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀░█░█░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█
-- ░█░░░█░█░█░█░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░░█░░░█░░█░█░█░█
-- ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local keys = require("keys")
local helpers = require("helpers")
local awesome = awesome
local client = client

-- ░█░█░▀█▀░█▀▄░█▀▀░█▀▀░▀█▀░█▀▀
-- ░█▄█░░█░░█░█░█░█░█▀▀░░█░░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀

-- Memory widget
-- =============================================
local memory_widget = wibox.widget({
	{
		{
			{
				{
					id = "icon",
					text = "",
					forced_width = dpi(30),
					align = "center",
					valign = "center",
					font = beautiful.wibar_icon_font,
					widget = wibox.widget.textbox,
				},
				-- fixing font centering
				right = dpi(3),
				widget = wibox.container.margin,
			},
			bg = beautiful.darkblue,
			fg = beautiful.light_bg,
			widget = wibox.widget.background,
		},
		{
			{
				id = "text",
				font = beautiful.wibar_font,
				widget = wibox.widget.textbox,
			},
			left = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.light_bg,
	bg = beautiful.blue,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::ram", function(used, total)
	memory_widget:get_children_by_id("text")[1].markup = tostring(used) .. " MB"
end)

-- Clock widget
-- =============================================
local clock_widget = wibox.widget({
	{
		{
			{
				{
					id = "icon",
					text = "󱑆",
					forced_width = dpi(30),
					align = "center",
					valign = "center",
					font = beautiful.wibar_icon_font,
					widget = wibox.widget.textbox,
				},
				-- fixing font centering
				right = dpi(3),
				widget = wibox.container.margin,
			},
			bg = beautiful.darkgreen,
			fg = beautiful.light_bg,
			widget = wibox.widget.background,
		},
		{
			{
				id = "text",
				format = "%a %b %d - %I:%M %p",
				font = beautiful.wibar_font,
				widget = wibox.widget.textclock,
			},
			left = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.light_bg,
	bg = beautiful.green,
	widget = wibox.container.background,
})

-- CPU widget
-- =============================================
local cpu_widget = wibox.widget({
	{
		{
			{
				{
					id = "icon",
					text = "",
					forced_width = dpi(30),
					align = "center",
					valign = "center",
					font = beautiful.wibar_icon_font,
					widget = wibox.widget.textbox,
				},
				-- fixing font centering
				right = dpi(5),
				widget = wibox.container.margin,
			},
			bg = beautiful.cyan,
			fg = beautiful.light_bg,
			widget = wibox.widget.background,
		},
		{
			{
				id = "text",
				font = beautiful.wibar_font,
				widget = wibox.widget.textbox,
			},
			left = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.cyan,
	bg = beautiful.light_bg,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::cpu", function(cpu_idle)
	cpu_widget:get_children_by_id("text")[1].markup = tostring(cpu_idle) .. "%"
end)

-- Weather widget
-- =============================================
local weather_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = "",
				forced_width = dpi(30),
				align = "center",
				valign = "center",
				font = beautiful.wibar_icon_font,
				widget = wibox.widget.textbox,
			},
			bg = beautiful.magenta,
			fg = beautiful.light_bg,
			widget = wibox.widget.background,
		},
		{
			{
				{
					id = "description",
					font = beautiful.wibar_font,
					widget = wibox.widget.textbox,
				},
				nil,
				{
					id = "temp_current",
					align = "right",
					font = beautiful.wibar_font,
					widget = wibox.widget.textbox,
				},
				widget = wibox.layout.align.horizontal,
			},
			left = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.magenta,
	bg = beautiful.light_bg,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::weather", function(result)
	weather_widget:get_children_by_id("description")[1].markup = result.current.weather[1].description:gsub(
		"^%l",
		string.upper
	) .. ", "
	weather_widget:get_children_by_id("temp_current")[1].markup = math.floor(result.current.temp)
			.. "<sup><span>°</span></sup><span>C</span>"
end)

-- Playerctl widget
-- =============================================
local playerctl_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = "󰎈",
				forced_width = dpi(30),
				align = "center",
				valign = "center",
				font = beautiful.wibar_icon_font,
				widget = wibox.widget.textbox,
			},
			bg = beautiful.red,
			fg = beautiful.light_bg,
			widget = wibox.widget.background,
		},
		{
			{
				id = "text",
				text = "Not Playing",
				font = beautiful.wibar_font,
				align = "center",
				forced_width = dpi(100),
				widget = wibox.widget.textbox,
			},
			left = dpi(10),
			right = dpi(10),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.red,
	bg = beautiful.light_bg,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::spotify", function(artist, title, status)
	playerctl_widget:get_children_by_id("text")[1].markup = title
end)

playerctl_widget:buttons(gears.table.join(
-- left click = all players
	awful.button({}, 1, function()
		awful.spawn.with_shell("playerctl play-pause")
	end)
-- right click = specific player
-- awful.button({}, 3, function()
-- 	awful.spawn.with_shell("mpvc toggle")
-- end)
))

-- Volume widget
-- =============================================
local volume_bar = wibox.widget({
	max_value = 100,
	value = 70,
	forced_width = dpi(100),
	bar_shape = helpers.rrect(dpi(6)),
	shape = helpers.rrect(dpi(6)),
	color = beautiful.bg_focus,
	background_color = beautiful.light_bg,
	widget = wibox.widget.progressbar,
})

awesome.connect_signal("evil::volume", function(volume, muted)
	volume_bar.value = volume

	if muted then
		volume_bar.color = beautiful.light_bg
	else
		volume_bar.color = beautiful.bg_focus
	end
end)

-- Osd
-- =============================================
local slider = wibox.widget({
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = dpi(380),
	forced_height = dpi(10),
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.light_bg,
	color = beautiful.bg_focus,
})

local icon_widget = wibox.widget({
	widget = wibox.widget.textbox,
	font = beautiful.icon_font_name .. "15",
	forced_width = dpi(30),
	align = "center",
	valign = "center",
})

local text = wibox.widget({
	widget = wibox.widget.textbox,
	halign = "center",
})

local info = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	{
		widget = wibox.container.margin,
		margins = dpi(20),
		{
			layout = wibox.layout.fixed.horizontal,
			fill_space = true,
			spacing = dpi(8),
			icon_widget,
			{
				widget = wibox.container.background,
				forced_width = dpi(36),
				text,
			},
			slider,
		},
	},
})

local osd = awful.popup({
	shape = helpers.rrect(beautiful.border_radius),
	visible = false,
	ontop = true,
	border_width = beautiful.widget_border_width,
	border_color = beautiful.widget_border_color,
	minimum_height = dpi(60),
	maximum_height = dpi(60),
	minimum_width = dpi(290),
	maximum_width = dpi(290),
	placement = function(c)
		awful.placement.bottom(c, { margins = dpi(20) + beautiful.border_width * 2 })
	end,
	widget = info,
})

-- volume
awesome.connect_signal("evil::volume", function(volume, muted, icon)
	slider.value = volume
	text.text = volume
	icon_widget.text = icon
end)

-- bright
-- awesome.connect_signal("bright::value", function(value)
-- 	slider.value = value
-- 	text.text = value
-- 	icon_widget.text = "󰃟"
-- end)

-- function
local function osd_hide()
	osd.visible = false
	osd_timer:stop()
end

local osd_timer = gears.timer({
	timeout = 3,
	callback = osd_hide,
})

local function osd_toggle()
	if not osd.visible then
		osd.visible = true
		osd_timer:start()
	else
		osd_timer:again()
	end
end

awesome.connect_signal("summon::osd", function()
	osd_toggle()
end)

-- ░█░█░▀█▀░█▀▄░█▀█░█▀▄
-- ░█▄█░░█░░█▀▄░█▀█░█▀▄
-- ░▀░▀░▀▀▀░▀▀░░▀░▀░▀░▀
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt({ prompt = " Run: ", fg = beautiful.wibar_fg })
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = {
		widget = wibox.container.place,
		awful.widget.layoutbox({
			screen = s,
			resize = true,
			forced_width = dpi(15),
			forced_height = dpi(15),
			widget = wibox.container.place,
			-- Add buttons, allowing you to change the layout
			buttons = {
				awful.button({}, 1, function()
					awful.layout.inc(1)
				end),
				awful.button({}, 3, function()
					awful.layout.inc(-1)
				end),
				awful.button({}, 4, function()
					awful.layout.inc(1)
				end),
				awful.button({}, 5, function()
					awful.layout.inc(-1)
				end),
			},
		}),
	}

	-- Create a taglist widget
	-- Helper function that updates a taglist item
	local update_taglist = function(self, tag, index)
		local tagBox = self:get_children_by_id("underline")[1]
		local tagName = self:get_children_by_id("index_role")[1]
		if tag.selected then
			tagName.markup = helpers.colorize_text(
				beautiful.taglist_text_focused[index],
				beautiful.taglist_text_color_focused[index]
			)
			tagBox.bg = beautiful.taglist_text_color_occupied[index]
		elseif tag.urgent then
			tagName.markup =
					helpers.colorize_text(beautiful.taglist_text_urgent[index], beautiful.taglist_text_color_urgent[index])
			tagBox.bg = beautiful.wibar_bg
		elseif #tag:clients() > 0 then
			tagName.markup = helpers.colorize_text(
				beautiful.taglist_text_occupied[index],
				beautiful.taglist_text_color_occupied[index]
			)
			tagBox.bg = beautiful.wibar_bg
		else
			tagName.markup =
					helpers.colorize_text(beautiful.taglist_text_empty[index], beautiful.taglist_text_color_empty[index])
			tagBox.bg = beautiful.wibar_bg
		end
	end

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = wibox.layout.fixed.horizontal,
		buttons = keys.taglist_buttons,
		widget_template = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							id = "index_role",
							font = beautiful.taglist_text_font,
							align = "center",
							valign = "center",
							forced_width = dpi(24),
							widget = wibox.widget.textbox,
						},
						top = dpi(0),
						right = dpi(4),
						bottom = dpi(-1),
						widget = wibox.container.margin,
					},
					{
						{
							top = dpi(0),
							bottom = dpi(3),
							widget = wibox.container.margin,
						},
						id = "underline",
						bg = beautiful.wibar_bg,
						shape = gears.shape.rectangle,
						widget = wibox.container.background,
					},
				},
				widget = wibox.container.margin,
				right = dpi(4),
			},
			id = "background_role",
			widget = wibox.container.background,
			shape = gears.shape.rectangle,
			create_callback = update_taglist,
			update_callback = update_taglist,
		},
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = keys.tasklist_buttons,
		style = {
			font = beautiful.tasklist_font,
			bg = beautiful.tasklist_bg_normal,
		},
		layout = {
			spacing = dpi(4),
			-- layout = wibox.layout.fixed.horizontal
			layout = wibox.layout.flex.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = dpi(2),
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				forced_width = dpi(220),
				left = dpi(10),
				right = dpi(10),
				widget = wibox.container.margin,
			},
			-- border_width = dpi(2),
			-- shape  = gears.shape.rounded_bar,
			-- 	id = "bg_role",
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	-- Create a system tray widget
	s.systray = wibox.widget.systray()
	s.systray.visible = true -- can be toggled by a keybind

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = beautiful.wibar_position,
		screen = s,
		type = "dock",
		width = beautiful.wibar_width,
		height = beautiful.wibar_height,
		shape = helpers.rrect(beautiful.wibar_border_radius),
	})

	s.mywibox:setup({
		{
			{
				s.mytaglist,
				s.mytasklist,
				align = "left",
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			{
				s.mypromptbox,
				playerctl_widget,
				-- volume_bar,
				align = "center",
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			{
				weather_widget,
				memory_widget,
				cpu_widget,
				clock_widget,
				s.systray,
				s.mylayoutbox,
				align = "right",
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			expand = "none",
			layout = wibox.layout.align.horizontal,
		},
		top = dpi(3),
		bottom = dpi(3),
		left = dpi(3),
		right = dpi(3),
		widget = wibox.container.margin,
	})

	-- Place bar at the top and add margins
	awful.placement.top(s.mywibox, { margins = beautiful.screen_margin * 0 }) -- No margin
end)

-- ░█▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
-- ░█░█░█▀▀░░█░░░█░░█░█░█░█░▀▀█
-- ░▀▀▀░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀

-- Notification settings
-- =============================================
-- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
	-- Handle other contexts here
	if context ~= "app_icon" then
		n.icon = beautiful.awesome_icon
		return
	end

	-- Use XDG icon
	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({
		notification = n,
		type = "notification",
		cursor = "hand1",
		shape = beautiful.notification_shape,
		maximum_width = beautiful.notification_max_width,
		maximum_height = beautiful.notification_max_height,
		widget_template = {
			widget = wibox.container.constraint,
			strategy = "max",
			{
				widget = naughty.container.background,
				id = "background_role",
				{
					widget = wibox.container.margin,
					margins = dpi(10),
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(20),
						fill_space = true,
						{
							widget = wibox.container.place,
							{
								widget = wibox.container.background,
								shape = gears.shape.circle,
								naughty.widget.icon,
							},
						},
						{
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(10),
							naughty.widget.title,
							naughty.widget.message,
						},
					},
				},
			},
		},
	})
end)

-- Titlebar
-- =============================================
client.connect_signal("request::titlebars", function(c)
	local titlebar = awful.titlebar(c, {
		position = beautiful.titlebar_position,
		size = beautiful.titlebar_size,
	})

	local buttons = gears.table.join(
		awful.button({}, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)

	titlebar.widget = {
		layout = wibox.layout.flex.horizontal,
		-- {
		-- 	widget = wibox.container.place,
		-- 	align = "left",
		-- 	{
		-- 		widget = wibox.container.margin,
		-- 		margins = { left = dpi(10), right = dpi(10) top = dpi(8), bottom = dpi(8) },
		-- 		{
		-- 			layout = wibox.layout.fixed.horizontal,
		-- 			spacing = 8,
		-- 			awful.titlebar.widget.maximizedbutton(c),
		-- 			awful.titlebar.widget.minimizebutton(c),
		-- 			awful.titlebar.widget.closebutton(c),
		-- 		},
		-- 	},
		-- },
		{
			widget = wibox.container.background,
			buttons = buttons,
			{
				widget = wibox.container.margin,
				left = dpi(10),
				right = dpi(10),
				{
					widget = wibox.container.constraint,
					width = dpi(100),
					{
						align = beautiful.titlebar_title_align,
						widget = awful.titlebar.widget.titlewidget(c),
					},
				},
			},
		},
	}
end)

-- Autostart applications
-- =============================================
-- awful.spawn.once({},false)
-- With shell
-- awful.spawn.with_shell({}, false)
-- EOF ------------------------------------------------------------------------
