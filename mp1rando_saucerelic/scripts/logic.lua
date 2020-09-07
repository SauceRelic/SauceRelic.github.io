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
    return (not set("elevatorShuffle") and has("cr_west")) or has("missile") and (
            has("temple") or
            has("to_east") and has("ice") and has("space") and has("morph") or
            has("to_west") or

            )

  elseif code == "to_east" then


  elseif code == "to_west" then


  elseif code == "to_southchozo" then


  elseif code == "to_southmines" then


  elseif code == "cr_west" then


  elseif code == "cr_north" then


  elseif code == "cr_east" then


  elseif code == "cr_south" then


  elseif code == "mc_north" then


  elseif code == "mc_west" then


  elseif code == "mc_east" then


  elseif code == "mc_southmines" then


  elseif code == "mc_southphen" then


  elseif code == "pd_north" then


  elseif code == "pd_south" then


  elseif code == "pm_east" then


  elseif code == "pm_west" then

    
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
