require('class')

Bullet = class:new()

function Bullet.add(bullet)
  table.insert(hero.shots, bullet)
end

function Bullet.remove(i)
  table.remove(hero.shots, i)
end

function Bullet.removeAllOutOfView()
  for i, bullet in ipairs(hero.shots) do
    if bullet.y < 0 then
      Bullet.remove(i)
    end
  end
end

function Bullet:init(x, y)
  self.x = x
  self.y = y
  self.hero = hero
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill", self.x, self.y, 2, 5)
end

function Bullet:update(dt)
  -- move the bullet on its trajectory
  self.y = self.y - dt * 100
end
