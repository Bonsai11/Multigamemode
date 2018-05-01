ACL = {}
ACL.aclLists = {}
ACL.adminLevels = {"11", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"}
ACL.banlist = nil
ACL.commandList = nil

function ACL.playerCommand(command)

	if command == "logout" or command == "login" or command == "register" then 
	
		if not getElementData(source, "account") or not isObjectInACLGroup("user."..getElementData(source, "account"):gsub(" ", ""), aclGetGroup ("11")) then
			
			--FIXME cancelEvent() 
			return
	
		end
		
	end

	if not ACL.check(source, command) then
		
		cancelEvent()
		
	end

end
addEventHandler("onPlayerCommand", root, ACL.playerCommand)


function ACL.main()

	if not fileExists("acl/lists/banlist.xml") then
	
		ACL.banlist = xmlCreateFile("acl/lists/banlist.xml", "bans")
		xmlSaveFile(ACL.banlist)
		xmlUnloadFile(ACL.banlist)
		
	end
	
	ACL.banlist = xmlLoadFile("acl/lists/banlist.xml")
	
	outputServerLog("ACL: Banlist loaded succesfully!")
	
	ACL.commandList = xmlLoadFile("acl/lists/commands.xml")
	
	if ACL.commandList then
	
		outputServerLog("ACL: Command list loaded succesfully!")
	
	else
	
		outputServerLog("ACL: Error loading Command list!")
	
	end
	
end
addEventHandler("onResourceStart", resourceRoot, ACL.main)


function ACL.save()

	for arena, aclList in pairs(ACL.aclLists) do
	
		if not aclList.isTemporary then
	
			xmlSaveFile(aclList.xmlNode)
		
			outputServerLog("ACL: Saved ACL for Arena: "..arena)
			
		else

			ACL.unloadArenaACL(arena)

		end
	
	end

end
addEventHandler("onResourceStop", resourceRoot, ACL.save)


function ACL.loadArenaACL(arenaName)

	local arenaElement = getElementByID(arenaName)

	if not fileExists("acl/arenas/"..arenaName..".xml") then
	
		fileCopy("acl/lists/template.xml", "acl/arenas/"..arenaName..".xml")

		outputServerLog("ACL: Created new ACL for Arena: "..arenaName)

	end
	
	ACL.aclLists[arenaName] = {}
	
	ACL.aclLists[arenaName].xmlNode = xmlLoadFile("acl/arenas/"..arenaName..".xml")
	
	ACL.aclLists[arenaName].isTemporary = getElementData(arenaElement, "temporary")
	
	outputServerLog("ACL: Loaded ACL for Arena: "..arenaName)
	
end
addEvent("onArenaCreate")
addEventHandler("onArenaCreate", root, ACL.loadArenaACL)


function ACL.reloadACL(arenaName)
	
	if not ACL.aclLists[arenaName] then return false end

	xmlUnloadFile(ACL.aclLists[arenaName].xmlNode)
	
	ACL.loadArenaACL(arenaName)

end


function ACL.reloadAllACL()
	
	for arena, aclList in pairs(ACL.aclLists) do
	
		if not aclList.isTemporary then
	
			ACL.reloadACL(arena)

		end

	end

end
addCommandHandler("reloadacls", ACL.reloadAllACL)


function ACL.unloadArenaACL(arenaName)
	
	if not fileExists("acl/arenas/"..arenaName..".xml") then return end

	xmlUnloadFile(ACL.aclLists[arenaName].xmlNode)
		
	ACL.aclLists[arenaName] = nil

	fileDelete("acl/arenas/"..arenaName..".xml")
		
	ACL.clearArenaBans(arenaName)	
		
	outputServerLog("ACL: Unloaded ACL for Arena: "..arenaName)

end


function ACL.getAdminList()

	local adminList = {}

	for arena, aclList in pairs(ACL.aclLists) do
	
		if not aclList.isTemporary then
	
			adminList[arena] = {}
	
			for i, m in ipairs(xmlNodeGetChildren(aclList.xmlNode)) do
	
				if xmlNodeGetName(m) == "group" then
					
					for i, n in ipairs(xmlNodeGetChildren(m)) do
					
						if xmlNodeGetName(n) == "object" then
	
							table.insert(adminList[arena], {group = xmlNodeGetAttribute(m, "name"), account = xmlNodeGetAttribute(n, "name")})
							
						end
			
					end
					
				end
			
			end

		end

	end

	local list = toJSON(adminList)
	
	outputConsole(list)
	
end
--addCommandHandler("get", ACL.getAdminList)


function ACL.getArenaAdminList(arena)

	local adminList = {}

	if not ACL.aclLists[arena] then return end

	local arenaACL = ACL.aclLists[arena].xmlNode
	
	if not arenaACL then return false end
	
	for i, m in ipairs(xmlNodeGetChildren(arenaACL)) do

		if xmlNodeGetName(m) == "group" then
			
			for i, n in ipairs(xmlNodeGetChildren(m)) do
			
				if xmlNodeGetName(n) == "object" then

					table.insert(adminList, {group = xmlNodeGetAttribute(m, "name"), name = xmlNodeGetAttribute(n, "name")})
					
				end
	
			end
			
		end
	
	end

	return adminList
	
end
export_getArenaAdminList = ACL.getArenaAdminList


function ACL.clearArenaBans(arenaName)

	if not ACL.banlist then return end

	for i, m in ipairs(xmlNodeGetChildren(ACL.banlist)) do

		if xmlNodeGetAttribute(m, "arena") == arenaName then
		
			xmlDestroyNode(m)
			
		end
		
	end
	
	xmlSaveFile(ACL.banlist)

	outputServerLog("ACL: Arena Bans cleared for Arena: "..arenaName)
	
end


function ACL.check(player, command)
	
	local arena = getElementData(player, "Arena")
	
	local arenaElement = getElementParent(player)
	
	local isPrivate = getElementData(arenaElement, "temporary")
	
	local commandGroup = ACL.getCommandACLGroup(command, isPrivate)

	if not commandGroup then return false end
	
	if type(commandGroup) ~= "table" then return true end
	
	local playerName = getCleanPlayerName(player)
	
	local account = getElementData(player, "account")
	
	if not account then return false end
	
	if isObjectInACLGroup ( "user." .. account:gsub(" ", ""), aclGetGroup("11")) and not isGuestAccount(getPlayerAccount(player)) then
	
		return true
		
	end
	
	local playerGroups = ACL.getPlayerACLGroup(account, arena)
	
	if not playerGroups or #playerGroups == 0 then
	
		outputServerLog("ACL: "..arena..": Account: "..account.." not found in ACL!" )
		return false
		
	end
	
	for i, group in pairs(playerGroups) do
		
		for j, includedGroup in pairs(group.includes) do
		
			if includedGroup == commandGroup[1] and commandGroup[2] == "true" then
				
				outputServerLog("ACL: "..arena..": Command: "..getCleanPlayerName(player).." - "..command)
				return true
				
			end
		
		end
	
	end
	
	outputServerLog("ACL: Access denied: Player: "..playerName.." Command: "..command)

	return false

end
export_acl_check = ACL.check


function ACL.getPlayerACLGroup(account, arena)

	if not ACL.aclLists[arena] then return false end

	local arenaACL = ACL.aclLists[arena].xmlNode
	
	if not arenaACL then return false end
	
	local playerGroups = {}
	
	for i, m in ipairs(xmlNodeGetChildren(arenaACL)) do
	
		if xmlNodeGetName(m) == "group" then
			
			local includedGroups = {}
			
			for i, n in ipairs(xmlNodeGetChildren(m)) do
			
				if xmlNodeGetName(n) == "acl" then
					
					table.insert(includedGroups, xmlNodeGetAttribute(n, "name"))
					
				end
			
				if xmlNodeGetName(n) == "object" then
					
					if xmlNodeGetAttribute(n, "name") == account then
						
						table.insert(playerGroups, {group = xmlNodeGetAttribute(m, "name"), includes = includedGroups})
						
					end
					
				end
	
			end
			
		end
	
	end
	
	return playerGroups

end


function ACL.getCommandACLGroup(command, isPrivate)

	if not ACL.commandList then return false end
	
	for i, m in ipairs(xmlNodeGetChildren(ACL.commandList)) do
	
		if xmlNodeGetName(m) == "acl" then
			
			for i, n in ipairs(xmlNodeGetChildren(m)) do
	
				if xmlNodeGetName(n) == "right" then
					
					if xmlNodeGetAttribute(n, "name") == "command."..command then
							
						local group = xmlNodeGetAttribute(m, "name")
						
						local access
						
						if isPrivate then
						
							access = xmlNodeGetAttribute(n, "private")
							
						else

							access = xmlNodeGetAttribute(n, "normal")

						end

						return {group, access}

					end
					
				end
			
			end
			
		end
	
	end
	
	return true

end


function ACL.addPlayer(account, arena, level)

	if not ACL.aclLists[arena] then return end

	local arenaACL = ACL.aclLists[arena].xmlNode
	
	if not arenaACL then return false end
	
	ACL.removePlayer(account, arena)
	
	for i, m in ipairs(xmlNodeGetChildren(arenaACL)) do
	
		if xmlNodeGetName(m) == "group" then
			
			if xmlNodeGetAttribute(m, "name") == level then
				
				local object = xmlCreateChild(m, "object")
				xmlNodeSetAttribute(object, "name", account)
				
				outputServerLog("ACL: Added Account '"..account.."' as Level "..level.." to Arena "..arena)
				
				break
				
			end
			
		end
		
	end
	
	xmlSaveFile(arenaACL)

end
export_acladdPlayer = ACL.addPlayer


function ACL.removePlayer(account, arena)

	if not ACL.aclLists[arena] then return end

	local arenaACL = ACL.aclLists[arena].xmlNode
	
	if not arenaACL then return false end
	
	for i, m in ipairs(xmlNodeGetChildren(arenaACL)) do
	
		if xmlNodeGetName(m) == "group" then
			
			local level = xmlNodeGetAttribute(m, "name")
			
			for i, node in ipairs(xmlNodeGetChildren(m)  ) do
			
				if xmlNodeGetAttribute(node, "name") == account then
				
					xmlDestroyNode(node)
					
					outputServerLog("ACL: Removed Level "..level.." of Account '"..account.."' from Arena "..arena)
					
				end
				
			end
			
		end
		
	end
	
	xmlSaveFile(arenaACL)

end
export_aclremovePlayer = ACL.removePlayer


function ACL.getAdminList(p, c, t)

	local arena = getElementData(p, "Arena")
	
	local toElement = getElementParent(p)
	
	local adminsOnline = false

	local adminList = {}

	local playerName = getPlayerName(p):gsub('#%x%x%x%x%x%x', '')
	
	for i, level in pairs(ACL.adminLevels) do
	
		adminList[level] = {}
		
		for i, player in pairs(getPlayersInArena(toElement)) do
	
			if getElementData(player, "account") then
		
				local playerGroups = ACL.getPlayerACLGroup(getElementData(player, "account"), arena)

				if playerGroups and #playerGroups ~= 0 and playerGroups[1].group == level or (aclGetGroup(level) and (isObjectInACLGroup("user."..getElementData(player, "account"):gsub(" ", ""), aclGetGroup(level))) and not isGuestAccount(getPlayerAccount(player))) then
				
					table.insert(adminList[level], getPlayerName(player))

				end
				
			end
			
		end
		
	end	

	exports["CCS"]:export_outputArenaChat(toElement, "#ffff00<"..playerName.." is checking online admins>")
	
	for i=11, 1, -1 do
		
		local levelList = adminList[tostring(i)]
		
		local outputString = ""
		local seperator = ""
		
		if levelList then
		
			if #levelList ~= 0 then

				outputString = "Level "..i..": "
				
			end	
		
			for i, adminName in pairs(levelList) do
				
				outputString = outputString..seperator..adminName:gsub('#%x%x%x%x%x%x', '')
				
				seperator = ", "
				
			end
	
		end
	
		if #outputString ~= 0 then
		
			outputChatBox(outputString, p, 255, 0, 128)
			adminsOnline = true
			
		end	
	
	end
		
	if not adminsOnline then
	
		outputChatBox("No online admins!", p, 255, 0, 128)

	end	
		
end
addCommandHandler("admins", ACL.getAdminList)


function ACL.addAdmin(p, c, t, level)

	local arenaElement = getElementParent(p)
	
	local arena = getElementID(arenaElement)

	local player = findArenaPlayer(arenaElement, t)
	
	if not player then return end
	
	if player == p then return end

	local account = getElementData(player, "account")
	
	if not account then
	
		outputChatBox("Player is not logged in!" , p, 255 , 0, 128, true)
		return
	
	end
	
	if level == "0" then
	
		ACL.removePlayer(account, arena)
		exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." removed "..getCleanPlayerName(player).." from admins!")
		return
		
	end
	
	if not table.contains(ACL.adminLevels, level) then 
	
		outputChatBox("No such Level available!" , p, 255 , 0, 128, true)
		return 
		
	end
	
	if level == "A" or level == "9" or level == "10" or level == "11" then 
	
		outputChatBox("You cannot set levels higher than 8!" , p, 255 , 0, 128, true)
		return
	
	end	
	
	ACL.addPlayer(account, arena, level)

	exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." added "..getCleanPlayerName(player).." as an admin! (Level: "..level..")")

