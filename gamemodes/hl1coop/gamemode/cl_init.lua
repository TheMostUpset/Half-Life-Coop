GM.RagdollGibModels = {
	["models/hl1bar.mdl"] = {0, 16},
	["models/hgrunt.mdl"] = {0, 16},
	["models/scientist.mdl"] = {0, 16},
	["models/hassassin.mdl"] = {0, 16},
	["models/zombie.mdl"] = {0, 16},
	["models/islave.mdl"] = {1, 16},
	["models/bullsquid.mdl"] = {1, 20},
	["models/controller.mdl"] = {1, 12},
	["models/houndeye.mdl"] = {1, 8},
	["models/hl1hcrab.mdl"] = {1, 2},
	["models/agrunt.mdl"] = {1, 26},
}

include("cl_envmapfix.lua")
include("cl_hud.lua")
include("cl_menus.lua")
include("cl_scoreboard.lua")
include("cl_spec.lua")
include("cl_view.lua")
include("shared.lua")
include("gsrchud.lua")

function GetKeyFromBind(bind, bind1)
	bind, bind1 = tostring(bind), tostring(bind1)
	local lookup = input.LookupBinding
	bind = lookup(bind) or lookup(bind1) or "NO KEY"
	return string.upper(bind)
end

local function LoadCustomLangFile(lang)	
	local path = "hl1coop/lang/"
	local langFiles = file.Find(path.."*_"..lang..".lua", "LUA")
	for k, v in ipairs(langFiles) do
		include(path..v)
		print("Loaded custom language file: "..path..v)
	end
end
include("lang/lang_en.lua")
LoadCustomLangFile("en")
local lang_cvar = CreateClientConVar("hl1_coop_cl_lang", "", true)
function GM:GetLanguage()
	return lang_cvar:GetString()
end
function GM:IsLanguageSet()
	return self:GetLanguage() != ""
end
function GM:SetLanguage(newlang)
	local path = self.FolderName.."/gamemode/lang/lang_"
	include(path.."en.lua")	
	if newlang != "" and newlang != "en" then
		local lang_file = path..newlang..".lua"
		if file.Exists(lang_file, "LUA") then
			include(lang_file)
		end
	end
	
	LoadCustomLangFile("en")
	LoadCustomLangFile(newlang)
end
cvars.AddChangeCallback("hl1_coop_cl_lang", function(cvar, old, new)
	GAMEMODE:SetLanguage(new)
end)
if lang_cvar:GetString() != "en" then
	local lang_file = "lang/lang_"..lang_cvar:GetString()..".lua"
	if file.Exists(GM.FolderName.."/gamemode/"..lang_file, "LUA") then
		include(lang_file)
	end
	LoadCustomLangFile(lang_cvar:GetString())
end

function LangString(str)
	-- if !lang then
		-- print("ERROR: Language table not found!")
	-- elseif !lang[str] then
		-- print("WARNING: Language string not found: "..str)
	-- else
		-- return lang[str]
	-- end
	return lang and lang[str] or str
end

function ConvertToLang(msg)
	local str = msg
	if istable(msg) then
		str = msg[1]
	end
	if lang then
		if string.find(str, "#") then
			local str_t = string.Explode(" ", str)
			if #str_t > 0 then
				for i = 1, #str_t do
					local langtext = string.Replace(str_t[i], "#", "")
					if lang[langtext] then
						str_t[i] = lang[langtext]
					else
						local str_n = string.Split(str_t[i], "\n")
						if str_n and istable(str_n) and #str_n > 0 then
							for i = 1, #str_n do
								local langtext = string.Replace(str_n[i], "#", "")
								if lang[langtext] then
									str_n[i] = lang[langtext]
								end
							end
							str_t[i] = table.concat(str_n, "\n")
						end
					end
				end
			end
			str = table.concat(str_t, " ")
			if istable(msg) and #msg > 1 then
				for i = 2, #msg do
					str = str:gsub("%%" .. i-1 .. "%%", msg[i])
				end
			end
		end
	end
	return str
