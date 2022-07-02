![Screenshot](screenshot.png)

Advanced Ranks [ranks]
=======================

Ranks is an advanced ranks mod geared towards larger servers helps to both distiguish between players and make managing privileges much easier. With several ranks premade and a simplistic API, ranks is a good addition to any server, especially those with many players.

This mod was made in an effort to solve two problems. One of these is new players getting confused when they see moderators or administrators doing things that normal players cannot, resulting in repeated accusations of hacking. Ranks allows there to be no confusion between what a player should or should not be able to do, as their rank is displayed in both their nametag and as a prefix to chat messages sent by them.

### Packaged Ranks
By default, four ranks are included with the ranks mod, however, they are only for decoration purposes and do not modify any privileges as they should be configured by each server owner.

* Admin (`admin`)
* Moderator (`moderator`)

The above demonstrates that while ranks can be useful for managing privileges, it can also be a very nice form of progression/recognition.

**`/rank` Usage:**
```
Name or operation is either a player name, or "list" to list ranks
If the operation is "list", no new rank is needed
Setting new rank to "clear" causes all rank information to be removed from the player

/rank <name or operation> <new rank>
```

### Creating Ranks
You can create your own ranks and learn about privilege management in the API documentation. It explains how to manage privileges and register ranks with the `ranks.register` function. Registrations can be made either in the `ranks.lua` file of the mod itself (where default ranks or unregistered), or they can be preferrably placed in a `ranks.lua` file inside the world directory.

If you don't want one of the built in ranks, you can either register a new rank with the same name (effectively overriding the rank) or learn about `ranks.unregister` which can also be called from the world file.
