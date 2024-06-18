AddCSLuaFile()

ENT.Type = "point"
ENT.Spawnable = false

if CLIENT then return end

function ENT:KeyValue(k, v)
	if k == "OnMapSpawn" or k == "OnMapTransition" or k == "OnNewGame" or k == "OnLoadGame" or k == "OnBackgroundMap" then
		self:StoreOutput(k, v)
	end
	-- print(k,v)
end

function ENT:Initialize()
	self:NextThink(CurTime() + 0.2)
end

function ENT:Think()
	if self.Disabled then		
		self:NextThink(CurTime() + 1)
		return true
	end
	
	if self:HasSpawnFlags(1) then
        self.Think = function() end
        self:Remove()
    else
		self.Disabled = true
	end
	
	local loadType = GAMEMODE:GetMapLoadType()
	
	if loadType == "transition" then
		self:TriggerOutput("OnMapTransition")
    elseif loadType == "newgame" then
        self:TriggerOutput("OnNewGame")
    elseif loadType == "loadgame" then
        self:TriggerOutput("OnLoadGame")
    elseif loadType == "background" then
        self:TriggerOutput("OnBackgroundMap")
	end
	
	self:TriggerOutput("OnMapSpawn")
	
	self:NextThink(CurTime() + 0.2)
	
	return true
end