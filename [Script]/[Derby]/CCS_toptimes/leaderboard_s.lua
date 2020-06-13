Leaderboard = {}
Leaderboard.cache = {}
Leaderboard.oldCache = {}
Leaderboard.isDeleting = {}
Leaderboard.ROWS_TO_SHOW = 8
Leaderboard.selectQuery = [[
	SELECT leaderboard.id, accounts.player_account, accounts.player_name, accounts.player_country, leaderboard.time_ms, leaderboard.recorded_at FROM ddc_toptimes AS leaderboard 
	INNER JOIN ddc_accounts AS accounts ON leaderboard.player_id = accounts.id
	INNER JOIN ddc_maps AS maps ON leaderboard.map_id = maps.id
	WHERE maps.map_resource = ?
	ORDER BY time_ms, recorded_at
	LIMIT ?;
]]

Leaderboard.insertQuery = [[
    INSERT INTO ddc_toptimes (map_id, player_id, time_ms, recorded_at)
    SELECT id, (SELECT id FROM ddc_accounts WHERE player_account = ?), ?, NOW() FROM ddc_maps WHERE map_resource = ?
    ON DUPLICATE KEY UPDATE
    recorded_at = IF(time_ms > ?, NOW(), recorded_at),
    time_ms = IF(time_ms > ?, ?, time_ms);
]]

Leaderboard.deleteQuery = [[
	DELETE FROM ddc_toptimes WHERE id = ?
]]

Leaderboard.personalBestQuery = [[
	SELECT rank, accounts.player_account, accounts.player_name, accounts.player_country, time_ms, recorded_at 
	FROM (
		SELECT *, @rownum := @rownum + 1 AS rank
		FROM ddc_toptimes AS leaderboard, (SELECT @rownum := 0) t0
		WHERE leaderboard.map_id = (SELECT id from ddc_maps where map_resource = ?)
		ORDER BY time_ms
	) t1 
	INNER JOIN ddc_accounts AS accounts ON t1.player_id = accounts.id
	WHERE accounts.player_account = ?;
]]

function Leaderboard.updatePlayerCountry()

	local account = getElementData(source, "account")
	
	if not account then return end	
	
	local country = getElementData(source, "Country")

	if not country then return end		
	
	local connection = exports["CCS_database"]:getConnection()

	if not connection then return end	
	
	dbExec(connection, "UPDATE ddc_accounts SET player_country = ? WHERE player_account = ?;", country, account)
	
end
addEvent("onPlayerLoggedIn", true)
addEventHandler("onPlayerLoggedIn", root, Leaderboard.updatePlayerCountry)


function Leaderboard.addRecord(player, time)

	local arenaElement = getElementParent(player)
	local map = getElementData(arenaElement, "map")
	local account = getElementData(player, "account")

	if time == 0 or not map then return end
	
	if getElementData(player, "state") ~= "Alive" and getElementData(player, "state") ~= "Finished" then return end

	outputChatBox("#FF5050You finished at "..exports["CCS"]:export_msToTime(time, true), player, 255, 255, 255, true)

	if not getElementData(arenaElement, "toptimes") then
		return outputChatBox("#FF5050This arena does not have top times enabled", player, 255, 255, 255, true)
	end

	if not account then
		return outputChatBox("#FF5050Guests cannot get top times", player, 255, 255, 255, true)
	end
	
	if getElementData(player, "setting:ban_toptimes") == 1 then
		return outputChatBox("#FF5050You are banned from getting top times", player, 255, 255, 255, true)
	end

	local connection = exports["CCS_database"]:getConnection()

	if not connection then return end
	
	local query = dbPrepareString(connection, Leaderboard.insertQuery, account, time, map.resource, time, time, time)
	dbExec(connection, query)

	local query2 = dbPrepareString(connection, Leaderboard.selectQuery, map.resource, Leaderboard.ROWS_TO_SHOW)
	dbQuery(Leaderboard.callback, {arenaElement, true, true, false}, connection, query2)
	
end


