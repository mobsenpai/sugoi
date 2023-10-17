# Sugoi (すごい)

<img src="https://awesomewm.org/doc/api/images/AUTOGEN_wibox_logo_logo_and_name.svg" align="left">

> ###### 🇨​​​​​🇱​​​​​🇪​​​​​🇦​​​​​🇳​​​​​ 🇦​​​​​🇳​​​​​🇩​​​​​ 🇨​​​​​🇴​​​​​🇲​​​​​🇫​​​​​🇾​​​​​ 🇦​​​​​🇼​​​​​🇪​​​​​🇸​​​​​🇴​​​​​🇲​​​​​🇪​​​​​🇼​​​​​🇲​​​​​ 🇪​​​​​🇳​​​​​🇻​​​​​🇮​​​​​🇷​​​​​🇴​​​​​🇳​​​​​🇲​​​​​🇪​​​​​🇳​​​​​🇹​​​​​.
>
> ---
>
> This is just my personal configs. I have used many sources for this I do not claim this is my original idea.

<br>
<br>

---

AwesomeWM is the most powerful and highly configurable next-generation framework window manager for X. This is my favourite WM. Although it takes time and effort to configure it, I am very satisfied with this aesthetic result.

## 📢 Information

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

## 💎 Main features

- [x] dynamic icons in workspaces
- [x] running apps list in bar
- [x] music name in bar
- [x] weather in bar
- [x] memory usage in bar
- [x] cpu usage in bar
- [x] clock in bar
- [x] layout indicator in bar
- [x] volume & brightness osd
- [x] clipboard
- [x] screenshot

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

> As I am on nixos my .Xresources files are auto-generated and thus I am not able to include it in the repository. You can use your own xresources as well. In this setup however, I am using base16 colorschemes of gruvbox for this setup. You can just add these lines to your ~/.Xresources file. The colors are as follows:

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

<details> <summary> ~/.config/wezterm </summary>

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
# ~/.config/wezterm/colors/gruvbox-dark-medium.toml
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

</details> <br>

> For rofi as well

<details> <summary> ~/.config/config.rasi</summary>

```rasi
* {
active: #b8bb26ff;
active-background: var(active);
active-foreground: var(background);
alternate-active-background: var(active);
alternate-active-foreground: var(background);
alternate-background: var(background-alt);
alternate-normal-background: var(background-alt);
alternate-normal-foreground: var(foreground);
alternate-urgent-background: var(urgent);
alternate-urgent-foreground: var(background);
background: #282828ff;
background-alt: #3c3836ff;
background-colour: var(background);
border-colour: var(selected);
font: "monospace bold 10";
foreground: #d5c4a1ff;
foreground-colour: var(foreground);
handle-colour: var(selected);
normal-background: var(background-alt);
normal-foreground: var(foreground);
selected: #83a598ff;
selected-active-background: var(urgent);
selected-active-foreground: var(background);
selected-normal-background: var(selected);
selected-normal-foreground: var(background);
selected-urgent-background: var(active);
selected-urgent-foreground: var(background);
urgent: #fb4934ff;
urgent-background: var(urgent);
urgent-foreground: var(background);
}

configuration {
display-clipboard: ">";
display-combi: ">";
display-drun: ">";
display-emoji: ">";
drun-display-format: "{name}";
modi: "drun,combi,emoji";
show-icons: false;
window-format: "{w} · {c} · {t}";
}

element {
background-color: transparent;
border: 0px solid;
border-color: @border-colour;
border-radius: 0px;
cursor: pointer;
enabled: true;
margin: 0px;
padding: 12px;
spacing: 10px;
text-color: @foreground-colour;
}

element alternate.active {
background-color: var(alternate-active-background);
text-color: var(alternate-active-foreground);
}

element alternate.normal {
background-color: var(alternate-normal-background);
text-color: var(alternate-normal-foreground);
}

element alternate.urgent {
background-color: var(alternate-urgent-background);
text-color: var(alternate-urgent-foreground);
}

element normal.active {
background-color: var(active-background);
text-color: var(active-foreground);
}

element normal.normal {
background-color: var(normal-background);
text-color: var(normal-foreground);
}

element normal.urgent {
background-color: var(urgent-background);
text-color: var(urgent-foreground);
}

element selected.active {
background-color: var(selected-active-background);
text-color: var(selected-active-foreground);
}

element selected.normal {
background-color: var(selected-normal-background);
text-color: var(selected-normal-foreground);
}

element selected.urgent {
background-color: var(selected-urgent-background);
text-color: var(selected-urgent-foreground);
}

element-icon {
background-color: transparent;
cursor: inherit;
size: 24px;
text-color: inherit;
}

element-text {
background-color: transparent;
cursor: inherit;
highlight: inherit;
horizontal-align: 0.0;
text-color: inherit;
vertical-align: 0.5;
}

entry {
background-color: inherit;
cursor: text;
enabled: true;
margin: 8px 0px 0px 14px;
placeholder: "Search...";
placeholder-color: inherit;
text-color: inherit;
}

inputbar {
background-color: @background-colour;
border: 0px;
border-color: @border-colour;
border-radius: 0px;
children: [ prompt, entry ];
enabled: true;
margin: 0px;
padding: 0px 0px 6px 0px;
spacing: 10px;
text-color: @foreground-colour;
}

listview {
background-color: transparent;
border: 0px solid;
border-color: @border-colour;
border-radius: 0px;
columns: 1;
cursor: "default";
cycle: true;
dynamic: true;
enabled: true;
fixed-columns: true;
fixed-height: true;
layout: vertical;
lines: 7;
margin: 0px;
padding: 0px;
reverse: false;
scrollbar: false;
spacing: 10px;
text-color: @foreground-colour;
}

mainbox {
background-color: transparent;
border: 0px solid;
border-color: @border-colour;
border-radius: 0px 0px 0px 0px;
children: [ inputbar, listview];
enabled: true;
margin: 0px;
padding: 10px;
spacing: 10px;
}

prompt {
background-color: @background-alt;
enabled: true;
padding: 2px 14px 4px 14px;
text-color: inherit;
}

window {
anchor: center;
background-color: @background-colour;
border: 2px solid;
border-color: @border-colour;
border-radius: 0px;
cursor: "default";
enabled: true;
fullscreen: false;
location: center;
margin: 0px;
padding: 0px;
transparency: "real";
width: 420px;
x-offset: 0px;
y-offset: 0px;
}
```

