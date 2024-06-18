local meta = FindMetaTable("Entity")

function meta:IsTrigger()
	local class = self:GetClass()
	return class == "trigger_once" or class == "trigger_multiple"
end

local movingEnts = {
	["func_door"] = true,
	["func_platrot"] = true,
	["func_train"] = true,
	["func_tracktrain"] = true,
	["func_trackchange"] = true,
	["func_rotating"] = true,
}
function meta:IsMovingEntity()
	return movingEnts[self:GetClass()]
end

local items = {
	"weapon_",
	"item_",
	"ammo_"
}
function meta:IsPickupItem()
	for k, v in pairs(items) do
		if string.StartWith(self:GetClass(), v) then
			return true
		end
	end
	return false
end

function meta:IsSwitchableHandsWeapon()
	if self.CModel and self.VModel or self.CModelSatchel and self.CModelRadio and self.VModelSatchel and self.VModelRadio then
		return true
	end
	return false
end

function meta:StopMoveSound() -- fix for func_tracktrain
	local sndpath = self:GetInternalVariable("MoveSound")
	self:StopSound(sndpath)
end

if SERVER then

	function meta:BroadcastEntityPlayerColor(vec)
		net.Start("SetEntityPlayerColor")
		net.WriteEntity(self)
		net.WriteVector(vec)
		net.Broadcast()
	end
	
	function meta:GetHammerID()
		return self:GetInternalVariable("hammerid")
	end
	
	function meta:MarkRemovedForTransition()
		if !GAMEMODE.RemovedMapEntities then GAMEMODE.RemovedMapEntities = {} end
		if GAMEMODE.RemovedMapEntities then
			local exists = false
			for _, id in ipairs(GAMEMODE.RemovedMapEntities) do
				if id == self:MapCreationID() then
					exists = true
					break
				end
			end
			if !exists then
				table.insert(GAMEMODE.RemovedMapEntities, self:MapCreationID())
			end
		end
	end

end