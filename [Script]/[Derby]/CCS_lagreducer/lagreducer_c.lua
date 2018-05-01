DecoHider = {}
DecoHider.objectList = {}
DecoHider.toggled = false
DecoHider.originalWeather = 0
DecoHider.originalTime = {0, 0}
DecoHider.originalSky = {0, 0, 0, 0, 0, 0}
DecoHider.messageShown = false
DecoHider.state = 0

local ids = {}
ids[7916] = true
ids[9831] = true
ids[615] = true
ids[616] = true
ids[617] = true
ids[618] = true
ids[619] = true
ids[620] = true
ids[621] = true
ids[622] = true
ids[623] = true
ids[624] = true
ids[629] = true
ids[634] = true
ids[641] = true
ids[645] = true
ids[648] = true
ids[649] = true
ids[652] = true
ids[654] = true
ids[655] = true
ids[656] = true
ids[657] = true
ids[658] = true
ids[659] = true
ids[660] = true
ids[661] = true
ids[664] = true
ids[669] = true
ids[670] = true
ids[671] = true
ids[672] = true
ids[673] = true
ids[674] = true
ids[676] = true
ids[680] = true
ids[681] = true
ids[683] = true
ids[685] = true
ids[686] = true
ids[687] = true
ids[688] = true
ids[689] = true
ids[690] = true
ids[691] = true
ids[692] = true
ids[696] = true
ids[694] = true
ids[695] = true
ids[697] = true
ids[693] = true
ids[698] = true
ids[700] = true
ids[703] = true
ids[704] = true
ids[705] = true
ids[706] = true
ids[707] = true
ids[708] = true
ids[709] = true
ids[711] = true
ids[714] = true
ids[716] = true
ids[717] = true
ids[718] = true
ids[719] = true
ids[710] = true
ids[712] = true
ids[713] = true
ids[715] = true
ids[720] = true
ids[721] = true
ids[722] = true
ids[723] = true
ids[724] = true
ids[725] = true
ids[726] = true
ids[727] = true
ids[728] = true
ids[729] = true
ids[730] = true
ids[731] = true
ids[732] = true
ids[733] = true
ids[734] = true
ids[735] = true
ids[736] = true
ids[737] = true
ids[738] = true
ids[739] = true
ids[740] = true
ids[765] = true
ids[766] = true
ids[767] = true
ids[768] = true
ids[769] = true
ids[764] = true
ids[770] = true
ids[771] = true
ids[772] = true
ids[773] = true
ids[774] = true
ids[775] = true
ids[776] = true
ids[777] = true
ids[778] = true
ids[779] = true
ids[780] = true
ids[781] = true
ids[782] = true
ids[789] = true
ids[790] = true
ids[791] = true
ids[792] = true
ids[883] = true
ids[884] = true
ids[885] = true
ids[886] = true
ids[887] = true
ids[888] = true
ids[889] = true
ids[890] = true
ids[891] = true
ids[892] = true
ids[893] = true
ids[894] = true
ids[895] = true
ids[904] = true
ids[3505] = true
ids[3506] = true
ids[3507] = true
ids[3508] = true
ids[3509] = true
ids[3510] = true
ids[3511] = true
ids[3512] = true
ids[3517] = true
ids[18272] = true
ids[18273] = true
ids[16061] = true
ids[18270] = true
ids[18268] = true
ids[18271] = true
ids[18269] = true
ids[625] = true
ids[626] = true
ids[627] = true
ids[628] = true
ids[630] = true
ids[631] = true
ids[632] = true
ids[633] = true
ids[644] = true
ids[646] = true
ids[728] = true
ids[753] = true
ids[754] = true
ids[755] = true
ids[756] = true
ids[757] = true
ids[759] = true
ids[760] = true
ids[761] = true
ids[762] = true
ids[802] = true
ids[809] = true
ids[801] = true
ids[804] = true
ids[810] = true
ids[813] = true
ids[811] = true
ids[812] = true
ids[805] = true
ids[803] = true
ids[814] = true
ids[815] = true
ids[818] = true
ids[806] = true
ids[808] = true
ids[817] = true
ids[819] = true
ids[820] = true
ids[855] = true
ids[822] = true
ids[821] = true
ids[825] = true
ids[824] = true
ids[823] = true
ids[857] = true
ids[859] = true
ids[860] = true
ids[827] = true
ids[856] = true
ids[861] = true
ids[862] = true
ids[863] = true
ids[864] = true
ids[865] = true
ids[866] = true
ids[871] = true
ids[877] = true
ids[878] = true
ids[872] = true
ids[875] = true
ids[876] = true
ids[878] = true
ids[3409] = true
ids[3450] = true
ids[3520] = true
ids[3532] = true
ids[4173] = true
ids[4174] = true
ids[4993] = true
ids[5150] = true
ids[5322] = true
ids[5234] = true
ids[5265] = true
ids[5290] = true
ids[6237] = true
ids[8660] = true
ids[9153] = true
ids[8990] = true
ids[8991] = true
ids[11413] = true
ids[11414] = true
ids[13802] = true
ids[14400] = true
ids[14402] = true
ids[14468] = true
ids[14469] = true
ids[16390] = true
ids[17938] = true
ids[17939] = true
ids[18013] = true
ids[18015] = true
ids[18011] = true
ids[17958] = true
ids[17941] = true

