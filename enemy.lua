require('class')
require('entity')

Enemy = Entity:new("enemy")

print("Enemy")
print(Enemy)

function Enemy:init(x, y)
  self.__baseclass:init()

  if self ~= Enemy then
    self:setPosition(x, y)
    self:setDimension(32, 40)
    self:setMoveForce(3000)
    self:setMass(10)
  end
end

function Enemy:draw()
  love.graphics.setColor(150, 100, 200, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

function Enemy:think(dt)
  if rand:random() > 0.95 then
    if rand:random() > 0.5 then
      self.ax = self.moveForce / self.mass
    else
      self.ax = -self.moveForce / self.mass
    end
  end
  if rand:random() > 0.95 then
    if rand:random() > 0.5 then
      self.ay = self.moveForce / self.mass
    else
      self.ay = -self.moveForce / self.mass
    end
  end
end

function Enemy:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end
