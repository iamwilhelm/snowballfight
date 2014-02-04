require('class')

Bullet = class:new()

function Bullet.add(bullet)
  table.insert(hero.shots, bullet)
end

function Bullet.remove(i)
  table.remove(hero.shots, i)
end

-- should know something about the field of view or bullet range from point of origin
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
  self.width = 5
  self.height = 10
  self.speed = 150
  self.hero = hero
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

function Bullet:update(dt)
  -- move the bullet on its trajectory
  self.y = self.y - dt * self.speed
end
