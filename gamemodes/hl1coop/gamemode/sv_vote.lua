local cvar_voteEnable = CreateConVar("hl1_coop_sv_vote_enable", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow voting on server")
local cvar_voteSpec = CreateConVar("hl1_coop_sv_vote_allowspectators", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow spectators to vote")
local cvar_voteAllowBan = CreateConVar("hl1_coop_sv_vote_allowban", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow voting to ban player")
local cvar_voteAllowKick = CreateConVar("hl1_coop_sv_vote_allowkick", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow voting to kick player")
local cvar_voteTime = CreateConVar("hl1_coop_sv_vote_time", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Vote time in seconds")
local cvar_voteCoolDown = CreateConVar("hl1_coop_sv_vote_cooldown", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time in seconds before allow player to vote again")

local sndVoteStart = "ambient/alarms/warningbell1.wav"
local sndVotePassed = "friends/friend_join.wav"
local sndVoteFailed = "buttons/button10.wav"
local sndVote = "buttons/blip1.wav"

function GM:VoteTypesTable()
	local voteTypes = {
		["map"] = "<mapname>",
		["kick"] = "<nickname>",
		["kickid"] = "<userid>",
		["ban"] = "<userid> <minutes 1-30>",
		["skill"] = "<number 1-4>",
		["restart"] = "",
		["friendlyfire"] = "",
		["speedrunmode"] = "",
		["survivalmode"] = "",
		["crackmode"] = "",
		["1hpmode"] = "",
		["skiptripmines"] = ""
	}
	return voteTypes
end

function GM:OnAdminKickAttempt(kicker, plyAdmin)
	--kicker:ChatMessage("Fuck you")
end
function GM:OnAdminBanAttempt(baner, plyAdmin)
	--baner:ChatMessage("Fuck you again")
end

local voteExecuteDelay = 3
local voteExecuteTime = 0

local function VoteEnd(result, nomsg)
	if result == 1 then
		local voteType = GetGlobalString("VoteType")
		if voteType == "map" then
			timer.Simple(voteExecuteDelay, function()
				local maptochange = GetGlobalString("VoteName")
				RunConsoleCommand("changelevel", maptochange)
				GAMEMODE:TransitPlayers(maptochange)
			end)
		elseif voteType == "kick" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("kick", GetGlobalString("VoteName"))
			end)
		elseif voteType == "kickid" then
			timer.Simple(voteExecuteDelay, function()
				game.KickID(GetGlobalString("VoteName"), "Kicked by vote")
			end)
		elseif voteType == "ban" then
			timer.Simple(voteExecuteDelay, function()
				local plyid = tonumber(GetGlobalString("VoteName"))
				local ply = Player(plyid)
				local minutes = GetGlobalInt("VoteMinutes")
				if IsValid(ply) and !ply:IsAdmin() then
					ply:Ban(minutes, true)
					print(ply:Nick().." was banned for "..minutes.." minutes")
				end
			end)
		elseif voteType == "skill" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_sv_skill", GetGlobalString("VoteName"))
			end)
		elseif voteType == "speedrunmode" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_mode_speedrun", GetGlobalString("VoteName"))
			end)
		elseif voteType == "survivalmode" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_mode_survival", GetGlobalString("VoteName"))
			end)
		elseif voteType == "crackmode" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_mode_crack", GetGlobalString("VoteName"))
			end)
		elseif voteType == "1hpmode" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_mode_1hp", GetGlobalString("VoteName"))
			end)
		elseif voteType == "restart" then
			timer.Simple(voteExecuteDelay, function()
				GAMEMODE:GameRestart()
			end)
		elseif voteType == "friendlyfire" then
			timer.Simple(voteExecuteDelay, function()
				RunConsoleCommand("hl1_coop_sv_friendlyfire", GetGlobalString("VoteName"))
			end)
		elseif voteType == "skiptripmines" then
			timer.Simple(voteExecuteDelay, function()
				SkipTripmines()
			end)
		end
		if !nomsg then ChatMessage("#vote_votepassed", 3) end
		net.Start("PlayClientSound")
		net.WriteString(sndVotePassed)
		net.Broadcast()
		voteExecuteTime = CurTime() + voteExecuteDelay
	else
		if !nomsg then ChatMessage("#vote_votefailed", 3) end
		net.Start("PlayClientSound")
		net.WriteString(sndVoteFailed)
		net.Broadcast()
	end
	GAMEMODE:SetGlobalBool("Vote", false)
	for k, v in pairs(player.GetAll()) do
		v.voteOption = nil
	end
