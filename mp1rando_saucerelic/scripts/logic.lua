function antiGravity()
  if Tracker:ProviderCountForCode("gravity") > 0 then
    return 0
  else
    return 1
  end
end

function suitlessEarlyMagmoor()
  if Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks") then
    return 1
  else
    return 0
  end
end

function suitlessMagmoorRun()
  if Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmretanks") then
    return 1
  else
    return 0
  end
end
