Chat = {}
Chat.languages = {"Arabic", "Brazilian", "Chinese", "Croatian", "Czech", "Dutch", "English", "Estonian", "French", "German", 
				  "Hungarian", "Italien", "Japanese", "Latvian", "Lithuanian", "Norwegian", "Polish", "Romanian", "Russian",
				  "Slovak", "Slovenian", "Spanish", "Swedish", "Turkish", "Bulgarian"}

Chat.emotis = {"( ͡o ͜ʖ ͡o)", "( ͡~ ͜ʖ ͡o)", "(っ＾◡＾)っ#ff0000♥#ffffff", "(っ＾◡＾)っ#2E9AFE♥#ffffff", "( ͡; ͜ʖ ͡;)", "¯\\_(ツ)_/¯", "ಠ_ಠ", "(ง ͠° ͟ل͜ ͡°)ง", "（╯°□°）╯︵( .o.)",
			    "༼ つ ◕_◕ ༽つ", "(͡ ͡° ͜ つ ͡͡°)", "(ノಠ益ಠ)ノ彡┻━┻", "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧", "(☞ﾟ∀ﾟ)☞", "(ᵔᴥᵔ)", "ಠ╭╮ಠ", "\\ (•◡•) /", "ᕙ(⇀‸↼‶)ᕗ", "(ง°ل͜°)ง",
				"∩༼˵☯‿☯˵༽つ¤=[]:::::>", "°͜ʖ°?", "(͡o ◡ ͡o )╭∩╮", "┌( ͝° ͜ʖ͡°)=ε/̵͇̿̿/’̿’̿ ̿", "(っ＾◡＾)っ#FA58F4♥#ffffff", "(っ＾◡＾)っ#00FF00♥#ffffff", "(っ＾◡＾)っ#FFBF00♥#ffffff",
				"(っ＾◡＾)っ#2EFEF7♥#ffffff", "(っ＾◡＾)っ#ffffff♥#ffffff", "(｡✿‿✿｡)", "(｡◕‿◕｡)", "( ́ ◕◞ε◟◕`)", "┏(＾0＾)┛┗(＾0＾)┓", "(づ｡◕‿‿◕｡)づ", "(✿◠‿◠)", "ᕦ(ò_óˇ)ᕤ", "٩◔‿◔۶", 
				"( ͡°_ʖ ͡°)", "(ง ͠° ͟ʖ #)ง", "╭∩╮( ͡° ͟ʖ ͡° )╭∩╮", "(◕︵◕)", "( ͡e ͜ʖ ͡e)╭∩╮ᶠᶸᶜᵏᵧₒᵤ", "¿°͜ʖ°?", "(✖╭╮✖)", "シ", "(っ◠‿ ◠)っ ❤"}

Chat.emotis[69] = "♋"	
				
function Chat.global(player, command, ...)

	if not isElement(player) then return end

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	if getElementData(player, "gmute") then
	
		outputChatBox("Sorry, You are muted!", player, 255, 0, 128, true)
		return
	
	end
	
	local playerName = getPlayerName(player)

	cancelEvent()
	
	local chat_color = getElementData(player, "setting:chat_color") or "#ffffff"
	
	local message = Chat.parseEmotis(message)
	
	outputChatBox("#ffaa00[Global] #ffffff"..getPlayerName(player).."#ffffff: "..chat_color..message, root, 255, 255, 255, true)
	
	triggerEvent("onServerChatMessage", root, "#ffaa00[Global] #ffffff"..getPlayerName(player).."#ffffff: "..chat_color..message)
	
	triggerEvent("onPlayerGlobalChatMessage", player, message)
	
end
addCommandHandler("Global", Chat.global)


function Chat.clan(player, command, ...)

	if not isElement(player) then return end

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	local playerName = getPlayerName(player)

	cancelEvent()
	
	if not getElementData(player, "clan") then return end
	
	local chat_color = getElementData(player, "setting:chat_color") or "#ffffff"
	
	local message = Chat.parseEmotis(message)	
	
	for i, p in pairs(getElementsByType("player")) do
	
		if getElementData(player, "clan") == getElementData(p, "clan") then
	
			outputChatBox("#00ffaa[Clan] #ffffff"..playerName.."#ffffff: "..chat_color..message, p, 255, 255, 255, true)
	
		end
	
	end
	
	triggerEvent("onServerChatMessage", root, "#00ffaa[Clan] #ffffff"..playerName.."#ffffff: "..chat_color..message)
	
end
addCommandHandler("Clan", Chat.clan)


