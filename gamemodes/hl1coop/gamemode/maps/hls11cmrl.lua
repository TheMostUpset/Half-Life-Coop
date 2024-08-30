MAP.ChapterTitle = "#HL1_Chapter12_Title"
MAP.ShowChapterTitle = false

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-42, -765, -170), Angle(25, 120, 0))
end

local tele0pos = Vector(-292, -455, -295)
local tele1pos = Vector(280, -20, -305)
local tele2pos = Vector(265, 605, -1105)
local tele3pos = Vector(2060, 2610, -1100)
local tele4pos = Vector(3523, 3088, -715)
local tele5pos = Vector(570, -3460, -620)
local tele6pos = Vector(1944, -2456, -685)

MAP.ImportantNPCs = {"barney1"}

MAP.EnvFadeWhitelist = {
	["leveldead_shake5f"] = true,
	["leveldead_fade"] = true
}

function MAP:CreateMapCheckpoints()
	-- weapon room
	GAMEMODE:CreateCheckpointTrigger(2, Vector(1955, 3542, -607), Vector(2018, 3594, -496), Vector(1985, 3295, -600), Angle(0, 45, 0), {tele0pos, tele1pos, tele2pos, tele3pos}, "weapon_hornetgun")
	-- snark vent
	GAMEMODE:CreateCheckpointTrigger(3, Vector(245, -989, -413), Vector(237, -917, -355), Vector(520, -1960, -420), Angle(0, 90, 0), {tele0pos, tele1pos, tele2pos, tele3pos, tele4pos}, "weapon_hornetgun", snark_func)
end

local rocketsPassed
local rocketsPassedPos = Vector(400, 320, -1100)
local rocketsPassedAng = Angle(0, 180, 0)

local function CreateWeaponBlock()		
	-- TODO: fix gauss blast damage
	local blockWeapons = ents.Create("hl1_trigger_func")
	if IsValid(blockWeapons) then
		function blockWeapons:Touch(ent)
			-- probably it can remove func_door lift as well, need to recheck
			if !ent:IsPlayer() then
				ent:Remove()
			end
		end
		blockWeapons:Spawn()
		blockWeapons:SetCollisionBoundsWS(Vector(153, 288, -513), Vector(328, 112, -543))
	end
end

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "chase_mm" then
		if game.SinglePlayer() then
			GAMEMODE:Checkpoint(1, rocketsPassedPos, rocketsPassedAng, {tele0pos, tele1pos}, activator)
			for k, v in ipairs(ents.FindInBox(Vector(-389, -561, -118), Vector(769, 731, -452))) do
				if v:GetClass() == "monster_headcrab" then
					v:Remove()
				end
			end
		else
			if !rocketsPassed then
				GAMEMODE:RemoveCoopSpawnpoints()
				GAMEMODE:Checkpoint(1, rocketsPassedPos, rocketsPassedAng, {tele0pos, tele1pos}, activator)
				GAMEMODE:CreateCoopSpawnpoints(rocketsPassedPos, rocketsPassedAng)
				CreateWeaponBlock()
				rocketsPassed = true
			end
		end
	end
	if ent:GetName() == "bustmm" then
		GAMEMODE:Checkpoint(4, Vector(2990, -2946, -440), Angle(0,180,0), {tele0pos, tele1pos, tele2pos, tele3pos, tele4pos, tele5pos}, activator, "weapon_hornetgun")
	end
	if ent:GetName() == "radio1" then
		GAMEMODE:Checkpoint(5, Vector(-1290, 1350, -350), Angle(0,180,0), {tele0pos, tele1pos, tele2pos, tele3pos, tele4pos, tele5pos, tele6pos}, activator, "weapon_hornetgun")
	end
end

local function FixCrates()
	local found = false
	for k, v in ipairs(ents.FindInBox(Vector(2721, -3198, -736), Vector(2464, -3012, -577))) do
		if v:GetClass() == "func_breakable" then
			v.defaultSpawnFlags = v:GetSpawnFlags()
			v:SetSaveValue("m_takedamage", 0)
			v:SetKeyValue("spawnflags", 0)
			found = true
		end
		if v:GetClass() == "prop_physics" then -- the white box we created
			found = true
		end
	end
	return found
end

hook.Add("Modify1hpModeEntities", "1hpFixCrates", FixCrates)
function MAP:OnSkillLevelChange(skill)
	if skill > 3 then
		if !FixCrates() then
			GAMEMODE:CreateMapDecoration("models/hunter/blocks/cube2x2x2.mdl", Vector(2578,-3088,-688))
		end
	else
		for k, v in ipairs(ents.FindInBox(Vector(2721, -3198, -736), Vector(2464, -3012, -577))) do
			if v:GetClass() == "func_breakable" and v.defaultSpawnFlags then
				v:SetSaveValue("m_takedamage", 2)
				v:SetKeyValue("spawnflags", v.defaultSpawnFlags)
			end
			if v:GetClass() == "prop_physics" then
				v:Remove()
			end
		end
	end