</details> <br>

> Use https://github.com/tinted-theming/base16-schemes, to add colorschems to more apps Eg. rofi.

> Some important keybinds. More in `keys.lua`

| Keybind             | Function                 |
| ------------------- | ------------------------ |
| `super + enter`     | Open terminal            |
| `super + A`         | Open rofi drun           |
| `super + S`         | Open scratchpad terminal |
| `super + shift + q` | Quit awesome             |
| `super + shift + r` | Reload awesome           |
| `super + q`         | Close selected window    |

_And **many many** more...._

## 🔧 Installation

If you have read all the above then. It is actually very easy to install you don't need to install any other program to run it. If using my defaults then these programs should be enough (programs names may vary depending on the distro). Ofc you can use what you want, be sure to make the respective changes.

- [ ] awesome-git
- [ ] wezterm
- [ ] pipewire pipewire-alsa pipewire-pulse alsa-utils wireplumber
- [ ] rofi
- [ ] clipmenu xclip maim slop swappy
- [ ] inotify-tools light
- [ ] playerctl
- [ ] rofi-emoji
- [ ] bottom
- [ ] ranger
- [ ] pcmanfm
- [ ] bottom
- [ ] ttf-jetbrains-mono-nerd
- [ ] feh

> finally just clone the repo to your `~/.config/awesome`

```bash
git clone https://github.com/MobSenpai/sugoi.git
```

## Notes

> I have noticed that wezterm does not work on some installs, so it is advisable to change the default terminal to `kitty` by changing these lines in `rc.lua`

```
terminal = "kitty",
floating_terminal = "kitty --class floating_terminal",
scratchpad_terminal = "kitty --class scratchpad",
```

<details> <summary> Use this theme for kitty </summary>

```
# See https://sw.kovidgoyal.net/kitty/conf.html
font_family monospace
font_size 10


# Shell integration is sourced and configured manually
shell_integration no-rc enabled

active_border_color #665c54
active_tab_background #282828
active_tab_foreground #d5c4a1
background #282828
color0 #282828
color1 #fb4934
color10 #b8bb26
color11 #fabd2f
color12 #83a598
color13 #d3869b
color14 #8ec07c
color15 #fbf1c7
color16 #fe8019
color17 #d65d0e
color18 #3c3836
color19 #504945
color2 #b8bb26
color20 #bdae93
color21 #ebdbb2
color3 #fabd2f
color4 #83a598
color5 #d3869b
color6 #8ec07c
color7 #d5c4a1
color8 #665c54
color9 #fb4934
cursor #d5c4a1
foreground #d5c4a1
inactive_border_color #3c3836
inactive_tab_background #3c3836
inactive_tab_foreground #bdae93
scrollback_lines 2000
selection_background #d5c4a1
selection_foreground #282828
tab_bar_background #3c3836
url_color #bdae93
window_padding_width 7
```

</details> <br>

> Change the bar size to your display resolution by, changing this line in `themes/gruva/theme.lua`

```
theme.wibar_width = dpi(1920)
```

> `Clipmenu` is used as clipboard. It needs some configuration, so research on your own, or replace with something else.

> Uncomment this line in `evil/init.lua` to enable brightness osd.

```
require("evil.brightness")
```

## 💡 Acknowledgements

- [elenapan](https://github.com/elenapan)
- [rxyhn](https://github.com/rxyhn)
- [JavaCafe01](https://github.com/JavaCafe01)
- [Sinomor](https://github.com/Sinomor)
