-- Basic Functions

function tristate(state)
  if     state == 2 then
    return true
  elseif state == 1 then
    return true, AccessibilityLevel.SequenceBreak
  elseif state == 0 then
    return false
  else
    print("tristate exception: invalid state",state)
    return false
  end
end

-- Shortcut for checking item ownership
function has(item,mode)
  if not mode then
    if Tracker:ProviderCountForCode(item) >= 1 then
      return true
    else
      return false
    end

  elseif mode == 1 then
    if Tracker:ProviderCountForCode(item) >= 1 then
      return 2
    else
      return 0
    end

  else
    print("has exception: invalid mode",mode)
    return false
  end
end

-- Alias for has(), denotes randomizer settings
function set(item,mode)
  return has(item,mode)
end

-- Inverse has(), used only for access rules defined in json so mode is nil
function nhas(item)
  return not has(item)
end

-- Selector function for tri-state trick items
-- For item stages, 0 is off, 1 is out of logic but known by user (sequence breakable), and 2 is on
-- Setting "mode" changes the returns of the function:
--  if mode==nil: 0 returns false, 1 returns true with sequence break, 2 returns true
--  if mode==0:   0 returns false, 1 returns false, 2 returns true
--  if mode==1:   Return current stage
function trick(code, mode)
  local setting = Tracker:FindObjectForCode(code)
  if setting then
    local cStage = setting.CurrentStage
    if cStage then

      if not mode or mode == 0 then
        if cStage == 0 then
          return false

        elseif cStage == 1 then
          if mode then
            return false
          else
            return true, AccessibilityLevel.SequenceBreak
          end

        elseif cStage == 2 then
          return true
        end

      elseif mode == 1 then
        return cStage

      else
        print("trick exception: invalid mode",mode)
        return false
      end
    else
      print("trick exception: code did not refer to a trick setting",code)
      return false
    end
  else
    print("trick exception: could not find object for code",code)
  end
end

-- Returns by trick stage:
-- 0: true
-- 1: true
-- 2: true,sequencebreak
function ntrick(code)
  local ret = trick(code,1)
  if ret == 2 then
    return true, AccessibilityLevel.SequenceBreak
  else
    return true
  end
end

-- Evaluates a boolean statement consisting of only or operators between terms
function orN(...)
  for i,v in ipairs({...}) do
    if has(v) then
      return true
    end
  end
  return false
end


-- Evaluates a boolean statement with structure:
-- (has(x) and ... and has(z)) or (...) or ...
-- Arguments are either item code strings or "or", which denotes or operators in the structure
function eval(...)
  local statementPart = 2
  local statementFull = 0

  for i,v in ipairs({...}) do

    if v == "or" then
      statementFull = math.max(statementFull,statementPart)
      if statementFull == 2 then
        return true
      else
        statementPart = 2
      end

    elseif statementPart == 0 then
      -- Do nothing

    elseif string.find(v,"t_") then
      statementPart = math.min(statementPart,trick(v,1))

    else
      statementPart = math.min(statementPart,has(v,1))

    end
  end

  statementFull = math.max(statementFull,statementPart)
  return tristate(statementFull)
end

-- Item combo shortcuts
function etanks(count)
  local tanks = Tracker:ProviderCountForCode("etank")
  if tanks >= count then
    return 2
  else
    return 0
  end
end

function canBomb()
  return has("morph") and has("bomb")
end

function canPb()
  return has("morph") and has("powerbomb")
end

function canBombOrPb()
  return has("morph") and (has("bomb") or has("powerbomb"))
end

function canBoost()
  return has("morph") and has("boost")
end

function canSpider()
  return has("morph") and has("spider")
end

function canSuper()
  return has("missile") and has("charge") and has("super")
end

function thermalReqs(mode)
  local trick = Tracker:FindObjectForCode("t_removeThermalReqs")
  local cStage = trick.CurrentStage

  if not mode or mode == 0 then
    if cStage == 2 then
      return true

    elseif cStage == 1  and not mode then
      if has("thermal") then
        return true
      else
        return true, AccessibilityLevel.SequenceBreak
      end

    else
      return has("thermal")
    end

  elseif mode == 1 then
    return cStage

  else
    print("thermalReqs exception: invalid mode",mode)
    return false
  end
end

