MAP.ChapterTitle = "#HL1_Chapter3_Title"
MAP.ShowChapterTitle = true

MAP.DisableFullRespawn = true

if CLIENT then return end

MAP.EnvFadeWhitelist = {
	["fade_in"] = true
}

MAP.StartingWeapons = false

MAP.npcLagFixBlacklist = {
	["headcrab_crab1"] = true,
	["headcrab_crab2"] = true
}

MAP.FallToDeath = {
	{Vector(4960, 2752, -236), Vector(3054, 3600, -279)}, -- stay back gordon
	{Vector(5825, 2680, -2084), Vector(6112, 2967, -1733)}, -- after akira elevator
	{Vector(4560, 3943, -2288), Vector(5248, 3319, -2180)}, -- bullsquid
	{Vector(4320, 4343, -2400), Vector(4032, 4631, -2720)},
	{Vector(4672, 5231, -3824), Vector(5472, 6191, -3790)} -- crates
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-1655, 542, -1582), Angle(0, 90, 0))
end

local tele1pos = Vector(2240, -480, -310)
local tele2pos = Vector(579, 254, -305)
local tele3pos = Vector(1175, 2110, 780)
local tele4pos = Vector(5963, 600, 830)
local tele5pos = Vector(5344, 2583, -1655)

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "airamm" then
		local weptable = {"weapon_crowbar", "weapon_glock"}
		GAMEMODE:Checkpoint(3, Vector(2915, 1820, 810), Angle(0, -90, 0), {tele1pos, tele2pos, tele3pos}, activator, weptable)
	end
	if ent:GetName() == "2teleport_mm1" then
		local weptable = {"weapon_crowbar", "weapon_glock"}
		GAMEMODE:Checkpoint(5, Vector(5580, 2815, -1700), Angle(0, 180, 0), {tele1pos, tele2pos, tele3pos, tele4pos}, activator, weptable)
	end
end

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(659, 80, -143), Vector(523, 96, -28), Vector(590, 17, -142), Angle(0, -90, 0), {tele1pos, tele2pos})
	GAMEMODE:CreateCheckpointTrigger(2, Vector(902, 1944, 721), Vector(569, 2280, 626), Vector(1035, 2114, 730), Angle(), {tele1pos, tele2pos}, "weapon_crowbar")
	GAMEMODE:CreateCheckpointTrigger(6, Vector(4544, 5534, -2010), Vector(4480, 5520, -1920), Vector(4612, 5478, -2016), Angle(0, 150, 0), {tele1pos, tele2pos, tele3pos, tele4pos, tele5pos}, {"weapon_crowbar", "weapon_glock"})
end

local function NPCMoveTo(npc, vec)
	npc:SetSaveValue("m_vecLastPosition", vec)
	npc:SetSchedule(SCHED_FORCED_GO)
end

local waitTrig
local akiraClip
local akiraWaitTrig

