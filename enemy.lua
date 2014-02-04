require('class')

Enemy = class:new()

function Enemy:init(x, y)
  self.width = 40
  self.height = 20
  self.x = x
  self.y = self.height + y
  self.speed = 20
end

function Enemy:draw()
  love.graphics.setColor(150, 100, 200, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

function Enemy:update(dt)
  self.y = self.y + 20 * dt
end


