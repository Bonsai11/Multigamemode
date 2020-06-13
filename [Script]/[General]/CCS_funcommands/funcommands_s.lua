Funcommands = {}

function Funcommands.nab(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#00ffff'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Well done, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', u NAB!!!')

end
addCommandHandler("nab", Funcommands.nab)


function Funcommands.naball(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#00ffff'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Well done, everyone, u NABS!!!')

end
addCommandHandler("naball", Funcommands.naball)


function Funcommands.gay(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': #FF6200'..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' is gomosek!')

end
addCommandHandler("gay", Funcommands.gay)


function Funcommands.cry(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, "#1E90FF"..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' cries when angels deserve to die!')

end
addCommandHandler("cry", Funcommands.cry)


function Funcommands.ragequit(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#FF6464* '..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' has left the game [Ragequit]')

end
addCommandHandler("ragequit", Funcommands.ragequit)


function Funcommands.pc(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, "#00BBF5"..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' gave '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' a new PC!')

end
addCommandHandler("pc", Funcommands.pc)


function Funcommands.ping(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#00BBF5'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', please lower your ping.')

end
addCommandHandler("ping", Funcommands.ping)


function Funcommands.wtf(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ff0000'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': What the fuck, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'?')

end
addCommandHandler("wtf", Funcommands.wtf)


function Funcommands.yeby(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': #66CD00'..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', KAK YEBY SUKA!')

end
addCommandHandler("yeby", Funcommands.yeby)


function Funcommands.stfu(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Hey, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', shut the fuck up!')

end
addCommandHandler("stfu", Funcommands.stfu)


function Funcommands.nc(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Nice cheats, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("nc", Funcommands.nc)


function Funcommands.bb(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Goodbye, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("bb", Funcommands.bb)


function Funcommands.hiall(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Hello everyone :)')

end
addCommandHandler("hiall", Funcommands.hiall)


function Funcommands.hi(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Hey, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("hi", Funcommands.hi)


function Funcommands.bball(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Bye-bye everyone!')

end
addCommandHandler("bball", Funcommands.bball)


function Funcommands.gl(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Good luck, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("gl", Funcommands.gl)


function Funcommands.n1(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Nice one, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("n1", Funcommands.n1)


function Funcommands.b1(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Bad one, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("b1", Funcommands.b1)


function Funcommands.yes(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Yes, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', I can agree with you.')

end
addCommandHandler("yes", Funcommands.yes)


function Funcommands.no(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': No, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', you are fucking wrong!')

end
addCommandHandler("no", Funcommands.no)


function Funcommands.hunter(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Achtung, hunter is coming!')

end
addCommandHandler("hunter", Funcommands.hunter)


function Funcommands.brb(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' will be right back!')

end
addCommandHandler("brb", Funcommands.brb)


function Funcommands.banan(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' has been bananned from game by '..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("banan", Funcommands.banan)


function Funcommands.fu(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Fuck you very much, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("fu", Funcommands.fu)


function Funcommands.ty(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Thank you, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("ty", Funcommands.ty)


function Funcommands.np(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': No problemo, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("np", Funcommands.np)


function Funcommands.gogo(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': GO, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', GO. YOU CAN WIN! :)')

end
addCommandHandler("gogo", Funcommands.gogo)


function Funcommands.gogo2(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': GOGO, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..', YOU CAN LOSE!')

end
addCommandHandler("gogo2", Funcommands.gogo2)


function Funcommands.bot(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end
	
	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' is a stupid BOT!')

end
addCommandHandler("bot", Funcommands.bot)


function Funcommands.butwhy(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': But why, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'? ( ͡; ͜ʖ ͡;)')

end
addCommandHandler("butwhy", Funcommands.butwhy)


function Funcommands.rip(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Rest in Pieces, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("rip", Funcommands.rip)


function Funcommands.khe(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': ( ͡o ͜ʖ ͡o) KHÈ FAST, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("khe", Funcommands.khe)
 
 
function Funcommands.lick(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' licks '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("lick", Funcommands.lick)


function Funcommands.spank(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' spanks '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("spank", Funcommands.spank)


function Funcommands.whynot(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Why not, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'? ( ͡° ͜ʖ ͡°)')

end
addCommandHandler("whynot", Funcommands.whynot)


function Funcommands.pff(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Play for fuck, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("pff", Funcommands.pff)


function Funcommands.pro(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#00ffff'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..' is such a PRO!!')

end
addCommandHandler("pro", Funcommands.pro)


function Funcommands.proall(p, c)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#00ffff'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Everyone is so PRO!!')

end
addCommandHandler("proall", Funcommands.proall)


function Funcommands.eat(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..' eats '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')

end
addCommandHandler("eat", Funcommands.eat)


function Funcommands.countryChange(p, c, t)

	local account = getElementData(p, "account")
	
	if not account or account ~= "Angel" then
	
		outputChatBox("Error: Only Angel can do this!", p, 255, 0, 0, true)
		return 
		
	end
	
	if not t then return end
	
	if #t < 2 or #t > 3 then return end
	
	setElementData(p, "Country", t)

end
addCommandHandler("cc", Funcommands.countryChange)


function Funcommands.wiu(p, c, player)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
	
	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	local vehicle = getPedOccupiedVehicle(p)
	
	if not vehicle then return end
	
	addVehicleSirens(vehicle, 8, 2, true, false, true, false)	

	setElementModel(p, 266)
	
	exports["CCS"]:export_outputArenaChat(arenaElement, "#ff0000Wiu #ffffffWiu #0000ffWiu#00ccff! "..getPlayerName(player):gsub('#%x%x%x%x%x%x', '').." is being chased for shortcutting!")

end
addCommandHandler("wiu", Funcommands.wiu)


function Funcommands.nt(p, c, player)
 
    local arenaElement = getElementParent(p)
 
    if not getElementData(arenaElement, "showSpectatorChat") and getElementData(p, "Spectator") then return end
   
    if player then
   
        player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
   
    else
   
        player = p
       
    end
   
    if not player then return end
   
    exports["CCS"]:export_outputArenaChat(arenaElement, '#ffff00'..getPlayerName(p):gsub('#%x%x%x%x%x%x', '')..': Nice try, '..getPlayerName(player):gsub('#%x%x%x%x%x%x', '')..'!')
 
end
addCommandHandler("nt", Funcommands.nt)

