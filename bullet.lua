require('class')

Bullet = class:new()

function Bullet.add(bullet)
end

function Bullet.remove(i)
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
  -- move the bullet up
  self.y = self.y - dt * 100

  -- remove bullets outside the field of view
  if self.y < 0 then
    table.remove(hero.shots, i)
  end
end
