function hasItem(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

function antiGravity()
  return not hasItem("gravity")
end

function allowBackPhenBombs()
  return not hasItem("nolatebombs")
end

function vis()
  return not hasItem("obfuscate")
end

function MagmoorRun()
  if hasItem("trick_vmr") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("vmretanks")) then
    return 1
  else
    return hasItem("varia") or hasItem("gravity") or hasItem("phazon")
  end
end

function EarlyMagmoor()
  if hasItem("trick_earlymagitems") and (Tracker:ProviderCountForCode("etanks") >= Tracker:ProviderCountForCode("earlyetanks")) then
    return 1
  else
    return hasItem("varia") or hasItem("gravity") or hasItem("phazon")
  end
end
