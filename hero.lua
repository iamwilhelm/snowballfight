require('class')
require('bullet')

Hero = class:new()

function Hero:init(x, y)
  self.x = x
  self.y = y
  self.width = 30
  self.height = 30
  self.speed = 150
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

function Hero:moveLeft(dt)
  self.x = self.x - self.speed * dt
end

function Hero:moveRight(dt)
  self.x = self.x + self.speed * dt
end

function Hero:moveUp(dt)
  self.y = self.y - self.speed * dt
end

function Hero:moveDown(dt)
  self.y = self.y + self.speed * dt
end

function Hero:shoot(dt)
  local bullet = Bullet:new(self.x, self.y - self.height)
  table.insert(projectiles, bullet)
  table.insert(world, shot)
end



