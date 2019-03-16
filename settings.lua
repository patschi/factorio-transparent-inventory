data:extend({
	{ -- If the mod is active at all
		type = "bool-setting",
		name = "is-enabled",
		setting_type = "runtime-global",
		default_value = true,
	},
	{ -- If we should tell the owner of the inventory something
		type = "bool-setting",
		name = "tell-stalker",
		setting_type = "runtime-global",
		default_value = true,
	},
})
