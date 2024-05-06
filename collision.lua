local collision = {}

function collision.countNbLevelFiles()
  local dir = "levels"

  local fileCount = 0
  for _, file in ipairs(love.filesystem.getDirectoryItems(dir)) do
      if love.filesystem.getInfo(dir .. "/" .. file, "file") then
          fileCount = fileCount + 1
      end
  end

  return fileCount
end

function collision.getTileAt(pX, pY)
  local col = math.floor(pX / TILE_WIDTH) + 1
  local lig = math.floor(pY / TILE_HEIGHT) + 1
  if col > 0 and col <= #map[1] and lig > 0 and lig <= #map then
    local id = map[lig][col]
    return tostring(id)
  end
  return 0
end

function collision.isSolid(pID)
  if pID == "0" then return false end
  if pID >= "1" and pID ~= "9" and pID ~= "14" and pID ~= "15" then return true end
end

function collision.isJumpThrough(pID)
  if pID == "9" then return true else return false end
  return false
end

function collision.isLadder(pID)
  if pID == "14" or pID == "15" then return true end 
  return false
end

function collision.collideRight(pSprite)
  local id1 = collision.getTileAt(pSprite.x + TILE_WIDTH, pSprite.y + 3)
  local id2 = collision.getTileAt(pSprite.x + TILE_WIDTH, pSprite.y + 10)
  if collision.isSolid(id1) or collision.isSolid(id2) then return true end
  return false
end

function collision.collideLeft(pSprite)
  local id1 = collision.getTileAt(pSprite.x - 1, pSprite.y + 3)
  local id2 = collision.getTileAt(pSprite.x - 1, pSprite.y + 10)
  if collision.isSolid(id1) or collision.isSolid(id2) then return true end
  return false
end

function collision.collideBelow(pSprite)
  -- local scaleAjust = 16
  local id1 = collision.getTileAt(pSprite.x + 1, pSprite.y + TILE_HEIGHT)
  local id2 = collision.getTileAt(pSprite.x + 14, pSprite.y + TILE_HEIGHT)

  -- if (collision.isJumpThrough(id1) or collision.isJumpThrough(id2)) and pSprite.collisionRelease then
  --   local lig = math.floor((pSprite.y + (TILE_HEIGHT / 2)) / TILE_HEIGHT) + 1
  --   local yLine = (lig - 1) * TILE_HEIGHT
  --   local distance = pSprite.y - yLine

  --   if distance >= 0 and distance < 10 then
  --     return true
  --   end
  -- end

  if collision.isSolid(id1) or collision.isSolid(id2) then return true end
  return false
end

function collision.collideAbove(pSprite)
  local id1 = collision.getTileAt(pSprite.x + 1, pSprite.y - 2)
  local id2 = collision.getTileAt(pSprite.x + 14, pSprite.y - 2)
  
  if collision.isSolid(id1) or collision.isSolid(id2) then return true end
  return false
end

return collision