function xrayReqs(mode)
  local trick = Tracker:FindObjectForCode("t_removeXrayReqs")
  local cStage = trick.CurrentStage

  if not mode or mode == 0 then
    if cStage == 2 then
      return true

    elseif cStage == 1  and not mode then
      if has("xray") then
        return true
      else
        return true, AccessibilityLevel.SequenceBreak
      end

    else
      return has("xray")
    end

  elseif mode == 1 then
    return cStage

  else
    print("xrayReqs exception: invalid mode",mode)
    return false
  end
end

function hasSuit(mode)
  if set("hp_variaonly") then
    return has("varia",mode)
  else
    if not mode then
      return has("varia") or has("gravity") or has("phazon")
    elseif mode == 1 then
      return math.max(has("varia",1),has("gravity",1),has("phazon",1))
    else
      print("hasSuit exception: invalid mode",mode)
    end
  end
end

function canIsg()
  return has("morph") and has("bomb") and has("boost")
end

function canWallcrawl()
  if canBomb() then
    return true
  elseif has("space") then
    return tristate(trick("t_outOfBoundsWithoutMorphBall",1))
  else
    return false
  end
end


-- Recursively checks logic to reach each anchor (in this case, elevators).
-- If access to an anchor is changed or forced on by a user toggle, it will not change again, so it is skipped on the next round
function anchorAccess()
  local anchorsTable = {"temple", "to_north", "to_east", "to_west", "to_southchozo", "to_southmines", "cr_west", "cr_north", "cr_east", "cr_south",
   "mc_north", "mc_west", "mc_east", "mc_southmines", "mc_southphen", "pd_north", "pd_south", "pm_east", "pm_west"}

  local iterations = 0
  local resolved = false

  -- Reset all anchors to avoid anchors "locking" each other on
  for i,code in ipairs(anchorsTable) do
    local anchor = Tracker:FindObjectForCode(code)
    anchor.Active = false
  end

  while not resolved do
    iterations = iterations+1
    resolved = true
    local skipTable = {}

    for i,code in ipairs(anchorsTable) do
      local skip = false
      local anchor = Tracker:FindObjectForCode(code)

      -- If user toggled the anchor, set in logic, else use standard logic
      if has("u_"..code) then
        anchor.Active = true
      else
        anchor.Active = anchorLogic(code)
      end

      -- If accessible, check all logic again and skip entry on future rounds
      if anchor.Active then
        resolved = false
        table.insert(skipTable, 1, i)
      end
    end

    -- Remove accessible anchors from logic checking loop
    if not resolved then
      for i,v in ipairs(skipTable) do
        table.remove(anchorsTable, v)
      end
    end
  end

  print("Anchor logic iterations:", iterations)

  return 0
end

