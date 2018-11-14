Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/equips.json")
Tracker:AddItems("items/artifacts.json")

if not string.find(Tracker.ActiveVariantUID, "v_itemsonly") then
  if string.find(Tracker.ActiveVariantUID, "v_dev") then
    Tracker:AddItems("items/sbsettings.json")
    ScriptHost:LoadScript("scripts/logic.lua")
  end
  
  Tracker:AddMaps("maps/maps.json")

  Tracker:AddLocations("locations/logic.json")
  Tracker:AddLocations("locations/locations.json")
end

Tracker:AddLayouts("layouts/shared.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")