end

local cvar_debug_cl = CreateClientConVar("_hl1coop_debug_client", 0, false, false, "Print clientside debug info in console", 0, 1)
CreateClientConVar("hl1_coop_cl_autoswitch", 1, true, true, "Enable weapon autoswitch on pickup", 0, 1)
CreateClientConVar("hl1_coop_cl_playermodel", "Helmet (HLS)", true, true, "Player model")
CreateClientConVar("hl1_coop_cl_playermodel_skin", "0", true, true, "Player model skin")
CreateClientConVar("hl1_coop_cl_playermodel_bodygroups", "", true, true, "Player model bodygroups")
CreateClientConVar("hl1_coop_cl_playercolor", "", true, true, "Player model color")
cvar_thirdperson = CreateClientConVar("hl1_coop_cl_thirdperson", 0, false, false, "Enable third person view", 0, 1)
cvar_showtriggers = CreateClientConVar("_hl1coop_showtriggers", 0, false, false, nil, 0, 1)
cvar_showclips = CreateClientConVar("_hl1coop_showclips", 0, false, false, nil, 0, 1)

cvars.AddChangeCallback("hl1_coop_cl_thirdperson", function(cvar, old, new)
	new = tonumber(new)
	if new > 0 then
		RestoreRagdoll()
	end
end)
--[[local function SetLongJumpClient(ply, b, silent)
	ply.HasLongJump = b
	if b and !silent then
		timer.Simple(.5, function()
			if IsValid(ply) and ply:Alive() and ply:GetLongJump() then
				GAMEMODE:PlayerShowScreenHint(1, 8)
			end
		end)
	end
end

net.Receive("SetLongJumpClient", function()
	local ply = LocalPlayer()
	local b = net.ReadBool()
	local silent = net.ReadBool()
	if IsValid(ply) then
		SetLongJumpClient(ply, b, silent)
	else
		timer.Simple(2, function()
			ply = LocalPlayer()
			if IsValid(ply) then
				SetLongJumpClient(ply, b, silent)
			end
		end)
	end
end)]]

function debugPrintClient(...)
	if cvar_debug_cl:GetBool() then
		print(...)
	end
end

net.Receive("SetGlobalBoolFix", function()
	SetGlobalBool(net.ReadString(), net.ReadBool())
end)
net.Receive("SetGlobalFloatFix", function()
	SetGlobalFloat(net.ReadString(), net.ReadFloat())
end)
net.Receive("SetGlobalIntFix", function()
	SetGlobalInt(net.ReadString(), net.ReadInt(16))
end)

net.Receive("PlayClientSound", function()
	surface.PlaySound(net.ReadString())
end)

net.Receive("EmitClientSound", function()
	local snd, pitch = net.ReadString(), net.ReadUInt(9)
	local ply = LocalPlayer()
	if IsValid(ply) then
		ply:EmitSound(snd, 0, pitch)
	end
end)

net.Receive("SendConnectingPlayers", function()
	CONNECTING_PLAYERS_TABLE = net.ReadTable()
end)

net.Receive("SetEntityPlayerColor", function()
	local ent, col = net.ReadEntity(), net.ReadVector()
	if IsValid(ent) then
		ent.GetPlayerColor = function() return col end
	end
end)

function ChatMessage(text, Type)
	local col = color_white
	if Type == 0 then
		col = Color(160, 255, 160) -- green, server messages
	elseif Type == 2 then
		col = Color(255, 160, 0) -- orange, gamemode chat notifies
	elseif Type == 3 then
		col = Color(0, 200, 255) -- blue, vote
	elseif Type == 4 then
		col = Color(255, 70, 60) -- red, warnings or errors
	elseif Type == 5 then
		col = Color(220, 190, 80) -- pale yellow, other chat notifications
	end
	chat.AddText(col, text)
	
	if hook.Run("IsLobbyChatValid") then
		local lobbyChat = GAMEMODE.LobbyChat
		lobbyChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
		lobbyChat.richText:AppendText(text.."\n")
	end
