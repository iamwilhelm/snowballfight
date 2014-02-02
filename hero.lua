require('class')

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
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- hero update actions

function Hero:moveLeft(dt)
  self.x = self.x - self.speed * dt
end

function Hero:moveRight(dt)
  self.x = self.x + self.speed * dt
end

function Hero:shoot(dt)
  local shot = {}
  shot.x = self.x + self.width / 2
  shot.y = self.y
  table.insert(self.shots, shot)
end



