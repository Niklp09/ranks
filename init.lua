ranks = {}

local registered   = {}
local default
local player

-- Load mod storage
local storage = minetest.get_mod_storage()

---
--- API
---

-- [local function] Get colour
local function get_colour(colour)
	if type(colour) == "table" and minetest.rgba then
		return minetest.rgba(colour.r, colour.g, colour.b, colour.a)
	elseif type(colour) == "string" then
		return colour
	else
		return "#ffffff"
	end
end

-- [function] Register rank
function ranks.register(name, def)
	assert(name ~= "clear", "Invalid name \"clear\" for rank")

	registered[name] = def

	if def.default then
		default = name
	end
end

-- [function] Unregister rank
function ranks.unregister(name)
	registered[name] = nil
end

-- [function] List ranks in plain text
function ranks.list_plaintext()
	local list = ""
	for rank, i in pairs(registered) do
		if list == "" then
			list = rank
		else
			list = list..", "..rank
		end
	end
	return list
end

-- [function] Get player rank
function ranks.get_rank(name)
	if type(name) ~= "string" then
		name = minetest.get_player_by_name(name)
	end

	local rank = storage:get_string(name)
	if rank ~= "" and registered[rank] then
		return rank
	end
end

-- [function] Get rank definition
function ranks.get_def(rank)
	if not rank then
		return
	end

	return registered[rank]
end

-- [function] Update player nametag
function ranks.update_nametag(name)

	if type(name) ~= "string" then
		name = name:get_player_name()
	else
		player = minetest.get_player_by_name(name)
	end

	local rank = ranks.get_rank(name)
	if rank ~= nil then
		local def    = ranks.get_def(rank)
		local colour = get_colour(def.colour)
		local prefix = def.prefix

		if prefix then
			prefix = minetest.colorize(colour, prefix).." "
		else
			prefix = ""
		end

		local player = minetest.get_player_by_name(name)
		if player then
			player:set_nametag_attributes({
				text = prefix..name,
			})
		end

		return true
	end
end

-- [function] Set player rank
function ranks.set_rank(name, rank)
	if type(name) ~= "string" then
		name = name:get_player_name()
	end

	if registered[rank] and minetest.player_exists(name) then
		storage:set_string(name, rank)

		-- Update nametag
		ranks.update_nametag(name)

		return true
	end
end

-- [function] Remove rank from player
function ranks.remove_rank(name)
	if type(name) ~= "string" then
		name = name:get_player_name()
	else
		player = minetest.get_player_by_name(name)
	end

	local rank = ranks.get_rank(name)
	if rank ~= nil then
		storage:set_string(name, nil)

		local player = minetest.get_player_by_name(name)
		if player then
			-- Update nametag
			player:set_nametag_attributes({
				text = name,
				color = "#ffffff",
			})
		end
	end
end

---
--- Registrations
---

-- Assign/update rank on join player
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()

	-- If database item exists and new storage item does not, use database item
	if player:get_meta():get("ranks:rank") ~= nil and storage:get_string(name, rank) == "" then
		-- Add entry into new storage system
		storage:set_string(name, player:get_meta():get("ranks:rank"))

		-- Store backup then invalidate database item
		player:get_meta():set("ranks:rank-old", player:get_meta():get("ranks:rank"))
		player:get_meta():set("ranks:rank", nil)
	end

	-- Both items exist, remove old one
	if player:get_meta():get("ranks:rank") ~= nil and storage:get_string(name, rank) ~= "" then
		player:get_meta():set("ranks:rank-old", player:get_meta():get("ranks:rank"))
		player:get_meta():set("ranks:rank", nil)
	end

	if ranks.get_rank(name) then
		-- Update nametag
		ranks.update_nametag(name)
	else
		if ranks.default then
			ranks.set_rank(name, ranks.default)
		end
	end
end)

-- [chatcommand] /rank
minetest.register_chatcommand("rank", {
	description = "Set a player's rank",
	params = "<player> <new rank> / \"list\" | username, rankname / list ranks",
	privs = {server = true},
	func = function(name, param)
		local param = param:split(" ")
		if #param == 0 then
			return false, "Invalid usage (see /help rank)"
		end

		if #param == 1 and param[1] == "list" then
			return true, "Available Ranks: "..ranks.list_plaintext()
		elseif #param == 2 then
			if minetest.player_exists(param[1]) == false then
					return false, "Player does not exist"
			end

			if ranks.get_def(param[2]) then
				if ranks.set_rank(param[1], param[2]) then
					if name ~= param[1] then
						minetest.chat_send_player(param[1], name.." set your rank to "..param[2])
					end

					return true, "Set "..param[1].."'s rank to "..param[2]
				else
					return false, "Unknown error while setting "..param[1].."'s rank to "..param[2]
				end
			elseif param[2] == "clear" then
				ranks.remove_rank(param[1])
				return true, "Removed rank from "..param[1]
			else
				return false, "Invalid rank (see /rank list)"
			end
		else
			return false, "Invalid usage (see /help rank)"
		end
	end,
})

---
--- Ranks
---

-- Load default ranks
dofile(minetest.get_modpath("ranks").."/ranks.lua")