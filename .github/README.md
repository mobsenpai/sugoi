# Sugoi (すごい)

<img src="https://awesomewm.org/doc/api/images/AUTOGEN_wibox_logo_logo_and_name.svg" align="left">

> ###### 🇨​​​​​🇱​​​​​🇪​​​​​🇦​​​​​🇳​​​​​ 🇦​​​​​🇳​​​​​🇩​​​​​ 🇨​​​​​🇴​​​​​🇲​​​​​🇫​​​​​🇾​​​​​ 🇦​​​​​🇼​​​​​🇪​​​​​🇸​​​​​🇴​​​​​🇲​​​​​🇪​​​​​🇼​​​​​🇲​​​​​ 🇪​​​​​🇳​​​​​🇻​​​​​🇮​​​​​🇷​​​​​🇴​​​​​🇳​​​​​🇲​​​​​🇪​​​​​🇳​​​​​🇹​​​​​.
>
> ---
>
> This is just my personal configs. I have used many sources for this I do not claim this is my original idea.

<br>

---

AwesomeWM is the most powerful and highly configurable next-generation framework window manager for X. This is my favourite WM. Although it takes time and effort to configure it, I am very satisfied with this aesthetic result.

## ℹ️ Information

> Here are some details about my setup.
>
> Read carefully and go through the dotfiles before using.

<img src="https://imgur.com/dAQhRWC.png" align="right" width="400px">

