Reaction = {}
Reaction.interval = 180000
Reaction.cancelTime = 60000
Reaction.lowerCaseLetters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'x', 'y', 'z'}
Reaction.upperCaseLetters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z'}
Reaction.numbers = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
Reaction.lists = {Reaction.lowerCaseLetters, Reaction.upperCaseLetters, Reaction.numbers}
Reaction.timer = nil
Reaction.cancelTimer = nil
Reaction.currentTest = nil
Reaction.currentPrize = nil

function Reaction.main()

	outputServerLog("Reaction Test: Starting!")
	addEvent("onPlayerGlobalChatMessage")
	
	Reaction.createTimer()
	
end
addEventHandler("onResourceStart", resourceRoot, Reaction.main)


function Reaction.createTimer()

	local extraTime = math.random(60000)
	
	Reaction.timer = setTimer(Reaction.createTest, Reaction.interval+extraTime, 1)
	
	outputServerLog("Reaction Test: Creating Timer: "..((Reaction.interval+extraTime)/1000).." seconds")
	
end


function Reaction.cancelTest()

	outputServerLog("Reaction Test: Cancelled!")
	
	if isTimer(Reaction.cancelTimer) then killTimer(Reaction.cancelTimer) end
	if isTimer(Reaction.timer) then killTimer(Reaction.timer) end
	removeEventHandler("onPlayerGlobalChatMessage", root, Reaction.check)
	removeEventHandler("onPlayerChat", root, Reaction.check)
	
	triggerClientEvent(root, "onReactionTest", root, false)
	
	local message = "#ffff00"..utf8.char(9733).." #81BEF7REACTION TEST #ffff00"..utf8.char(9733).."#81BEF7 Nobody passed the test! "
	
	exports["CCS"]:export_outputGlobalChat(message)	
	
	Reaction.createTimer()	

end


function Reaction.createTest()

	if #getElementsByType("player") < 2 then
	
		Reaction.createTimer()
		
		local message = "#ffff00"..utf8.char(9733).." #81BEF7REACTION TEST #ffff00"..utf8.char(9733).."#81BEF7 Not enough players!"
	
		exports["CCS"]:export_outputGlobalChat(message)	
		
		return
		
	end

	outputServerLog("Reaction Test: Showing Test!")
	
	local difficulty = math.random(100)
	local maxLength, minLength
	Reaction.currentTest = ""
	Reaction.currentPrize = 0
	local stars = ""

	if difficulty > 85 then
	
		maxLength = 10
		minLength = 8
		maxLists = 3
		stars = "#ffff00"..utf8.char(9733)..utf8.char(9733)..utf8.char(9733)
		Reaction.currentPrize = math.random(20000, 25000)
		
	elseif difficulty > 60 then

		maxLength = 8
		minLength = 6
		maxLists = 3
		stars = "#ffff00"..utf8.char(9733)..utf8.char(9733)
		Reaction.currentPrize = math.random(15000, 20000)
		
	else
	
		maxLength = 6
		minLength = 4
		maxLists = 2
		stars = "#ffff00"..utf8.char(9733)
		Reaction.currentPrize = math.random(10000, 15000)
		
	end
	
	local length = math.random(minLength, maxLength)

	for i=1, length, 1 do
	
		local randomList = math.random(maxLists)
		
		local randomChar = Reaction.lists[randomList][math.random(#Reaction.lists[randomList])]

		Reaction.currentTest = Reaction.currentTest..randomChar
	
	end

	local message = stars.." #81BEF7REACTION TEST"..stars.."#81BEF7 First who types #FA5858"..Reaction.currentTest.."#81BEF7 wins #FA5858$"..Reaction.currentPrize.."#81BEF7!"
	
	exports["CCS"]:export_outputGlobalChat(message)
	
	addEventHandler("onPlayerGlobalChatMessage", root, Reaction.check)
	addEventHandler("onPlayerChat", root, Reaction.check)
	
	triggerClientEvent(root, "onReactionTest", root, true)
	
	Reaction.cancelTimer = setTimer(Reaction.cancelTest, Reaction.cancelTime, 1)
	
end


function Reaction.check(message)
	
	if not string.find(message, Reaction.currentTest) then return end
	
	if not getElementData(source, "reactionTestForbidden") then
	
		local message = "#81BEF7"..utf8.char(9873)..utf8.char(9873).." #FA5858"..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").."#81BEF7 wins #FA5858$"..Reaction.currentPrize.."#81BEF7 for fast reaction! "..utf8.char(9873)..utf8.char(9873)
	
		exports["CCS"]:export_outputGlobalChat(message)
		
		exports["CCS_stats"]:export_addPlayerMoney(source, Reaction.currentPrize)
		
		if isTimer(Reaction.cancelTimer) then killTimer(Reaction.cancelTimer) end
		if isTimer(Reaction.timer) then killTimer(Reaction.timer) end
		removeEventHandler("onPlayerGlobalChatMessage", root, Reaction.check)
		removeEventHandler("onPlayerChat", root, Reaction.check)
		
		triggerClientEvent(root, "onReactionTest", root, false)
		
		Reaction.createTimer()
		
		outputServerLog("Reaction Test: Winner: "..getPlayerName(source))
		
	else
	
		outputChatBox("You cannot participate in Reaction Test by Console!", source, 255, 0, 128, true)
	
	end
	
end
