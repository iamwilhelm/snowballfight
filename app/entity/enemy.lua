require('class')
require('entity')

Enemy = Entity:new("enemy")

print("Enemy")
print(Enemy)

function Enemy.loadAssets()
  Enemy.sounds = {}


  Enemy.images = {}
  Enemy.images.stunLeft = love.graphics.newImage("assets/sprites/sballer/sballerLstunLeft.png")
  Enemy.images.stunRight = love.graphics.newImage("assets/sprites/sballer/sballerLstunRight.png")
  Enemy.images.throwLeft = love.graphics.newImage("assets/sprites/sballer/sballerLthrowLeft.png")
  Enemy.images.throwRight = love.graphics.newImage("assets/sprites/sballer/sballerLthrowRight.png")
  Enemy.images.runLeft = love.graphics.newImage("assets/sprites/sballer/sballerTrunLeft.png")
  Enemy.images.runRight = love.graphics.newImage("assets/sprites/sballer/sballerTrunRight.png")
end

function Enemy:init(x, y)
  self.__baseclass:init()

  if self ~= Enemy then
    self:setPosition(x, y)
    self:setDimension(58, 69)
    self:setMoveForce(2000)
    self:setMass(10)

    self.stunTimestamp = love.timer.getTime()
    self.state = "running"

    -- set animations for each state

    self.anim = {}

    self.anim.stunned = {}
    self.anim.stunned.right = newAnimation(Enemy.images.stunRight, 58, 69, 0.15, 0)
    self.anim.stunned.right:setMode('once')
    self.anim.stunned.left = newAnimation(Enemy.images.stunLeft, 58, 69, 0.15, 0)
    self.anim.stunned.left:setMode('once')


    self.anim.throwing = {}
    self.anim.throwing.right = newAnimation(Enemy.images.throwRight, 75, 68, 0.1, 0)
    self.anim.throwing.left = newAnimation(Enemy.images.throwLeft, 75, 68, 0.1, 0)

    self.anim.running = {}
    self.anim.running.right = newAnimation(Enemy.images.runRight, 34, 33, 0.1, 0)
    self.anim.running.left = newAnimation(Enemy.images.runLeft, 34, 33, 0.1, 0)
  end
end

function Enemy:draw()
  love.graphics.setColor(255, 255, 255, 255)

  if self.state == "running" then

    if self.ax >= 0 then
      self.anim.running.right:draw(self.x, self.y,
                                   0, 1, 1, self.width / 2, self.height / 2)
    elseif self.ax < 0 then
      self.anim.running.left:draw(self.x, self.y,
                                  0, 1, 1, self.width / 2, self.height / 2)
    end

  elseif self.state == "stunned" then
    -- stunned is opposite of direction moving
    if self.vx >= 0 then
      self.anim.stunned.left:draw(self.x, self.y,
                                  0, 1, 1, self.width / 2, self.height / 2)
    elseif self.vx < 0 then
      self.anim.stunned.right:draw(self.x, self.y,
                                   0, 1, 1, self.width / 2, self.height / 2)
    end
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

  elseif self.state == "stunned" then
    -- do nothing
  end
end

function Enemy:move(dt)
  Entity.move(self, dt)

  if self.state == "running" then

    if self.ax >= 0 then
      self.anim.running.right:update(dt)
    elseif self.ax < 0 then
      self.anim.running.left:update(dt)
    end

  elseif self.state == "stunned" then

    if (love.timer.getTime() - self.stunTimestamp) > 2 then
      self.state = "running"
      self.anim.stunned.left:reset()
      self.anim.stunned.left:play()
    else

      if self.vx >= 0 then
        self.anim.stunned.left:update(dt)
      elseif self.vx < 0 then
        self.anim.stunned.right:update(dt)
      end

    end

  end
end

function Enemy:stun(dt)
  self.state = "stunned"
  self.stunTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
end

function Enemy:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end