function Chat.language(player, command, ...)

	if not isElement(player) then return end

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	if getElementData(player, "lmute") then
	
		outputChatBox("Sorry, You are muted!", player, 255, 0, 128, true)
		return
	
	end
	
	local playerName = getPlayerName(player)

	cancelEvent()
	
	if not getElementData(player, "Language") then return end
	
	local chat_color = getElementData(player, "setting:chat_color") or "#ffffff"
	
	local message = Chat.parseEmotis(message)	
	
	for i, p in pairs(getElementsByType("player")) do
		
		if getElementData(player, "Language") == getElementData(p, "Language") then
			
			outputChatBox("#aaff00["..getElementData(player, "Language").."] #ffffff"..playerName.."#ffffff: "..chat_color..message, p, 255, 255, 255, true)
	
		end
	
	end
	
	triggerEvent("onServerChatMessage", root, "#aaff00["..getElementData(player, "Language").."] #ffffff"..playerName.."#ffffff: "..chat_color..message)
	
end
addCommandHandler("Language", Chat.language)


function Chat.group(player, command, ...)

	if not isElement(player) then return end

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end

	local playerName = getPlayerName(player)

	cancelEvent()
	
	if not getElementData(player, "chat:group") then return end
	
	local chat_color = getElementData(player, "setting:chat_color") or "#ffffff"
	
	local message = Chat.parseEmotis(message)	
	
	for i, p in pairs(getElementsByType("player")) do
		
		if getElementData(player, "chat:group") == getElementData(p, "chat:group") then
			
			outputChatBox("#ff00ff[Group] #ffffff"..playerName.."#ffffff: "..chat_color..message, p, 255, 255, 255, true)
	
		end
	
	end
	
	triggerEvent("onServerChatMessage", root, "#ff00ff[Group] #ffffff"..playerName.."#ffffff: "..chat_color..message)
	
end
addCommandHandler("Group", Chat.group)


function Chat.redirect(message, messageType)
	
	cancelEvent()
	
	if not isElement(source) then return end
	
	local arenaElement = getElementParent(source)

	if not arenaElement or getElementType(arenaElement) ~= "Arena" then return end
		
	local chat_color = getElementData(source, "setting:chat_color") or "#ffffff"
	
	message = Chat.parseEmotis(message)	
	
	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(source, "Spectator") then
		
		Chat.outputSpectatorChat(arenaElement, getPlayerName(source).."#ffffff: "..chat_color..message)
	
		return
	
	end
	
	if messageType == 0 then

		triggerEvent("onPlayerArenaChat", source, message, messageType)

		if wasEventCancelled() then return end

		if getElementData(arenaElement, "silence") and not exports["CCS"]:export_acl_check(source, "silence") then
	
			outputChatBox("Sorry, Silence mode is active!", source, 255, 0, 128)
			return
		
		end
	
		Chat.outputArenaChat(arenaElement, getPlayerName(source).."#ffffff: "..chat_color..message)

	elseif messageType == 1 then
	
		triggerEvent("onPlayerArenaChat", source, message, messageType)
	
		if wasEventCancelled() then return end
	
		if getElementData(arenaElement, "silence") and not exports["CCS"]:export_acl_check(source, "silence") then
	
			outputChatBox("Sorry, Silence mode is active!", source, 255, 0, 128)
			return
		
		end
	
		Chat.outputArenaChat(arenaElement, "#ff00ff* "..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." "..message:gsub("#%x%x%x%x%x%x", ""))

	elseif messageType == 2 then

		local team = getPlayerTeam(source)
	
		if not team then return end
	
		for i, p in pairs(getPlayersInTeam(team)) do
		
			outputChatBox("#00f000[Team] #ffffff"..getPlayerName(source).."#ffffff: "..chat_color..message, p, 255, 255, 255, true)
		
		end	
		
		triggerEvent("onServerChatMessage", root, "#00f000[Team] #ffffff"..getPlayerName(source).."#ffffff: "..chat_color..message)
	
	end

end
addEventHandler("onPlayerChat", root, Chat.redirect)


function Chat.outputLanguageChat(language, message)

	if not message then return end
	
	for i, p in pairs(getElementsByType("player")) do
		
		if getElementData(p, "Language") == language then
			
			outputChatBox("#aaff00["..language.."] #ffffff"..message, p, 255, 255, 255, true)
	
		end
	
	end
	
	triggerEvent("onServerChatMessage", root, "#aaff00["..language.."]#ffffff "..message)

end


function Chat.outputClanChat(clan, message)

	if not message then return end
	
	for i, p in pairs(getElementsByType("player")) do
		
		if getElementData(p, "Clan") == clan then
			
			outputChatBox("#00ffaa[Clan] #ffffff"..message, p, 255, 255, 255, true)
	
		end
	
	end
	
	triggerEvent("onServerChatMessage", root, "#00ffaa[Clan] #ffffff"..message)

