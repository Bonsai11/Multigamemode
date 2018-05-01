local TopTimes = {}
TopTimes.cache = {}
TopTimes.oldCache = {}
TopTimes.deleteLock = {}

function TopTimes.triggerHunterPickup(type, model)

	if type ~= "vehiclechange" then return end

	if not getPedOccupiedVehicle(source) then return end

	if model == 425 then

		local element = getElementParent(source)
		local timepassed = exports["CCS"]:export_getTimePassed(element)
		TopTimes.add(source, timepassed)

	end

end
addEvent("onPlayerDerbyPickupHit", true)
addEventHandler("onPlayerDerbyPickupHit", root, TopTimes.triggerHunterPickup)


function TopTimes.triggerRaceWin()

	local element = getElementParent(source)
	local timepassed = exports["CCS"]:export_getTimePassed(element)
	TopTimes.add(source, timepassed)

end
addEvent("onFinishRace", true)
addEventHandler("onFinishRace", root, TopTimes.triggerRaceWin)


function TopTimes.add(player, data)

	if data == 0 then return end

	local arenaElement = getElementParent(player)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	outputChatBox("#ff5050Your time: #ffffff"..exports["CCS"]:export_msToTime(data, true).."#ff5050!", player, 255, 0, 128, true)

	if not getElementData(arenaElement, "toptimes") then

		outputChatBox("This Arena does not have top times enabled!", player, 255, 255, 0)

		return

	end

	if getElementData(player, "state") ~= "Alive" and getElementData(player, "state") ~= "Finished" then return end

	if not getElementData(player, "account") then

		outputChatBox("Guests cannot get top times!", player, 255, 0, 128, true)

		return

	end
	
	if getElementData(player, "setting:ban_toptimes") == 1 then

		outputChatBox("You are banned from getting toptimes!", player, 255, 0, 128, true)

		return

	end

	local arena = getElementID(arenaElement)

	local dbTable = "toptimes-"..map.resource

	while #dbTable > 64 do

		dbTable = dbTable:sub(1, #dbTable-1)

	end

	local playerSerial = getPlayerSerial(player)

	local dataText = exports["CCS"]:export_msToTime(data, true)

	if not dataText then return end

	TopTimes.connection = exports["CCS_database"]:getConnection()

	if not TopTimes.connection then return end

	--Update this players toptime if neccessary
	dbExec(TopTimes.connection, "INSERT INTO `"..dbTable.."` (player_account, timeMS, timeText, dateRecorded, arena) VALUES (?, ?, ?, NOW(), ?) ON DUPLICATE KEY UPDATE "
							  .."timeText = IF(timeMS > ?, ?, timeText), dateRecorded =  IF(timeMS > ?, NOW(), dateRecorded), "
							  .."arena =  IF(timeMS > ?, ?, arena), timeMS = IF(timeMS > ?, ?, timeMS);",
							  getElementData(player, "account"), data, dataText, arena, data, dataText, data, data, arena, data, data)

	dbQuery(TopTimes.timesCallback, {arenaElement, true, getElementData(player, "account")}, TopTimes.connection, "SELECT a.id, a.player_account, b.player_name, a.timeMS, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS LIMIT 10;")

end


function TopTimes.timesCallback(handle, arenaElement, needUpdate, account)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then

		outputDebugString("No result!")
		dbFree(handle)
		return

	end

	TopTimes.deleteLock[arenaElement] = false

	TopTimes.oldCache[arenaElement] = TopTimes.cache[arenaElement]
	
	TopTimes.cache[arenaElement] = {}

	for i, topTime in ipairs(result) do
	
		table.insert(TopTimes.cache[arenaElement], {i, topTime.id, topTime.player_account, topTime.player_name, topTime.timeMS, topTime.dateRecorded, topTime.arena})
		
	end

	if not needUpdate then return end

	TopTimes.connection = exports["CCS_database"]:getConnection()

	local map = getElementData(arenaElement, "map")

	if not map then return end

	--Check if anything in top 10 changed
	for i = 1, 10, 1 do

		--At least one of them need to exist
		if TopTimes.oldCache[arenaElement][i] or result[i] then

			--Some Top was deleted
			if TopTimes.oldCache[arenaElement][i] and not result[i] then

				triggerClientEvent(arenaElement, "onClientPlayerTopTime", arenaElement)

				if i == 1 then
					
					dbExec(TopTimes.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes - 1 WHERE player_account = ?;", TopTimes.oldCache[arenaElement][i][3])

					exports["CCS_stats"]:export_reloadAccountData(TopTimes.oldCache[arenaElement][i][3])

				end

			--Someone get a new top without replacing an old
			elseif result[i] and not TopTimes.oldCache[arenaElement][i] then

				if account and result[i].player_account == account then

					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top time!")

					if i == 1 then

						exports["CCS"]:export_outputGlobalChat("#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top time on #ffffff"..map.name.."#ff5050!")

					end

				end

				triggerClientEvent(arenaElement, "onClientPlayerTopTime", arenaElement)

				if i == 1 then
					
					dbExec(TopTimes.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes + 1 WHERE player_account = ?;", result[i].player_account)

					exports["CCS_stats"]:export_reloadAccountData(result[i].player_account)

				end

			--Someone replace a top time
			elseif TopTimes.oldCache[arenaElement][i][5] ~= result[i].timeMS then

				if account and result[i].player_account == account then

					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top time!")

					if i == 1 then

						exports["CCS"]:export_outputGlobalChat("#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top time on #ffffff"..map.name.."#ff5050!")

					end

				end

				triggerClientEvent(arenaElement, "onClientPlayerTopTime", arenaElement)

				if i == 1 then
					
					dbExec(TopTimes.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes - 1 WHERE player_account = ?;", TopTimes.oldCache[arenaElement][i][3])

					exports["CCS_stats"]:export_reloadAccountData(TopTimes.oldCache[arenaElement][i][3])
					
					dbExec(TopTimes.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes + 1 WHERE player_account = ?;", result[i].player_account)

					exports["CCS_stats"]:export_reloadAccountData(result[i].player_account)

				end

			end

		end

	end

end


function TopTimes.newMap(map)

	TopTimes.oldCache[source] = nil

	TopTimes.cache[source] = nil

	TopTimes.connection = exports["CCS_database"]:getConnection()

	if not TopTimes.connection then return end

	if map.type == "Shooter" or map.type == "Cross" or map.type == "Linez" then return end
	
	local dbTable = "toptimes-"..map.resource

	while #dbTable > 64 do

		dbTable = dbTable:sub(1, #dbTable-1)

	end
	
	if getElementData(source, "toptimes") then
	
		dbExec(TopTimes.connection, "CREATE TABLE IF NOT EXISTS `"..dbTable.."` (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, player_account VARCHAR(255) NOT NULL, timeMS BIGINT NOT NULL, timeText VARCHAR(255) NOT NULL, dateRecorded DATETIME NOT NULL, arena VARCHAR(255) NOT NULL, UNIQUE(player_account)) ENGINE = MYISAM;")

	end	
		
	dbQuery(TopTimes.timesCallback, {source, false}, TopTimes.connection, "SELECT a.id, a.player_account, b.player_name, a.timeMS, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS LIMIT 10;")

end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, TopTimes.newMap)


function TopTimes.request()

	local arenaElement = getElementParent(source)

	--if not getElementData(arenaElement, "toptimes") then return end
	
	if not TopTimes.cache[arenaElement] then return end

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local requestTopTimes = {}

	for i, topTime in ipairs(TopTimes.cache[arenaElement]) do

		table.insert(requestTopTimes, {topTime[1], topTime[4], exports["CCS"]:export_msToTime(topTime[5], true), topTime[6], topTime[7]})

	end

	triggerClientEvent(source, "onClientTopTimesUpdate", arenaElement, requestTopTimes, map.name)

end
addEvent("onPlayerRequestTopTimes", true)
addEventHandler("onPlayerRequestTopTimes", root, TopTimes.request)


function TopTimes.remove(player, c, index)

	local arenaElement = getElementParent(player)

	if not getElementData(arenaElement, "toptimes") then return end

	if not index then return end

	if TopTimes.deleteLock[arenaElement] then return end

	TopTimes.deleteLock[arenaElement] = true

	local map = getElementData(arenaElement, "map")

	if not map then return end

	index = tonumber(index)

	TopTimes.connection = exports["CCS_database"]:getConnection()

	if not TopTimes.connection then return end

	local dbTable = "toptimes-"..map.resource

	if not TopTimes.cache[arenaElement][index] then return end

	dbExec(TopTimes.connection, "DELETE FROM `"..dbTable.."` WHERE id=?", TopTimes.cache[arenaElement][index][2])

	dbQuery(TopTimes.timesCallback, {arenaElement, true}, TopTimes.connection, "SELECT a.id, a.player_account, b.player_name, a.timeMS, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS LIMIT 10;")

	exports["CCS"]:export_outputArenaChat(arenaElement, "#ff5050Top Times: #ffffff"..getPlayerName(player):gsub('#%x%x%x%x%x%x', '').." #ff5050removed Top Time #ffffff#"..index.."#ff5050!")

end
addCommandHandler("deletetime", TopTimes.remove)
