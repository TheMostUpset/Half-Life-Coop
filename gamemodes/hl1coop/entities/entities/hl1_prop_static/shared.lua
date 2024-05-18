ENT.Type = "anim"
ENT.Author = "Upset"
ENT.Spawnable = false

if CLIENT then
	local cvar_optimize = CreateClientConVar("hl1_coop_cl_prop_optimization", 0, true, false, "Static props rendering opmitization", 0, 1)

	function ENT:Initialize()
		self.PixVis = util.GetPixelVisibleHandle()
		self.ModelRadius = self:GetModelBounds():Length() * 1.25
		self.MinRadius = self.ModelRadius * 800
	end
	
	function ENT:Draw()
		if !cvar_optimize:GetBool() then
			self:DrawModel()
			return
		end
		
		local pos, radius = self:WorldSpaceCenter(), self.ModelRadius
		local dist = math.huge
		local visible = util.PixelVisible(pos, radius, self.PixVis)
		if visible == 0 then
			dist = LocalPlayer():EyePos():DistToSqr(pos)
		end
		if visible != 0 or dist < self.MinRadius then
			self:DrawModel()
		end
		-- render.DrawWireframeSphere(pos, radius, 8, 8)
	end
end