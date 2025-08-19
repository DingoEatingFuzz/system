return {
	base46 = {
		theme = "oceanic-next",
		hl_add = {},
		hl_override = {},
		integrations = {},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "oceanic-next", "oceanic-light" },
	},

	-- Derived from nvchad/ui: https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
	ui = {
		cmp = {
			icons_left = false,
			style = "default",
			abbr_maxwidth = 60,
			format_colors = {
				tailwind = false,
				icon = "󱓻",
			},
		},

		telescope = { style = "borderless" }, -- borderless / bordered

		statusline = {
			enabled = false,
		},

		tabufline = {
			enabled = false,
		},

		colorify = {
			enabled = false,
		},
	},

	term = {
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	lsp = { signature = true },

	-- Unused yet necessary config tables
	cheatsheet = {},
}
