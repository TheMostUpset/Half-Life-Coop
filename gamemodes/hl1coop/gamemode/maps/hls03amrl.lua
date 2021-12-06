MAP.ChapterTitle = "#HL1_Chapter4_Title"
MAP.ShowChapterTitle = true

MAP.DisableFullRespawn = true

if CLIENT then return end

MAP.BlockSpawnpointCreation = {
	["hls02amrl"] = true
}

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_handgrenade"}

MAP.npcLagFixBlacklist = {
	["ripzombie"] = true,
	["dueling_zombie"] = true,
	["jumperz"] = true
}

MAP.FallToDeath = {
	{Vector(-1064, -488, -512), Vector(-801, -776, -436)}
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(2510, -600, -500), Angle(5, -150, 0))
end

function MAP:FixMapEntities()
	for k, v in pairs(ents.FindByName("turretpwr1")) do
		v:SetPos(v:GetPos() - Vector(0,0,1))
	end
	for k, v in pairs(ents.FindInBox(Vector(2714, -557, -280), Vector(3140, -856, -284))) do
		if v:GetClass() == "monster_barnacle" then
			v:SetPos(v:GetPos() - Vector(0, 0, 1))
		end
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateCoopSpawnpoints(Vector(2319, -1009, -570), Angle(0, 90, 0))
	
	local hintDoors
	if !GAMEMODE:GetSpeedrunMode() then
		hintDoors = ents.Create("hl1_hint")
		if IsValid(hintDoors) then
			hintDoors:SetPos(Vector(908, -864, -476))
			hintDoors:SetAngles(Angle(0,90,90))
			hintDoors:SetText("#hint_doors")
			hintDoors:Spawn()
		end
	end
	
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		fTrig.TouchFunction = function()
			if !GAMEMODE:GetSpeedrunMode() then
				fTrig:Remove()
				if IsValid(hintDoors) then hintDoors:Remove() end
				for k, v in pairs(ents.FindByClass("func_door")) do
					if v:GetName() == "noopen2" or v:GetName() == "noopen3" then
						v:Remove()
					end
				end
				for k, v in pairs(ents.FindByClass("func_door_rotating")) do
					if v:GetName() == "halldoor1" or v:GetName() == "halldoor2" then
						v:Fire("Open")
					end
				end
			end
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(747, -771, -576), Vector(343, -955, -566))
	end
end

function MAP:OperateMapEvents(ent, input)
	local class, name = ent:GetClass(), ent:GetName()
	if class == "trigger_multiple" and name == "spawninlift" then
		ent:Remove()
	end
	if !game.SinglePlayer() and class == "func_button" and name == "elebutton1" and input == "Unlock" then
		return true
	end
end

function MAP:CreateMapEventCheckpoints(ent, activator)
	local tele1pos = Vector(2240, -785, -530)
	if ent:GetName() == "from2a" then
		GAMEMODE:Checkpoint(1, Vector(500, 870, 70), Angle(0, -90, 0), tele1pos, activator, "weapon_shotgun")
	end
end