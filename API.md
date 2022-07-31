Ranks API
=========
The ranks API allows you to register, unregister, and manage ranks.

`ranks.register(name, def)`

* Register a new rank
* `name`: Name for rank (name cannot be `clear`)
* `def`: See [#Rank definition]

`ranks.unregister(name)`

* Unregister a rank
* `name`: Name of rank

`ranks.list_plaintext()`

* Returns a plaintext, comma-separated list of ranks

`ranks.get_rank(player)`

* Returns the player's rank or `nil`
* `player`: PlayerRef or string

`ranks.get_def(name)`

* Returns the rank definition or `nil`
* `name`: Name of rank

`ranks.update_nametag(player)`

* Checks and updates player nametag based on rank definition
* Returns `true` if successful, `nil` if player has no rank
* Automatically called `on_joinplayer` and on `ranks.set_rank`
* `player`: PlayerRef or string

`ranks.set_rank(player, rank)`

* Changes a player's rank
* Returns `true` if successful, `nil` if rank doesn't exist
* `player`: PlayerRef or string
* `rank`: Name of rank

`ranks.remove_rank(player)`

* Removes all ranking information from a player
* `player`: PlayerRef or string

#### Rank definition
```lua
{
	prefix = "Moderator", -- Prefix to be shown on nametag and chat
	colour = {a = 255, r = 255, g = 83, b = 37}, -- A table of RGBA values, a single base colour (e.g. "red"), or a hex string
}
```
