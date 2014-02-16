require('./ext/math')
require('entity')
require('bullet')

Hero = Entity:new("friendly")

print("Hero")
print(Hero)

function Hero:init(x, y)
  self.__baseclass:init()

  if self ~= Hero then
    self:setPosition(x, y)
    self:setDimension(32, 40)

    self:setMaxVelocity(90)
    self:setMaxAccel(500)

    self.intent = nil
  end
end

function Hero:draw()
  love.graphics.setColor(255, 255, 0, 255)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

-- hero update actions

function Hero:think(dt)
  if love.keyboard.isDown("a") then
    hero:moveLeft(dt)
  elseif love.keyboard.isDown("d") then
    hero:moveRight(dt)
  else
    hero:stopHorizontal(dt)
  end

  if love.keyboard.isDown("w") then
    hero:moveUp(dt)
  elseif love.keyboard.isDown("s") then
    hero:moveDown(dt)
  else
    hero:stopVertical(dt)
  end

end

-- hero specific actions

function Hero:moveLeft(dt)
  self.ax = -self.a_max
end

function Hero:moveRight(dt)
  self.ax = self.a_max
end

function Hero:moveUp(dt)
  self.ay = -self.a_max
end

function Hero:moveDown(dt)
  self.ay = self.a_max
end

function Hero:stopHorizontal(dt)
  self.ax = 0
end

function Hero:stopVertical(dt)
  self.ay = 0
end

function Hero:shoot(dt)
  local dx = eyesight.x - self.x
  local dy = eyesight.y - self.y
  local rot = math.atan2(dy, dx)
  if math.sign(dx) == -1 then
  end
  local bullet = Bullet:new(self.x, self.y, rot)

  -- TODO global access

  world:add(bullet)
end

-- draggable

function Hero:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end

