Reaction = {}

function Reaction.main(state)
	
	if state then
		
		addEventHandler("onClientRender", root, Reaction.cheatCheck)
		
	else
	
		removeEventHandler("onClientRender", root, Reaction.cheatCheck)
	
	end

end
addEvent("onReactionTest", true)
addEventHandler("onReactionTest", root, Reaction.main)


function Reaction.cheatCheck()

	if isConsoleActive() then
	
		setElementData(localPlayer, "reactionTestForbidden", true)
		
	else
	
		setElementData(localPlayer, "reactionTestForbidden", false)
	
	end

end