end


function Chat.outputGroupChat(group, message)

	if not message then return end
	
	for i, p in pairs(getElementsByType("player")) do
		
		if getElementData(p, "chat:group") == group then
			
			outputChatBox("#ff00ff[Group] #ffffff"..message, p, 255, 255, 255, true)
	
		end
	
	end	

	triggerEvent("onServerChatMessage", root, "#ff00ff[Group]#ffffff "..message)
	
end


function Chat.outputGlobalChat(message)

	if not message then return end
	
	outputChatBox("#ffaa00[Global] #ffffff"..message, root, 255, 255, 255, true)

	triggerEvent("onServerChatMessage", root, "#ffaa00[Global] #ffffff"..message)

end
export_outputGlobalChat = Chat.outputGlobalChat


function Chat.outputSpectatorChat(element, message)

	if not isElement(element) then return end

	if not message then return end
	
	for i, p in pairs(getSpectatorsInArena(element)) do

		outputChatBox("#999999[Spectator] #ffffff"..message, p, 255, 255, 255, true)

	end
	
	triggerEvent("onServerChatMessage", root, "#999999[Spectator] "..message)

end


function Chat.outputArenaChat(element, message)

	if not isElement(element) then return end

	if not message then return end
	
	local arenaName
	
	--If in Training, output to all people in a Training arena
	if getElementData(element, "creator") == "Training" then
	
		arenaName = "Training"
	
		for i, p in pairs(getElementsByType("Arena")) do
	
			if getElementData(p, "creator") == "Training" then
				
				outputChatBox(message, p, 255, 255, 255, true)
		
			end
		
		end
	
	else
	
		arenaName = getElementID(element)
		
		outputChatBox(message, element, 255, 255, 255, true)
		
	end	

	triggerEvent("onServerChatMessage", root, "["..arenaName.."] "..message)

end
export_outputArenaChat = Chat.outputArenaChat


function Chat.join(p, c, lang)

	if not lang then 
	
		outputChatBox("Synatx is: /join <Language>", p, 255, 0, 128, true)
		return 
		
	end
	
	local theLanguage = false
	
	for i, language in pairs(Chat.languages) do
	
		if language:lower() == lang:lower() then
		
			theLanguage = language
			break
			
		end

	end

	if not theLanguage then 
	
		outputChatBox("Language not found!", p, 255, 0, 128, true)
		return 
		
	end
	
	local playerName = getPlayerName(p)
	
	if getElementData(p, "Language") then
	
		Chat.outputLanguageChat(getElementData(p, "Language"), playerName.." #ff0000 left the Chat!")
		
	end
	
	setElementData(p, "Language", theLanguage)
	
	Chat.outputLanguageChat(getElementData(p, "Language"), playerName.."#00ff00 joined the Chat!")
	
end
addCommandHandler("join", Chat.join)


function Chat.leave(p, c)

	local playerName = getPlayerName(p)
	
	if getElementData(p, "Language") then
	
		Chat.outputLanguageChat(getElementData(p, "Language"), playerName.."#ff0000 left the Chat!")
		
	end
	
	setElementData(p, "Language", false)

end
addCommandHandler("leave", Chat.leave)


function Chat.personalMessage(p, c, name, ...)

	if not isElement(p) then return end

	if not name then
	
		outputChatBox("Usage: /pm <namepart> <message>", p, 255, 0, 128)
		return
		
	end

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	local message = Chat.parseEmotis(message)
	
	local player = findPlayerAll(name)
	
	if not player then 
	
		outputChatBox("Error: Player not found!", p, 255, 0, 128)
		return 
	
	end
	
	if getElementData(player, "setting:no_personalmessages") == 1 then
	
		outputChatBox("Error: This player disabled all personal messages!", p, 255, 0, 128)
		return
	
	end
	
	local myName = getPlayerName(p):gsub('#%x%x%x%x%x%x', '')
	
	local hisName = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')

	outputChatBox("[PM] TO "..hisName..": "..message:gsub('#%x%x%x%x%x%x', ''), p, 255, 0, 128)

	outputChatBox("[PM] FROM "..myName..": "..message:gsub('#%x%x%x%x%x%x', ''), player, 255, 0, 128)
	
	triggerClientEvent(player, "onClientPrivateMessage", p, message)

	triggerEvent("onServerChatMessage", root, myName.." > "..hisName..": "..message:gsub('#%x%x%x%x%x%x', ''))
	
end
addCommandHandler("pm", Chat.personalMessage)


function Chat.reply(p, c, ...)

	local player = getElementData(p, "chat:reply")

	if not player then return end

	if not isElement(player) then return end
	
	Chat.personalMessage(p, c, getPlayerName(player):gsub('#%x%x%x%x%x%x', ''), ...)

