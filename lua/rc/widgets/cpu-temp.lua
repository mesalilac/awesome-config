local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local get_script = require("lua.helpers.get_script").get_script

local M = {}

M.widget = {
	{
		{
			widget = awful.widget.watch("bash -c " .. get_script("cpu-temp.sh"), 3),
		},
		left = 10,
		right = 10,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin,
	},
	fg = beautiful.widget_fg,
	bg = "#7dbde8",
	widget = wibox.container.background,
}

return M