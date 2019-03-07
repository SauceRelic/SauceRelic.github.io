function tracker_on_accessibility_updated()
  ArtifactCounter()
end

function ArtifactCounter()
  local artifacts = Tracker:FindObjectForCode("broadarts")

  artifacts.AcquiredCount = Tracker:ProviderCountForCode("allartifacts")
end
