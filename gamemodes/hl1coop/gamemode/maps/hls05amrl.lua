MAP.ChapterTitle = "#HL1_Chapter6_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_shotgun", "weapon_handgrenade", "weapon_mp5"}

MAP.FallToDeath = {
	{Vector(702, 61, -2418), Vector(-1959, -2615, -1980)},
	{Vector(-3648, -1402, -5388), Vector(-3239, -1813, -3738)}, -- fan
	{Vector(474, 2395, -4300), Vector(-433, 1459, -4426)}, -- generator

	{Vector(9205, 12018, -1372), Vector(8802, 10884, -1285)},
	{Vector(8802, 10884, -1372), Vector(8476, 11026, -1285)},
	{Vector(8476, 10884, -1372), Vector(8070, 12018, -1285)},
	{Vector(8476, 12018, -1372), Vector(8802, 11874, -1285)},
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-1692, 3278, 76), Angle(20, -45, 0))
	GAMEMODE:CreateViewPointEntity(Vector(563, -822, -362), Angle(35, -145, 0))
end

local tele0pos = Vector(-1931, 3095, -60)
local tele1pos = Vector(-1332, 3098, -354)
local tele2pos = Vector(-762, 3223, -2844)
local tele3pos = Vector(-637, -3564, -2755) -- lift to 05b
local tele4pos = Vector(-445, -2620, -955)
local tele5pos = Vector(-3558, -228, -1130)
local tele6pos = Vector(-856, 818, -1350)

local trainEnt

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "c1a4i_tentacle_sci" then
		GAMEMODE:Checkpoint(5, Vector(8078, 11243, 70), Angle(0, 103, 0), {tele0pos, tele2pos, tele3pos, tele4pos}, activator)
	end
end

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(-1499, 2948, -2394), Vector(-1165, 3248, -2479), Vector(-1332, 3298, -2794), Angle(), tele1pos)
	GAMEMODE:CreateCheckpointTrigger(3, Vector(-525, -4372, -2754), Vector(-563, -4228, -2639), Vector(-643, -4412, -2744), Angle(0,90,0), {tele1pos, tele2pos})
	
	GAMEMODE:CreateCheckpointTrigger(4, Vector(-571, -3420, -860), Vector(-705, -3354, -1006), Vector(-641, -3288, -1000), Angle(0,90,0), {tele0pos, tele2pos, tele3pos})
	GAMEMODE:CreateCheckpointTrigger(7, Vector(8399, 11005, -2954), Vector(8879, 11086, -2804), Vector(8340, 10775, -3470), Angle(), {tele0pos, tele2pos, tele3pos, tele4pos, tele5pos, tele6pos})
end

function MAP:FixMapEntities()	
	for k, v in pairs(ents.FindByName("tent_barney2")) do
		v:Remove()
	end
end

function MAP:ModifyMapEntities()
	local button = NULL
	for k, v in pairs(ents.FindByName("liftbut1")) do
		if v:GetClass() == "func_button" then
			button = v
			v:Fire("Lock")
		end
	end
	local func = function()
		if IsValid(button) then button:Fire("Unlock") end
	end

	local mins, maxs = Vector(-708, -3678, -2790), Vector(-608, -3596, -2720)
	local e_mins, e_maxs = Vector(-749, -3671, -2790), Vector(-527, -3458, -2720)
	
	if GAMEMODE:GetSpeedrunMode() then
		mins, maxs = e_mins, e_maxs
	end
	
	local wt = GAMEMODE:CreateWaitTrigger(mins, maxs, 30, false, func, WAIT_FREE, true)
	if !GAMEMODE:GetSpeedrunMode() and IsValid(wt) then
		function wt:StartTouch(ent)
			if ent:IsPlayer() and ent:Alive() then
				wt:SetCollisionBoundsWS(e_mins, e_maxs)
			end
		end
	end
	
	for k, v in pairs(ents.FindByName("stopbarsp")) do
		if v:GetClass() == "trigger_push" then
			v:Remove()
		end
	end
	
	for k, v in pairs(ents.FindByClass("func_breakable")) do
		local globalname = v:GetInternalVariable("globalname")
		if globalname != "" and string.StartWith(globalname, "c1a4_breakable_") then
			v:SetSaveValue("globalname", "")
		end
	end
	
	for k, v in pairs(ents.FindByClass("func_tracktrain")) do
		local globalname = v:GetInternalVariable("globalname")
		if globalname == "c1a4h_lift" then
			v:SetSaveValue("globalname", "")
			v:SetNoDraw(false)
			v:SetNotSolid(false)
			v:Spawn()
		end
	end
	
	-- 05b below
	
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(8660, 11078, 300), Angle(0, 145, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(8570, 11060, 300), Angle(0, 145, 0))
	GAMEMODE:CreatePickupEntity("item_battery",Vector(8732, 11051, 300), Angle())
	GAMEMODE:CreatePickupEntity("item_battery", Vector(8700, 11051, 300), Angle())
	GAMEMODE:CreatePickupEntity("item_battery", Vector(8668, 11051, 300), Angle())
	GAMEMODE:CreatePickupEntity("item_healthkit", Vector(8620, 11055, 300), Angle(0, 145, 0))
	
	for k, v in pairs(ents.FindInBox(Vector(12398, 10311, -4130), Vector(12333, 10251, -4200))) do
		if v:GetClass() == "item_healthkit" then
			v.RespawnTime = 5
		end
	end
	if game.MaxPlayers() > 2 then
		GAMEMODE:CreatePickupEntity("item_healthkit", Vector(12399, 10397, -4190), Angle(0, -10, 0), nil, 10)
		GAMEMODE:CreatePickupEntity("item_healthkit", Vector(12359, 10393, -4190), Angle(0, 50, 0), nil, 10)
	end
	if game.MaxPlayers() > 4 then
		GAMEMODE:CreatePickupEntity("item_healthkit", Vector(12256, 10255, -4190), Angle(0, 30, 0), nil, 15)
		GAMEMODE:CreatePickupEntity("item_healthkit", Vector(12253, 10302, -4190), Angle(0, 60, 0), nil, 15)
	end
	
	if game.MaxPlayers() > 1 then
		local tentFix = ents.Create("hl1_tentacle_fix")
		if IsValid(tentFix) then
			local pos = Vector(8639, 11446, -30)
			tentFix:SetPos(pos)
			tentFix.NPCPos = pos - Vector(0, 0, 420)
			tentFix:Spawn()
		end
	end
