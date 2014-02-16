require('class')

Map = class:new()

print("Map")
print(Map)

function Map:init(mapTileWidth, mapTileHeight)
  self.mapTileWidth = mapTileWidth
  self.mapTileHeight = mapTileHeight
  self.tileWidth = 32
  self.tileHeight = 32

  self.map = {}
  for x = 1, self.mapTileWidth do
    self.map[x] = {}
    for y = 1, self.mapTileHeight do
      self.map[x][y] = math.random(0, 3)
    end
  end
  self.map[2][2] = 5

  self.tileQuads = {}

  -- number of tiles to display
  self.screenWidth, self.screenHeight = love.window.getDimensions()
  self.viewTileWidth = math.floor(self.screenWidth / self.tileWidth) + 2
  self.viewTileHeight = math.floor(self.screenHeight / self.tileHeight) + 2

  -- viewport
  self.viewTileX = 1
  self.viewTileY = 1
  self.zoomX = 1
  self.zoomY = 1
end

function Map:setupTileset(filename)
  tilesetImage = love.graphics.newImage(filename)
  tilesetImage:setFilter("nearest", "linear")

  function getQuadAt(tileX, tileY)
    return love.graphics.newQuad(tileX * self.tileWidth, tileY * self.tileHeight,
                                 self.tileWidth, self.tileHeight,
                                 tilesetImage:getWidth(), tilesetImage:getHeight())
  end

  self.tileQuads[0] = getQuadAt(5, 17) -- grass1
  self.tileQuads[2] = getQuadAt(5, 18) -- grass2
  self.tileQuads[1] = getQuadAt(5, 19) -- pebble
  self.tileQuads[3] = getQuadAt(6, 18) -- flower1
  self.tileQuads[4] = getQuadAt(6, 19) -- flower2
  self.tileQuads[5] = getQuadAt(4, 18) -- stone
  self.tileQuads[6] = getQuadAt(4, 19) -- stone2

  local totalNumOfTiles = self.viewTileWidth * self.viewTileHeight
  self.tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, totalNumOfTiles)

  self:update(0)
end

function Map:update(dt)
  self.tilesetBatch:clear()

  local beginTileX = math.floor(self.viewTileX)
  local beginTileY = math.floor(self.viewTileY)

  for tileX = 0, self.viewTileWidth - 1 do
    for tileY = 0, self.viewTileHeight - 1 do
      local quad = self:tileQuadAt(beginTileX + tileX, beginTileY + tileY)
      local mapX = tileX * self.tileWidth
      local mapY = tileY * self.tileHeight
      self.tilesetBatch:add(quad, mapX, mapY)
    end
  end
end

function Map:track(entity)
  self.trackEntity = entity
end

function Map:think(dt)
end

function Map:move(dt)
  local oldViewTileX = self.viewTileX
  local oldViewTileY = self.viewTileY

  self.vx = self.trackEntity.vx / self.tileWidth
  self.vy = self.trackEntity.vy / self.tileHeight
  self.viewTileX = math.limit(self.viewTileX + self.vx * dt, 1,
                              self.mapTileWidth - self.viewTileWidth)
  self.viewTileY = math.limit(self.viewTileY + self.vy * dt, 1,
                              self.mapTileHeight - self.viewTileHeight)

  if math.floor(self.viewTileX) ~= math.floor(oldViewTileX) or
     math.floor(self.viewTileX) ~= math.floor(oldViewTileY) then
    self:update(dt)
  end
end

function Map:draw()
  -- round to the nearest 1 / tileWidth to get rid of visual artifacts
  roundedTileX = math.floor(self.viewTileX * self.tileWidth) / self.tileWidth
  roundedTileY = math.floor(self.viewTileY * self.tileHeight) / self.tileHeight

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(
    self.tilesetBatch,
    -self.zoomX * (roundedTileX % 1) * self.tileWidth,
    -self.zoomY * (roundedTileY % 1) * self.tileHeight
  )
end

function Map:tileQuadAt(tileX, tileY)
  local tiletype = self.map[tileX + 1][tileY + 1]
  return self.tileQuads[tiletype]
end

function Map:isOutside(entity)
  if entity.x < self:left() or entity.x > self:right() then
    return true
  elseif entity.y < self:top() or entity.y > self:bottom() then
    return true
  else
    return false
  end
end

function Map:left()
  return 0
end

function Map:right()
  return (self.mapTileWidth - 3) * map.tileWidth
end

function Map:top()
  return 0
end

function Map:bottom()
  return (self.mapTileHeight - 2) * map.tileHeight - 7
end

function Map:viewportWidth()
  return self.screenWidth / self.zoomX
end

function Map:viewportHeight()
  return self.screenHeight / self.zoomY
end