end
addCommandHandler("Reply", Chat.reply)


function Chat.create(p, c)

	if getElementData(p, "chat:group") then 
	
		outputChatBox("Error: You are already in a group!", p, 255, 0, 128)
		return 
	
	end

	setElementData(p, "chat:group", getTickCount())

	outputChatBox("You successfully created a group!", p, 0, 255, 0)
	
end
addCommandHandler("create", Chat.create)


function Chat.invite(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(p, "chat:group") then 
	
		outputChatBox("Error: You are not in a group!", p, 255, 0, 128)
		return 
	
	end

	if player then 
	
		player = findPlayerAll(player)
		
	end
	
	if not player then return end
	
	if getElementData(player, "chat:group") then 
	
		outputChatBox("Error: Player is already in a group!", p, 255, 0, 128)
		return 
	
	end
	
	local myName = getPlayerName(p)
	
	local hisName = getPlayerName(player)
	
	setElementData(player, "chat:group", getElementData(p, "chat:group"))

	Chat.outputGroupChat(getElementData(p, "chat:group"), myName.."#00ff00 invited #ffffff"..hisName.." #00ff00to the Chat!")
	
end
addCommandHandler("invite", Chat.invite)


function Chat.leavegroup(p, c)

	if not getElementData(p, "chat:group") then 
	
		outputChatBox("Error: You are not in a group!", p, 255, 0, 128)
		return 
	
	end

	local playerName = getPlayerName(p)
	
	Chat.outputGroupChat(getElementData(p, "chat:group"), playerName.."#ff0000 left the Chat!")
	
	setElementData(p, "chat:group", nil)
	
end
addCommandHandler("leavegroup", Chat.leavegroup)


function Chat.remove(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(p, "chat:group") then 
	
		outputChatBox("Error: You are not in a group!", p, 255, 0, 128)
		return 
	
	end

	if player then 
	
		player = findPlayerAll(player)
		
	end
	
	if not player then return end
	
	local myName = getPlayerName(p)
	
	local hisName = getPlayerName(player)

	if not getElementData(player, "chat:group") then 
	
		outputChatBox("Error: Player is not in a group!", p, 255, 0, 128)
		return 
	
	end
	
	if getElementData(p, "chat:group") ~= getElementData(player, "chat:group") then 
	
		outputChatBox("Error: Player is not in your group!", p, 255, 0, 128)
		return 
	
	end
	
	setElementData(player, "chat:group", nil)

	Chat.outputGroupChat(getElementData(p, "chat:group"), myName.."#ff0000 removed #ffffff"..hisName.." #ff0000from the Chat!")
	
	
end
addCommandHandler("remove", Chat.remove)


function Chat.playerQuit()

	local playerName = getPlayerName(source)

	if getElementData(source, "chat:group") then 

		Chat.outputGroupChat(getElementData(source, "chat:group"), playerName.."#ff0000 left the Chat! [Quit]")
	
	end
	
	if getElementData(source, "Clan") then
	
		Chat.outputClanChat(getElementData(source, "Clan"), playerName.."#ff0000 left the Chat! [Quit]")
		
	end
	
end
addEventHandler("onPlayerQuit", root, Chat.playerQuit)


function Chat.pms(p, c)
	
	if getElementData(p, "setting:no_personalmessages") == 1 then
	
		exports["CCS_stats"]:export_changePlayerSettings(p, {no_personalmessages = 0})
		
		outputChatBox("You will receive personal messages!", p, 255, 0, 128)

	else

		exports["CCS_stats"]:export_changePlayerSettings(p, {no_personalmessages = 1})
		
		outputChatBox("You will receive no personal messages anymore!", p, 255, 0, 128)
		
	end	
		
end
addCommandHandler("pms", Chat.pms)


function Chat.parseEmotis(msg)

	if not msg:match(':%d+:', 1, true) then
	
		return msg
		
	end

	for i, emote in pairs(Chat.emotis) do
	
		while msg:find(":"..i..":", 1, true) do

			msg = msg:gsub(":"..i..":", emote)
		
		end
		
	end
	
	return msg

end


function Chat.getLanguages()

	return Chat.languages
	
end
export_getLanguages = Chat.getLanguages


function Chat.emojis(p)

	local emojiCount = 0

	for i, emoji in pairs(Chat.emotis) do
	
		emojiCount = emojiCount + 1
	
	end

	outputChatBox(emojiCount.. " emojis found! Check Console for a list!", p, 255, 0, 128, true)

	for i, emoji in pairs(Chat.emotis) do
	
		outputConsole(tostring(i..": "..emoji), p)
	
	end

end
addCommandHandler("emojis", Chat.emojis)