function Leaderboard.callback(handle, arenaElement, sendToPlayers, announce, initial)

	local result = dbPoll(handle, 0)

	if not result then
		return dbFree(handle)
	end

	Leaderboard.isDeleting[arenaElement] = false
	Leaderboard.oldCache[arenaElement] = Leaderboard.cache[arenaElement]
	Leaderboard.cache[arenaElement] = {}
	
	for i, row in ipairs(result) do
		table.insert(Leaderboard.cache[arenaElement], {
			id = row.id,
			account = row.player_account,
			nickname = row.player_name,
			country = row.player_country,
			time = row.time_ms,
			date = row.recorded_at
		})
	end
	
	local needUpdate = Leaderboard.detectChange(arenaElement, announce)	
		
	if initial or needUpdate and sendToPlayers then
	
		for i, player in ipairs(exports["CCS"]:export_getPlayersAndSpectatorsInArena(arenaElement)) do
		
			Leaderboard.request(player)
			
		end

	end
	
end


function Leaderboard.detectChange(arenaElement, announce)
	
	--There can always only be 1 row thats different
	needUpdate = false
	
	local map = getElementData(arenaElement, "map")

	if not map then return end	
	
	--cannot compare without old cache
	if not Leaderboard.oldCache[arenaElement] then return end	
	
	for i = 1, Leaderboard.ROWS_TO_SHOW, 1 do
		
		--if no data, nothing to compare
		if not Leaderboard.oldCache[arenaElement][i] and not Leaderboard.cache[arenaElement][i] then break end
		
		--someone deleted a top time
		if Leaderboard.oldCache[arenaElement][i] and not Leaderboard.cache[arenaElement][i] then
			
			if i == 1 then
				exports["CCS_stats"]:export_reloadAccountData(Leaderboard.oldCache[arenaElement][i].account)
			end
			
			needUpdate = true
			break
		
		--someone got a new top without replacing the old one
		elseif Leaderboard.cache[arenaElement][i] and not Leaderboard.oldCache[arenaElement][i] then
		
			if announce then
			
				if i == 1 then
					exports["CCS"]:export_outputGlobalChat("#FF0000* #FFFFFF"..Leaderboard.cache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").." #ff5050got a new #FFFFFF#"..i.." #ff5050top time on "..map.name)
				else
					exports["CCS"]:export_outputArenaChat(arenaElement, "#FF0000* #FFFFFF"..Leaderboard.cache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").." #ff5050got a new #FFFFFF#"..i.." #ff5050top time")
				end

			end
			
			if i == 1 then
				exports["CCS_stats"]:export_reloadAccountData(Leaderboard.cache[arenaElement][i].account)
			end
			
			needUpdate = true
			break
			
		--someone got a new top time
		elseif Leaderboard.oldCache[arenaElement][i].time ~= Leaderboard.cache[arenaElement][i].time then
		
			if announce then
		
				if i == 1 then
					exports["CCS"]:export_outputGlobalChat("#FF0000* #FFFFFF"..Leaderboard.cache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").." #ff5050replaced #FFFFFF"..Leaderboard.oldCache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").."#ff5050's #FFFFFF#"..i.." #ff5050top time on "..map.name)
				else
					exports["CCS"]:export_outputArenaChat(arenaElement, "#FF0000* #FFFFFF"..Leaderboard.cache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").." #ff5050replaced #FFFFFF"..Leaderboard.oldCache[arenaElement][i].nickname:gsub("#%x%x%x%x%x%x", "").."#ff5050's #FFFFFF#"..i.." #ff5050top time")
				end

			end
				
			if i == 1 then
				exports["CCS_stats"]:export_reloadAccountData(Leaderboard.cache[arenaElement][i].account)
				exports["CCS_stats"]:export_reloadAccountData(Leaderboard.oldCache[arenaElement][i].account)
			end	
				
			needUpdate = true
			break
			
		end
		
	end
	
	return needUpdate

end

function Leaderboard.fetchPersonalBestTime(player)

	if not isElement(player) then return end

	local arenaElement = getElementParent(player)
	local map = getElementData(arenaElement, "map")

	if not map then return end

	local connection = exports["CCS_database"]:getConnection()

	if not connection then return end

	local account = getElementData(player, "account")

	local query = dbPrepareString(connection, Leaderboard.personalBestQuery, map.resource, account)
	dbQuery(Leaderboard.personalBestCallback, {arenaElement, player}, connection, query)
	
end


function Leaderboard.personalBestCallback(handle, arenaElement, player)

	local result = dbPoll(handle, 0)

	if not result then
		return dbFree(handle)
	end
	
	if not isElement(player) then return end
	
	local map = getElementData(arenaElement, "map")
	
	if not map then return end
	
	local personalBest
	
	for i, row in ipairs(result) do
		personalBest = {
			rank = row.rank,
			account = row.player_account,
			nickname = row.player_name,
			country = row.player_country,
			time = row.time_ms,
			date = row.recorded_at
		}
	end
	
	triggerClientEvent(player, "onClientTopTimesUpdate", player, Leaderboard.cache[arenaElement], personalBest)
	
end


function Leaderboard.fetchLeaderboard(map)

	Leaderboard.oldCache[source] = nil
	Leaderboard.cache[source] = nil

	local connection = exports["CCS_database"]:getConnection()

	if not connection then return end
	
	local query = dbPrepareString(connection, Leaderboard.selectQuery, map.resource, Leaderboard.ROWS_TO_SHOW)
	dbQuery(Leaderboard.callback, {source, true, false, true}, connection, query)
	
end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, Leaderboard.fetchLeaderboard)


function Leaderboard.request(player)

	local arenaElement = getElementParent(player)
	
	local map = getElementData(arenaElement, "map")

	if not map then return end
	
	if not Leaderboard.isRaceMap(map.type) then return end

	if not Leaderboard.cache[arenaElement] then return end
	
	local account = getElementData(player, "account")
	
	if account then
	
		Leaderboard.fetchPersonalBestTime(player)
		
	else
		
		triggerClientEvent(player, "onClientTopTimesUpdate", player, Leaderboard.cache[arenaElement], false)
	
	end

end


function Leaderboard.clientRequest()

	if not isElement(source) then return end
	
	Leaderboard.request(source)
	
end
addEvent("onPlayerRequestTopTimes", true)
addEventHandler("onPlayerRequestTopTimes", root, Leaderboard.clientRequest)


function Leaderboard.arenaJoin()
	
	Leaderboard.request(source)
	
end
addEvent("onPlayerJoinArena", true)
addEventHandler("onPlayerJoinArena", root, Leaderboard.arenaJoin)


function Leaderboard.deleteRecord(p, c, indexToRemove)

	local arenaElement = getElementParent(p)
	
	if not Leaderboard.cache[arenaElement] then return end
	
	local map = getElementData(arenaElement, "map")
	
	if not map then return end
	
	indexToRemove = tonumber(indexToRemove)

	if not indexToRemove then return end
	
	if indexToRemove > Leaderboard.ROWS_TO_SHOW or not Leaderboard.cache[arenaElement][indexToRemove] then return end
	
	if not getElementData(arenaElement, "toptimes") then return end
	
	if Leaderboard.isDeleting[arenaElement]  then return end

	local connection = exports["CCS_database"]:getConnection()

	if not connection then return end
	
	Leaderboard.isDeleting[arenaElement] = true
	dbExec(connection, Leaderboard.deleteQuery, Leaderboard.cache[arenaElement][indexToRemove].id)

	local query = dbPrepareString(connection, Leaderboard.selectQuery, map.resource, Leaderboard.ROWS_TO_SHOW)
	dbQuery(Leaderboard.callback, {arenaElement, true, false, false}, connection, query)
	
	exports["CCS"]:export_outputArenaChat(arenaElement, "#FF0000* #FFFFFF"..getPlayerName(p):gsub("#%x%x%x%x%x%x", "").." #ff5050removed top #FFFFFF#"..indexToRemove)

end
addCommandHandler("deletetime", Leaderboard.deleteRecord)


function Leaderboard.deathmatchFinish()

	local arenaElement = getElementParent(source)

	local time = exports["CCS"]:export_getTimePassed(arenaElement)
	Leaderboard.addRecord(source, time)

end
addEvent("onPlayerHunterPickup", true)
addEventHandler("onPlayerHunterPickup", root, Leaderboard.deathmatchFinish)


function Leaderboard.raceFinish()

	local time = exports["CCS"]:export_getTimePassed(getElementParent(source))
	Leaderboard.addRecord(source, time)
	
end
addEvent("onFinishRace", true)
addEventHandler("onFinishRace", root, Leaderboard.raceFinish)


function Leaderboard.isRaceMap(type)

	if not type then return false end

	local allowedTypes = {
		"Oldschool",
		"Classic",
		"Modern",
		"Race",
		"Dynamic",
		"Maptest"
	}

	for _, v in ipairs(allowedTypes) do
		if type == v then return true end
	end

	return false
	
end