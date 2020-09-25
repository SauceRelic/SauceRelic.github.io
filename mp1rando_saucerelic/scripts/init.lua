Tracker:AddItems("items/equips.json")
Tracker:AddItems("items/artifacts.json")

if not string.find(Tracker.ActiveVariantUID, "v_itemsonly") then
  diff_cStage = 0
  startArea_en = nil

  Tracker:AddItems("items/settings.json")
  Tracker:AddItems("items/anchors.json")
  Tracker:AddMaps("maps/maps.json")

  ScriptHost:LoadScript("scripts/logic.lua")
  ScriptHost:LoadScript("scripts/interface.lua")

  Tracker:AddLocations("locations/anchors.json")
  Tracker:AddLocations("locations/locations.json")

  Tracker:AddLayouts("layouts/settings.json")
end

Tracker:AddLayouts("layouts/shared.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")