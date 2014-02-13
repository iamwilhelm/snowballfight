require('class')

Map = class:new()

print("Map")
print(Map)

function Map:init(mapWidth, mapHeight)
  self.mapWidth = mapWidth
  self.mapHeight = mapHeight
  self.tileWidth = 32
  self.tileHeight = 32

  self.map = {}
  for x = 1, self.mapWidth do
    self.map[x] = {}
    for y = 1, self.mapHeight do
      self.map[x][y] = math.random(0, 3)
    end
  end
  self.map[1][1] = 5

  self.tileQuads = {}

  -- number of tiles to display
  self.viewTileWidth = math.floor(800 / self.tileWidth) + 1
  self.viewTileHeight = math.floor(600 / self.tileHeight) + 1

  -- viewport
  self.viewportX = 0
  self.viewportY = 0
  self.zoomX = 1
  self.zoomY = 1
end

function Map:setupTileset(filename)
  tilesetImage = love.graphics.newImage(filename)
  tilesetImage:setFilter("nearest", "linear")

  function getQuadAt(viewportX, viewportY)
    return love.graphics.newQuad(viewportX * self.tileWidth, viewportY * self.tileHeight,
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

function Map:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(
    self.tilesetBatch,
    math.floor(-self.zoomX * (self.viewportX % 1) * self.tileWidth),
    math.floor(-self.zoomY * (self.viewportY % 1) * self.tileHeight),
    0,
    self.zoomX,
    self.zoomY
  )
end

function Map:update(dt)
  self.tilesetBatch:clear()
  for tileX = 1, self.viewTileWidth do
    for tileY = 1, self.viewTileHeight do
      local quad = self:tileQuadAt(tileX + math.floor(self.viewportX),
                                   tileY + math.floor(self.viewportY))
      local mapX = (tileX - 1) * self.tileWidth
      local mapY = (tileY - 1) * self.tileHeight
      self.tilesetBatch:add(quad, mapX, mapY)
    end
  end
end

function Map:tileQuadAt(tileX, tileY)
  local tiletype = self.map[tileX][tileY]
  return self.tileQuads[tiletype]
end

function Map:think(dt)
  if love.keyboard.isDown("up")  then
    self:move(0, -0.2 * self.tileHeight * dt)
  end
  if love.keyboard.isDown("down")  then
    self:move(0, 0.2 * self.tileHeight * dt)
  end
  if love.keyboard.isDown("left")  then
    self:move(-0.2 * self.tileWidth * dt, 0)
  end
  if love.keyboard.isDown("right")  then
    self:move(0.2 * self.tileWidth * dt, 0)
  end
end

function Map:move(dx, dy, dt)
  oldTileDisplayX = self.viewportX
  oldTileDisplayY = self.viewportY

  self.viewportX = math.max(math.min(self.viewportX + dx,
                                     self.mapWidth - self.viewTileWidth), 1)
  self.viewportY = math.max(math.min(self.viewportY + dy,
                                     self.mapHeight - self.viewTileHeight), 1)

  if math.floor(self.viewportX) ~= math.floor(oldTileDisplayX) or math.floor(self.viewportX) ~= math.floor(oldTileDisplayY) then
    self:update(dt)
  end
end


