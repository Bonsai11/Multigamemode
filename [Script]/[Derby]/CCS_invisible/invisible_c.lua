Invisible = {}
Invisible.toggled = false
Invisible.objectList = {}
Invisible.key = "i"

function Invisible.toggle()
	if Invisible.toggled == true then
		Invisible.disable()
	else
		Invisible.enable()
	end
end

function Invisible.enable() 
	Invisible.objectList = {}
	
	for k, v in pairs(getElementsByType("object")) do
		if getElementAlpha(v) == 0 then
			Invisible.objectList[#Invisible.objectList + 1] = {v, "alpha"}
			setElementAlpha(v, 255)
		elseif getObjectScale(v) == 0 then
			Invisible.objectList[#Invisible.objectList + 1] = {v, "scale"}
			setObjectScale(v, 1)
		end
	end

	Invisible.toggled = true
	outputChatBox("#FF0000* #FFFFFFInvisible objects are now shown", 255, 255, 255, true)
end

function Invisible.disable()
	for k, v in pairs(Invisible.objectList) do
		if v[2] == "alpha" then
			setElementAlpha(v[1], 0)
		else
			setObjectScale(v[1], 0)
		end
	end

	Invisible.toggled = false
	Invisible.objectList = {}
	outputChatBox("#FF0000* #FFFFFFInvisible objects are now hidden", 255, 100, 100, true)
end

function Invisible.main()
	bindKey(Invisible.key, "down", Invisible.toggle)

	if Invisible.toggled == false then return end

	Invisible.enable()
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Invisible.main)

function Invisible.leave()
	Invisible.toggled = false
end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, Invisible.leave)

function Invisible.reset()
	Invisible.objectList = {}

	unbindKey(Invisible.key,"down", Invisible.toggle)
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Invisible.reset)