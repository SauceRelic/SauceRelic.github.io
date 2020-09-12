--[[function tracker_on_accessibility_updated()

end--]]

function 

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

function trick(code, desiredStage)
  local setting = Tracker:FindObjectForCode(code)
  if setting then
    local cStage = setting.CurrentStage
    if desiredStage then
      return cStage == desiredStage
    else
      if cStage == 1 then
        return true
      elseif cStage == 2 then
        return true, AccessibilityLevel.SequenceBreak
      else
        return false
      end
    end
  end
end



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
