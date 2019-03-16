local hotkey = {
	type = "custom-input",
	name = "tinv-open",
	key_sequence = "ALT + mouse-button-1",
	consuming = "none",
	localised_name = {'shortcut'}, -- Actual translation for current language in locale/ directory
}

data:extend{hotkey}
