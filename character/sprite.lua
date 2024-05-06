local sprite = {}
sprite.collision = require('../collision')

-- local x = 11
-- local y = 1

function sprite.createSprite(pType, pX, pY)
    local mySprite = {}
    
    mySprite.x = pX
    mySprite.y = pY
    mySprite.vx = 0
    mySprite.vy = 0
    mySprite.gravity = 0
    mySprite.isJumping = false
    mySprite.type = pType
    mySprite.frame = 0
    mySprite.standing = false
    mySprite.bJumpReady = false
    mySprite.collisionRelease = false
    mySprite.flip = false
    
    mySprite.currentAnimation = ""
    mySprite.frame = 0
    mySprite.animationSpeed = 1/8
    mySprite.animationTimer = mySprite.animationSpeed
    mySprite.animations = {}
    mySprite.images = {}
    
    mySprite.AddImages = function(psDir, plstImage)
      for k,v in pairs(plstImage) do
        local fileName = psDir.."/"..v..".png"
        mySprite.images[v] = love.graphics.newImage(fileName)
      end
    end
    
    mySprite.AddAnimation = function(psDir, psName, plstImages)
      mySprite.AddImages(psDir, plstImages)
      mySprite.animations[psName] = plstImages
    end
    
    mySprite.PlayAnimation = function(psName)
      if mySprite.currentAnimation ~= psName then
        mySprite.currentAnimation = psName
        mySprite.frame = 1
      end
    end
    
    table.insert(heroSprites, mySprite)
    
    return mySprite
  end

  function sprite.updatePlayer(pPlayer, dt)
    -- Locals for Physics
    local accel = 500
    local friction = 300
    local maxSpeed = 150
    local jumpVelocity = -280
    local newAnimation = "idle"
  
    -- Friction
    if pPlayer.vx > 0 then
      pPlayer.vx = pPlayer.vx - friction * dt
      if pPlayer.vx < 0 then pPlayer.vx = 0 end
    end
    if pPlayer.vx < 0 then
      pPlayer.vx = pPlayer.vx + friction * dt
      if pPlayer.vx > 0 then pPlayer.vx = 0 end
    end

    -- Keyboard
    if love.keyboard.isDown('right') then
      pPlayer.vx = pPlayer.vx + accel * dt
      if pPlayer.vx > maxSpeed then pPlayer.vx = maxSpeed end
      pPlayer.flip = false
      newAnimation = "run"
    end
    if love.keyboard.isDown('left') then
      pPlayer.vx = pPlayer.vx - accel * dt
      if pPlayer.vx < -maxSpeed then pPlayer.vx = -maxSpeed end
      pPlayer.flip = true
      newAnimation = "run"
    end
    if love.keyboard.isDown('up') and pPlayer.standing and pPlayer.bJumpReady then
      pPlayer.vy = jumpVelocity
      pPlayer.standing = false
      pPlayer.bJumpReady = false
    end
    if love.keyboard.isDown('up') == false and pPlayer.bJumpReady == false then
      pPlayer.bJumpReady = true
    end
    if love.keyboard.isDown('down') and pPlayer.collisionRelease and pPlayer.standing then
      pPlayer.collisionRelease = false
    end

    -- Ajuster la position du personnage en fonction de x et y
    -- if love.keyboard.isDown('a') then 
    --   x = x + 1
    -- end
    -- if love.keyboard.isDown('z') then 
    --   x = x - 1
    -- end
    -- if love.keyboard.isDown('q') then 
    --   y = y + 1
    -- end
    -- if love.keyboard.isDown('s') then 
    --   y = y - 1
    -- end

    pPlayer.PlayAnimation(newAnimation)

    -- Move
    pPlayer.x = pPlayer.x + pPlayer.vx * dt
    pPlayer.y = pPlayer.y + pPlayer.vy * dt
  end
  
  function alignOnLine(pSprite)
    local lig = math.floor((pSprite.y + TILE_HEIGHT / 2) / TILE_HEIGHT) + 1
    pSprite.y = (lig - 1) * TILE_HEIGHT
  end

  function alignOnColumn(pSprite)
    local lig = math.floor((pSprite.x + TILE_WIDTH / 2) / TILE_WIDTH) + 1
    pSprite.x = (lig - 1) * TILE_WIDTH
  end

  function sprite.updateSprite(pSprite, dt)
    -- Locals for Collisions
    local oldX = pSprite.x
    local oldY = pSprite.y
    
    -- Specific behavior for the player
    if pSprite.type == "player" then
      sprite.updatePlayer(pSprite, dt)
    end

    -- Collision detection
    local collide = false

    -- On the right
    if pSprite.vx > 0 then
      collide = sprite.collision.collideRight(pSprite)
    end
    
    -- On the left
    if pSprite.vx < 0 then
      collide = sprite.collision.collideLeft(pSprite)
    end
    
    -- Stop!
    if collide then
      pSprite.vx = 0
      alignOnColumn(pSprite)
    end

    collide = false

    -- Above
    if pSprite.vy < 0 then
      collide = sprite.collision.collideAbove(pSprite)
      if collide then
        pSprite.vy = 0
        alignOnLine(pSprite)
      end
    end

    collide = false

    -- Below
    if pSprite.standing or pSprite.vy > 0 then
      collide = sprite.collision.collideBelow(pSprite)
      if collide then
        pSprite.collisionRelease = true
        pSprite.standing = true
        pSprite.vy = 0
        alignOnLine(pSprite)
      else
        pSprite.standing = false
      end
    end
    
    -- Sprite falling
    if pSprite.standing == false then
      pSprite.vy = pSprite.vy + pSprite.gravity * dt
    end

    -- Animation
    if pSprite.currentAnimation ~= "" then
      pSprite.animationTimer = pSprite.animationTimer - dt
      if pSprite.animationTimer <= 0 then
        pSprite.frame = pSprite.frame + 1
        pSprite.animationTimer = pSprite.animationSpeed
        if pSprite.frame > #pSprite.animations[pSprite.currentAnimation] then
          pSprite.frame = 1
        end
      end
    end

  end

  function sprite.drawSprite(pSprite)
    local imgName = pSprite.animations[pSprite.currentAnimation][pSprite.frame]
    local img = pSprite.images[imgName]
    local halfw = img:getWidth() / 2
    local halfh = img:getHeight() / 2
    local flipCoef = 1
    local scale = 1

    if pSprite.flip then flipCoef = -1 end
    love.graphics.draw(
      img, -- Image
      pSprite.x + halfw + 2, -- horizontal position
      pSprite.y + halfh, -- vertical position
      0, -- rotation (none = 0)
      scale * flipCoef, -- horizontal scale
      scale,
      halfw, -- vertical scale (normal size = 1)
      halfh -- horizontal and vertical offset
    )

  end
  
  return sprite