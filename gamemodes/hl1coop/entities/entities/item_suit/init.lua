AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = Model("models/w_suit.mdl")
ENT.SoundBell = Sound("fvox/bell.wav")

ENT.RespawnTime = 2
ENT.BoundSize = 8

function ENT:KeyValue(k, v)
	if k == "OnPlayerTouch" then
		self:StoreOutput(k, v)
	end
end

function ENT:Initialize()
	if !self:IsInWorld() then
		self:Remove()
	end
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetSolid(SOLID_NONE)

	self:SetTrigger(true)
	self:UseTriggerBounds(true, self.BoundSize)
	self.Pickable = true
end

function ENT:Touch(ent)
	if IsValid(ent) then
		if ent:IsPlayer() and ent:Alive() and self.Pickable then
			self:Pickup(ent)
		end
	end
end

function ENT:Pickup(ply)
	if !ply:IsSuitEquipped() then
		ply:EquipSuit()
		ply:EmitSound(self.SoundBell, 75, 100 + math.random(0, 5), .7, CHAN_ITEM)
		timer.Simple(1, function()
			if IsValid(ply) and ply:Alive() then
				ply:EmitSound("fvox/hev_logon.wav", 65, 100 + math.random(0, 5), 0.3, CHAN_VOICE)
			end
		end)
		
		if self.Respawnable then
			self:RespawnItem(self.RespawnTime)
		else
			self:Remove()
		end
		self.Pickable = false
		
		hook.Run("OnSuitEquip", ply, self)
		self:TriggerOutput("OnPlayerTouch", ply)
	end
end