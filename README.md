# Factorio Mod: Transparent Inventory

![Thumbnail](https://raw.githubusercontent.com/patschi/factorio-transparent-inventory/master/thumbnail.png "Thumbnail")
![Mod Settings](https://raw.githubusercontent.com/patschi/factorio-transparent-inventory/master/screenshots/settings_mod.png "Mod Settings")

This is a simple [Factorio](https://www.factorio.com/) mod ([also available on mods.factorio.com](https://mods.factorio.com/mod/transparent-inventory)) which makes all inventories transparent for all players. This way any player is able to **open inventories of other players using ALT + MOUSE-CLICK-1** (*default*), just like admins on multiplayer servers can do. However when this mod is active, **players do not need admin permissions** to be able to do that and additionally the owner is informed (*enabled by default*) when somewhen opens his personal inventory.

This helps sharing resources with friends without figgling around with temporary chests, nor wasting valuable time trying to communicate which or how many resources exactly your friends needs to be productive. This way your friends can simply take everything they need* **to be more productive than ever before!**

Probably most useful on smaller multiplayer servers with people you trust.

(*) I'm not responsible for any item losses when your friend takes something away from you.

## Features

- Open inventories of all players, without admin permissions
- Ability for players to decide if they allow access to their inventory from other players
- Allowing to change the hotkey to look in other inventories
- Language support for English and German
- **Admin**: Ability to deactivate this mod in the mod settings
- **Admin**: Ability to control access for specific users (including [wildcard](#users-list-wildcard) and [Lua regex support for advanced users](#users-list-lua-regex))
- **Admin**: Ability to control whether users can allow access to their inventory. This can be globally overwritten.
- **Admin**: Ability to turn off messages to inventory owners

## Requirements

- Factorio multiplayer server running 0.17 and later
- More than one active player to have inventories to look into

## Roadmap/Ideas

- [x] Publish this mod on [mods.factorio.com](https://mods.factorio.com/mod/transparent-inventory)
- [x] Have at least 1 download on [mods.factorio.com](https://mods.factorio.com/mod/transparent-inventory)
- [ ] Notice the inventory owner which items got added/removed after inventory was accessed. (including mod setting)
- [ ] Add custom events for integration of other mods

## Notes

### Factorio Mods

The mod is also available on the [official Factorio mods portal here]([mods.factorio.com](https://mods.factorio.com/mod/transparent-inventory)).

### Users list: Wildcard

Using wildcard is quite simple. You can simple put an asterisk (`*`) wherever you want to. **Notice:** This is case-insensitive and this is only possible when regex support is *disabled*.

#### Wildcard Examples

- `superg*` matches any username which starts with `super`, like `supergirl`.
- `*man` matches any username which ends with `man`, like `superman`, `batman` or `spiderman`.
- `*t*` matches any username which has a `t` in their name. (The same for uppercase `T`, as this is case-insensitive)

### Users list: Lua Regex

Lua Regex is quite special, therefore I strongly recommend doing researches before enabling the regex support in the mod. The regex in Lua is only capable of a tiny subset of features as the PCRE-regex known in other programming languages. You can find a [Lua documentation regarding regex here](https://www.lua.org/pil/20.2.html).

#### Regex Examples

- Not liking usernames which are completely uppercase and sounds like shouting? When enabling `All users, except listed ones` and using `%u+` as regex, everyone can open inventories of other users - except players with just an uppercase username.
- Quite the same as the sample above: When using `%d+` you can deny usernames which are only consisting out of digits, like `133742`.

## Credits

- [Factorio](https://www.factorio.com/) for their awesome, (very) addictive game
- Big thanks goes to the very friendly, helpful people over at [Factorio Discord](https://discord.gg/factorio) in *#mod-making* for their support to make this mod possible
