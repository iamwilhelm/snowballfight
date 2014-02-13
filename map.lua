require('class')

Map = class:new()

print("Map")
print(Map)

function Map:init(width, height)
  self.mapWidth = width
  self.mapHeight = height

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
  self.tilesDisplayWidth = 26
  self.tilesDisplayHeight = 20

  -- view x,y in tiles
  self.tileDisplayX = 1
  self.tileDisplayY = 1
  self.displayZoomX = 1
  self.displayZoomY = 1
end

function Map:setupTileset(filename)
  tilesetImage = love.graphics.newImage(filename)
  tilesetImage:setFilter("nearest", "linear")
  self.tileSizeX = 32
  self.tileSizeY = 32


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

  self.tilesetBatch = love.graphics.newSpriteBatch(tilesetImage,
    self.tilesDisplayWidth * self.tilesDisplayHeight)
  self:update(0)
end

function Map:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(
    self.tilesetBatch,
    math.floor(-self.displayZoomX * (self.tileDisplayX % 1) * self.tileSizeX),
    math.floor(-self.displayZoomY * (self.tileDisplayY % 1) * self.tileSizeY),
    0,
    self.displayZoomX,
    self.displayZoomY
  )
end

function Map:update(dt)
  self.tilesetBatch:clear()
  for tileX = 1, self.tilesDisplayWidth do
    for tileY = 1, self.tilesDisplayHeight do
      self.tilesetBatch:add(self:tileQuadAt(tileX + math.floor(self.tileDisplayX),
                                            tileY + math.floor(self.tileDisplayY)),
                            (tileX - 1) * self.tileSizeX,
                            (tileY - 1) * self.tileSizeY)
    end
  end
end

function Map:think(dt)
  if love.keyboard.isDown("up")  then
    self:move(0, -0.2 * self.tileSizeY * dt)
  end
  if love.keyboard.isDown("down")  then
    self:move(0, 0.2 * self.tileSizeY * dt)
  end
  if love.keyboard.isDown("left")  then
    self:move(-0.2 * self.tileSizeX * dt, 0)
  end
  if love.keyboard.isDown("right")  then
    self:move(0.2 * self.tileSizeX * dt, 0)
  end
end

function Map:move(dx, dy, dt)
  oldTileDisplayX = self.tileDisplayX
  oldTileDisplayY = self.tileDisplayY

  self.tileDisplayX = math.max(math.min(self.tileDisplayX + dx,
                                        self.mapWidth - self.tilesDisplayWidth), 1)
  self.tileDisplayY = math.max(math.min(self.tileDisplayY + dy,
                                        self.mapHeight - self.tilesDisplayHeight), 1)

  if math.floor(self.tileDisplayX) ~= math.floor(oldTileDisplayX) or math.floor(self.tileDisplayX) ~= math.floor(oldTileDisplayY) then
    self:update(dt)
  end
end

function Map:tileQuadAt(tileX, tileY)
  local tiletype = self.map[tileX][tileY]
  return self.tileQuads[tiletype]
end

