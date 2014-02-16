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

    self.isTracking = true
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

function Camera:map(map)
  self.map = map
end

function Camera:track(entity)
  self.trackEntity = entity
end

function Camera:toggleTracking()
  self.isTracking = not self.isTracking
end

function Camera:think(dt)
  if self.isTracking == false then
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
  else
    if self.trackEntity ~= nil then
      local fudgefactor = 3
      local dx = self.trackEntity.x - self.x
      local dy = self.trackEntity.y - self.y

      self.ax = fudgefactor * dx / self.screenWidth * self.a_max
      self.ay = fudgefactor * dy / self.screenHeight * self.a_max
    end
  end
end

-- NOTE: we subtract out two tiles in the camera limit, because the map has a
-- perimeter of tiles all around it.
function Camera:move(dt)
  -- TODO global access to map
  self.vx = math.limit(self.vx + self.ax * dt, self.v_max)
  self.x = math.limit(self.x + self.vx * dt,
                      self.map:left() + self.map:viewportWidth() / 2,
                      self.map:right() - self.map:viewportWidth() / 2)

  self.vy = math.limit(self.vy + self.ay * dt, self.v_max)
  self.y = math.limit(self.y + self.vy * dt,
                      self.map:top() + self.map:viewportHeight() / 2,
                      self.map:bottom() - self.map:viewportHeight() / 2)
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
