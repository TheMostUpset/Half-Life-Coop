
if CLIENT then

	SWEP.PrintName			= "Pickup Editor"
	SWEP.Author				= "Upset"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 0
	SWEP.CrosshairXY		= {24, 0}
	SWEP.WepSelectIcon		= surface.GetTextureID("hl1/icons/glock")

end

SWEP.Base 				= "weapon_hl1_base"
SWEP.Weight				= 0
SWEP.HoldType			= "pistol"

SWEP.Category			= "Other"
SWEP.Spawnable			= false

SWEP.PlayerModel		= Model("models/hl1/p_9mmhandgun.mdl")
SWEP.EntModel			= Model("models/w_9mmhandgun.mdl")

SWEP.CModel				= Model("models/hl1/c_9mmhandgun.mdl")
SWEP.VModel				= Model("models/v_9mmhandgun.mdl")

SWEP.ViewModel			= SWEP.CModel
SWEP.WorldModel			= SWEP.PlayerModel

SWEP.Primary.Delay	 		= .04
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Secondary.Automatic	= true

function SWEP:Initialize()
	self.PickupAngle = Angle()
	self.PickupPosAdd = Vector()
end

function SWEP:Deploy()
	if IsValid(self.PickupEntity) then
		self.PickupEntity:Remove()
	end
	if self.PickupClass then
		self.PickupEntity = ents.Create(self.PickupClass)
		local ent = self.PickupEntity
		if IsValid(ent) then
			ent:SetPos(self.Owner:GetEyeTrace().HitPos)
			ent:SetAngles(self.PickupAngle)
			ent:SetColor(Color(100, 255, 100, 180))
			ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
			ent:Spawn()
			ent:SetSolid(SOLID_NONE)
			ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
			ent:SetTrigger(false)
			ent:SetMoveType(MOVETYPE_NONE)
			ent.Pickable = false
		end
	end
	return true
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:OnRemove()
	if IsValid(self.PickupEntity) then
		self.PickupEntity:Remove()
	end
end

function SWEP:AddVector(num)
	self.PickupPosAdd[3] = self.PickupPosAdd[3] + num
	self.Owner:PrintMessage(HUD_PRINTCENTER, tostring(self.PickupPosAdd))
end

function SWEP:AddAngle(num)
	self.PickupAngle[2] = self.PickupAngle[2] + num
	self.PickupAngle:Normalize()
	self.Owner:PrintMessage(HUD_PRINTCENTER, tostring(self.PickupAngle))
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Owner:KeyDown(IN_USE) then
		self:AddVector(1)
		return
	end
	self:AddAngle(5)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	if self.Owner:KeyDown(IN_USE) then
		self:AddVector(-1)
		return
	end
	self:AddAngle(-5)
end

function SWEP:Reload()
	if self.Removed then return end

	if self.Owner:KeyDown(IN_USE) then
		self.PickupAngle = Angle()
		self.PickupPosAdd = Vector()
		return
	end
	if !self.PickupPos or !self.PickupAngle then return end
	self.PickupPos = self.PickupPos + self.PickupPosAdd
	local pos, ang = self.PickupPos, self.PickupAngle
	ang:Normalize()
	local func = "CreateWeaponEntity"
	if self.IsItem then
		func = "CreatePickupEntity"
	end
	local text = 'GAMEMODE:'..func..'("'..self.PickupClass..'", Vector('..math.Round(pos[1])..', '..math.Round(pos[2])..', '..math.Round(pos[3])..'), Angle('..math.Round(ang[1])..', '..math.Round(ang[2])..', '..math.Round(ang[3])..'))'
	-- self.Owner:PrintMessage(HUD_PRINTCONSOLE, text)
	print(text)
	self:Remove()
	self.PickupEntity:Remove()
	self.Removed = true
end

function SWEP:Think()
	if !game.SinglePlayer() and self.NextThinkTime and self.NextThinkTime > CurTime() then return end
	self.NextThinkTime = CurTime() + .2
	
	local ent = self.PickupEntity
	if IsValid(ent) then
		local tr = util.TraceLine({
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 10000,
			filter = {ent, self.Owner}
		})
		self.PickupPos = tr.HitPos
		ent:SetPos(self.PickupPos + self.PickupPosAdd)
		ent:SetAngles(self.PickupAngle)
	end
end

function SWEP:WeaponIdle()
end