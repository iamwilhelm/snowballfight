require('entity')

Bullet = Entity:new("projectile")

print("Bullet")
print(Bullet)

function Bullet:init(x, y, rot)
  self.__baseclass:init(x, y)

  if self ~= Bullet then
    self:setDimension(20, 20)
    self:setPosition(x, y)
    self:setMass(5)
    -- slow
    self:setMoveForce(20000)
    -- fast
    -- self:setMoveForce(50000)
    self.rot = rot

    -- TODO global
    self.hero = hero
  end
end

function Bullet:impulse(dt)
  local ax = self.moveForce / self.mass * math.cos(self.rot)
  local ay = self.moveForce / self.mass * math.sin(self.rot)
  local fudgeDt = 0.1
  self.vx = self.vx + ax * fudgeDt
  self.vy = self.vy + ay * fudgeDt
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle("fill", self.x, self.y, self.width / 2)
end