-- Tests anchor logic for non-user-toggle cases
function anchorLogic(code)
  local ponrSet = Tracker:FindObjectForCode("ponr")
  local ponr = ponrSet.CurrentStage

  if     code == "temple" then
    return has("to_north") and has("missile")

  elseif code == "to_north" then
    return not set("elevatorShuffle") and has("cr_west") or
           has("missile") and (
             has("temple") or
             has("to_east") and has("ice") and has("space") and has("morph") or
             has("to_west") or
             has("to_southchozo") and trick("t_greatTreeHallBarsSkip",0) and has("ice") and canBomb() and has("gravity") and has("space") and (thermalReqs(0) or ponr == 2) or
             has("to_southmines") and has("ice") and has("space") and has("gravity") and (thermalReqs(0) or ponr == 2) and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0) and canBoost())
           )

  elseif code == "to_east" then
    return not set("elevatorShuffle") and has("cr_east") or
           trick("t_climbFrigateCrashSite",0) and has("ice") and has("space") and (
             has("to_north") and has("morph") and has("missile") or
             has("to_southchozo") and trick("t_greatTreeHallBarsSkip",0) and canBomb() and has("gravity") and (thermalReqs(0) or ponr == 2) or
             has("to_southmines") and has("gravity") and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0) and canBoost()) and (thermalReqs(0) or ponr == 2)
           )

  elseif code == "to_west" then
    return not set("elevatorShuffle") and has("mc_east") or
           has("to_north") and has("missile")

  elseif code == "to_southchozo" then
    return not set("elevatorShuffle") and has("cr_south") or
           has("ice") and has("space") and (
             has("to_north") and has("missile") and has("gravity") and has("wave") and (canBoost() and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0)) or trick("t_greatTreeHallBarsSkip",0) and canBomb()) and thermalReqs(0) or
             has("to_east") and has("gravity") and has("wave") and (canBoost() and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0)) or trick("t_greatTreeHallBarsSkip",0) and canBomb()) and thermalReqs(0) or
             has("to_southmines") and (canBoost() or trick("t_greatTreeHallBarsSkip",0) and canBomb())
           )

  elseif code == "to_southmines" then
    return not set("elevatorShuffle") and has("pm_east") or
           has("ice") and has("space") and (
             has("to_north") and has("missile") and has("gravity") and has("wave") and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0) and canBomb()) and thermalReqs(0) or
             has("to_east") and has("gravity") and has("wave") and (canBomb() or trick("t_hydroAccessTunnelWithoutGravity",0) and canBoost()) and thermalReqs(0) or
             has("to_southchozo") and trick("t_greatTreeHallBarsSkip",0) and canBomb()
           )

  elseif code == "cr_west" then
    return not set("elevatorShuffle") and has("to_north") or
           has("cr_north") and has("morph") or
           has("cr_east") and has("missile") and canBomb() and has("space") and (has("ice") or canBoost()) or
           has("cr_south") and has("missile") and canBomb() and has("space") and has("ice")

  elseif code == "cr_north" then
    return not set("elevatorShuffle") and has("mc_north") or
           has("cr_west") and has("morph") and (has("missile") or trick("t_mainPlazaItemsOnlySpaceJump",0) and trick("t_vaultAccessFromMainPlaza",0) and set("ledgeDoorEnable") and has("space"))

  elseif code == "cr_east" then
    return not set("elevatorShuffle") and has("to_east") or
           has("missile") and canBomb() and (
             has("cr_west") and (has("space") and ((canSpider() or trick("t_furnaceAccessWithoutSpider",0) and trick("t_hallOfTheEldersBombSlotsWithoutSpider",0)) and (has("boost") and (has("wave") or has("ice") and trick("t_reflectingPoolAccessWithoutWaveBeam",0)) or trick("t_climbReflectingPoolWithoutBoostBall",0) and (has("wave") and (has("ice") or trick("t_crosswayHpbj",0)) or has("ice") and trick("t_reflectingPoolAccessWithoutWaveBeam",0))) or trick("t_iceBeamBeforeFlaahgraOobWallcrawl",0) and trick("t_climbReflectingPoolWithoutBoostBall",0)) or trick("t_iceBeamBeforeFlaahgraOobWallcrawl",0) and has("boost")) or
             has("cr_south") and has("ice") and (canBoost() or trick("t_climbReflectingPoolWithoutBoostBall",0) and has("space"))
           )

  elseif code == "cr_south" then
    return not set("elevatorShuffle") and has("to_southchozo") or
           has("missile") and has("ice") and (
             has("cr_west") and (canBomb() and has("space") and (canBoost() or trick("t_climbReflectingPoolWithoutBoostBall",0)) and (has("wave") or trick("t_reflectingPoolAccessWithoutWaveBeam",0)) and (canSpider() or trick("t_furnaceAccessWithoutSpider",0) and trick("t_hallOfTheEldersBombSlotsWithoutSpider",0)) or trick("t_iceBeamBeforeFlaahgraOobWallcrawl",0) and (has("space") and trick("t_climbReflectingPoolWithoutBoostBall",0) and (canBomb() or has("morph") and trick("t_outOfBoundsWithoutMorphBall",0)) or canBomb() and canBoost())) or
             has("cr_east") and (canBomb() and canBoost() or trick("t_climbReflectingPoolWithoutBoostBall",0) and has("space") and (canBomb() or trick("t_boostThroughBombTunnels",0) and canBoost()))
           )

  elseif code == "mc_north" then
    return not set("elevatorShuffle") and has("cr_north") or
           canBomb() and hasSuit() and (
             has("mc_west") or
             has("mc_east") and (has("grapple") or trick("t_fieryShoresAccessWithoutMorphGrapple",0))
           )

  elseif code == "mc_west" then
    return not set("elevatorShuffle") and has("pd_north") or
           has("mc_north") and canBomb() and hasSuit() or
           has("mc_east") and (
             trick("t_boostThroughBombTunnels",0) and hasSuit() and canBoost() and has("grapple") or
             canBomb() and (hasSuit() and (has("grapple") or trick("t_fieryShoresAccessWithoutMorphGrapple",0)) or not hasSuit() and (trick("t_suitlessMagmoorRun",0) and (has("space") and (Tracker:ProviderCountForCode("etank") >= 5) or (Tracker:ProviderCountForCode("etank") >= 6)) or trick("t_suitlessMagmoorRunMinimal",0) and (has("space") and (Tracker:ProviderCountForCode("etank") >= 3) or (Tracker:ProviderCountForCode("etank") >= 4))))
           )

  elseif code == "mc_east" then
    return not set("elevatorShuffle") and has("to_west") or
           has("mc_north") and hasSuit() and canBomb() or
           has("mc_west") and (
             trick("t_boostThroughBombTunnels",0) and hasSuit() and canBoost() and has("grapple") or
             canBomb() and (hasSuit() or trick("t_suitlessMagmoorRun",0) and (has("space") and (Tracker:ProviderCountForCode("etank") >= 5) or (Tracker:ProviderCountForCode("etank") >= 6)) or trick("t_suitlessMagmoorRunMinimal",0) and (has("space") and (Tracker:ProviderCountForCode("etank") >= 3) or (Tracker:ProviderCountForCode("etank") >= 4)))
           ) or
           has("mc_southmines") and canPb() and has("ice") and has("space") and has("wave") and (hasSuit() and (canSpider() or trick("t_crossTwinFiresTunnelWithoutSpider",0)) or trick("t_crossTwinFiresTunnelSuitless",0) and trick("t_lateMagmoorNoHeatProtection",0) and (Tracker:ProviderCountForCode("etank") >= 2)) or
           has("mc_southphen") and has("wave") and has("space") and (hasSuit() and (canSpider() or trick("t_crossTwinFiresTunnelWithoutSpider",0)) or trick("t_crossTwinFiresTunnelSuitless",0) and trick("t_lateMagmoorNoHeatProtection",0) and (Tracker:ProviderCountForCode("etank") >= 2))

  elseif code == "mc_southmines" then
    return not set("elevatorShuffle") and has("pm_west") or
           canPb() and has("wave") and has("space") and has("ice") and (
             has("mc_east") and (hasSuit() and (canSpider() or trick("t_crossTwinFiresTunnelWithoutSpider",0)) or trick("t_crossTwinFiresTunnelSuitless",0) and (Tracker:ProviderCountForCode("etank") >= 2)) or
             has("mc_southphen") and (hasSuit() or trick("t_lateMagmoorNoHeatProtection",0))
           )

  elseif code == "mc_southphen" then
    return not set("elevatorShuffle") and has("pd_south") or
           has("space") and has("wave") and (
             has("mc_east") and (hasSuit() and (canSpider() or trick("t_crossTwinFiresTunnelWithoutSpider",0)) or trick("t_crossTwinFiresTunnelSuitless",0) and (Tracker:ProviderCountForCode("etank") >= 2)) or
             has("mc_southmines") and canPb() and has("ice") and (hasSuit() or trick("t_lateMagmoorNoHeatProtection",0))
           )

  elseif code == "pd_north" then
    return not set("elevatorShuffle") and has("mc_west") or
           has("pd_south") and thermalReqs(0) and has("wave") and has("space") and (
             -- Through Quarantine Cave
             (has("missile") or has("charge")) and (canSpider() and (canSuper() or has("ice") and (canBomb() or trick("t_climbFrozenPikeWithoutBombs",0)) or ponr == 2) or ponr == 2 and trick("t_exitQuarantineCaveRuinedCourtyardSlopeJump",0) and has("morph")) or
             -- Through labs
             has("ice") and has("missile") and has("scan") and (canBomb() and canBoost() or not ponr ~= 0) and (canSpider() or trick("t_phendranaTransportSouthToTransportAccessWithoutSpider",0) and has("morph"))
           )

  elseif code == "pd_south" then
    return not set("elevatorShuffle") and has("mc_south") or
           has("pd_north") and has("missile") and has("space") and has("wave") and (
             -- Through Quarantine Cave
             thermalReqs(0) and canSuper() and (canBomb() and canSpider() or has("morph") and has("grapple") and (canSpider() or ponr == 2 and (canBoost() and canBomb() or trick("t_climbRuinedCourtyardWithoutBoostSpider",0)))) or
             -- Through labs
             has("scan") and has("ice") and has("morph") and (canBoost() and canBomb() or trick("t_observatoryPuzzleSkip",0) and (canSpider() or trick("t_climbRuinedCourtyardWithoutBoostSpider",0)) and (canBomb() or trick("t_boostThroughBombTunnels",0) and canBoost() or trick("t_climbFrozenPikeWithoutBombs",0)))
           )

  elseif code == "pm_east" then
    return not set("elevatorShuffle") and has("to_southmines") or
           has("pm_west") and has("ice") and has("wave") and has("space") and canPb() and has("grapple") and (canSpider() and canBomb() or trick("t_climbPhazonProcessingCenterWithoutSpider",0) and (ponr == 2 and trick("t_spiderlessShafts",0) and trick("t_climbOreProcessingWithoutGrappleSpider",0) and canBomb() or trick("t_eliteResearchInfiniteBoostClip",0) and canBoost() and (canSpider() or ponr == 2 and trick("t_spiderlessShafts",0) and canBomb())))

  elseif code == "pm_west" then
    return not set("elevatorShuffle") and has("mc_southmines") or
           has("pm_east") and has("ice") and has("wave") and has("space") and canPb() and canBomb() and has("scan") and (canSpider() or ponr == 2 and trick("t_climbOreProcessingWithoutGrappleSpider",0) and trick("t_climbPhazonProcessingCenterWithoutSpider",0)) and (canBoost() or has("grapple") or trick("t_mainQuarryToOreProcessingWithoutGrapple",0))

  end

  return false
