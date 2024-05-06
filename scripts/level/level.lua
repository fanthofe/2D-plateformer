local Level = {}
local tileTexture = {}

function Level.loadLevel(nbLevel)
    -- Importer la map depuis un fichier txt
    -- local filename = "levels/level"..tostring(nbLevel)..".txt"
    -- for line in love.filesystem.lines(filename) do
    --     map[#map + 1] = line
    -- end

    -- Importer la map depuis un fichier lua
    map1 = tiledMap.layers[1].data
    local nbCol = love.graphics.getWidth() / TILE_WIDTH

    for i = 1, #map1 do
        local row = math.floor((i - 1) / nbCol) + 1
        local col = (i - 1) % nbCol + 1

        if map[row] == nil then
            map[row] = {}
        end

        map[row][col] = map1[i]
    end
    
    -- Charger les tuiles du tileset
    local nbColumns = tileset:getWidth() / TILE_WIDTH
    local nbLines = tileset:getHeight() / TILE_HEIGHT
    tileTexture[0] = nil

    local l,c
    local i = 1
    for l=1, nbLines do
        for c=1, nbColumns do 
        tileTexture[i] = love.graphics.newQuad(
            (c-1) * TILE_WIDTH,
            (l-1) * TILE_HEIGHT,
            TILE_WIDTH,
            TILE_HEIGHT,
            tileset:getWidth(),
            tileset:getHeight()
            )
        i = i + 1
        end
    end
end

function Level.drawMap()

    for l=1,#map do
        for c=1,#map[1] do
            local id = map[l][c]
            local texture = tileTexture[id]
            if texture ~= nil then
                love.graphics.draw(tileset, texture, (c-1) * TILE_WIDTH, (l-1) * TILE_HEIGHT)
            end
        end
    end
end

return Level