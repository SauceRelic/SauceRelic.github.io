function hasItem(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

function missing(item)
  return not hasItem(item)
end

function disabled(item,sb)
  if sb == nil then
    return missing(item)
  else
    if missing(item) then
     return true
    else
      return missing(sb), AccessibilityLevel.SequenceBreak
    end
  end
end

function MagmoorRun()
  if hasItem("t_vmr") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmrtanks")) then
    return true
  elseif hasItem("varia") or hasItem("gravity") or hasItem("phazon") then
    return true
  elseif hasItem("t_vmr") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("sb_vmrtanks")) then
    return true, AccessibilityLevel.SequenceBreak
  elseif hasItem("sb_t_vmr") and ((Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmrtanks")) or (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("sb_vmrtanks"))) then
    return true, AccessibilityLevel.SequenceBreak
  else
    return false
  end
end

function EarlyMagmoor()
  if hasItem("t_earlymagitems") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks")) then
    return true
  elseif hasItem("varia") or hasItem("gravity") or hasItem("phazon") then
    return true
  elseif hasItem("t_earlymagitems") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("sb_earlyetanks")) then
    return true, AccessibilityLevel.SequenceBreak
  elseif hasItem("sb_t_earlymagitems") and ((Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks")) or (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("sb_earlyetanks"))) then
    return true, AccessibilityLevel.SequenceBreak
  else
    return false
  end
end

function ERIB()
  if hasItem("t_terrain") and hasItem("t_ghetto") then
    return (hasItem("t_eliteib") and hasItem("boost")) or (hasItem("morph") and hasItem("bombs"))
  else
    return true
  end
end