end

net.Receive("ChatMessage", function()
	local text = net.ReadTable()
	text = ConvertToLang(text)
	local Type = net.ReadUInt(4)
	ChatMessage(text, Type)
end)

net.Receive("GibPlayer", function()
	local pos, force, amount, ent = net.ReadVector(), net.ReadVector(), net.ReadUInt(8), net.ReadEntity()
	GAMEMODE:GibEntity(pos, amount, force, 0, ent)
end)

net.Receive("LastCheckpointPos", function()
	LAST_CHECKPOINT = net.ReadVector()
end)

net.Receive("ApplyViewModelHands", function()
	local wep = net.ReadEntity()
	if IsValid(wep) then
		GAMEMODE:ApplyViewModelHands(LocalPlayer(), wep)
	else
		timer.Simple(.1, function()
			GAMEMODE:ApplyViewModelHands()
		end)
	end
end)

function IsHLSMounted()
	return IsMounted("hl1") or IsMounted("hl1mp")
end

function IsWSAddonMounted(id)
	id = tostring(id)
	local addonExists = false
	for k, v in pairs(engine.GetAddons()) do
		if v.wsid == id then
			addonExists = true
			return v.mounted
		end
	end
	if !addonExists then
		print("Couldn't find installed addon with id "..id)
	end
end

HL1Maps = {
	["c0a0"] = "hls00amrl",
	["c0a0a"] = "hls00amrl",
	["c0a0b"] = "hls00amrl",
	["c0a0c"] = "hls00amrl",
	["c0a0d"] = "hls00amrl",
	["c0a0e"] = "hls00amrl",
	["c1a0"] = "hls01amrl",
	["c1a0a"] = "hls01amrl",
	["c1a0b"] = "hls01amrl",
	["c1a0c"] = "hls02amrl",
	["c1a0d"] = "hls01amrl",
	["c1a0e"] = "hls01amrl",
	["c1a1"] = "hls02amrl",
	["c1a1a"] = "hls02amrl",
	["c1a1b"] = "hls02amrl",
	["c1a1c"] = "hls02amrl",
	["c1a1d"] = "hls02amrl",
	["c1a1f"] = "hls02amrl",
	["c1a1g"] = "hls02amrl",
	["c1a2"] = "hls03amrl",
	["c1a2a"] = "hls03amrl",
	["c1a2b"] = "hls03amrl",
	["c1a2c"] = "hls03amrl",
	["c1a2d"] = "hls03amrl",
	["c1a3"] = "hls04amrl",
	["c1a3a"] = "hls04amrl",
	["c1a3b"] = "hls04amrl",
	["c1a3c"] = "hls04amrl",
	["c1a3d"] = "hls04amrl",
	["c1a4"] = "hls05amrl",
	["c1a4b"] = "hls05bmrl",
	["c1a4d"] = "hls05bmrl",
	["c1a4e"] = "hls05bmrl",
	["c1a4f"] = "hls05bmrl",
	["c1a4g"] = "hls05bmrl",
	["c1a4i"] = "hls05bmrl",
	["c1a4j"] = "hls05bmrl",
	["c1a4k"] = "hls05bmrl",
	["c2a1"] = "hls06amrl",
	["c2a1a"] = "hls06amrl",
	["c2a1b"] = "hls06amrl",
	["c2a2"] = "hls07amrl",
	["c2a2a"] = "hls07amrl",
	["c2a2b1"] = "hls07amrl",
	["c2a2b2"] = "hls07amrl",
	["c2a2c"] = "hls07amrl",
	["c2a2d"] = "hls07amrl",
	["c2a2e"] = "hls07amrl",
	["c2a2f"] = "hls07bmrl",
	["c2a2g"] = "hls07bmrl",
	["c2a2h"] = "hls07bmrl",
	["c2a3"] = "hls08amrl",
	["c2a3a"] = "hls08amrl",
	["c2a3b"] = "hls08amrl",
	["c2a3c"] = "hls08amrl",
	["c2a3d"] = "hls08amrl",
	["c2a3e"] = "hls09amrl",
	["c2a4"] = "hls09amrl",
	["c2a4a"] = "hls09amrl",
	["c2a4b"] = "hls09amrl",
	["c2a4c"] = "hls09amrl",
	["c2a4d"] = "hls10amrl",
	["c2a4e"] = "hls10amrl",
	["c2a4f"] = "hls10amrl",
	["c2a4g"] = "hls10amrl",
	["c2a5"] = "hls11amrl",
	["c2a5a"] = "hls11amrl",
	["c2a5b"] = "hls11bmrl",
	["c2a5c"] = "hls11bmrl",
	["c2a5d"] = "hls11cmrl",
	["c2a5e"] = "hls11cmrl",
	["c2a5f"] = "hls11cmrl",
	["c2a5g"] = "hls11cmrl",
	["c2a5w"] = "hls11amrl",
	["c2a5x"] = "hls11amrl",
	["c3a1"] = "hls12amrl",
	["c3a1a"] = "hls12amrl",
	["c3a1b"] = "hls12amrl",
	["c3a2"] = "hls13amrl",
	["c3a2a"] = "hls13amrl",
	["c3a2b"] = "hls13amrl",
	["c3a2c"] = "hls13amrl",
	["c3a2d"] = "hls13amrl",
	["c3a2e"] = "hls13amrl",
	["c3a2f"] = "hls13amrl",
	["c4a1"] = "hls14amrl",
	["c4a1a"] = "hls14amrl",
	["c4a1b"] = "hls14amrl",
	["c4a1c"] = "hls14bmrl",
	["c4a1d"] = "hls14bmrl",
	["c4a1e"] = "hls14bmrl",
	["c4a1f"] = "hls14bmrl",
	["c4a2"] = "hls14amrl",
	["c4a2a"] = "hls14amrl",
	["c4a2b"] = "hls14amrl",
	["c4a3"] = "hls14сmrl",
	["c5a1"] = "hls14сmrl",
	["t0a0"] = "hls_hc",
	["t0a0a"] = "hls_hc",
	["t0a0b1"] = "hls_hc",
	["t0a0b2"] = "hls_hc",
	["t0a0c"] = "hls_hc",
	["t0a0d"] = "hls_hc",
}