end
addCommandHandler("setlevel", ACL.addAdmin)


function ACL.addArenaBan(player, arena)

	if not ACL.banlist then return end

	local ban = xmlCreateChild(ACL.banlist, "ban")
	xmlNodeSetAttribute(ban, "name", getCleanPlayerName(player))
	xmlNodeSetAttribute(ban, "serial", getPlayerSerial(player))
	xmlNodeSetAttribute(ban, "arena", arena)
	xmlSaveFile(ACL.banlist)

end


function ACL.removeArenaBan(name, arena)

	if not ACL.banlist then return end

	for i, m in ipairs(xmlNodeGetChildren(ACL.banlist)) do

		if xmlNodeGetAttribute(m, "name") == name and xmlNodeGetAttribute(m, "arena") == arena then
		
			xmlDestroyNode(m)
			xmlSaveFile(ACL.banlist)

			return true
			
		end
		
	end
	
	xmlSaveFile(ACL.banlist)

	return false

end
export_removeArenaBan = ACL.removeArenaBan


function ACL.checkBan(serial, arena)

	if not ACL.banlist then return false end
	
	for i, m in ipairs(xmlNodeGetChildren(ACL.banlist)) do

		if xmlNodeGetAttribute(m, "serial") == serial and xmlNodeGetAttribute(m, "arena") == arena then
		
			return true
			
		end
		
	end
	
	return false

