local Userpanel = {}
Userpanel.boughtMaps = {}
-- Tops 1
Userpanel.toptimesQuery = [[(SELECT player_name, map_name, map_resource, time_ms FROM ddc_accounts, ddc_toptimes toptimes INNER JOIN (
                            SELECT map_id, MIN(time_ms) mintt
                            FROM ddc_toptimes
                            GROUP BY map_id
                        ) toptimes2 ON toptimes.map_id = toptimes2.map_id AND toptimes.time_ms = toptimes2.mintt, ddc_maps WHERE ddc_accounts.id = toptimes.player_id AND toptimes.map_id = ddc_maps.id AND player_id = (SELECT id FROM ddc_accounts WHERE player_account = ?))]]
-- All tops		

Userpanel.toptimesQuery2 = [[(SELECT ddc_maps.map_name, ddc_accounts.player_name player_name, ddc_toptimes.time_ms time, ddc_toptimes.recorded_at date FROM ddc_toptimes, ddc_accounts, ddc_maps WHERE ddc_toptimes.player_id = 1 AND ddc_toptimes.player_id = ddc_accounts.id AND ddc_toptimes.map_id = ddc_maps.id ORDER BY time_ms)]]

function Userpanel.serverInfo()

	triggerClientEvent(source, "onClientUserpanelReceiveServerInfo", source, {getServerName()})

end
addEvent("onUserpanelRequestServerInfo", true)
addEventHandler("onUserpanelRequestServerInfo", root, Userpanel.serverInfo)


function Userpanel.requestMaps()

	local arenaElement = getElementParent(source)
	
	local type = getElementData(arenaElement, "type")
	
	if not type then return end
	
	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	if not Userpanel.connection then return end

	local account = getElementData(source, "account")
	
	type = "'"..type:gsub(";", "', '").."'"

	if account then
	
		dbQuery(Userpanel.mapsCallback, {source}, Userpanel.connection, "SELECT *, (SELECT COUNT(*) FROM ddc_map_favorites, ddc_accounts WHERE ddc_map_favorites.map_id = ddc_maps.id AND ddc_map_favorites.player_id = ddc_accounts.id AND ddc_accounts.player_account = ?) as map_favorite FROM ddc_maps WHERE map_type IN ( "..type.." ) ORDER BY map_favorite DESC;", account)
	
	else
		
		dbQuery(Userpanel.mapsCallback, {source}, Userpanel.connection, "SELECT *, (SELECT 0 FROM ddc_maps) as map_favorite FROM ddc_maps WHERE map_type IN ( "..type.." );")
	
	end
	
end
addEvent("onUserpanelRequestMaps", true)
addEventHandler("onUserpanelRequestMaps", root, Userpanel.requestMaps)


