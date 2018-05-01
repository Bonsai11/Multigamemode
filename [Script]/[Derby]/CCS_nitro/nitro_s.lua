function updateNitroLevel(type, model)

	if type == "nitro" then
	
		triggerClientEvent(source, "updateClientNitro", root)
		
	end
	
end
addEvent("onPlayerDerbyPickupHit")
addEventHandler("onPlayerDerbyPickupHit", root, updateNitroLevel)