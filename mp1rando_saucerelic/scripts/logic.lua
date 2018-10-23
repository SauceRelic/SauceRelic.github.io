function hasItem(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

function antiGravity()
  if hasItem("gravity") then
    return 0
  else
    return 1
  end
end

function MagmoorRun()
  if hasItem("trick_vmr") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmretanks")) then
    return 1
  elseif hasItem("varia") or hasItem("gravity") or hasItem("phazon") then
    return 1
  else
    return 0
  end
end

function EarlyMagmoor()
  if hasItem("trick_earlymagitems") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks")) then
    return 1
  elseif hasItem("varia") or hasItem("gravity") or hasItem("phazon") then
    return 1
  else
    return 0
  end
end
