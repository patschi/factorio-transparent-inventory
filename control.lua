script.on_init(function ()
	logServer("TransparentInventory initialized.") -- Show it in the server-side log
end)

script.on_event("tinv-open", function(event) -- When defined shortcut was called...
	stalking_player_inventory(event) -- ...then we call our function just right below.
end)

function stalking_player_inventory(event)
	-- "selected player" is the player who's inventory is opened
	-- simply "player" is actually the player who's doing that

	if settings.global["is-enabled"].value then -- Check if TINV is globally enabled. If so, proceed.
		local player = game.get_player(event.player_index) -- Get LuaPlayer class from current player who triggered the shortcut
		local selected = player.selected -- Get the selected LuaEntity of said player

		local colors = { -- A few colors we use later on
			red    = {r = 1};
			green  = {g = 1};
			orange = {r = 255, g = 99, b = 71};
		}

		-- selected.player might be nil when being in "god mode" (where the character is detached from LuaPlayer)
		-- Check must be last to actually not crash when trying to open inventory of any other entity than a player
		if selected ~= nil and selected.type == "player" and selected.player ~= nil then -- Check that target is not empty and is actually a player
			-- Everything is fine... so lets look into the inventory!
			local selected_player = selected.player -- "selected" is just LuaEntity, therefore we use player property to get LuaPlayer class
			player.print({'message.player-stalking-now', selected_player.name}, colors.green) -- Write current player
			if settings.global["tell-stalker"].value then -- Check if we tell selected player that player is stalking him
				selected_player.print({'message.target-is-stalking-player', player.name}, colors.orange) -- Write selected player that someone is stalking him now
			end
			logServer(player.name .. "is looking in the inventory of player " .. selected_player.name) -- Write it to the server logs for whatever reasons
			player.opened = selected_player -- Force the player to open LuaPlayer (which causes the inventory to open)
		else -- ...or not...
			player.print({'message.target-must-be-player'}, colors.red) -- Tell the player that the target must be an player
		end
	end
end

function logServer(text)
	log(text) -- Logs to server output
end