function Userpanel.mapsCallback(handle, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("Maps: No result!")
		dbFree(handle)
		return 
		
	end
	
	if not isElement(player) then return end
	
	triggerClientEvent(player, "onUserpanelReceiveMaps", root, result)
	
end


function Userpanel.requestClans()

	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	if not Userpanel.connection then return end
	
	dbQuery(Userpanel.clansCallback, {source}, Userpanel.connection, "SELECT *, (SELECT COUNT(*) FROM ddc_clan_members WHERE ddc_clan_members.clan_id = ddc_clans.id) AS member_count FROM ddc_clans;")
	
end
addEvent("onUserpanelRequestClans", true)
addEventHandler("onUserpanelRequestClans", root, Userpanel.requestClans)


function Userpanel.clansCallback(handle, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("Maps: No result!")
		dbFree(handle)
		return 
		
	end

	if not isElement(player) then return end
	
	triggerClientEvent(player, "onUserpanelReceiveClans", root, result)

end


function Userpanel.requestClanMembers(clanID)

	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	if not Userpanel.connection then return end
	
	dbQuery(Userpanel.clanMembersCallback, {source}, Userpanel.connection, "SELECT member_name as player_account, player_name, is_owner FROM ddc_clan_members LEFT JOIN ddc_accounts ON ddc_clan_members.member_name = ddc_accounts.player_account WHERE clan_id = ?;", clanID)	
	
end
addEvent("onUserpanelRequestClanMembers", true)
addEventHandler("onUserpanelRequestClanMembers", root, Userpanel.requestClanMembers)


function Userpanel.clanMembersCallback(handle, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("Maps: No result!")
		dbFree(handle)
		return 
		
	end

	if not isElement(player) then return end
	
	triggerClientEvent(player, "onUserpanelReceiveClanMembers", root, result)

end


function Userpanel.requestPlayerStats(playerAccount)

	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	if not Userpanel.connection then return end
	
	dbQuery(Userpanel.playerStatsCallback, {source}, Userpanel.connection, "SELECT ddc_accounts.player_account, player_name, player_country, player_toptimes, player_cash, player_rolls, player_spins, ddc_stats_lemon.player_dms, ddc_stats_lemon.player_wins, ddc_stats_lemon.player_gametime FROM ddc_accounts JOIN ddc_stats_lemon ON ddc_accounts.player_account = ddc_stats_lemon.player_account WHERE ddc_accounts.player_account = ?;", playerAccount)	
	
end
addEvent("onUserpanelRequestPlayerStats", true)
addEventHandler("onUserpanelRequestPlayerStats", root, Userpanel.requestPlayerStats)


function Userpanel.playerStatsCallback(handle, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("Maps: No result!")
		dbFree(handle)
		return 
		
	end

	if not isElement(player) then return end
	
	triggerClientEvent(player, "onUserpanelReceivePlayerStats", root, result)

end

--CREATE TABLE ddc_map_favorites ( map_id int(10) UNSIGNED NOT NULL, player_id int(10) UNSIGNED NOT NULL, FOREIGN KEY (map_id) REFERENCES ddc_maps(id), FOREIGN KEY (player_id) REFERENCES ddc_accounts(id), UNIQUE (map_id, player_id) );
function Userpanel.requestMapDetails(map)

	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	if not Userpanel.connection then return end

	local account = getElementData(source, "account")

	if account then
	
		dbQuery(Userpanel.mapDetailsCallback, {source}, Userpanel.connection, "SELECT *, (SELECT COUNT(*) FROM ddc_toptimes WHERE ddc_toptimes.map_id = ddc_maps.id) AS map_toptimes, (SELECT COUNT(*) FROM ddc_map_favorites, ddc_accounts WHERE ddc_map_favorites.map_id = ddc_maps.id AND ddc_map_favorites.player_id = ddc_accounts.id AND ddc_accounts.player_account = ?) as map_favorite FROM ddc_maps WHERE map_name = ?;", account, map)
	
	else

		dbQuery(Userpanel.mapDetailsCallback, {source}, Userpanel.connection, "SELECT *, (SELECT COUNT(*) FROM ddc_toptimes WHERE ddc_toptimes.map_id = ddc_maps.id) AS map_toptimes, (SELECT 0 FROM ddc_maps) FROM ddc_maps WHERE map_name = ?;", map)	
	
	end
	
end
addEvent("onUserpanelRequestMapDetails", true)
addEventHandler("onUserpanelRequestMapDetails", root, Userpanel.requestMapDetails)


function Userpanel.mapDetailsCallback(handle, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("Maps: No result!")
		dbFree(handle)
		return 
		
	end

	if not isElement(player) then return end
	
	triggerClientEvent(player, "onUserpanelReceiveMapDetails", root, result)

end


function Userpanel.requestMyTops(account)

	if not account then return end
	
	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	dbQuery(Userpanel.toptimesCallback, {account, source}, Userpanel.connection, Userpanel.toptimesQuery, account)
	
end
addEvent("onUserpanelRequestMyTops", true)
addEventHandler("onUserpanelRequestMyTops", root, Userpanel.requestMyTops)


function Userpanel.toptimesCallback(handle, account, player)

	local result = dbPoll(handle, 0)

	if not getPlayerName(player) then return end

	--No Result
	if not result then

		outputDebugString("No result!")
		dbFree(handle)
		return

	end
	
	triggerClientEvent(player, "onUserpanelReceiveMyTops", root, result)

end


function Userpanel.requestMapTops(map)

	if not map then return end
	
	Userpanel.connection = exports["CCS_database"]:getConnection()
	
	dbQuery(Userpanel.mapToptimesCallback, {source}, Userpanel.connection, "SELECT ddc_accounts.player_name, ddc_accounts.player_account, ddc_maps.map_name, time_ms FROM ddc_accounts, ddc_toptimes, ddc_maps WHERE ddc_accounts.id = ddc_toptimes.player_id AND ddc_toptimes.map_id = ddc_maps.id AND ddc_maps.map_resource = ? ORDER BY time_ms" , map)

end
addEvent("onUserpanelRequestMapToptimes", true)
addEventHandler("onUserpanelRequestMapToptimes", root, Userpanel.requestMapTops)


function Userpanel.mapToptimesCallback(handle, player)

	local result = dbPoll(handle, 0)

	if not getPlayerName(player) then return end

	--No Result
	if not result then

		outputDebugString("No result!")
		dbFree(handle)
		return

	end
	
	triggerClientEvent(player, "onUserpanelReceiveMapTops", root, result)

end


function Userpanel.requestSettings()

	triggerClientEvent(source, "onUserpanelReceiveSettings", root, exports["CCS_stats"]:export_getPlayerSettings(source))
	
end
addEvent("onUserpanelRequestSettings", true)
addEventHandler("onUserpanelRequestSettings", root, Userpanel.requestSettings)


function Userpanel.saveSettings(settings)

	if getElementData(source, "setting:player_language") ~= settings["player_language"] then
	
		executeCommandHandler("join", source, settings["player_language"])
		
	end

	exports["CCS_stats"]:export_changePlayerSettings(source, settings)

end
addEvent("onUserpanelSaveSettings", true)
addEventHandler("onUserpanelSaveSettings", root, Userpanel.saveSettings)


function Userpanel.requestLanguages()

	triggerClientEvent(source, "onUserpanelReceiveLanguages", root, exports["CCS"]:export_getLanguages()) 

end
addEvent("onUserpanelRequestLanguages", true)
addEventHandler("onUserpanelRequestLanguages", root, Userpanel.requestLanguages)


function Userpanel.updateMapFavorite(map, favorite)
	
	if not map then return end

	local account = getElementData(source, "account")

	if not account then return end
	
	Userpanel.connection = exports["CCS_database"]:getConnection()

	if favorite then
	
		dbExec(Userpanel.connection, "INSERT INTO ddc_map_favorites (map_id, player_id) VALUES ((SELECT id FROM ddc_maps WHERE map_resource = ?), (SELECT id from ddc_accounts WHERE player_account = ?)) ON DUPLICATE KEY UPDATE map_id = map_id;" , map, account)

	else
	
		dbExec(Userpanel.connection, "DELETE FROM ddc_map_favorites WHERE map_id = (SELECT id FROM ddc_maps WHERE map_resource = ?) AND player_id = (SELECT id from ddc_accounts WHERE player_account = ?)" , map, account)
	
	end

end
addEvent("onUserpanelUpdateMapFavorite", true)
addEventHandler("onUserpanelUpdateMapFavorite", root, Userpanel.updateMapFavorite)


function Userpanel.requestNextmap(map)

	local resource = getResourceFromName("CCS_stats")

	if not resource then return end
	
	if getResourceState(resource) ~= "running" then return end
	
	local arenaElement = getElementParent(source)

	if #getElementData(arenaElement, "nextmap") > 2 then

		outputChatBox("Error: Next map queue is full!", source, 255, 0, 128)
		return

	end
	
	if not Userpanel.boughtMaps[arenaElement] then
	
		Userpanel.boughtMaps[arenaElement] = {}
		
	end
	
	local type = getElementData(arenaElement, "type")
	
	local map = exports["CCS"]:export_findMap(map, type)
	
	if not map or #map == 0 then
	
		outputChatBox("Error: Map not found!", source, 255, 0, 128)
		return
		
	end
	
	map = map[1]
	
	if Userpanel.boughtMaps[arenaElement][map.name] and getTickCount() - Userpanel.boughtMaps[arenaElement][map.name] >= 3600000 then
	
		Userpanel.boughtMaps[arenaElement][map.name] = nil
		
	end
	
	if Userpanel.boughtMaps[arenaElement][map.name] then

		local timeLeft = 3600000 - (getTickCount() - Userpanel.boughtMaps[arenaElement][map.name])
	
		outputChatBox("Error: This map can be bought again in: "..exports["CCS"]:export_msToHourMinuteSecond(timeLeft), source, 255, 0, 128)
		return

	end	
	
	local playerName = getPlayerName(source):gsub('#%x%x%x%x%x%x', '')
	
	if not exports["CCS_stats"]:export_takePlayerMoney(source, 100000) then 
	
		outputChatBox("Error: You don't have enough money!", source, 255, 0, 128)
		return
	
	end
	
	local nextmap = getElementData(arenaElement, "nextmap")
	
	table.insert(nextmap, map)
	
	setElementData(arenaElement, "nextmap", nextmap)
	
	Userpanel.boughtMaps[arenaElement][map.name] = getTickCount()

	exports["CCS"]:export_outputArenaChat(arenaElement, "#00f000"..playerName.." bought "..map.name.." to be the next map! ($100000)")

end
addEvent("onUserpanelRequestNextmap", true)
addEventHandler("onUserpanelRequestNextmap", root, Userpanel.requestNextmap)