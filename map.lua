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
  self.tilesDisplayWidth = 25
  self.tilesDisplayHeight = 19

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

  -- grass1
  self.tileQuads[0] = love.graphics.newQuad(5 * self.tileSizeX, 17 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- grass2
  self.tileQuads[2] = love.graphics.newQuad(5 * self.tileSizeX, 18 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- pebble
  self.tileQuads[1] = love.graphics.newQuad(5 * self.tileSizeX, 19 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- flower1
  self.tileQuads[3] = love.graphics.newQuad(6 * self.tileSizeX, 18 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- flower2
  self.tileQuads[4] = love.graphics.newQuad(6 * self.tileSizeX, 19 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- stone
  self.tileQuads[5] = love.graphics.newQuad(4 * self.tileSizeX, 18 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- stone2
  self.tileQuads[6] = love.graphics.newQuad(4 * self.tileSizeX, 19 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())

  self.tilesetBatch = love.graphics.newSpriteBatch(tilesetImage,
    self.tilesDisplayWidth * self.tilesDisplayHeight)
  self:update(0)
end

function Map:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.tilesetBatch)
end

function Map:update(dt)
  self.tilesetBatch:clear()
  for tileX = 1, self.tilesDisplayWidth do
    for tileY = 1, self.tilesDisplayHeight do
      self.tilesetBatch:add(self:tileQuadAt(tileX, tileY),
                            (tileX - 1) * self.tileSizeX,
                            (tileY - 1) * self.tileSizeY)
    end
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

