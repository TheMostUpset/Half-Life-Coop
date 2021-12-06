util.AddNetworkString("SetSpectateMode")
util.AddNetworkString("SetSpectatePlayer")

net.Receive("SetSpectateMode", function(len, ply)
	if IsValid(ply) and ply:IsSpectator() then
		local obsTarget = ply:GetObserverTarget()
		if IsValid(obsTarget) and obsTarget:IsPlayer() and obsTarget:IsSpectator() then
			ply:UnSpectate()
		end
		ply:Spectate(net.ReadUInt(4))
	end
end)

net.Receive("SetSpectatePlayer", function(len, ply)
	if IsValid(ply) and ply:IsSpectator() then
		local ent = net.ReadEntity()
		if IsValid(ent) and ent:IsPlayer() and !ent:IsSpectator() then
			ply:SpectateEntity(ent)
			ply:SetupHands(ent)
			local obsMode = ply:GetObserverMode()
			if obsMode != OBS_MODE_CHASE and obsMode != OBS_MODE_IN_EYE then
				ply:Spectate(OBS_MODE_CHASE)
			end
		else
			ply:UnSpectate()
		end
		--ply:SetLocalVelocity(Vector())
	end
end)

concommand.Add("hl1_coop_spectate", function(ply)
	if !ply or !IsValid(ply) then return end
	ply:SpecToggle()
end)