Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/equips.json")
Tracker:AddItems("items/artifacts.json")

if not string.find(Tracker.ActiveVariantUID, "v_itemsonly") then
  if not string.find(Tracker.ActiveVariantUID, "v_legacy") then
    Tracker:AddItems("items/sbsettings.json")
    Tracker:AddLocations("locations/settings.json")
    ScriptHost:LoadScript("scripts/logic.lua")
    Tracker:AddLayouts("layouts/settings.json")
  end
  
  Tracker:AddMaps("maps/maps.json")

  Tracker:AddLocations("locations/logic.json")
  Tracker:AddLocations("locations/locations.json")
end

ScriptHost:LoadScript("scripts/special.lua")

Tracker:AddLayouts("layouts/shared.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")