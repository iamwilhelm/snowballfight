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
      self.map[x][y] = math.random(0, 2)
    end
  end

  self.tileQuads = {}

  -- number of tiles to display
  self.tilesDisplayWidth = 26
  self.tilesDisplayHeight = 20

  -- view x,y in tiles
  self.tileDisplayX = 1
  self.tileDisplayY = 1
end

function Map:setupTileset(filename)
  tilesetImage = love.graphics.newImage(filename)
  tilesetImage:setFilter("nearest", "linear")
  self.tileSizeX = 32
  self.tileSizeY = 32

  -- grass
  self.tileQuads[0] = love.graphics.newQuad(0 * self.tileSizeX, 20 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- stone
  self.tileQuads[1] = love.graphics.newQuad(1 * self.tileSizeX, 20 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- tree
  self.tileQuads[2] = love.graphics.newQuad(2 * self.tileSizeX, 20 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- stump
  self.tileQuads[3] = love.graphics.newQuad(3 * self.tileSizeX, 20 * self.tileSizeY,
    self.tileSizeX, self.tileSizeY, tilesetImage:getWidth(), tilesetImage:getHeight())
  -- dead tree
  self.tileQuads[4] = love.graphics.newQuad(4 * self.tileSizeX, 20 * self.tileSizeY,
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
  for tileX = 0, self.tilesDisplayWidth - 1 do
    for tileY = 0, self.tilesDisplayHeight - 1 do
      self.tilesetBatch:add(self:tileQuadAt(tileX, tileY),
                            tileX * self.tileSizeX, tileY * self.tileSizeY)
    end
  end
end

function Map:tileQuadAt(tileX, tileY)
  local tiletype = self.map[tileX + 1][tileY + 1]
  return self.tileQuads[tiletype]
end

