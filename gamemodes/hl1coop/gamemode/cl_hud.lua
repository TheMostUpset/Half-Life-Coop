surface.CreateFont( "HL1Coop_score", {
	font	= "Roboto",
	size	= ScrW() / 26,
	weight	= 800
} )

surface.CreateFont( "HL1Coop_msg", {
	font	= "Roboto",
	extended = true,
	size	= ScrW() / 28,
	weight	= 800
} )

surface.CreateFont( "HL1Coop_vote", {
	font	= "Trebuchet MS",
	size	= ScrH() / 32,
	weight	= 800
} )

surface.CreateFont( "HL1Coop_Captions", {
	font = "Trebuchet MS",
	extended = true,
	size = ScrW() / 54,
	weight = 400
} )

surface.CreateFont("HL1Coop_text", {
	font = "Arial",
	extended = true,
	size = ScrH() / 24,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HL1Coop_ChapterTitle", {
	font	= "Trebuchet MS",
	extended = true,
	size	= ScrW() / 28,
	weight	= 800
} )

local killics = {
	["weapon_crowbar"] = "crowbar",
	["weapon_glock"] = "glock",
	["weapon_357"] = "357",
	["weapon_mp5"] = "mp5",
	["weapon_shotgun"] = "shotgun",
	["weapon_crossbow"] = "crossbow",
	["weapon_rpg" ]= "rpg",
	["weapon_gauss"] = "gauss",
	["weapon_egon"] = "egon",
	["weapon_hornetgun"] = "hgun",
	["weapon_handgrenade"] = "grenade",
	["weapon_satchel"] = "satchel",
	["weapon_tripmine"] = "tripmine",
	["weapon_snark"] = "snark"
}
for wep, icon in pairs(killics) do
	killicon.Add(wep, "hl1/icons/"..icon, Color(255, 150, 50, 255))
end

local cvar_showscore = CreateClientConVar("hl1_coop_cl_showscore", 1, true, false, "Show score points popup")
local ScreenMessageScore
local ScreenMessageScoreText
local ScreenMessageScore_time = RealTime()
net.Receive("ScreenMessageScore", function()
	local score = net.ReadInt(32)
	hook.Run("OnScreenScoreAdded", score)
	if !cvar_showscore:GetBool() then return end
	local msg = net.ReadString()
	if msg and msg != "" then
		ScreenMessageScoreText = ConvertToLang(msg)
	else
		ScreenMessageScoreText = nil
	end
	if ScreenMessageScore and ScreenMessageScore_time+.75 >= RealTime() and (tonumber(ScreenMessageScore) > 0 and score > 0 or tonumber(ScreenMessageScore) < 0 and score < 0) then
		score = score + ScreenMessageScore
	end
	local sym = score > 0 and "+" or ""
	ScreenMessageScore = sym..score
	ScreenMessageScore_time = RealTime()
end)

local TextMessageCenter
local TextMessageCenter_time = RealTime()
function GM:SetTextMessageCenter(str, float)
	TextMessageCenter = ConvertToLang(str)
	TextMessageCenter_time = RealTime() + float
end
net.Receive("TextMessageCenter", function()
	GAMEMODE:SetTextMessageCenter(net.ReadString(), net.ReadFloat())
end)

local hintText = ""
local hintTime = RealTime()
local hintDelay = 0
local hintX, hintY = 0, 0
local seenHints = {}
net.Receive("ShowScreenHint", function()
	local int = net.ReadUInt(5)
	local delay = net.ReadFloat()
	GAMEMODE:PlayerShowScreenHint(int, delay)
end)

function GM:PlayerHasSeenHint(int)
	return seenHints and seenHints[int]
end

function GM:ScreenHintTable()
	local t = {
		[1] = lang.hint_longjump,
		[2] = lang.hint_quitchase,
		[3] = "Press "..GetKeyFromBind("+jump").." for\nfirst person cam",
		[4] = lang.hint_medkituse
		-- [5] is reserved
	}
	return t
end

function GM:PlayerShowScreenHint(int, delay)
	if IsValid(LocalPlayer()) and cvars.Bool("hl1_coop_cl_showhints") and !self:PlayerHasSeenHint(int) then
		if int == 5 and CanReachNearestTeleport() then
			hintText = lang.hint_lastcheckpoint
		else
			hintText = hook.Run("ScreenHintTable")[int]
		end

		if !hintText then return end
		
		hintDelay = delay
		hintTime = RealTime() + hintDelay
		hintX, hintY = ScrW(), ScrH() / 1.5
		
		if seenHints then
			seenHints[int] = true
		end
	end
end

local hintTopText = ""
local hintTopTime = RealTime()
local hintTopDelay = 0
local hintTopX, hintTopY = 0, 0
net.Receive("ShowScreenHintTop", function()
	local text = net.ReadString()
	local delay = net.ReadFloat()
	GAMEMODE:PlayerShowScreenHintTop(text, delay)
end)
function GM:PlayerShowScreenHintTop(text, delay)
	if IsValid(LocalPlayer()) then
		hintTopDelay = delay
		hintTopTime = RealTime() + hintTopDelay
		hintTopY = -256
		hintTopText = ConvertToLang(text)
		MsgN(hintTopText)
	end
end

local worldHintTime = RealTime()
net.Receive("ShowTeleportHint", function()
	if IsValid(LocalPlayer()) then
		telePosTable = net.ReadTable()
		if cvars.Bool("hl1_coop_cl_showhints") and !GAMEMODE:PlayerHasSeenHint(0) then
			worldHintTime = RealTime() + 15
		end
	end
end)

local caption_text = {}
local lineCountS = 0
local caption_h_lerp = 0
function GM:ShowCaption(sentence)
	if !cvars.Bool("hl1_coop_cl_subtitles", false) then return end
	local text = lang.subtitleTable[sentence]
	if text then
		local caption_color = {140, 140, 140}
		local caption_time = RealTime() + utf8.len(text) / 20 + 2.5
		local typeSentence = string.upper(sentence)
		local startwith = string.StartWith
		if startwith(typeSentence, "!SC_") or startwith(sentence, "NPC_Scientist") then
			caption_color = {240, 240, 240}
		elseif startwith(typeSentence, "!BA_") then
			caption_color = {160, 200, 255}
		elseif startwith(typeSentence, "!HG_") then
			caption_color = {180, 255, 200}
		elseif startwith(typeSentence, "!GM_") then
			caption_color = {255, 200, 255}
			caption_time = RealTime() + utf8.len(text) / 14 + 2.5
		elseif startwith(typeSentence, "!BMAS_") then
			caption_color = {40, 120, 200}
			caption_time = RealTime() + utf8.len(text) / 14 + 3.5
		elseif startwith(sentence, "nihilanth/") then
			caption_color = {255, 120, 30}
			caption_time = RealTime() + utf8.len(text) / 16 + 3
		elseif startwith(sentence, "tride/") then
			caption_color = {255, 200, 30}
			caption_time = RealTime() + utf8.len(text) / 12
		elseif startwith(typeSentence, "!HOLO_") or startwith(sentence, "holo/") then
			caption_color = {210, 180, 80}
		end
		
		local font = lang.subtitleFont
		surface.SetFont(font)
		local ctext_w, ctext_h = surface.GetTextSize("")
		local caption_w = ScrW() / 1.6
		local caption_table = string.Wrap(font, text, caption_w)
		for k, v in pairs(caption_text) do
			if table.ToString(v[1]) == table.ToString(caption_table) then return end
		end
		local caption_h = ctext_h * #caption_table
		if #caption_text == 0 then
			caption_h_lerp = caption_h
			lineCountS = 0
		end

		table.insert(caption_text, {caption_table, caption_time, RealTime(), caption_color, ctext_h, caption_w, caption_h, lineCountS})
	end