end

local tank_breakable
function MAP:FixMapEntities()
	for k, v in ipairs(ents.FindByClass("func_breakable")) do
		if v:GetPos() == Vector(3307,4399,-788) then
			tank_breakable = v
			tank_breakable:SetSaveValue("m_takedamage", 0)
		end
	end	
	for k, v in ipairs(ents.FindByClass("ambient_generic")) do
		if v:GetName() == "brad_break_shakea" then
			v:SetSaveValue("message", "weapons/mortarhit.wav")
		end
	end
	if GAMEMODE:GetSkillLevel() > 3 then
		FixCrates()
	end
	for k, v in ipairs(ents.FindByClass("ambient_generic")) do
		local snd = v:GetInternalVariable("message")
		if string.find(snd, "weapons/explode") then
			snd = string.gsub(snd, "weapons/explode", "hl1/weapons/explode")
			v:SetSaveValue("message", snd)
		end
	end
end

local expTrig
local barrels = {
	["can_expl1_mm"] = true,
	["can_expl2_mm"] = true,
	["can_expl3_mm"] = true
}

local function DeleteExplosionTrigger()
	local ent = ents.FindByName("leveldead_mm")[1]
	if IsValid(ent) then
		ent:Remove()
	end
	expTrig = true
end

local function OspreyGruntCount()
	local count = 0
	for k, v in ipairs(ents.FindByClass("monster_human_grunt")) do
		local owner = v:GetOwner()
		if IsValid(owner) and owner:GetClass() == "monster_osprey" then
			count = count + 1
		end
	end
	return count
end

function MAP:OnEntCreated(ent)
	if ent:GetClass() == "monster_mortar" then
		timer.Simple(0, function()
			if IsValid(ent) then
				ent:SetOwner(NULL)
			end
		end)
	end
	if ent:GetClass() == "monster_human_grunt" then
		timer.Simple(0, function()
			if IsValid(ent) then
				local owner = ent:GetOwner()
				if IsValid(owner) and owner:GetClass() == "monster_osprey" then
					local m_hGruntCount = OspreyGruntCount()
					local maxGrunts = 8
					local skill = GAMEMODE:GetSkillLevel()
					if skill == 2 then
						maxGrunts = maxGrunts + 4
					elseif skill > 2 then
						maxGrunts = maxGrunts + 8
					end
					if m_hGruntCount >= maxGrunts then
						ent.IsSetToRemove = true
						ent:Remove()
					end
				end
			end
		end)
	end
	if ent:GetClass() == "beam" then
		timer.Simple(0, function()
			if IsValid(ent) then
				local m_hEndEntity = ent:GetInternalVariable("m_hEndEntity")
				if IsValid(m_hEndEntity) and m_hEndEntity:GetClass() == "monster_human_grunt" and m_hEndEntity.IsSetToRemove then
					ent:Remove()
				end
			end
		end)
	end
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	local class, name = ent:GetClass(), ent:GetName()
	if class == "monster_osprey" and name == "osprey1" and input == "Activate" then
		timer.Simple(1, function()
			if IsValid(ent) then
				local grunts = ents.FindByClass("monster_human_grunt")
				ent:SetSaveValue("m_iUnits", 64) -- not setting max value but breaking it
			end
		end)
	end
	if class == "multi_manager" and name == "brad_mover_relay" and IsValid(tank_breakable) then
		tank_breakable:SetSaveValue("m_takedamage", 2)
	end
	if !expTrig and IsValid(activator) and (activator:IsPlayer() or activator:IsNPC()) and (class == "logic_relay" and name == "leveldead_mm" and input == "Trigger" or barrels[name]) then
		expTrig = true
		local act_owner = activator:GetOwner()
		if IsValid(act_owner) and act_owner:IsPlayer() then
			activator = act_owner
		end
		local name = activator:IsPlayer() and activator:Nick() or activator:GetClass()
		ChatMessage({"#game_explosiontrig", name}, 2)
	end
	if class == "env_shake" and name == "leveldead_shake1" then
		GAMEMODE:GameOver(true)
	end
	if class == "func_door_rotating" and name == "barney_gate_open1" and input == "Open" then
		table.RemoveByValue(self.ImportantNPCs, "barney1")
	end
	
	if class == "func_tankmortar" and name == "brad_cannon" and input == "Activate" then
		ent.targetname = "brad_turret"
		ent:Initialize()
		--ent.FixTankEntity = true
		ent.FireSound = "ambience/biggun1.wav"
	end
