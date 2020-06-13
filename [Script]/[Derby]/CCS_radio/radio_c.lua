Radio = {}
Radio.x, Radio.y = guiGetScreenSize()
Radio.state = false
Radio.muted = false
Radio.timer = nil
Radio.globalSound = nil
Radio.localSound = nil
Radio.globalSong = {}
Radio.localSong = {}
Radio.globalVolume = 1
Radio.localVolume = 1
Radio.isPlaying = false
Radio.streamData = {}
Radio.isInterfaceShown = false
Radio.disabled = false
Radio.clickDuration = nil
Radio.clickStart = nil
Radio.stopRenderingTimer = nil
Radio.url = "http://mta/local/html/index.html"
Radio.browser = guiCreateBrowser(0, 0, Radio.x, Radio.y, true, true, false)
guiSetVisible(Radio.browser, false)
setElementData(localPlayer, "radio", true)

function Radio.message()
	outputChatBox("#FF6464[RADIO] #00FF00ONLINE #ffffffPress F4 to toggle, M to mute, ADDITIONAL: /disableradio, /song, /queue", 255, 255, 255, true)
end

setTimer(Radio.message, 120000, 0)

function Radio.ready()
	loadBrowserURL(source, Radio.url)
	setBrowserRenderingPaused(guiGetBrowser(Radio.browser), true)
	guiSetInputMode("no_binds_when_editing")
end
addEventHandler("onClientBrowserCreated", guiGetBrowser(Radio.browser), Radio.ready)

function Radio.clientJoined(response) 
	Radio.playSong(response.data, response.player)
end
addEvent("onClientJoinedRadio", true)
addEventHandler("onClientJoinedRadio", root, Radio.clientJoined)

function Radio.main()
	if Radio.disabled then return end
	setElementData(localPlayer, "radio", true)
	bindKey("F4", "down", Radio.toggle)
	bindKey("M", "down", Radio.muteToggle)
	Radio.state = true
	Radio.muted = false
	if isElement(Radio.globalSound) then setSoundVolume(Radio.globalSound, 1) end
	if not isElement(Radio.globalSound) then
		triggerServerEvent("onPlayerJoinRadio", root)
	end
end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", localPlayer, Radio.main)

function Radio.reset()
	setElementData(localPlayer, "radio", false)
	unbindKey("F4", "down", Radio.toggle)
	unbindKey("M", "down", Radio.muteToggle)
	Radio.state = false
	removeEventHandler("onClientRender", root, Radio.render)
	Radio.destroy()
	Radio.muted = true
	if isElement(Radio.globalSound) then setSoundVolume(Radio.globalSound, 0) end
end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, Radio.reset)

function Radio.create()
	if isTimer(Radio.stopRenderingTimer) then killTimer(Radio.stopRenderingTimer) end
	addEventHandler("onClientRadioLocalSongContinue", root, Radio.continueLocalSong)
	addEventHandler("onClientRadioLocalSongPause", root, Radio.pauseLocalSong)
	addEventHandler("onClientRadioLocalSongStart", root, Radio.startLocalSong)
	addEventHandler("onSearchButton", root, Radio.search)
	addEventHandler("onBuySongButton", root, Radio.buySong)
	addEventHandler("onClientRadioSearchResult", root, Radio.searchResult)
	Radio.isInterfaceShown = true
	guiSetVisible(Radio.browser, true)
	setBrowserRenderingPaused(guiGetBrowser(Radio.browser), false)
	showCursor(true)
	local list = {title = "no results"}
	--[[ outputConsole(toJSON(list)) ]]
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').open()")
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').returnMusicData("..toJSON(list)..")")	
end

function Radio.destroy()
	removeEventHandler("onClientRender", root, Radio.render)
	removeEventHandler("onClientRadioLocalSongContinue", root, Radio.continueLocalSong)
	removeEventHandler("onClientRadioLocalSongPause", root, Radio.pauseLocalSong)
	removeEventHandler("onClientRadioLocalSongStart", root, Radio.startLocalSong)
	removeEventHandler("onSearchButton", root, Radio.search)
	removeEventHandler("onBuySongButton", root, Radio.buySong)
	removeEventHandler("onClientRadioSearchResult", root, Radio.searchResult)
	Radio.isInterfaceShown = false
	guiSetVisible(Radio.browser, false)
	showCursor(false)
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').isCurrentSong=false")
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').currentSong=null")
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').isPlaying=false")
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').close()")
	
	if isElement(Radio.localSound) then stopSound(Radio.localSound) end
	if isTimer(Radio.timer) then killTimer(Radio.timer) end
	Radio.isPlaying = false
	Radio.stopRenderingTimer = setTimer(setBrowserRenderingPaused, 500, 1, guiGetBrowser(Radio.browser), true)
