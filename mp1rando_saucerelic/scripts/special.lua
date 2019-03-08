function tracker_on_accessibility_updated()
  ArtifactCounter()
  ShuffleItems()
end

function ArtifactCounter()
  local artifacts = Tracker:FindObjectForCode("broadarts")

  artifacts.AcquiredCount = Tracker:ProviderCountForCode("allartifacts")
end

function ShuffleItems()
  VanillaTrack("@Chozo Ruins/Hive Totem/Missile Launcher", "shuf_launcher", "missile")
end

function VanillaTrack(locationref, setting, item)
  local location = Tracker:FindObjectForCode(locationref)
  
  if location then
    if disabled(setting) then
      location.CapturedItem = Tracker:FindObjectForCode(item)
    end
  end
end 
