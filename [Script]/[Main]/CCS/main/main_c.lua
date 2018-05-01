Main = {}

function Main.start()

	--MTA Race Pickup Models
	engineImportTXD(engineLoadTXD("models/nitro.txd"), 2221)
	engineReplaceModel(engineLoadDFF("models/nitro.dff", 2221), 2221)
	engineSetModelLODDistance( 2221, 60 )
	
	engineImportTXD(engineLoadTXD("models/repair.txd"), 2222)
	engineReplaceModel(engineLoadDFF("models/repair.dff", 2222), 2222)
	engineSetModelLODDistance( 2222, 60 )
	
	engineImportTXD( engineLoadTXD("models/vehiclechange.txd"), 2223)
	engineReplaceModel(engineLoadDFF("models/vehiclechange.dff", 2223), 2223)
	engineSetModelLODDistance( 2223, 60 )
	
	--Linez
	engineImportTXD( engineLoadTXD("models/thick.txd"), 2224)
	engineReplaceModel(engineLoadDFF("models/thick.dff", 2224), 2224)
	engineSetModelLODDistance( 2224, 60 )
	
	engineImportTXD( engineLoadTXD("models/shield.txd"), 2225)
	engineReplaceModel(engineLoadDFF("models/shield.dff", 2225), 2225)
	engineSetModelLODDistance( 2225, 60 )
	
	engineImportTXD( engineLoadTXD("models/tires.txd"), 2226)
	engineReplaceModel(engineLoadDFF("models/tires.dff", 2226), 2226)
	engineSetModelLODDistance( 2226, 60 )	
	
	--General
	setAmbientSoundEnabled("general", false)
	setWorldSoundEnabled(25, false)
	setBlurLevel(0)
	setHeatHaze (0)
	setRadioChannel(0)
	setCameraClip(true, false)
	setCloudsEnabled(false)
	setMinuteDuration(60000)
	setElementData(localPlayer, "Language", gettok(getLocalization()["name"], 1, " "))
	showPlayerHudComponent("all", false)
	showPlayerHudComponent("crosshair", true)
	fadeCamera(true)
	setTime(9,0)
	setWeather(3)
	setSkyGradient(60, 100, 196, 60, 100, 196)
	setCloudsEnabled(false)
	showChat(false)
	
	setTimer(Main.updateTime, 60000, 0)
	Main.updateTime()
	
	triggerEvent("onShowLogin", localPlayer)

end
addEventHandler("onClientResourceStart", resourceRoot, Main.start)


function Main.updateTime()

	local time = getRealTime()
	setElementData(localPlayer, "time", string.format("%02d:%02d", time.hour, time.minute))

end


function Main.hidegui()

	showChat(not isChatVisible())
	executeCommandHandler("showradar")
	executeCommandHandler("showspeedo")
	executeCommandHandler("showrankingboard")
	executeCommandHandler("showdurationwindow")
	executeCommandHandler("showtopkills")
	executeCommandHandler("showtoptimes")
	executeCommandHandler("showannouncement")
	executeCommandHandler("shownotifications")
	executeCommandHandler("showmessages")
	
end
addCommandHandler("hidegui", Main.hidegui)