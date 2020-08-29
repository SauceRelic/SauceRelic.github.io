-- basic functions
function hasItem(item)
  if Tracker:ProviderCountForCode(item) >= 1 then
    return true
  else
    return false
  end
end

function missing(item)
  return not hasItem(item)
end

function disabled(item,sb)
  if not sb then
    return missing(item)
  else
    if missing(item) then
     return true
    else
      return missing(sb), AccessibilityLevel.SequenceBreak
    end
  end
end

-- Evaluates a boolean statement consisting of only or operators between terms
function orN(...)
  for i,v in ipairs({...}) do
    if hasItem(v) then
      return true
    end
  end
  return false
end


-- Evaluates a boolean statement with structure:
-- (hasItem(x) and ... and hasItem(z)) or (...) or ...
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
        statementPart = hasItem(v)
      end

    end
  end

  return statementPart
end


-- item combo requirements
function canBomb()
  return hasItem(morph) and hasItem(bomb)
end

function canPb()
  return hasItem(morph) and hasItem(powerbomb)
end

function canBombOrPb()
  return hasItem(morph) and (hasItem(bomb) or hasItem(powerbomb))
end

function canBoost()
  return hasItem(morph) and hasItem(boost)
end

function canSpider()
  return hasItem(morph) and hasItem(spider)
end

function canSuper()
  return hasItem(missile) and hasItem(charge) and hasItem(super)
end

function thermalReqs()
  return hasItem(thermal) or hasItem(t_removeThermalReqs)
end

function xrayReqs()
  return hasItem(xray) or hasItem(t_removeXrayReqs)
end

function hasItemSuit()
  if hasItem(hp_variaonly) then
    return hasItem(varia)
  else
    return hasItem(varia) or hasItem(gravity) or hasItem(phazon)
  end
end

function canIsg()
  return hasItem(morph) and hasItem(bomb) and hasItem(boost)
end

function canWallcrawl()
  return (canBomb() or hasItem(t_outOfBoundsWithoutMorphBall)) and hasItem(space)
end
