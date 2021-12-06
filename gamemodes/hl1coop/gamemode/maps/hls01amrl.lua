MAP.ChapterTitle = "#HL1_Chapter2_Title"
MAP.ShowChapterTitle = true

MAP.DisableFullRespawn = true

if CLIENT then return end

MAP.NoSuitOnSpawn = true
MAP.StartingWeapons = false
MAP.DisallowSurvivalMode = true
MAP.npcLagFixDisabled = true

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(1900, 3325, 915), Angle(10, 45, 0))
	GAMEMODE:CreateViewPointEntity(Vector(1380, 3100, 926), Angle(5, -50, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-350, 4246, 840), Angle(15, 45, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-590, 4682, 830), Angle(10, -140, 0))
	
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		local seqnames = {
			["introwalkerguy1mm"] = true,
			["gizmoscistart"] = true,
			["relax_ssss"] = true,
			["enterbarney1"] = true,
			["GmanSeeYou"] = true,
			["start1"] = true,
			["machine1"] = true,
		}
		for k, v in pairs(ents.FindByClass("scripted_sequence")) do
			if seqnames[v:GetName()] then
				v:Fire("BeginSequence")
			end
		end
	end
end

local function CreateSuitEntity(pos, ang)
	local suit = ents.Create("item_suit")
	if IsValid(suit) then
		suit:SetPos(pos)
		suit:SetAngles(ang)
		-- suit.dontRemove = true
		suit.Respawnable = true
		suit:Spawn()
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateCoopSpawnpoints(Vector(2554, 3534, 780), Angle(0, 180, 0))
	
	local mapSuit = ents.FindByClass("item_suit")[1]
	if IsValid(mapSuit) and mapSuit:CreatedByMap() then
		mapSuit:Remove() -- removing it because i dunno how to remove outputs lol
	end		
	CreateSuitEntity(Vector(-1550, 4176, 746), Angle())
	if game.MaxPlayers() > 1 then
		CreateSuitEntity(Vector(-1550, 4304, 746), Angle())
	end
	if game.MaxPlayers() > 2 then
		CreateSuitEntity(Vector(-1550, 4048, 746), Angle())
	end
	GAMEMODE:CreateWaitTrigger(Vector(-295, 2530, 728), Vector(-391, 2396, 872), 40, true)
	GAMEMODE:CreateWaitTrigger(Vector(610, 1168, -144), Vector(418, 928, 0), 30)
	GAMEMODE:CreateWaitTrigger(Vector(1398, -360, -217), Vector(1271, -48, -360), 30)

	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		for k, v in pairs(ents.FindByClass("logic_auto")) do
			v:Remove()
		end
	end
	
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		fTrig.TouchFunction = function(ply)
			ply:ScreenFade(SCREENFADE.IN, color_black, 1, 14)
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(3400, 4631, -3563), Vector(3304, 4788, -3456))
	end
	
	local randomphrases = {"Greetings!", "Have you seen my coffee cup?", "Well, there goes\nour grant money", "Do you know who\nate all the donuts?", "Hello there", "Oh my"}
	local lol = ents.Create("changelevel_text")
	if IsValid(lol) then
		lol:SetPos(Vector(1290, 1090, -1905))
		lol:SetAngles(Angle(0, -45, 0))
		lol:SetText(table.Random(randomphrases))
		lol:Spawn()
	end
end

function MAP:OperateMapEvents(ent, input, caller)
	if IsValid(ent) and ent:GetClass() == "func_door" and ent:GetName() == "tldoor" and input == "Open" and GAMEMODE:IsCoop() then
		ent:SetNotSolid(true)
	end
	if ent:GetClass() == "multi_manager" and ent:GetName() == "probe_arm_mm" and input == "Trigger" then
		local pushClip = ents.Create("hl1_pushableclip")
		if IsValid(pushClip) then
			pushClip:Spawn()
			pushClip:SetCollisionBoundsWS(Vector(1365, 664, -384), Vector(1340, 576, -300))
		end
	end
end

local tele1pos = Vector(1900, 3330, 830) -- lobby
local tele2pos = Vector(-462, 4463, 780) -- near lockers
local tele3pos = Vector(1060, 420, -95) -- control room
local tele4pos = Vector(1401, -145, -310) -- test chamberrrr door

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(491, 2524, -144), Vector(501, 2400, -32), Vector(572, 2466, -140), Angle(), {tele1pos, tele2pos}, "item_suit")
end

function MAP:CreateMapEventCheckpoints(ent, activator, input)
	if ent:GetName() == "test_lab_entry_door" and input == "Close" then
		GAMEMODE:Checkpoint(2, Vector(1665, -100, -340), Angle(0, 90, 0), {tele1pos, tele2pos, tele3pos, tele4pos}, activator, "item_suit")
		for k, v in pairs(ents.FindByClass("speaker")) do
			v:TurnOff()
		end
	end
	if ent:GetName() == "portal_begin_mm" then
		GAMEMODE:RemoveCoopSpawnpoints()
		GAMEMODE:CreateCoopSpawnpoints(Vector(1665, 180, -350), Angle(0, 90, 0))
		self.NoSuitOnSpawn = false
	end
end

local hasMusicPlayed

function MAP:OnSuitPickup(ply, suitEnt)
	if suitEnt:CreatedByMap() then return end
	for k, v in pairs(ents.FindByName("hevmastered")) do
		v:Fire("Enable")
	end
	if !hasMusicPlayed then
		hasMusicPlayed = true
		hook.Run("PlayGlobalMusic", "HL1_Music.track_4")
	end
end

function MAP:OnMapRestart()
	self.NoSuitOnSpawn = true
end