function IsUnsupportedMap()
	return HL1Maps[game.GetMap()]
end

local warn_cvar = CreateClientConVar("hl1_coop_cl_nocontentwarning", 0, true, false, "Don't show content warning window", 0, 1)

local function HLSContentCheck(delay)
	if !warn_cvar:GetBool() and !IsHLSMounted() and !file.Exists("materials/halflife/c1a0_c1.vtf", "GAME") then
		hook.Run("OpenMountMenu", delay)
		contentWindowRepeatTime = RealTime() + 15
	elseif contentWindowRepeatTime then
		contentWindowRepeatTime = nil
	end
end

-- local bindDefKeys = {
	-- ["gm_showhelp"] = "F1",
	-- ["gm_showteam"] = "F2",
	-- ["gm_showspare1"] = "F3",
	-- ["gm_showspare2"] = "F4"
-- }

-- local function CheckBinds()
	-- for k, v in SortedPairsByValue(bindDefKeys) do
		-- if GetKeyFromBind(k) == "NO KEY" then
			-- ChatMessage("WARNING! "..k.." is not bound! Expected key: "..v, 4)
		-- end
	-- end
-- end

local initCallSuccess

function GM:InitPostEntity()	
	initCallSuccess = true

	if engine.IsPlayingDemo() then
		SetGlobalInt("HL1CoopState", COOP_STATE_INGAME)
	end
	
	net.Start("PlayerHasFullyLoaded")
	net.SendToServer()
	--LocalPlayer().afkTime = RealTime()
	
	if IsUnsupportedMap() then
		self:ReadFuckingDescription()
		return
	end
	
	if game.SinglePlayer() and MAP.ShowIntro then
		hook.Run("GameIntro")
	end
	
	if self:IsCoop() then
		if lang_cvar:GetString() != "" then
			if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
				hook.Run("OpenStartMenu")
			end
		else
			if GAMEMODE:GetCoopState() != COOP_STATE_ENDTITLES then
				hook.Run("OpenLanguageMenu")
			end
		end
	end
	
	HLSContentCheck()
	-- CheckBinds()
	
	hook.Run("FixMapSpecular")
