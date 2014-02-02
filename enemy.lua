require('class')

Enemy = class:new()

function Enemy:init(x, y)
  self.width = 40
  self.height = 20
  self.x = x
  self.y = self.height + y
end

function Enemy:draw()
  love.graphics.setColor(0, 255, 255, 255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Enemy:update(dt)
  self.y = self.y + dt
end


