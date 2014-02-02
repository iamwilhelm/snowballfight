Hero = {}
Hero.__index = Hero

function Hero.new(x, y)
  local hero = {}
  setmetatable(hero, Hero)

  hero.x = x
  hero.y = y
  hero.width = 30
  hero.height = 30
  hero.speed = 150
  hero.shots = {}

  return hero
end

function Hero:moveLeft(dt)
  self.x = self.x - self.speed * dt
end

function Hero:moveRight(dt)
  self.x = self.x + self.speed * dt
end

function Hero:shoot()
  local shot = {}
  shot.x = self.x + self.width / 2
  shot.y = self.y
  table.insert(self.shots, shot)
end


function Hero:draw()
  love.graphics.setColor(255, 255, 0, 255)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
