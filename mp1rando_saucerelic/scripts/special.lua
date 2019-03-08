function tracker_on_accessibility_updated()
  ArtifactCounter()
  ShuffleItems()
end

function ArtifactCounter()
  local artifacts = Tracker:FindObjectForCode("broadarts")

  artifacts.AcquiredCount = Tracker:ProviderCountForCode("allartifacts")
end

function ShuffleItems()
  -- Missile Launcher
  VanillaTrack("@Hive Totem/Missile Launcher", "shuf_launcher", "missile")
  -- Morph Ball
  VanillaTrack("@Ruined Shrine/Beetle Battle (Morph Ball)", "shuf_morph", "morph")
  -- Bombs
  VanillaTrack("@Burn Dome/Incinerator Drone (Morph Bomb)", "shuf_bombs", "bomb")
  -- Charge Beam
  VanillaTrack("@Watery Hall/Scan Puzzle (Charge Beam)", "shuf_charge", "charge")
  -- Space Jump
  VanillaTrack("@Alcove/Space Jump", "shuf_space", "space")

  -- Artifacts
  VanillaTrack("@Artifact Temple/Artifact of Truth", "shuf_artifacts", "truth")
  VanillaTrack("@Warrior Shrine/Artifact of Strength", "shuf_artifacts", "strength")
  VanillaTrack("@Control Tower/Artifact of Elder", "shuf_artifacts", "elder")
  VanillaTrack("@Sunchamber/Ghosts (Artifact of Wild)", "shuf_artifacts", "wild")
  VanillaTrack("@Tower Chamber/Artifact of Lifegiver", "shuf_artifacts", "lifegiver")
  VanillaTrack("@Elite Research/Phazon Elite (Artifact of Warrior)", "shuf_artifacts", "warrior")
  VanillaTrack("@Life Grove/Artifact of Chozo", "shuf_artifacts", "chozo")
  VanillaTrack("@Lava Lake/Artifact of Nature", "shuf_artifacts", "nature")
  VanillaTrack("@Chozo Ice Temple/Artifact of Sun", "shuf_artifacts", "sun")
  VanillaTrack("@Elder Chamber/Artifact of World", "shuf_artifacts", "world")
  VanillaTrack("@Storage Cave/Artifact of Spirit", "shuf_artifacts", "spirit")
  VanillaTrack("@Phazon Mining Tunnel/Artifact of Newborn", "shuf_artifacts", "newborn")
end

function VanillaTrack(locationref, setting, item)
  local location = Tracker:FindObjectForCode(locationref)
  
  if location then
    if disabled(setting) then
      location.CapturedItem = Tracker:FindObjectForCode(item)
    end
  end
end 
