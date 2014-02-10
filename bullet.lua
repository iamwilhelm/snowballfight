require('entity')

Bullet = Entity:new()
print("Bullet")
print(Bullet)

function Bullet.add(bullet)
  table.insert(projectiles, bullet)
end

function Bullet.remove(i)
  table.remove(projectiles, i)
end

-- should know something about the field of view or bullet range from point of origin
function Bullet.removeAllOutOfView()
  for i, bullet in ipairs(projectiles) do
    if bullet.y < 0 then
      Bullet.remove(i)
    end
  end
end

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

function Bullet:update(dt)
  self:think(dt)
  self:move(dt)
end

