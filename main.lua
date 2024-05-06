-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

--Chargement des fichiers associés
local _level = require('scripts/level/level')
local _collision = require('collision')
local _sprite = require('character/sprite')

-- Chargement des utils
map = {} -- Map
imgTiles = {} -- Tileset
tiledMap = require('levels/map-level-1')
tileset = love.graphics.newImage("/images/tileset.png")
heroSprites = {}
TILE_WIDTH = 16
TILE_HEIGHT = 16

function initMap(imgTiles)
  imgTiles["1"] = love.graphics.newImage("images/tile1.png")
  imgTiles["2"] = love.graphics.newImage("images/tile2.png") 
  imgTiles["4"] = love.graphics.newImage("images/tile4.png") 
  imgTiles["5"] = love.graphics.newImage("images/tile5.png") 
end

function initGame(nbLevel)
  _level.loadLevel(nbLevel)
  initMap(imgTiles)
  -- Localisation du personnage en début de jeu
  level = {}
  level.playerStart = {}
  level.playerStart.col = 20
  level.playerStart.line = 3


  local player = _sprite.createSprite( 
    "player",
    (level.playerStart.col - 1) * TILE_WIDTH,
    (level.playerStart.line - 1) * TILE_HEIGHT
  )
  
  player.AddAnimation("images/player", "idle",
  { "idle1", "idle2", "idle3", "idle4" })
  player.AddAnimation("images/player", "run",
  { "run1", "run2", "run3", "run4", "run5",
  "run6", "run7", "run8", "run9", "run10" })
  -- player.AddAnimation("images/player", "climb",
  -- { "climb1", "climb2" })
  -- player.AddAnimation("images/player", "climb_idle", { "climb1" })
  player.PlayAnimation("idle")
  
  player.gravity = 500
  player.bJumpReady = true
  player.collisionRelease = true
end

function love.load()
  --Titre du jeu
  love.window.setTitle("2D platformer")

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
--  print("Screen size is "..width..","..height)

 initGame(0)
 
end

function love.update(dt)

  for nSprite = #heroSprites,1,-1 do
    local sprite = heroSprites[nSprite]
    _sprite.updateSprite(sprite, dt)
  end
end

function love.draw()
  -- love.graphics.scale(2,2)

  -- Affiche la map
  _level.drawMap()

  -- Affiche le personnage
  for nSprite = #heroSprites, 1, -1 do
    local drawSprite = heroSprites[nSprite]
    _sprite.drawSprite(drawSprite)
  end
  
  -- size = heroSprites[1].images['idle1']:getHeight()
  -- scaleAjuste = 0
  -- love.graphics.setColor( 0,1,0 )
  -- love.graphics.rectangle('fill', heroSprites[1].x, heroSprites[1].y, 4,4)
  -- love.graphics.rectangle('fill', size + heroSprites[1].x, heroSprites[1].y , 4,4)
  -- love.graphics.rectangle('fill', heroSprites[1].x, size + heroSprites[1].y + scaleAjuste, 4,4)
  -- love.graphics.rectangle('fill', size + heroSprites[1].x, size + heroSprites[1].y + scaleAjuste, 4,4)
  -- love.graphics.setColor( 1,1,1 )

end

function love.keypressed(key)
 
--  print(key)
 
end
 
