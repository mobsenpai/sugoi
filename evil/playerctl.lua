-- Provides:
-- evil::playerctl
--      artist (string)
--      song (string)
--      status (string) [playing | paused | stopped]
local awful = require("awful")

local function emit_info(playerctl_output)
	local artist = playerctl_output:match("artist_start(.*)title_start")
	local title = playerctl_output:match("title_start(.*)status_start")
	-- Use the lower case of status
	local status = playerctl_output:match("status_start(.*)"):lower()
	status = string.gsub(status, "^%s*(.-)%s*$", "%1")

	awesome.emit_signal("evil::playerctl", artist, title, status)
end

-- Sleeps until playerctl changes state (pause/play/next/prev)
local playerctl_script = [[
  sh -c '
    playerctl metadata --format 'artist_start{{artist}}title_start{{title}}status_start{{status}}' --follow
  ']]

-- Kill old playerctl process
awful.spawn.easy_async_with_shell(
	"ps x | grep \"playerctl metadata\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		-- Emit song info with each line printed
		awful.spawn.with_line_callback(playerctl_script, {
			stdout = function(line)
				emit_info(line)
			end,
		})
	end
)
