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
  Hero.sounds.thud = love.audio.newSource("assets/sounds/punch.mp3")

  Hero.images = {}
  Hero.images.stunLeft = love.graphics.newImage("assets/sprites/sballer/sballerLstunLeft.png")
  Hero.images.stunRight = love.graphics.newImage("assets/sprites/sballer/sballerLstunRight.png")
  Hero.images.throwLeft = love.graphics.newImage("assets/sprites/sballer/sballerLthrowLeft.png")
  Hero.images.throwRight = love.graphics.newImage("assets/sprites/sballer/sballerLthrowRight.png")

  Hero.images.runningHeadLeft = love.graphics.newImage("assets/sprites/sballer/sballerHrunLeft.png")
  Hero.images.runningHeadRight = love.graphics.newImage("assets/sprites/sballer/sballerHrunRight.png")
  Hero.images.runningTorsoLeft = love.graphics.newImage("assets/sprites/sballer/sballerTrunLeft.png")
  Hero.images.runningTorsoRight = love.graphics.newImage("assets/sprites/sballer/sballerTrunRight.png")
  Hero.images.runningLegsLeft = love.graphics.newImage("assets/sprites/sballer/sballerLrunLeft.png")
  Hero.images.runningLegsRight = love.graphics.newImage("assets/sprites/sballer/sballerLrunRight.png")
end

function Hero:init(x, y)
  self.__baseclass:init()

  if self ~= Hero then
    self:setPosition(x, y)
    self:setDimension(40, 60)
    self:setMoveForce(1500)
    self:setMass(10)

    -- what is this for?
    self.stunTimestamp = love.timer.getTime()
    self.chargeTimestamp = love.timer.getTime()
    self.state = "running"

    -- set animations for each state

    self.anim = {}

    self.anim.stunned = {}
    self.anim.stunned.left = newAnimation(Hero.images.stunLeft, 58, 69, 0.175, 0)
    self.anim.stunned.left:setMode('once')
    self.anim.stunned.right = newAnimation(Hero.images.stunRight, 58, 69, 0.175, 0)
    self.anim.stunned.right:setMode('once')

    self.anim.throwing = {}
    self.anim.throwing.left = newAnimation(Hero.images.throwLeft, 75, 68, 0.1, 0)
    self.anim.throwing.right = newAnimation(Hero.images.throwRight, 75, 68, 0.1, 0)

    self.anim.runningHead = {}
    self.anim.runningHead.left = newAnimation(Hero.images.runningHeadLeft, 31, 30, 0.1, 0)
    self.anim.runningHead.right = newAnimation(Hero.images.runningHeadRight, 31, 30, 0.1, 0)

    self.anim.runningTorso = {}
    self.anim.runningTorso.left = newAnimation(Hero.images.runningTorsoLeft, 34, 33, 0.1, 0)
    self.anim.runningTorso.right = newAnimation(Hero.images.runningTorsoRight, 34, 33, 0.1, 0)

    self.anim.runningLegs = {}
    self.anim.runningLegs.left = newAnimation(Hero.images.runningLegsLeft, 38, 30, 0.1, 0)
    self.anim.runningLegs.right = newAnimation(Hero.images.runningLegsRight, 38, 30, 0.1, 0)

  end
end

function Hero:draw()
  love.graphics.setColor(255, 255, 255, 100)

  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)

  love.graphics.setColor(255, 255, 255, 255)

  if self.state == "running" then

    if self.ax <= 0 then
      self.anim.runningLegs.left:draw(self.x, self.y,
                                      0, 1, 1, 38 / 2 + 8, 30 / 2 - 12 - 4)
      self.anim.runningTorso.left:draw(self.x, self.y,
                                       0, 1, 1, 34 / 2, 33 / 2 - 4)
      self.anim.runningHead.left:draw(self.x, self.y,
                                      0, 1, 1, 31 / 2, 30 / 2 + 20 - 4)
    elseif self.ax > 0 then
      self.anim.runningLegs.right:draw(self.x, self.y,
                                       0, 1, 1, 38 / 2 - 8, 30 / 2 - 12 - 4)
      self.anim.runningTorso.right:draw(self.x, self.y,
                                        0, 1, 1, 34 / 2, 33 / 2 - 4)
      self.anim.runningHead.right:draw(self.x, self.y,
                                       0, 1, 1, 31 / 2, 30 / 2 + 20 - 4)
    end

  elseif self.state == "stunned" then
    -- stunned is opposite of direction moving
    if self.vx >= 0 then
      self.anim.stunned.left:draw(self.x, self.y,
                                  0, 1, 1, 58 / 2, 69 / 2)
    elseif self.vx < 0 then
      self.anim.stunned.right:draw(self.x, self.y,
                                   0, 1, 1, 58 / 2, 69 / 2)
    end
  end


end

-- hero update actions

function Hero:think(dt)
  if self.state == "running" then
    if love.keyboard.isDown("a") then
      self:moveLeft(dt)
    elseif love.keyboard.isDown("d") then
      self:moveRight(dt)
    else
      self:stopHorizontal(dt)
    end

    if love.keyboard.isDown("w") then
      self:moveUp(dt)
    elseif love.keyboard.isDown("s") then
      self:moveDown(dt)
    else
      self:stopVertical(dt)
    end

    if love.keyboard.isDown("e") then
      self:stun(dt)
    end
  elseif self.state == "stunned" then
    -- do nothing
  end
end

function Hero:move(dt)
  Entity.move(self, dt)

  if self.state == "running" then

    if self.ax <= 0 then
      self.anim.runningLegs.left:update(dt)
      self.anim.runningTorso.left:update(dt)
      self.anim.runningHead.left:update(dt)
    elseif self.ax > 0 then
      self.anim.runningLegs.right:update(dt)
      self.anim.runningTorso.right:update(dt)
      self.anim.runningHead.right:update(dt)
    end

  elseif self.state == "stunned" then

    if (love.timer.getTime() - self.stunTimestamp) > 2 then
      self.anim.stunned.left:reset()
      self.anim.stunned.left:play()
      self.anim.stunned.right:reset()
      self.anim.stunned.right:play()
      self.state = "running"
    else
      if self.vx <= 0 then
        self.anim.stunned.right:update(dt)
      elseif self.vx > 0 then
        self.anim.stunned.left:update(dt)
      end

    end

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

function Hero:charge(dt)
  self.chargeTimestamp = love.timer.getTime()
end

function Hero:chargedForce(elapsed)
  local u = 0.5
  local sigma = 0.25
  return 1 / (sigma * math.sqrt(2 * math.pi)) *
    math.exp(-math.pow(elapsed - u, 2) / (2 * math.pow(sigma, 2)))
end

function Hero:shoot(dt)
  dt = dt or love.timer.getDelta()
  local dx = eyesight.x - self.x
  local dy = eyesight.y - self.y
  local rot = math.atan2(dy, dx)

  local elapsed = love.timer.getTime() - self.chargeTimestamp
  local force = 25000 * self:chargedForce(elapsed)

  local bullet = Bullet:new(self, self.x, self.y, rot)
  bullet:setMoveForce(force)
  bullet:impulse(dt)

  -- TODO global access
  world:add(bullet)

  -- play sound (should be in a before filter or state change callback)
  love.audio.play(Hero.sounds.throw)
end

function Hero:stun(dt)
  self.state = "stunned"
  self.stunTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
  love.audio.play(Hero.sounds.thud)
end

-- draggable

function Hero:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end

