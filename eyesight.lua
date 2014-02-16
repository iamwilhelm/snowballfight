require('entity')

Eyesight = Entity:new()

print("Eyesight")
print(Eyesight)

function Eyesight:init(camera)
  self.__baseclass:init()
  screenWidth, screenHeight = love.window.getDimensions()
  if x == nil then self.x = screenWidth / 2 end
  if y == nil then self.y = screenHeight / 2 end

  if self ~= Camera then
    self:setPosition(x, y)
    self.camera = camera
  end
end

function Eyesight:think(dt)
  local screenX, screenY = love.mouse.getPosition()
  self.x, self.y = camera:screen2WorldCoord(screenX, screenY)
end

function Eyesight:draw()
  love.graphics.setColor(255, 63, 0, 120)
  love.graphics.circle("fill", self.x, self.y, 8)
end