end

local oxy
local fuel

local VOXhasPlayed
function MAP:OperateMapEvents(ent, input, caller, activator)
	if GAMEMODE:IsCoop() and ent:GetClass() == "path_track" and ent:GetName() == "ridepath28" and input == "InPass" then
		GAMEMODE:Checkpoint(2, Vector(1016, -5776, -2876), Angle(0, 160, 0), {tele1pos, tele2pos})
		
		local train = caller
		train:SetNotSolid(true)
		timer.Simple(.4, function()
			if IsValid(train) then
				train:SetNotSolid(false)
			end
		end)
		local box = ents.FindInBox(Vector(891, -5621, -2858), Vector(672, -5542, -2814))
		for k, v in pairs(box) do
			if v:IsPlayer() then
				v:SetVelocity(Vector(1000, 0, 0))
				timer.Simple(.05, function()
					if IsValid(v) then
						v:SetLocalVelocity(Vector(-770, 0, 680))
					end
				end)
			end
		end
		trainEnt = NULL
	end
	-- 05b below
	if ent:GetClass() == "logic_relay" and input == "Trigger" then
		if ent:GetName() == "init_rocket_fire" then
			GAMEMODE:Checkpoint(6, Vector(7973, 11450, 70), Angle(), {tele0pos, tele2pos, tele3pos, tele4pos, tele5pos, tele6pos})
		end
		if ent:GetName() == "OxyAuto1" then
			oxy = true
		end
		if ent:GetName() == "FuelAuto1" then
			fuel = true
		end
		if oxy and fuel then
			for _, ply in pairs(GAMEMODE:GetActivePlayersTable()) do
				if ply != activator then
					ply:SendScreenHintTop("#notify_oxyfuel")
				end
			end
			oxy = nil
			fuel = nil
		end
	end
	if ent:GetClass() == "env_texturetoggle" and ent:GetName() == "power_indicator_toggle" and input == "IncrementTextureIndex" then
		for _, ply in pairs(GAMEMODE:GetActivePlayersTable()) do
			if ply != activator then
				ply:SendScreenHintTop("#notify_power")				
			end
		end
	end
	if !VOXhasPlayed and ent:GetClass() == "ambient_generic" and input == "PlaySound" and ent:GetName() == "fuel_vox" then
		local message = string.Replace(ent:GetSaveTable().message, "!", "!BMAS_")
		GAMEMODE:SendCaption(message, ent:GetPos())
		VOXhasPlayed = true
	end
end

function MAP:CreateExtraEnemies()
	GAMEMODE:CreateNPCSpawner("monster_headcrab", 3, Vector(-181, -4301, -2739), Angle(0, 180, 0), 500, false)
	GAMEMODE:CreateNPCSpawner("monster_barnacle", 4, Vector(-457, -4657, -2451), Angle(0, 0, 0), 500, false)
	GAMEMODE:CreateNPCSpawner("monster_bullchicken", 5, Vector(-1441, -3876, -2902), Angle(0, 32, 0), 800, false)
end

function MAP:OnMapRestart()
	oxy = nil
	fuel = nil
	
	for k,v in pairs(ents.FindByClass("env_smokestack")) do
		if v:GetName() == "engine_smoke" then
			v:Fire("TurnOff")
		end 
	end
end

function MAP:OnEntCreated(ent)
	if ent:GetClass() == "func_tracktrain" then
		timer.Simple(0, function()
			if IsValid(ent) and ent:GetName() == "twain" then
				trainEnt = ent
			end
		end)
	end
end

local function TakeTrainDamage(ent, trainEnt, dmg)
	if IsValid(ent) and ent:IsNPC() and ent:Health() > 0 then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(dmg)
		dmginfo:SetAttacker(trainEnt)
		dmginfo:SetInflictor(trainEnt)
		dmginfo:SetDamageType(DMG_CRUSH)
		ent:TakeDamageInfo(dmginfo)
	end
end
hook.Add("Think", "05TrainThink", function()
	if IsValid(trainEnt) then
		local vel = trainEnt:GetVelocity():Length2D()
		if vel >= 280 then
			local dmg = trainEnt:GetInternalVariable("dmg")
			local pos = trainEnt:GetPos()
			
			local trpos = pos + trainEnt:GetForward() * 50 + trainEnt:GetRight() * 80
			local tr = util.TraceHull({
				start = trpos,
				endpos = trpos,
				filter = trainEnt,
				mins = Vector(-16, -16, -32),
				maxs = Vector(16, 16, 16)
			})
			
			local trFpos = pos + trainEnt:GetForward() * 50
			local trF = util.TraceHull({
				start = trFpos,
				endpos = trFpos,
				filter = trainEnt,
				mins = Vector(-64, -64, -32),
				maxs = Vector(64, 64, 8)
			})
			
			TakeTrainDamage(tr.Entity, trainEnt, dmg)
			TakeTrainDamage(trF.Entity, trainEnt, dmg)
		end
	end
end)