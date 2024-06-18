AddCSLuaFile("cl_envmapfix.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_spec.lua")
AddCSLuaFile("cl_view.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_chatsounds.lua")
AddCSLuaFile("sh_entity.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("sh_skill.lua")
AddCSLuaFile("sh_crackmode.lua")
AddCSLuaFile("gsrchud.lua")
AddCSLuaFile("hl1_soundscripts.lua")
AddCSLuaFile("conflictfix.lua")

local lang_files = file.Find(GM.FolderName.."/gamemode/lang/*", "LUA")
for k, v in ipairs(lang_files) do
	AddCSLuaFile("lang/"..v)
end

MAX_DROPPED_WEAPONS = 10
FLASHLIGHT_DRAIN_DELAY = 0.75
FLASHLIGHT_GAIN_DELAY = 0.1
SPAWN_PROTECTION_TIME = 2

WEAPONBOX_THROWABLES = {
	["Grenade"] = "weapon_handgrenade",
	["Satchel"] = "weapon_satchel",
	["TripMine"] = "weapon_tripmine",
	["Snark"] = "weapon_snark"
}

WEAPONBOX_AMMO_MAX_VALUES = {
	["9mmRound"] = 250,
	["357"] = 36,
	["Buckshot"] = 125,
	["XBowBolt"] = 50,
	["RPG_Round"] = 5,
	["Uranium"] = 100,
	["Hornet"] = 8,
	["Grenade"] = 10,
	["Satchel"] = 5,
	["TripMine"] = 5,
	["Snark"] = 15,
	["MP5_Grenade"] = 10
}

GM.WeaponRespawnTime = .5

GM.NPCScorePrice = {
	["monster_scientist"] = -20,
	["monster_sitting_scientist"] = -20,
	["monster_barney"] = -10,

	["monster_cockroach"] = 1,
	["monster_leech"] = 1,
	["monster_babycrab"] = 5,
	["monster_headcrab"] = 10,
	["monster_sentry"] = 15,
	["monster_zombie"] = 20,
	["monster_houndeye"] = 20,
	["monster_miniturret"] = 20,
	["monster_turret"] = 30,
	["monster_alien_slave"] = 30,
	["monster_alien_controller"] = 30,
	["monster_bullchicken"] = 30,
	["monster_human_grunt"] = 50,
	["monster_ichthyosaur"] = 60,
	["monster_alien_grunt"] = 70,
	["monster_human_assassin"] = 80,
	["monster_gargantua"] = 0,
	["hornet"] = 0,
	["monster_snark"] = 0,
	["monster_bigmomma"] = 0,
	["monster_nihilanth"] = 0,
	["monster_generic"] = 0,
	
	-- VJ HLR
	
	["npc_vj_hlr1_scientist"] = -20,
	["npc_vj_hlrof_cleansuitsci"] = -20,
	["npc_vj_hlrbs_rosenberg"] = -20,
	["npc_vj_hlrdc_keller"] = -20,
	["npc_vj_hlr1_securityguard"] = -10,
	["npc_vj_hlrof_otis"] = -10,
	
	["npc_vj_hlr1_cockroach"] = 1,
	["npc_vj_hlr1_barnacle"] = 10,
	["npc_vj_hlr1_headcrab"] = 10,
	["npc_vj_hlr1_houndeye"] = 20,
	["npc_vj_hlr1_archer"] = 20,
	["npc_vj_hlr1_zombie"] = 20,
	["npc_vj_hlrof_zombie_sec"] = 30,
	["npc_vj_hlrof_zombie_soldier"] = 30,
	["npc_vj_hlr1_alienslave"] = 30,
	["npc_vj_hlr1_bullsquid"] = 30,
	["npc_vj_hlr1_floater"] = 30,
	["npc_vj_hlr1_aliencontroller"] = 30,
	["npc_vj_hlr1_panthereye"] = 40,
	["npc_vj_hlrof_pitdrone"] = 40,
	["npc_vj_hlr1_hgrunt"] = 50,
	["npc_vj_hlrof_gonome"] = 60,
	["npc_vj_hlrof_voltigore_baby"] = 60,
	["npc_vj_hlr1_aliengrunt"] = 70,
	["npc_vj_hlrof_shocktrooper"] = 80,
	["npc_vj_hlr1_hgrunt_serg"] = 100,
	["npc_vj_hlrof_voltigore"] = 200,
	["npc_vj_hlrsv_garg_baby"] = 250,
	["npc_vj_hlr1_garg"] = 500,
	
	["npc_vj_hlr1a_scientist"] = -20,
	["npc_vj_hlr1a_securityguard"] = -10,
	["npc_vj_hlr1a_headcrab"] = 20,
	["npc_vj_hlr1a_zombie"] = 20,
	["npc_vj_hlr1a_hgrunt"] = 50,
	["npc_vj_hlr1a_bullsquid"] = 120,
}

GM.NPCScorePriceDamageMul = {
	["monster_apache"] = 1,
	["monster_osprey"] = 1,
	["monster_bigmomma"] = 1,
	["monster_gargantua"] = 1,
	["monster_nihilanth"] = 1,
}

GM.NPCsNiceNames = {
	["monster_barney"] = "Security Guard",
	["monster_scientist"] = "Scientist",
}

GM.replaceEntsInBoxes = {
	["item_ammo_pistol"] = "weapon_glock",
	["item_ammo_pistol_large"] = "ammo_9mmclip",
	["item_ammo_smg1"] = "weapon_mp5",
	["item_ammo_smg1_large"] = "ammo_9mmAR",
	["item_ammo_ar2"] = "ammo_ARgrenades",
	["item_ammo_ar2_large"] = "weapon_shotgun",
	["item_box_buckshot"] = "ammo_buckshot",
	["item_flare_round"] = "weapon_crossbow",
	["item_box_flare_rounds"] = "ammo_crossbow",
	["item_rpg_round"] = "weapon_357",
	["unused (item_smg1_grenade) 13"] = "ammo_357",
	["item_box_sniper_rounds"] = "weapon_rpg",
	["unused (???) 15"] = "ammo_rpgclip",
	["weapon_stunstick"] = "ammo_gaussclip",
	["unused (weapon_ar1) 17"] = "weapon_handgrenade",
	["weapon_ar2"] = "weapon_tripmine",
	["unused (???) 19"] = "weapon_satchel",
	["weapon_rpg"] = "weapon_snark",
	["weapon_smg1"] = "weapon_hornetgun",
	["weapon_9mmar"] = "weapon_mp5",
	["weapon_9mmhandgun"] = "weapon_glock"
}

include("shared.lua")
include("sv_entreplace.lua")
include("sv_hev.lua")
include("sv_spec.lua")
include("sv_vote.lua")
include("sv_resource.lua")
include("sv_transition.lua")

util.AddNetworkString("HL1DeathMenu")
util.AddNetworkString("HL1DeathMenuRemove")
util.AddNetworkString("HL1StartMenu")
util.AddNetworkString("HL1ChapterPreStart")
util.AddNetworkString("HL1ChapterStart")
util.AddNetworkString("HL1GameIntro")
util.AddNetworkString("HL1GameOver")
util.AddNetworkString("HL1Music")
util.AddNetworkString("ScreenMessageScore")
util.AddNetworkString("TextMessageCenter")
util.AddNetworkString("PlayerHasFullyLoaded")
--util.AddNetworkString("SetLongJumpClient")
util.AddNetworkString("PlayClientSound")
util.AddNetworkString("EmitClientSound")
util.AddNetworkString("GibPlayer")
util.AddNetworkString("SendConnectingPlayers")
util.AddNetworkString("ShowScreenHint")
util.AddNetworkString("ShowScreenHintTop")
util.AddNetworkString("ShowTeleportHint")
util.AddNetworkString("ShowMapRecords")
util.AddNetworkString("ChatMessage")
util.AddNetworkString("HL1DrawMessage")
util.AddNetworkString("UpdatePlayerPositions")
util.AddNetworkString("SetGlobalBoolFix")
util.AddNetworkString("SetGlobalFloatFix")
util.AddNetworkString("SetGlobalIntFix")
util.AddNetworkString("SetPlayerModel")
util.AddNetworkString("SetPlayerModelColor")
util.AddNetworkString("ApplyViewModelHands")
util.AddNetworkString("ShowCaption")
util.AddNetworkString("RagdollGib")
util.AddNetworkString("LastCheckpointPos")
util.AddNetworkString("RunServerCommand")
util.AddNetworkString("SetEntityPlayerColor")
util.AddNetworkString("HL1PickupEditor")

net.Receive("RunServerCommand", function(len, ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsAdmin() then
		RunConsoleCommand(net.ReadString(), net.ReadString())
	end
end)

function UpdateConnectingTable(ply)
	if !CONNECTING_PLAYERS_TABLE then return end
	net.Start("SendConnectingPlayers")
	net.WriteTable(CONNECTING_PLAYERS_TABLE)
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

net.Receive("PlayerHasFullyLoaded", function(len, ply)
	GAMEMODE:OnPlayerFullyLoaded(ply)
end)

net.Receive("SetPlayerModel", function(len, ply)
	if cvars.Bool("hl1_coop_sv_custommodels", false) then
		if IsValid(ply) and ply:Alive() then
			ply:SetModel(net.ReadString())
			local actWep = ply:GetActiveWeapon()
			if IsValid(actWep) then
				hook.Run("ApplyViewModelHands", ply, actWep, true)
			end
			ply:SetupHands()
		end
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "Cannot set a model due to server settings")
	end
end)

net.Receive("SetPlayerModelColor", function(len, ply)
	if IsValid(ply) and ply:Alive() then
		local col = string.Explode(" ", net.ReadString())
		if col[1] and col[2] and col[3] then
			ply:SetPlayerColor(Vector(col[1] / 255, col[2] / 255, col[3] / 255))
		end
	end
end)

local cvar_debug = CreateConVar("_hl1coop_debug", 0, FCVAR_ARCHIVE, "Print serverside debug info in console", 0, 1)
--CreateConVar("hl1_coop_limitedrespawns", 1, FCVAR_NOTIFY, "Limited continues")
local cvar_speedrun = CreateConVar("hl1_coop_mode_speedrun", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, nil, 0, 1)
local cvar_survival = CreateConVar("hl1_coop_mode_survival", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, nil, 0, 1)
local cvar_crack = CreateConVar("hl1_coop_mode_crack", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, nil, 0, 1)
local cvar_1hp = CreateConVar("hl1_coop_mode_1hp", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, nil, 0, 1)
cvar_afktime = CreateConVar("hl1_coop_sv_afktime", 300, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Move AFK player to spectators after the time in seconds", 0)
local cvar_gainnpchp = CreateConVar("hl1_coop_sv_gainnpchealth", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable increasing NPC health depending on player count", 0, 1)
local cvar_plygib = CreateConVar("hl1_coop_sv_playergib", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow player gibbing on high damage", 0, 1)
cvar_medkit = CreateConVar("hl1_coop_sv_medkit", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Give medkit in non-survival mode", 0, 1)
local cvar_firstmap = CreateConVar("hl1_coop_sv_firstmap", "", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The map that will load after game end, e.g. the lobby")
cvar_fixnihilanth = CreateConVar("hl1_coop_sv_fixnihilanth", 1)
--cvar_airaccelerate = CreateConVar("hl1_coop_sv_airaccelerate", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Air accelerate")
cvar_scoretracking = CreateConVar("hl1_coop_sv_scoretracking", 0, FCVAR_ARCHIVE, "Enable score tracking for Gametracker or other server browsers", 0, 1)
cvar_hevvoice = CreateConVar("hl1_coop_sv_hevvoice", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable HEV suit voice", 0, 1)
local cvar_assistpoints = CreateConVar("hl1_coop_sv_assistpoints", 1, FCVAR_NOTIFY, "Give assist score points depending on damage to NPC", 0, 1)
local cvar_checkpoints = CreateConVar("hl1_coop_sv_checkpoints", 1, FCVAR_NOTIFY, "Enable co-op checkpoints", 0, 1)
local cvar_unreadykicktime = CreateConVar("hl1_coop_sv_unreadykicktime", 60, FCVAR_ARCHIVE, "Time in seconds to kick unready player in lobby", 0, 999)
cvar_transparentplayers = CreateConVar("hl1_coop_sv_transparentplayers", 1, FCVAR_ARCHIVE, "Make players transparent when touching wait triggers", 0, 1)

GM.ReturnToReadyScreenTime = 120 -- when no players on server, it automatically returns to ready screen
GM.FirstSpawnAsSpectator = true

concommand.Add("unload", function(ply)
	if IsValid(ply) then
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) then
			if wep.Unload then
				wep:Unload()
			end
		end
	end
end)

concommand.Add("unstuck", function(ply)
	if IsValid(ply) and ply:IsStuck() then
		ply:Unstuck()
	end
end)

concommand.Add("callmedic", function(ply)
	ply:CallMedic()
end)

function GM:GlobalTextMessageCenter(msg, delay)
	net.Start("TextMessageCenter")
	net.WriteString(msg)
	net.WriteFloat(delay)
	net.Broadcast()
end

function GM:GlobalScreenHintTop(text, delay)
	if !istable(text) then
		text = {text}
	end
	delay = delay or 8
	net.Start("ShowScreenHintTop")
	net.WriteTable(text)
	net.WriteFloat(delay)
	net.Broadcast()
end

function ChatMessage(msg, t)
	if !istable(msg) then
		msg = {msg}
	end
	t = t or 1
	net.Start("ChatMessage")
	net.WriteTable(msg)
	net.WriteUInt(t, 4)
	net.Broadcast()
end

function SendMessage(msg, msgtype, pos, staydelay, hcol, col)
	msgtype = msgtype or 0
	pos = pos or 0
	hcol = hcol or Color(240,110,0)
	col = col or Color(100, 100, 100)
	staydelay = staydelay or 1
	net.Start("HL1DrawMessage")
	net.WriteString(msg)
	net.WriteUInt(msgtype, 4)
	net.WriteUInt(pos, 4)
	net.WriteFloat(staydelay)
	net.WriteColor(hcol)
	net.WriteColor(col)
	net.Broadcast()
end

function debugPrint(...)
	if cvar_debug:GetBool() then
		print(...)
	end
end

function GM:Initialize()
	RunConsoleCommand("sv_airaccelerate", "20")
	RunConsoleCommand("sv_gravity", "800")
	RunConsoleCommand("sv_sticktoground", "0")
	if !game.SinglePlayer() then RunConsoleCommand("ai_use_think_optimizations", "0") end
	RunConsoleCommand("ai_disabled", "0")
	RunConsoleCommand("ai_ignoreplayers", "0")
	RunConsoleCommand("ai_serverragdolls", "0")
	RunConsoleCommand("hl1_sv_loadout", "0")
	RunConsoleCommand("hl1_sv_clampammo", "1")
	RunConsoleCommand("gmod_suit", "0")
	RunConsoleCommand("func_breakdmg_club", "2")
	
	timer.Simple(0, function()
		hook.Run("SetSkillLevel")
	end)
	
	SetGlobalFloat("GameTime", -1)
	
	local hlswepsInstalled = file.Exists("weapons/weapon_hl1_base.lua", "LUA")
	if !hlswepsInstalled then
		timer.Create("ReadFuckingAddonPage", 1, 0, function() 
			PrintMessage(HUD_PRINTTALK, "HALF-LIFE SWEPS ADDON IS NOT INSTALLED! GAMEMODE IS UNPLAYABLE!")
		end)
	end
end

function GM:ShutDown()
	-- revert to default values
	RunConsoleCommand("sv_airaccelerate", "10")
	RunConsoleCommand("sv_gravity", "600")
	RunConsoleCommand("func_breakdmg_club", "1.5")
end

function GM:SetCoopState(int)
	self:SetGlobalInt("HL1CoopState", int)
end

function GM:CreateSpawnpoint(pos, ang)
	local spawnPoint = ents.Create("info_player_coop")
	if IsValid(spawnPoint) then
		spawnPoint:SetPos(pos)
		spawnPoint:SetAngles(ang)
		spawnPoint:Spawn()
		if !spawnPoint:IsInWorld() then
			spawnPoint:Remove()
		else
			debugPrint("Created spawnpoint", spawnPoint, spawnPoint:GetPos())
		end
	end
end

function GM:CreateCoopSpawnpoints(pos, ang, amount)
	--local info_player_start = ents.FindByClass("info_player_start")[1]
	--ang = self:IsCoop() and IsValid(info_player_start) and info_player_start:GetAngles() or ang
	ang = ang or Angle()
	amount = amount or game.MaxPlayers()
	local transSpawnPointFirst = ents.Create("info_player_coop")
	if IsValid(transSpawnPointFirst) then
		local tr = util.TraceHull({
			start = pos,
			endpos = pos + Vector(0,0,72),
			filter = player.GetAll(),
			mask = MASK_PLAYERSOLID,
			mins = Vector(-16, -16, 0),
			maxs = Vector(16, 16, 0)
		})
		if tr.Hit then
			pos = pos + (pos - tr.HitPos)
		end
		transSpawnPointFirst:SetPos(pos)
		transSpawnPointFirst:SetAngles(ang)
		transSpawnPointFirst:Spawn()
		if !transSpawnPointFirst:IsInWorld() then
			transSpawnPointFirst:Remove()
		end
		--print(transSpawnPointFirst, transSpawnPointFirst:GetPos(), transSpawnPointFirst:OBBMins())
	end
	if amount > 1 and self:IsCoop() and IsValid(transSpawnPointFirst) then
		for i = 2, amount do
			local vecrand = VectorRand() * i * 20
			vecrand[3] = 0
			local tr = util.TraceHull({
				start = pos,
				endpos = pos + vecrand,
				filter = player.GetAll(),
				mask = MASK_PLAYERSOLID,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 72)
			})
			local transSpawnPoint = ents.Create("info_player_coop")
			if IsValid(transSpawnPoint) then
				transSpawnPoint:SetPos(tr.HitPos)
				transSpawnPoint:SetAngles(ang)
				transSpawnPoint:Spawn()
				if !transSpawnPoint:IsInWorld() then
					transSpawnPoint:Remove()
				else
					debugPrint("Created spawnpoint", transSpawnPoint, transSpawnPoint:GetPos())
				end
			end
		end
	end
end

function GM:RemoveCoopSpawnpoints()
	local t = ents.FindByClass("info_player_coop")
	table.Add(t, ents.FindByClass("info_player_start"))
	for k, v in ipairs(t) do
		v:Remove()
		debugPrint(v, "removed")
	end
end

function GM:InitPostEntity(restart)
	if !restart then
		CallMapHook("OnMapLoaded")
		if !self:IsCoop() then
			self:SetCoopState(COOP_STATE_INGAME)
		end
	end
	
	if !self.TransitionTable then
		local datafile = "hl1_coop/transition_data.txt"
		local data = file.Read(datafile)
		if data then
			self.TransitionTable = util.JSONToTable(data)
			file.Delete(datafile)
		end
	end
	if self.TransitionTable then
		local t = self.TransitionTable
		
		self.TransitionMapName = t[1]
		local mapname = self.TransitionMapName
		local landmarkname = t[2]
		local lastmap = t[3]
		local pos = t[5]
		local ang = t[6]

		if mapname == game.GetMap() then
			if !restart then
				if self:IsCoop() then self:SetCoopState(COOP_STATE_TRANSITION) end
				if t[4] then SetGlobalFloat("GameTime", t[4]) end
				if t[7] then SESSION_ID = t[7] end
			end
			if (!MAP.BlockSpawnpointCreation or !MAP.BlockSpawnpointCreation[lastmap]) and pos and ang then
				ang[1] = 0
				ang[3] = 0
				for k, v in ipairs(ents.FindByClass("info_landmark")) do
					if v:GetInternalVariable("m_iName") == landmarkname then
						hook.Run("CreateCoopSpawnpoints", v:GetPos() + pos, ang)
					end
				end
			end
			self:RestoreTransitionEntityData()
			hook.Run("OnMapTransition", lastmap)
		end
	end
	
	self:RestorePlayerData()
	
	if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION and CONNECTING_PLAYERS_TABLE and #CONNECTING_PLAYERS_TABLE > 0 then
		SetGlobalFloat("FirstWaitingTime", SysTime() + 60)
		
		local entremove = ents.FindByClass("logic_auto")
		table.Add(entremove, ents.FindByClass("trigger_auto"))
		table.Add(entremove, ents.FindByClass("trigger_once"))
		table.Add(entremove, ents.FindByClass("trigger_multiple"))
		table.Add(entremove, ents.FindByClass("multi_manager"))
		table.Add(entremove, ents.FindByClass("monster_*"))
		table.Add(entremove, ents.FindByClass("speaker"))
		for k, v in ipairs(entremove) do
			v:Remove()
		end
	end
	
	-- remove items on first map in chapter
	--[[if self:IsCoop() or game.MapLoadType() != "transition" then
		timer.Simple(.2, function()
			local removeStuff = {}
			table.Add(removeStuff, ents.FindByClass("weapon_*"))
			table.Add(removeStuff, ents.FindByClass("item_*"))
			table.Add(removeStuff, ents.FindByClass("ammo_*"))
			for k, v in pairs(removeStuff) do
				if !v:CreatedByMap() and !IsValid(v:GetOwner()) and !v.dontRemove then
					print("Removed " .. v:GetClass(), v:GetPos())
					v:Remove()
				end
			end
		end)
	end]]--
	for k, v in ipairs(ents.FindByName("player_spawn_template")) do
		v:Remove()
	end
	
	-- fix for spawning items from breakables
	local breakables = {}
	table.Add(breakables, ents.FindByClass("func_breakable"))
	table.Add(breakables, ents.FindByClass("func_physbox"))
	for k, v in ipairs(breakables) do
		local repl = self.replaceEntsInBoxes[v:GetSaveTable().m_iszSpawnObject]
		if repl then
			v:SetSaveValue("m_iszSpawnObject", repl)
		end
	end

	CallMapHook("FixMapEntities")
	CallMapHook("CreateMapCheckpoints")
	if self:IsCoop() then
		CallMapHook("ModifyMapEntities")
		CallMapHook("CreateViewPoints")
		CallMapHook("CreateExtraEnemies")		
		hook.Run("RemoveGlobalEnvFades")
	end
	if self:GetSurvivalMode() then
		CallMapHook("CreateSurvivalEntities")
	end
	
	if game.SinglePlayer() and !restart then
		if cvar_speedrun:GetBool() and !self:GetSpeedrunMode() then
			self:SetSpeedrunMode(true, 2)
		end
		if cvar_survival:GetBool() and !self:GetSurvivalMode() then
			self:SetSurvivalMode(true)
		end
		if cvar_crack:GetBool() and !self:GetCrackMode() then
			self:SetCrackMode(true)
			hook.Run("RestartMap")
		end
		if cvar_1hp:GetBool() then
			self:Set1hpMode(true)
		end
		if !SESSION_ID then SESSION_ID = math.random(999) end
	end
end

function GM:GetMapLoadType()
	if self.TransitionMapName == game.GetMap() then return "transition" end
	return game.MapLoadType()
end

function GM:OnMapTransition(prevmap)
	CallMapHook("OnMapTransition", prevmap)
end

function GM:RemoveGlobalEnvFades()
	-- removing global fades
	for k, v in ipairs(ents.FindByClass("env_fade")) do
		if !v:HasSpawnFlags(4) and (!MAP.EnvFadeWhitelist or !MAP.EnvFadeWhitelist[v:GetName()]) then
			debugPrint("Removed global env_fade", v, v:GetName())
			v:Remove()
		end
	end
end

function GM:CreateWeaponEntity(class, pos, ang, respawnable)
	pos = pos or Vector()
	ang = ang or Angle()
	if respawnable == nil then respawnable = true end
	local wep = ents.Create(class)
	if IsValid(wep) then
		wep:SetPos(pos)
		wep:SetAngles(ang)
		if respawnable then
			wep.rRespawnable = respawnable
		end
		wep:Spawn()
	end
end

function GM:CreatePickupEntity(class, pos, ang, respawnable, respawntime)
	if respawnable == nil then respawnable = true end
	local ent = ents.Create(class)
	if IsValid(ent) then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		if respawnable then
			ent.Respawnable = respawnable
		end
		if respawntime then
			ent.RespawnTime = respawntime
		end
		ent:Spawn()
	end
end

function GM:CreatePlayerClip(mins, maxs)
	local plyClip = ents.Create("hl1_playerclip")
	if IsValid(plyClip) then
		plyClip:Spawn()
		plyClip:SetCollisionBoundsWS(mins, maxs)
		return plyClip
	end
end

function GM:CreateFallTrigger(mins, maxs)
	if !MAP.FallToDeath then
		MAP.FallToDeath = {}
	end
	local vecTable = {mins, maxs}
	if MAP.FallToDeath then
		local hasvalue
		for k, v in pairs(MAP.FallToDeath) do
			if vecTable[1] == v[1] and vecTable[2] == v[2] then
				hasvalue = true
			end
		end
		if !hasvalue then
			table.insert(MAP.FallToDeath, vecTable)
		end
	end
end

WAIT_NOMOVE, WAIT_FREEZE, WAIT_LOCK, WAIT_FREE = 0, 1, 2, 3

function GM:CreateWaitTrigger(mins, maxs, t, hev, endfunc, trigtype, finaltrig, nocollide)
	if !endfunc and game.MaxPlayers() < 2 then return end
	local wTrig = ents.Create("hl1_trigger_wait")
	if IsValid(wTrig) then
		if hev then
			wTrig.HEVRequire = true
		end
		wTrig:SetTimer(t)
		if endfunc then
			wTrig.EndFunction = endfunc
		end
		if trigtype then
			wTrig.WaitType = trigtype
		end
		if finaltrig then
			wTrig.FinalTrigger = true
		end
		if nocollide then
			wTrig.NoCollide = true
		end
		wTrig:Spawn()
		wTrig:SetCollisionBoundsWS(mins, maxs)
		
		return wTrig
	end
end

function GM:CreateTeleport(pos, dest, ang, weptable, func)
	local ent = ents.Create("hl1_teleport")
	if IsValid(ent) then
		ent:SetPos(pos)
		ent:SetDestination(dest, ang)
		if weptable then
			ent:SetWeaponTable(weptable)
		end
		if func then
			function ent:EnterEvent()
				func()
			end
		end
		ent:Spawn()
	end
end

function GM:RemovePreviousCheckpoint(except)
	local t = ents.FindByClass("hl1_teleport")
	for k, v in ipairs(t) do
		if istable(except) then
			if !table.HasValue(except, v:GetPos()) then
				v:Remove()
			end
		else
			if v:GetPos() != except then
				v:Remove()
			end
		end
	end
end

function GM:RemoveSurvivalEntities()
	if !cvar_medkit:GetBool() then
		for k, v in ipairs(ents.FindByClass("weapon_healthkit")) do
			v:Remove()
		end
	end
end

function GM:ReviveDeadPlayers(pos, ang, weptable)
	if IsEntity(pos) then
		pos = pos:GetPos() + Vector(0,0,24)
	end
	for k, v in pairs(team.GetPlayers(TEAM_COOP)) do
		if v:IsDeadInSurvival() then
			net.Start("HL1DeathMenuRemove")
			net.Send(v)
			v:ResetVars(true)
			hook.Call("PlayerLoadout", GAMEMODE, v)
			v:Spawn()
			local vecrand = VectorRand() * 96
			vecrand[3] = 0
			local tr = util.TraceHull({
				start = pos,
				endpos = pos + vecrand,
				filter = v,
				mask = MASK_PLAYERSOLID_BRUSHONLY,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 72)
			})
			local spawnPos = tr.HitPos
			local tr1 = util.TraceLine({
				start = spawnPos,
				endpos = spawnPos - Vector(0,0,64),
				filter = v,
				mask = MASK_PLAYERSOLID_BRUSHONLY
			})
			if !tr1.Hit then
				spawnPos = tr.StartPos
			end
			local findTrig = ents.FindInBox(tr1.StartPos, tr1.HitPos)
			for _, ent in pairs(findTrig) do
				if ent:GetClass() == "trigger_hurt" then
					spawnPos = tr.StartPos
				end
			end
			v:TeleportToCheckpoint(spawnPos, ang, weptable)
			if v.wboxEnt and IsValid(v.wboxEnt) then
				v.wboxEnt:SetOwner(NULL)
			end
		end
	end
end

function GM:Checkpoint(cpNum, dest, ang, telePos, ply, weptable, delay, func)
	if cpNum and LAST_CHECKPOINT_NUMBER and cpNum <= LAST_CHECKPOINT_NUMBER then return end
	
	hook.Run("RemovePreviousCheckpoint")
	if !cvar_checkpoints:GetBool() then return end
	-- some shitty code below
	if delay then
		timer.Simple(delay, function()
			if istable(telePos) then
				for k, v in pairs(telePos) do
					hook.Run("CreateTeleport", v, dest, ang, weptable, func)
				end
			else
				hook.Run("CreateTeleport", telePos, dest, ang, weptable, func)
			end
		end)
	else
		if istable(telePos) then
			for k, v in pairs(telePos) do
				hook.Run("CreateTeleport", v, dest, ang, weptable, func)
			end
		else
			hook.Run("CreateTeleport", telePos, dest, ang, weptable, func)
		end
	end
	if IsValid(ply) and ply:IsPlayer() then
		ChatMessage({"#game_checkpointpl", ply:Nick()}, 2)
	else
		ChatMessage("#game_checkpoint", 2)
	end
	
	hook.Run("SendTeleportHint")
	
	if self:GetSurvivalMode() then
		timer.Simple(1, function()
			if self:GetActivePlayersNumber() > 0 then
				hook.Run("ReviveDeadPlayers", dest, ang, weptable)
			end
		end)
	end
	
	if IsEntity(dest) then return end
	
	LAST_CHECKPOINT = {Pos = dest, Ang = ang, Weptable = weptable}
	if cpNum then LAST_CHECKPOINT_NUMBER = cpNum end
	net.Start("LastCheckpointPos")
	net.WriteVector(dest)
	net.Broadcast()
	
	for k, v in pairs(hook.Run("GetActivePlayersTable")) do
		--print(v, dest:Distance(v:GetPos()))
		if v:GetScore() >= cvar_price_movetocheckpoint:GetInt() and dest:Distance(v:GetPos()) > LAST_CHECKPOINT_MINDISTANCE then
			v:SendScreenHint(5)
			v.CanTeleportTime = CurTime() + 15
			v:SendLua("LocalPlayer().CanTeleportTime = CurTime() + 15")
		end
	end
	
	CallMapHook("OnCheckpoint", cpNum, dest, ang, ply, weptable)
end

function GM:SendTeleportHint(ply)
	local teleTable = {} 
	for k, v in ipairs(ents.FindByClass("hl1_teleport")) do
		table.insert(teleTable, v:GetPos())
	end
	net.Start("ShowTeleportHint")
	net.WriteTable(teleTable)
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function GM:CreateCheckpointTrigger(cpNum, mins, maxs, dest, destang, telePos, weptable, passfunc)
	local cpTrig = ents.Create("hl1_trigger_checkpoint")
	if IsValid(cpTrig) then
		cpTrig:SetCheckpointData(cpNum, dest, destang, telePos, weptable)
		if passfunc then
			cpTrig.PassFunction = passfunc
		end
		cpTrig:Spawn()
		cpTrig:SetCollisionBoundsWS(mins, maxs)
		return cpTrig
	end
end

function GM:GameFinished()
	if self:GetSpeedrunMode() then
		local gTime = GetGlobalFloat("GameTime")
		if gTime >= 0 then
			local mapTime = self:GetMapTime()
			local Time = FormattedTimer(mapTime)
			local gTime = GetGlobalFloat("GameTime") + mapTime
			ChatMessage("Map time: "..Time..", total game time: "..FormattedTimer(gTime))
			SetGlobalFloat("GameTime", -1)
			SetGlobalFloat("SpeedrunModeTime", CurTime() + 1000)
		end
	end
end

function GM:PlayerHasFinishedMap(ply)
	if cvars.Bool("sv_cheats") or self:GetCrackMode() or self.IsSandboxDerived or self:Get1hpMode() then return end
	local fTime = CurTime() - GetGlobalFloat("SpeedrunModeTime")
	if fTime > 0 and !ply.HasFinishedMap then
		ply.HasFinishedMap = true
		local Time = string.FormattedTime(fTime, "%02i:%02i.%03i")
		local bestTime = nil
		
		local datafile = "hl1_coop/map_records_"..game.GetMap()..".txt"
		local data = file.Read(datafile)
		if data then
			self.MapRecords = util.JSONToTable(data)
		end
		
		if !self.MapRecords then
			self.MapRecords = {}
		end
		
		if self.MapRecords then
			local plyid = ply:SteamID64()
			for k, v in pairs(self.MapRecords) do
				if v.steamid == plyid then
					if v.maptime < fTime then
						bestTime = v.maptime
					else
						table.remove(self.MapRecords, k)
					end
				end
			end
			if !bestTime then
				table.insert(self.MapRecords, {nick = ply:Nick(), steamid = plyid, maptime = fTime})
			end
			--PrintTable(self.MapRecords)
			file.CreateDir("hl1_coop")
			file.Write(datafile, util.TableToJSON(self.MapRecords))
			
			--[[net.Start("ShowMapRecords")
			net.WriteTable(self.MapRecords)
			net.Send(ply)]]--
		end
		
		-- bestTime = bestTime and ", personal best: "..string.FormattedTime(bestTime, "%02i:%02i.%02i") or ""
		-- ChatMessage(ply:Nick().." has finished the map in "..Time..bestTime)
		local stradd = bestTime and "#game_personalbest" or ""
		bestTime = bestTime and string.FormattedTime(bestTime, "%02i:%02i.%02i") or ""
		ChatMessage({"#game_plfinishmap "..stradd, ply:Nick(), Time, bestTime})
	end
end

function GM:SendCaption(sentence, pos, isSentence)
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then return end
	local startWith = string.StartsWith
	if isSentence or startWith(sentence, "!") or startWith(sentence, "NPC_Scientist") or startWith(sentence, "tride/") or startWith(sentence, "barney/") or startWith(sentence, "scientist/") or startWith(sentence, "hgrunt/") or startWith(sentence, "nihilanth/") or startWith(sentence, "holo/") then
		net.Start("ShowCaption")
		net.WriteString(sentence)
		if pos == true then
			net.Broadcast()
		else
			net.SendPAS(pos)
		end
		--print(sentence)
	end
end

function GM:AcceptInput(ent, input, activator, caller, value)
	if IsValid(caller) and caller:GetClass() == "trigger_once" then
		CallMapHook("CreateMapEventCheckpoints", ent, activator, input, caller)
		--print(ent, ent:GetName(), input, activator, caller, caller:GetName())
	end
	if ent:GetClass() == "env_explosion" and input == "Explode" and IsValid(activator) and activator:IsPlayer() and !ent.ActivatedByTrigger and (!IsValid(caller) or !caller:IsTrigger()) then
		ent:SetOwner(activator)
	end
	--print(ent, ent:GetName(), input, activator, caller)
	if ent:GetClass() == "ambient_generic" and input == "PlaySound" then
		local message = ent:GetSaveTable().message
		local pos = ent:HasSpawnFlags(1) or ent:GetPos()
		--print(message, ent, ent:GetName())
		hook.Run("SendCaption", message, pos)
	end
	if game.SinglePlayer() and ent:GetClass() == "player_weaponstrip" and input == "Strip" then
		local ply = Entity(1)
		if IsValid(ply) and ply:IsPlayer() then
			ply:StripWeapons()
		end
	end
	--[[if ent:GetClass() == "scripted_sentence" and input == "BeginSentence" then
		local active = ent:GetSaveTable().m_active
		if active then
			local sndpos = ent:GetPos()
			local sentence = ent:GetKeyValues().sentence
			local entityname = ent:GetKeyValues().entity
			local speaker = ents.FindByName(entityname)[1]
			if IsValid(speaker) and speaker:Health() > 0 then
				sndpos = speaker:WorldSpaceCenter()
			elseif !string.StartWith(entityname, "monster_") then
				active = false
			end
			--print(ent, ent:GetName(), sentence, speaker, entityname)
			--[[if string.StartWith(ent:GetName(), "globalspeaker") then
				local sentenceName = string.Replace(sentence, "!", "")
				for k, v in pairs(ents.FindByClass("speaker")) do
					EmitSentence(sentenceName, v:GetPos(), v:EntIndex(), CHAN_VOICE, .3, 0, 0, 100)
				end
				sentence = "!BMAS_"..sentenceName
			end]]
			--[[if active then
				hook.Run("SendCaption", sentence, sndpos)
			end
		end
	end]]
	if self:GetCrackMode() then
		hook.Run("CrackModeAcceptInput", ent, input, caller, activator)
	end
	return CallMapHook("OperateMapEvents", ent, input, caller, activator)
end

local entsRemovalCheck = {
	["logic_relay"] = true,
	["trigger_once"] = true,
	["func_breakable"] = true,
	["monster_tripmine"] = true,
}
function GM:EntityRemoved(ent)
	-- print(ent, ent:MapCreationID())
	if MAP.SaveTransitionEntityData then
		if ent:MapCreationID() > -1 and entsRemovalCheck[ent:GetClass()] then
			ent:MarkRemovedForTransition()
		end
	end
end

function GM:RestartMap()
	CallMapHook("PreMapRestart")
	self:PlayGlobalMusic("") -- stops the music
	game.CleanUpMap()
	hook.Run("InitPostEntity", true)
	self:SetGlobalFloat("WaitTime", 0)
	timer.Remove("LoadFirstMap")
	LAST_CHECKPOINT = nil
	LAST_CHECKPOINT_NUMBER = nil
	self.RemovedMapEntities = nil
	CallMapHook("OnMapRestart")
	
	hook.Run("CheckForShittyAddons")
end

function GM:GetFallDamage(ply, flFallSpeed)
	if GAMEMODE.Deathmatch then return 10 end

	local skill = self:GetSkillLevel() > 3 and self:GetSkillLevel() or 0
	local PLAYER_FATAL_FALL_SPEED = 1024
	local PLAYER_MAX_SAFE_FALL_SPEED = 580
	local DAMAGE_FOR_FALL_SPEED = 100 / ( PLAYER_FATAL_FALL_SPEED - PLAYER_MAX_SAFE_FALL_SPEED ) + skill
	
	return (flFallSpeed - PLAYER_MAX_SAFE_FALL_SPEED) * DAMAGE_FOR_FALL_SPEED
end

function GM:OnPlayerFullyLoaded(ply)
	ply.afkTime = 0
	ply:SetNWInt("Status", PLAYER_NOTREADY)
	
	local userid = ply:UserID()
	
	if CONNECTING_PLAYERS_TABLE then
		local hasUpdates = false
		for k, v in ipairs(CONNECTING_PLAYERS_TABLE) do
			if v[1] == userid then
				table.remove(CONNECTING_PLAYERS_TABLE, k)
				hasUpdates = true
			end
		end
		if hasUpdates then UpdateConnectingTable() end
	end
end

function GM:OnSuitEquip(ply, suitEnt)
	if !cvars.Bool("hl1_coop_sv_custommodels") then
		ply:SetModel(DEFAULT_PLAYERMODEL_PATH)
	end
	CallMapHook("OnSuitPickup", ply, suitEnt)
end

function GM:PlayerInitialSpawn(ply)
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD and ply:Team() != TEAM_COOP then
		ply:SetTeam(TEAM_UNASSIGNED)
		--self:PlayerSpawnAsSpectator(ply)
		UpdateConnectingTable(ply)
		return
	end
	ply.FirstSpawn = true
	ply:SetupMovementParams()
	ply:AllowFlashlight(true)
	if hl1_coop_sv_friendlyfire:GetBool() then
		ply:SetNoCollideWithTeammates(true)
	else
		ply:SetCustomCollisionCheck(true)
	end
	hook.Call("PlayerLoadout", GAMEMODE, ply, false)
	ply:SetTeam(TEAM_COOP)
	
	--[[if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then
		timer.Simple(0, function()
			if IsValid(ply) then
				ply:Freeze(true)
			end
		end)
	end]]
	
	if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD and self:GetMapLoadType() == "transition" then
		if self.LastPlayersTable then
			for k, v in pairs(self.LastPlayersTable) do
				if v.id == ply:UserID() and v.steamid == ply:SteamID64() then
					if MAP.SavePlayerScore and v.score then
						ply:SetScore(v.score)
					end
					if !ply.SpawnedAsSpectator and v.spec then
						ply:SetTeam(TEAM_SPECTATOR)
						hook.Run("PlayerSpawnAsSpectator", ply)
						ply.SpawnedAsSpectator = true
						v.spec = false
						return
					end
					if v.alive then
						timer.Simple(.1, function()
							if IsValid(ply) then
								if MAP.StartingWeapons != false and v.weptable then
									for wepclass, w in pairs(v.weptable) do
										if !ply:HasWeapon(wepclass) then
											ply:Give(wepclass, true)
										end
										if w.ammotype then
											ply:SetAmmo(w.ammocount, w.ammotype)
										end
										if w.ammotypeS then
											ply:SetAmmo(w.ammocountS, w.ammotypeS)
										end
										if w.clip then
											local weapon = ply:GetWeapon(wepclass)
											if IsValid(weapon) then
												weapon:SetClip1(w.clip)
											end
										end
									end
								end
								if v.hp > 0 then ply:SetHealth(v.hp) end
								ply:SetArmor(v.armor)
								if v.wep then
									ply:SelectWeapon(v.wep)
								end
							end
						end)
					end
					return
				end
			end
		end
	end
	if !self.IsSandboxDerived and GAMEMODE.FirstSpawnAsSpectator and self:IsCoop() and !ply:IsBot() and !ply.SpawnedAsSpectator and ply:GetNWInt("Status") == 0 then
		ply:SetTeam(TEAM_SPECTATOR)
		hook.Run("PlayerSpawnAsSpectator", ply)
		ply.SpawnedAsSpectator = true
	end
end

function GM:PlayerSpawnAsSpectator(ply, noteam)
	if ply:Team() == TEAM_COOP then
		ply:DropWeaponBox(true)
		if ply:IsFrozen() then
			ply:Freeze(false)
		end
	end
	ply:UnSpectate()
	ply:SetViewEntity()
	hook.Run("StopPlayerChase", ply)
	ply:KillSilent()
	ply:StripWeapons()
	--ply:SetLocalVelocity(Vector())
	ply.DeathEnt = nil
	ply.DeathPos = nil
	ply.DeathAng = nil
	ply.DeathDuck = nil
	--ply.HasFinishedMap = nil
	ply:SetWaitBool(false)
	if ply.wboxEnt and IsValid(ply.wboxEnt) then
		ply.wboxEnt:SetOwner(NULL)
	end

	if !noteam then
		local ent = ents.FindByClass("point_viewcontrol")
		ent = ent[math.random(1, #ent)]
		if IsValid(ent) then
			ply:SetPos(ent:GetPos())
			ply:SetEyeAngles(ent:GetAngles())
		end

		if ply:Team() != TEAM_UNASSIGNED then
			ply:SetTeam(TEAM_SPECTATOR)
		end
		if !IsValid(ply:GetObserverTarget()) then
			ply:SetObserverMode(OBS_MODE_FIXED)
		end
		local ragdoll = ply:GetRagdollEntity()
		if IsValid(ragdoll) then
			ragdoll:Remove()
		end
		
		hook.Run("VotePlayerJoinedSpectators", ply)
	end
end

function GM:PlayerSpawn(ply)
	--[[if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then
		ply:Freeze(true)
	end]]
	
	if self.IsSandboxDerived then
		if ply:IsListenServerHost() then
			ply:ChatMessage("You're in Sandbox mode - type 'hl1_coop_sandbox 0' in console to disable it.", 0)
		else
			ply:ChatMessage("You're playing Sandbox mode.", 0)
		end
	end

	ply:SetViewEntity()
	if ply:Team() != TEAM_COOP then
		hook.Run("PlayerSpawnAsSpectator", ply)
		return
	end

	if ply.DeathEnt and IsValid(ply.DeathEnt) then
		ply:SetPos(ply.DeathEnt:GetPos() + ply.DeathPos)
		ply:SetEyeAngles(ply.DeathAng)
	elseif ply.DeathPos and ply.DeathAng then
		ply:SetPos(ply.DeathPos)
		ply:SetEyeAngles(ply.DeathAng)
	end
	if ply.DeathDuck then
		ply:ConCommand("+duck")
		timer.Simple(.1, function()
			ply:ConCommand("-duck")
		end)
	end
	
	ply:UnSpectate()
	ply:SetupMovementParams()
	if MAP.NoSuitOnSpawn then
		ply:RemoveSuit()
	end
	ply:SetupPlayerModel()
	ply:SetupPlayerColor()
	ply:SetupHands()
	ply:SetFlashlightPower(100)
	
	CallMapHook("OnPlayerSpawn", ply)
	
	if !ply.FirstSpawn then
		ply:SetSpawnProtectionTime(SPAWN_PROTECTION_TIME)
	end
	ply.FirstSpawn = false
	
	timer.Simple(1, function()
		if ply:IsStuck() then
			ply:Unstuck()
		end
	end)
	
	hook.Run("SendTeleportHint", ply)
	
	ply.DiedInSurvival = nil
	ply:SendLua("LocalPlayer().DiedInSurvival = nil")
	ply:ClearSuitMessages()
	
	if self:Get1hpMode() then
		ply:SetMaxHealth(1)
		ply:SetMaxArmor(0)
		ply:SetHealth(1)
		ply:SetArmor(0)
	end
end

function GM:PlayerTick(ply, mv)
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD and ply:GetNWInt("Status") == PLAYER_NOTREADY and !ply:IsListenServerHost() then
		if ply.afkTime then
			if player.GetCount() > 1 and UnreadyKickTimeoutStarted then
				local kickUnreadyPlayerTime = cvar_unreadykicktime:GetInt()
				if ply.afkTime == 0 then
					ply.afkTime = SysTime()
				elseif kickUnreadyPlayerTime > 0 and (SysTime() - ply.afkTime) >= kickUnreadyPlayerTime then
					//PrintMessage(HUD_PRINTTALK, ply:Nick().." has been kicked for unactivity")
					ply:Kick("Kicked due to unactivity")
				end
			else
				ply.afkTime = 0
			end
		end
	end
	
	if !game.SinglePlayer() and cvar_afktime:GetBool() and GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD and ply.afkTime and !ply:IsBot() then
		if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION or GAMEMODE:GetCoopState() == COOP_STATE_ENDTITLES or player.GetCount() <= 1 or ply:Team() != TEAM_COOP or !ply:Alive() or ply:IsFlagSet(FL_ATCONTROLS) or ply:IsFrozen() or ply.afkTime == 0 or (self.NewChapterDelay and self.NewChapterDelay > CurTime()) then
			ply.afkTime = SysTime()
		end
		if SysTime() - ply.afkTime >= cvar_afktime:GetFloat() then
			hook.Run("PlayerSpawnAsSpectator", ply)
			ChatMessage({"#game_afkspec", ply:Nick()})
		end
	end
	
	if ply:Alive() and ply:WaterLevel() > 2 then
		if !ply.Drowning then ply.Drowning = CurTime() + 15 end
		if ply.Drowning and ply.Drowning < CurTime() then
			ply.Drowning = CurTime() + 1.5
			local dmginfo = DamageInfo()
			dmginfo:SetDamage(5)
			dmginfo:SetDamageType(DMG_DROWN)
			dmginfo:SetAttacker(game.GetWorld())
			dmginfo:SetInflictor(game.GetWorld())
			dmginfo:SetDamageForce(Vector(0,0,10))
			ply:TakeDamageInfo(dmginfo)
			--[[if !ply.DrownDamage then ply.DrownDamage = 0 end
			if ply.DrownDamage then ply.DrownDamage = ply.DrownDamage + 5 end]]
		end
	elseif ply.Drowning then
		ply.Drowning = nil
	end
	--[[if ply:Alive() and ply:WaterLevel() < 2 and !ply.Drowning and ply.DrownDamage then
		if ply.DrownDamage > 0 then
			if !ply.DrownDamageTime then ply.DrownDamageTime = CurTime() + 3 end
			if ply.DrownDamageTime and ply.DrownDamageTime < CurTime() then
				ply.DrownDamageTime = CurTime() + 3
				local recoverHealth = 5
				if ply:Health() + recoverHealth > ply:GetMaxHealth() then
					recoverHealth = ply:GetMaxHealth() - ply:Health()
				end
				ply:SetHealth(ply:Health() + recoverHealth)
				ply.DrownDamage = ply.DrownDamage - recoverHealth
				if ply:Health() >= ply:GetMaxHealth() then
					ply.DrownDamage = nil
					ply.DrownDamageTime = nil
				end
			end
		end
	end]]
	
	hook.Run("FlashlightPowerThink", ply)
	
	local actwep = ply:GetActiveWeapon()
	if IsValid(actwep) and !actwep.IsHL1Base then
		local PMpunchangle = ply.punchangle
		if PMpunchangle and PMpunchangle != Angle() then
			HL1_DropPunchAngle(FrameTime(), PMpunchangle)
		end
	end
end

local cvar_gmodsuit = GetConVar("gmod_suit")
function GM:FlashlightPowerThink(ply)
	if (!ply.FlashlightPowerTime or ply.FlashlightPowerTime <= CurTime()) and ply:Alive() and !cvar_gmodsuit:GetBool() then
		if ply:FlashlightIsOn() then
			ply:SetFlashlightPower(math.max(ply:GetFlashlightPower() - 1, 0))			
			if ply:GetFlashlightPower() <= 0 then
				ply:Flashlight(false)
			end
			ply.FlashlightPowerTime = CurTime() + FLASHLIGHT_DRAIN_DELAY
		elseif ply:GetFlashlightPower() < 100 then
			ply:SetFlashlightPower(math.min(ply:GetFlashlightPower() + 1, 100))
			ply.FlashlightPowerTime = CurTime() + FLASHLIGHT_GAIN_DELAY
		end
	end
end

function GM:PlayerSwitchFlashlight(ply, enable)
	if enable then
		return ply:IsSuitEquipped() and ply:GetFlashlightPower() >= 5
	end
	return true
end

function GM:PostPlayerDeath(ply)
	if hook.Run("GetSurvivalMode") and ply:Team() == TEAM_COOP then
		local plyNum = hook.Run("GetActivePlayersNumber")
		if plyNum == 1 then
			timer.Create("NotifyLastAlivePlayer", 1, 1, function()
				if hook.Run("GetActivePlayersNumber") == 1 then
					local lastPly = self:GetActivePlayersTable()[1]
					if IsValid(lastPly) and lastPly:Alive() then
						lastPly:SendScreenHintTop("#notify_onlyyouleft")
						for k, v in pairs(team.GetPlayers(TEAM_COOP)) do
							if !v:Alive() then
								v:SendScreenHintTop({"#notify_lastalive", lastPly:Nick()})
							end
						end
					end
				end
			end)
		end
		if plyNum == 0 then
			local someoneCanRespawn = false
			for k, v in ipairs(team.GetPlayers(TEAM_COOP)) do
				if !v:Alive() and v:GetScore() >= cvar_price_respawn_survival:GetInt() then
					net.Start("HL1DeathMenuRemove")
					net.Send(v)
					timer.Simple(1, function()
						if IsValid(v) and !v:Alive() then
							hook.Run("RespawnFunc", v, 2)
						end
					end)
					someoneCanRespawn = true
					break
				end
			end
			if !someoneCanRespawn then
				hook.Run("GameOver")
			end
		end
	end
end

function GM:CreateNPCSpawner(class, pl, pos, ang, radius, effect)
	local ent = ents.Create("hl1_monster_maker")
	if IsValid(ent) then
		ent:SetNPC(class)
		ent:SetMinPlayers(pl)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetRadius(radius)
		ent:EnableEffect(effect)
		ent:Spawn()
	end
end

function GM:GameStart()
	self:SetCoopState(COOP_STATE_INGAME)
	local delay = 3
	if cvar_speedrun:GetBool() then
		self:SetSpeedrunMode(true, delay)
	end
	if cvar_survival:GetBool() then
		self:SetSurvivalMode(true)
	end
	if cvar_crack:GetBool() then
		self:SetCrackMode(true)
	end
	hook.Run("RestartMap")
	if cvar_1hp:GetBool() then
		self:Set1hpMode(true)
	end
	for k, pl in ipairs(player.GetAll()) do
		if pl:Team() != TEAM_SPECTATOR then
			hook.Run("PlayerInitialSpawn", pl)
			pl:Spawn()
		end
		net.Start("HL1ChapterStart")
		net.WriteFloat(delay)
		net.Send(pl)
	end
	self.NewChapterDelay = CurTime() + delay
end

function GM:GameRestart()
	timer.Remove("GameRestartTimer")
	for k, v in ipairs(player.GetAll()) do
		v:ResetVars()
		v.HasFinishedMap = nil
		v.canTakeDamage = nil
		v.LastWeaponsTable = nil
		v:SetScore(0)
		v:SetFrags(0)
		v:SetDeaths(0)
		v:StripAmmo()
		v:StripWeapons()
		v:Freeze(false)
		v:SetWaitBool(false)
		v:ConCommand("-duck")
	end
	SetGlobalFloat("GameTime", self:GetGameTime())
	SetGlobalBool("ScreamLife", false)
	hook.Run("GameStart")
end

function GM:GameOver(skipfade, reason)
	--[[for k, v in pairs(player.GetAll()) do
		v:Freeze(true)
	end]]
	self:SetCoopState(COOP_STATE_GAMEOVER)
	if !skipfade then
		reason = reason or ""
		net.Start("HL1GameOver")
		net.WriteString(reason)
		net.Broadcast()
	end
	timer.Create("GameRestartTimer", 4, 1, function()
		hook.Run("GameRestart")
	end)
end

cvars.AddChangeCallback("hl1_coop_mode_speedrun", function(name, value_old, value_new)
	value_new = tonumber(value_new)
	if !isnumber(value_new) then return end
	if value_new == 1 then
		if !MAP.DisallowSpeedrunMode and GAMEMODE:GetCoopState() == COOP_STATE_INGAME then
			GAMEMODE:GameRestart()
		end
	elseif value_new == 0 then
		GAMEMODE:SetSpeedrunMode(false)
	end
end)

function GM:SetSurvivalMode(b, t)
	if MAP.DisallowSurvivalMode then return end
	t = t or 30
	if b then
		if self:GetSurvivalMode() then
			self:SetGlobalBool("SurvivalMode", false)
		end
		PrintMessage(HUD_PRINTTALK, "Survival mode starts in "..t.." seconds")
		self.SurvivalModeTime = RealTime() + t
	else
		self:SetGlobalBool("SurvivalMode", false)
		self.SurvivalModeTime = nil
		PrintMessage(HUD_PRINTTALK, "Survival mode is disabled")
		hook.Run("RemoveSurvivalEntities")
	end
end

cvars.AddChangeCallback("hl1_coop_mode_survival", function(name, value_old, value_new)
	value_new = tonumber(value_new)
	if !isnumber(value_new) then return end
	if value_new == 1 then
		if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
			GAMEMODE:SetSurvivalMode(true, 10)
		end
	elseif value_new == 0 then
		GAMEMODE:SetSurvivalMode(false)
	end
end)

function GM:ResetSpeedrunTimer(delay)
	delay = delay or 0
	if self:GetSpeedrunMode() then
		self:SetGlobalFloat("SpeedrunModeTime", CurTime() + delay)
	end
end

function GM:SetSpeedrunMode(b, t)
	if MAP.DisallowSpeedrunMode then return end
	t = t or 0
	if b then
		self:SetGlobalBool("SpeedrunMode", true)
		self:SetGlobalFloat("SpeedrunModeTime", CurTime() + t)
		PrintMessage(HUD_PRINTTALK, "Speedrun mode is enabled!")
		if game.GetMap() == "hls01amrl" then
			self:SetGlobalFloat("GameTime", 0)
		elseif GetGlobalFloat("GameTime") == 0 then
			self:SetGlobalFloat("GameTime", -1)
		end
	else
		self:SetGlobalBool("SpeedrunMode", false)
		SetGlobalFloat("GameTime", -1)
		PrintMessage(HUD_PRINTTALK, "Speedrun mode is disabled")
	end
end

cvars.AddChangeCallback("hl1_coop_mode_crack", function(name, value_old, value_new)
	value_new = tonumber(value_new)
	if !isnumber(value_new) then return end
	if value_new == 1 then
		if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
			GAMEMODE:GameRestart()
		end
	elseif value_new == 0 then
		GAMEMODE:SetCrackMode(false)
	end
end)

function GM:SetCrackMode(b)
	if b then
		self:SetGlobalBool("CrackMode", true)
		PrintMessage(HUD_PRINTTALK, "Crack mode is enabled!")
		if math.random(0, 100) == 0 then
			self:SetGlobalBool("ScreamLife", true)
			PrintMessage(HUD_PRINTTALK, "AAAAAAAAAAAAAAAAAAAAAAAAAAAHHHHH")
		end
	else
		self:SetGlobalBool("CrackMode", false)
		self:SetGlobalBool("ScreamLife", false)
		if self.LastPlayersTable then
			for k, v in pairs(self.LastPlayersTable) do
				v.weptable = nil
			end
		end
		PrintMessage(HUD_PRINTTALK, "Crack mode is disabled")
		if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
			hook.Run("GameRestart")
		end
	end
end

function GM:Modify1hpModeEntities()
	local items = ents.FindByClass("item_healthkit")
	table.Add(items, ents.FindByClass("item_battery"))
	table.Add(items, ents.FindByClass("func_healthcharger"))
	table.Add(items, ents.FindByClass("func_recharge"))
	for _, ent in ipairs(items) do
		ent:Remove()
	end
	local replaceTable = GetHL1AmmoEntTable()
	local crates = ents.FindByClass("func_breakable")
	table.Add(crates, ents.FindByClass("func_pushable"))
	table.Add(crates, ents.FindByClass("func_physbox"))
	for _, ent in ipairs(crates) do
		local spawnObj = ent:GetClass() == "func_pushable" and ent.spawnobject or ent:GetSaveTable().m_iszSpawnObject
		if spawnObj == "item_battery" or spawnObj == "item_healthkit" then
			local repl = replaceTable[math.random(1, #replaceTable)]
			if repl then
				if ent:GetClass() == "func_pushable" then
					ent.spawnobject = repl
				else
					ent:SetSaveValue("m_iszSpawnObject", repl)
				end
			end
		end
	end
end

function GM:Set1hpMode(b, t)
	if b then
		self:SetGlobalBool("1hpMode", true)
		PrintMessage(HUD_PRINTTALK, "1 HP mode is enabled!")
		
		hook.Run("Modify1hpModeEntities")
		for _, ply in ipairs(player.GetAll()) do
			ply:SetMaxHealth(1)
			ply:SetMaxArmor(0)
			ply:SetHealth(1)
			ply:SetArmor(0)
		end
	else
		self:SetGlobalBool("1hpMode", false)
		PrintMessage(HUD_PRINTTALK, "1 HP mode is disabled")
		for _, ply in ipairs(player.GetAll()) do
			ply:SetMaxHealth(100)
			ply:SetMaxArmor(100)
		end
	end
end

cvars.AddChangeCallback("hl1_coop_mode_1hp", function(name, value_old, value_new)
	value_new = tonumber(value_new)
	if !isnumber(value_new) then return end
	if value_new == 1 then
		if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
			GAMEMODE:Set1hpMode(true)
		end
	elseif value_new == 0 then
		GAMEMODE:Set1hpMode(false)
		if GAMEMODE:GetCoopState() == COOP_STATE_INGAME then
			GAMEMODE:GameRestart()
		end
	end
end)

concommand.Add("allready", function(ply)
	if IsValid(ply) and !ply:IsAdmin() then return end
	for k, v in ipairs(player.GetAll()) do
		v:ConCommand("_hl1_coop_ready")
	end
end)

function GM:ReadyScreenThink()
	if CONNECTING_PLAYERS_TABLE and !self.ConnectingTimeout then
		self.ConnectingTimeout = RealTime() + 60
	end
	if CONNECTING_PLAYERS_TABLE and #CONNECTING_PLAYERS_TABLE == 0 or self.ConnectingTimeout and self.ConnectingTimeout <= RealTime() or !CONNECTING_PLAYERS_TABLE then
		local allReady = true
		for k, v in ipairs(player.GetAll()) do
			if !v:IsBot() and v:GetNWInt("Status") != PLAYER_READY then
				allReady = false
				break
			end
		end
		if player.GetCount() > 0 and allReady then
			self:SetCoopState(COOP_STATE_INGAME)
			self:GlobalTextMessageCenter("#game_starting", 1.75)
			net.Start("HL1ChapterPreStart")
			net.Broadcast()
			timer.Simple(2, function()
				if MAP.ShowIntro then
					net.Start("HL1GameIntro")
					net.Broadcast()
					timer.Simple(6, function()
						hook.Run("GameStart")
					end)
				else
					hook.Run("GameStart")
				end
			end)
			SESSION_ID = math.random(999)
		end
	end
end

function GM:Think()
	-- checking if plys are ready
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		hook.Run("ReadyScreenThink")
	end
	
	if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then
		if CONNECTING_PLAYERS_TABLE and (GetGlobalFloat("FirstWaitingTime") <= SysTime() or #CONNECTING_PLAYERS_TABLE <= 0) then
			if hook.Run("GetActivePlayersNumber") > 0 then
				-- TODO: dont create timer if player count is 1
				if !timer.Exists("GameStartAfterWaiting") then
					timer.Create("GameStartAfterWaiting", 3, 1, function()
						self:SetCoopState(COOP_STATE_INGAME)
						local delay = 0
						if MAP.ShowChapterTitle != false then
							delay = 3
						end
						if cvar_speedrun:GetBool() then
							self:SetSpeedrunMode(true, delay)
						end
						if cvar_survival:GetBool() then
							self:SetSurvivalMode(true)
						end
						if cvar_crack:GetBool() then
							self:SetCrackMode(true)
						end
						hook.Run("RestartMap")
						if cvar_1hp:GetBool() then
							self:Set1hpMode(true)
						end
						if MAP.ShowChapterTitle != false then
							net.Start("HL1ChapterStart")
							net.WriteFloat(delay)
							net.Broadcast()
							self.NewChapterDelay = CurTime() + delay
						end
						--[[for k, v in pairs(player.GetAll()) do
							v:Freeze(false)
						end]]
						CONNECTING_PLAYERS_TABLE = nil
					end)
				end
			else
				print("No players detected. Returning to Ready Screen.")
				hook.Run("ReturnToReadyScreen")
			end
		end
	end
	
	hook.Run("VoteThink")
	
	hook.Run("NPCThinkInit")
	
	hook.Run("RestartTimerThink")
	
	if self.SurvivalModeTime and self.SurvivalModeTime <= RealTime() then
		self.SurvivalModeTime = nil
		if self:GetActivePlayersNumber(true) > 0 then
			self:SetGlobalBool("SurvivalMode", true)
			PrintMessage(HUD_PRINTTALK, "Survival mode is enabled!")
			for k, v in ipairs(team.GetPlayers(TEAM_COOP)) do
				if v:Alive() then
					v:GiveMedkit()
				end
			end
			CallMapHook("CreateSurvivalEntities")
		else
			PrintMessage(HUD_PRINTTALK, "No (alive) players were detected. Trying again.")
			self:SetSurvivalMode(true)
		end
	end
end

function GM:RestartTimerThink()
	if self.RestartTime and self.RestartTime <= RealTime() then
		self.RestartTime = nil
		if player.GetCount() == 0 then
			hook.Run("ReturnToReadyScreen")
		end
	end
end

function GM:SetGlobalBool(name, b)
	SetGlobalBool(name, b)
	-- sometimes it does not set on client, so we do this
	net.Start("SetGlobalBoolFix")
	net.WriteString(name)
	net.WriteBool(b)
	net.Broadcast()
end

function GM:SetGlobalFloat(name, fl)
	SetGlobalFloat(name, fl)
	net.Start("SetGlobalFloatFix")
	net.WriteString(name)
	net.WriteFloat(fl)
	net.Broadcast()
end

function GM:SetGlobalInt(name, int)
	SetGlobalInt(name, int)
	net.Start("SetGlobalIntFix")
	net.WriteString(name)
	net.WriteInt(int, 16)
	net.Broadcast()
end
	
function GM:NPCThinkInit()
	if player.GetCount() > 1 then
		for _, npc in ipairs(ents.FindByClass("monster_*")) do
			if npc:IsNPC() then
				hook.Run("NPCThink", npc)
			end
		end
	end
end

function GM:NPCThink(npc)
	if (npc:GetClass() == "monster_scientist" or npc:GetClass() == "monster_barney") and npc:GetNPCState() == NPC_STATE_SCRIPT then
		local blockEnt = npc:GetBlockingEntity()
		if IsValid(blockEnt) and blockEnt:IsPlayer() then
			local tr = util.TraceHull({
				start = npc:GetPos(),
				endpos = npc:GetPos() + npc:GetForward() * 16,
				filter = npc,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 72)
			})
			local trEnt = tr.Entity
			if IsValid(trEnt) and trEnt:IsPlayer() and trEnt:GetMoveType() == MOVETYPE_WALK then
				debugPrint(trEnt:GetName().." is blocking "..npc:GetClass().." at "..tostring(tr.HitPos))
				local dir = npc:GetRight()
				local tr_d = util.QuickTrace(trEnt:GetPos(), dir * 60, npc)
				if tr_d.Hit then
					dir = -dir
				end
				if trEnt:KeyDown(IN_USE) then
					trEnt:ConCommand("-use")
				end
				trEnt:SetLocalVelocity(dir * 500)
			end
		end
	end
	if GetConVarNumber("ai_use_think_optimizations") > 0 and !MAP.npcLagFixDisabled and GetConVarNumber("ai_ignoreplayers") <= 0 and !self.npcLagFixClassBlacklist[npc:GetClass()] and npc:GetNPCState() != NPC_STATE_SCRIPT and !IsValid(npc:GetEnemy()) then
		for _, pl in ipairs(player.GetAll()) do
			if pl:Alive() and npc:Disposition(pl) == D_HT and pl:Visible(npc) then
				npc:SetEnemy(pl)
				if IsValid(npc:GetEnemy()) and (!MAP.npcLagFixBlacklist or !MAP.npcLagFixBlacklist[npc:GetName()]) then
					npc:SetSaveValue("m_IdealNPCState", 3)
				end
			end
		end
	end
	
	if self:GetCrackMode() then
		hook.Run("CrackModeNPCThink", npc)
	end
end

function GM:CreateViewPointEntity(pos, ang)
	ang = ang or Angle()
	local ent = ents.Create("point_viewcontrol")
	if IsValid(ent) then
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()
	end
end

function GM:ReturnToReadyScreen()
	UnreadyKickTimeoutStarted = false
	self:SetCoopState(COOP_STATE_FIRSTLOAD)
	if cvar_speedrun:GetBool() then
		cvar_speedrun:SetBool(false)
	end
	if cvar_crack:GetBool() then
		cvar_crack:SetBool(false)
	end
	if self.IsSandboxDerived then return end
	if player.GetCount() > 0 then
		for k, v in ipairs(player.GetAll()) do
			v.afkTime = 0
			v:SetNWInt("Status", PLAYER_NOTREADY)
			v:SetTeam(TEAM_UNASSIGNED)
			hook.Run("PlayerSpawnAsSpectator", v)
		end
		timer.Simple(.1, function()
			net.Start("HL1StartMenu")
			net.Broadcast()
		end)
	end
end

GM.npcLagFixClassBlacklist = {
	["monster_barnacle"] = true,
	["monster_barney_dead"] = true,
	["monster_cockroach"] = true,
	["monster_flyer"] = true,
	["monster_flyer_flock"] = true,
	["monster_furniture"] = true,
	["monster_generic"] = true,
	["monster_gman"] = true,
	["monster_hevsuit_dead"] = true,
	["monster_hgrunt_dead"] = true,
	["monster_leech"] = true,
	["monster_scientist"] = true,
	["monster_scientist_dead"] = true,
	["monster_sitting_scientist"] = true,
	["monster_snark"] = true,
	["monster_nihilanth"] = true,
}

GM.NPCHealthMultiplierBlacklist = {
	["aitesthull"] = true,
	["controller_head_ball"] = true,
	["cycler"] = true,
	["monster_barnacle"] = true,
	["monster_barney_dead"] = true,
	["monster_cockroach"] = true,
	["monster_flyer"] = true,
	["monster_flyer_flock"] = true,
	["monster_furniture"] = true,
	["monster_generic"] = true,
	["monster_gman"] = true,
	["monster_hevsuit_dead"] = true,
	["monster_hgrunt_dead"] = true,
	["monster_leech"] = true,
	["monster_scientist"] = true,
	["monster_scientist_dead"] = true,
	["monster_sitting_scientist"] = true,
	["monster_snark"] = true,
	["hornet"] = true,
	["controller_energy_ball"] = true,
	["nihilanth_energy_ball"] = true,
	["monster_nihilanth"] = true,
}

function GM:NPCHealthMultiplier()
	local plyNum = hook.Run("GetActivePlayersNumber")
	if cvar_gainnpchp:GetBool() and plyNum > 2 then
		local div = 2.7
		local maxValue = 4
		return math.Clamp(math.Round(plyNum / div, 1), 1, maxValue)
	end
	return 1
end

function GM:ShowSpare1()
end

function GM:ShowSpare2()
end

function GM:PlayerDroppedWeapon(ply, wep)
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
		--[[if wep:Clip1() == -1 then
			local ammotype = wep:GetPrimaryAmmoType()
			wep.DroppedAmmo = ply:GetAmmoCount(ammotype)
			ply:SetAmmo(0, ammotype)
		end]]
		wep.WasDropped = true
		if !ply.DroppedWeapons then
			ply.DroppedWeapons = {}
		end
		if ply.DroppedWeapons then
			for k, v in pairs(ply.DroppedWeapons) do
				if !IsEntity(v[1]) or !IsValid(v[1]) or v[1] == wep then
					ply.DroppedWeapons[k] = nil
				end
			end
			table.insert(ply.DroppedWeapons, {wep, wep.EquipTime})
		end
	end
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply:HasWeapon(wep:GetClass()) then
		local ammotype = wep:GetPrimaryAmmoType()
		if ammotype == -1 then
			return false
		end
		if self:IsCoop() and !wep.IsThrowable and (wep.rRespawnable or wep.ReplRespawnTable) then return false end
		if wep:IsScripted() then
			local maxAmmoPrimary = wep.Primary.MaxAmmo
			local maxAmmoMul = ply.HL1MaxAmmoMultiplier
			if maxAmmoMul then
				if maxAmmoPrimary then
					maxAmmoPrimary = math.Round(maxAmmoPrimary * maxAmmoMul)
				end
			end
			if maxAmmoPrimary and ply:GetAmmoCount(ammotype) >= maxAmmoPrimary then
				return false
			end
		end
		--[[if wep.Secondary.MaxAmmo and ply:GetAmmoCount(wep:GetSecondaryAmmoType()) >= wep.Secondary.MaxAmmo then
			return false
		end]]--
		--[[if wep.DroppedAmmo then
			if wep.DroppedAmmo <= 0 then
				return false
			end
			ply:SetAmmo(ply:GetAmmoCount(ammotype) - wep.Primary.DefaultClip + wep.DroppedAmmo, ammotype)
		end]]
		if wep.WasDropped and wep:Clip1() == -1 then
			ply:SetAmmo(ply:GetAmmoCount(ammotype) - wep.Primary.DefaultClip, ammotype)
		end
	end
	if wep.ReplRespawnTable then
		local pos, ang = wep.ReplRespawnTable.pos, wep.ReplRespawnTable.ang
		local respClass = wep:GetClass()
		local respTime = GAMEMODE.WeaponRespawnTime or cvars.Number("hl1_sv_itemrespawntime", 23)
		wep.ReplRespawnTable = nil
		local ent = ents.Create(respClass)
		timer.Simple(respTime, function()
			if IsValid(ent) then
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:Spawn()
				ent.ReplRespawnTable = {
					pos = pos,
					ang = ang
				}
				sound.Play("items/suitchargeok1.wav", pos, 80, 150)
			end
		end)
	end
	return true
end

function GM:WeaponEquip(wep, ply)
	local ammotype = wep:GetPrimaryAmmoType()
	--[[local dropammo = wep.DroppedAmmo
	if dropammo and wep:IsScripted() then
		local ammo = dropammo - wep.Primary.DefaultClip
		if ammo > 0 then
			ply:GiveAmmo(ammo, ammotype, true)
		end
		local ammocount = ply:GetAmmoCount(ammotype)
		if dropammo <= 0 then
			timer.Simple(0, function()
				if IsValid(ply) then
					ply:SetAmmo(ammocount, ammotype)
				end
			end)
		elseif dropammo < wep.Primary.DefaultClip and ammocount < dropammo then
			timer.Simple(0, function()
				if IsValid(ply) then
					ply:SetAmmo(dropammo, ammotype)
				end
			end)			
		end
		wep.DroppedAmmo = nil
	end]]
	if !wep.WasDropped and ammotype != -1 then
		if game.SinglePlayer() and wep:IsScripted() and wep.IsHL1Base and wep:Clip1() != -1 then
			local clip = wep:Clip1()
			wep:SetClip1(-1)
			wep:SetClip1(clip)
		end
		wep.EquipTime = CurTime()
		if ply.DroppedWeapons then
			local preventDupe
			for k, v in pairs(ply.DroppedWeapons) do
				local dropwep, equiptime = v[1], v[2]
				if IsValid(dropwep) and dropwep:GetClass() == wep:GetClass() and equiptime + 15 > CurTime() then
					preventDupe = true
				end
			end
			if preventDupe then
				if wep:Clip1() == -1 then
					local ammo = ply:GetAmmoCount(ammotype)
					timer.Simple(0, function()
						if IsValid(ply) then
							ply:SetAmmo(ammo, ammotype)
						end
					end)
				else
					wep:SetClip1(0)
				end
			end
		end
	end
	ply:PlayPickupSound()
	
	if !wep.WasDropped and (wep:CreatedByMap() or wep.rRespawnable) and ply:GetInfoNum("hl1_coop_cl_autoswitch", 0) > 0 then
		timer.Simple(0, function()
			if IsValid(ply) and IsValid(wep) and (wep:Clip1() > 0 or ply:GetAmmoCount(ammotype) > 0) and ply:GetActiveWeapon() != wep then
				ply:SelectWeapon(wep:GetClass())
			end
		end)
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if !hl1_coop_sv_friendlyfire:GetBool() and attacker:IsPlayer() and attacker:Team() == ply:Team() and attacker != ply then
		return false
	end
	return true
end

function GM:CanPlayerSuicide(ply)
	return ply:Team() != TEAM_SPECTATOR and ply:Team() != TEAM_UNASSIGNED and !ply:IsFlagSet(FL_GODMODE)
end

function GM:PlayerDeathThink(pl)
	if pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_UNASSIGNED then
		return
	end

	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then

		if self:GetSurvivalMode() then
			if !pl.DiedInSurvival then
				if pl:GetScore() < cvar_price_respawn_survival:GetInt() then
					-- pl:TextMessageCenter("#game_surv_noscore", 3)
					hook.Run("RespawnFunc", pl, 1)
				else
					net.Start("HL1DeathMenu")
					net.WriteBool(true)
					net.Send(pl)
				end
			end
		else
			if pl:IsBot() then
				pl:Spawn()
			else
				if GetGlobalBool("DisablePlayerRespawn") then
					pl:Spectate(OBS_MODE_ROAMING)
				else
					if pl.KilledByFall or noRespawnOptions then
						hook.Run("RespawnFunc", pl, 2)
					else
						if pl:GetScore() < cvar_price_respawn_here:GetInt() then
							hook.Run("RespawnFunc", pl, 2)
						else
							net.Start("HL1DeathMenu")
							net.WriteBool(false)
							net.Send(pl)
						end
					end
				end
			end
		end

	end

end

function GM:StorePlayerAmmunition(ply)
	local weptable = ply:GetWeapons()
	if !table.IsEmpty(weptable) then
		local weapons = {}
		for k, v in pairs(weptable) do
			if v:IsScripted() then
				local ammotype = v:GetPrimaryAmmoType()
				local ammotypeS = v:GetSecondaryAmmoType()
				table.insert(weapons, {v:GetClass(), ammotype, ply:GetAmmoCount(ammotype), ammotypeS, ply:GetAmmoCount(ammotypeS), v:Clip1()})
			end
		end
		return weapons
	end
end

function GM:StorePlayerAmmunitionNew(ply)
	local weptable = ply:GetWeapons()
	if weptable then
		local weapons = {}
		for k, v in ipairs(weptable) do
			local clip = v:Clip1()
			clip = clip > -1 and clip or nil
			local ammotype = v:GetPrimaryAmmoType()
			ammotype = ammotype > -1 and ammotype or nil
			local ammotypeS = v:GetSecondaryAmmoType()
			ammotypeS = ammotypeS > -1 and ammotypeS or nil
			local ammocount = ammotype and ply:GetAmmoCount(ammotype)
			local ammocountS = ammotypeS and ply:GetAmmoCount(ammotypeS)
			
			local wepclass = v:GetClass()
			if !v.IsThrowable or ammocount and ammocount > 0 then
				weapons[wepclass] = {ammotype = ammotype, ammotypeS = ammotypeS, clip = clip, ammocount = ammocount, ammocountS = ammocountS}
			end
		end
		return weapons
	end
end

function GM:GetPlayerAmmo(ply)
	local plyam = hook.Run("StorePlayerAmmunitionNew", ply)
	if plyam then
		local ammo = {}
		for wepclass, v in pairs(plyam) do
			if v.ammotype then
				ammo[game.GetAmmoName(v.ammotype)] = ply:GetAmmoCount(v.ammotype)
			end
			if v.ammotypeS then
				ammo[game.GetAmmoName(v.ammotypeS)] = ply:GetAmmoCount(v.ammotypeS)
			end
		end
		return ammo
	end
end

GibSound = Sound("common/bodysplat.wav")

function GM:GibEntity(ent, amount, force)
	amount = amount or 16
	force = force or Vector()
	net.Start("GibPlayer")
	net.WriteVector(ent:GetPos())
	net.WriteVector(force)
	net.WriteUInt(amount, 8)
	net.WriteEntity(ent)
	net.Broadcast()
	ent:EmitSound(GibSound, 85, math.random(90, 110))
end

function GM:CreateEntityRagdoll(owner, ragdoll)
	if IsValid(owner) and owner:IsPlayer() then
		owner.GetRagdollEntityServerside = function() return ragdoll end
		local col = owner:GetPlayerColor()
		ragdoll.GetPlayerColor = function() return col end
		timer.Simple(.05, function()
			if IsValid(ragdoll) then
				ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
				ragdoll:BroadcastEntityPlayerColor(col)
			end
		end)
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	if cvar_plygib:GetBool() and (ply:Health() <= -40 or dmginfo:IsDamageType(DMG_ALWAYSGIB)) and !dmginfo:IsBulletDamage() then
		hook.Run("GibEntity", ply, 40, dmginfo:GetDamageForce() / 128)
	else
		ply:CreateRagdoll()
	end
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if self.Deathmatch then
		
			if attacker == ply then
				attacker:AddFrags( -1 )
			else
				attacker:AddFrags( 1 )
			end

		else
	
			if attacker == ply then
				attacker:AddScore(-100, "#score_selfkill")
			elseif attacker:Team() == ply:Team() then
				attacker:AddScore(-100, "#score_teamkill")
			end
			
		end
	
	end

end

function GM:PlayerDeath(victim, inflictor, attacker)
	if !IsValid(victim) then return end

	victim.NextSpawnTime = CurTime() + 1
	
	if IsValid(attacker) and attacker:GetClass() == "trigger_hurt" then attacker = victim end
	
	if !IsValid(inflictor) and IsValid(attacker) then
		inflictor = attacker
	end
	
	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC()) then
		inflictor = inflictor:GetActiveWeapon()
		if !IsValid(inflictor) then inflictor = attacker end
	end
	
	CallMapHook("OnPlayerDeath", victim, inflictor, attacker)
	if victim.KilledByFall or victim:HasFallenToDeath() then
		victim.KilledByFall = true
		if !MAP.DisableFullRespawn then
			victim.LastWeaponsTable = hook.Run("StorePlayerAmmunition", victim)
		end
	else
		local ground = victim:GetGroundEntity()
		if !IsValid(ground) then
			local tr = util.QuickTrace(victim:GetPos(), Vector(0,0,-48), victim)
			ground = tr.Entity
		end
		if IsValid(ground) and ground:IsMovingEntity() then
			victim.DeathEnt = ground
			victim.DeathPos = victim:GetPos() - ground:GetPos()
		else
			victim.DeathEnt = nil
			victim.DeathPos = victim:GetPos()
		end
		
		victim.DeathAng = victim:EyeAngles()
		victim.DeathDuck = victim:Crouching()
		
		victim:DropWeaponBox()
	end
	
	if attacker == victim then
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( victim )
		net.Broadcast()

		MsgAll( attacker:Nick() .. " suicided!\n" )
	
		return
	end

	if attacker:IsPlayer() then

		net.Start( "PlayerKilledByPlayer" )

			net.WriteEntity( victim )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )

		net.Broadcast()

		MsgAll( attacker:Nick() .. " killed " .. victim:Nick() .. " using " .. inflictor:GetClass() .. "\n" )

		return
	end

	net.Start( "PlayerKilled" )

		net.WriteEntity( victim )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )

	net.Broadcast()

	MsgAll( victim:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )
end

function GM:PlayClientSound(snd, ply)
	net.Start("PlayClientSound")
	net.WriteString(snd)
	net.Send(ply)
end

function GM:PlayGlobalSound(snd)
	net.Start("PlayClientSound")
	net.WriteString(snd)
	net.Broadcast()
end

function GM:PlayGlobalMusic(snd)
	net.Start("HL1Music")
	net.WriteString(snd)
	net.Broadcast()
end

function GM:EmitGlobalSound(snd, pitch)
	pitch = pitch or 100
	net.Start("EmitClientSound")
	net.WriteString(snd)
	net.WriteInt(pitch, 9)
	net.Broadcast()
end

concommand.Add("_hl1_coop_ready", function(ply, cmd, args, argStr)
	if !ply or !IsValid(ply) or GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD or ply:GetNWInt("Status") == PLAYER_READY then return end
	ply:SetNWInt("Status", PLAYER_READY)
	GAMEMODE:PlayGlobalSound("buttons/button14.wav")
	
	if !UnreadyKickTimeoutStarted then
		UnreadyKickTimeoutStarted = true
	end
end)

function GM:RespawnFunc(ply, rtype)
	if !ply or !IsValid(ply) or ply:Alive() then return end
	if !self:GetSurvivalMode() then
		if rtype == 1 then
			if !ply.KilledByFall then
				local respawnPrice = cvar_price_respawn_here:GetInt()
				if ply:GetScore() >= respawnPrice then
					ply:AddScore(-respawnPrice)
					ply:Spawn()
					local hp = math.min(ply:GetMaxHealth(), 25)
					ply:SetHealth(hp)
					hook.Call("PlayerLoadout", self, ply, true) -- crowbar & pistol
				else
					ply:PrintMessage(HUD_PRINTCONSOLE, "Not enough score!")
				end
			end
		else
			ply:ResetVars()
			if rtype == 3 and !MAP.DisableFullRespawn then
				local respawnPrice = cvar_price_respawn_full:GetInt()
				if ply:GetScore() >= respawnPrice then
					ply:AddScore(-respawnPrice)
					hook.Call("PlayerLoadout", self, ply)
				else
					ply:PrintMessage(HUD_PRINTCONSOLE, "Not enough score!")
					return
				end
			else
				hook.Call("PlayerLoadout", self, ply, true) -- crowbar & pistol
			end
			ply:Spawn()
			if IsValid(ply.wboxEnt) then
				ply.wboxEnt:SetOwner(NULL)
				ply.wboxEnt = nil
			end
		end
	else
		if rtype == 2 then
			if ply.KilledByFall then
				ply:ResetVars() -- removing last death pos so we can spawn at actual player start
			end
			local respawnPrice = cvar_price_respawn_survival:GetInt()
			if ply:GetScore() >= respawnPrice then
				ply:AddScore(-respawnPrice)
				ply:Spawn()
				local hp = math.min(ply:GetMaxHealth(), 100)
				ply:SetHealth(hp)
				hook.Call("PlayerLoadout", self, ply, true) -- crowbar & pistol
				
				timer.Remove("NotifyLastAlivePlayer")
				for k, v in pairs(team.GetPlayers(TEAM_COOP)) do
					v:SendScreenHintTop({"#notify_respawned", ply:Nick()})
				end
			else
				ply:PrintMessage(HUD_PRINTCONSOLE, "Not enough score!")
			end
		else
			if ply.wboxEnt and IsValid(ply.wboxEnt) then
				ply.wboxEnt:SetOwner(NULL)
				ply.wboxEnt = nil
			end
			hook.Run("StopPlayerChase", ply)
			ply.DiedInSurvival = true
			ply:SendLua("LocalPlayer().DiedInSurvival = true")
		end
	end
end

concommand.Add("_hl1_coop_respawn", function(ply, cmd, args, argStr)
	local arg = tonumber(args[1])
	GAMEMODE:RespawnFunc(ply, arg)
end)

/*concommand.Add("_hl1_coop_getmystuffback", function(ply, cmd)
	if !ply or !IsValid(ply) or !ply:Alive() or GAMEMODE:GetSpeedrunMode() then return end
	if ply.wboxEnt and IsValid(ply.wboxEnt) then
		local price = PRICE_GETMYSTUFFBACK
		if ply:GetScore() >= price then
			ply.wboxEnt:SetPos(ply:GetPos())
			ply.wboxEnt = nil
			ply:AddScore(-price)	
		else
			ply:ChatMessage("Not enough score!")
		end
	else
		ply:ChatMessage("Your stuff has not been found")
	end
end)*/

function GM:PlayerLoadoutLight(ply)
	ply:Give("weapon_glock")
	ply:Give("weapon_crowbar")
	ply:GiveAmmo(17, "9mmRound", true)
	local add_weps = MAP.StartingWeaponsLight
	if add_weps then
		for k, v in pairs(add_weps) do
			ply:Give(v)
		end
	end
end

function GM:PlayerLoadout(ply, light)
	if ply.LastWeaponsTable then
		for k, v in pairs(ply.LastWeaponsTable) do
			local wepclass, ammotype, ammocountP, ammotypeS, ammocountS, clip = v[1], v[2], v[3], v[4], v[5], v[6]
			ply:Give(wepclass)
			local wep = ply:GetWeapon(wepclass)
			if IsValid(wep) then
				if clip > -1 and wep.Primary.ClipSize > -1 then
					wep:SetClip1(clip)
				end
			end
		end
		ply.LastWeaponsTable = nil
		return
	end
	ply:RemoveAllAmmo()
	local t = MAP.StartingWeapons
	if (light or t == nil) and t != false then
		hook.Run("PlayerLoadoutLight", ply)
	elseif t then
		if istable(t) then
			for k, v in pairs(t) do
				ply:Give(v)
				local wep = ply:GetWeapon(v)
				if IsValid(wep) and wep:IsWeapon() then
					local amount = wep.Primary.DefaultClip
					if amount > 0 and wep.Primary.Ammo != "Hornet" then
						ply:GiveAmmo(amount, wep:GetPrimaryAmmoType(), true)
					end
				end
			end
		else
			ply:Give(t)
		end
		if MAP.StartingAmmo then
			for aType, aAmount in pairs(MAP.StartingAmmo) do
				ply:GiveAmmo(aAmount, aType, true)
			end
		end
	end
	if self:GetSurvivalMode() or cvar_medkit:GetBool() and !MAP.DisallowSurvivalMode then
		ply:GiveMedkit()
	end
	if self:GetSurvivalMode() then
		local wepsSurv = MAP.StartingWeaponsSurvival
		if wepsSurv then
			if istable(wepsSurv) then
				for k, v in pairs(wepsSurv) do
					ply:Give(v)
				end
			else
				ply:Give(wepsSurv)
			end
		end
	end
	
	-- select best weapon	
	timer.Simple(.1, function()
		if IsValid(ply) then
			ply:SelectBestWeapon()
			if game.SinglePlayer() then
				ply:FixInvisibleViewModel()
			end
		end
	end)
	
	if self.IsSandboxDerived then
		ply:Give("weapon_physgun")
		ply:Give("weapon_physcannon")
		ply:Give("gmod_tool")
		ply:Give("gmod_camera")
	end
end

function GM:PlayerSelectSpawn(pl, rand)
	if !IsTableOfEntitiesValid(self.SpawnPoints) or self.SpawnPoints and #self.SpawnPoints == 0 then
		local coopSPs = ents.FindByClass("info_player_coop")
		if #coopSPs > 0 then
			self.SpawnPoints = coopSPs
		else
			self.SpawnPoints = ents.FindByClass( "info_player_start" )
			self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		end
	end
	
	--PrintTable(self.SpawnPoints)

	if !self:IsCoop() then
		for k, v in pairs( self.SpawnPoints ) do
			-- If any of the spawnpoints have a MASTER flag then only use that one.
			-- This is needed for single player maps.
			if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, v, true ) ) then
				return v
			else
				return self.SpawnPoints[1]
			end
		end
	else
		if !rand then
			for k, v in pairs(self.SpawnPoints) do
				if hook.Run("IsSpawnpointSuitable", pl, v) then
					return v
				end
			end
		end
		return self.SpawnPoints[math.random(1, #self.SpawnPoints)]
	end

end

function GM:IsSpawnpointSuitable(pl, spawnpointent, bMakeSuitable)

	local Pos = spawnpointent:GetPos()

	-- Note that we're searching the default hull size here for a player in the way of our spawning.
	-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	-- (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )

	if ( pl:Team() == TEAM_SPECTATOR ) then return true end

	local Blockers = 0

	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v != pl && v:GetClass() == "player" && v:Alive() ) then

			Blockers = Blockers + 1

		end
	end

	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

gameevent.Listen("player_connect")
hook.Add("player_connect", "ConnectionTableAdd", function(data)
	if data.bot != 1 then
		if !CONNECTING_PLAYERS_TABLE then
			CONNECTING_PLAYERS_TABLE = {}
		end
		if CONNECTING_PLAYERS_TABLE then
			table.insert(CONNECTING_PLAYERS_TABLE, {data.userid, data.name})			
			UpdateConnectingTable()
		end
		--ChatMessage(data.name .. " ("..data.userid..") has connected to the server", 0)
	end
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "ConnectionTableRemove", function(data)
	if data.bot != 1 then
		if CONNECTING_PLAYERS_TABLE then
			local hasUpdates = false
			for k, v in ipairs(CONNECTING_PLAYERS_TABLE) do
				if v[1] == data.userid then
					table.remove(CONNECTING_PLAYERS_TABLE, k)
					hasUpdates = true
				end
			end
			if hasUpdates then			
				UpdateConnectingTable()
			end
		end
		--ChatMessage(data.name .. " ("..data.userid..") has left the server", 0)
	end
end)

function GM:AdjustNPCHealth(prevSkill)
	--local prevSkillTable = self:GetSkillTable(prevSkill)
	for _, npc in ipairs(ents.FindByClass("monster_*")) do
		if npc:IsNPC() and !self.NPCHealthMultiplierBlacklist[npc:GetClass()] then
			--local hpCvar = self.NPCHealthConVar[npc:GetClass()]
			--local maxHealth = hpCvar and cvars.Number(hpCvar) or npc:GetMaxHealth()
			local maxHealth = npc:GetMaxHealth()
			if maxHealth > 0 then
				local maxHealthMul = math.floor(maxHealth * hook.Run("NPCHealthMultiplier"))
				if MAP.ImportantNPCs and (!MAP.ImportantHealthBlacklist or !MAP.ImportantHealthBlacklist[npc:GetName()]) then
					for k, v in pairs(MAP.ImportantNPCs) do
						if npc:GetName() == v then
							maxHealthMul = maxHealthMul * IMPORTANT_NPC_HP_SCALE
						end
					end
				end
				local hp = npc:Health()
				if hp > maxHealthMul then
					debugPrint("lowering npc hp:", npc, "hp: "..hp, "max: "..maxHealthMul)
					npc:SetHealth(maxHealthMul)
				end
			end
		end
	end
	for k, v in ipairs(ents.FindByClass("info_bigmomma")) do
		local healthkeyDef = v.healthDefault
		if healthkeyDef then
			v:SetKeyValue("health", healthkeyDef * cvars.Number("sk_bigmomma_health_factor", 1) * hook.Run("NPCHealthMultiplier"))
		end
	end
end

function GM:SetRestartTimer()
	local t = self.ReturnToReadyScreenTime
	self.RestartTime = RealTime() + t
	print("No players detected. Returning to Ready Screen in "..t.." seconds.")
end

function GM:PlayerDisconnected(ply)
	local name = ply:Nick()
	local id = ply:UserID()

	ply:DropWeaponBox()
	if hook.Run("GetSurvivalMode") and ply:Team() == TEAM_COOP and ply:Alive() and hook.Run("GetActivePlayersNumber") <= 1 and player.GetCount() > 1 then
		hook.Run("GameOver")
	end

	timer.Simple(1, function()
		hook.Run("AdjustNPCHealth")
	end)

	if self:IsCoop() and GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD and player.GetCount() < 2 then
		hook.Run("SetRestartTimer")
	end

	hook.Run("StopPlayerChase", ply)

	hook.Run("VotePlayerDisconnected", ply)
end

-- stops other players chasing ply
function GM:StopPlayerChase(ply)
	for k, v in ipairs(player.GetHumans()) do
		if v != ply then
			if v:GetViewEntity() == ply then
				v:SetViewEntity()
			end
			local obsTarget = v:GetObserverTarget()
			if IsValid(obsTarget) and obsTarget == ply then
				v:SpectateEntity(table.Random(hook.Run("GetActivePlayersTable")))
			end
		end
	end
end

function GM:PlayerSay(ply, text, isTeamChat)
	hook.Run("PlayerSayChatsound", ply, text, isTeamChat)
	return text
end

net.Receive("UpdatePlayerPositions", function(len, ply)
	if IsValid(ply) then
		ply.ShowPlayerDist = RealTime() + net.ReadFloat()
	end
end)

function GM:SetupPlayerVisibility(ply, viewent)
	if (!IsValid(viewent) or viewent == ply) and ply.ShowPlayerDist and ply.ShowPlayerDist > RealTime() then
		for k, v in pairs(hook.Run("GetActivePlayersTable")) do
			AddOriginToPVS(v:GetPos())
		end
	end
	local specply = ply:GetObserverTarget()
	if IsValid(specply) then
		ply:SetPos(specply:GetPos())
	end
	--[[if IsValid(viewent) and viewent:IsPlayer() and viewent != ply then
		AddOriginToPVS(viewent:GetPos())
	end]]
end

function GM:OnDamagedByExplosion(ply, dmginfo)
	return true
end

function GM:OnNPCKilled(npc, attacker, inflictor)
	if !IsValid(inflictor) then inflictor = attacker end
	if IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC()) then
		local actwep = inflictor:GetActiveWeapon()
		if IsValid(actwep) then
			inflictor = actwep
		end
	end

	if npc.PlyDmgTable then
		local ePrice = self.NPCScorePrice[npc:GetClass()]
		if ePrice then
			local totalDmg = 0
			for ply, t in pairs(npc.PlyDmgTable) do
				if IsValid(ply) and CurTime() - t.Time <= 30 then
					totalDmg = totalDmg + t.Dmg
				else
					npc.PlyDmgTable[ply] = nil
				end
			end
			if !table.IsEmpty(npc.PlyDmgTable) then
				for ply, t in pairs(npc.PlyDmgTable) do
					if IsValid(ply) then
						local p = t.Dmg / totalDmg
						local score = math.Round(ePrice * p)
						if score > 0 then
							local scoreMsg
							if ply != attacker then
								scoreMsg = "#score_assist"
							end
							ply:AddScore(score, scoreMsg)
						end
					end
				end
			else
				npc.PlyDmgTable = nil
			end
		end
	end

	if attacker:IsPlayer() then
		local ePrice = self.NPCScorePrice[npc:GetClass()]
		if !ePrice then
			attacker:AddScore(10)
		elseif !npc.PlyDmgTable then
			attacker:AddScore(ePrice)
		end
		MsgC(color_white, attacker:Nick() .. " killed " .. npc:GetClass() .. " with " .. inflictor:GetClass() .. "\n")
	end
	
	if MAP.ImportantNPCs then
		if MAP.ImportantNPCsSpecial then
			local hasAliveNPCs
			for _, name in pairs(MAP.ImportantNPCs) do
				for k, v in ipairs(ents.FindByName(name)) do
					if npc != v and v:Health() > 0 then
						hasAliveNPCs = true
					end
				end
			end
			if !hasAliveNPCs then
				hook.Run("GameOver", false, "All scientists are dead")
			end
		else
			for _, name in pairs(MAP.ImportantNPCs) do
				if npc:GetName() == name then
					local nicename = self.NPCsNiceNames[npc:GetClass()]
					local reason
					if nicename then
						reason = "The "..nicename.." has been killed"
					end
					hook.Run("GameOver", false, reason)
				end
			end
		end
	end
	
	if MAP.SaveTransitionEntityData and npc:MapCreationID() > -1 then
		npc:MarkRemovedForTransition()
	end
	
	if self:GetCrackMode() then
		hook.Run("CrackModeNPCKilled", npc, attacker, inflictor)
	end
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
	if hitgroup == HITGROUP_HEAD and dmginfo:GetDamage() < npc:Health() then
		dmginfo:ScaleDamage(2)
	end
	
	if hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR then
	
		dmginfo:ScaleDamage(.25)
	end
end

monsterDeadTable = {
	["monster_barney_dead"] = true,
	["monster_hevsuit_dead"] = true,
	["monster_hgrunt_dead"] = true,
	["monster_scientist_dead"] = true,
}

local scoreForDamage = {
	["monster_apache"] = true,
	["monster_osprey"] = true,
	["monster_gargantua"] = {"hornet", "ent_hl1_hornet"},
}
local function InflictorInBlacklist(t, inflictor)
	if t == true or !IsValid(inflictor) then return end

	if istable(t) then
		for k, v in pairs(t) do
			if inflictor:GetClass() == v then
				return true
			end
		end
	else
		if inflictor:GetClass() == t then return true end
	end
end

function GM:CreateAssistTable(ent, dmginfo)
	if !cvar_assistpoints:GetBool() or game.SinglePlayer() then return end
	local attacker = dmginfo:GetAttacker()
	local npcKillScore = self.NPCScorePrice[ent:GetClass()]
	if npcKillScore and npcKillScore > 1 then
		if !ent.PlyDmgTable then
			ent.PlyDmgTable = {}
		end
		if ent.PlyDmgTable then
			local dmg = dmginfo:GetDamage()
			local hp = ent:Health()
			if dmg > hp then
				dmg = hp
			end
			dmg = math.ceil(dmg)
			if !ent.PlyDmgTable[attacker] then
				ent.PlyDmgTable[attacker] = {Dmg = dmg, Time = CurTime()}
			else
				ent.PlyDmgTable[attacker].Dmg = ent.PlyDmgTable[attacker].Dmg + dmg
				ent.PlyDmgTable[attacker].Time = CurTime()
			end
		end
	end
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	if IsValid(attacker) and attacker:IsPlayer() and IsValid(inflictor) and inflictor:GetClass() == "monster_mortar" and !IsValid(inflictor:GetOwner()) then
		dmginfo:SetAttacker(inflictor)
	end
	
	--[[if ent:GetClass() == "func_breakable" and ent:Health() > 0 and ent:HasSpawnFlags(256) and IsValid(attacker) and attacker:IsPlayer() and dmginfo:IsDamageType(DMG_CLUB) then
		ent:SetHealth(0)
	end]]
	
	if MAP.ImportantNPCs and self:IsCoop() and ent:IsNPC() then
		if IsValid(attacker) and attacker:IsPlayer() then
			for k, v in pairs(MAP.ImportantNPCs) do
				if ent:GetName() == v then
					return true
				end
			end
		end
	end
	if ent:GetName() == "tank_break_explob" then
		if IsValid(attacker) and attacker:IsPlayer() then
			attacker:AddScore(math.floor(dmginfo:GetDamage() / 1.5))
		end
	end
		
	--[[if ent:IsNPC() and ent:GetClass() == "nihilanth_energy_ball" then
		print(ent, dmginfo:GetAttacker(), dmginfo:GetDamage())
		return true
	end]]--
	
	
	if ent:IsPlayer() then
		if !ent:IsBot() and (!ent.canTakeDamage and dmginfo:GetDamage() < 100 or self.NewChapterDelay and self.NewChapterDelay + 2 > CurTime()) or GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then
			return true
		end

		if ent.SpawnProtectionTime and ent.SpawnProtectionTime >= CurTime() and IsValid(attacker) and (attacker:GetClass() != "trigger_hurt" or dmginfo:GetDamage() < 100) then return true end
		if IsValid(attacker) and attacker:GetClass() == "trigger_hurt" and dmginfo:IsDamageType(16) then
			if ent:Armor() > 0 then
				ent:SetArmor(math.Clamp(ent:Armor() - dmginfo:GetDamage(), 0, 100))
			end
			return true
		end
	end
	
	if ent:IsNPC() then
		if ent:Health() > 0 and attacker:IsPlayer() then
			hook.Run("CreateAssistTable", ent, dmginfo)
		end
		local dmgScore = scoreForDamage[ent:GetClass()]
		if dmgScore then
			if IsValid(attacker) and attacker:IsPlayer() and !InflictorInBlacklist(dmgScore, inflictor) then
				local score = dmginfo:GetDamage() / 2.5
				local scoreMul = self.NPCScorePriceDamageMul[ent:GetClass()]
				if scoreMul then
					score = score * scoreMul
				end
				if score > 0 then
					score = math.max(score, 1)
				end
				attacker:AddScore(math.floor(score))
			end
		end
		if ent:GetClass() == "monster_gman" then
			ent:SetHealth(ent:Health() - dmginfo:GetDamage())
			if ent:Health() < -140 then
				ent:Remove()
				hook.Run("GibEntity", ent)
			end
		end
		if ent:GetClass() == "monster_nihilanth" then
			if cvar_fixnihilanth:GetBool() then
				if !dmginfo:IsBulletDamage() or IsValid(inflictor) and !inflictor:IsPlayer() then
					local m_irritation = ent:GetInternalVariable("m_irritation")
					if m_irritation and m_irritation >= 2 then
						local dmgpos = dmginfo:GetDamagePosition()
						local tr = util.TraceLine({
							start = dmgpos + Vector(0,0,128),
							endpos = dmgpos - Vector(0,0,128),
							filter = {attacker, inflictor}
						})
						if !(tr.HitBox == 3 and tr.HitGroup == 2) then
							dmginfo:ScaleDamage(0)
						end
					end
				end
			end
			if ent:Health() > 1 then
				if IsValid(attacker) and attacker:IsPlayer() then
					local score = dmginfo:GetDamage() / 6
					local scoreMul = self.NPCScorePriceDamageMul[ent:GetClass()]
					if scoreMul then
						score = score * scoreMul
					end
					if score > 0 then
						score = math.max(score, 1)
					end
					attacker:AddScore(math.floor(score))
				end
			else
				timer.Simple(0.25, function()
					if IsValid(ent) and ent:GetInternalVariable("m_lifeState") > 0 then
						CallMapHook("OnNihilanthDeath", ent)
					end
				end)
			end
		end
		if ent:GetClass() == "monster_bigmomma" then
			if dmginfo:IsDamageType(DMG_BLAST) then
				local dmgpos = dmginfo:GetDamagePosition()
				local entpos = ent:WorldSpaceCenter()
				local dist = dmgpos:Distance(entpos) - 20
				dist = math.max(dist / 32, 1)
				local dmg = dmginfo:GetInflictor().dmg
				dmg = dmg or 100
				dmginfo:SetDamagePosition(dmgpos)
				dmginfo:SetDamage(dmg / dist)
				--print(dmginfo:GetDamage())
			end
			if ent:Health() > 1 then
				if IsValid(attacker) and attacker:IsPlayer() then
					local score = math.floor(dmginfo:GetDamage()) / 16
					if score > 0 then
						score = math.max(score, 1)
						local scoreMul = self.NPCScorePriceDamageMul[ent:GetClass()]
						if scoreMul then
							score = score * scoreMul
						end
						score = math.Round(score)
						attacker:AddScore(score)
					end
				end
			end
		end
	end
	
	if monsterDeadTable[ent:GetClass()] then
		ent:SetHealth(ent:Health() - dmginfo:GetDamage())
		if ent:Health() <= -40 then
			hook.Run("GibEntity", ent)
			ent:Remove()
		end
	end
	
	if ent:IsPlayer() and !ent:HasGodMode() and hook.Run("PlayerShouldTakeDamage", ent, dmginfo:GetAttacker()) then
		hook.Run("HEV_TakeDamage", ent, dmginfo)
	end
end

function GM:OnEntityExplosion(ent, pos, radius, dmg, hitEntity)
	if self:GetCrackMode() then
		hook.Run("CrackModeEntityExplosion", ent, pos, radius, dmg)
	end
	if cvars.Bool("ai_serverragdolls") then return end
	net.Start("RagdollGib")
	net.WriteVector(pos)
	net.WriteFloat(dmg)
	net.WriteFloat(radius)
	net.SendPVS(pos)
end

function GM:FixCollisionBounds(ent, class, mins, maxs)
	-- use in OnEntityCreated
	if ent:GetClass() == class then
		timer.Simple(0, function()
			if IsValid(ent) then
				ent:SetCollisionBounds(mins, maxs)
			end
		end)
	end
end

function GM:Impulse101(ply)
	if !IsValid(ply) then return end
	
	local weps = GetHL1WeaponClassTable()
	
	for _, wep in pairs(weps) do
		ply:Give(wep)
		local entWep = ply:GetWeapon(wep)
		if IsValid(entWep) and entWep.Primary.MaxAmmo then ply:GiveAmmo(math.min(entWep.Primary.MaxAmmo - ply:GetAmmoCount(entWep:GetPrimaryAmmoType()), entWep.Primary.DefaultClip), entWep:GetPrimaryAmmoType()) end
		--if entWep.Secondary.MaxAmmo then ply:GiveAmmo(math.min(entWep.Secondary.MaxAmmo - ply:GetAmmoCount(entWep:GetSecondaryAmmoType()), entWep.Secondary.DefaultClip), entWep:GetSecondaryAmmoType()) end
	end
	if ply:IsSuitEquipped() then
		if ply:Armor() < 100 then
			ply:Give("item_battery")
		end
	else
		ply:Give("item_suit")
	end
	ply:Give("ammo_ARgrenades")
end

concommand.Add("hl1_coop_give", function(ply, cmd, args)
	if !IsValid(ply) or !ply:IsAdmin() or !ply:Alive() then return end
	local wep = args[1]
	if wep then
		if ply:HasWeapon(wep) then
			wep = ply:GetWeapon(wep)
			if IsValid(wep) and wep:IsScripted() then
				local ammoType = wep:GetPrimaryAmmoType()
				if ammoType > -1 then
					ply:GiveAmmo(wep.Primary.DefaultClip, ammoType)
				end
			end
		else
			ply:Give(wep)
		end
	end
end)

concommand.Add("hl1_coop_impulse101", function(ply, cmd, args)
	if ply and IsValid(ply) and (!ply:IsSuperAdmin() or !ply:Alive()) then return end
	
	if args[1] then
		for k, v in ipairs(player.GetAll()) do
			if v:Nick():lower() == args[1]:lower() then
				ply = v
				break
			end
		end
	end

	hook.Run("Impulse101", ply)
end)

concommand.Add("hl1_coop_addscore", function(ply, cmd, args)
	if IsValid(ply) and !ply:IsAdmin() then return end
	local score = tonumber(args[1])
	local nick = args[2]
	if nick then
		local giveTo
		for k, v in ipairs(player.GetAll()) do
			if v:Nick():lower() == nick:lower() then
				giveTo = v
				break
			end
		end
		if giveTo then
			ply = giveTo
		else
			print("Player "..nick.." has not been found")
			return
		end
	end
	if score then
		ply:AddScore(score)
		print(ply:Nick().." got "..score.." score")
	end
end)

concommand.Add("game_restart", function(ply, cmd, args)
	if IsValid(ply) and !ply:IsAdmin() then return end
	GAMEMODE:GameRestart()
end)
concommand.Add("game_lobby", function(ply, cmd, args)
	if IsValid(ply) and !ply:IsAdmin() then return end
	GAMEMODE:ReturnToReadyScreen()
end)

function GM:StartEndTitles()
	self:SetCoopState(COOP_STATE_ENDTITLES)
	self:SetGlobalFloat("EndTitlesTime", CurTime())
	--[[for k, v in pairs(player.GetAll()) do
		v:Freeze(true)
	end]]
	local endTime = 110
	local restartTime = 10
	if !self:IsCoop() then
		endTime = endTime + restartTime
	end
	timer.Create("LoadFirstMap", endTime, 1, function()
		if GAMEMODE:GetCoopState() == COOP_STATE_ENDTITLES then
			if self:IsCoop() then
				PrintMessage(HUD_PRINTTALK, "Restart in "..restartTime.." seconds")
				timer.Create("GameRestartTimer", restartTime, 1, function()
					hook.Run("LoadFirstMap")
				end)
			else
				RunConsoleCommand("disconnect")
			end
		end
	end)
end

function GM:LoadFirstMap()
	local map = "hls01amrl"
	local cvar = cvar_firstmap:GetString()
	if cvar and string.len(cvar) > 0 then
		map = cvar
	--[[else
		local t = {}
		for chapter, maptable in pairs(GAMEMODE.Chapters) do
			table.insert(t, maptable[1])
		end
		table.sort(t, function(a, b) return a < b end)
		map = t[1]
		]]
	end
	RunConsoleCommand("changelevel", map)
	hook.Run("TransitPlayers", map)
end

concommand.Add("dropweapon", function(ply)
	if IsValid(ply) and ply:Alive() then
		local actwep = ply:GetActiveWeapon()
		if IsValid(actwep) then
			if actwep.IsThrowable then
				ply:DropAmmo(actwep:GetClass())
				if IsValid(actwep) and ply:GetAmmoCount(actwep:GetPrimaryAmmoType()) <= 0 then
					actwep:Holster()
				end
				return
			end
			if ply.DroppedWeapons then
				local count = 0
				for k, v in pairs(ply.DroppedWeapons) do
					local dropwep = v[1]
					if IsValid(dropwep) and dropwep:GetClass() == actwep:GetClass() and !IsValid(dropwep:GetOwner()) then
						count = count + 1
					end
				end
				if count >= MAX_DROPPED_WEAPONS then return end
			end
			if actwep:IsScripted() then
				actwep:Holster()
			end
			if SERVER then ply:DropWeapon(actwep) end
		end
	end
end, nil, nil, FCVAR_CLIENTCMD_CAN_EXECUTE)

concommand.Add("dropammo", function(ply)
	if IsValid(ply) then
		ply:DropAmmo()
	end
end, nil, nil, FCVAR_CLIENTCMD_CAN_EXECUTE)

concommand.Add("chase", function(ply, cmd, args, argStr)
	if !IsValid(ply) then return end
	local arg = tonumber(args[1])
	if !arg then ply:ChasePlayer() return end
	local pl = Player(arg)
	if IsValid(pl) and pl != ply and pl:Team() == TEAM_COOP then
		ply:ChasePlayer(pl)
	else
		ply:ChasePlayer()
	end
end, nil, nil, FCVAR_CLIENTCMD_CAN_EXECUTE)

concommand.Add("lastcheckpoint", function(ply, cmd, args, argStr)
	if !IsValid(ply) or !ply:Alive() or ply:IsFrozen() or ply:IsSpectator() then return end
	if !LAST_CHECKPOINT then
		ply:PrintMessage(HUD_PRINTCONSOLE, "No checkpoint was found")
		return
	end
	if ply.CanTeleportTime and ply.CanTeleportTime > CurTime() and LAST_CHECKPOINT.Pos:Distance(ply:GetPos()) > LAST_CHECKPOINT_MINDISTANCE then
		local price = cvar_price_movetocheckpoint:GetInt()
		if ply:GetScore() < price then
			ply:PrintMessage(HUD_PRINTCONSOLE, "Not enough score!")
			return
		end
		ply:TeleportToCheckpoint(LAST_CHECKPOINT.Pos, LAST_CHECKPOINT.Ang, LAST_CHECKPOINT.Weptable)
		ply:AddScore(-price)
	end
end, nil, nil, FCVAR_CLIENTCMD_CAN_EXECUTE)

function GM:ChangeLevel(map, delay)
	if map then
		delay = delay or 3
		local plytable = player.GetAll()
		for _, pl in ipairs(plytable) do
			pl:Lock()
		end
		self:GlobalTextMessageCenter("Changing level...", delay)
		timer.Simple(delay, function()
			RunConsoleCommand("changelevel", map)
			for _, pl in ipairs(plytable) do
				pl:UnLock()
			end
		end)
	end
end

cvars.AddChangeCallback("hl1_coop_sv_hevvoice", function(name, value_old, value_new)
	value_new = tonumber(value_new)
	if !isnumber(value_new) then return end
	
	local sentence
	
	if value_new >= 1 then
		sentence = "HEV_V0"
	else
		sentence = "HEV_V1"
	end
	
	if sentence then
		for k, v in ipairs(player.GetAll()) do
			v:SetSuitUpdate(sentence, 0, true)
		end
	end
end)

cvars.AddChangeCallback("hl1_coop_sv_friendlyfire", function(name, value_old, value_new)
	value_new = tonumber(value_new)

	local plys = player.GetAll()
	
	if isnumber(value_new) and value_new >= 1 then
		for k, v in ipairs(plys) do
			v:SetCustomCollisionCheck(false)
			v:SetNoCollideWithTeammates(true)
		end
	else
		for k, v in ipairs(plys) do
			v:SetCustomCollisionCheck(true)
			v:SetNoCollideWithTeammates(false)
		end
	end
end, "HL1Coop_FriendlyFire_Callback")

function GM:CreatePhysicsDecoration(model, pos, ang, mat, skin)
	ang = ang or Angle()
	local ent = ents.Create("prop_physics")
	if IsValid(ent) then
		ent:SetModel(model)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		if skin then
			ent:SetSkin(skin)
		end
		ent:Spawn()
		if mat then
			ent:SetMaterial(mat)
		end
	end
end

function GM:CreateBreakableDecoration(model, pos, ang, health, spawnent, mat, scale, noshadow, skin, nodraw, nonsolid)
	ang = ang or Angle()
	health = health or 100
	local ent = ents.Create("hl1_prop_breakable")
	if IsValid(ent) then
		ent:SetModel(model)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetHealth(health)
		if spawnent then
			ent.spawnobject = spawnent
		end
		if scale then
			ent:SetModelScale(scale)
		end
		if noshadow then
			ent:DrawShadow(false)
		end
		if skin then
			ent:SetSkin(skin)
		end
		if nodraw then
			ent:SetNoDraw(true)
		end
		ent:Spawn()
		if mat then
			ent:SetMaterial(mat)
		end
		if nonsolid then
			ent:SetNotSolid(true)
		end
		
		return ent
	end
end

function GM:CreateStaticDecoration(model, pos, ang, mat, scale, noshadow, skin, nodraw, nonsolid, color)
	ang = ang or Angle()
	local ent = ents.Create("hl1_prop_static")
	if IsValid(ent) then
		ent:SetModel(model)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		if scale then
			ent:SetModelScale(scale)
		end
		if noshadow then
			ent:DrawShadow(false)
		end
		if skin then
			ent:SetSkin(skin)
		end
		if nodraw then
			ent:SetNoDraw(true)
		end
		ent:Spawn()
		if scale then
			ent:Activate()
		end
		if mat then
			ent:SetMaterial(mat)
		end
		if nonsolid then
			ent:SetNotSolid(true)
		end
		if color then
			ent:SetColor(color)
		end
		
		return ent
	end
end

function GM:CreateMapDecoration(model, pos, ang, mat, scale, noshadow, nophys, skin, nodraw)
	ang = ang or Angle()
	local ent = ents.Create("prop_physics")
	if IsValid(ent) then
		ent:SetModel(model)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		if scale then
			ent:SetModelScale(scale)
		end
		if noshadow then
			ent:DrawShadow(false)
		end
		if skin then
			ent:SetSkin(skin)
		end
		if nodraw then
			ent:SetNoDraw(true)
		end
		ent:Spawn()
		if scale then
			ent:Activate()
		end
		if nophys then
			ent:PhysicsDestroy()
		else
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:Sleep()
				phys:EnableMotion(false)
			end
		end
		if mat then
			ent:SetMaterial(mat)
		end
		
		return ent
	end
end

function GM:CreateHologramDecoration(model, pos, ang, mat, scale, skin)
	ang = ang or Angle()
	local ent = ents.Create("hl1_prop_static")
	if IsValid(ent) then
		ent:SetModel(model)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:DrawShadow(false)
		if scale then
			ent:SetModelScale(scale)
		end
		if skin then
			ent:SetSkin(skin)
		end
		if nodraw then
			ent:SetNoDraw(true)
		end
		ent:Spawn()
		ent:SetNotSolid(true)
		if mat then
			ent:SetMaterial(mat)
		end
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ent:SetRenderFX(kRenderFxDistort)
		
		return ent
	end
end