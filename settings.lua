data:extend({
	{ -- If the mod is active at all
		type = "bool-setting",
		name = "tinv-is-enabled",
		setting_type = "runtime-global",
		default_value = true,
		order = "tinv-setting-10",
	},
	{ -- If we should tell the owner of the inventory something
		type = "bool-setting",
		name = "tinv-tell-stalker",
		setting_type = "runtime-global",
		default_value = true,
		order = "tinv-setting-20",
	},
	{ -- The mode the provided users list should be handled
		type = "string-setting",
		name = "tinv-users-mode",
		setting_type = "runtime-global",
		default_value = "excluding-listed",
		allowed_values = { "only-listed", "excluding-listed" },
		order = "tinv-setting-30",
	},
	{ -- If regex-support for users list is enabled
		type = "bool-setting",
		name = "tinv-users-list-regex",
		setting_type = "runtime-global",
		default_value = false,
		order = "tinv-setting-40",
	},
	{ -- Users which should be allowed/disallowed to open invs
		type = "string-setting",
		name = "tinv-users-list",
		setting_type = "runtime-global",
		default_value = "",
		allow_blank = true,
		order = "tinv-setting-45",
	},
})
