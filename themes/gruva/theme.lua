-- ░▀█▀░█░█░█▀▀░█▄█░█▀▀
-- ░░█░░█▀█░█▀▀░█░█░█▀▀
-- ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local helpers = require("helpers")

-- Inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")
theme.wallpaper = "/home/yashraj/Pictures/wall.png"

-- ░█▀▀░█▀█░█▀█░▀█▀░█▀▀
-- ░█▀▀░█░█░█░█░░█░░▀▀█
-- ░▀░░░▀▀▀░▀░▀░░▀░░▀▀▀

theme.font_name = "JetBrainsMono Nerd Font "
theme.font = theme.font_name .. "Bold 9"
theme.icon_font = theme.font_name .. "Bold "

-- ░█▀▀░█▀█░█░░░█▀█░█▀▄░█▀▀
-- ░█░░░█░█░█░░░█░█░█▀▄░▀▀█
-- ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

theme.background = xrdb.background or "#"
theme.foreground = xrdb.foreground or "#"
-- Black
theme.color0 = xrdb.color0 or "#"
theme.color8 = xrdb.color8 or "#"
-- Red
theme.color1 = xrdb.color1 or "#"
theme.color9 = xrdb.color9 or "#"
-- Green
theme.color2 = xrdb.color2 or "#"
theme.color10 = xrdb.color10 or "#"
-- Yellow
theme.color3 = xrdb.color3 or "#"
theme.color11 = xrdb.color11 or "#"
-- Blue
theme.color4 = xrdb.color4 or "#"
theme.color12 = xrdb.color12 or "#"
-- Magenta
theme.color5 = xrdb.color5 or "#"
theme.color13 = xrdb.color13 or "#"
-- Cyan
theme.color6 = xrdb.color6 or "#"
theme.color14 = xrdb.color14 or "#"
-- White
theme.color7 = xrdb.color7 or "#"
theme.color15 = xrdb.color15 or "#"

-- Special
theme.transparent = "#00000000"
theme.lighter_bg = "#3c3836"
theme.darker_bg = "#1d2021"
theme.orange = "#d65d0e"

-- Background Colors
theme.bg_normal = theme.background
theme.bg_focus = theme.color4 .. 70
theme.bg_urgent = theme.color3
theme.bg_minimize = theme.background .. 55

-- Foreground Colors
theme.fg_normal = theme.foreground
theme.fg_focus = theme.color7
theme.fg_urgent = theme.color1
theme.fg_minimize = theme.foreground .. 55

--- ░█░█░▀█▀░░░█▀▀░█░░░█▀▀░█▄█░█▀▀░█▀█░▀█▀░█▀▀
--- ░█░█░░█░░░░█▀▀░█░░░█▀▀░█░█░█▀▀░█░█░░█░░▀▀█
--- ░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░▀░░▀▀▀

-- Borders
-- ===================================================================
theme.border_width = dpi(3)
theme.border_normal = theme.lighter_bg
theme.border_focus = theme.color2
theme.border_radius = dpi(15)
theme.widget_border_width = dpi(2)
theme.widget_border_color = theme.color8

-- Taglist
-- ===================================================================
local taglist_square_size = dpi(0)
theme.taglist_font = theme.font_taglist
theme.taglist_bg = theme.wibar_bg
theme.taglist_bg_focus = theme.orange
theme.taglist_fg_focus = theme.darker_bg
theme.taglist_bg_occupied = theme.wibar_bg
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_empty = theme.wibar_bg
theme.taglist_fg_empty = theme.lighter_bg
theme.taglist_bg_urgent = theme.color1 .. "55"
theme.taglist_fg_urgent = theme.color1
theme.taglist_disable_icon = true
theme.taglist_spacing = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Tasklist
-- ===================================================================
theme.tasklist_font = theme.font
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = theme.color0
theme.tasklist_fg_focus = theme.color2
theme.tasklist_bg_normal = theme.color0
theme.tasklist_fg_normal = theme.foreground
theme.tasklist_bg_minimize = theme.bg_minimize
theme.tasklist_fg_minimize = theme.fg_minimize
theme.tasklist_disable_task_name = false
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_align = "center"

--- Titlebar
-- ===================================================================
theme.titlebar_enabled = false

-- Menu
-- Variables set for theming the menu:
-- ===================================================================
theme.menu_height = dpi(30)
theme.menu_width = dpi(150)
theme.menu_bg_normal = theme.bg_normal
theme.menu_fg_normal = theme.fg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_focus = theme.fg_focus
theme.menu_border_width = theme.border_width / 2
theme.menu_border_color = theme.color8
theme.menu_submenu = ">  "
theme.menu_submenu_icon = nil

-- Gaps
-- ===================================================================
theme.useless_gap = dpi(8)
theme.screen_margin = dpi(3)

-- Wibar
-- ===================================================================
theme.wibar_position = "top"
theme.wibar_height = dpi(25)
theme.wibar_width = dpi(1366)
theme.wibar_bg = theme.color0
theme.wibar_fg = theme.color7
theme.wibar_border_color = theme.color0
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(0)

-- Systray
-- ===================================================================
theme.bg_systray = theme.wibar_bg

-- Notifications
-- ===================================================================
theme.notification_font = theme.font
theme.notification_bg = theme.background
theme.notification_fg = theme.foreground
theme.notification_border_width = dpi(2)
theme.notification_border_color = theme.color8
theme.notification_opacity = 1
theme.notification_margin = dpi(15)
-- theme.notification_width = dpi(300)
-- theme.notification_height = dpi(80)
theme.notification_icon_size = dpi(50)
theme.notification_position = "top_right"
theme.notification_border_radius = theme.border_radius
-- theme.notification_crit_bg = theme.color1
-- theme.notification_crit_fg = theme.color0
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 2

-- Misc
-- ===================================================================
-- Recolor Layout icons
theme = theme_assets.recolor_layout(theme, theme.foreground)
theme.layoutlist_shape_selected = gears.shape.rounded_rect
theme.layoutlist_bg_selected = theme.color3

-- Edge snap
theme.snap_bg = theme.lighter_bg
theme.snap_shape = helpers.rrect(theme.border_radius)
theme.snap_border_width = dpi(5)

-- Hotkeys popup
theme.hotkeys_modifiers_fg = theme.color12

return theme
-- EOF ------------------------------------------------------------------------
