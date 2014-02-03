require('class')
require('bullet')

Hero = class:new()

function Hero:init(x, y)
  self.x = x
  self.y = y
  self.width = 30
  self.height = 30
  self.speed = 150
  self.shots = {}
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
  elseif love.keyboard.isDown("right") then
    hero:moveRight(dt)
  end
end

function Hero:moveLeft(dt)
  self.x = self.x - self.speed * dt
end

function Hero:moveRight(dt)
  self.x = self.x + self.speed * dt
end

function Hero:shoot(dt)
  local shot = Bullet:new(self.x, self.y)
  table.insert(self.shots, shot)
end



