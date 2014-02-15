require('entity')

Bullet = Entity:new("projectile")

print("Bullet")
print(Bullet)

function Bullet:init(x, y)
  self.__baseclass:init(x, y)

  if self ~= Bullet then
    self:setPosition(x, y)
    self:setVelocity(0, -300)
    self:setDimension(5, 10)
    self:setMaxVelocity(300)

    -- TODO global
    self.hero = hero
  end
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

