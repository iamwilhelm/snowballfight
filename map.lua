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
  screenWidth, screenHeight = love.window.getDimensions()
  self.viewTileWidth = math.floor(screenWidth / self.tileWidth) + 2
  self.viewTileHeight = math.floor(screenHeight / self.tileHeight) + 2

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

function Map:think(dt)
end

function Map:move(dt)
  local oldViewTileX = self.viewTileX
  local oldViewTileY = self.viewTileY
  local dx = camera.vx / self.tileWidth * dt
  local dy = camera.vy / self.tileHeight * dt
  -- print(dx, dy)

  self.viewTileX = math.limit(self.viewTileX + dx, 1,
                              self.mapTileWidth - self.viewTileWidth)
  self.viewTileY = math.limit(self.viewTileY + dy, 1,
                              self.mapTileHeight - self.viewTileHeight)

  if math.floor(self.viewTileX) ~= math.floor(oldViewTileX) or
     math.floor(self.viewTileX) ~= math.floor(oldViewTileY) then
    self:update(dt)
  end
end

function Map:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(
    self.tilesetBatch,
    -self.zoomX * (self.viewTileX % 1) * self.tileWidth,
    -self.zoomY * (self.viewTileY % 1) * self.tileHeight
  )
end

function Map:tileQuadAt(tileX, tileY)
  local tiletype = self.map[tileX + 1][tileY + 1]
  return self.tileQuads[tiletype]
end

function Map:thinkold(dt)
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

end


