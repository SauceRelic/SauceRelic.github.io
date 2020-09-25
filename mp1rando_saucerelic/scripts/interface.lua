--[[function tracker_on_accessibility_updated()

end--]]

function startingAreaControl()
  local setting = Tracker:FindObjectForCode("startingArea")
  if setting.Active ~= startArea_en then
    startArea_en = setting.Active
    local landsite = Tracker:FindObjectForCode("to_north")
    local ulandsite = Tracker:FindObjectForCode("u_to_north")

    if not startArea_en then
      landsite.Active = true
      ulandsite.Active = true
    else
      landsite.Active = false
      ulandsite.Active = false
    end
  end

  return 0
end

-- Allows starting locations to be shown only when no anchors are in logic, i.e. no starting area has been selected
function startingAreaVis()
  local anchorsTable = {
    "temple", "to_north", "to_east", "to_west", "to_southchozo", "to_southmines", "cr_west", "cr_north", "cr_east", "cr_south",
    "mc_north", "mc_west", "mc_east", "mc_southmines", "mc_southphen", "pd_north", "pd_south", "pm_east", "pm_west"
  }

  for i,code in ipairs(anchorsTable) do
    if has(code) then
      return false
    end
  end
  return true
end

function difficultySwitch()
  local setting = Tracker:FindObjectForCode("difficulty")
  if setting.CurrentStage ~= diff_cStage then
    diff_cStage = setting.CurrentStage

    local tricksTable = {
      "alcoveNoItems", "antechamberWithPowerBombs", "arborChamberWithoutPlasma", "arboretumPuzzleSkip", "chapelOfTheEldersWithPowerBombs", "chozoIceTempleItemWithIS", "chozoIceTempleWithoutSpaceJump", "climbFrigateCrashSite", "climbFrozenPikeWithoutBombs", "climbObservatoryWithoutBoost",
      "climbOreProcessingWithoutGrappleSpider", "climbPhazonProcessingCenterWithoutSpider", "climbReflectingPoolWithoutBoostBall", "climbRuinedCourtyardWithoutBoostSpider", "climbTowerOfLightWithoutMissiles", "crashedFrigateGammaElevatorWithoutGravity", "crossMagmaPoolSuitless", "crossMagmaPoolWithoutGrapple", "crossTwinFiresTunnelSuitless", "crossTwinFiresTunnelWithoutSpider",
      "crosswayHpbj", "crosswayItemFewerReqs", "destroyBombCoversWithPowerBombs", "earlyPhendranaBehindIceItemsWithIS", "eliteResearchLaserItemWithoutBoost", "lateMagmoorNoHeatProtection", "exitPhendranaCanyonNoItems", "exitQuarantineCaveRuinedCourtyardSlopeJump", "fieryShoresAccessWithoutMorphGrapple", "fieryShoresItemSj",
      "frigateCrashSiteItemOnlyScanVisor", "frigateCrashSiteItemWithoutGravitySuit", "furnaceAccessWithoutSpider", "furnaceSpiderTrackItemHBJ", "furnaceSpiderTrackItemSpaceJumpBombs", "gatheringHallWithoutSpaceJump", "gravityChamberLedgeItemWithoutGrapplePlasma", "greatTreeHallBarsSkip", "hallOfTheEldersBombSlotsWithoutSpider", "hallOfTheEldersItemsWithIS",
      "hydroAccessTunnelWithoutGravity", "iceBeamBeforeFlaahgraOobWallcrawl", "iceRuinsEastSpiderItemWithoutSpider", "eliteResearchInfiniteBoostClip", "lavaLakeItemSuitless", "lavaLakeItemOnlyMissiles", "lifeGroveSpinnerWithoutBoostBall", "lifeGroveTunnelHpbj", "lowerPhazonMineWithoutSpiderGrapple", "magmaPoolItemWithIS",
      "mainPlazaHpbj", "mainPlazaGrappleLedgeOnlyGrapple", "mainPlazaItemsOnlySpaceJump", "mainPlazaTreeNoSpaceJump", "mainQuarryItemWithoutSpider", "mainQuarryToOreProcessingWithoutGrapple", "observatoryPuzzleSkip", "outOfBoundsWithoutMorphBall", "phazonMiningTunnelItemWithoutPhazonSuit", "phendranaTransportSouthToTransportAccessWithoutSpider",
      "plasmaProcessingItemWithoutGrappleSpider", "plasmaProcessingFromMagmoorWorkstationOob", "quarantineMonitorDash", "trainingChamberAndAccessOobWallcrawl", "reflectingPoolAccessWithoutWaveBeam", "removePhendranaDepthsGrappleReqs", "removeThermalReqs", "removeXrayReqs", "rootCaveArborChamberWithoutGrapple", "ruinedFountainItemFlaahgraSkip",
      "ruinedNurseryWithoutBombs", "ruinedShrineScanDashEscape", "shoreTunnelEscapeWithoutSpaceJump", "spiderlessShafts", "suitlessMagmoorRun", "suitlessMagmoorRunMinimal", "sunTowerIbj", "towerChamberNoGravity", "boostThroughBombTunnels", "triclopsPitItemWithCharge",
      "triclopsPitItemWithoutSpaceJump", "upperRuinedShrineTowerOfLightFewerAccessReqs", "vaultAccessFromMainPlaza", "ventShaftHpbj", "warriorShrineMinimumReqs", "warriorShrineWithoutBoost", "wateryHallUnderwaterFlaahgraSkip", "wateryHallUnderwaterSlopeJump", "wateryHallScanPuzzleWithIS", "waveSunOobWallcrawlWithIS"
    }
    local trickStageTable = {}

    if     diff_cStage == 0 then
      trickStageTable = {0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0}
    elseif diff_cStage == 1 then
      trickStageTable = {0,0,0,0,0,0,0,0,0,0, 0,0,2,0,0,0,0,0,0,0, 0,0,2,0,0,2,2,0,2,2, 0,0,2,0,0,2,0,0,2,0, 0,0,0,0,0,0,0,0,0,0, 0,2,2,2,0,0,0,0,0,2, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,2,0,2, 0,0,2,0,0,0,2,0,0,0}
    elseif diff_cStage == 2 then
      trickStageTable = {2,0,0,2,0,0,0,2,2,0, 2,2,2,2,2,2,0,0,0,2, 0,2,2,0,2,2,2,0,2,2, 2,2,2,0,0,2,0,0,2,0, 0,0,0,0,0,2,0,0,0,0, 0,2,2,2,0,2,0,0,0,2, 2,0,0,0,0,2,2,2,2,0, 0,2,0,0,0,0,0,2,0,2, 0,2,2,0,0,2,2,2,0,0}
    elseif diff_cStage == 3 then
      trickStageTable = {2,2,0,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 0,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 0,0,0,2,2,2,2,0,2,2, 0,2,2,2,2,2,2,0,0,2, 2,0,2,0,2,2,2,2,2,2, 0,2,2,0,0,0,2,2,0,2, 2,2,2,0,2,2,2,2,2,0}
    elseif diff_cStage == 4 then
      trickStageTable = {2,2,0,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 0,0,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,0,0,2, 2,0,2,0,2,2,2,2,2,2, 2,2,2,2,2,0,2,2,0,2, 2,2,2,2,2,2,2,2,2,0}
    elseif diff_cStage == 5 then
      trickStageTable = {2,2,0,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,0,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,0,2,2, 2,0,2,0,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,0}
    elseif diff_cStage == 6 then
      trickStageTable = {2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2}
    end

    for i,code in ipairs(tricksTable) do
      local obj = Tracker:FindObjectForCode("t_"..code)
      obj.CurrentStage = trickStageTable[i]
    end

  end

  return 0
end

CaptureBadgeCache = {}

-- Places a badge on the specified location
-- Will be used for potential softlock warnings
function badgeHandler(locref, img)
  local section = Tracker:FindObjectForCode(locref)
  if section then
    if CaptureBadgeCache[section.Owner] then
      section.Owner:RemoveBadge(CaptureBadgeCache[section.Owner])
      CaptureBadgeCache[section.Owner] = nil
    end

    if img then
      CaptureBadgeCache[section.Owner] = section.Owner:AddBadge(img)
    end

  else
    print("badgeHandler exception: invalid location reference",locref)
  end
end

--[[
-- Places an item in the specified location's capture
-- Not currently used in this package, but I'm keeping it here in case it's needed later/in another package
function VanillaTrack(locationref, setting, item)
  local location = Tracker:FindObjectForCode(locationref)

  if location then
    if disabled(setting) then
      location.CapturedItem = Tracker:FindObjectForCode(item)
    end
  end
end
--]]