end

function GM:VoteCancel(ply)
	if IsValid(ply) and !ply:IsAdmin() then return end
	if !GetGlobalBool("Vote") then
		if IsValid(ply) then
			ply:ChatMessage("#vote_noactivevote", 3)
		else
			print("No vote in progress")
		end
		return
	end
	VoteEnd(0, true)
	if IsValid(ply) then
		ChatMessage({"#vote_plyvetoed", ply:Nick()}, 3)
	else
		ChatMessage("#vote_canceled", 3)
	end
end

local nextCheck = RealTime()
function GM:VoteThink()	
	if GetGlobalBool("Vote") then
		if nextCheck and nextCheck <= RealTime() then
			local plyCount = (cvar_voteSpec:GetBool() or GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD) and player.GetCount() or team.NumPlayers(TEAM_COOP)
			if plyCount == 0 then
				hook.Run("VoteCancel")
				return
			end
			local yes, no = GetGlobalInt("VoteNumYes"), GetGlobalInt("VoteNumNo")
			local total = yes + no
			if (GetGlobalFloat("VoteTime") - CurTime()) <= 0 then
				if yes > no and total > 1 then
					VoteEnd(1)
				else				
					VoteEnd()
				end
			elseif yes > math.floor(plyCount / 2) then			
				VoteEnd(1)
			elseif no >= yes and no >= math.ceil(plyCount / 2) then
				VoteEnd()
			end
			
			nextCheck = RealTime() + .5
		end
	end
end

local function RemovePlayerVote(ply)
	local vote = ply.voteOption
	if vote then
		if vote == 1 then
			SetGlobalInt("VoteNumYes", GetGlobalInt("VoteNumYes") - 1)
		else
			SetGlobalInt("VoteNumNo", GetGlobalInt("VoteNumNo") - 1)
		end
		ply.voteOption = nil
	end
end

function GM:VotePlayerJoinedSpectators(ply)
	if GetGlobalBool("Vote") and !cvar_voteSpec:GetBool() then
		RemovePlayerVote(ply)
	end
end

function GM:VotePlayerDisconnected(ply)
	if GetGlobalBool("Vote") then
		RemovePlayerVote(ply)
		
		local voteType = GetGlobalString("VoteType")
		local voteName = GetGlobalString("VoteName")
		if voteType == "kick" then
			if ply:Nick() == voteName then
				local ip = ply:IPAddress()
				RunConsoleCommand("addip", 1, ip)
				VoteEnd(0, true)
			end
		elseif voteType == "kickid" then
			if ply == Player(voteName) then
				local ip = ply:IPAddress()
				RunConsoleCommand("addip", 1, ip)
				VoteEnd(0, true)
			end
		elseif voteType == "ban" then
			if ply == Player(voteName) then
				local ip = ply:IPAddress()
				RunConsoleCommand("addip", GetGlobalInt("VoteMinutes"), ip)
				VoteEnd(0, true)
			end
		end
	end
end

local function PrintHelpText(ply)
	ply:PrintMessage(HUD_PRINTTALK, "Usage:")
	local voteTypes = hook.Run("VoteTypesTable")
	for k, v in SortedPairs(voteTypes) do
		ply:PrintMessage(HUD_PRINTTALK, k.." "..v)
	end
end

function GM:CanPlayerVote(ply)
	return true
end