function MAP:OperateMapEvents(ent, input, caller, activator)
	--[[if IsValid(caller) and ent:GetName() == "ele_2mm" and input == "Trigger" and IsValid(activator) and activator:IsPlayer() then
		if IsValid(plyclip) then plyclip:Remove() end
		local elev = ents.FindByName("ele_2")[1]
		local plyclip = GAMEMODE:CreatePlayerClip(Vector(719, 351, -360), Vector(675, 160, -232))
		caller:Fire("Lock")
		timer.Simple(6, function()
			if IsValid(ent) and IsValid(elev) then
				ent:Fire("Trigger")
				timer.Simple(2.5, function()
					if IsValid(caller) then caller:Fire("Unlock") end
				end)
				if elev:GetPos() == Vector(587,256,-2) then
					for k, v in pairs(ents.FindInBox(Vector(476, 352, -360), Vector(699, 160, -339))) do
						v:SetPos(Vector(777, 289, -355))
					end
				end
			end
		end)
	end]]
	if !GAMEMODE:GetSpeedrunMode() then
		if IsValid(akiraClip) and ent:GetClass() == "func_rot_button" and ent:GetName() == "lift_lever" and input == "Use" then
			local buttonEnt = ent
			if !IsValid(akiraWaitTrig) then
				local func = function()
					if IsValid(buttonEnt) then
						buttonEnt:Fire("Unlock")
						buttonEnt:Fire("Use")
						timer.Simple(1, function()
							if IsValid(buttonEnt) then
								buttonEnt:Fire("Lock")
							end
						end)
					end
					if IsValid(akiraClip) then
						akiraClip:Remove()
					end
				end
				akiraWaitTrig = GAMEMODE:CreateWaitTrigger(Vector(5698, 1142, 768), Vector(6207, 787, 900), 60, false, func, WAIT_FREE)
			end
		end
		if ent:GetClass() == "func_tracktrain" and ent:GetName() == "pl" and input == "StartForward" then
			local music_trigger = function()
				local pos = Vector(5952, 1023, 640)
				local bounds = Vector(153, 65, 89)
				for k, v in pairs(ents.FindInBox(pos - bounds, pos + bounds)) do
					if v:GetClass() == "trigger_once" then
						v:Fire("Kill")
						ents.FindByName("cd_audio_track_6")[1]:Fire("PlaySound")
					end
				end
			end
			GAMEMODE:Checkpoint(4, ent, Angle(0, 90, 0), {tele1pos, tele2pos, tele3pos, tele4pos}, nil, {"weapon_crowbar", "weapon_glock"}, nil, music_trigger)
		end
	end
	if ent:GetClass() == "func_door" and ent:GetName() == "retinal_scanner_door" and input == "Open" then
		local sci = ents.FindByName("console_guy")[1]
		if IsValid(sci) and sci:IsNPC() then
			sci:SetCondition(17)
			timer.Simple(.09, function()
				if IsValid(sci) then
					sci:SentenceStop()
				end
			end)
			timer.Simple(.1, function()
				if IsValid(sci) then
					NPCMoveTo(sci, Vector(608, -305, -144))
				end
			end)
		end
	end
	if ent:GetClass() == "func_door_rotating" and ent:GetName() == "retinal_scanner_door_up" and input == "Open" then
		local sci = ents.FindByName("sitting_scientist12")[1]
		if IsValid(sci) and sci:IsNPC() then
			sci:SetCondition(17)
			timer.Simple(.1, function()
				if IsValid(sci) then
					NPCMoveTo(sci, Vector(3082, 992, 952))
					sci:SetCondition(17)
				end
			end)
		end
	end
	if IsValid(waitTrig) and ent:GetClass() == "func_button" and ent:GetName() == "elebutton1" and IsValid(caller) and caller:GetClass() == "func_door" and input == "Unlock" then
		return true
	end
	if ent:GetClass() == "func_door" and ent:GetName() == "startele1" and input == "Close" then
		local box = ents.FindInBox(Vector(3960, 5499, -1712), Vector(3836, 5495, -1616))
		for k, v in pairs(box) do
			if v:IsPlayer() then
				v:SetVelocity(Vector(0, -500, 0))
			end
		end
	end
end

function MAP:FixMapEntities()
	for k, v in pairs(ents.FindByName("crate*")) do
		if v:GetClass() == "func_physbox" then
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				if GAMEMODE:GetSkillLevel() <= 1 then
					phys:EnableMotion(false)
				end
			end
		end
	end
	
	local pushClip = ents.Create("hl1_pushableclip")
	if IsValid(pushClip) then
		pushClip:Spawn()
		pushClip:SetCollisionBoundsWS(Vector(4828, 768, 768), Vector(4996, 812, 925))
	end
	
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		function fTrig:StartTouch(ent)
			if ent:GetClass() == "monster_scientist" and ent:GetName() == "OHDEAR" then
				ent:SetNoDraw(true)
				ent:SetNotSolid(true)
				timer.Simple(.7, function()
					if IsValid(ent) then
						GAMEMODE:GibEntity(ent, 36, Vector(0, 0, 1300))
						ent:Remove()
					end
				end)
			end
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(829, 2196, -816), Vector(626, 2012, -680))
	end
	
	for k, v in pairs(ents.FindByName("crawl_barney")) do
		v:SetSaveValue("m_takedamage", 0)
	end