end

-- Lookup table for path of no return cases to properly badge softlocks
function ponrLUT(index)
  local basereqs,normalreqs,allponrreqs,visonlyreqs,locref = 0,0,0,0,""

  if index == "alcove" then
    locref = "@Alcove/Space Jump Room (Major)"
    basereqs = has("to_north",1)
    normalreqs = math.min(basereqs, math.max(
      has("space",1),
      trick("t_alcoveNoItems",1)
    ))
    allponrreqs = math.min(basereqs, has("morph",1), has("boost",1), has("bomb",1))

  elseif index == "beetle" then
    locref = "@Ruined Shrine/Beetle Battle (Major)"
    basereqs = math.min(has("cr_west",1), has("missile",1))
    normalreqs = math.min(basereqs, math.max(
      has("morph",1),
      has("space",1),
      math.min(trick("t_ruinedShrineScanDashEscape",1), has("scan",1))
    ))
    visonlyreqs = 2

  elseif index == "burndome" then
    locref = "@Burn Dome/Incinerator Drone (Major)"
    basereqs = math.max(
      math.min(has("cr_west",1), has("missile",1), has("morph",1)), math.min(
        has("cr_south",1), has("ice",1), has("space",1), has("morph",1), has("bomb",1)
      )
    )
    normalreqs = math.min(basereqs, has("bomb",1))
    allponrreqs = basereqs

  elseif index == "antechamber" then
    locref = "@Antechamber/Major Item"
    basereqs = math.min(
      has("missile",1), math.max(math.min(has("morph",1),has("boost",1),has("bomb",1)), math.min(trick("t_climbReflectingPoolWithoutBoostBall",1),has("space",1))),
      math.max(
        math.min(has("cr_south",1), has("ice",1)),
        math.min(has("cr_east",1), has("morph",1), math.max(has("bomb",1), math.min(trick("t_boostThroughBombTunnels",1), has("boost",1)))),
        math.min(has("cr_west",1), has("morph",1),trick("t_iceBeamBeforeFlaahgraOobWallcrawl",1),trick("t_outOfBoundsWithoutMorphBall",1),has("space",1))
      )
    )
    normalreqs = math.min(basereqs, math.max(
      has("ice",1),
      math.min(trick("t_antechamberWithPowerBombs",1),has("morph",1),(has("pb",1)))
    ))
    visonlyreqs = basereqs

  elseif index == "shoretunnel" then
    locref = "@Shore Tunnel/Break the Glass (Major)"
    basereqs = math.min(
      hasSuit(1), has("morph",1), has("pb",1), math.max(
        math.min(has("mc_north",1),has("bomb",1)),
        math.min(has("mc_west",1),math.max(has("bomb",1),math.min(trick("t_boostThroughBombTunnels",1),has("boost",1)))),
        math.min(has("mc_east",1),math.max(has("grapple",1),math.min(trick("t_fieryShoresAccessWithoutMorphGrapple",1),has("bomb",1))))
      )
    )
    normalreqs = math.min(basereqs, has("space",1))
    visonlyreqs = basereqs

  elseif index == "warshrine" then
    locref = "@Fiery Shores/Warrior Shrine Tunnel (Minor)"
    basereqs = math.min(
      hasSuit(1),has("morph",1),has("pb",1),math.max(trick("t_warriorShrineMinimumReqs",1),math.min(has("space",1),math.max(has("boost",1),trick("t_warriorShrineWithoutBoost",1)))),
      math.max(
        math.min(has("mc_north",1),has("bomb",1)),
        math.min(has("mc_west",1),math.max(has("bomb",1),math.min(trick("t_boostThroughBombTunnels",1),has("boost",1)))),
        math.min(has("mc_east",1),math.max(has("grapple",1),math.min(trick("t_fieryShoresAccessWithoutMorphGrapple",1),has("bomb",1))))
      )
    )
    normalreqs = math.min(basereqs, has("bomb",1))
    allponrreqs = basereqs

  elseif index == "plasmaproc" then
    locref = "@Plasma Processing/Plasma Beam (Major)"
    basereqs = math.min(
      has("space",1), has("wave",1), has("morph",1), has("bomb",1), has("boost",1), has("ice",1), math.max(math.min(has("grapple",1), has("spider",1)), trick("t_plasmaProcessingItemWithoutGrappleSpider",1)), math.max(
        math.min(has("mc_east",1), math.max(
          math.min(hasSuit(1), math.max(has("spider",1), trick("t_crossTwinFiresTunnelWithoutSpider",1))),
          math.min(trick("t_crossTwinFiresTunnelSuitless",1), etanks(2))
        )),
        math.min(has("mc_southmines",1), has("pbs",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1))),
        math.min(has("mc_southphen",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1)))
      )
    )
    local oobreqs = math.min(
      trick("t_plasmaProcessingFromMagmoorWorkstationOob",1), has("ice",1), math.max(math.min(has("morph",1), has("bomb",1)), math.min(trick("t_outOfBoundsWithoutMorphBall",1), has("space",1))), math.max(
        math.min(has("mc_east",1), has("wave",1), has("space",1), math.max(
          math.min(hasSuit(1), math.max(has("spider",1), trick("t_crossTwinFiresTunnelWithoutSpider",1))),
          math.min(trick("t_crossTwinFiresTunnelSuitless",1), etanks(2))
        )),
        math.min(has("mc_southmines",1), has("pbs",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1))),
        math.min(has("mc_southphen",1), has("wave",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1)))
      )
    )
    normalreqs = math.min(has("plasma",1), math.max(
      basereqs,
      math.min(oobreqs, has("space"))
    ))
    visonlyreqs = math.max(
      basereqs,
      math.min(oobreqs, has("space"))
    )
    allponrreqs = oobreqs

  elseif index == "magmoorwork" then
    locref = "@Magmoor Workstation/Major Item"
    basereqs = math.min(
      thermalReqs(1), has("wave",1), has("scan",1), has("morph",1), math.max(has("bomb",1), has("space")), math.max(
        math.min(has("mc_east",1), has("space",1), math.max(
          math.min(hasSuit(1), math.max(has("spider",1), trick("t_crossTwinFiresTunnelWithoutSpider",1))),
          math.min(trick("t_crossTwinFiresTunnelSuitless",1), etanks(2))
        )),
        math.min(has("mc_southmines",1), has("ice",1), has("pbs",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1))),
        math.min(has("mc_southphen",1), math.max(hasSuit(1), trick("t_lateMagmoorNoHeatProtection",1)))
      )
    )
    normalreqs = math.min(basereqs, has("space",1))
    allponrreqs = basereqs

  else
    print("ponrLUT exception: invalid index",index)
    return false
  end

  -- Clear current badge
  badgeHandler(locref)

  -- Normal case satisfied, can return
  if normalreqs == 2 then
    return true

  -- Check PONR cases
  else
    local setting = Tracker:FindObjectForCode("ponr")

    -- Set to Visible Only
    if setting.CurrentStage == 1 then
      if normalreqs >= visonlyreqs then
        return tristate(normalreqs)
      else
        if visonlyreqs >= 1 then
          badgeHandler(locref,"images/warning_vis.png")
        end
        return tristate(visonlyreqs)
      end

    -- Set to Any
    elseif setting.CurrentStage == 2 then
      if normalreqs >= visonlyreqs and normalreqs >= allponrreqs then
        return tristate(normalreqs)
      else
        if visonlyreqs >= allponrreqs then
          if visonlyreqs >= 1 then
            badgeHandler(locref,"images/warning_vis.png")
          end
          return tristate(visonlyreqs)
        else
          if allponrreqs >= 1 then
            badgeHandler(locref,"images/warning.png")
          end
          return tristate(allponrreqs)
        end
      end

    -- No cases satisfied, inaccessible
    else
      return false
    end
  end
end