end

function GM:InputMouseApply()
	return self:ShouldLockMovement()
end

function GM:CreateMove(cmd)
	local ply = LocalPlayer()

	if self:ShouldLockMovement() then
		cmd:ClearButtons()
		return
	end

	if !ply:Alive() and ply:Team() != TEAM_SPECTATOR and ply:GetObserverMode() == OBS_MODE_NONE then cmd:ClearMovement() end
	
	if GAMEMODE:GetSpeedrunMode() and ply:WaterLevel() < 3 and ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK and !ply:InVehicle() then
		if bit.band(cmd:GetButtons(), IN_JUMP) != 0 then
			if !ply:IsOnGround() then
				cmd:SetButtons(bit.band(cmd:GetButtons(), bit.bnot(IN_JUMP)))
			end
		end
	end

	if GAMEMODE:GetCoopState() != COOP_STATE_TRANSITION and !self:PlayerHasSeenHint(1) and ply:GetLongJump() and cmd:GetButtons() == IN_FORWARD then
		timer.Simple(3, function()
			if IsValid(ply) and ply:GetLongJump() then
				self:PlayerShowScreenHint(1, 8)
			end
		end)
	end
end

function GM:Think()
	if !initCallSuccess then
		hook.Run("InitPostEntity")
		print("InitPostEntity called from Think!")
	end
	
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD and !self:IsStartMenuOpen() and !self:IsLanguageMenuOpen() and !gui.IsGameUIVisible() and !IsUnsupportedMap() then
		hook.Run("OpenStartMenu")
	end

	if contentWindowRepeatTime and contentWindowRepeatTime <= RealTime() then
		HLSContentCheck(3)
	end

	if self:GetCrackMode() then
		for _, npc in ipairs(ents.FindByClass("monster_*")) do
			if npc:IsNPC() then
				hook.Run("CrackModeNPCThink", npc)
			end
		end
	end
end

function GM:OnPlayerChat(ply, strText, bTeamOnly, bPlayerIsDead)	
	local tab = {}

	if IsValid(ply) then
		if ply:Team() != TEAM_SPECTATOR then
			if bPlayerIsDead and GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
				table.insert( tab, Color( 255, 30, 40 ) )
				table.insert( tab, "*DEAD* " )
			end
		else
			table.insert( tab, Color( 220, 220, 220 ) )
			table.insert( tab, "[SPEC] " )
		end
	end

	if ( bTeamOnly ) then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end

	if ( IsValid( ply ) ) then
		table.insert( tab, ply )
	else
		table.insert( tab, "Console" )
	end

	table.insert( tab, color_white )
	table.insert( tab, ": " .. strText )
	
	chat.AddText( unpack(tab) )
	
	--surface.PlaySound( "common/menu2.wav" )
	
	if hook.Run("IsLobbyChatValid") then
		local col = self:GetTeamColor(ply)
		local nick = IsValid(ply) and ply:Nick() or "Console"
		local lobbyChat = self.LobbyChat
		lobbyChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
		lobbyChat.richText:AppendText(nick)

		lobbyChat.richText:InsertColorChange(255, 255, 255, 255)
		lobbyChat.richText:AppendText(": "..strText.."\n")
		
		if hook.Run("IsLobbyChatVisible") then
			surface.PlaySound("common/menu2.wav")
		end
	end
	
	strText = string.lower(strText)
	if string.StartWith(strText, "!") or string.StartWith(strText, "/") then
		strText = string.SetChar(strText, 1, "")
		hook.Run("OnChatCommand", strText)
	end

	return true
