Chat = {}
Chat.globalEnabled = true
Chat.replyInputActive = false
bindKey("g", "down", "chatbox", "Global")
bindKey("c", "down", "chatbox", "Clan")
bindKey("l", "down", "chatbox", "Language")
bindKey("x", "down", "chatbox", "Group")
bindKey("r", "down", "chatbox", "Reply")

function Chat.trackReplyStart()

	if isChatBoxInputActive() then 
	
		local player = getElementData(localPlayer, "chat:reply")
		Chat.replyInputActive = true 
		addEventHandler("onClientKey", root, Chat.trackReplyFinish)

		if player and isElement(player) then
		
			outputChatBox("Your message will be send to: "..getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), 255, 0, 128)
			
		end
		
	end 
	
end
bindKey("r", "up", Chat.trackReplyStart)


function Chat.trackReplyFinish(button, action)

	if button ~= "escape" and button ~= "enter" and button ~= "num_enter" then return end
	
	if not action then return end
	
	Chat.replyInputActive = false
	removeEventHandler("onClientKey", root, Chat.trackReplyFinish)
	
end


function Chat.global(text)

	if string.match(text, string.gsub("[GLOBAL]", "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")) then
		cancelEvent()
	end
	
end


function Chat.hideGlobal()

	if Chat.globalEnabled then
		outputChatBox("#FF0000** #FFFFFFYou disabled the Global chat", 255, 255, 255, true)
		addEventHandler("onClientChatMessage", root, Chat.global)
		Chat.globalEnabled = false
	else
		outputChatBox("#00FF00** #FFFFFFYou enabled the Global chat", 255, 255, 255, true)
		removeEventHandler("onClientChatMessage", root, Chat.global)
		Chat.globalEnabled = true
	end
	
end
addCommandHandler("hideglobal", Chat.hideGlobal)


function Chat.privateMessage(message)

	if Chat.replyInputActive then return end

	setElementData(localPlayer, "chat:reply", source)
	
end
addEvent("onClientPrivateMessage", true)
addEventHandler("onClientPrivateMessage", root, Chat.privateMessage)

