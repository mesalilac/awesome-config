-- CMUS controler, taken from Robin Hahling
-- http://blog.rolinh.ch/linux/un-widget-controleur-pour-le-lecteur-audio-cmus-pour-awesome-wm/

--module("lib/cmus")

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")


local M = {}

--{{{ Get cmus PID to check if it is running
local function getCmusPid()
	local fpid = io.popen("pgrep cmus")
	if fpid then
		local pid = fpid:read("*n")
		fpid:close()
		return pid
	end
end --}}}

--{{{ Enable cmus control
function M.cmus_cmd(action)
	local cmus_info, cmus_state
	local cmus_run = getCmusPid()
	if cmus_run then
		cmus_info = io.popen("cmus-remote -Q"):read("*all")
		cmus_state = string.gsub(string.match(cmus_info, "status %a*"), "status ", "")
		if cmus_state ~= "stopped" then
			if action == "next" then
				io.popen("cmus-remote -n")
			elseif action == "previous" then
				io.popen("cmus-remote -r")
			elseif action == "stop" then
				io.popen("cmus-remote -s")
			end
		end
		if action == "play_pause" then
			if cmus_state == "playing" or cmus_state == "paused" then
				io.popen("cmus-remote -u")
			elseif cmus_state == "stopped" then
				io.popen("cmus-remote -p")
			end
		end
	end
end --}}}

-- Cmus Widget
local function hook_cmus() --{{{
	-- check if cmus is running
	local cmus_run = getCmusPid()

	if cmus_run then
		local cmus_info = io.popen("cmus-remote -Q"):read("*all")
		local cmus_state = string.gsub(string.match(cmus_info, "status %a*"), "status ", "")
		if cmus_state == "playing" or cmus_state == "paused" then
			local cmus_artist = string.match(cmus_info, "tag artist %C*")
			if cmus_artist == nil then
				cmus_artist = "unknown artist"
			else
				cmus_artist = string.gsub(cmus_artist, "tag artist ", "")
			end

			local cmus_title = string.match(cmus_info, "tag title %C*")
			if cmus_title == nil then
				cmus_title = "unknown title"
			else
				cmus_title = string.gsub(cmus_title, "tag title ", "")
			end

			-- cut the string off it its more than 15 chars
			if string.len(cmus_artist) > 15 then
				cmus_artist = string.sub(cmus_artist, 1, 15)
				cmus_artist = cmus_artist .. "..."
			end
			if string.len(cmus_title) > 15 then
				cmus_title = string.sub(cmus_title, 1, 15)
				cmus_title = cmus_title .. "..."
			end

			local cmus_curtime = string.gsub(string.match(cmus_info, "position %d*"), "position ", "")
			local cmus_curtime_formated = math.floor(cmus_curtime / 60)
				.. ":"
				.. string.format("%02d", cmus_curtime % 60)
			local cmus_totaltime = string.gsub(string.match(cmus_info, "duration %d*"), "duration ", "")
			local cmus_totaltime_formated = math.floor(cmus_totaltime / 60)
				.. ":"
				.. string.format("%02d", cmus_totaltime % 60)

			-- cmus_title = string.format("%.5c", cmus_title)
			local cmus_string = cmus_artist
				.. " - "
				.. cmus_title
				.. " ("
				.. cmus_curtime_formated
				.. "/"
				.. cmus_totaltime_formated
				.. ")"
			if cmus_state == "paused" then
				cmus_string = "|| " .. cmus_string .. ""
			else
				cmus_string = "> " .. cmus_string .. ""
			end
			cmus_string = cmus_string

			-- remove "&" from the span field
			return cmus_string
		else
			cmus_string = "cmus is not playing"
		end
		return cmus_string
	else
		return "cmus is not running"
	end
end --}}}

M.widget = {
	{
		{
			widget = awful.widget.watch("cmus", 1, function(widget)
				widget:set_text(hook_cmus())
			end),
		},
		left = 10,
		right = 10,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin,
	},
	fg = beautiful.widget_fg,
	bg = "#7476e8",
	widget = wibox.container.background,
}

return M