end

function Radio.toggle(key, keyState)
	Radio.toggleInterface()
end

function Radio.render()
	if not isElement(Radio.localSound) then return end
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio')._updateProgressBar("..getSoundPosition(Radio.localSound)..")")
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').currentTime="..getSoundPosition(Radio.localSound))
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').isPlaying="..tostring(Radio.isPlaying))
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').duration="..Radio.localSong.duration)
end

function Radio.toggleInterface()
	if Radio.isInterfaceShown then
		Radio.destroy()
		if isElement(Radio.globalSound) and not Radio.muted then
			setSoundVolume(Radio.globalSound, 1)
		end
	else
		Radio.create()
	end
end

function Radio.muteToggle()
	if not isElement(Radio.globalSound) then return end

	if not Radio.muted then
		setSoundVolume(Radio.globalSound, 0)
		Radio.muted = true
		setElementData(localPlayer, "radio", false)
		outputChatBox("#FF6464[RADIO] #ffffffRadio is now muted!", 255, 255, 255, true)
	else
		setSoundVolume(Radio.globalSound, 1)
		Radio.muted = false
		setElementData(localPlayer, "radio", true)
		outputChatBox("#FF6464[RADIO] #ffffffRadio is now unmuted!", 255, 255, 255, true)
	end
end

function Radio.mute()
	if not isElement(Radio.globalSound) then 
		outputChatBox("#FF6464[RADIO] #ffffffNo song playing!", 255, 255, 255, true)
		return 
	end
	
	if Radio.isInterfaceShown then return end
	
	if not Radio.muted then
		setSoundVolume(Radio.globalSound, 0)
		Radio.muted = true
		outputChatBox("#FF6464[RADIO] #ffffffRadio is now muted!", 255, 255, 255, true)
	else
		setSoundVolume(Radio.globalSound, 1)
		Radio.muted = false
		outputChatBox("#FF6464[RADIO] #ffffffRadio is now unmuted!", 255, 255, 255, true)
	end
end

function Radio.stopSong(isSongSkipped, player)
	if isSongSkipped then
		outputChatBox("#FF6464[RADIO] #ffffffCurrent song skipped by "..player, 255, 255, 255, true)
	end

	if isElement(Radio.globalSound) then stopSound(Radio.globalSound) end
end
addEvent("onClientRadioSongEnd", true)
addEventHandler("onClientRadioSongEnd", root, Radio.stopSong)

function Radio.continueLocalSong(data)
	local song = fromJSON(data)
	Radio.isPlaying = true;
	Radio.timer = setTimer(Radio.songEnded, song.duration * 1000 + getSoundPosition(Radio.localSound), 1)
	setSoundPaused(Radio.localSound, false)
	addEventHandler("onClientRender", root, Radio.render)
	
	if isElement(Radio.globalSound) then
		setSoundVolume(Radio.globalSound, 0)	
	end
end
addEvent("onClientRadioLocalSongContinue")

function Radio.pauseLocalSong(data)
	if not isElement(Radio.localSound) then return end
	if isTimer(Radio.timer) then killTimer(Radio.timer) end
	setSoundPaused(Radio.localSound, true)
	Radio.isPlaying = false
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').isPlaying=false")
	removeEventHandler("onClientRender", root, Radio.render)
end
addEvent("onClientRadioLocalSongPause")

