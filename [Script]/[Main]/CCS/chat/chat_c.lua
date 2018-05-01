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
	
		Chat.replyInputActive = true 
		
		addEventHandler("onClientKey", root, Chat.trackReplyFinish)
		
		local player = getElementData(localPlayer, "chat:reply")

		if player and isElement(player) then
		
			outputChatBox("Your message will be send to: "..getPlayerName(player):gsub('#%x%x%x%x%x%x', ''), 255, 0, 128)
		
		end
		
	end 

end
bindKey("r", "up", Chat.trackReplyStart)


function Chat.trackReplyFinish(button, pressOrRelease)

	if button ~= "escape" and button ~= "enter" and button ~= "num_enter" then return end

	if not pressOrRelease then return end
	
	Chat.replyInputActive = false
	
	removeEventHandler("onClientKey", root, Chat.trackReplyFinish)
	
end


function Chat.global(text)

	if string.match(text, string.gsub("[Global]", "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")) then
	
		cancelEvent()
		
	end
	
end


function Chat.hideGlobal()

	if Chat.globalEnabled then
	
		outputChatBox("You disabled the Global Chat!", 255, 0, 0)
		
		addEventHandler("onClientChatMessage", root, Chat.global)
		
		Chat.globalEnabled = false
		
	else
	
		outputChatBox("You enabled the Global Chat!", 0, 240, 0)
		
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

