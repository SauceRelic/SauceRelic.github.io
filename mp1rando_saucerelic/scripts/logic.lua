function hasItem(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

function missing(item)
  if hasItem(item) then
    return false
  else
    return true
  end
end

function disabled(item)
  return missing(item)
end

function MagmoorRun()
  if hasItem("t_vmr") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmretanks")) then
    return 1
  else
    return hasItem("varia") or hasItem("gravity") or hasItem("phazon")
  end
end

function EarlyMagmoor()
  if hasItem("t_earlymagitems") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks")) then
    return 1
  else
    return hasItem("varia") or hasItem("gravity") or hasItem("phazon")
  end
end

function ERIB()
  if hasItem("t_terrain") and hasItem("t_ghetto") then
    return (hasItem("t_eliteib") and hasItem("boost")) or (hasItem("morph") and hasItem("bombs"))
  else
    return true
  end
end
