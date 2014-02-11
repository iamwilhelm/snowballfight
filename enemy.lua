require('class')
require('entity')

Enemy = Entity:new("enemy")

print("Enemy")
print(Enemy)

function Enemy:init(x, y)
  self.__baseclass:init()

  if self ~= Enemy then
    self:setPosition(x, y)
    self:setDimension(32, 48)

    self:setMaxVelocity(20)
    self:setMaxAccel(1000)
  end
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