end

function GM:OnChatCommand(command)
	if command == "content" and !IsHLSMounted() then
		hook.Run("OpenMountMenu", 0)
	end
end

function GM:OnSpawnMenuOpen()
	if !self.IsSandboxDerived then
		RunConsoleCommand("lastinv")
	else
		self.BaseClass:OnSpawnMenuOpen()
	end
end

function GM:OnContextMenuOpen()	
	local ply = LocalPlayer()
	if ply:GetViewEntity() != ply then
		RunConsoleCommand("chase")
	else
		RunConsoleCommand("showdist")
	end
	
	if self.IsSandboxDerived then
		self.BaseClass:OnContextMenuOpen()
	end
end

local hudHide = {
	["CHudAmmo"] = true,
	["CHudBattery"] = true,
	["CHudHealth"] = true
}
local hudAlwaysHide = {
	["CHUDQuickInfo"] = true,
	["CHudTrain"] = true,
	["CHudCloseCaption"] = true
}

function GM:HUDShouldDraw(name)
	local ply = LocalPlayer()
	if IsValid(ply) then
		if name == "CHudCrosshair" then return IsValid(ply:GetActiveWeapon())
		elseif name == "CHudDamageIndicator" then return ply:Team() != TEAM_SPECTATOR and ply:Team() != TEAM_UNASSIGNED
		elseif hudHide[name] then return !ply:IsChasing() end
	end
	if name == "CHudChat" then return !hook.Run("IsLobbyChatVisible") end
	return !hudAlwaysHide[name]
end

function GM:GibEntity(pos, amount, force, gibtype, ent)
	gibtype = gibtype or 0
	local effectdata = EffectData()
	effectdata:SetFlags(1)
	effectdata:SetOrigin(pos)
	effectdata:SetNormal(force)
	effectdata:SetScale(amount)
	effectdata:SetMaterialIndex(gibtype)
	if ent and IsValid(ent) then
		effectdata:SetEntity(ent)
		ent.GibTable = {}
	else
		effectdata:SetEntity(NULL)
	end
	util.Effect("hl1_gib_emitter", effectdata, true)
end

local function IsServerRagdoll(ent)
	return ent:GetClass() == "prop_ragdoll"
end

net.Receive("RagdollGib", function()
	local pos, dmg, radius = net.ReadVector(), net.ReadFloat(), net.ReadFloat()
	for k, v in pairs(ents.FindInSphere(pos, radius)) do
		if v:IsRagdoll() and !v:GetRagdollOwner():IsPlayer() and !IsServerRagdoll(v) then
			local ragdollPos = v:GetPos()
			
			local tr = util.TraceLine({
				start = pos,
				endpos = ragdollPos,
				filter = v,
				mask = MASK_SOLID_BRUSHONLY
			})
			
			if !tr.HitWorld then
				local dir = ragdollPos - pos
				local force = dmg / dir:Length()
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:SetPos((ragdollPos + dir * force / 2) + Vector(0,0,30))
				end
				local gibType = GAMEMODE.RagdollGibModels[v:GetModel()]
				if gibType and force > 1 then
					v:Remove()
					GAMEMODE:GibEntity(ragdollPos, gibType[2], dir:GetNormalized(), gibType[1])
				end
			end
		end
	end
end)

