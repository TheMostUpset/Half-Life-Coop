MAP.ChapterTitle = "#HL1_Chapter10_Title"
MAP.ShowChapterTitle = true

MAP.DisableFullRespawn = true

if CLIENT then return end

MAP.EnvFadeWhitelist = {
	["fadein"] = true,
	["fadeout"] = true,
	["fadein2"] = true,
	["level_fadein2"] = true
}

MAP.StartingWeapons = false

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-582, -854, 233), Angle(5, 45, 0))
end
	
function MAP:CreateMapEventCheckpoints(ent, activator)
	local tele1pos = Vector(-2615, 120, 520)
	local tele2pos = Vector(-474, 1586, 55)
	if ent:GetName() == "music_track_22" then
		local pos = Vector(-425, 1025, 24)
		local ang = Angle(0, 45, 0)
		GAMEMODE:Checkpoint(1, pos, ang, tele1pos, activator, "weapon_crowbar")
	end
	if ent:GetName() == "gib1" then
		local pos = Vector(-2400, -1380, -860)
		local ang = Angle(0, 90, 0)
		local weptable = {"weapon_crowbar", "weapon_357", "weapon_satchel"}
		GAMEMODE:Checkpoint(2, pos, ang, {tele1pos, tele2pos}, activator, weptable)
	end
end

function MAP:FixMapEntities()
	local fTrigPipe = ents.Create("hl1_trigger_func")
	if IsValid(fTrigPipe) then
		fTrigPipe.TouchFunction = function(ply)
			if ply:GetVelocity()[3] < -500 then
				ply:SetVelocity(Vector(0, 0, 250))
			end
		end
		fTrigPipe:Spawn()
		fTrigPipe:SetCollisionBoundsWS(Vector(-2784, 72, 170), Vector(-2888, 184, 190))
	end
	
	local fTrigSpawn = ents.Create("hl1_trigger_func")
	if IsValid(fTrigSpawn) then
		fTrigSpawn.TouchFunction = function(ply)
			if ply:GetVelocity()[3] < -500 then
				ply:SetVelocity(Vector(0, 0, 250))
			end
		end
		fTrigSpawn:Spawn()
		fTrigSpawn:SetCollisionBoundsWS(Vector(-2600, 380, 492), Vector(-2643, 338, 495))
	end
end

local noCutscene
local plyTelePos = Vector(-2624, 376, 645)
local plySpawnPos = plyTelePos - Vector(0, 0, 1)

function MAP:ModifyMapEntities()
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		for k, v in pairs(ents.FindByName("wottadrag")) do
			v:Remove()
		end
		for k, v in pairs(ents.FindByClass("env_fade")) do
			v:Remove()
		end
		for k, v in pairs(ents.FindByName("camera_drag")) do
			if v:GetClass() == "point_viewcontrol" then
				v:Remove()
			end
		end
	else
		if noCutscene then
			GAMEMODE:CreateCoopSpawnpoints(plySpawnPos, Angle(0, -100, 0))
			for k, v in pairs(ents.FindByName("camera_drag")) do
				if v:GetClass() == "point_viewcontrol" then
					v:Remove()
				end
			end
			for k, v in pairs(ents.FindByClass("env_fade")) do
				v:Remove()
			end		
			for k, v in pairs(ents.FindByName("block_forblackscreen")) do
				v:Fire("Kill")
			end
			for k, v in pairs(ents.FindByName("compactormm")) do
				v:Fire("Trigger")
			end
			for k, v in pairs(ents.FindByName("intro_box")) do
				v:Fire("Break")
			end
		end
	end
end

function MAP:OnPlayerSpawn(ply)
	if !noCutscene and GAMEMODE:IsCoop() and !ply:IsBot() then
		local camera = ents.FindByName("camera_drag")[1]
		if IsValid(camera) then
			ply:SetPos(Vector(1362, -1621, 2504))
			timer.Simple(1, function()
				if IsValid(ply) and IsValid(camera) then
					if ply:GetViewEntity() != camera then
						ply:SetViewEntity(camera)
					end
				end
			end)
		end
	end
end

function MAP:OperateMapEvents(ent, input, caller)
	if !noCutscene and ent:GetClass() == "trigger_teleport" and ent:GetName() == "compactor_teleport" and input == "Enable" and GAMEMODE:IsCoop() then
		GAMEMODE:CreateCoopSpawnpoints(plySpawnPos, Angle(0, -100, 0))
		for k, v in pairs(player.GetHumans()) do
			v:SetPos(plyTelePos)
			v:SetViewEntity()
			v:Freeze(false)
		end
		local camera = ents.FindByName("camera_drag")[1]
		if IsValid(camera) then
			camera:Remove()
		end
		noCutscene = true
	end
	if ent:GetName() == "intro_box" and input == "Break" and IsValid(caller) and caller:GetClass() == "multi_manager" then
		GAMEMODE:ResetSpeedrunTimer()
	end
end

function MAP:OnEntCreated(ent)
	if ent:GetClass() == "item_suit" then
		timer.Simple(0, function()
			if IsValid(ent) and ent:GetName() == "player_spawn_items" then
				ent:Remove()
			end
		end)
	end
end

function MAP:CreateSurvivalEntities()
	GAMEMODE:CreateWeaponEntity("weapon_healthkit", Vector(-2600, 197, 504), Angle(0, -65, 0))
end

function MAP:OnCheckpoint()
	self.StartingWeaponsSurvival = "weapon_crowbar"
end

function MAP:PreMapRestart()
	if !noCutscene and GAMEMODE:IsCoop() then
		local box = ents.FindByName("intro_box")[1]
		if !IsValid(box) then
			noCutscene = true
		end
	end
end

function MAP:OnMapRestart()
	self.StartingWeaponsSurvival = nil
	
	if !noCutscene and GAMEMODE:IsCoop() then
		local camera = ents.FindByName("camera_drag")[1]
		if IsValid(camera) then
			for k, v in pairs(player.GetHumans()) do
				v:SetPos(Vector(1362, -1621, 2504))
				v:Freeze(true)
				timer.Simple(2, function()
					if IsValid(v) and IsValid(camera) then
						if v:GetViewEntity() != camera then
							v:SetViewEntity(camera)
						end
					end
				end)
			end
		end
	end
end