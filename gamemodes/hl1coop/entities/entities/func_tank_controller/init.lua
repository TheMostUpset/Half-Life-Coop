AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetNoDraw(true)
	self:SetSolid(SOLID_NONE)
	self.ParentEnt = self:GetParent()
	self.DangerDist = 80000 -- stops attacking and searching below this dist, used for explosives
	self.UpdateTime = 1
end

function ENT:TargetVisible(target)
	if self.CustomTraceCheck then
		local startPos = self:GetPos()
		local tr = util.TraceHull({
			start = startPos,
			endpos = target:EyePos(),
			filter = {self, self.ParentEnt}
		})		
		return tr.Entity == target
	else
		return target:Visible(self) or target:Visible(self.ParentEnt)
	end
end

function ENT:Think()
	if IsValid(self.ParentEnt) and GetConVarNumber("ai_disabled") <= 0 and GetConVarNumber("ai_ignoreplayers") <= 0 then
		local target = self:GetTarget()
		if self.Explosive and IsValid(target) then
			local dist = self:GetPos():DistToSqr(target:GetPos())
			if dist <= self.DangerDist then
				target = NULL
				self:SetTarget(target)
			end
		end
		if !IsValid(target) or !target:Alive() or !self:TargetVisible(target) then
			if self.ForceTraceCheck and IsValid(target) then
				self:SetTarget(NULL)
			end
			self:FindNewTarget()
		end
	end
	self:NextThink(CurTime() + self.UpdateTime)
	return true
end

function ENT:FindNewTarget()
	local t = {}
	
	for k, v in pairs(ents.FindInPVS(self:GetPos())) do
		if v:IsPlayer() and v:Alive() and self:TargetVisible(v) then
			local dist = self:GetPos():DistToSqr(v:GetPos())
			if self.Explosive and dist > self.DangerDist or !self.Explosive then
				table.insert(t, {v, dist})
			end
		end
	end
	table.sort(t, function(a,b) return a[2] < b[2] end)
	
	t = t[1]
	if t then
		local target = t[1]
		if IsValid(target) then
			self:SetTarget(target)
		end
	end
end

function ENT:GetTarget()
	return self.ParentEnt:GetInternalVariable("m_hTarget")
end

function ENT:SetTarget(ent)
	self.ParentEnt:SetSaveValue("m_hTarget", ent)
end