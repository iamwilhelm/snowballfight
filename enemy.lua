require('class')

Enemy = class:new()

function Enemy:init(x, y)
  self.width = 40
  self.height = 20

  self.x = x
  self.y = y

  self.v_max = 20
  self.vx = 0
  self.vy = 0
end

function Enemy:draw()
  love.graphics.setColor(150, 100, 200, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

function Enemy:update(dt)
  self:think(dt)
  self:move(dt)
end

function Enemy:think(dt)
  if rand:random() > 0.9 then
    if rand:random() > 0.5 then
      self.vx = self.v_max
    else
      self.vx = -self.v_max
    end
  end
  if rand:random() > 0.9 then
    if rand:random() > 0.5 then
      self.vy = self.v_max
    else
      self.vy = -self.v_max
    end
  end
end

function Enemy:move(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

-- query

function Enemy:bottom()
  return self.y + self.height / 2
end