end
net.Receive("ShowCaption", function()
	local sentence = net.ReadString()
	GAMEMODE:ShowCaption(sentence)
end)

local ChapterFadeIn
net.Receive("HL1ChapterPreStart", function()
	ChapterFadeIn = RealTime() + 2
end)

net.Receive("HL1ChapterStart", function()
	GAMEMODE.NewChapterDelay = CurTime() + net.ReadFloat()
	GAMEMODE:ShowChapterName()
end)

local ChapterName = ""
local ChapterFadeOut = RealTime()
function GM:ShowChapterName()
	ChapterFadeOut = RealTime() + 5
	if MAP.ShowChapterTitle != false and MAP.ChapterTitle then
		ChapterName = ConvertToLang(MAP.ChapterTitle)
	end
end

local GameOverReason = ""
local GameOverFade = RealTime()
net.Receive("HL1GameOver", function()
	local reason = net.ReadString()
	if reason then
		GameOverReason = ConvertToLang(reason)
		--SendMessage(reason, 0, 0, nil, Color(160,160,160), "HL1Coop_text")
	end
	GameOverFade = RealTime() + 5
	GAMEMODE:StopMusic(3)
end)

local introLogoAlphaIn = 0
local introLogoAlphaOut = 350
local introTime = RealTime()
function GM:GameIntro()
	introLogoAlphaIn = 0
	introLogoAlphaOut = 300
	introTime = RealTime() + 10
	if game.SinglePlayer() then
		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 2, 4)
	end
end
net.Receive("HL1GameIntro", function()
	GAMEMODE:GameIntro()
end)

local gamemodeLogo = Material("hl1coop_logo.png", "smooth")

GM.CreditsTextStart = [[Gamemode was created by
Upset

SWEPs coding
Upset

Half-Life Resized Maps
Mr.Lazy
Upset
Maestra Fénix

GoldSrc HUD
DyaMetR

Half-Life: Source Playermodels
Captain Charles]]

GM.CreditsTextEnd = [[Testing
Mr.Lazy
crafty
Matsilagi
nio
CehkUrPrvldge
cringecancer
cyan
Novel
Lyokanthrope
Sonador




Valve is:

Viktor Antonov
Ted Backman
Kelly Bailey
Jeff Ballinger
Matt Bamberger
Aaron Barber
Yahn Bernier
Ken Birdwell
Derrick Birum
Chris Bokitch
Steve Bond
Matt Boone
Charlie Brown
Julie Caldwell
Dario Casali
Yvan Charpentier
Jess Cliffe
John Cook
Greg Coomer
Kellie Cosner
Scott Dalton
Kerry Davis
Jason Deakins
Ariel Diaz
Quintin Doroquez
Martha Draves
Laura Dubuk
Mike Dunkle
Mike Dussault
Rick Ellis
Dhabih Eng
Miles Estes
Adrian Finol
Bill Fletcher
Moby Francke
Pat Goodwin
Chris Green
Chris Grinstead
John Guthrie
Leslie Hall
Damarcus Holbrook
Tim Holt
Brian Jacobson
Erik Johnson
Jakob Jungels
Iikka Keranen
Eric Kirchmer
Marc Laidlaw
Jeff Lane
Tom Leonard
Doug Lombardi
Randy Lundeen
Scott Lynch
Ido Magal
Gary McTaggart
John Morello II
Bryn Moslow
Gabe Newell
Tri Nguyen
Jake Nicholson
Martin Otten
Kristen Perry
Bay Raitt
Alfred Reynolds
Dave Riller
Danika Rogers
David Sawyer
Aaron Seeler
Nick Shaffner
Taylor Sherman
Eric Smith
David Speyrer
Jay Stelly
Jeremy Stone
Mikel Thompson
Kelly Thornton
Carl Uhlman
Bill Van Buren
KayLee Vogt
Robin Walker
Josh Weier
Doug Wood
Matt T Wood
Matt Wright


Thank you for playing!]]

ShowPlayerDist = RealTime()
concommand.Add("showdist", function()
	ShowPlayerDist = RealTime() + 5
	
	net.Start("UpdatePlayerPositions")
	net.WriteFloat(5)
	net.SendToServer()
end)

function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x - i, y - i, w + i * 2, h + i * 2 )
	end
end

function GetHUDThemeColor()
	local col = Color(255, 180, 0, 255)
	if GSRCHUD and GSRCHUD.isEnabled() then
		col = GSRCHUD.getCurrentColour()
	end
	return col
end

function HintFrameColor(alpha)
	alpha = alpha or 100
	local col = Color(255, 150, 0, alpha)
	if GSRCHUD and GSRCHUD.isEnabled() then
		local themeCol = GetHUDThemeColor()
		col.r, col.g, col.b = themeCol.r, themeCol.g - 30, themeCol.b
	end
	return col
end

local function kewlText( text, font, x, y, color, align, align_y )

	align_y = align_y or 0

    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,color.a/1.5), align, align_y )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,color.a/2), align, align_y )
    draw.SimpleText( text, font, x+3, y+3, Color(0,0,0,color.a/4), align, align_y )
    draw.SimpleText( text, font, x, y, color, align, align_y )

end

local function kewlDrawText(text, font, x, y, color, align)
    draw.DrawText( text, font, x+1, y+1, Color(0,0,0,color.a/1.5), align, align_y )
    draw.DrawText( text, font, x+2, y+2, Color(0,0,0,color.a/2), align, align_y )
    draw.DrawText( text, font, x+3, y+3, Color(0,0,0,color.a/4), align, align_y )
    draw.DrawText( text, font, x, y, color, align )
end

