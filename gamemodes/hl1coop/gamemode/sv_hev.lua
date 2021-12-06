function GM:HEV_TakeDamage(ply, dmginfo)
	local SUIT_NEXT_IN_30SEC = 30
	local SUIT_NEXT_IN_1MIN = 60
	local SUIT_NEXT_IN_5MIN = 300
	local SUIT_NEXT_IN_10MIN = 600
	local SUIT_NEXT_IN_30MIN = 1800
	local SUIT_NEXT_IN_1HOUR = 3600

	local flHealthPrev = ply:Health()
	local m_lastDamageAmount = dmginfo:GetDamage()
	local newHealth = flHealthPrev - m_lastDamageAmount
	
	if newHealth > 0 then	
		local ftrivial = newHealth > 75 or m_lastDamageAmount < 5
		local fmajor = m_lastDamageAmount > 25
		local fcritical = newHealth < 30

		if !ftrivial then	
			if dmginfo:IsDamageType(DMG_CLUB) then
				if fmajor then
					ply:SetSuitUpdate("HEV_DMG4", SUIT_NEXT_IN_30SEC) -- minor fracture
				end
			elseif dmginfo:IsDamageType(bit.bor(DMG_FALL, DMG_CRUSH)) then
				if fmajor then
					ply:SetSuitUpdate("HEV_DMG5", SUIT_NEXT_IN_30SEC) -- major fracture
				else
					ply:SetSuitUpdate("HEV_DMG4", SUIT_NEXT_IN_30SEC) -- minor fracture
				end
			elseif dmginfo:IsDamageType(DMG_BULLET) then
				if m_lastDamageAmount > 5 then
					ply:SetSuitUpdate("HEV_DMG6", SUIT_NEXT_IN_30SEC) -- blood loss
				end
			elseif dmginfo:IsDamageType(DMG_SLASH) then
				if fmajor then
					ply:SetSuitUpdate("HEV_DMG1", SUIT_NEXT_IN_30SEC)	-- major laceration
				else
					ply:SetSuitUpdate("HEV_DMG0", SUIT_NEXT_IN_30SEC)	-- minor laceration
				end
			elseif dmginfo:IsDamageType(DMG_SONIC) then
				if fmajor then
					ply:SetSuitUpdate("HEV_DMG2", SUIT_NEXT_IN_1MIN)	-- internal bleeding
				end
			elseif dmginfo:IsDamageType(bit.bor(DMG_POISON, DMG_PARALYZE)) then
				ply:SetSuitUpdate("HEV_DMG3", SUIT_NEXT_IN_1MIN)	-- blood toxins detected
			elseif dmginfo:IsDamageType(DMG_ACID) then
				ply:SetSuitUpdate("HEV_DET1", SUIT_NEXT_IN_1MIN)	-- hazardous chemicals detected
			elseif dmginfo:IsDamageType(DMG_NERVEGAS) then
				ply:SetSuitUpdate("HEV_DET0", SUIT_NEXT_IN_1MIN)	-- biohazard detected
			elseif dmginfo:IsDamageType(DMG_RADIATION) then
				ply:SetSuitUpdate("HEV_DET2", SUIT_NEXT_IN_1MIN)	-- radiation detected
			end		
		end
		
		if !ftrivial and fmajor and flHealthPrev >= 75 then
			-- first time we take major damage...
			-- turn automedic on if not on
			ply:SetSuitUpdate("HEV_MED1", SUIT_NEXT_IN_30MIN) -- automedic on

			-- give morphine shot if not given recently
			ply:SetSuitUpdate("HEV_HEAL7", SUIT_NEXT_IN_30MIN) -- morphine shot
		end
		
		if !ftrivial and fcritical and flHealthPrev < 75 then
			-- already took major damage, now it's critical...
			if flHealthPrev < 6 then
				ply:SetSuitUpdate("HEV_HLTH3", SUIT_NEXT_IN_10MIN) -- near death
			elseif flHealthPrev < 20 then
				ply:SetSuitUpdate("HEV_HLTH2", SUIT_NEXT_IN_10MIN) -- health critical
			end
			
			-- give critical health warnings
			if math.random(0,3) == 0 and flHealthPrev < 50 then
				ply:SetSuitUpdate("HEV_DMG7", SUIT_NEXT_IN_5MIN) -- seek medical attention
			end
		end
		
		local DMG_TIMEBASED = bit.bor(DMG_BURN, DMG_DROWN, DMG_ENERGYBEAM, DMG_SHOCK, DMG_SLOWBURN)
		
		if dmginfo:IsDamageType(DMG_TIMEBASED) and flHealthPrev < 75 then
			if flHealthPrev < 50 then
				if math.random(0,3) == 0 then
					ply:SetSuitUpdate("HEV_DMG7", SUIT_NEXT_IN_5MIN) -- seek medical attention
				end
			else
				ply:SetSuitUpdate("HEV_HLTH1", SUIT_NEXT_IN_10MIN) -- health dropping
			end
		end
	end
end

function GM:HEV_NoAmmo(wep, owner)
	owner:SetSuitUpdate("HEV_AMO0")
end

function GM:HEV_ArmorPickup(ply, maxarmor)
	local pct = math.Round((ply:Armor() * 100) * (1.0/maxarmor) + 0.5)
	pct = (pct / 5)
	if pct > 0 then
		pct = pct - 1
	end
	pct = math.floor(pct)
	ply:SetSuitUpdate("HEV_"..pct.."P", 30)
end