AddCSLuaFile()
include("entities/hl1_item_battery.lua")

function ENT:HEV_ArmorPickup(ply, maxarmor)
	gamemode.Call("HEV_ArmorPickup", ply, maxarmor)
end