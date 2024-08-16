DeriveGamemode("base")

MAP = {}

COOP_STATE_FIRSTLOAD = 0
COOP_STATE_TRANSITION = 1
COOP_STATE_INGAME = 2
COOP_STATE_GAMEOVER = 3
COOP_STATE_ENDTITLES = 4

PLAYER_NOTREADY = 1
PLAYER_READY = 2

DEFAULT_PLAYERMODEL_PATH = Model("models/player/coop/helmet.mdl")

LAST_CHECKPOINT_MINDISTANCE = 1500 -- used for "teleport to checkpoint" thingy

IMPORTANT_NPC_HP_SCALE = 4

BIND_VOTE_YES = KEY_F1
BIND_VOTE_NO = KEY_F2
BIND_THIRDPERSON = KEY_F3
BIND_QUICKMENU = KEY_F4

include("sh_chatsounds.lua")
include("sh_entity.lua")
include("sh_player.lua")
include("sh_skill.lua")
include("hl1_soundscripts.lua")
include("conflictfix.lua")
include("sh_crackmode.lua")

local mapFile = "maps/"..game.GetMap()..".lua"
local mapFileExists = file.Find(GM.FolderName.."/gamemode/"..mapFile, "LUA")[1]
if mapFileExists then
	include(mapFile)
	AddCSLuaFile(mapFile)
end

local mapCustomFile = "hl1coop/maps/"..game.GetMap()..".lua"
local mapCustomFileExists = file.Find(mapCustomFile, "LUA")[1]
if mapCustomFileExists then
	include(mapCustomFile)
	AddCSLuaFile(mapCustomFile)
	print("Loaded custom map script: "..mapCustomFile)
end

GM.Name = "Half-Life Co-op"

