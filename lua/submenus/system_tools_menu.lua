local awful = require("awful")

return {
	{
		"system-monitoring-center",
		function()
			awful.spawn("system-monitoring-center")
		end,
	},
    {
        "lxtask",
        function ()
            awful.spawn("lxtask")
        end
    },
	{
		"virt manager",
		function()
			awful.spawn("virt-manager")
		end,
	},
	{
		"VirtualBox",
		function()
			awful.spawn("VirtualBox")
		end,
	},
	{
		"cpu-x",
		function()
			awful.spawn("cpu-x")
		end,
	},
	{
		"gparted",
		function()
			awful.spawn("gparted")
		end,
	},
	{
		"alacritty",
		function()
			awful.spawn("alacritty")
		end,
	},
	{
		"st",
		function()
			awful.spawn("st")
		end,
	},
	{
		"kitty",
		function()
			awful.spawn("kitty")
		end,
	},
}
