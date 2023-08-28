ENT.Type = "anim"
ENT.Base = "hl1_item_pickup_base"
ENT.PrintName = "HL1 Weapon Box"
ENT.Category = "Half-Life"
ENT.Author = "Upset"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "OwnerNick")
end

if CLIENT then
	function ENT:Draw()
		local owner = self:GetOwner()
		if IsValid(owner) and owner != LocalPlayer() then
			render.SetBlend(.5)
		end
		self:DrawModel()
		render.SetBlend(1)
		local nick = self:GetOwnerNick()
		if nick != "" then
			local ang = self:GetAngles()
			cam.Start3D2D(self:GetPos() + ang:Up() * 34 + ang:Forward() * .7, ang + Angle(0, 90, 90), .2)
				draw.DrawText(nick, "Trebuchet18", 0, 0, Color(240, 160, 40, 200), TEXT_ALIGN_CENTER) 
			cam.End3D2D()
			cam.Start3D2D(self:GetPos() + ang:Up() * 34 - ang:Forward() * .7, ang + Angle(0, -90, 90), .2)
				draw.DrawText(nick, "Trebuchet18", 0, 0, Color(240, 160, 40, 200), TEXT_ALIGN_CENTER) 
			cam.End3D2D()
		end
	end
end