function Radio.startLocalSong(data)
	local song = fromJSON(data)
  
	if isElement(Radio.localSound) then
		stopSound(Radio.localSound)
		if isTimer(Radio.timer) then killTimer(Radio.timer) end
		Radio.isPlaying = false
	end
	
	Radio.isPlaying = true
	Radio.localSound = playSound(song.streamUrl)
	Radio.timer = setTimer(Radio.songEnded, song.duration * 1000, 1)
	Radio.localSong = song
	addEventHandler("onClientRender", root, Radio.render)
	
	if isElement(Radio.globalSound) then
		setSoundVolume(Radio.globalSound, 0)
	end
end
addEvent("onClientRadioLocalSongStart")

function Radio.checkSongPlaying(stream)
	if not isElement(Radio.globalSound) or (isElement(Radio.globalSound) and getSoundLength(Radio.globalSound) == 0) then
		Radio.globalSound = playSound(stream)
	end
end

function Radio.playSong(data, player)
	if not Radio.state then return end
	if Radio.disabled then return end
	
	if isElement(Radio.globalSound) then stopSound(Radio.globalSound) end

	Radio.globalSong = {data = data, player = player}
	outputChatBox("#FF6464[RADIO] #ffffffNow playing: #0080FF"..data.title.." #ffffffby#EC407A "..data.artist.." #ffffffrequested by "..player, 255, 255, 255, true)
	Radio.globalSound = playSound(data.streamUrl)
	setTimer(Radio.checkSongPlaying, 5000, 1, data.streamUrl)
  
	if Radio.isInterfaceShown or Radio.muted then
		setSoundVolume(Radio.globalSound, 0)
	end
end
addEvent("onClientRadioSongStart", true)
addEventHandler("onClientRadioSongStart", root, Radio.playSong)

function Radio.search(value)
	triggerServerEvent("onRadioSongSearch", root, value)
end
addEvent("onSearchButton")

function Radio.buySong(data)
	local song = fromJSON(data)
	triggerServerEvent("onRadioSongRequest", root, song)
end
addEvent("onBuySongButton")

function Radio.songEnded()
	removeEventHandler("onClientRender", root, Radio.render)
	Radio.isPlaying = false
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio')._onEnd()")
end

function Radio.searchResult(data)
	local list = toJSON(data)
	list = list:sub(1, -2)
	list = list:sub(2, #list)
	executeBrowserJavascript(guiGetBrowser(Radio.browser), "document.querySelector('ddc-radio').returnMusicData("..toJSON(list)..")")	
end
addEvent("onClientRadioSearchResult", true)

function convertSecToMin(t)
	if t == 0 then return "0:00" end
	local r, e = math.floor(t / 60), tostring(math.floor(t % 60))

	if string.len(e) < 2 then
		e = "0"..e
	end

	return r..":"..e
end

function Radio.getCurrentSong()
	if not isElement(Radio.globalSound) then return end
	local song = Radio.globalSong
	outputChatBox("#FF6464[RADIO] #ffffffCurrent song: "..song.data.title.." by "..song.data.artist.." requested by "..song.player.." #ffffff("..convertSecToMin(getSoundPosition(Radio.globalSound)).."/"..convertSecToMin(getSoundLength(Radio.globalSound))..")", 255, 255, 255, true)
end
addCommandHandler("song", Radio.getCurrentSong)

function Radio.disable()
	if Radio.disabled then
		outputChatBox("#FF6464[RADIO] #ffffffRejoin arena to enable radio!", 255, 255, 255, true)
		Radio.disabled = false
	else
		outputChatBox("#FF6464[RADIO] #fffffRadio is now disabled!", 255, 255, 255, true)
		if isElement(Radio.globalSound) then
			stopSound(Radio.globalSound)
		end
		Radio.disabled = true
	end
end
addCommandHandler("disableradio", Radio.disable)

function Radio.liveStream(link)
	outputChatBox("#FF6464[RADIO] #ffffffLIVE RADIO #00FF00ONLINE", 255, 255, 255, true)
	playSound("http://shaincast.caster.fm:48964/listen.mp3?authn1da99b9f47ae278abbacd9ab7233add8")
end
addEvent("onLiveStream", true)
addEventHandler("onLiveStream", root, Radio.liveStream)

function Radio.downloadFinished()
	outputChatBox("#FF6464[RADIO] #ffffffDownload finished!", 255, 255, 255, true)
end
addEvent("onDownloadFinished", true)
addEventHandler("onDownloadFinished", root, Radio.downloadFinished)