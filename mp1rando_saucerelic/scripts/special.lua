--[[function tracker_on_accessibility_updated()

end--]]

function VanillaTrack(locationref, setting, item)
  local location = Tracker:FindObjectForCode(locationref)
  
  if location then
    if disabled(setting) then
      location.CapturedItem = Tracker:FindObjectForCode(item)
    end
  end
end

function Badge(locref, img)
  local location = Tracker:FindObjectForCode(locref)
  location:AddBadge(img)
end
