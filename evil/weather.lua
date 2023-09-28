-- Provides:
-- evil::weather
--      result json (string)
local awful = require("awful")
local json = require("modules.json")

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

local GET_FORECAST_CMD = [[bash -c "curl -s --show-error -X GET '%s'"]]

awful.widget.watch(string.format(GET_FORECAST_CMD, url), 600, function(_, stdout, stderr)
	if stderr == "" then
		local result = json.decode(stdout)
		awesome.emit_signal("evil::weather", result)
	end
end)
