-- Basic Functions

-- Shortcut for checking item ownership
function has(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

-- Alias for has(), denotes randomizer settings
function set(item)
  return has(item)
end

function anchorAccess()
  local anchorsTable = {"temple", "to_north", "to_east", "to_west", "to_southchozo", "to_southmines", "cr_west", "cr_north", "cr_east", "cr_south",
   "mc_north", "mc_west", "mc_east", "mc_southmines", "mc_southphen", "pd_north", "pd_south", "pm_east", "pm_west"}

  local resolved = false
  
  while not resolved do
    resolved = true
    local skipTable = {}

    for i,code in ipairs(anchorsTable) do
      local skip = false
      local iState = has(code)
      local anchor = Tracker:FindObjectForCode(code)
      
      -- If user toggled the anchor, set in logic, else use standard logic
      if has("u_"..code) then
        anchor.Active = true
        skip = true
      else
        anchor.Active = anchorLogic(code)
      end

      -- If accessibility changed, check all logic again and skip changed entry on future rounds
      if iState ~= has(code) then
        resolved = false
        table.insert(skipTable, 1, i)
      end
      
      -- Skip on future rounds if forced in logic by user toggle
      if skip then
        table.insert(skipTable, 1, i)
      end
    end

    -- Remove forced/changed anchors from logic checking loop
    if not resolved then
      for i,v in ipairs(skipTable) do
        table.remove(anchorsTable, v)
      end
    end
  end
end

-- Tests anchor logic for non-user-toggle cases
function anchorLogic(code)
  if     code == "temple" then
    return has("to_north") and has("missile")

  elseif code == "to_north" then
    return not set("elevatorShuffle") and has("cr_west") or
           has("missile") and (
             has("temple") or
             has("to_east") and has("ice") and has("space") and has("morph") or
             has("to_west") or
             has("to_southchozo") and set("t_greatTreeHallBarsSkip") and has("ice") and canBomb() and has("gravity") and has("space") and (thermalReqs() or set("ponr_allowall")) or
             has("to_southmines") and has("ice") and has("space") and has("gravity") and (thermalReqs() or set("ponr_allowall")) and (canBomb() or set("t_hydroAccessTunnelWithoutGravity") and canBoost())
           )

  elseif code == "to_east" then
    return not set("elevatorShuffle") and has("cr_east") or
           set("t_climbFrigateCrashSite") and has("ice") and has("space") and (
             has("to_north") and has("morph") and has("missile") or
             has("to_southchozo") and set("t_greatTreeHallBarsSkip") and canBomb() and has("gravity") and (thermalReqs() or set("ponr_allowall")) or
             has("to_southmines") and has("gravity") and (canBomb() or set("t_hydroAccessTunnelWithoutGravity") and canBoost()) and (thermalReqs() or set("ponr_allowall"))
           )
           
  elseif code == "to_west" then
    return not set("elevatorShuffle") and has("mc_east") or
           has("to_north") and has("missile")

  elseif code == "to_southchozo" then
    return not set("elevatorShuffle") and has("cr_south") or
           has("ice") and has("space") and (
             has("to_north") and has("missile") and has("gravity") and has("wave") and (canBoost() and (canBomb() or set("t_hydroAccessTunnelWithoutGravity")) or set("t_greatTreeHallBarsSkip") and canBomb()) and thermalReqs() or
             has("to_east") and has("gravity") and has("wave") and (canBoost() and (canBomb() or set("t_hydroAccessTunnelWithoutGravity")) or set("t_greatTreeHallBarsSkip") and canBomb()) and thermalReqs() or
             has("to_southmines") and (canBoost() or set("t_greatTreeHallBarsSkip") and canBomb())
           )

  elseif code == "to_southmines" then
    return not set("elevatorShuffle") and has("pm_east") or
           has("ice") and has("space") and (
             has("to_north") and has("missile") and has("gravity") and has("wave") and (canBomb() or set("t_hydroAccessTunnelWithoutGravity") and canBomb()) and thermalReqs() or
             has("to_east") and has("gravity") and has("wave") and (canBomb() or set("t_hydroAccessTunnelWithoutGravity") and canBoost()) and thermalReqs() or
             has("to_southchozo") and set("t_greatTreeHallBarsSkip") and canBomb()
           )

  elseif code == "cr_west" then
    return not set("elevatorShuffle") and has("to_north") or
           has("cr_north") and has("morph") or
           has("cr_east") and has("missile") and canBomb() and has("space") and (has("ice") or canBoost()) or
           has("cr_south") and has("missile") and canBomb() and has("space") and has("ice")

  elseif code == "cr_north" then
    return not set("elevatorShuffle") and has("mc_north") or
           has("cr_west") and has("missile") and has("morph")

  elseif code == "cr_east" then
    return not set("elevatorShuffle") and has("to_east") or
           has("missile") and canBomb() and (
             has("cr_west") and has("space") and (canSpider() or set("t_furnaceAccessWithoutSpider") and set("t_hallOfTheEldersBombSlotsWithoutSpider")) and (has("wave") and (canBoost() or set("t_climbReflectingPoolWithoutBoostBall") and (has("ice") or set("t_crosswayHpbj"))) or set("t_reflectingPoolAccessWithoutWaveBeam") and has("ice") and (canBoost() or set("t_climbReflectingPoolWithoutBoostBall"))) or
             has("cr_south") and has("ice") and (canBoost() or set("t_climbReflectingPoolWithoutBoostBall") and has("space"))
           )

  elseif code == "cr_south" then
    return not set("elevatorShuffle") and has("to_southchozo") or
           has("missile") and has("ice") and (
             has("cr_west") and canBomb() and has("space") and (canBoost() or set("t_climbReflectingPoolWithoutBoostBall")) and (has("wave") or set("t_reflectingPoolAccessWithoutWaveBeam")) and (canSpider() or set("t_furnaceAccessWithoutSpider") and set("t_hallOfTheEldersBombSlotsWithoutSpider")) or
             has("cr_east") and (canBomb() and canBoost() or set("t_climbReflectingPoolWithoutBoostBall") and has("space") and (canBomb() or set("t_boostThroughBombTunnels") and canBoost()))
           )

  elseif code == "mc_north" then
    return not set("elevatorShuffle") and has("cr_north") or
           canBomb() and hasSuit() and (
             has("mc_west") or
             has("mc_east") and (has("grapple") or set("t_fieryShoresAccessWithoutMorphGrapple"))
           )

  elseif code == "mc_west" then
    return not set("elevatorShuffle") and has("pd_north") or
           has("mc_north") and canBomb() and hasSuit() or
           has("mc_east") and (
             set("t_boostThroughBombTunnels") and hasSuit() and canBoost() and has("grapple") or
             canBomb() and (hasSuit() and (has("grapple") or set("t_fieryShoresAccessWithoutMorphGrapple")) or not hasSuit() and (set("t_suitlessMagmoorRun") and (has("space") and (Tracker:ProviderCountForCode("etank") >= 5) or (Tracker:ProviderCountForCode("etank") >= 6)) or set("t_suitlessMagmoorRunMinimal") and (has("space") and (Tracker:ProviderCountForCode("etank") >= 3) or (Tracker:ProviderCountForCode("etank") >= 4))))
           )

  elseif code == "mc_east" then
    return not set("elevatorShuffle") and has("to_west") or
           has("mc_north") and hasSuit() and canBomb() or
           has("mc_west") and (
             set("t_boostThroughBombTunnels") and hasSuit() and canBoost() and has("grapple") or
             canBomb() and (hasSuit() or set("t_suitlessMagmoorRun") and (has("space") and (Tracker:ProviderCountForCode("etank") >= 5) or (Tracker:ProviderCountForCode("etank") >= 6)) or set("t_suitlessMagmoorRunMinimal") and (has("space") and (Tracker:ProviderCountForCode("etank") >= 3) or (Tracker:ProviderCountForCode("etank") >= 4)))
           ) or
           has("mc_southmines") and canPb() and has("ice") and has("space") and has("wave") and (hasSuit() and (canSpider() or set("t_crossTwinFiresTunnelWithoutSpider")) or set("t_crossTwinFiresTunnelSuitless") and (Tracker:ProviderCountForCode("etank") >= 2)) or
           has("mc_southphen") and has("wave") and has("space") and (hasSuit() and (canSpider() or set("t_crossTwinFiresTunnelWithoutSpider")) or set("t_crossTwinFiresTunnelSuitless") and (Tracker:ProviderCountForCode("etank") >= 2))

  elseif code == "mc_southmines" then
    return not set("elevatorShuffle") and has("pm_west") or
           canPb() and has("wave") and has("space") and has("ice") and (
             has("mc_east") and (hasSuit() and (canSpider() or set("t_crossTwinFiresTunnelWithoutSpider")) or set("t_crossTwinFiresTunnelSuitless") and (Tracker:ProviderCountForCode("etank") >= 2)) or
             has("mc_southphen")
           )

  elseif code == "mc_southphen" then
    return not set("elevatorShuffle") and has("pd_south") or
           has("space") and has("wave") and (
             has("mc_east") and (hasSuit() and (canSpider() or set("t_crossTwinFiresTunnelWithoutSpider")) or set("t_crossTwinFiresTunnelSuitless") and (Tracker:ProviderCountForCode("etank") >= 2)) or
             has("mc_southmines") and canPb() and has("ice")
           )

  elseif code == "pd_north" then
    return not set("elevatorShuffle") and has("mc_west") or
           has("pd_south") and thermalReqs() and has("wave") and has("space") and (
             -- Through Quarantine Cave
             (has("missile") or has("charge")) and (canSpider() and (canSuper() or has("ice") and (canBomb() or set("t_climbFrozenPikeWithoutBombs")) or set("ponr_allowall")) or set("ponr_allowall") and set("t_exitQuarantineCaveRuinedCourtyardSlopeJump") and has("morph")) or
             -- Through labs
             has("ice") and has("missile") and has("scan") and (canBomb() and canBoost() or not set("ponr_disabled")) and (canSpider() or set("t_phendranaTransportSouthToTransportAccessWithoutSpider") and has("morph"))
           )

  elseif code == "pd_south" then
    return not set("elevatorShuffle") and has("mc_south") or
           has("pd_north") and has("missile") and has("space") and has("wave") and (
             -- Through Quarantine Cave
             thermalReqs() and canSuper() and (canBomb() and canSpider() or has("morph") and has("grapple") and (canSpider() or set("ponr_allowall") and (canBoost() and canBomb() or set("t_climbRuinedCourtyardWithoutBoostSpider")))) or
             -- Through labs
             has("scan") and has("ice") and has("morph") and (canBoost() and canBomb() or set("t_observatoryPuzzleSkip") and (canSpider() or set("t_climbRuinedCourtyardWithoutBoostSpider")) and (canBomb() or set("t_boostThroughBombTunnels") and canBoost() or set("t_climbFrozenPikeWithoutBombs")))
           )

  elseif code == "pm_east" then
    return not set("elevatorShuffle") and has("to_southmines") or
           has("pm_west") and has("ice") and has("wave") and has("space") and canPb() and has("grapple") and (canSpider() and canBomb() or set("t_climbPhazonProcessingCenterWithoutSpider") and (set("ponr_allowall") and set("t_spiderlessShafts") and set("t_climbOreProcessingWithoutGrappleSpider") and canBomb() or set("t_eliteResearchInfiniteBoostClip") and canBoost() and (canSpider() or set("ponr_allowall") and set("t_spiderlessShafts") and canBomb())))

  elseif code == "pm_west" then
    return not set("elevatorShuffle") and has("mc_southmines") or
           has("pm_east") and has("ice") and has("wave") and has("space") and canPb() and canBomb() and has("scan") and (canSpider() or set("ponr_allowall") and set("t_climbOreProcessingWithoutGrappleSpider") and set("t_climbPhazonProcessingCenterWithoutSpider")) and (canBoost() or has("grapple") or set("t_mainQuarryToOreProcessingWithoutGrapple"))
    
  end

  return false
end

  
-- Inverse has(), used only for access rules defined in json
function missing(item)
  return not has(item)
end

-- Deprecated
--[[function disabled(item,sb)
  if not sb then
    return missing(item)
  else
    if missing(item) then
     return true
    else
      return missing(sb), AccessibilityLevel.SequenceBreak
    end
  end
end--]]

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
  local statementPart = true

  for i,v in ipairs({...}) do

    if v == "or" then
      if statementPart then
        return true
      else
        statementPart = true
      end

    else
      if statementPart then
        statementPart = has(v)
      end

    end
  end

  return statementPart
end


-- Item combo shortcuts
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

function thermalReqs()
  return has("thermal") or has("t_removeThermalReqs")
end

function xrayReqs()
  return has("xray") or has("t_removeXrayReqs")
end

function hasSuit()
  if has("hp_variaonly") then
    return has("varia")
  else
    return has("varia") or has("gravity") or has("phazon")
  end
end

function canIsg()
  return has("morph") and has("bomb") and has("boost")
end

function canWallcrawl()
  return (canBomb() or has("t_outOfBoundsWithoutMorphBall")) and has("space")
end
