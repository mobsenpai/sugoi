-- ░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀░█░█░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█
-- ░█░░░█░█░█░█░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░░█░░░█░░█░█░█░█
-- ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local json = require("modules.json")
local keys = require("keys")
local helpers = require("helpers")

-- ░█░█░▀█▀░█▀▄░█▀▀░█▀▀░▀█▀░█▀▀
-- ░█▄█░░█░░█░█░█░█░█▀▀░░█░░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀

-- Memory widget
-- =============================================
local memory_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = "  ",
				font = beautiful.icon_font .. "10",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.color14,
			fg = beautiful.darker_bg,
			widget = wibox.widget.background,
		},
		{
			id = "text",
			text = "",
			font = beautiful.icon_font .. "10",
			widget = wibox.widget.textbox,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.darker_bg,
	bg = beautiful.color6,
	widget = wibox.container.background,
})

local update_interval = 20
local ram_script = [[
  sh -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

-- Periodically get ram info
awful.widget.watch(ram_script, update_interval, function(widget, stdout)
	local available = stdout:match("(.*)@@")
	local total = stdout:match("@@(.*)@")
	local used = tonumber(total) - tonumber(available)
	-- weather_widget attach
	local usage = memory_widget:get_children_by_id("text")[1]
	memory_widget:emit_signal("widget::redraw_needed")
	usage:set_text(used .. " MB ")
end)

-- Clock widget
-- =============================================
local clock_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = " 󰃰 ",
				font = beautiful.icon_font .. "10",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.color12,
			fg = beautiful.darker_bg,
			widget = wibox.widget.background,
		},
		{
			id = "text",
			format = "%a %b %d - %I:%M %p ",
			font = beautiful.icon_font .. "10",
			widget = wibox.widget.textclock,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	fg = "#ffffff",
	bg = beautiful.color4,
	widget = wibox.container.background,
})

-- CPU widget
-- =============================================
local cpu_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = " 󰍛 ",
				font = beautiful.icon_font .. "12",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.color11,
			fg = beautiful.darker_bg,
			widget = wibox.widget.background,
		},
		{
			id = "text",
			text = "",
			font = beautiful.icon_font .. "10",
			widget = wibox.widget.textbox,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.color3,
	bg = beautiful.lighter_bg,
	widget = wibox.container.background,
})

local update_interval = 5
local cpu_idle_script = [[
  sh -c "
  vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'
  "]]

-- Periodically get cpu info
awful.widget.watch(cpu_idle_script, update_interval, function(widget, stdout)
	local cpu_idle = stdout
	cpu_idle = string.gsub(cpu_idle, "^%s*(.-)%s*$", "%1")
	local used = 100 - tonumber(cpu_idle)
	-- cpu_widget attach
	local usage = cpu_widget:get_children_by_id("text")[1]
	cpu_widget:emit_signal("widget::redraw_needed")
	usage:set_text(used .. "% ")
end)

-- Weather widget
-- =============================================
local GET_FORECAST_CMD = [[bash -c "curl -s --show-error -X GET '%s'"]]

local current_weather_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = "  ",
				font = beautiful.icon_font .. "10",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.color10,
			fg = beautiful.darker_bg,
			widget = wibox.widget.background,
		},
		{
			id = "description",
			text = "Mostly cloudy,",
			font = beautiful.icon_font .. "10",
			widget = wibox.widget.textbox,
		},
		nil,
		{
			id = "tempareture_current",
			markup = "20<sup><span>°</span></sup><span>C </span>",
			align = "right",
			font = beautiful.icon_font .. "10",
			widget = wibox.widget.textbox,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.color2,
	bg = beautiful.lighter_bg,
	widget = wibox.container.background,
})

local api_key = user.openweathermap_key
local coordinates = user.openweathermap_city_id
local units = user.openweathermap_weather_units

local url = (
	"https://api.openweathermap.org/data/2.5/onecall"
	.. "?lat="
	.. coordinates[1]
	.. "&lon="
	.. coordinates[2]
	.. "&appid="
	.. api_key
	.. "&units="
	.. units
	.. "&exclude=minutely"
)

awful.widget.watch(string.format(GET_FORECAST_CMD, url), 600, function(_, stdout, stderr)
	if stderr == "" then
		local result = json.decode(stdout)
		-- Current weather setup
		local description = current_weather_widget:get_children_by_id("description")[1]
		local temp_current = current_weather_widget:get_children_by_id("tempareture_current")[1]
		current_weather_widget:emit_signal("widget::redraw_needed")
		description:set_text(result.current.weather[1].description:gsub("^%l", string.upper) .. ",")
		temp_current:set_markup(math.floor(result.current.temp) .. "<sup><span>°</span></sup><span>C </span>")
	end
end)