function DecoHider.toggle()

	if DecoHider.state == 0 then
  
		DecoHider.state = 1
		DecoHider.enable()
  
	elseif DecoHider.state == 1 then
  
		DecoHider.state = 2
		DecoHider.enable()
		
	elseif DecoHider.state == 2 then

		DecoHider.disable()
		DecoHider.state = 0
  
	end
  
end


function DecoHider.disable()

    for i, object in pairs(DecoHider.objectList) do
	
		if isElement(object) then
		
			setElementAlpha(object, 255)
			
		end
	  
    end
	
	DecoHider.objectList = {}
	
	resetFarClipDistance()
	
	setWeather(DecoHider.originalWeather)
	
	setTime(DecoHider.originalTime[1], DecoHider.originalTime[2])
	
	setSkyGradient(DecoHider.originalSky[1], DecoHider.originalSky[2], DecoHider.originalSky[3], DecoHider.originalSky[4], DecoHider.originalSky[5], DecoHider.originalSky[6])
	
    outputChatBox("#ffd700Lag Reducer: #ff0000Disabled!", 255, 255, 255, true)

end


function DecoHider.enable()

	if DecoHider.state == 1 then

		DecoHider.originalWeather = getWeather()
	
		DecoHider.originalTime[1], DecoHider.originalTime[2] = getTime()
	
		DecoHider.originalSky[1], DecoHider.originalSky[2], DecoHider.originalSky[3], DecoHider.originalSky[4], DecoHider.originalSky[5], DecoHider.originalSky[6] = getSkyGradient()
	
	
		DecoHider.changeWeather()
		
		outputChatBox("#ffd700Lag Reducer: #ffff00Low!", 255, 255, 255, true)
		
	elseif DecoHider.state == 2 then
	
		for i, object in pairs(getElementsByType("object")) do
	
			if ids[getElementModel(object)] then
		  
				setElementAlpha(object, 0)
				table.insert(DecoHider.objectList, object)
			
			end
	  
		end
	
		DecoHider.changeWeather()
		
		setFarClipDistance(200)
		
		outputChatBox("#ffd700Lag Reducer: #00f000High!", 255, 255, 255, true)
	
	end

end


function DecoHider.changeWeather()

	setWeather(0)
	
	setSkyGradient(0, 0, 0, 0, 0, 0)
	
	setTime(0, 0)

end


function DecoHider.main()

	if not DecoHider.messageShown then

		triggerEvent("onClientCreateNotification", localPlayer, "Press N to activate Lag Reducer!", "information")

		DecoHider.messageShown = true
		
	end	
		
	bindKey("n","down", DecoHider.toggle)

	DecoHider.originalWeather = getWeather()
	
	DecoHider.originalTime[1], DecoHider.originalTime[2] = getTime()
	
	DecoHider.originalSky[1], DecoHider.originalSky[2], DecoHider.originalSky[3], DecoHider.originalSky[4], DecoHider.originalSky[5], DecoHider.originalSky[6] = getSkyGradient()	
	
	if DecoHider.state == 0 then return end
	
	DecoHider.enable()

end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, DecoHider.main)


function DecoHider.leave()

	DecoHider.messageShown = false
	DecoHider.state = 0

end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, DecoHider.leave)


function DecoHider.reset()

	DecoHider.objectList = {}

	unbindKey("n","down", DecoHider.toggle)

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, DecoHider.reset)
