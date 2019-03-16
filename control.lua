-- Listener when mod gets initialized
script.on_init(function ()
	serverLog("TransparentInventory initialized.") -- Show it in the server-side log
end)

-- Listener when someone presses the hotkey
script.on_event("tinv-open", function(event) -- When defined shortcut was called...
	stalking_player_inventory(event) -- ...then we call our function just right below.
end)

-- Main function
function stalking_player_inventory(event)
	-- Notes:
	--  "selected player" is the player who's inventory is opened
	--  simply "player" is actually the player who's doing that

	if settings.global["tinv-is-enabled"].value then -- Check if TINV is globally enabled. If so, proceed.
		local player = game.get_player(event.player_index) -- Get LuaPlayer class from current player who triggered the shortcut
		local selected = player.selected -- Get the selected LuaEntity of said player

		local colors = { -- A few colors we use later on
			red    = {r = 1};
			green  = {g = 1};
			orange = {r = 255, g = 99, b = 71};
		}

		-- selected.player might be nil when being in "god mode" (where the character is detached from LuaPlayer)
		-- Check must be last to actually not crash when trying to open inventory of any other entity than a player
		-- Check that target is not empty and is actually a player
		if selected ~= nil and selected.type == "player" and selected.player ~= nil then
			-- Everything is fine... so proceed...
			local selected_player = selected.player -- "selected" is just LuaEntity, therefore we use player property to get LuaPlayer class
			-- Check if player is allowed to open inventory of someone
			if tinv_is_allowed_to_stalk(player) then
				serverLog(player.name .. " is looking in the inventory of player " .. selected_player.name)
				if settings.global["tinv-tell-stalker"].value then -- Check if we tell selected player that player is stalking him
					selected_player.print({'message.target-is-stalking-player', player.name}, colors.orange) -- Write selected player that someone is stalking him now
				end
				player.print({'message.player-stalking-now', selected_player.name}, colors.green) -- Write current player
				player.opened = selected_player -- Force the player to open LuaPlayer (which causes the inventory to open)
			else -- Apparently not...
				serverLog(player.name .. " tried looking in the inventory of player " .. selected_player.name .. " but was denied.")
				player.print({'message.player-stalking-not-allowed'}, colors.red) -- Tell the player that he's not allowed to stalk
			end
		else -- ...or not...
			player.print({'message.target-must-be-player'}, colors.red) -- Tell the player that the target must be a player
		end
	end
end

function tinv_is_allowed_to_stalk(player)
	local mode = settings.global["tinv-users-mode"].value
	local users = settings.global["tinv-users-list"].value

	-- Lets check if username matches
	for user in string.gmatch(users, '([^,]+)') do -- Go through all defined users, separated by comma
		if tinv_playername_matches(player.name, user) then -- If current user matches...
			if mode == "only-listed" then -- If only-listed and user is matching, then the user has permission
				return true
			elseif mode == "excluding-listed" then -- If excluding-listed and user is matching, the user is not allowed to
				return false
			end
		end
	end

	-- Default if no matching user was found
	if mode == "only-listed" then -- If only-listed, all other user are not granted access
		return false
	elseif mode == "excluding-listed" then -- If excluding-listed, by default everyone has access, except listed
		return true
	end

	return false -- If anything strange happens, we simply deny as a fallback
end

-- Function to check if username matches and taking wildcard into account
function tinv_playername_matches(player_name, compare_name)
	local regex_enabled = settings.global["tinv-users-list-regex"].value
	
	-- Check if username contains a wildcard sign, so we know we check it a different way
	if not regex_enabled and string.find(compare_name, "%*") then -- "%" is the escape char in Lua... whyever.
		-- Note: It might be possible directly using string.match() on it, but I would like to use simply "*" as the wildcard char
		--       instead of the official Lua ".*" wildcard for the match function. So this is basically a workaround for that.
		compare_name = string.gsub(compare_name, "%*", ".*")
		if string.match(player_name:lower(), "^" .. compare_name:lower() .. "$") then -- Check is case-insensitive.
			return true
		end

	elseif regex_enabled then -- If regex support is enabled... Fingers crossed the user knows what to do.
		-- Here we now valdiate the player_name after all specified regex strings, exactly as user provided.
		-- Notice: This is case-sensitive!
		if string.match(player_name, "^" .. compare_name .. "$") then
			return true
		end

	else -- Fallback. No wildcard, going the boring way...
		if player_name:lower() == compare_name:lower() then -- Check is case-insensitive.
			return true
		end
	end

	return false -- By default it does not match
end

-- Function to log something in the server log
function serverLog(text)
	log(text) -- Logs to server output
end