-- Playerctl widget
-- =============================================
local playerctl_widget = wibox.widget({
	{
		{
			{
				id = "icon",
				text = " 󰎈 ",
				font = beautiful.icon_font .. "11",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.color13,
			fg = beautiful.darker_bg,
			widget = wibox.widget.background,
		},
		{
			id = "text",
			text = "---",
			font = beautiful.icon_font .. "10",
			align = "center",
			forced_width = dpi(100),
			widget = wibox.widget.textbox,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	fg = beautiful.color13,
	bg = beautiful.lighter_bg,
	widget = wibox.container.background,
})

-- Get playerctl output
local function emit_info(playerctl_output)
	local artist = playerctl_output:match('artist_start(.*)title_start')
	local title = playerctl_output:match('title_start(.*)status_start')
	-- Use the lower case of status
	local status = playerctl_output:match('status_start(.*)'):lower()
	status = string.gsub(status, '^%s*(.-)%s*$', '%1')
	-- playerctl_widget attach
	local song = playerctl_widget:get_children_by_id("text")[1]
	if status == "stopped" then
		song:set_text("---")
	else
		song:set_text(title .. " ")
	end
end

-- Sleeps until spotify changes state (pause/play/next/prev)
local spotify_script = [[
  sh -c '
    playerctl metadata --format 'artist_start{{artist}}title_start{{title}}status_start{{status}}' --follow
  ']]

-- Kill old playerctl process
awful.spawn.easy_async_with_shell("ps x | grep \"playerctl metadata\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		-- Emit song info with each line printed
		awful.spawn.with_line_callback(spotify_script, {
			stdout = function(line)
				emit_info(line)
			end
		})
	end)

-- Volume osd
-- needs pamixer installed
-- =============================================
local volume_old = -1
local muted_old = -1
local function emit_volume_info()
	-- Get volume info of the currently active sink
	awful.spawn.easy_async_with_shell('echo -n $(pamixer --get-mute); echo "_$(pamixer --get-volume)"', function(stdout)
		local bool = string.match(stdout, "(.-)_")
		local volume = string.match(stdout, "%d+")
		local muted_int = -1
		if bool == "true" then
			muted_int = 1
		else
			muted_int = 0
		end
		local volume_int = tonumber(volume)

		-- Only send signal if there was a change
		-- We need this since we use `pactl subscribe` to detect
		-- volume events. These are not only triggered when the
		-- user adjusts the volume through a keybind, but also
		-- through `pavucontrol` or even without user intervention,
		-- when a media file starts playing.
		if volume_int ~= volume_old or muted_int ~= muted_old then
			awesome.emit_signal("signal::volume", volume_int, muted_int)
			volume_old = volume_int
			muted_old = muted_int
		end
	end)
end

-- Run once to initialize widgets
emit_volume_info()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

-- Kill old pactl subscribe processes
awful.spawn.easy_async({
	"pkill",
	"--full",
	"--uid",
	os.getenv("USER"),
	"^pactl subscribe",
}, function()
	-- Run emit_volume_info() with each line printed
	awful.spawn.with_line_callback(volume_script, {
		stdout = function(line)
			emit_volume_info()
		end,
	})
end)

local volume_icon = wibox.widget({
	markup = "<span foreground='" .. beautiful.color4 .. "'><b>󰋋</b></span>",
	align = "center",
	valign = "center",
	font = beautiful.font_name .. "20",
	widget = wibox.widget.textbox,
})

local volume_adjust = awful.popup({
	type = "notification",
	maximum_width = dpi(50),
	maximum_height = dpi(300),
	visible = false,
	ontop = true,
	widget = wibox.container.background,
	bg = beautiful.transparent,
	placement = function(c)
		awful.placement.right(c, { margins = { right = 10 } })
	end,
})

local volume_bar = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	shape = gears.shape.rounded_rect,
	background_color = beautiful.lighter_bg,
	color = beautiful.color4,
	max_value = 100,
	value = 0,
	widget = wibox.widget.progressbar,
})

local volume_ratio = wibox.widget({
	layout = wibox.layout.ratio.vertical,
	{
		{ volume_bar, direction = "east", widget = wibox.container.rotate },
		top = dpi(20),
		left = dpi(20),
		right = dpi(20),
		widget = wibox.container.margin,
	},
	volume_icon,
	nil,
})

volume_ratio:adjust_ratio(2, 0.72, 0.28, 0)

volume_adjust.widget = wibox.widget({
	volume_ratio,
	shape = helpers.rrect(beautiful.border_radius / 2),
	border_width = beautiful.widget_border_width,
	border_color = beautiful.widget_border_color,
	bg = beautiful.background,
	widget = wibox.container.background,
})

-- create a 3 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer({
	timeout = 3,
	autostart = true,
	callback = function()
		volume_adjust.visible = false
		volume_bar.mouse_enter = false
	end,
})

awesome.connect_signal("signal::volume", function(vol, muted)
	volume_bar.value = vol

	if muted == 1 or vol == 0 then
		volume_icon.markup = "<span foreground='" .. beautiful.color4 .. "'><b>󰟎</b></span>"
	else
		volume_icon.markup = "<span foreground='" .. beautiful.color4 .. "'><b>󰋋</b></span>"
	end

	if volume_adjust.visible then
		hide_volume_adjust:again()
	else
		volume_adjust.visible = true
		hide_volume_adjust:start()
	end
end)

-- ░█░█░▀█▀░█▀▄░█▀█░█▀▄
-- ░█▄█░░█░░█▀▄░█▀█░█▀▄
-- ░▀░▀░▀▀▀░▀▀░░▀░▀░▀░▀

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt({ prompt = " Run: ", fg = beautiful.prompt_fg })
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
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
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, keys.taglist_buttons)
	s.mytaglist.font = beautiful.font

	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, keys.tasklist_buttons)
	s.mytasklist.font = beautiful.font

	-- Create a system tray widget
	s.systray = wibox.widget.systray()
	s.systray.visible = true -- can be toggled by a keybind

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = beautiful.wibar_position,
		screen = s,
		width = beautiful.wibar_width,
		height = beautiful.wibar_height,
		shape = helpers.rrect(beautiful.border_radius),
	})

	s.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				s.mypromptbox,
				s.mytasklist,
			},
			{
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
				playerctl_widget,
			},
			{
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
				current_weather_widget,
				memory_widget,
				cpu_widget,
				clock_widget,
				s.systray,
			},
		},
		top = dpi(3),
		bottom = dpi(3),
		left = dpi(3),
		right = dpi(3),
		layout = wibox.container.margin,
	})

	-- Place bar at the bottom and add margins
	awful.placement.top(s.mywibox, { margins = beautiful.screen_margin * 0 }) -- I don't want margin so I added "*0"