-- taken from: https://github.com/SuperiorServers/dash/blob/master/lua/dash/extensions/client/string.lua
function string.Wrap(font, text, width)
	surface.SetFont(font)

	local sw = surface.GetTextSize(' ')
	local ret = {}

	local w = 0
	local s = ''

	local t = string.Explode('\n', text)
	for i = 1, #t do
		local t2 = string.Explode(' ', t[i], false)
		for i2 = 1, #t2 do
			local neww = surface.GetTextSize(t2[i2])
				
			if (w + neww >= width) then
				ret[#ret + 1] = s
				w = neww + sw
				s = t2[i2] .. ' '
			else
				s = s .. t2[i2] .. ' '
				w = w + neww + sw
			end
		end
		ret[#ret + 1] = s
		w = 0
		s = ''
	end
		
	if (s ~= '') then
		ret[#ret + 1] = s
	end

	return ret
end

local targetEnt
local targetTextTime = RealTime()

function GM:HUDDrawTargetID()
	local ply = LocalPlayer()
	local actwep = ply:GetActiveWeapon()
	--if IsValid(actwep) and actwep:GetClass() == "weapon_healthkit" and table.Count(ply:GetWeapons()) > 1 then return end
	
	local tr = ply:GetEyeTrace()
	
	if tr.Hit and tr.HitNonWorld and IsValid(tr.Entity) and tr.Entity:IsPlayer() then
		targetEnt = tr.Entity
		targetTextTime = RealTime()
	end
	
	if IsValid(targetEnt) then
		local alpha = (targetTextTime - RealTime()) * 255 + 220
		alpha = math.Clamp(alpha, 0, 255)
		if alpha > 0 then
			local x, y = ScrW() / 2, ScrH() / 2
			local gap = 20
			local hp = targetEnt:Health()
			local hpcol = Color(255, 30, 0, alpha)
			if hp > 50 then
				hpcol = Color(0, 255, 0, alpha)
			elseif hp > 25 then
				hpcol = Color(255, 255, 0, alpha)
			end
			kewlText(targetEnt:Nick(), "TargetID", x, y - gap, Color(255,180,70,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			if hp > 0 then
				kewlText(hp.." / "..targetEnt:Armor(), "TargetIDSmall", x, y + gap, hpcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
	end
end

local haloPlyTable = {}

function GM:HUDDrawPlayerDistance()
	local ply = LocalPlayer()
	local actwep = ply:GetActiveWeapon()
	local medkitActive = IsValid(actwep) and actwep:GetClass() == "weapon_healthkit" and table.Count(ply:GetWeapons()) > 1
	if ShowPlayerDist and ShowPlayerDist > RealTime() or medkitActive then
		local alpha = math.Clamp((ShowPlayerDist - RealTime()) *50, 0, 180)
		local alphamul = 1
		haloPlyTable = {}
		for k, pl in pairs(team.GetPlayers(TEAM_COOP)) do
			if IsValid(pl) and pl != ply and pl:Team() == ply:Team() then
				local plpos = pl:GetPos()
				local pos = plpos + Vector(0, 0, pl:OBBMaxs()[3] + 18)
				if !pl:Alive() then
					local ragdoll = pl:GetRagdollEntity()
					if !IsValid(ragdoll) then continue end
					plpos = ragdoll:GetPos()
					pos = plpos + Vector(0, 0, 48)
				end
				
				local dist = ply:GetPos():Distance(plpos)
				local dist_m = math.Round(dist * 0.02)
				local text_x, text_y = math.Clamp(pos:ToScreen().x, 0, ScrW()), math.Clamp(pos:ToScreen().y, -64, ScrH())
				
				local maxdist = 800
				if medkitActive and dist < maxdist then
					alphamul = math.Clamp((-dist + maxdist) / 100, 0, 1)
					alpha = 200 * alphamul
				end
				if alphamul > 0 then
					local col = Color(150, 150, 150, alpha)
					if !pl:Alive() then
						col = Color(180, 60, 60, alpha)
					elseif medkitActive and dist < maxdist then
						local rectWidth = 80
						local rectHeight = 6
						local rectY = 12
						local plymaxhp = pl:GetMaxHealth()
						local plyhp = math.Clamp(pl:Health(), 0, plymaxhp)
						surface.SetDrawColor(200, 0, 0, 160 * alphamul)
						surface.DrawRect(text_x - rectWidth / 2, text_y - rectY, rectWidth, rectHeight)
						surface.SetDrawColor(0, 220, 0, 200 * alphamul)
						surface.DrawRect(text_x - rectWidth / 2, text_y - rectY, rectWidth * plyhp / plymaxhp, rectHeight)
					end
					
					if dist < 1000 and pl:GetNWFloat("CallMedicTime") > CurTime() then
						local alert = math.sin(RealTime() * 20) * 4
						col = Color(255, 100 * alert, 100 * alert, 255)
					end
					
					kewlDrawText(pl:GetName().."\n"..dist_m.."m", "HL1Coop_text", text_x, text_y, col, TEXT_ALIGN_CENTER)
				
					if cvars.Bool("hl1_coop_cl_drawhalos") and dist_m <= 40 then
						if pl:Alive() then
							haloPlyTable[k] = pl
						else
							local ragdoll = pl:GetRagdollEntity()
							if IsValid(ragdoll) then
								haloPlyTable[k] = ragdoll
							end
						end
					end
				end
			end
		end
	end
end

function GM:PreDrawHalos()
	if haloPlyTable and !table.IsEmpty(haloPlyTable) and ShowPlayerDist and ShowPlayerDist > RealTime() then
		local alpha = math.Clamp((ShowPlayerDist - RealTime()) / 3, 0, 1)
		local col = Color(100 * alpha, 255 * alpha, 0)
		halo.Add(haloPlyTable, col, 2, 2, 1, true, true)
	end
end

function GM:HUDDrawChangelog()
	local textcol = Color(255,200,50,255)
	if self.Version then draw.SimpleText("ver "..self.Version, "Trebuchet18", ScrW() - 4, ScrH(), textcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM) end
	if self.Changelog and self.Changelog != "" then
		draw.SimpleText("New in version "..self.Version..":", "Trebuchet24", 8, 4, textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) 
		draw.DrawText(self.Changelog, "Trebuchet18", 8, 35, textcol, TEXT_ALIGN_LEFT)
	end
end

function GM:HUDDrawWorldHint()
	if worldHintTime > RealTime() and telePosTable then
		local ply = LocalPlayer()
		for _, telePos in pairs(telePosTable) do
			local worldHintAlpha = 0 -- TODO: make alpha value individual
			local hintPos = telePos + Vector(0,0,64)
			local dist = ply:GetPos():Distance(telePos)
			if dist < 768 then
				local tr = util.TraceLine({
					start = telePos, 
					endpos = ply:EyePos(),
					filter = ply,
					mask = MASK_SOLID_BRUSHONLY
				})
				if !tr.Hit then
					worldHintAlpha = math.Clamp((worldHintTime - RealTime()) *100, 0, 180)
					--worldHintAlpha = dist-255 + worldHintAlpha
					if dist > 512 then
						worldHintAlpha = worldHintAlpha - dist / 1.4 + 367
					end
					worldHintAlpha = math.Clamp(worldHintAlpha, 0, 180)
				else
					worldHintAlpha = math.max(worldHintAlpha - 3, 0)
				end
				--local col = Color(255, 200, 0, worldHintAlpha)
				surface.SetFont("MenuFont")
				local text = lang.hint_teleport
				local textWidth, textHeight = surface.GetTextSize(text)
				local rectWidth = textWidth + 32
				local gap = 32
				local text_x, text_y = math.Clamp(hintPos:ToScreen().x, textWidth / 2 + gap, ScrW() - textWidth / 2 - gap), math.Clamp(hintPos:ToScreen().y, gap/2, ScrH() - textHeight - gap/2)
				
				surface.SetDrawColor(0, 0, 0, worldHintAlpha)
				surface.DrawRect(text_x - rectWidth / 2, text_y, rectWidth, textHeight)
				draw.OutlinedBox(text_x - rectWidth / 2, text_y, rectWidth, textHeight, 3, HintFrameColor(worldHintAlpha / 10))
				draw.DrawText(text, "MenuFont", text_x, text_y, Color(150, 255, 150, worldHintAlpha), TEXT_ALIGN_CENTER)
			
				if seenHints and !self:PlayerHasSeenHint(int) then
					seenHints[0] = true
				end
			end
		end
	end
end

function GM:HUDDrawHint()
	if hintTime > RealTime() then
		local hintBlink = 0 - (hintTime - hintDelay - RealTime()) * 200
		if hintBlink > 100 then
			hintBlink = math.max(120 + (hintTime - hintDelay - RealTime()) * 80, 0)
		end
		local hintAlpha = math.Clamp((hintTime - RealTime()) * 100, 0, 255)
		surface.SetFont("MenuFont")
		local hintWidth, hintHeight = surface.GetTextSize(hintText)
		hintWidth = hintWidth + 48
		hintX = Lerp(FrameTime() * 6, hintX, ScrW() - hintWidth - 32)
		surface.SetDrawColor(0, 0, 0, hintAlpha / 1.5)
		surface.DrawRect(hintX, hintY, hintWidth, hintHeight)
		surface.SetDrawColor(255, 200, 0, hintBlink - 40)
		surface.DrawRect(hintX, hintY, hintWidth, hintHeight)
		draw.OutlinedBox(hintX, hintY, hintWidth, hintHeight, 3, HintFrameColor(hintAlpha / 10))
		kewlDrawText(hintText, "MenuFont", hintX + hintWidth / 2, hintY, Color(255, 200 + hintBlink / 2, hintBlink, hintAlpha), TEXT_ALIGN_CENTER)
	end
end

function GM:HUDDrawHintTop()
	if hintTopTime > RealTime() then
		local hintBlink = 0 - (hintTopTime - hintTopDelay - RealTime()) * 200
		if hintBlink > 100 then
			hintBlink = math.max(120 + (hintTopTime - hintTopDelay - RealTime()) * 80, 0)
		end
		local hintAlpha = math.Clamp((hintTopTime - RealTime()) * 100, 0, 255)
		surface.SetFont("MenuFont")
		local hintWidth, hintHeight = surface.GetTextSize(hintTopText)
		hintWidth = hintWidth + 48
		hintTopX = ScrW() / 2 - hintWidth / 2
		hintTopY = Lerp(FrameTime() * 6, hintTopY, 48)
		surface.SetDrawColor(0, 0, 0, hintAlpha / 1.5)
		surface.DrawRect(hintTopX, hintTopY, hintWidth, hintHeight)
		surface.SetDrawColor(255, 200, 0, hintBlink - 40)
		surface.DrawRect(hintTopX, hintTopY, hintWidth, hintHeight)
		draw.OutlinedBox(hintTopX, hintTopY, hintWidth, hintHeight, 3, HintFrameColor(hintAlpha / 10))
		kewlDrawText(hintTopText, "MenuFont", hintTopX + hintWidth / 2, hintTopY, Color(255, 230 + hintBlink / 2, 150 + hintBlink, hintAlpha), TEXT_ALIGN_CENTER)
	end
end

local vote_yes = Material("icon16/tick.png")
local vote_no = Material("icon16/cross.png")
function GM:HUDDrawVote()
	local voteType = GetGlobalString("VoteType")
	local voteName = GetGlobalString("VoteName")
	local voteNameAdd = ""
	if voteType == "skill" then
		if SKILL_LEVEL[voteName] then
			voteNameAdd = "("..SKILL_LEVEL[voteName]..")"
		end
	elseif voteType == "map" then
		local chapterName = hook.Run("GetChapterName", voteName)
		if chapterName then
			voteNameAdd = "("..chapterName..")"
		end
	elseif voteType == "kickid" then
		voteType = "kick"
		local ply = Player(voteName)
		if IsValid(ply) then
			voteName = ply:Nick()
		end
	elseif voteType == "ban" then
		local ply = Player(voteName)
		if IsValid(ply) then
			voteName = ply:Nick()
		end
		voteNameAdd = "for "..GetGlobalInt("VoteMinutes").." minutes"
	elseif voteType == "skiptripmines" then
		voteType = "skip tripmine room"
	else
		if voteType == "speedrunmode" then
			voteType = "speedrun mode"
			if voteName == "1" then
				voteNameAdd = "(causes map restart)"
			end
		elseif voteType == "crackmode" then
			voteType = "crack mode"
			voteNameAdd = "(causes map restart)"
		elseif voteType == "survivalmode" then
			voteType = "survival mode"
		elseif voteType == "friendlyfire" then
			voteType = "friendly fire"
		end
		if voteName == "0" then
			voteName = "OFF"
		elseif voteName == "1" then
			voteName = "ON"
		end
	end
	
	surface.SetFont("HL1Coop_vote")
	local yes, no = GetGlobalInt("VoteNumYes"), GetGlobalInt("VoteNumNo")
	local vtime = math.Round(math.max(GetGlobalInt("VoteTime") - CurTime(), 0))
	local votetext = lang.hud_vote..":".." "..vtime.."s "..lang.hud_voteleft.."\n"..voteType.." "..voteName.."\n"..voteNameAdd
	local vtext_w, vtext_h = surface.GetTextSize(votetext)
	local vcol = Color(255, 210, 50, 220)
	local rectG = 20
	
	local frame_w, frame_h = math.max(ScrW() / 7, vtext_w), ScrH() / 6
	local frame_x, frame_y = 20, ScrH() / 2 - frame_h / 2
	
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(frame_x - rectG / 2, frame_y - rectG / 2, frame_w + rectG, frame_h + rectG)
	draw.OutlinedBox(frame_x - rectG / 2, frame_y - rectG / 2, frame_w + rectG, frame_h + rectG, 3, HintFrameColor())
	kewlDrawText(votetext, "HL1Coop_vote", frame_x, frame_y, vcol, TEXT_ALIGN_LEFT)
	
	local icon_scale = 16
	local icon_y = frame_y + frame_h - 32
	local icon_text = 28
	local icon_frame_col = Color(255, 220, 50, 220)
	local frame_g = 10
	local text_w, text_h = surface.GetTextSize("0 (F2)")
	
	local yes_x = frame_x + frame_g
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(vote_yes)
	surface.DrawTexturedRect(yes_x, icon_y, icon_scale, icon_scale)
	draw.OutlinedBox(yes_x - 2, icon_y - 2, icon_scale + 4, icon_scale + 4, 1, icon_frame_col)
	kewlText(yes.." ("..GetKeyFromBind("gm_showhelp")..")", "HL1Coop_vote", yes_x + icon_text + text_w / 2, icon_y + icon_scale / 2, icon_frame_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local no_x = frame_w + frame_x - text_w / 2 - frame_g
	kewlText(no.." ("..GetKeyFromBind("gm_showteam")..")", "HL1Coop_vote", no_x, icon_y + icon_scale / 2, icon_frame_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(vote_no)
	surface.DrawTexturedRect(no_x - text_w / 2 - icon_text, icon_y, icon_scale, icon_scale)
	draw.OutlinedBox(no_x - text_w / 2 - icon_text - 2, icon_y - 2, icon_scale + 4, icon_scale + 4, 1, icon_frame_col)

	--local chosen_w = icon_scale + text_w + icon_text
	--surface.SetDrawColor(150, 150, 150, 120)
	--surface.DrawRect(yes_x, icon_y, chosen_w, icon_scale + 8)
end

function GM:HUDDrawScreenMessageScore()	
	local RT = RealTime()
	local ScreenMessageScore_alpha = math.Clamp(700 - (RT - ScreenMessageScore_time) * 900, 0, 255)
	if ScreenMessageScore and ScreenMessageScore_alpha > 0 then
		local ScreenMessageScore_pos = math.Clamp(558 + ScrH() / 4 - (RT - ScreenMessageScore_time) * 700, 0, ScrH() / 2.5)
		kewlText(ScreenMessageScore, "HL1Coop_score", ScrW() / 2, ScreenMessageScore_pos, Color(255,240,50,ScreenMessageScore_alpha), TEXT_ALIGN_CENTER)
		if ScreenMessageScoreText then
			local msgAlpha = math.max(ScreenMessageScore_alpha - 70, 0)
			kewlText(ScreenMessageScoreText, "HL1Coop_vote", ScrW() / 2, ScreenMessageScore_pos * .875, Color(255,180,30,msgAlpha), TEXT_ALIGN_CENTER)
		end
	end
end

function GM:HUDDrawTextMessageCenter()
	local RT = RealTime()
	if TextMessageCenter and TextMessageCenter_time > RT then
		local alpha = math.Clamp((TextMessageCenter_time - RT) * 300, 0, 255)
		kewlText(TextMessageCenter, "HL1Coop_msg", ScrW() / 2, ScrH() / 2, Color(255,240,150,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
	
local ctime = RealTime()
local caption_alpha = 0
function GM:HUDDrawCaptions()
	local cstime = 0
	local caption_w = 0
	local caption_h = 0
	for k, v in pairs(caption_text) do
		if v[2] > ctime then
			ctime = v[2]
		end
		cstime = v[3]
		caption_w = v[6]
		caption_h = caption_h + v[7]
		
		if v[2] < RealTime() + .1 and #caption_text > 1 then
			caption_h = caption_h - v[7]
			lineCountS = math.max(lineCountS - #v[1], 0)
		end
		if v[2] < RealTime() then
			table.remove(caption_text, k)
		end
	end
	if ctime > RealTime() then
		local FT = FrameTime()
		--caption_h_lerp = Lerp(FrameTime() * 10, caption_h_lerp, caption_h)
		caption_h_lerp = math.Approach(caption_h_lerp, caption_h, FT * 180)
		local caption_x = ScrW() / 2 - caption_w / 2
		local caption_y = ScrH() / 1.35 - caption_h_lerp / 4
		local rectgap = 16
		local alpha = 1
		if ctime > RealTime() + 1 then
			caption_alpha = math.Clamp(caption_alpha + FT * 10, 0, 1)
		else
			caption_alpha = math.Clamp(caption_alpha - FT, 0, 1)
		end
		surface.SetDrawColor(0, 0, 0, 150 * caption_alpha)
		surface.DrawRect(caption_x - rectgap / 2, caption_y - rectgap / 2, caption_w + rectgap, caption_h_lerp + rectgap)
		
		local lineCount = 0
		for k, v in pairs(caption_text) do
			local ctable = v[1]
			local cstime = v[3]
			local ccol = v[4]
			local ctext_h = v[5]
			if RealTime() < cstime + .15 then
				alpha = math.Clamp((RealTime() - cstime) * 12, 0, 1)
			else
				alpha = math.Clamp(v[2] - RealTime(), 0, 1)
			end
			for l, t in pairs(ctable) do
				local s = l - 1
				kewlText(t, lang.subtitleFont, caption_x, caption_y + (s + v[8]) * ctext_h, Color(ccol[1], ccol[2], ccol[3], 255 * alpha), TEXT_ALIGN_LEFT)
			end
			--v[8] = Lerp(FrameTime() * 20, v[8], lineCount)
			v[8] = math.Approach(v[8], lineCount, FT * 8)
			if v[2] > RealTime() + .1 then
				lineCount = lineCount + #ctable
			end
			lineCountS = lineCount
		end
	end
end
concommand.Add("clearsubtitles", function()
	ctime = 0
	if caption_text then
		table.Empty(caption_text)
	end
end)

local icon_train_mat = Material("sprites/640_train_gmod")
function GM:HUDTrainDraw()
	local clrTrain = Color(255, 230, 20, 255)
	local txSize = 128
	local y = ScrH() - 32 - txSize
	local x = ScrW() / 2 - 32 - txSize / 4
	if GSRCHUD and GSRCHUD.isEnabled() then
		clrTrain = GetHUDThemeColor()
	end
	surface.SetDrawColor(clrTrain)
	surface.SetMaterial(icon_train_mat)
	surface.DrawTexturedRect(x, y, txSize, txSize)
	
	local m_iPos = LocalPlayer():GetNW2Int("m_iTrain")
	icon_train_mat:SetFloat("$frame", math.Clamp(m_iPos - 1, 0, 4))
end
	
function GM:EndTitles()
	if GAMEMODE:GetCoopState() == COOP_STATE_ENDTITLES then
		local font = "HL1Coop_score"
		surface.SetFont(font)
		
		local text = self.CreditsTextStart.."\n\n"
		if lang.credits_translationby and utf8.len(lang.credits_translationby) > 0 then text = text..lang.credits_translationby.."\n\n" end
		text = text.."\n"..self.CreditsTextEnd
		
		local textWidth, textHeight = surface.GetTextSize(text)
		local textspeed = textHeight / 100
		local textmove = (CurTime() - GetGlobalFloat("EndTitlesTime")) * textspeed - ScrH() / 1.4
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(gamemodeLogo)
		local logoW, logoH = 400, 170
		surface.DrawTexturedRect(ScrW() / 2 - logoW / 2, ScrH() / 2 - logoH / 2 - textmove, logoW, logoH)
		draw.DrawText(text, font, ScrW() / 2, ScrH() / 2 + logoH - textmove, Color(200,200,200,255), TEXT_ALIGN_CENTER)
	end
end

local EnvMessageInit, EnvMessageSplit, EnvMessageLetterTable, EnvMessageTextTable, EnvMessageCountOld, EnvMessageCount, EnvMessageAlpha, EnvMessageTableLine, EnvMessageType, EnvMessagePos, EnvMessageHColor, EnvMessageColor, EnvMessageFont
local EnvMessageFadeout

function SendMessage(msg, msgtype, pos, staydelay, hlightcol, col, font)
	msg = language.GetPhrase(msg)
	EnvMessageInit = ConvertToLang(msg)
	EnvMessageType = msgtype or 0
	if EnvMessageType == 0 then
		EnvMessageSplit = string.Split(EnvMessageInit, "\n")
		EnvMessageLetterTable = {}
		EnvMessageTextTable = {}
		for k, v in ipairs(EnvMessageSplit) do
			EnvMessageTextTable[k] = ""
			EnvMessageSplit[k] = string.ToTable(v)
		end
		EnvMessageCountOld = 0
		EnvMessageCount = 0
		EnvMessageAlpha = 400 * staydelay
		EnvMessageTableLine = 1
		EnvMessageHColor = hlightcol or Color(240,110,0)
	else
		EnvMessageAlpha = 1
		EnvMessageFadeout = false
	end
	EnvMessagePos = pos or 0
	EnvMessageColor = col or Color(100, 100, 100)
	EnvMessageFont = font or "Trebuchet24"
end

net.Receive("HL1DrawMessage", function()
	SendMessage(net.ReadString(), net.ReadUInt(4), net.ReadUInt(4), net.ReadFloat(), net.ReadColor(), net.ReadColor())
end)

function GM:HUDDrawMessage()
	if EnvMessageInit and EnvMessageAlpha and EnvMessageAlpha > 0 then
		local FT = FrameTime()
		surface.SetFont(EnvMessageFont)
		local tw, th = surface.GetTextSize(EnvMessageInit)
		if EnvMessageType == 0 then
			local ttw, tth = surface.GetTextSize(table.concat(EnvMessageSplit[EnvMessageTableLine], ""))
			
			local letterKey = math.floor(EnvMessageCount)
			if letterKey != math.floor(EnvMessageCountOld) and letterKey <= #EnvMessageSplit[EnvMessageTableLine] then
				local lastLetter = EnvMessageSplit[EnvMessageTableLine][letterKey]
				if lastLetter then
					local lag = math.ceil(letterKey - EnvMessageCountOld)
					if lag > 1 then
						for i = 1, lag - 1 do
							lag = lag - 1
							local lastLetter = EnvMessageSplit[EnvMessageTableLine][letterKey - lag]
							if lastLetter then
								EnvMessageTextTable[EnvMessageTableLine] = EnvMessageTextTable[EnvMessageTableLine]..lastLetter
							end
						end
					end
					EnvMessageTextTable[EnvMessageTableLine] = EnvMessageTextTable[EnvMessageTableLine]..lastLetter
					if EnvMessageLetterTable then
						local letter_w, letter_h = surface.GetTextSize(EnvMessageTextTable[EnvMessageTableLine])
						letter_h = th / #EnvMessageSplit
						letter_h = letter_h * (EnvMessageTableLine - 1)
						table.insert(EnvMessageLetterTable, {lastLetter, letter_w - ttw / 2, letter_h, 255})
					end
				end
			end
			if letterKey < #EnvMessageSplit[EnvMessageTableLine] then
				EnvMessageCountOld = EnvMessageCount
				EnvMessageCount = EnvMessageCount + 1
			else
				if EnvMessageTableLine < #EnvMessageSplit then
					EnvMessageTableLine = math.min(EnvMessageTableLine + 1, #EnvMessageSplit)
					EnvMessageCount = 1
				else
					EnvMessageCount = EnvMessageCount + 1 -- stopping the loop
					EnvMessageAlpha = EnvMessageAlpha - FT * 100
				end
			end
			-- drawing
			local posX, posY = ScrW() / 2, ScrH() / 2
			if EnvMessagePos > 0 then
				posX, posY = ScrW() / 16 + tw / 2, ScrH() / 1.2 - th / 2
			end
			if EnvMessageTextTable then
				for k, v in pairs(EnvMessageTextTable) do
					local text = table.concat(EnvMessageSplit[k], "")
					local ttw, tth = surface.GetTextSize(text)
					kewlDrawText(v, EnvMessageFont, posX - ttw / 2, posY - th / 2 + (k-1) * draw.GetFontHeight(EnvMessageFont), Color(EnvMessageColor.r,EnvMessageColor.g,EnvMessageColor.b,math.Clamp(EnvMessageAlpha, 0, 255)))
				end
			end
			if EnvMessageLetterTable then
				for k, v in ipairs(EnvMessageLetterTable) do
					v[4] = math.max(v[4] - FT * 800, 0)
					if v[4] > 0 then
						draw.DrawText(v[1], EnvMessageFont, posX + v[2], posY - th / 2 + v[3], Color(EnvMessageHColor.r,EnvMessageHColor.g,EnvMessageHColor.b,v[4]), TEXT_ALIGN_RIGHT)
					end
				end
			end
		else
			if EnvMessageFadeout then
				EnvMessageAlpha = EnvMessageAlpha - FT * 300
			else
				EnvMessageAlpha = EnvMessageAlpha + FT * 300
			end
			if EnvMessageAlpha >= 400 then
				EnvMessageFadeout = true
			end
			
			local posX, posY = ScrW() / 2, ScrH() / 2
			if EnvMessagePos > 0 then
				posX, posY = ScrW() / 10, ScrH() / 1.25
			end

			kewlDrawText(EnvMessageInit, EnvMessageFont, posX, posY - th / 2, Color(EnvMessageColor.r,EnvMessageColor.g,EnvMessageColor.b,math.Clamp(EnvMessageAlpha, 0, 255)), TEXT_ALIGN_CENTER)
		end
	end
end

function GM:HUDDrawSpectatorStuff(ply)	
	local spectarget = ply:GetObserverTarget()
	if IsValid(spectarget) and spectarget:IsPlayer() and spectarget != ply then
		kewlText(spectarget:Nick(), "Trebuchet24", ScrW() / 2, ScrH() - 96, Color(255,200,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
	if ply:IsSpectator() then
		if ply:GetObserverMode() != OBS_MODE_NONE and ply:GetObserverMode() != OBS_MODE_IN_EYE then
			local pos1, pos2 = ScrH() / 4, ScrH() / 3
			local alpha = math.sin(RealTime() * 10) * 30 + 200
			if IsValid(spectarget) then
				pos1, pos2 = ScrH() / 12, ScrH() / 10
				if GetGlobalFloat("WaitTime") > CurTime() then
					pos1, pos2 = ScrH() / 4.5, ScrH() / 4
				end
			end
			if ply:IsDeadInSurvival() then
				if !IsValid(spectarget) then
					kewlDrawText(lang.hud_surv_norespawns, "HL1Coop_text", ScrW() / 2, pos1, Color(255,200,0,alpha), TEXT_ALIGN_CENTER)
				end
			elseif ply:CanJoinGame() then
				kewlText(lang.hud_pressesc, "HL1Coop_text", ScrW() / 2, pos2, Color(255,200,0,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
		if IsValid(spectarget) and !ply:IsDeadInSurvival() then
			kewlText(lang.hud_specmode, "Trebuchet24", ScrW() / 2, 4, Color(200,200,200,180), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		
		local font = "Trebuchet24"
		local w = 220
		local x, y = ScrW(), ScrH() / 6
		surface.SetFont(font)		
		local plyTable = hook.Run("GetActivePlayersTable")
		for k, v in pairs(plyTable) do
			if v != ply then
				local nick = string.Left(v:Nick(), 11)
				local tw, th = surface.GetTextSize(nick)
				y = y + th + 4
				if v == spectarget then
					surface.SetDrawColor(200, 100, 0, 220)
				else
					surface.SetDrawColor(100, 0, 0, 100)
				end
				surface.DrawRect(x - w, y, w, th)
				kewlText(nick, font, x - 148, y, Color(255,200,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				kewlText(v:Armor(), font, x - 24, y, Color(255,250,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				kewlText(v:Health(), font, x - 48, y, Color(255,250,0,230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
		end
	end
end

local gndVel, gndVelAlpha
function GM:HUDDrawSpeedrun()
	local ply = LocalPlayer()
	if GAMEMODE:GetSpeedrunMode() and ply:Alive() and (!IsValid(viewent) or viewent == ply) then
		local font = "Trebuchet24"
		local fontH = draw.GetFontHeight(font)
		local velX, velY = ScrW() / 2, ScrH() - 70
		local timerX, timerY = ScrW() - 6, ScrH() / 8
		
		local vel = math.Round(ply:GetVelocity():Length2D())
		local gndVelLast = gndVel
		gndVel = ply.GroundHitSpeed and math.Round(ply.GroundHitSpeed) or 0
		if gndVel != gndVelLast then
			gndVelAlpha = 180
		end
		gndVelAlpha = math.max(gndVelAlpha - FrameTime() * 100, 80)
		kewlText(gndVel, font, velX, velY, Color(200,200,200,gndVelAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		kewlText(vel, font, velX, velY + fontH, Color(255,200,0,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local fTime = self:GetMapTime()
		fTime = fTime > 0 and fTime or 0
		kewlText(FormattedTimer(fTime), font, timerX, timerY + fontH, Color(255,200,0,150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		local gTime = GetGlobalFloat("GameTime")
		if gTime >= 0 then
			gTime = fTime + gTime
			gTime = gTime > 0 and gTime or 0
			kewlText(FormattedTimer(gTime), font, timerX, timerY, Color(200,200,200,150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end
	end
end

function GM:HUDDrawBottomText(ply)	
	if ply:Alive() then
		if ply.SpawnProtectionTime then
			local spt = ply.SpawnProtectionTime - CurTime()
			if spt > 0 then
				local sptR = math.Round(spt, 1)
				local alpha = math.Clamp(spt * 1000 - 30, 0, 120)
				kewlText(lang.hud_spawnprotection..": "..sptR, "Trebuchet24", ScrW() / 2, ScrH() - 8, Color(200,200,200,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
		end
	elseif GetGlobalBool("DisablePlayerRespawn") then
		kewlText("Respawns are disabled", "Trebuchet24", ScrW() / 2, ScrH() - 8, Color(200,200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end

local wait_x_ready = ScrW() / 2
local wait_x_unready = ScrW() / 2
function GM:HUDDrawWaitTimer()
	local CT = CurTime()
	if GetGlobalFloat("WaitTime") > CT then
		local FT = FrameTime()
		local wtime = GetGlobalFloat("WaitTime") - CT
		local wtimeR = math.Round(wtime, 1)
		if wtimeR % 1 == 0 then
			wtimeR = wtimeR..".0" -- am i doing this right lol
		end
		local alpha = math.Clamp(wtime * 1000, 0, 255)
		surface.SetFont("HL1Coop_text")
		local text = lang.hud_waitingforplayersc..": "..wtimeR
		kewlText(text, "HL1Coop_text", ScrW() / 2, 24, Color(255,210,50,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		local textWidth, textHeight = surface.GetTextSize(text)
		
		local wait_y = 0
		local wait_y_ready = 0
		local wait_y_unready = 0
		local wait_x = ScrW() / 2
		local wait_align = TEXT_ALIGN_LEFT
		local wait_col = Color(50,250,50,alpha)
		local readyNum = 0
		local plys = hook.Run("GetActivePlayersTable")
		wait_x_ready = Lerp(FT * 2, wait_x_ready, ScrW() / 2 - 128)
		wait_x_unready = Lerp(FT * 2, wait_x_unready, ScrW() / 2 + 128)
		for k, v in pairs(plys) do
			if v:IsInWaitTrigger() then
				readyNum = readyNum + 1
				wait_y_ready = wait_y_ready + 20
				wait_y = wait_y_ready
				wait_x = wait_x_ready
				wait_align = TEXT_ALIGN_RIGHT
				wait_col = Color(50,250,50,alpha)
			else
				wait_y_unready = wait_y_unready + 20
				wait_y = wait_y_unready
				wait_x = wait_x_unready
				wait_align = TEXT_ALIGN_LEFT
				wait_col = Color(250,50,50,alpha)
			end
			kewlText(v:Nick(), "Trebuchet24", wait_x, textHeight + wait_y + 8, wait_col, wait_align, TEXT_ALIGN_TOP)
		end
		if readyNum > 0 then
			kewlText(readyNum.."/"..#plys, "HL1Coop_text", ScrW() / 2, textHeight + 26, Color(255,210,50,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	else
		wait_x_ready = ScrW() / 2
		wait_x_unready = ScrW() / 2
	end
end

function GM:HUDPaint()
	local ply = LocalPlayer()
	
	if self.IsSandboxDerived then
		local actWep = ply:GetActiveWeapon()
		if IsValid(actWep) and actWep:GetClass() != "gmod_camera" then
			kewlText("SANDBOX MODE", "Trebuchet24", 16, 10, Color(255,255,255,100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

	if !GSRCHUD or !GSRCHUD.isEnabled() then
		hook.Run("HUDDrawPickupHistory")
	end
	
	local viewent = ply:GetViewEntity()
	if IsValid(viewent) and viewent:IsPlayer() and viewent != ply then
		kewlText(viewent:Nick(), "Trebuchet24", ScrW() / 2, ScrH() - 96, Color(255,200,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	if !ply:IsSpectator() and viewent == ply then
		hook.Run("HUDDrawTargetID")
	end
	if !game.SinglePlayer() then
		hook.Run("DrawDeathNotice", 0.85, 0.04)
	end
	if ply:IsFlagSet(FL_ONTRAIN) and ply:Alive() then
		hook.Run("HUDTrainDraw")
	end
	
	if !GAMEMODE:GetSpeedrunMode() and ChapterFadeIn then
		local fade = math.Clamp((RealTime() - ChapterFadeIn + 1.5) * 180, 0, 255)
		surface.SetDrawColor(0, 0, 0, fade)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		if ChapterFadeIn - RealTime() < -5 then
			ChapterFadeIn = nil
		end
	end
	if introTime and introTime > RealTime() then
		local alpha
		local FT = FrameTime()
		if introLogoAlphaIn >= 255 then
			introLogoAlphaOut = introLogoAlphaOut - FT * 80
			alpha = math.Clamp(introLogoAlphaOut, 0, 255)
		else
			introLogoAlphaIn = introLogoAlphaIn + FT * 200
			alpha = math.Clamp(introLogoAlphaIn, 0, 255)
		end
		if !game.SinglePlayer() then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(gamemodeLogo)
		local logoW, logoH = 500, 200
		surface.DrawTexturedRect(ScrW() / 2 - logoW / 2, ScrH() / 2 - logoH / 2, logoW, logoH)
	end
	if ChapterFadeOut > RealTime() then
		introTime = nil
		ChapterFadeIn = nil
		local ChapterFadeOutTime = math.max(ChapterFadeOut - RealTime(), 0)
		local ChapterFadeOutAlpha = math.Clamp(ChapterFadeOutTime * 100, 0, 255)
		if GAMEMODE:GetSpeedrunMode() then			
			kewlText("SPEEDRUN MODE", "HL1Coop_ChapterTitle", ScrW() / 3 + ChapterFadeOutTime * 60, ScrH() / 2, Color(200,150,50,ChapterFadeOutAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			surface.SetDrawColor(0, 0, 0, ChapterFadeOutAlpha)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end
		kewlText(ChapterName, "HL1Coop_ChapterTitle", ScrW() / 1.5 - ChapterFadeOutTime * 60, ScrH() / 2, Color(200,200,200,ChapterFadeOutAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	elseif GameOverFade and GameOverFade > RealTime() then
		local fade = math.Clamp((RealTime() - GameOverFade) * 100 + 500, 0, 255)
		surface.SetDrawColor(0, 0, 0, fade)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		kewlText(GameOverReason, "HL1Coop_text", ScrW() / 2, ScrH() / 2, Color(220,220,220,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	-- kewlText(lang.HL1_Chapter2_Title, "HL1Coop_ChapterTitle", ScrW() / 1.5 - 10 * 60, ScrH() / 2, Color(200,200,200,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	
	hook.Run("HUDDrawScreenMessageScore")
	hook.Run("HUDDrawTextMessageCenter")
	hook.Run("HUDDrawMessage")
	hook.Run("HUDDrawSpectatorStuff", ply)	
	hook.Run("HUDDrawSpeedrun")
	hook.Run("HUDDrawBottomText", ply)	
	hook.Run("HUDDrawPlayerDistance")
	hook.Run("HUDDrawWorldHint")
	hook.Run("HUDDrawHint")
	hook.Run("HUDDrawHintTop")
	hook.Run("HUDDrawCaptions")
	
	hook.Run("EndTitles")
	
	if GetGlobalBool("Vote") then
		hook.Run("HUDDrawVote")
	end
	
	hook.Run("HUDDrawWaitTimer")
	
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		hook.Run("HUDDrawChangelog")
	end

	if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then 
		if MAP.ShowChapterTitle != false then
			surface.SetDrawColor(0, 0, 0, 240)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end
		local alpha = math.sin(RealTime() * 10) * 30 + 220
		if CONNECTING_PLAYERS_TABLE and #CONNECTING_PLAYERS_TABLE > 0 or hook.Run("GetActivePlayersNumber") == 0 then
			kewlText(lang.hud_waitingforplayers, "HL1Coop_msg", ScrW() / 2, ScrH() / 2, Color(255,230,140,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			--kewlText(math.Round(GetGlobalFloat("FirstWaitingTime") - CurTime(), 1), "Trebuchet24", ScrW() / 2, 8, Color(255,230,140,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			if CONNECTING_PLAYERS_TABLE then
				local gap = 32
				for k, v in pairs(CONNECTING_PLAYERS_TABLE) do
					gap = gap + 22
					local pl = Player(v)
					local text = IsValid(pl) and pl:Nick() or "id "..v
					kewlText(text, "Trebuchet24", ScrW() / 2, ScrH() / 2 + gap, Color(255,230,140,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			kewlText(lang.hud_getready, "HL1Coop_msg", ScrW() / 2, ScrH() / 2, Color(255,230,140,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end