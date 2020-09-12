--[[function tracker_on_accessibility_updated()

end--]]

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