end)

-- ░█▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
-- ░█░█░█▀▀░░█░░░█░░█░█░█░█░▀▀█
-- ░▀▀▀░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀

-- Notification settings
-- =============================================
naughty.config.defaults.title = "System Notification"

-- Timeouts
naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 12

-- Notification layout
if beautiful.notification_border_radius > 0 then
	beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
end

naughty.connect_signal("request::display", function(n)
	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(5),
			layout = wibox.layout.flex.horizontal
		}),
		widget_template = {
			{
				{
					{
						font = beautiful.font_name .. "Bold 11",
						markup = "<span foreground='" .. beautiful.color4 .. "'>" .. " " .. "</span>",
						widget = wibox.widget.textbox
					},
					{
						id = 'text_role',
						font = beautiful.notification_font,
						widget = wibox.widget.textbox
					},
					forced_height = dpi(35),
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.place
			},
			strategy = "min",
			width = dpi(60),
			widget = wibox.container.constraint,
		},
		style = {
			underline_normal = false,
			underline_selected = true
		},
		widget = naughty.list.actions
	})

	naughty.layout.box {
		notification = n,
		type = "notification",
		cursor = "hand2",
		shape = helpers.rrect(beautiful.notification_border_radius),
		border_width = beautiful.notification_border_width,
		border_color = beautiful.notification_border_color,
		position = beautiful.notification_position,
		widget_template = {
			{
				{
					{
						{
							naughty.widget.icon,
							{
								{
									nil,
									{
										{
											align = "left",
											font = beautiful.notification_font,
											markup = "<b>" .. n.title .. "</b>",
											widget = wibox.widget.textbox,
										},
										{
											align = "left",
											font = beautiful.notification_font,
											text = n.message,
											widget = wibox.widget.textbox,
										},
										layout = wibox.layout.fixed.vertical
									},
									expand = "none",
									layout = wibox.layout.align.vertical
								},
								left = n.icon and beautiful.notification_padding or 0,
								widget = wibox.container.margin,
							},
							layout = wibox.layout.align.horizontal
						},
						{
							wibox.widget({
								forced_height = dpi(10),
								layout = wibox.layout.fixed.vertical
							}),
							{
								nil,
								actions,
								expand = "none",
								layout = wibox.layout.align.horizontal
							},
							visible = n.actions and #n.actions > 0,
							layout = wibox.layout.fixed.vertical
						},
						layout = wibox.layout.fixed.vertical
					},
					margins = beautiful.notification_padding,
					widget = wibox.container.margin,
				},
				strategy = "min",
				width = beautiful.notification_min_width or dpi(150),
				widget = wibox.container.constraint,
			},
			strategy = "max",
			width = beautiful.notification_max_width or dpi(300),
			height = beautiful.notification_max_height or dpi(150),
			widget = wibox.container.constraint,
		}
	}
end)

-- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
	-- Handle other contexts here
	if context ~= "app_icon" then return end

	-- Use XDG icon
	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

-- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
	a.icon = menubar.utils.lookup_icon(hints.id)
end)

-- Autostart applications
-- =============================================
-- awful.spawn.once({},false)
-- EOF ------------------------------------------------------------------------