end

function MAP:OnMapRestart()
	if self.ImportantNPCs and !table.HasValue(self.ImportantNPCs, "barney1") then
		table.insert(self.ImportantNPCs, "barney1")
	end
	expTrig = nil
	if rocketsPassed then
		GAMEMODE:RemoveCoopSpawnpoints()
		GAMEMODE:CreateCoopSpawnpoints(rocketsPassedPos, rocketsPassedAng)
		CreateWeaponBlock()
		DeleteExplosionTrigger()
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-100, 2451, -1140), Angle(0, -120, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(-69, 2397, -1072), Angle(-70, -170, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(2536, 3820, -600), Angle(0, 50, 0))
	GAMEMODE:CreateWeaponEntity("weapon_crossbow", Vector(-170, -1814, -380), Angle(0, 100, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(876, -3024, -560), Angle(0, 94, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(3015, -2880, -420), Angle(0, 35, 0))
	GAMEMODE:CreateWeaponEntity("weapon_handgrenade", Vector(1443, -1730, -713), Angle())
	GAMEMODE:CreateWeaponEntity("weapon_satchel", Vector(2246, -2058, -690), Angle(0, 180, 0))
	GAMEMODE:CreateWeaponEntity("weapon_gauss", Vector(2435, -1070, -380), Angle(0, -90, 0))
	--GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(376, -2760, -635), Angle(90, 0, 0))
	GAMEMODE:CreatePickupEntity("ammo_9mmclip", Vector(365, -2755, -650), Angle(0, -5, 0))
	
	for i = 0, 160, 40 do
		GAMEMODE:CreatePickupEntity("ammo_gaussclip", Vector(2091 + i, 2775, -580), Angle(0, 90, 0))
		GAMEMODE:CreatePickupEntity("ammo_gaussclip", Vector(2091 + i, 2647, -580), Angle(0, 90, 0))
	end
	GAMEMODE:CreateWeaponEntity("weapon_egon", Vector(2274, 2705, -580), Angle(0, 180, 0))
	for i = 0, 120, 30 do
		GAMEMODE:CreatePickupEntity("item_healthkit", Vector(2515, 2836 + i, -580), Angle(0, math.random(-26, 26), 0))
		GAMEMODE:CreatePickupEntity("item_battery", Vector(2147, 2831 + i, -580), Angle())
		GAMEMODE:CreatePickupEntity("ammo_argrenades", Vector(2195, 2831 + i, -580), Angle(0, math.random(-180, 180), 0))
	end
	
	-- moves players from spawn once rockets room is passed
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		function fTrig:Touch(ent)
			if rocketsPassed and ent:IsPlayer() then
				ent:Spawn()
			end
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(-206, -781, -128), Vector(423, -386, -352))
	end
	-- deletes explosion trigger so it couldn't ruin level progress
	local deleteExplosion = ents.Create("hl1_trigger_func")
	if IsValid(deleteExplosion) then
		deleteExplosion.TouchFunction = function()
			DeleteExplosionTrigger()
			deleteExplosion:Remove()
		end
		deleteExplosion:Spawn()
		deleteExplosion:SetCollisionBoundsWS(Vector(1314, 2510, -1152), Vector(1296, 2287, -1002))
	end
	
	-- sets the name for tank so it can be detected in EntityTakeDamage hook
	for k, v in ipairs(ents.FindByName("tank_health")) do
		if v:GetClass() == "func_breakable" then
			v:SetName("tank_break_explob")
		end
	end
	
	-- we dont need this in coop
	for k, v in ipairs(ents.FindByClass("scripted_sequence")) do
		if v:GetName() == "watchout" or v:GetName() == "watchoutforthedoorsbarney" then
			v:Remove()
		end
	end
	
	local rem = ents.FindByClass("npc_enemyfinder")
	table.Add(rem, ents.FindByClass("ai_relationship"))
	for k, v in pairs(rem) do
		v:Remove()
	end
	for k, v in ipairs(ents.FindByName("sniper1")) do
		if v:GetClass() == "func_tank" then
			local cEnt = ents.Create("func_tank_controller")
			if IsValid(cEnt) then
				cEnt:SetParent(v)
				cEnt:SetPos(v:GetPos())
				cEnt:Spawn()
			end
		end
	end
end

function SkipTripmines()
	if rocketsPassed or game.SinglePlayer() then return end
	rocketsPassed = true
	GAMEMODE:GameRestart()
end

function TripminesSkipped()
	return rocketsPassed
end