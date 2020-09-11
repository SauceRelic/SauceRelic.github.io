Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/equips.json")
Tracker:AddItems("items/artifacts.json")

if not string.find(Tracker.ActiveVariantUID, "v_itemsonly") then
  Tracker:AddLocations("locations/settings.json")
  ScriptHost:LoadScript("scripts/logic.lua")
  Tracker:AddLayouts("layouts/settings.json")
  
  Tracker:AddItems("items/anchors.json")
  Tracker:AddMaps("maps/maps.json")

  Tracker:AddLocations("locations/logic.json")
  Tracker:AddLocations("locations/locations.json")
end

ScriptHost:LoadScript("scripts/settings.lua")

Tracker:AddLayouts("layouts/shared.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")