function GM:PostPlayerDraw(ply)
	local pl = LocalPlayer()
	local actwep = pl:GetActiveWeapon()
	local medkitActive = IsValid(actwep) and actwep:GetClass() == "weapon_healthkit" and table.Count(pl:GetWeapons()) > 1
	if IsValid(ply) and ((!ShowPlayerDist or ShowPlayerDist < RealTime() and !medkitActive) or ply == pl) then
		local Time = ply:GetNWFloat("CallMedicTime") - CurTime()
		if Time > 0 then
			local pos = ply:GetPos()
			local ang = pl:EyeAngles()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			local alert = math.Clamp(math.sin(RealTime() * 20) * 100, 0, 1)
			cam.Start3D2D(pos + Vector(0, 0, 82), Angle(0, ang.y, 90), .8)
				draw.DrawText("MEDIC!", "Trebuchet18", 0, 0, Color(255 * alert, 80 * alert, 0, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end

function GM:PlayerBindPress(ply, bind, pressed)
	if (bind == "undo" or bind == "gmod_undo") and !game.SinglePlayer() and !self.IsSandboxDerived then
		RunConsoleCommand("callmedic")
	end	
    if bind == "messagemode" or bind == "messagemode2" then
		return hook.Run("IsLobbyChatVisible")
	end
end

function GM:PreDrawPlayerHands(hands, vm, ply, wep)
	if IsValid(wep) then
		ply = wep:GetOwner()
		if IsValid(ply) then
			return !ply:ShouldUseHands() and wep:IsSwitchableHandsWeapon()
		end
	end
end

net.Receive("HL1Music", function()
	local musicFile = net.ReadString()
	if string.len(musicFile) > 0 then
		GAMEMODE:PlayMusic(musicFile)
	else
		GAMEMODE:StopMusic()
	end
end)

MUSIC_TRACK_DURATION = {
	["HL1_Music.track_2"] = 132,
	["song_hl1_3"] = 132,
	["HL1_Music.track_4"] = 62,
	["HL1_Music.track_5"] = 98,
	["HL1_Music.track_6"] = 102,
	["HL1_Music.track_7"] = 25,
	["HL1_Music.track_8"] = 11,
	["HL1_Music.track_9"] = 95,
	["HL1_Music.track_10"] = 107,
	["HL1_Music.track_11"] = 85,
	["HL1_Music.track_12"] = 130,
	["HL1_Music.track_13"] = 38,
	["HL1_Music.track_14"] = 75,
	["HL1_Music.track_15"] = 121,
	["HL1_Music.track_16"] = 18,
	["HL1_Music.track_17"] = 126,
	["HL1_Music.track_18"] = 102,
	["HL1_Music.track_19"] = 118,
	["HL1_Music.track_20"] = 87,
	["HL1_Music.track_21"] = 87,
	["HL1_Music.track_22"] = 83,
	["HL1_Music.track_23"] = 112,
	["HL1_Music.track_24"] = 79,
	["HL1_Music.track_25"] = 102,
	["HL1_Music.track_26"] = 40,
	["HL1_Music.track_27"] = 19,
	["HL1_Music.track_28"] = 8,

	["song0"] = 40,
	["song1"] = 98,
	["song2"] = 173,
	["song3"] = 91,
	["song4"] = 66,
	--["song5"] = ,
	["song6"] = 45,
	["song7"] = 51,
	["song8"] = 60,
	["song10"] = 29,
	["song11"] = 35,
	--["song12_short"] = ,
	["song12_long"] = 73,
	["song13"] = 54,
	["song14"] = 159,
	["song15"] = 69,
	["song16"] = 170,
	["song17"] = 61,
	["song19"] = 116,
	["song20_submix0"] = 103,
	["song20_submix4"] = 140,
	["song23"] = 43,
	--["song24"] = ,
	["song25"] = 46,
	["song26"] = 70,
	["song26_trainstation1"] = 91,
	["song27"] = 72,
	["song28"] = 13,
	["song29"] = 136,
	["song30"] = 104,
	["song31"] = 99,
	["song32"] = 43,
	["song33"] = 84,
	["song_intro"] = 85,
	["song_Ravenholm"] = 31,
}

local music
local musicDuration
function GM:PlayMusic(musicFile, vol)
	if musicFile then
		local fadeTime = 3.5
		if music and music:IsPlaying() then
			if musicDuration and musicDuration > SysTime() then
				music:FadeOut(fadeTime)
			else
				music:Stop()
			end
		end
		local ply = LocalPlayer()
		if IsValid(ply) then
			music = CreateSound(ply, musicFile)
		end
		if music then
			local dur = MUSIC_TRACK_DURATION[musicFile]
			vol = vol or 1 --cvars.Number("snd_musicvolume", 1)
			music:PlayEx(vol, 100)
			if dur then musicDuration = SysTime() + dur - fadeTime end
		end
	end
end
function GM:StopMusic(fade)
	if music and music:IsPlaying() then
		if fade and fade > 0 and musicDuration and musicDuration > SysTime() then
			music:FadeOut(fade)
		else
			music:Stop()
		end
	end
end

function CanReachNearestTeleport()
	local ply = LocalPlayer()
	local plypos = ply:GetPos()
	if telePosTable and #telePosTable > 0 then
		table.sort(telePosTable, function(a,b) return a:DistToSqr(plypos) < b:DistToSqr(plypos) end)
		local tr = util.TraceLine({
			start = ply:EyePos(),
			endpos = telePosTable[1],
			filter = ply,
			mask = MASK_SOLID_BRUSHONLY
		})
		return tr.StartPos:Distance(tr.HitPos) >= 1000 or tr.Hit
	end
end

concommand.Add("hl1_coop_version", function()
	print(GAMEMODE.Name.." "..GAMEMODE.Version)
end)



function GM:PostReloadToolsMenu()
	for k, v in pairs(g_SpawnMenu.CreateMenu:GetItems()) do
		if v.Name == "#spawnmenu.category.weapons" then
			g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
		end
	end
end

function GM:PopulateWeapons_New(pnlContent, tree, node)

	local blacklisted = {
		["weapon_hl1_crowbar"] = true,
		["weapon_hl1_glock"] = true,
		["weapon_hl1_357"] = true,
		["weapon_hl1_mp5"] = true,
		["weapon_hl1_shotgun"] = true,
		["weapon_hl1_crossbow"] = true,
		["weapon_hl1_rpg"] = true,
		["weapon_hl1_gauss"] = true,
		["weapon_hl1_egon"] = true,
		["weapon_hl1_hornetgun"] = true,
		["weapon_hl1_handgrenade"] = true,
		["weapon_hl1_satchel"] = true,
		["weapon_hl1_tripmine"] = true,
		["weapon_hl1_snark"] = true,
		["weapon_glock_hl1"] = true,
		["weapon_mp5_hl1"] = true,
		["weapon_shotgun_hl1"] = true
	}

	local Weapons = list.Get( "Weapon" )
	local Categorised = {}

	for k, weapon in pairs( Weapons ) do

		if !weapon.Spawnable or blacklisted[weapon.ClassName] then continue end

		Categorised[ weapon.Category ] = Categorised[ weapon.Category ] or {}
		table.insert( Categorised[ weapon.Category ], weapon )

	end

	Weapons = nil

	for CategoryName, v in SortedPairs( Categorised ) do

		local node = tree:AddNode( CategoryName, "icon16/gun.png" )

		node.DoPopulate = function( self )

			if ( self.PropPanel ) then return end

			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
			
				local icon = "entities/" .. ent.ClassName .. ".png"
				if GetHL1WeaponClassTable_Alt()[ent.ClassName] then
					local newName = string.Replace(ent.ClassName, "weapon_", "weapon_hl1_")
					icon = "entities/" .. newName .. ".png"
				end

				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", self.PropPanel, {
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.ClassName,
					material	= icon,
					admin		= ent.AdminOnly
				} )

			end

		end

		node.DoClick = function( self )

			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )

		end

	end

	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end
	
spawnmenu.AddCreationTab( "Weapons", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "weapons", "PopulateWeapons_New" )
	ctrl:CallPopulateHook( "PopulateWeapons_New" )
	return ctrl

end, "icon16/gun.png", 10 )