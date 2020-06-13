Radio = {}
Radio.songQueue = {}
Radio.maxQueue = 10
Radio.timer = nil
Radio.streamData = {}
Radio.isStreaming = false
Radio.buyLock = {}
Radio.songs = { 'Frontliner feat John Harris - Halos (Hardstyle Videoclip HD+HQ)', 'Thousand Foot Krutch: Untraveled Road (Official Audio) ', 'Stromae - Alors On Danse (Dubdogz Remix) (Bass Boosted)', 'Major Lazer - Be Together (Cat Dealers Remix)', 'Imagine Dragons – Thunder', 'Macky Gee Ft. Stuart Rowe - Aftershock', 'Imagine Dragons - Its Time', 'Joey Dale & Ares Carter feat. Natalie Angiuli - Step Into Your Light', 'Thousand Foot Krutch: Born This Way (Official Audio)', '[DnB] - Tristam & Braken - Frame of Mind [Monstercat Release]', '[Trap] - Aero Chord - Surface [Monstercat Release]', 'The White Stripes - Seven Nation Army', 'Gotye - Somebody That I Used To Know (Feat. Kimbra) (4FRNT Remix)', 'DragonForce - Defenders ft. Matt Heafy | Lyrics on screen | Full HD', 'Bad Wolves - Zombie (Official Video)', 'Audioslave - Like a Stone (Official Video)', 'Starset - Satellite (Official Music Video)', 'SPOOKY SCARY SKELETONS (Trap Remix)', 'MACKLEMORE FEAT ERIC NALLY - AINT GONNA DIE TONIGHT', 'Can t Hold Us Lyrics Macklemore and Ryan Lewis Low)', 'Eminem - Till I Collapse [HD]', 'Marshello-Alone', 'Eminem - Lose Yourself [HD]', 'Alan Walker - Force', 'Eminem - Not Afraid', 'Con Bro Chill - Party Animal (Audio Only)', 'Knife Party - Bonfire', 'Coldplay - Paradise (Official Video)', 'CANT STOP THE FEELING! (From DreamWorks Animations "Trolls")(Official Video)', 'Con Bro Chill - We Came To Party (Audio Only)', 'Fall Out Boy - Centuries (Official Video)', 'Coolio - Gangsta Paradise (Cat Dealers & Simonetti Bootleg)', 'SIAMES - "The Wolf" [Official Video]', 'Metallica - Hardwired', 'Unlike Pluto - Everything Black (feat. Mike Taylor) [Official Lyric Video]', 'The Offspring - Youre Gonna Go Far, Kid', 'Cat Dealers & Evokings feat Magga - Gravity (Official Lyric Video)', 'Three Days Grace - Time Of Dying Music Video (Warrior)', 'DJ Snake - Let Me Love You (BOXINLION Cover Remix)', 'Felguk - This Life (Cat Dealers Remix)', 'Skillet - "Feel Invincible" [Official Music Video]', 'CAZZETTE - She Wants Me Dead (CAZZETTE vs. AronChupa) [Official Video] ft. The High', ' [Electronic] - Unlike Pluto - Waiting For You (feat. Joanna Jones) [Monstercat Release]', 'Kungs vs Cookin’ on 3 Burners - This Girl', 'Cat Dealers - Your Body (Remix)', 'Caravan Palace - Lone Digger', 'Rammstein - Du Hast (Official Video)', 'twenty one pilots: Heathens (from Suicide Squad: The Album) [OFFICIAL VIDEO]', 'Sick Puppies - Youre Going Down', 'Rammstein - Amerika (Official Video)', 'Foster the People - Pumped up Kicks (Bridge and Law Remix)', '[Electro] - Nitro Fun - Final Boss [Monstercat Release]', 'Deorro x Chris Brown - Five More Hours (Lyric Video)', '[Drumstep] - Braken - To The Stars [Monstercat Release]', 'Franz Ferdinand - Take Me Out', 'Pharrell Williams - Happy', '[Electro] Nitro Fun - Cheat Codes[Monstercat Release] ', 'Jenix Catch Fire~ Lyrics', 'Cat Dealers & Galck - Pump It (Original Mix)', 'DJ Khaled - Wild Thoughts ft. Rihanna, Bryson Tiller', 'Fox Stevenson – Endless', 'Matisyahu - Live Like A Warrior (LYRIC VIDEO)', 'Harder Better Faster Stronger - Daft Punk (remix)', 'D-Block & S-te-Fan - Fired Up', 'Fall Out Boy - The Phoenix (Official Video) - Part 2 of 11', 'Thousand Foot Krutch: War of Change (Official Music Video)', 'Green Day: "Boulevard Of Broken Dreams" - [Official Video]', 'System of a Down - B.Y.O.B. Lyrics HD', 'Red Hot Chili Peppers - Pink As Floyd [Vinyl Playback Video]', 'Lost In The Echo (Official Video) - Linkin Park', 'Alan Walker - Alone', 'Burn It Down (Official Video) - Linkin Park', 'Taio Cruz - Hangover ft. Flo Rida', 'SAIL - AWOLNATION (Unofficial Video)', 'Flo Rida - Good Feeling [Official Video]', 'Ylvis - The Fox (What Does The Fox Say?) [Official music video HD]', 'Avenged Sevenfold - Nightmare [HQ]', 'Alan Walker - The Spectre', 'Avenged Sevenfold - Welcome to the Family(Lyrics in Description)', 'Usher - DJ Got Us Fallin In Love ft. Pitbull', 'Taio Cruz - Dynamite', 'Thousand Foot Krutch-Phenomenon [lyrics]', 'Rise Against – Savior', 'AC/DC - Thunderstruck (Official Video)', 'Red Hot Chili Peppers - Cant Stop (Offical Music Video)', 'Faint (Official Video) - Linkin Park', 'Spiderbait - Black Betty', 'Alien Ant Farm - Smooth Criminal', 'The Strokes – Reptilia', 'Cat Dealers - Stolen Dance', 'Major Lazer & DJ snake Lean on Lyrics', 'Gorillaz - Feel Good Inc. (Official Video)', 'The Killers - When You Were Young', 'Bon Jovi - Its My Life', 'blink-182 - All The Small Things', 'Bon Jovi - Livin On A Prayer', 'The Killers - Mr. Brightside', 'System of a down- Aerials', 'Alan Walker - Faded', 'System Of A Down - Holy Mountains #08', 'Chamillionaire - Hip Hop Police Lyrics', 'What Ive Done (Official Video) - Linkin Park', 'Kanye West - Stronger', 'Numb (Official Video) - Linkin Park', 'Avicii - Levels', 'Somewhere I Belong (Official Video) - Linkin Park', 'DragonForce - Through The Fire And Flames (Video)', 'Red Hot Chili Peppers - Snow (Hey Oh) (Official Music Video)', 'DragonForce - Operation Ground And Pound [OFFICIAL VIDEO]', 'Calvin Harris & Alesso - Under Control ft. Hurts', 'Maroon 5 - One More Night' }

