local awful = require("awful")
local gfs = require("gears.filesystem")

local lock_screen = {}

local lua_pam_path = gfs.get_configuration_dir() .. "modules/lockscren/lib/liblua_pam.so"

-- Initialize authentication method based on whether lua-pam has been
-- installed or not
awful.spawn.easy_async_with_shell("stat " .. lua_pam_path .. " >/dev/null 2>&1", function(_, __, ___, exitcode)
	if exitcode == 0 then
		local pam = require("liblua_pam")
		-- lua-pam was installed.
		-- Authenticate with PAM
		-- TODO: setup lib-pam
		lock_screen.authenticate = function(password)
			return pam.auth_current_user(password)
		end
	else
		-- lua-pam was NOT installed.
		-- Authenticate with user.lock_screen_custom_password
		lock_screen.authenticate = function(password)
			return password == user.lock_screen_custom_password
		end
	end

	-- Load the lock_screen element
	require("modules.lockscreen.lockscreen")
end)

return lock_screen
-- EOF ------------------------------------------------------------------------