end


function ACL.getArenaBans(arena)

	local bans = {}
	
	if not ACL.banlist then return false end
	
	for i, m in ipairs(xmlNodeGetChildren(ACL.banlist)) do

		if xmlNodeGetAttribute(m, "arena") == arena then
		
			table.insert(bans, {name = xmlNodeGetAttribute(m, "name"), serial = xmlNodeGetAttribute(m, "serial")})
			
		end
		
	end
	
	return bans

end
export_getArenaBans = ACL.getArenaBans


function ACL.reloadBans()

	if not fileExists("acl/lists/banlist.xml") then
	
		ACL.banlist = xmlCreateFile("acl/lists/banlist.xml", "bans")
		xmlSaveFile(ACL.banlist)
		xmlUnloadFile(ACL.banlist)
		
	end
	
	xmlUnloadFile(ACL.banlist)
	
	ACL.banlist = xmlLoadFile("acl/lists/banlist.xml")
	
	outputServerLog("ACL: Banlist reloaded succesfully!")

end
addCommandHandler("reloadbanlist", ACL.reloadBans)


function ACL.reloadCommandList()

	if not fileExists("acl/lists/commands.xml") then
	
		outputServerLog("ACL: No command list found!")
		return
		
	end
	
	xmlUnloadFile(ACL.commandList)
	
	ACL.commandList = xmlLoadFile("acl/lists/commands.xml")
	
	outputServerLog("ACL: Command list reloaded succesfully!")

end
addCommandHandler("reloadcommandlist", ACL.reloadCommandList)


function ACL.addServerAdmin(p, c, account)
	
	if not account then return end
	
	local group = aclGetGroup("11")

	if not group then return end

	if aclGroupAddObject(group, "user."..account) then
	
		outputServerLog("ACL: Added account "..account.." as server admin!")

	else
	
		outputServerLog("Error: Failed to add account!")

	end
		
end
addCommandHandler("addserveradmin", ACL.addServerAdmin)


function ACL.register(p, c, username, password)

	if not username or not password then return end

	if getAccount(username) then
	
		outputChatBox("Error: Account already exists!", p, 255, 0, 128)
		return
		
	end
	
	if addAccount(username, password) then
	
		outputChatBox("Successfully registered! Use /login to login!", p, 255, 0, 128)
		
	else
	
		outputChatBox("Error: Failed to register!", p, 255, 0, 128)
	
	end
		
end
addCommandHandler("register", ACL.register)