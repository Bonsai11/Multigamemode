FPS = {}

function FPS.main()

	setElementData(localPlayer,"fps", 0)
	FPS.starttick = getTickCount()
	FPS.counter = 0

end
addEventHandler("onClientResourceStart", root, FPS.main)

function FPS.render()

	FPS.counter = FPS.counter + 1
	
	if getTickCount() - FPS.starttick >= 1000 then
	
		setElementData(localPlayer, "fps", FPS.counter)
		FPS.counter = 0
		FPS.starttick = getTickCount()
		
	end

end
addEventHandler("onClientRender", root, FPS.render)

