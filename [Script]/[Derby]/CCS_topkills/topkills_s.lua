local TopKills = {}
TopKills.cache = {}
TopKills.oldCache = {}
TopKills.deleteLock = {}

function TopKills.triggerKills(kills)

	local element = getElementParent(source)
	TopKills.add(source, kills, false)

end
addEvent("onShooterKills", true)
addEvent("onDerbyKills", true)
addEventHandler("onShooterKills", root, TopKills.triggerKills)
addEventHandler("onDerbyKills", root, TopKills.triggerKills)


function TopKills.add(player, data)

	if data == 0 then return end

	local arenaElement = getElementParent(player)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	if not getElementData(arenaElement, "topkills") then

			outputChatBox("This Arena does not have top kills enabled!", player, 255, 255, 0)

		return

	end

	if not getElementData(player, "account") then

			outputChatBox("Guests cannot get top kills!", player, 255, 0, 128, true)

		return

	end

	local arena = getElementID(arenaElement)

	local dbTable = "toptimes-"..map.resource

	while #dbTable > 64 do

		dbTable = dbTable:sub(1, #dbTable-1)

	end

	local playerSerial = getPlayerSerial(player)

	local dataText = data

	if not dataText then return end

	TopKills.connection = exports["CCS_database"]:getConnection()

	if not TopKills.connection then return end

	--Update this players toptime if neccessary
	dbExec(TopKills.connection, "INSERT INTO `"..dbTable.."` (player_account, timeMS, timeText, dateRecorded, arena) VALUES (?, ?, ?, NOW(), ?) ON DUPLICATE KEY UPDATE "
							  .."timeText = IF(timeMS < ?, ?, timeText), dateRecorded =  IF(timeMS < ?, NOW(), dateRecorded), "
							  .."arena =  IF(timeMS < ?, ?, arena), timeMS = IF(timeMS < ?, ?, timeMS);",
							  getElementData(player, "account"), data, dataText, arena, data, dataText, data, data, arena, data, data)

	dbQuery(TopKills.timesCallback, {arenaElement, true, getElementData(player, "account")}, TopKills.connection, "SELECT a.id, a.player_account, b.player_name, a.timeText, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS DESC LIMIT 10;")

end


function TopKills.timesCallback(handle, arenaElement, needUpdate, account)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then

		outputDebugString("No result!")
		dbFree(handle)
		return

	end

	TopKills.deleteLock[arenaElement] = false

	TopKills.oldCache[arenaElement] = TopKills.cache[arenaElement]
	
	TopKills.cache[arenaElement] = {}

	for i, topTime in ipairs(result) do

		table.insert(TopKills.cache[arenaElement], {i, topTime.id, topTime.player_account, topTime.player_name, topTime.timeText, topTime.dateRecorded, topTime.arena})

	end

	if not needUpdate then return end

	TopKills.connection = exports["CCS_database"]:getConnection()

	local map = getElementData(arenaElement, "map")

	if not map then return end

	--Check if anything in top 10 changed
	for i = 1, 10, 1 do

		--At least one of them need to exist
		if TopKills.oldCache[arenaElement][i] or result[i] then

			--Some Top was deleted
			if TopKills.oldCache[arenaElement][i] and not result[i] then

				triggerClientEvent(arenaElement, "onClientPlayerTopKill", arenaElement)

				if i == 1 then

					dbExec(TopKills.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes - 1 WHERE player_account = ?;", TopKills.oldCache[arenaElement][i][3])

					exports["CCS_stats"]:export_reloadAccountData(TopKills.oldCache[arenaElement][i][3])

				end

			--Someone get a new top without replacing an old
			elseif result[i] and not TopKills.oldCache[arenaElement][i] then

				if account and result[i].player_account == account then

					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top kill!")

				end

				triggerClientEvent(arenaElement, "onClientPlayerTopKill", arenaElement)

				if i == 1 then

					dbExec(TopKills.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes + 1 WHERE player_account = ?;", result[i].player_account)

					exports["CCS_stats"]:export_reloadAccountData(result[i].player_account)

				end

			--Someone replace a top time
			elseif TopKills.oldCache[arenaElement][i][5] ~= result[i].timeText then

				if account and result[i].player_account == account then

					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffffff"..result[i].player_name:gsub('#%x%x%x%x%x%x', '').." #ff5050got a new #ffffff#"..i.." #ff5050top kill!")

				end

				triggerClientEvent(arenaElement, "onClientPlayerTopKill", arenaElement)

				if i == 1 then

					dbExec(TopKills.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes - 1 WHERE player_account = ?;", TopKills.oldCache[arenaElement][i][3])

					exports["CCS_stats"]:export_reloadAccountData(TopKills.oldCache[arenaElement][i][3])

					dbExec(TopKills.connection, "UPDATE ddc_accounts SET player_toptimes = player_toptimes + 1 WHERE player_account = ?;", result[i].player_account)

					exports["CCS_stats"]:export_reloadAccountData(result[i].player_account)

				end

			end

		end

	end

end


function TopKills.newMap(map)

	TopKills.oldCache[source] = nil

	TopKills.cache[source] = nil

	TopKills.connection = exports["CCS_database"]:getConnection()

	if not TopKills.connection then return end

	if map.type ~= "Shooter" and map.type ~= "Cross" and map.type ~= "Linez" then return end
	
	local dbTable = "toptimes-"..map.resource

	while #dbTable > 64 do

		dbTable = dbTable:sub(1, #dbTable-1)

	end
	
	if getElementData(source, "topkills") then

		dbExec(TopKills.connection, "CREATE TABLE IF NOT EXISTS `"..dbTable.."` (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, player_account VARCHAR(255) NOT NULL, timeMS BIGINT NOT NULL, timeText VARCHAR(255) NOT NULL, dateRecorded DATETIME NOT NULL, arena VARCHAR(255) NOT NULL, UNIQUE(player_account)) ENGINE = MYISAM;")

	end
		
	dbQuery(TopKills.timesCallback, {source, false}, TopKills.connection, "SELECT a.id, a.player_account, b.player_name, a.timeText, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS DESC LIMIT 10;")

end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, TopKills.newMap)


function TopKills.request()

	local arenaElement = getElementParent(source)
	
	--if not getElementData(arenaElement, "topkills") then return end
	
	if not TopKills.cache[arenaElement] then return end

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local requestTopTimes = {}

	for i, topTime in ipairs(TopKills.cache[arenaElement]) do

		table.insert(requestTopTimes, {topTime[1], topTime[4], topTime[5], topTime[6], topTime[7]})

	end

	triggerClientEvent(source, "onClientTopKillsUpdate", arenaElement, requestTopTimes, map.name)

end
addEvent("onPlayerRequestTopKills", true)
addEventHandler("onPlayerRequestTopKills", root, TopKills.request)


function TopKills.remove(player, c, index)

	local arenaElement = getElementParent(player)

	if not getElementData(arenaElement, "topkills") then return end

	if not index then return end

	if TopKills.deleteLock[arenaElement] then return end

	TopKills.deleteLock[arenaElement] = true

	local map = getElementData(arenaElement, "map")

	if not map then return end

	index = tonumber(index)

	TopKills.connection = exports["CCS_database"]:getConnection()

	if not TopKills.connection then return end

	local dbTable = "toptimes-"..map.resource

	if not TopKills.cache[arenaElement][index] then return end

	dbExec(TopKills.connection, "DELETE FROM `"..dbTable.."` WHERE id=?", TopKills.cache[arenaElement][index][2])

	dbQuery(TopKills.timesCallback, {arenaElement, true}, TopKills.connection, "SELECT a.id, a.player_account, b.player_name, a.timeText, a.dateRecorded, a.arena FROM `"..dbTable.."` a, ddc_accounts b WHERE a.player_account = b.player_account ORDER BY timeMS DESC LIMIT 10;")

	exports["CCS"]:export_outputArenaChat(arenaElement, "#ff5050Top Kills: #ffffff"..getPlayerName(player):gsub('#%x%x%x%x%x%x', '').." #ff5050removed Top Kill #ffffff#"..index.."#ff5050!")

end
addCommandHandler("deletekill", TopKills.remove)
