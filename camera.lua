require('entity')

Camera = Entity:new()

print("Camera")
print(Camera)

function Camera:init(x, y)
  self.__baseclass:init()
  self.screenWidth, self.screenHeight = love.window.getDimensions()
  if x == nil then self.x = self.screenWidth / 2 end
  if y == nil then self.y = self.screenHeight / 2 end

  if self ~= Camera then
    self:setPosition(x, y)
    self.scaleX = 1
    self.scaleY = 1
    self.rotation = 0
  end
end

function Camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.translate(self.screenWidth / 2, self.screenHeight / 2)
  love.graphics.scale(self.scaleX, self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:update(dt)
  self:think(dt)
  self:move(dt)
end

function Camera:think(dt)
  if love.keyboard.isDown("left") then
    self.ax = -self.a_max
  elseif love.keyboard.isDown("right") then
    self.ax = self.a_max
  else
    self.ax = 0
  end
  if love.keyboard.isDown("up") then
    self.ay = -self.a_max
  elseif love.keyboard.isDown("down") then
    self.ay = self.a_max
  else
    self.ay = 0
  end
end

function Camera:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end

function Camera:left()
  return self.scaleX * (self.x - self.screenWidth / 2)
end

function Camera:right()
  return self.scaleX * (self.x + self.screenWidth / 2)
end

function Camera:top()
  return self.scaleY * (self.y - self.screenHeight / 2)
end

function Camera:bottom()
  return self.scaleY * (self.y + self.screenHeight / 2)
end