local cvar_sandbox = CreateConVar("hl1_coop_sandbox", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Load gamemode as sandbox", 0, 1)
if cvar_sandbox:GetBool() then
	DeriveGamemode("sandbox")
	GM.Name = "Half-Life Sandbox"
end

GM.Author = "Upset"
GM.Email = "themostupset@gmail.com"
GM.Version = "1.7.2 beta"
GM.Cooperative = true
GM.Changelog = [[]]

cvar_price_respawn_here = CreateConVar("hl1_coop_price_respawn_here", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, 'How much score "Respawn here with 25 hp" costs')
cvar_price_respawn_full = CreateConVar("hl1_coop_price_respawn_full", 500, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How much score respawn with full loadout costs")
cvar_price_respawn_survival = CreateConVar("hl1_coop_price_respawn_survival", 400, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How much score respawn in survival mode costs")
cvar_price_movetocheckpoint = CreateConVar("hl1_coop_price_movetocheckpoint", 50, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How much score teleporting to last checkpoint costs")
-- cvar_award_teammaterevive = CreateConVar("hl1_coop_award_teammaterevive", 50, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "")
cvar_gmodsuit = GetConVar("gmod_suit")

hl1_coop_sv_friendlyfire = CreateConVar("hl1_coop_sv_friendlyfire", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow friendly fire", 0, 1)
local hl1_coop_sv_custommodels = CreateConVar("hl1_coop_sv_custommodels", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Allow custom player models", 0, 1)
SetGlobalBool("hl1_coop_sv_custommodels", hl1_coop_sv_custommodels:GetBool())
if SERVER then
	cvars.AddChangeCallback("hl1_coop_sv_custommodels", function(name, value_old, value_new)
		local b = tobool(value_new)
		GAMEMODE:SetGlobalBool("hl1_coop_sv_custommodels", b)
	end)
end

player_manager.AddValidModel("Helmet (HLS)", DEFAULT_PLAYERMODEL_PATH)
player_manager.AddValidModel("Scientist (Einstein)(HLS)", "models/player/coop/scientist_einstien.mdl")
player_manager.AddValidModel("Scientist (Luther)(HLS)", "models/player/coop/scientist_luther.mdl")
player_manager.AddValidModel("Scientist (Slick)(HLS)", "models/player/coop/scientist_slick.mdl")
player_manager.AddValidModel("Scientist (Walter)(HLS)", "models/player/coop/scientist_walter.mdl")

function CallMapHook(name, ...)
	return hook.Call(name, MAP, ...)
end

function GM:GetCoopState()
	if self.IsSandboxDerived then return COOP_STATE_INGAME end
	return GetGlobalInt("HL1CoopState")
end

local HL1_Chapters = {
	["Hazard Course"] = "hls_hc",
	["Black Mesa Inbound"] = "hls00amrl",
	["Anomalous Materials"] = "hls01amrl",
	["Unforeseen Consequences"] = "hls02amrl",
	["Office Complex"] = "hls03amrl",
	["We've Got Hostiles"] = "hls04amrl",
	["Blast Pit"] = "hls05amrl",
	["Power Up"] = "hls06amrl",
	["On A Rail"] = {"hls07amrl", "hls07bmrl"},
	["Apprehension"] = "hls08amrl",
	["Residue Processing"] = "hls09amrl",
	["Questionable Ethics"] = "hls10amrl",
	["Surface Tension"] = {"hls11amrl", "hls11bmrl", "hls11cmrl"},
	["Forget About Freeman!"] = "hls12amrl",
	["Lambda Core"] = "hls13amrl",
	["Xen"] = "hls14amrl",
	["Interloper"] = "hls14bmrl",
	["Nihilanth"] = "hls14cmrl"
}

Campaigns = {
	{Title = "Half-Life", Maps = HL1_Chapters, Icon = "icon16/hl1.png"},
	-- {Title = "Uplink Extended", Maps = {"uplinkext1", "uplinkext2", "uplinkext3", "uplinkext4"}, Icon = "icon16/hl1.png"}
}

function AddCampaign(title, maptable, icon)
	icon = icon or "icon16/hl1.png"
	table.insert(Campaigns, {Title = title, Maps = maptable, Icon = icon})
end

function GM:GetChapterName(map)
	if map then
		for k, campaign in pairs(Campaigns) do		
			for chapter, maps in pairs(campaign.Maps) do
				if istable(maps) then
					if table.HasValue(maps, map) then
						return chapter
					end
				elseif maps == map then
					return chapter
				end				
			end
		end
	else	
		return MAP.ChapterTitle or "UNTITLED"
	end
end

local campaignFilesPath = "hl1coop/campaigns/"
local campaignFiles = file.Find(campaignFilesPath.."*", "LUA")
for _, File in pairs(campaignFiles) do
	local campaignFile = campaignFilesPath..File
	include(campaignFile)
	AddCSLuaFile(campaignFile)
end

function GM:IsCoop()
	return self.Cooperative and !game.SinglePlayer()
end

function GM:GetSurvivalMode()
	return GetGlobalBool("SurvivalMode")
end
	
function GM:GetSpeedrunMode()
	return GetGlobalBool("SpeedrunMode")
end

function GM:GetCrackMode()
	return GetGlobalBool("CrackMode")
end

function GM:Get1hpMode()
	return GetGlobalBool("1hpMode")
end

function FormattedTimer(t)
	local Time = string.FormattedTime(t, "%02i:%02i.%03i")
	local time_text = Time
	if t / 60 > 60 then
		local Time_ = string.FormattedTime(t)
		time_text = Time_.h..":"..Time
	end
	return time_text
end

function GM:PlayerNoClip(ply, b)
	if self.IsSandboxDerived then return self.BaseClass:PlayerNoClip(ply, b) end
	
	if ply:GetObserverMode() == OBS_MODE_ROAMING then return false end
	if !b then return true end
	
	return cvars.Bool("sv_cheats")
end

function GM:GetActivePlayersNumber(alive)
	if hook.Run("GetSurvivalMode") or GetGlobalBool("DisablePlayerRespawn") or alive then
		return #hook.Run("GetActivePlayersTable", alive)
	else
		return team.NumPlayers(TEAM_COOP)
	end
end

function GM:GetActivePlayersTable(alive)
	if hook.Run("GetSurvivalMode") or GetGlobalBool("DisablePlayerRespawn") or alive then
		local t = {}
		for _, pl in pairs(team.GetPlayers(TEAM_COOP)) do
			if pl:Alive() then
				table.insert(t, pl)
			end
		end
		return t
	else
		return team.GetPlayers(TEAM_COOP)
	end
end

local gibModels = {
	["models/gibs/hgibs.mdl"] = "models/gibs/hghl1.mdl",
	["models/gibs/agibs.mdl"] = "models/gibs/aghl1.mdl"
}
for _, model in pairs(gibModels) do
	util.PrecacheModel(model)
end
local function FixGibModel(ent)
	local mins, maxs = ent:GetCollisionBounds()
	ent:SetModel(gibModels[ent:GetModel()])
	ent:SetCollisionBounds(mins, maxs)
	local getbg = ent:GetBodygroup(0)
	if getbg == 0 or getbg == 1 then
		ent:SetBodygroup(0, math.random(1, ent:GetBodygroupCount(0) - 1)) // avoid throwing random amounts of the 0th gib. (skull)
	end
end

function GM:OnEntityCreated(ent)
	if ent:IsPlayer() then
		ent:InstallDataTable()
		ent:SetupDataTables()
	end	
	if ent:IsWeapon() then
		hook.Run("OnWeaponCreated", ent)
	end
	if SERVER then
		if IsValid(ent) then
			if ent:GetClass() == "gib" then
				timer.Simple(0, function()
					if IsValid(ent) and gibModels[ent:GetModel()] then
						FixGibModel(ent)
					end
				end)
			end
			if ent:IsNPC() then
				if self:IsCoop() then
					if MAP.ImportantNPCs then
						timer.Simple(0, function()
							if IsValid(ent) and (!MAP.ImportantHealthBlacklist or !MAP.ImportantHealthBlacklist[ent:GetName()]) then
								for k, v in pairs(MAP.ImportantNPCs) do
									if ent:GetName() == v then
										ent:SetHealth(ent:Health() * IMPORTANT_NPC_HP_SCALE)
									end
								end
							end
						end)
					end
					if ent:GetClass() == "hornet" then
						timer.Simple(0, function()
							if IsValid(ent) then
								local owner = ent:GetOwner()
								if IsValid(owner) and owner:IsPlayer() then
									ent:AddRelationship("player D_NU 1")
								end
							end
						end)
					end
				end
				if string.StartWith(ent:GetClass(), "monster_") then
					ent:SetSaveValue("m_fBoneCacheFlags", 1) -- instead of sv_pvsskipanimation 0
				end
				if ent:GetClass() == "monster_barnacle" then
					timer.Simple(0, function()
						if IsValid(ent) then
							local fixent = ents.Create("hl1_barnacle_fix")
							if IsValid(fixent) then
								fixent:SetPos(ent:GetPos() - Vector(0, 0, 1))
								fixent:SetParent(ent)
								fixent:Spawn()
							end
						end
					end)
				end
				self:FixCollisionBounds(ent, "monster_houndeye", Vector(-16, -16, 0), Vector(16, 16, 40))
				self:FixCollisionBounds(ent, "monster_bigmomma", Vector(-32, -32, 0), Vector(32, 32, 130))
				self:FixCollisionBounds(ent, "monster_apache", Vector(-256, -256, -64), Vector(256, 256, 100))
				if monsterDeadTable and monsterDeadTable[ent:GetClass()] then
					timer.Simple(0, function()
						if IsValid(ent) then
							ent:SetSaveValue("m_takedamage", 1)
							ent:SetSolid(SOLID_BBOX)
							ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
							ent:SetPos(ent:GetPos() + Vector(0,0,1))
						end
					end)
				end
				if !self.NPCHealthMultiplierBlacklist[ent:GetClass()] then
					ent:SetLagCompensated(true)
					timer.Simple(0, function()
						if IsValid(ent) then
							--[[local hpCvar = self.NPCHealthConVar[ent:GetClass()]
							if hpCvar then
								ent:SetHealth(cvars.Number(hpCvar, ent:Health()))
							end]]
							if ent:GetClass() == "monster_bigmomma" then
								ent:SetHealth(ent:Health() * cvars.Number("sk_bigmomma_health_factor", 1))
							end							
							ent:SetHealth(ent:Health() * hook.Run("NPCHealthMultiplier"))
							debugPrint(ent, "health: "..ent:Health(), "mul: "..hook.Run("NPCHealthMultiplier"))
						end
					end)
				end
			end
	
			if ent:GetClass() == "item_sodacan" then
				timer.Simple(.5, function()
					if IsValid(ent) then
						ent:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 8))
					end
				end)
			end
	
			hook.Run("EntityReplace", ent)
			
			if self:GetCrackMode() then
				timer.Simple(0, function()
					if IsValid(ent) then
						hook.Run("CrackModeEntCreated", ent)
					end
				end)
			end
		end
	end
	CallMapHook("OnEntCreated", ent)
end

function GM:OnWeaponCreated(wep)
	if wep:IsScripted() then
		-- small fix for TFA
		if weapons.IsBasedOn(wep:GetClass(), "tfa_gun_base") then
			if SERVER then
				wep.AllowSprintAttack = true
			else
				-- wep.WalkBobMult = 0
			end
		end
		-- and for MW2019
		if weapons.IsBasedOn(wep:GetClass(), "mg_base") then
			timer.Simple(0, function()
				if IsValid(wep) then
					function wep:CanSprint()
						return false
					end
				end
			end)
		end
	end
end

function GM:CreateTeams()

	if GAMEMODE.Deathmatch then
		TEAM_DEATHMATCH = 1
		team.SetUp( TEAM_DEATHMATCH, "DM Player", Color( 0, 0, 255 ) )
		team.SetSpawnPoint( TEAM_DEATHMATCH, "info_player_deathmatch" )
	else
		TEAM_COOP = 1
		team.SetUp( TEAM_COOP, "Coop Mate", Color( 255, 150, 0 ) )
		team.SetSpawnPoint( TEAM_COOP, "info_player_coop" )
	end
	team.SetSpawnPoint( TEAM_SPECTATOR, "worldspawn" )

end

function GM:ShouldCollide(ent1, ent2)
	if IsValid(ent1) and IsValid(ent2) and ent1:IsPlayer() and (ent2:IsPlayer() or IsValid(ent2:GetOwner()) and ent2:GetOwner():IsPlayer() and ent2:GetOwner():Team() == ent1:Team()) then return false end

	if ent1.ShouldCollide and ent1:ShouldCollide(ent2) or ent2.ShouldCollide and ent2:ShouldCollide(ent1) then return false end
	
	return true
end

local movekeys = {
	[IN_ATTACK] = true,
	[IN_ATTACK2] = true,
	[IN_BACK] = true,
	[IN_DUCK] = true,
	[IN_FORWARD] = true,
	[IN_JUMP] = true,
	[IN_LEFT] = true,
	[IN_MOVELEFT] = true,
	[IN_MOVERIGHT] = true,
	[IN_RIGHT] = true
}

function GM:KeyPress(ply, key)
	if SERVER and GAMEMODE:GetCoopState() == COOP_STATE_INGAME and ply:Team() == TEAM_COOP then
		if movekeys[key] then
			if !ply.canTakeDamage then
				ply.canTakeDamage = true
			end
		end
		if cvar_afktime:GetBool() then
			ply.afkTime = SysTime()
		end
	end
	if CLIENT and IsFirstTimePredicted() and ply:IsSpectator() then
		hook.Run("SpectatorKeyPress", ply, key)
	end
end

function GM:OnPlayerHitGround(ply, bInWater, bOnFloater, flFallSpeed)
	if CLIENT then
		ply.GroundHitSpeed = ply:GetVelocity():Length2D()
	elseif game.SinglePlayer() then
		ply:SendLua("LocalPlayer().GroundHitSpeed = "..ply:GetVelocity():Length2D())
	end
	if self:GetCrackMode() then
		hook.Run("CrackModePlayerHitGround", ply, bInWater, bOnFloater, flFallSpeed)
	end
end

--[[function GM:CalcMainActivity( ply, velocity )

	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )
	
	if CLIENT and self:IsCoop() and ply != LocalPlayer() then
		-- workaround by ZehMatt
		velocity = ply:GetActAbsVelocity(velocity)
	end

	if !( self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerVaulting( ply, velocity ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerDucking( ply, velocity ) ) then

		local len2d = velocity:Length2DSqr()
		if ( len2d > 22500 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then ply.CalcIdeal = ACT_MP_WALK end

	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	return ply.CalcIdeal, ply.CalcSeqOverride

end]]

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	if CLIENT and ply != LocalPlayer() then
		local vel = ply:GetActAbsVelocity()
		if vel:IsZero() then
			return true
		end
	end

	return !ply:Alive()
end

function GM:PlayerStepSoundTime( ply, iType, bWalking )

	local fStepTime = 350
	local fMaxSpeed = ply:GetMaxSpeed()
	local dir = ply:GetVelocity():GetNormalized():Dot(ply:GetForward())

	if ( iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT ) then
		
		if ( fMaxSpeed <= 100 ) then
			fStepTime = 450
			if dir < 0 then
				fStepTime = fStepTime / 1.25
			end
		elseif ( fMaxSpeed <= 300 ) then
			fStepTime = 350
		else
			fStepTime = 320
		end
	
	elseif ( iType == STEPSOUNDTIME_ON_LADDER ) then
	
		fStepTime = 450
	
	elseif ( iType == STEPSOUNDTIME_WATER_KNEE ) then
	
		fStepTime = 600
	
	end
	
	-- Step slower if crouching
	if ( ply:Crouching() ) then
		fStepTime = fStepTime + 50
	end
	
	return fStepTime
	
end

function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 300 ) then
		movement = ( len / maxseqgroundspeed / 1.75 )
	elseif ( len <= 300 ) then
		movement = ( len / maxseqgroundspeed / 1.2)
	end

	local rate = math.min( movement, 2 )
	
	if ply:Crouching() then
		rate = 1.35
	end

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( CLIENT ) then
		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

function GM:ShouldLockMovement()
	local state = GAMEMODE:GetCoopState()
	return state == COOP_STATE_TRANSITION or state == COOP_STATE_GAMEOVER or state == COOP_STATE_ENDTITLES
end

function GM:Move(ply, mv)
	return hook.Run("ShouldLockMovement")
end

local PLAYER_LONGJUMP_SPEED = 350
local DOLONGJUMP

local function DoCrouchTrace(origin, endpos)
	endpos = endpos or Vector()
	local plyTable = player.GetAll()
	local tr = util.TraceHull({
		start = origin,
		endpos = origin + endpos,
		filter = plyTable,
		mask = MASK_PLAYERSOLID,
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 72)
	})
	return tr
end

function GM:SetupMove(ply, move, cmd)
	if hook.Run("ShouldLockMovement") then
		move:SetMaxClientSpeed(0.1)
		return
	end

	if ply:Alive() and ply:GetMoveType() == MOVETYPE_WALK and !ply:OnGround() and ply:WaterLevel() < 1 then
		local tr = DoCrouchTrace(move:GetOrigin())
		if !tr.Hit then
			local crouchOffset = Vector(0,0,16)
			if !ply:Crouching() and cmd:KeyDown(IN_DUCK) then
				tr = DoCrouchTrace(move:GetOrigin(), -crouchOffset)
				move:SetOrigin(tr.HitPos)
				if tr.Hit then
					move:SetOrigin(move:GetOrigin() - crouchOffset)
				end
			end
			if ply:Crouching() and move:KeyReleased(IN_DUCK) then
				tr = DoCrouchTrace(move:GetOrigin(), crouchOffset)
				move:SetOrigin(tr.HitPos)
			end
		end
	end

	-- barnacle
	if ply:GetMoveType() == MOVETYPE_FLY then
		ply:SetMoveType(MOVETYPE_NONE)
		move:SetVelocity(Vector(0,0,0))
	end

	if self.NewChapterDelay and self.NewChapterDelay > CurTime() then
		move:SetMaxClientSpeed(0.1)
	end
	
	if ply:OnGround() and move:KeyDown(IN_USE) then
		local vel = move:GetVelocity()
		vel.x = vel.x / 64
		vel.y = vel.y / 64
		move:SetVelocity(vel)
	end
	
	if ply:GetLongJump() and !ply:Crouching() and move:GetMaxClientSpeed() >= 1 then
		if move:KeyPressed(IN_DUCK) then
			ply.LongJumpTime = CurTime() + .25
		end
		if ply.LongJumpTime and ply.LongJumpTime > CurTime() and move:KeyPressed(IN_JUMP) and move:GetVelocity():Length() > 50 and ply:OnGround() then
			DOLONGJUMP = true
		end
	end
	
	-- gravity prediction fix
	if SERVER then
		local grav = ply:GetGravity()
		if grav != ply:GetNWFloat("Gravity") then
			ply:SetNWFloat("Gravity", grav)
		end
	else
		local grav = ply:GetNWFloat("Gravity")
		if grav != ply:GetGravity() then
			ply:SetGravity(grav)
		end
	end
end

function GM:FinishMove(ply, move)
	local vel = move:GetVelocity()
	if DOLONGJUMP then
		for i = 1, 2 do
			vel[i] = move:GetAngles():Forward()[i] * PLAYER_LONGJUMP_SPEED * 1.6
		end
		vel[3] = math.sqrt(2 * 800 * 56.0)
		move:SetVelocity(vel)
		ply:SetViewPunchAngles(Angle(-5, 0, 0))
		
		DOLONGJUMP = nil
	end
	ply:SetActAbsVelocity(vel)
end

local lastMusicEnt
function GM:EntityEmitSound(t)
	local name = t.OriginalSoundName
	if SERVER then
		local ent = t.Entity
		if IsValid(ent) and ent:GetClass() == "ambient_generic" then
			if string.StartWith(name, "HL1_Music") or string.StartWith(name, "song_hl1_") then
				if !IsValid(lastMusicEnt) or lastMusicEnt != ent then
					hook.Run("PlayGlobalMusic", name)
				end
				lastMusicEnt = ent
				return false
			end
		end

		if ent:IsNPC() then
			local isSentence = ent:Health() > 0 and t.SoundName == "invalid.wav"
			hook.Run("SendCaption", name, ent:WorldSpaceCenter(), isSentence)
		end
		
		if t.SoundName == "items/ammo_pickup.wav" then
			t.SoundName = "items/gunpickup2.wav"
			return true
		end
	else
		if name == "BaseExplosionEffect.Sound" then
			t.SoundName = string.gsub(t.SoundName, "weapons/", "hl1/weapons/")
			return true
		end
	end
	
	if self:GetCrackMode() then
		return hook.Run("CrackModeEmitSound", t)
	end
end

local entUseBlacklist = {
	["gib"] = true,
	["hl1_playerclip"] = true,
	["hl1_prop_breakable"] = true,
	["hl1_prop_static"] = true
}
local entUseFix = {
	["func_tank"] = true,
	["func_tankmortar"] = true
}

function GM:FindUseEntity(ply, ent)
	if !IsValid(ent) then
		local tr = util.TraceHull({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:GetAimVector() * 64,
			filter = ply,
			mask = MASK_SHOT_HULL,
			mins = Vector(-16, -16, -16),
			maxs = Vector(16, 16, 16)
		})
		if IsValid(tr.Entity) and entUseFix[tr.Entity:GetClass()] then
			ent = tr.Entity
		end
	end
	if IsValid(ent) and ent.MaxUseDistance then
		local dist = ent:WorldSpaceCenter():DistToSqr(ply:EyePos())
		if dist > ent.MaxUseDistance then
			ent = NULL
		end
	end
	if ply:KeyPressed(IN_USE) then
		if IsValid(ent) and !entUseBlacklist[ent:GetClass()] then
			ply:UseSound(1)
			if MAP.NPCUseFix and ent:IsNPC() and MAP.NPCUseFix[ent:GetName()] then
				return -- prevents script breaking
			end
		else
			ply:UseSound()
		end
	end
	return ent
end

function GM:IsImportantNPC(npc)
	if MAP.ImportantNPCs then
		for k, v in pairs(MAP.ImportantNPCs) do
			if npc:GetName() == v then
				return true
			end
		end
	end
	return false
end

local bulletFixEnts = {
	["func_tank"] = true,
	["monster_sentry"] = true,
	["monster_miniturret"] = true,
	["monster_turret"] = true,
}

function GM:EntityFireBullets(ent, data)
	if bulletFixEnts[ent:GetClass()] then
		data.HullSize = 1
		return true
	end
	if SERVER and cvar_fixnihilanth:GetBool() then
		local swepCallbackFunc = data.Callback -- if some SWEP has callback function, we're getting it
		data.Callback = function(attacker, tr, dmginfo)
			if swepCallbackFunc then swepCallbackFunc(attacker, tr, dmginfo) end -- since we're overriding function, call one from SWEP (if any)
			local trEnt = tr.Entity
			if IsValid(trEnt) and trEnt:GetClass() == "monster_nihilanth" then
				local m_irritation = trEnt:GetInternalVariable("m_irritation")
				if m_irritation and m_irritation >= 2 then
					if !(tr.HitBox == 3 and tr.HitGroup == 2) then
						dmginfo:ScaleDamage(0)
					end
				end
			end
		end
		return true
	end
end

function GM:PlayerPostThink(ply)
	if SERVER and ply:IsFlagSet(FL_ONTRAIN) then
		local m_iPos = ply:GetInternalVariable("m_iTrain")
		local nw = ply:GetNW2Int("m_iTrain")
		if nw != m_iPos and m_iPos <= 5 then
			ply:SetNW2Int("m_iTrain", m_iPos)
		end
	end
end

function GM:ApplyViewModelHands(ply, wep, forceModelChange)
	ply = ply or LocalPlayer()
	wep = wep or IsValid(ply) and ply:GetActiveWeapon()
	if IsValid(wep) and wep:IsSwitchableHandsWeapon() then
		if ply:ShouldUseHands() then
			if wep.CModelSatchel and wep.CModelRadio then
				wep.ModelSatchelView = wep.CModelSatchel
				wep.ModelRadioView = wep.CModelRadio
				if wep.ViewModel == wep.VModelSatchel then
					wep.ViewModel = wep.CModelSatchel
				end
			else
				wep.ViewModel = wep.CModel
			end
			wep.UseHands = true
		else
			if wep.VModelSatchel and wep.VModelRadio then
				wep.ModelSatchelView = wep.VModelSatchel
				wep.ModelRadioView = wep.VModelRadio
				if wep.ViewModel == wep.CModelSatchel then
					wep.ViewModel = wep.VModelSatchel
				end
			else
				wep.ViewModel = wep.VModel
			end
			wep.UseHands = false
		end
		if forceModelChange or !IsValid(ply:GetActiveWeapon()) then
			local vm = ply:GetViewModel()
			if IsValid(vm) and vm:GetModel() != wep.ViewModel then
				vm:SetModel(wep.ViewModel)
			end
		end
	end
	hook.Run("ApplyHDViewModel", wep, ply, forceModelChange)
end

function GM:ApplyHDViewModel(wep, ply, force)
	if IsValid(wep) and wep.IsHL1Base and wep:IsHDEnabled() then
		wep:ApplyHDViewModel()
		if force then
			local vm = ply:GetViewModel()
			if IsValid(vm) and vm:GetModel() != wep.ViewModel then
				vm:SetModel(wep.ViewModel)
			end
		end
	end
end

function GM:PlayerSwitchWeapon(ply, oldWep, newWep)
	if ply.UseEntity and IsValid(ply.UseEntity) then
		return true
	end
	if newWep:IsScripted() then
		if SERVER then
			net.Start("ApplyViewModelHands")
			net.WriteEntity(newWep)
			net.Send(ply)
			--[[timer.Simple(1, function()
				if IsValid(newWep) and ply:GetActiveWeapon() == newWep then
					net.Start("ApplyViewModelHands")
					net.WriteEntity(newWep)
					net.Send(ply)
				end
			end)]]
			if !IsValid(oldWep) and newWep.Primary.ClipSize == -1 then
				timer.Simple(0, function()
					if IsValid(newWep) and ply:GetActiveWeapon() == newWep then
						newWep:CallOnClient("Deploy")
						newWep:Deploy()
					end
				end)
			end
		end
		hook.Run("ApplyViewModelHands", ply, newWep)
		
		if self:GetCrackMode() then
			hook.Run("CrackModeWeaponSwitch", newWep)
		end
	end
end

function GM:PlayerButtonDown(ply, button)
	if game.SinglePlayer() and SERVER or CLIENT then
		if button == BIND_VOTE_YES then
			if IsFirstTimePredicted() then RunConsoleCommand("vote_yes") end
		elseif button == BIND_VOTE_NO then
			if IsFirstTimePredicted() then RunConsoleCommand("vote_no") end
		elseif button == BIND_THIRDPERSON then
			if CLIENT then
				if IsFirstTimePredicted() then 
					if cvar_thirdperson:GetBool() then
						cvar_thirdperson:SetBool(false)
						ChatMessage(LangString("chatmsg_thirdperson_off"), 5)
					else
						cvar_thirdperson:SetBool(true)
						ChatMessage(LangString("chatmsg_thirdperson_on"), 5)
					end
				end
			else
				if GetConVar("hl1_coop_cl_thirdperson"):GetBool() then
					RunConsoleCommand("hl1_coop_cl_thirdperson", "0")
				else
					RunConsoleCommand("hl1_coop_cl_thirdperson", "1")
				end
			end
		elseif button == BIND_QUICKMENU then
			if IsFirstTimePredicted() then RunConsoleCommand("hl1_coop_quickmenu") end
		end
	end
end

function GM:GetMapTime()
	return CurTime() - GetGlobalFloat("SpeedrunModeTime")
end

function GM:GetGameTime()
	return GetGlobalFloat("GameTime") >= 0 and GetGlobalFloat("GameTime") + self:GetMapTime() or -1
end

function GetHL1WeaponClassTable()
	local weps = {
		"weapon_crowbar",
		"weapon_glock",
		"weapon_357",
		"weapon_mp5",
		"weapon_shotgun",
		"weapon_crossbow",
		"weapon_rpg",
		"weapon_gauss",
		"weapon_egon",
		"weapon_hornetgun",
		"weapon_handgrenade",
		"weapon_satchel",
		"weapon_tripmine",
		"weapon_snark"
	}
	return weps
end

function GetHL1AmmoEntTable()
	local ammo = {
		"ammo_9mmar",
		"ammo_9mmclip",
		"ammo_357",
		"ammo_argrenades",
		"ammo_buckshot",
		"ammo_crossbow",
		"ammo_gaussclip",
		"ammo_glockclip",
		"ammo_mp5clip",
		"ammo_mp5grenades",
		"ammo_rpgclip"		
	}
	return ammo
end

function GetHL1WeaponClassTable_Alt()
	local weps = {
		["weapon_crowbar"] = true,
		["weapon_glock"] = true,
		["weapon_357"] = true,
		["weapon_mp5"] = true,
		["weapon_shotgun"] = true,
		["weapon_crossbow"] = true,
		["weapon_rpg"] = true,
		["weapon_gauss"] = true,
		["weapon_egon"] = true,
		["weapon_hornetgun"] = true,
		["weapon_handgrenade"] = true,
		["weapon_satchel"] = true,
		["weapon_tripmine"] = true,
		["weapon_snark"] = true
	}
	return weps
end

if SERVER then

	net.Receive("HL1PickupEditor", function(len, ply)
		if IsValid(ply) and ply:IsPlayer() and ply:IsAdmin() then
			local class, isitem = net.ReadString(), net.ReadBool()
			ply:GivePickupEditor(class, isitem)
		end
	end)

end

local function PickupEditorAutoComplete(cmd, stringargs, isitem)
	stringargs = string.Trim(stringargs)
	stringargs = string.lower(stringargs)
	
	local tbl = {}
	
	local lst = isitem and list.Get("SpawnableEntities") or list.Get("Weapon")
	
	for class, t in SortedPairs(lst) do
		if string.find(class, stringargs) then
			table.insert(tbl, cmd.." "..class)
		end
	end
	
	return tbl
end

concommand.Add("addweaponpickup", function(ply, cmd, args)
	if !IsValid(ply) or !ply:IsAdmin() then return end
	local class = tostring(args[1])
	if SERVER then
		ply:GivePickupEditor(class)
	else
		net.Start("HL1PickupEditor")
		net.WriteString(class)
		net.WriteBool(false)
		net.SendToServer()
	end
end, function(cmd, stringargs)
	return PickupEditorAutoComplete(cmd, stringargs)
end)

concommand.Add("additempickup", function(ply, cmd, args)
	if !IsValid(ply) or !ply:IsAdmin() then return end
	local class = tostring(args[1])
	if SERVER then
		ply:GivePickupEditor(class, true)
	else
		net.Start("HL1PickupEditor")
		net.WriteString(class)
		net.WriteBool(true)
		net.SendToServer()
	end
end, function(cmd, stringargs)
	return PickupEditorAutoComplete(cmd, stringargs, true)
end)