Ghost = {}

function Ghost.changeSetting(state)

	exports["CCS_stats"]:export_changePlayerSettings(source, {ghost_driver = state})
	
end
addEvent("onGhostDriverSettingChange", true)
addEventHandler("onGhostDriverSettingChange", root, Ghost.changeSetting)