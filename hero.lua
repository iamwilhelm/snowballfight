require('class')
require('bullet')

-- entity helper functions
function limit(num, cap)
  if num > cap then
    return cap
  end
  if num < -cap then
    return -cap
  end
  return num
end

Hero = class:new()

function Hero:init(x, y)
  self.width = 30
  self.height = 30

  self.x = x
  self.y = y

  self.v_max = 150
  self.vx = 0
  self.vy = 0

  self.a_max = 500
  self.ax = 0
  self.ay = 0

  self.intent = nil
end

function Hero:draw()
  love.graphics.setColor(255, 255, 0, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

-- hero update actions

function Hero:update(dt)
  self:think(dt)
  self:move(dt)
end

function Hero:think(dt)
  if love.keyboard.isDown("left") then
    hero:moveLeft(dt)
  end
  if love.keyboard.isDown("right") then
    hero:moveRight(dt)
  end
  if love.keyboard.isDown("up") then
    hero:moveUp(dt)
  end
  if love.keyboard.isDown("down") then
    hero:moveDown(dt)
  end
end

function Hero:move(dt)
  self.vx = limit(self.vx + self.ax * dt, self.v_max)
  self.x = self.x + self.vx * dt

  self.vy = limit(self.vy + self.ay * dt, self.v_max)
  self.y = self.y + self.vy * dt
end

-- hero specific actions

function Hero:moveLeft(dt)
  self.ax = -self.a_max
end

function Hero:moveRight(dt)
  self.ax = self.a_max
end

function Hero:moveUp(dt)
  self.ay = -self.a_max
end

function Hero:moveDown(dt)
  self.ay = self.a_max
end

function Hero:shoot(dt)
  local bullet = Bullet:new(self.x, self.y - self.height)
  table.insert(projectiles, bullet)
  table.insert(world, shot)
end

-- hero state queries

function Hero:bottom()
  return self.y + self.height / 2
end


