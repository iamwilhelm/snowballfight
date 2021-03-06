require('class')
require('entity')

Enemy = Entity:new("enemy")

print("Enemy")
print(Enemy)

function Enemy.loadAssets()
  Enemy.sounds = {}
  Enemy.sounds.throw = love.audio.newSource("assets/sounds/snow_throw.mp3")
  Enemy.sounds.thud = love.audio.newSource("assets/sounds/punch.mp3")

  Enemy.images = {}
  Enemy.images.stunLeft = love.graphics.newImage("assets/sprites/sballer/sballerLstunLeft.png")
  Enemy.images.stunRight = love.graphics.newImage("assets/sprites/sballer/sballerLstunRight.png")
  Enemy.images.throwLeft = love.graphics.newImage("assets/sprites/sballer/sballerLthrowLeft.png")
  Enemy.images.throwRight = love.graphics.newImage("assets/sprites/sballer/sballerLthrowRight.png")

  Enemy.images.runningHeadLeft = love.graphics.newImage("assets/sprites/sballer/sballerHrunLeft.png")
  Enemy.images.runningHeadRight = love.graphics.newImage("assets/sprites/sballer/sballerHrunRight.png")
  Enemy.images.runningTorsoLeft = love.graphics.newImage("assets/sprites/sballer/sballerTrunLeft.png")
  Enemy.images.runningTorsoRight = love.graphics.newImage("assets/sprites/sballer/sballerTrunRight.png")
  Enemy.images.runningLegsLeft = love.graphics.newImage("assets/sprites/sballer/sballerLrunLeft.png")
  Enemy.images.runningLegsRight = love.graphics.newImage("assets/sprites/sballer/sballerLrunRight.png")
end

function Enemy:init(x, y)
  self.__baseclass:init()

  if self ~= Enemy then
    self:setPosition(x, y)
    self:setDimension(40, 60)
    self:setMoveForce(5000)
    self:setMass(10)

    self.stunTimestamp = love.timer.getTime()
    self.state = "running"

    -- set animations for each state

    self.anim = {}

    self.anim.stunned = {}
    self.anim.stunned.left = newAnimation(Enemy.images.stunLeft, 58, 69, 0.175, 0)
    self.anim.stunned.left:setMode('once')
    self.anim.stunned.right = newAnimation(Enemy.images.stunRight, 58, 69, 0.175, 0)
    self.anim.stunned.right:setMode('once')

    self.anim.throwing = {}
    self.anim.throwing.left = newAnimation(Enemy.images.throwLeft, 75, 68, 0.1, 0)
    self.anim.throwing.right = newAnimation(Enemy.images.throwRight, 75, 68, 0.1, 0)

    self.anim.runningHead = {}
    self.anim.runningHead.left = newAnimation(Enemy.images.runningHeadLeft, 31, 30, 0.1, 0)
    self.anim.runningHead.right = newAnimation(Enemy.images.runningHeadRight, 31, 30, 0.1, 0)

    self.anim.runningTorso = {}
    self.anim.runningTorso.left = newAnimation(Enemy.images.runningTorsoLeft, 34, 33, 0.1, 0)
    self.anim.runningTorso.right = newAnimation(Enemy.images.runningTorsoRight, 34, 33, 0.1, 0)

    self.anim.runningLegs = {}
    self.anim.runningLegs.left = newAnimation(Enemy.images.runningLegsLeft, 38, 30, 0.1, 0)
    self.anim.runningLegs.right = newAnimation(Enemy.images.runningLegsRight, 38, 30, 0.1, 0)

  end
end

function Enemy:draw()
  --love.graphics.setColor(255, 255, 255, 100)
  --love.graphics.rectangle("fill",
  --  self.x - self.width / 2,
  --  self.y - self.height / 2,
  --  self.width, self.height)

  love.graphics.setColor(255, 255, 255, 255)

  if self.state == "running" then

    if self.ax <= 0 then
      love.graphics.setColor(127, 255, 127, 255)
      self.anim.runningLegs.left:draw(self.x, self.y,
                                      0, 1, 1, 38 / 2 + 8, 30 / 2 - 12 - 4)
      self.anim.runningTorso.left:draw(self.x, self.y,
                                       0, 1, 1, 34 / 2, 33 / 2 - 4)
      love.graphics.setColor(255, 255, 255, 255)
      self.anim.runningHead.left:draw(self.x, self.y,
                                      0, 1, 1, 31 / 2, 30 / 2 + 20 - 4)
    elseif self.ax > 0 then
      love.graphics.setColor(127, 255, 127, 255)
      self.anim.runningLegs.right:draw(self.x, self.y,
                                       0, 1, 1, 38 / 2 - 8, 30 / 2 - 12 - 4)
      self.anim.runningTorso.right:draw(self.x, self.y,
                                        0, 1, 1, 34 / 2, 33 / 2 - 4)
      love.graphics.setColor(255, 255, 255, 255)
      self.anim.runningHead.right:draw(self.x, self.y,
                                       0, 1, 1, 31 / 2, 30 / 2 + 20 - 4)
    end

  elseif self.state == "stunned" then
    -- stunned is opposite of direction moving
    love.graphics.setColor(127, 255, 127, 255)
    if self.vx >= 0 then
      self.anim.stunned.left:draw(self.x, self.y,
                                  0, 1, 1, 58 / 2, 69 / 2)
    elseif self.vx < 0 then
      self.anim.stunned.right:draw(self.x, self.y,
                                   0, 1, 1, 58 / 2, 69 / 2)
    end
    love.graphics.setColor(255, 255, 255, 255)
  end

end

function Enemy:think(dt)
  if self.state == "running" then

    if rand:random() > 0.95 then
      if rand:random() > 0.5 then
        self.ax = self.moveForce / self.mass
      else
        self.ax = -self.moveForce / self.mass
      end
    end
    if rand:random() > 0.95 then
      if rand:random() > 0.5 then
        self.ay = self.moveForce / self.mass
      else
        self.ay = -self.moveForce / self.mass
      end
    end
    if rand:random() < 0.001 then
      self:shoot(dt)
    end

  elseif self.state == "stunned" then
    -- do nothing
  end
end

function Enemy:move(dt)
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

function Enemy:chargedForce(elapsed)
  local u = 0.5
  local sigma = 0.25
  return 1 / (sigma * math.sqrt(2 * math.pi)) *
    math.exp(-math.pow(elapsed - u, 2) / (2 * math.pow(sigma, 2)))
end

function Enemy:shoot(dt)
  dt = dt or love.timer.getDelta()
  local dx = hero.x - self.x + rand:random(-64, 64)
  local dy = hero.y - self.y + rand:random(-64, 64)
  local rot = math.atan2(dy, dx)

  local elapsed = rand:random()
  local force = 12000 * self:chargedForce(elapsed)

  local bullet = Bullet:new(self, self.x, self.y, rot)
  bullet:setMoveForce(force)
  bullet:impulse(dt)

  -- TODO global access
  world:add(bullet)

  -- play sound (should be in a before filter or state change callback)
  love.audio.play(Hero.sounds.throw)

end

function Enemy:hurt(dt)
  self.state = "stunned"
  self.stunTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
  love.audio.play(Enemy.sounds.thud)
end

function Enemy:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end