end

function MAP:ModifyMapEntities() -- this hook runs in coop only
	GAMEMODE:CreateCoopSpawnpoints(Vector(1708, 262, -380), Angle())
	
	GAMEMODE:CreatePickupEntity("item_battery", Vector(5581, 2678, -1480), Angle(0, 145, 0))
	GAMEMODE:CreatePickupEntity("item_battery", Vector(5597, 2691, -1480), Angle(0, 100, 0))
	for i = 0, 6 do
		GAMEMODE:CreatePickupEntity("item_battery", Vector(2704 - i * 32, 4151, -2000), Angle())
	end
	
	local func = function()
		local elebutton1 = ents.FindByName("elebutton1")[1]
		if IsValid(elebutton1) then
			elebutton1:Fire("Unlock")
		end
	end
	waitTrig = GAMEMODE:CreateWaitTrigger(Vector(4023, 5232, -1712), Vector(3768, 5465, -1569), 60, false, func, WAIT_FREE, true)
	
	if !GAMEMODE:GetSpeedrunMode() then
		for k, v in pairs(ents.FindByName("lift_lever")) do
			v:Fire("Lock")
		end
		akiraClip = GAMEMODE:CreatePlayerClip(Vector(6112, 1079, 737), Vector(5792, 985, 768))
	end
end

function MAP:CreateExtraEnemies()
	GAMEMODE:CreateNPCSpawner("monster_zombie", 3, Vector(-380, 2670, 750), Angle(0, -90, 0), 550, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 2, Vector(228, 4000, 750), Angle(), 400, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 2, Vector(-170, 4030, 740), Angle(), 150, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 2, Vector(2512, 3320, 780), Angle(0, 135, 0), 520, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 3, Vector(2645, 3020, 780), Angle(0, 120, 0), 800, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 2, Vector(5240, 730, 580), Angle(0, 180, 0), 720, false)
	GAMEMODE:CreateNPCSpawner("monster_zombie", 3, Vector(4900, 911, 580), Angle(0, -90, 0), 280, false)
	--GAMEMODE:CreateNPCSpawner("monster_headcrab", 1, Vector(5400, 600, 770), Angle(0, 180, 0), 550, false)
	--GAMEMODE:CreateNPCSpawner("monster_headcrab", 1, Vector(5350, 535, 770), Angle(0, 180, 0), 530, false)
	--GAMEMODE:CreateNPCSpawner("monster_headcrab", 1, Vector(5386, 498, 770), Angle(0, 180, 0), 670, false)
	--GAMEMODE:CreateNPCSpawner("monster_headcrab", 1, Vector(5528, 490, 770), Angle(0, 180, 0), 680, false)
	--GAMEMODE:CreateNPCSpawner("monster_houndeye", 1, Vector(5740, 1100, 832), Angle(0, -90, 0), 350, true)
end

function MAP:CreateSurvivalEntities()
	GAMEMODE:CreateWeaponEntity("weapon_healthkit", Vector(2115, -409, -321), Angle(0, -65, 0))
	--GAMEMODE:CreateWeaponEntity("weapon_healthkit", Vector(550, -314, -108), Angle(0, -25, 0))
end

function MAP:OnCheckpoint(cpNum)
	if cpNum > 1 then
		self.StartingWeaponsSurvival = "weapon_crowbar"
	end
end

function MAP:OnMapRestart()
	self.StartingWeaponsSurvival = nil
end