function Radio.main()
	Radio.randomSong()
end
addEventHandler ("onResourceStart", resourceRoot, Radio.main)

function getCleanPlayerName(p)
    return string.gsub(getPlayerName(p), '#%x%x%x%x%x%x', '')
end

function Radio.downloadCallback(data, error, song)
	if not song or not song.data then
		Radio.randomSong()
		outputChatBox("#FF6464[RADIO] #ffffffCurrent song is bugged. Switching to next one.", client, 255, 255, 255, true)
	end
	
	if song.data.title ~= Radio.songQueue[1].data.title then return end

	--[[ if Radio.songDownloading.data.title ~= Radio.songQueue[1].data.title then return end ]]

	--[[ triggerClientEvent(root, "onDownloadFinished", root) ]]
	triggerClientEvent(root, "onClientRadioSongStart", root, Radio.songQueue[1].data, Radio.songQueue[1].player)
	Radio.timer = setTimer(Radio.handleSongEnd, (Radio.songQueue[1].data.duration * 1000) + 2000, 1)
	Radio.reset()
end

function Radio.downloadSong()
	--[[ outputChatBox("#FF6464[RADIO] #ffffffDownloading song, please wait!", root, 255, 255, 255, true) ]]
	fetchRemote(Radio.songQueue[1].data.streamUrl, Radio.downloadCallback, "", false, Radio.songQueue[1])
