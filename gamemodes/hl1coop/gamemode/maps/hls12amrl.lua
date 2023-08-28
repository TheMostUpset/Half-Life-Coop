MAP.ChapterTitle = "#HL1_Chapter13_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_hornetgun", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(470, -1000, 710), Angle(5, 65, 0))
end

function MAP:FixMapEntities()
	local rem = ents.FindByClass("npc_enemyfinder")
	table.Add(rem, ents.FindByClass("ai_relationship"))
	for k, v in pairs(rem) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByName("trigger_music_track_16")) do
		v:Remove()
		local fTrig = ents.Create("hl1_trigger_func")
		if IsValid(fTrig) then
			fTrig.TouchFunction = function(ply)					
				hook.Run("PlayGlobalMusic", "HL1_Music.track_16")
				fTrig:Remove()
			end
			fTrig:SetPos(v:GetPos())
			fTrig:Spawn()
			fTrig:SetCollisionBounds(v:GetCollisionBounds())
		end
	end
	
	for k, v in pairs(ents.FindByName("siloguardgunwav")) do
		local ambient = ents.Create("ambient_generic")
		ambient:SetSaveValue("message", v:GetInternalVariable("message"))
		ambient:SetKeyValue("health", 10)
		ambient:SetKeyValue("radius", 10240)
		ambient:SetKeyValue("spawnflags", 48)
		ambient:SetName(v:GetName())
		ambient:SetPos(v:GetPos())
		ambient:Spawn()
		ambient:Activate()
		
		v:Remove()
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(889, -491, 630), Angle(0, 30, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(676, -60, 621), Angle(0, 178, 10))
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-2448, -902, 230), Angle(0, 178, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-2080, -292, 183), Angle(0, 20, 0))
	GAMEMODE:CreateWeaponEntity("weapon_crossbow", Vector(-2666, -1963, -1150), Angle(0, 80, 0))
	GAMEMODE:CreateWeaponEntity("weapon_satchel", Vector(-3232, -1908, -1180), Angle(0, 180, 0))
	GAMEMODE:CreateWeaponEntity("weapon_crowbar", Vector(-2959, -2074, -1171), Angle(0, 50, 0))
	GAMEMODE:CreatePickupEntity("ammo_buckshot", Vector(-2838, -1557, -590), Angle(0, 20, 0))
	GAMEMODE:CreatePickupEntity("ammo_mp5clip", Vector(-2773, -1573, -625), Angle(0, -30, 0))
	GAMEMODE:CreateWeaponEntity("weapon_handgrenade", Vector(-2168, 1562, -1730), Angle(0, 50, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-3485, 1197, -1843), Angle(0, 20, 0))
	
	for k, v in pairs(ents.FindByName("blocked")) do
		v:SetNotSolid(true)
		v:SetNoDraw(true)
	end
	
	for k, v in pairs(ents.FindInSphere(Vector(-2825, 24, -586), 16)) do
		if v:GetClass() == "func_breakable" and v:GetName() == "" then
			v:SetName("tank_break_explob")
		end
	end

	for k, v in pairs(ents.FindByClass("func_tanklaser")) do
		local cEnt = ents.Create("func_tank_controller")
		if IsValid(cEnt) then
			cEnt:SetParent(v)
			cEnt:SetPos(v:GetPos() + Vector(0,0,32))
			cEnt:Spawn()
		end
	end
	for k, v in pairs(ents.FindByName("biggun")) do
		local cEnt = ents.Create("func_tank_controller")
		if IsValid(cEnt) then
			cEnt:SetParent(v)
			cEnt:SetPos(v:GetPos() - Vector(0,48,0))
			cEnt:Spawn()
		end
	end
end

local tele1pos = Vector(835, 1000, 665)
local tele2pos = Vector(-2950, 1945, -555)
local tele3pos = Vector(-933, 957, -1915)

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "hitsmm" then
		GAMEMODE:Checkpoint(1, Vector(-3555, -990, -1160), Angle(0, -45, 0), tele1pos, activator)
	end
	if ent:GetName() == "music_track_18" then
		GAMEMODE:Checkpoint(2, Vector(-3560, 680, -1835), Angle(0, 90, 0), {tele1pos, tele2pos}, activator)
	end
	if ent:GetName() == "Bullsquid_maker" then
		GAMEMODE:Checkpoint(3, Vector(-895, 2575, -4170), Angle(0, 150, 0), {tele1pos, tele2pos, tele3pos}, activator)
	end
end

local rocks = {
	["1b"] = true,
	["2b"] = true,
	["3b"] = true,
	["4b"] = true,
	["5b"] = true,
	["6b"] = true,
	["7b"] = true
}

function MAP:OnPlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:GetClass() == "func_door" and rocks[attacker:GetName()] then
		victim.KilledByFall = true
	end
end

function MAP:CreateExtraEnemies()
	GAMEMODE:CreateNPCSpawner("monster_human_assassin", 3, Vector(-954, 1707, -3905), Angle(0, -45, 0), 800, false)
	GAMEMODE:CreateNPCSpawner("monster_human_assassin", 5, Vector(-321, -101, -3656), Angle(0, -90, 0), 1500, false)
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	local class, name = ent:GetClass(), ent:GetName()
	if class == "func_door" and name == "c3a2_piston" and input == "Toggle" then
		timer.Simple(16, function()
			if IsValid(ent) then
				ent:Fire("Close")
			end
		end)
	end
	
	if game.SinglePlayer() then
		if class == "func_door" and name == "blocked" and input == "Open" then
			for k, v in pairs(ents.FindByClass("info_player_start")) do
				v:SetPos(Vector(827.5, 550, 613))
			end
		end
	end
end