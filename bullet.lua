require('entity')

Bullet = Entity:new("projectile")

print("Bullet")
print(Bullet)

function Bullet:init(x, y, rot)
  self.__baseclass:init(x, y)

  if self ~= Bullet then
    self:setDimension(20, 20)
    self:setPosition(x, y)
    self:setMaxVelocity(350)

    self.vx = self.v_max * math.cos(rot)
    self.vy = self.v_max * math.sin(rot)

    -- TODO global
    self.hero = hero
  end
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle("fill", self.x, self.y, self.width / 2)
end

