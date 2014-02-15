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

    self:setMaxVelocity(750)
    self:setMaxAccel(2000)
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

-- NOTE: we subtract out two tiles in the camera limit, because the map has a
-- perimeter of tiles all around it.
function Camera:move(dt)
  -- TODO global access to map
  self.vx = math.limit(self.vx + self.ax * dt, self.v_max)
  self.x = math.limit(self.x + self.vx * dt,
                      map:left() + map:viewportWidth() / 2,
                      map:right() - map:viewportWidth() / 2)

  self.vy = math.limit(self.vy + self.ay * dt, self.v_max)
  self.y = math.limit(self.y + self.vy * dt,
                      map:top() + map:viewportHeight() / 2,
                      map:bottom() - map:viewportHeight() / 2)
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
