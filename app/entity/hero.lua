require('lib/ext/math')
require('lib/AnAL')
require('entity')
require('entity/bullet')

Hero = Entity:new("friendly")

print("Hero")
print(Hero)

function Hero.loadAssets()
  Hero.sounds = {}
  Hero.sounds.throw = love.audio.newSource("assets/sounds/snow_throw.mp3")
end

function Hero:init(x, y)
  self.__baseclass:init()

  if self ~= Hero then
    self:setPosition(x, y)
    self:setDimension(32, 40)
    self:setMoveForce(2000)
    self:setMass(10)

    -- what is this for?
    self.intent = nil
    self.toShoot = false
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
  self.ax = -self.moveForce / self.mass
end

function Hero:moveRight(dt)
  self.ax = self.moveForce / self.mass
end

function Hero:moveUp(dt)
  self.ay = -self.moveForce / self.mass
end

function Hero:moveDown(dt)
  self.ay = self.moveForce / self.mass
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

  local bullet = Bullet:new(self.x, self.y, rot)
  -- from 20000 to 40000
  bullet:setMoveForce(20000)
  bullet:impulse(dt)

  -- TODO global access
  world:add(bullet)

  -- play sound (should be in a before filter
  love.audio.play(Hero.sounds.throw)
end

-- draggable

function Hero:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end