concommand.Add("hl1_coop_callvote", function(ply, cmd, args)
	if GAMEMODE:GetCoopState() == COOP_STATE_TRANSITION then return end
	if !cvar_voteEnable:GetBool() then
		ply:ChatMessage("#vote_votedisabled", 3)
		return
	end
	if !hook.Run("CanPlayerVote", ply) then
		ply:ChatMessage("#vote_cannotnow", 3)
		return
	end
	if !cvar_voteSpec:GetBool() then -- if spectators cannot vote
		if ply:Team() == TEAM_SPECTATOR then
			ply:ChatMessage("#vote_speccantcall", 3)
			return
		end
		if GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD and team.NumPlayers(TEAM_COOP) == 0 then
			ply:ChatMessage("#vote_cannotnow", 3)
			return
		end
	end
	if !ply:IsAdmin() and ply.NextVote and ply.NextVote > CurTime() then
		ply:ChatMessage("#vote_voteagain".." "..math.ceil(ply.NextVote - CurTime()).."s", 3)
		return
	end

	local voteType, voteName = args[1], args[2]
	local voteTypes = hook.Run("VoteTypesTable")
	if voteTypes[voteType] then
		if GetGlobalBool("Vote") or voteExecuteTime > CurTime() then
			ply:ChatMessage("#vote_alreadyactive", 3)
			return
		end
		
		if voteType == "map" and voteName then
			local mapcheck = file.Exists("maps/"..voteName..".bsp", "GAME")
			if !mapcheck then
				ply:PrintMessage(HUD_PRINTTALK, "The map is not installed on the server or is invalid")
				return
			end
			SetGlobalString("VoteName", voteName)
		elseif voteType == "kick" and voteName then
			if !cvar_voteAllowKick:GetBool() then
				ply:PrintMessage(HUD_PRINTTALK, "Vote to kick is disallowed on this server")
				return
			end
			local notvalid
			for k, v in ipairs(player.GetAll()) do
				if string.lower(v:Nick()) != string.lower(voteName) then
					notvalid = true
				else
					if v:IsAdmin() then
						hook.Run("OnAdminKickAttempt", ply, v)
						return
					end
					notvalid = nil
					break
				end
			end
			if notvalid then
				ply:PrintMessage(HUD_PRINTTALK, "Not a valid player!")
				return
			else
				SetGlobalString("VoteName", voteName)
			end
		elseif voteType == "kickid" and voteName then
			if !cvar_voteAllowKick:GetBool() then
				ply:PrintMessage(HUD_PRINTTALK, "Vote to kick is disallowed on this server")
				return
			end
			local plyid = tonumber(voteName)
			local playercheck = Player(plyid)
			if IsValid(playercheck) then
				if playercheck:IsAdmin() then
					hook.Run("OnAdminKickAttempt", ply, playercheck)
					return
				end
				SetGlobalString("VoteName", plyid)
			else
				ply:PrintMessage(HUD_PRINTTALK, "Not a valid player!")
				return
			end
		elseif voteType == "ban" and voteName then
			if !cvar_voteAllowBan:GetBool() then
				ply:PrintMessage(HUD_PRINTTALK, "Vote to ban is disallowed on this server")
				return
			end
			local plyid = tonumber(voteName)
			local playercheck = Player(plyid)
			if IsValid(playercheck) then
				if playercheck == ply then
					return
				end
				if playercheck:IsAdmin() then
					hook.Run("OnAdminBanAttempt", ply, playercheck)
					return
				end
				SetGlobalString("VoteName", plyid)
				local minutes = 10
				if args[3] then
					tonumber(args[3])
					minutes = math.Clamp(args[3], 1, 30)
				end
				SetGlobalInt("VoteMinutes", minutes)
			else
				ply:PrintMessage(HUD_PRINTTALK, "Not a valid player!")
				return
			end
		elseif voteType == "skill" and voteName then
			local skill = tonumber(voteName)
			if SKILL_LEVEL[skill] then
				if GAMEMODE:GetSkillLevel() == skill then
					ply:ChatMessage("#vote_skillalready".." "..skill, 3)
					return
				end
				if !hook.Run("CanChangeSkillLevel") then
					ply:ChatMessage("#vote_skillno", 3)
					return
				end
				SetGlobalString("VoteName", skill)
			else
				ply:PrintMessage(HUD_PRINTTALK, "Not a valid skill level!")
				return
			end
		elseif voteType == "friendlyfire" then
			if cvars.Bool("hl1_coop_sv_friendlyfire") then
				SetGlobalString("VoteName", "0")
			else
				SetGlobalString("VoteName", "1")
			end
		elseif voteType == "speedrunmode" then
			if cvars.Bool("hl1_coop_mode_speedrun") then
				SetGlobalString("VoteName", "0")
			else
				SetGlobalString("VoteName", "1")
			end
		elseif voteType == "survivalmode" then
			if cvars.Bool("hl1_coop_mode_survival") then
				SetGlobalString("VoteName", "0")
			else
				SetGlobalString("VoteName", "1")
			end
		elseif voteType == "crackmode" then
			if cvars.Bool("hl1_coop_mode_crack") then
				SetGlobalString("VoteName", "0")
			else
				SetGlobalString("VoteName", "1")
			end
		elseif voteType == "1hpmode" then
			if cvars.Bool("hl1_coop_mode_1hp") then
				SetGlobalString("VoteName", "0")
			else
				SetGlobalString("VoteName", "1")
			end
		elseif voteType == "restart" then
			if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
				ply:ChatMessage("#vote_cannotnow", 3)
				return
			end
			SetGlobalString("VoteName", "map")
		elseif voteType == "skiptripmines" then
			if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD or game.GetMap() != "hls11cmrl" or TripminesSkipped() then
				return
			end
			SetGlobalString("VoteName", "")
		else
			PrintHelpText(ply)
			return
		end
		GAMEMODE:SetGlobalBool("Vote", true)
		ChatMessage(ply:Nick().." ".."#vote_plycalled", 3)
		SetGlobalString("VoteType", voteType)
		SetGlobalInt("VoteNumYes", 1)
		SetGlobalInt("VoteNumNo", 0)
		GAMEMODE:SetGlobalFloat("VoteTime", CurTime() + cvar_voteTime:GetFloat())
		print(ply:Nick().." called vote: "..GetGlobalString("VoteType").." "..GetGlobalString("VoteName"))
		for k, v in ipairs(player.GetAll()) do
			if v != ply then
				v.voteOption = nil
			end
		end
		ply.voteOption = 1
		ply.NextVote = CurTime() + cvar_voteCoolDown:GetFloat()
		
		if player.GetCount() > 1 then
			GAMEMODE:PlayGlobalSound(sndVoteStart)
		end
	else
		PrintHelpText(ply)
	end
end)

local function CVote(v, ply)
	if !GetGlobalBool("Vote") then
		ply:ChatMessage("#vote_noactivevote", 3)
		return
	end
	if !cvar_voteSpec:GetBool() and ply:Team() == TEAM_SPECTATOR then
		ply:ChatMessage("#vote_speccantvote", 3)
		return
	end
	if ply.voteOption then
		ply:ChatMessage("#vote_alreadycast", 3)
		return
	end
	ply.voteOption = v
	ply:ChatMessage("#vote_votecast", 3)
	if v == 1 then
		SetGlobalInt("VoteNumYes", GetGlobalInt("VoteNumYes") + 1)
	else
		SetGlobalInt("VoteNumNo", GetGlobalInt("VoteNumNo") + 1)
	end
	
	net.Start("PlayClientSound")
	net.WriteString(sndVote)
	net.Broadcast()
end

concommand.Add("vote_yes", function(ply)
	CVote(1, ply)
end)

concommand.Add("vote_no", function(ply)
	CVote(0, ply)
end)
	
concommand.Add("vote_cancel", function(ply)
	GAMEMODE:VoteCancel(ply)
end)