| Config Defaults | Info                                                                                                               |
| :-------------- | :----------------------------------------------------------------------------------------------------------------- |
| WM              | AwesomeWM (git version)                                                                                            |
| OS              | NixOS (not relevant)                                                                                               |
| Terminal        | Wezterm                                                                                                            |
| Colors          | Xresources                                                                                                         |
| Launcher        | Rofi (rofi-emoji + clipmenu)                                                                                       |
| Compositor      | Picom (dccsillag's fork)                                                                                           |
| Fonts           | JetBrainsMono Nerd Font                                                                                            |
| File manager    | Pcmanfm                                                                                                            |
| Browser         | Vivaldi                                                                                                            |
| Shell           | Bash                                                                                                               |
| Editor          | Helix                                                                                                              |
| GUI Editor      | Vscodium                                                                                                           |
| Wallpaper       | [海島千本](https://www.pixiv.net/en/users/18362) / [🗝️𝐆𝐞𝐧𝐞𝐫𝐚𝐥 𝐒𝐭𝐨𝐫𝐞🛋️](https://www.pixiv.net/en/artworks/89143248) |

_Ofc you can change it._

## Main features

- [x] dynamic icons in workspaces
- [x] running apps list in bar
- [x] music name in bar
- [x] weather in bar
- [x] memory usage in bar
- [x] cpu useage in bar
- [x] clock in bar
- [x] layout indicator in bar

> Check the user variable in `rc.lua` to change the defaults to your apps first. Most important ones are ` terminal` and `app_launcher`.

```lua
user = {
	terminal = "",
	floating_terminal = "",
	scratchpad_terminal = "",
	editor = "",
	browser = "",
	file_manager = "",
	visual_editor = "",
	openweathermap_key = "",
	openweathermap_city_id = {
		"", -- lat
		"", -- lon
	},
	openweathermap_weather_units = "",
	lock_screen_custom_password = "",
	app_launcher = "",
}
```

> As I am on nixos my .Xresources files are auto-generated and thus I am not able to include it in ther repository. You can use your own xresources. I am using base16 colorschemes of gruvbox for this setup. You can just add these lines to your ~/.Xresources file. The colors are as follows:

```
! special
*background: #282828
*foreground: #d5c4a1

! black
*color0: #282828
*color8: #665c54

! red
*color1: #fb4934
*color9: #fb4934

! green
*color2: #b8bb26
*color10: #b8bb26

! yellow
*color3: #fabd2f
*color11: #fabd2f

! blue
*color4: #83a598
*color12: #83a598

! magenta
*color5: #d3869b
*color13: #d3869b

! cyan
*color6: #8ec07c
*color14: #8ec07c

! white
*color7: #d5c4a1
*color15: #fbf1c7


```

> same goes with wezterm. So here is the wezterm's config

```lua
-- ~/.config/wezterm/wezterm.lua
-- See https://wezfurlong.org/wezterm/

-- Add config folder to watchlist for config reloads.
local wezterm = require 'wezterm';
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

function font_with_fallback(name, params)
    local names = { name, "emoji" }
    return wezterm.font_with_fallback(names, params)
end

local font_name = "monospace"

return {
    -- Font config
    font = font_with_fallback(font_name),
    font_rules = {
        {
            italic = true,
            font = font_with_fallback(font_name, { italic = true })
        },
        {
            italic = true,
            intensity = "Bold",
            font = font_with_fallback(font_name, { bold = true, italic = true })
        },
        {
            intensity = "Bold",
            font = font_with_fallback(font_name, { bold = true })
        }
    },
    font_size = 10,
    line_height = 1.0,
    default_cursor_style = "SteadyUnderline",

    -- Keys
    disable_default_key_bindings = true,
    keys = {
        {
            mods = "CTRL|SHIFT",
            key = [[\]],
            action = wezterm.action {
                SplitHorizontal = { domain = "CurrentPaneDomain" }
            }
        },
        {
            mods = "CTRL",
            key = [[\]],
            action = wezterm.action {
                SplitVertical = { domain = "CurrentPaneDomain" }
            }
        },
        {
            key = "t",
            mods = "CTRL",
            action = wezterm.action { SpawnTab = "CurrentPaneDomain" }
        },
        {
            key = "w",
            mods = "CTRL",
            action = wezterm.action { CloseCurrentTab = { confirm = false } }
        },
        {
            mods = "CTRL",
            key = "Tab",
            action = wezterm.action { ActivateTabRelative = 1 }
        },
        {
            mods = "CTRL|SHIFT",
            key = "Tab",
            action = wezterm.action { ActivateTabRelative = -1 }
        },
        { key = "x", mods = "CTRL", action = "ActivateCopyMode" },
        {
            key = "v",
            mods = "CTRL|SHIFT",
            action = wezterm.action { PasteFrom = "Clipboard" }
        },
        {
            key = "c",
            mods = "CTRL|SHIFT",
            action = wezterm.action { CopyTo = "ClipboardAndPrimarySelection" }
        },
        {
            key = "L",
            mods = "CTRL",
            action = wezterm.action.ShowDebugOverlay
        }
    },
    front_end = "WebGpu",
    enable_wayland = true,
    check_for_updates = false,
    color_scheme = "gruvbox-dark-medium",
    window_padding = { left = "30pt", right = "30pt", top = "30pt", bottom = "30pt" },
    inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    show_tab_index_in_tab_bar = false,
}

```

```toml
-- ~/.config/wezterm/colors/gruvbox-dark-medium.toml
[colors]
ansi = ["282828", "fb4934", "b8bb26", "fabd2f", "83a598", "d3869b", "8ec07c", "d5c4a1"]
background = "282828"
brights = ["665c54", "fb4934", "b8bb26", "fabd2f", "83a598", "d3869b", "8ec07c", "fbf1c7"]
cursor_bg = "d5c4a1"
cursor_fg = "282828"
foreground = "d5c4a1"
selection_bg = "d5c4a1"
selection_fg = "282828"

[colors.tab_bar]
background = "282828"
inactive_tab_edge = "282828"
[colors.tab_bar.active_tab]
bg_color = "83a598"
fg_color = "d5c4a1"

[colors.tab_bar.inactive_tab]
bg_color = "282828"
fg_color = "d5c4a1"

[colors.tab_bar.inactive_tab_hover]
bg_color = "282828"
fg_color = "d5c4a1"

[colors.tab_bar.new_tab]
bg_color = "282828"
fg_color = "83a598"

[colors.tab_bar.new_tab_hover]
bg_color = "282828"
fg_color = "d5c4a1"

```

> Use https://github.com/tinted-theming/base16-schemes, to add colorschems to more apps Eg. rofi.

> Some important keybinds. More in `keys.lua`

| Keybind         | Function                 |
| --------------- | ------------------------ |
| `super + enter` | Open terminal            |
| `super + A`     | Open rofi drun           |
| `super + S`     | Open scratchpad terminal |

_And **many many** more...._

## Installation

If you have read all the above then. It is actually very easy to install you don't need to install any other program to run it. If using my defaults then these programs should be enough (programs names may vary depending on the distro). Ofc you can use what you want, be sure to make the respective changes.

- [ ] awesome-git
- [ ] rofi
- [ ] wezterm
- [ ] clipmenu
- [ ] gscreenshot
- [ ] rofi-emoji
- [ ] clipmenu
- [ ] bottom
- [ ] ranger
- [ ] pcmanfm
- [ ] bottom
- [ ] nerd-fonts-jetbrains-mono
- [ ] feh

> finally just clone the repo to you ~/.config/awesome

```bash
git clone https://github.com/MobSenpai/sugoi.git
```

## 💡 Acknowledgements

- [elenapan](https://github.com/elenapan)
- [rxyhn](https://github.com/rxyhn)
- [JavaCafe01](https://github.com/JavaCafe01)
- [Sinomor](https://github.com/Sinomor)
