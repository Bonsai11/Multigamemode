VoteManager = {}
VoteManager.x, VoteManager.y = guiGetScreenSize()
VoteManager.relX, VoteManager.relY = (VoteManager.x/800), (VoteManager.y/600)
VoteManager.pool = {}
VoteManager.myVote = 0
VoteManager.posX = 160 * VoteManager.relY
VoteManager.posY = 250 * VoteManager.relY
VoteManager.origWidth = 160
VoteManager.width = 200
VoteManager.height = 200 * VoteManager.relY
VoteManager.font = "default-bold"
VoteManager.fontSize = 1
VoteManager.title = "Choose next map:"
VoteManager.offset = 3 * VoteManager.relY
VoteManager.fontColor = tocolor(255, 255, 255, 255)
VoteManager.fontColorSelected = tocolor(0, 255, 0, 255)
VoteManager.fontHeight = dxGetFontHeight(VoteManager.fontSize, VoteManager.font) * 1
VoteManager.backgroundColor = tocolor(0, 0, 0, 100)

function VoteManager.start(pollData)

	VoteManager.destroy()

	for i, option in pairs(pollData.mapList) do 
	
		table.insert(VoteManager.pool, {name = option.name, votes = 0, arrows = ""})
	
	end

	VoteManager.voteTimeLeft = math.floor(pollData.voteTime/1000)
	VoteManager.currentTick = getTickCount()
	addEventHandler("onClientKey", root, VoteManager.vote)
	addEventHandler("onClientRender", root, VoteManager.render)
	
end
addEvent("onClientVoteStart", true)
addEventHandler("onClientVoteStart", root, VoteManager.start)


function VoteManager.render()

	local title = VoteManager.dxClipTextToWidth(" "..VoteManager.title, VoteManager.width)
	dxDrawRectangle(VoteManager.posX, VoteManager.posY, VoteManager.width, ((VoteManager.fontHeight + VoteManager.offset) * (#VoteManager.pool+1.5)), VoteManager.backgroundColor)
	dxDrawText(title.." ("..VoteManager.voteTimeLeft..")", VoteManager.posX+1, VoteManager.posY+1, VoteManager.posX+VoteManager.width+1, VoteManager.posY+VoteManager.fontHeight+1, tocolor(0,0,0,255), VoteManager.fontSize, VoteManager.font)
	dxDrawText(title.." ("..VoteManager.voteTimeLeft..")", VoteManager.posX, VoteManager.posY, VoteManager.posX+VoteManager.width, VoteManager.posY+VoteManager.fontHeight, VoteManager.fontColor, VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)

	for i, map in ipairs(VoteManager.pool) do 
	
		local posY = VoteManager.posY + ((VoteManager.fontHeight + VoteManager.offset) * (i + 0.5))

		--Text Shadow
		local mapName = VoteManager.dxClipTextToWidth(" "..i..".  "..map.name, VoteManager.width)
		dxDrawText(mapName, VoteManager.posX+1, posY + 1, VoteManager.posX+VoteManager.width+1, posY + VoteManager.fontHeight+1, tocolor(0, 0, 0, 255), VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)
		dxDrawText(" "..map.arrows, VoteManager.posX+VoteManager.width+1, posY+1, VoteManager.x+1, posY + VoteManager.fontHeight+1, tocolor(0, 0, 0, 255), VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)

		if i == VoteManager.myVote then
	
			dxDrawText(mapName, VoteManager.posX, posY, VoteManager.posX+VoteManager.width, posY + VoteManager.fontHeight, VoteManager.fontColorSelected, VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)
			dxDrawText(" "..map.arrows, VoteManager.posX+VoteManager.width, posY, VoteManager.x, posY + VoteManager.fontHeight, VoteManager.fontColorSelected, VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)

		else
		
			dxDrawText(mapName, VoteManager.posX, posY, VoteManager.posX+VoteManager.width, posY + VoteManager.fontHeight, VoteManager.fontColor, VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)
			dxDrawText(" "..map.arrows, VoteManager.posX+VoteManager.width, posY, VoteManager.x, posY + VoteManager.fontHeight, VoteManager.fontColor, VoteManager.fontSize, VoteManager.font, "left", "center", false, false, false, true)

		end
		
	end

	if getTickCount() - VoteManager.currentTick > 1000 then
	
		VoteManager.voteTimeLeft = VoteManager.voteTimeLeft - 1
		VoteManager.currentTick = getTickCount()
	
	end
	
	if VoteManager.voteTimeLeft < 0 then
	
		VoteManager.voteTimeLeft = 0
		
	end

end


function VoteManager.vote(button, pressOrRelease)

	if not pressOrRelease or isChatBoxInputActive() then return end

	if getElementData(localPlayer, "Spectator") then return end
	
	if button == "backspace" then
	
		if VoteManager.myVote ~= 0 then
			
			VoteManager.send(VoteManager.myVote, false)
			
		end
		
		return
		
	end	
	
	if string.find(button, "num_") then 
	
		button = string.gsub(button, "num_", "")
	
	end

	local vote = tonumber(button)
	
	if not vote or vote <= 0 or vote > #VoteManager.pool then return end
	
	if vote == VoteManager.myVote then 
	
		return 
	
	else
	
		if VoteManager.myVote ~= 0 then
			
			--delete old vote
			VoteManager.send(VoteManager.myVote, false)
			
		end
	
	end
	
	--send new vote
	VoteManager.send(vote, true)

end


function VoteManager.send(vote, setOrRemove)
	
	triggerServerEvent("onReceiveVote", localPlayer, vote, setOrRemove)
	
	if setOrRemove then
		
		VoteManager.myVote = vote
		
	else
	
		VoteManager.myVote = 0
	
	end
	
end


function VoteManager.update(voteList)
	
	--Vote already ended, update comes too late
	if #VoteManager.pool == 0 then return end
	
	for i, votes in ipairs(voteList) do 
	
		local arrows = ""
		
		for i=1, votes, 1 do
		
			arrows = arrows.."✔"
		
		end
	
		VoteManager.pool[i].votes = votes
		VoteManager.pool[i].arrows = arrows
	
	end

end
addEvent("onClientVoteUodate", true)
addEventHandler("onClientVoteUodate", root, VoteManager.update)


function VoteManager.destroy()

	removeEventHandler("onClientRender", root, VoteManager.render)
	removeEventHandler("onClientKey", root, VoteManager.vote)
	VoteManager.myVote = 0
	VoteManager.pool = {}

end
addEvent("onClientVoteEnd", true)
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, VoteManager.destroy)
addEventHandler("onClientVoteEnd", root, VoteManager.destroy)


function VoteManager.dxClipTextToWidth(text, width)

	while dxGetTextWidth(" "..text, VoteManager.fontSize, VoteManager.font, true) > width do
	
		text = text:sub(1, #text-1)
	
	end
	
	return text

end