end

function Radio.searchCallback(data, error, player)
	data = "["..data.."]"
	local response = fromJSON(data)
  
	triggerClientEvent(player, "onClientRadioSearchResult", player, response)
end

function Radio.search(value)
	fetchRemote("http://ddc.community:3000/search?q="..(value:gsub(" ","%%20")), Radio.searchCallback, "", false, client)
end
addEvent("onRadioSongSearch", true)
addEventHandler("onRadioSongSearch", root, Radio.search)

function Radio.randomSongCallback(data, error)
	data = "["..data.."]"
	local response = fromJSON(data)

	if not response then
		outputChatBox("#FF6464[RADIO] #ffffffCurrent song is bugged. Switching to next one.", client, 255, 255, 255, true)
		return Radio.randomSong()
	end
	
	local song = response[1]

	if not song or (not song.duration and not song.stream) then 
		outputChatBox("#FF6464[RADIO] #ffffffCurrent song is bugged. Switching to next one.", client, 255, 255, 255, true)
		return Radio.randomSong()
	end

	table.insert(Radio.songQueue, {data = song, player = "Server"})
	Radio.downloadSong()
end

function Radio.randomSong()
	local artist = Radio.songs[math.random(#Radio.songs)]
	fetchRemote("http://ddc.community:3000/search?q="..(artist:gsub(" ","%%20")), Radio.randomSongCallback, "", false)
end

function Radio.handleSongEnd(isSongSkipped, player, stream)
	if isSongSkipped then
		triggerClientEvent(root, "onClientRadioSongEnd", root, isSongSkipped, getCleanPlayerName(player))
	else
		triggerClientEvent(root, "onClientRadioSongEnd", root)
	end
	
	table.remove(Radio.songQueue, 1)

	if stream then return end
	
	if (#Radio.songQueue > 0) then
		if not Radio.songQueue[1].data.duration or not Radio.songQueue[1].data.streamUrl then 
			outputChatBox("#FF6464[RADIO] #ffffffFailed to play the song.", client, 255, 255, 255, true)
			Radio.handleSongEnd()
		end

		Radio.downloadSong()
	else
		Radio.randomSong()
	end
end

function Radio.request(data)
	if Radio.buyLock[client] and getTickCount() - Radio.buyLock[client] < 300000 then
		outputChatBox("You already bought a song recently!", client, 255, 0, 128)
		return
	end
	
	if (#Radio.songQueue >= Radio.maxQueue) then
		outputChatBox("#FF6464[RADIO] #ffffffQueue is full. ("..#Radio.songQueue.."/"..Radio.maxQueue..") Please try again later.", client, 255, 255, 255, true)
		return
	end
	
	if not exports["CCS_stats"]:export_takePlayerMoney(client, 25000) then 
		outputChatBox("Error: You don't have enough money!", client, 255, 0, 128)
		return 
	end

	if data.duration > 360 then
		outputChatBox("Error: The song exceeds the 6 minute length!", client, 255, 0, 128)
		return
	end
	
	Radio.buyLock[client] = getTickCount()

	if Radio.songQueue[1] and Radio.songQueue[1].player == "Server" then
		if isTimer(Radio.timer) then killTimer(Radio.timer) end
		table.remove(Radio.songQueue, 1)
		triggerClientEvent(root, "onClientRadioSongEnd", root)
		table.insert(Radio.songQueue, {data = data, player = getCleanPlayerName(client)})
		outputChatBox("#FF6464[RADIO] #ffffffYour song is in queue position "..#Radio.songQueue.."/"..Radio.maxQueue, client, 255, 255, 255, true)
		Radio.downloadSong()
		return
	end
	
	if #Radio.songQueue == 0 then
		table.insert(Radio.songQueue, {data = data, player = getCleanPlayerName(client)})
		outputChatBox("#FF6464[RADIO] #ffffffYour song is in queue position "..#Radio.songQueue.."/"..Radio.maxQueue, client, 255, 255, 255, true)
		Radio.downloadSong()
	else
		table.insert(Radio.songQueue, {data = data, player = getCleanPlayerName(client)})
		outputChatBox("#FF6464[RADIO] #ffffffYour song is in queue position "..#Radio.songQueue.."/"..Radio.maxQueue, client, 255, 255, 255, true)
	end
end
addEvent("onRadioSongRequest", true)
addEventHandler("onRadioSongRequest", root, Radio.request)

function Radio.skipSong(player)
	if isTimer(Radio.timer) then killTimer(Radio.timer) end
	Radio.handleSongEnd(true, player)
end
addCommandHandler("skipsong", Radio.skipSong)

function Radio.skipYourSong(player) 
	local nickname = getCleanPlayerName(player)
	if Radio.songQueue[1].player == nickname then
		Radio.skipSong(player)
	end
end
addCommandHandler("skipyoursong", Radio.skipYourSong)

function Radio.getSongQueue(player)
	local queue
	
	if (#Radio.songQueue ~= 0) then
		outputChatBox("#FF6464[RADIO] #ffffffSong queue:", player, 255, 255, 255, true)
		for i, song in ipairs(Radio.songQueue) do	
			outputChatBox("#ffffff"..i..". "..song.data.title.." ("..song.player.."#ffffff)", player, 255, 255, 255, true)
		end
	else
		outputChatBox("#FF6464[RADIO] #ffffffSong queue is empty", player, 255, 255, 255, true)
	end
end
addCommandHandler("queue", Radio.getSongQueue)

function Radio.getCurrentSong()
	triggerClientEvent(client, "onClientJoinedRadio", client, Radio.songQueue[1])
end
addEvent("onPlayerJoinRadio", true)
addEventHandler("onPlayerJoinRadio", root, Radio.getCurrentSong)

function Radio.liveStream(link)
	if Radio.isStreaming then
		Radio.handleSongEnd(false)
	else
		Radio.handleSongEnd(false, nil, true)
		triggerClientEvent("onLiveStream", root, link)
	end
end

--[[ addCommandHandler("livedj", Radio.liveStream) ]]

Voteskip = {}
Voteskip.votes = {}
Voteskip.votedPlayers = {}
Voteskip.locked = false

function Radio.reset()
	Voteskip.votes = 0
	Voteskip.votedPlayers = {}
	Voteskip.locked = false
end

function Radio.voteSkip(player, c)
	local players = getElementsByType("player") 
	local playerName = getCleanPlayerName(player)
	local percentNeeded = 0.50

	if Voteskip.locked then return end

	if not Radio.songQueue[1] then return end

	if Voteskip.votedPlayers[getPlayerSerial(player)] then return end

	Voteskip.votes = Voteskip.votes + 1
	Voteskip.votedPlayers[getPlayerSerial(player)] = true

	local missing = math.ceil((#players * percentNeeded)) - Voteskip.votes
	missing = math.max(missing, 0)

	outputChatBox("#FF6464[RADIO] #ffffff"..playerName.." #ffffffused /voteskip ("..missing.." votes missing)", root, 255, 255, 255, true)

	if missing == 0 then
		Voteskip.locked = true
		outputChatBox("#FF6464[RADIO] #ffffffVoteskip passed", root, 255, 255, 255, true)
		if isTimer(Radio.timer) then killTimer(Radio.timer) end
		Radio.handleSongEnd()
	end

end
addCommandHandler("voteskip", Radio.voteSkip)