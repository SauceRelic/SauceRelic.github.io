--[[function tracker_on_accessibility_updated()

end--]]

--function 

-- Allows starting locations to be shown only when no anchors are in logic, i.e. no starting area has been selected
function startingAreaVis()
  local anchorsTable = {"temple", "to_north", "to_east", "to_west", "to_southchozo", "to_southmines", "cr_west", "cr_north", "cr_east", "cr_south",
    "mc_north", "mc_west", "mc_east", "mc_southmines", "mc_southphen", "pd_north", "pd_south", "pm_east", "pm_west"}
  
  for i,code in ipairs(anchorsTable) do
    if has(code) then
      return false
    end
  end
  return true
end

-- Places a badge on the specified location
-- Will be used for potential softlock warnings
function Badge(locref, img)
  local location = Tracker:FindObjectForCode(locref)
  location:AddBadge(img)
end

--[[
-- Places an item in the specified location's capture
-- Not currently used in this package, but I'm keeping it here in case it's needed later/in another package
function VanillaTrack(locationref, setting, item)
  local location = Tracker:FindObjectForCode(locationref)
  
  if location then
    if disabled(setting) then
      location.CapturedItem = Tracker:FindObjectForCode(item)
    end
  end
end
--]]