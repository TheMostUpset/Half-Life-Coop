AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("HL1SpeakerSentence")

local cvar_unused = CreateConVar("hl1_coop_sv_unusedbmas", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allow playing unused Black Mesa Announcement System lines")

local ANNOUNCE_MINUTES_MIN = 0.25	 
local ANNOUNCE_MINUTES_MAX = 2.25

ENT.Presets = {
	[1] = {"C1A0_", 22},
	[2] = {"C1A1_", 11},
	[3] = {"C1A2_", 11},
	[4] = {"C1A3_", 10},
	[5] = {"C1A4_", 8},
	[6] = {"C2A1_", 8},
	[7] = {"C2A2_", 7},
	[8] = {"C2A3_"},
	[9] = {"C2A4_", 12},
	[10] = {"C2A5_"},
	[11] = {"C3A1_", 9},
	[12] = {"C3A2_", 7}
}

ENT.AmbientPresets = {
	["WILD"] = 12,
	["ROCKET"] = 6,
	["FAR_WAR"] = 16,
	["NEAR_WAR"] = 12,
}

function ENT:KeyValue(k, v)
	--print(k, v)
	if k == "preset" then
		self.m_preset = tonumber(v)
	end
	if k == "message" then
		self.message = v
	end
	if k == "delaymin" then
		self.delaymin = tonumber(v)
	end
	if k == "delaymax" then
		self.delaymax = tonumber(v)
	end
	-- if k == "radius" then
		-- self.radius = tonumber(v)
	-- end
end

function ENT:Initialize()
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	if !self:HasSpawnFlags(1) then
		// set first announcement time for random n second
		self:NextThink(CurTime() + math.Rand(5.0, 15.0))
	end
	
	if self.m_preset > 0 and self.Presets[self.m_preset] then
		self.SentenceName = self.Presets[self.m_preset][1]
		self.SentenceCount = self.Presets[self.m_preset][2]
	elseif self.message then
		-- self.SentenceName = string.Split(self.message, " ")
		local ambientCount = self.AmbientPresets[self.message]
		if ambientCount then
			self.SentenceName = self.message
			self.SentenceCount = ambientCount
		end
	end
end

function ENT:Think()
	if !self.PlayUnusedLines and !cvar_unused:GetBool() and (self.m_preset == 3 or self.m_preset > 4 and self.m_preset < 12) then
		self:NextThink(CurTime() + 60)
		return true
	end

	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		self:NextThink(CurTime() + 30)
		return true
	end
	
	-- local flattenuation = 0.3
	
	if string.StartWith(self.SentenceName, "!") then
		-- play regular sentence
		local flvolume = self:Health() * 0.1
		EmitSentence(self.SentenceName, self:GetPos(), self:EntIndex(), CHAN_VOICE, flvolume, 120, 0, 100)
		self:Remove()
	else
		if self.SentenceCount then
			// make random announcement from sentence group
			local rand = math.random(0, self.SentenceCount)
			if self.m_preset and self.m_preset > 0 then -- if BMAS
				self:PlaySentence(self.SentenceName..rand)
				self:NextThink(CurTime() + math.Rand(ANNOUNCE_MINUTES_MIN * 60.0, ANNOUNCE_MINUTES_MAX * 60.0))
			elseif self.message then -- if ambient sounds
				local flvolume = self:Health() * 0.1
				EmitSentence(self.SentenceName..rand, self:GetPos(), self:EntIndex(), CHAN_VOICE, flvolume, 120, 0, 100)
				if self.delaymin and self.delaymax then
					-- original code didn't use these values, but let's try
					self:NextThink(CurTime() + math.Rand(self.delaymin, self.delaymax))
				else
					self:NextThink(CurTime() + math.Rand(ANNOUNCE_MINUTES_MIN * 60.0, ANNOUNCE_MINUTES_MAX * 60.0))
				end
			end
		end
	end
	return true
end

function ENT:PlaySentence(sentence, flvolume, pitch, flags)
	flvolume = flvolume or self:Health() * 0.1
	pitch = pitch or 100
	flags = flags or 0
	if game.SinglePlayer() then
		EmitSentence(sentence, self:GetPos(), self:EntIndex(), CHAN_VOICE, flvolume, 0, flags, pitch)
		GAMEMODE:SendCaption("!BMAS_"..sentence, self:GetPos())
	else
		net.Start("HL1SpeakerSentence")
		net.WriteString(sentence)
		net.WriteFloat(flvolume)
		net.Broadcast()
	end
end

function ENT:TurnOn(nextSentenceTime)
	nextSentenceTime = nextSentenceTime or 1
	self:NextThink(CurTime() + nextSentenceTime)
end

function ENT:TurnOff()
	self:NextThink(0)
end

function ENT:AcceptInput(inputName, activator, called, data)
	if inputName == "TurnOn" then
		self:TurnOn()
	end
	if inputName == "TurnOff" then
		self:TurnOff()
	end
end