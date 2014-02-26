require('lib/ext/math')
require('lib/AnAL')
local statemachine = require('lib/statemachine')
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
    self:setMoveForce(5000)
    self:setMass(10)

    self.stunTimestamp = love.timer.getTime()
    self.chargeTimestamp = love.timer.getTime()

    -- All the possible states and descriptions
    --
    -- standing: not moving with nothing in hands
    -- holding: not moving with something in hands
    -- crouching: not moving and stooped low (making a snowball)
    -- catching: not moving with hands outstretched to catch
    --
    -- running: moving around without anything in hands
    -- carrying: moving around with something in hands
    --
    -- winding_up: cocking arm in preparation to throw
    -- throwing: throwing snowball
    --
    -- reeling: got hit by a snowball
    --
    -- idleing: not moving, but keeping oneself busy
    --
    self.fsm = statemachine.create({
      metatable = self,
      initial = 'Standing',
      events = {
        { name = 'Run', from = 'Standing', to = 'Running' },
        { name = 'Stop', from = 'Running', to = 'Standing' },

        { name = 'Run', from = 'Holding', to = 'Carrying' },
        { name = 'Stop', from = 'Carrying', to = 'Holding' },

        -- cannot crouch if holding/carrying something
        { name = 'Crouch', from = {'Standing', 'Running'}, to = 'Crouching' },
        { name = 'Stand', from = 'Crouch', to = 'Holding' }, -- timeout activated

        { name = 'Outstretch_arms', from = {'Standing', 'Running'}, to = 'Catching' },
        { name = 'Tuck_arms', from = 'Catching', to = 'Holding' }, -- timeout activated

        { name = 'Windup_throw', from = 'Holding', to ='Winduping' },
        { name = 'Release_throw', from = 'Winduping', to = 'Throwing' },
        { name = 'Recover_throw', from = 'Throwing', to = 'Standing' },

        { name = 'Hurt',
          from = {'Standing', 'Running', 'Catching', 'Crouching', 'Holding', 'Winduping'},
          to = 'Reeling' },
        { name = 'Recover', from = 'Reeling', to = 'Standing' },

        { name = 'Block', from = {'Holding', 'Carrying'}, to = 'Standing' },
      },
    })

    -- set animations for each state

    self.anim = {}

    self.anim.standing = {
      left = {
        head = { newAnimation(Hero.images.runningHeadLeft, 31, 30, 0.1, 0), 31, 30, 0, 20 - 4 },
        torso = { newAnimation(Hero.images.runningTorsoLeft, 34, 33, 0.1, 0), 34, 33, 0, -4 },
        legs = { newAnimation(Hero.images.runningLegsLeft, 38, 30, 0.1, 0), 38, 30, 8, -12 - 4 },
      },
      right = {
        head = { newAnimation(Hero.images.runningHeadRight, 31, 30, 0.1, 0), 31, 30, 0, 20 - 3 },
        torso = { newAnimation(Hero.images.runningTorsoRight, 34, 33, 0.1, 0), 34, 33, 0, -4 },
        legs = { newAnimation(Hero.images.runningLegsRight, 38, 30, 0.1, 0), 38, 30, -8, -12 - 4},
      }
    }

    self.anim.running = {
      left = {
        -- { animation, width, height, offsetX, offsetY }
        head = { newAnimation(Hero.images.runningHeadLeft, 31, 30, 0.1, 0), 31, 30, 0, 20 - 4 },
        torso = { newAnimation(Hero.images.runningTorsoLeft, 34, 33, 0.1, 0), 34, 33, 0, -4 },
        legs = { newAnimation(Hero.images.runningLegsLeft, 38, 30, 0.1, 0), 38, 30, 8, -12 - 4 },
      },
      right = {
        head = { newAnimation(Hero.images.runningHeadRight, 31, 30, 0.1, 0), 31, 30, 0, 20 - 3 },
        torso = { newAnimation(Hero.images.runningTorsoRight, 34, 33, 0.1, 0), 34, 33, 0, -4 },
        legs = { newAnimation(Hero.images.runningLegsRight, 38, 30, 0.1, 0), 38, 30, -8, -12 - 4},
      }
    }

    self.anim.throwing = {
      left = { all = { newAnimation(Hero.images.throwLeft, 75, 68, 0.1, 0), 58, 69, 0, 0 } },
      right = { all = { newAnimation(Hero.images.throwRight, 75, 68, 0.1, 0), 58, 69, 0, 0 } }
    }

    -- 58 / 2, 69 / 2)
    self.anim.reeling = {
      left = { all = { newAnimation(Hero.images.stunLeft, 58, 69, 0.175, 0), 58, 69, 0, 0 } },
      right = { all = { newAnimation(Hero.images.stunRight, 58, 69, 0.175, 0), 58, 69, 0, 0 } },
    }
    self.anim.reeling.left.all[1]:setMode('once')
    self.anim.reeling.right.all[1]:setMode('once')

    self.curr_anim = self.anim.running.left
  end
end

function Hero:onStanding(event, from, to)
  if (self.vx <= 0) then
    self.curr_anim = self.anim.standing.left
  else
    self.curr_anim = self.anim.standing.right
  end
end

function Hero:onRunning(event, from, to)
  if (self.vx <= 0) then
    self.curr_anim = self.anim.running.left
  else
    self.curr_anim = self.anim.running.right
  end
end

function Hero:onenterReeling(event, from, to)
  if (self.vx >= 0) then
    self.curr_anim = self.anim.reeling.left
  else
    self.curr_anim = self.anim.reeling.right
  end
end

function Hero:onleaveReeling(event, from, to)
  for k, e in pairs(self.curr_anim) do
    anim = e[1]
    anim:reset()
    anim:play()
  end
end

function Hero:onHurt(event, from, to)
  self.stunTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
  love.audio.play(Hero.sounds.thud)
end

function Hero:draw_bounding_box()
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.rectangle("fill",
    self.x - self.width / 2,
    self.y - self.height / 2,
    self.width, self.height)
end

function Hero:draw()
  self:draw_bounding_box()

  love.graphics.setColor(255, 255, 255, 255)
  for k, e in pairs(self.curr_anim) do
    anim = e[1]
    anim:draw(self.x, self.y, 0, 1, 1, e[2] / 2 + e[4], e[3] / 2 + e[5])
  end

end

-- hero update actions

function Hero:think(dt)
  if self.fsm.current == "Standing" or self.fsm.current == "Running" then
    if love.keyboard.isDown("a") then
      self:moveLeft(dt)
      self.fsm:Run()
    elseif love.keyboard.isDown("d") then
      self:moveRight(dt)
      self.fsm:Run()
    else
      self:stopHorizontal(dt)
      self.fsm:Stop()
    end

    if love.keyboard.isDown("w") then
      self:moveUp(dt)
      self.fsm:Run()
    elseif love.keyboard.isDown("s") then
      self:moveDown(dt)
      self.fsm:Run()
    else
      self:stopVertical(dt)
      self.fsm:Stop()
    end

    if love.keyboard.isDown("q") then
      self:stun(dt)
    end
  elseif self.fsm.current == "Reeling" then
    -- do nothing
  end
end

function Hero:move(dt)
  Entity.move(self, dt)

  for k, e in pairs(self.curr_anim) do
    anim = e[1]
    anim:update(dt)
  end

  -- timers to trigger states
  if (love.timer.getTime() - self.stunTimestamp) > 2 then
    self.fsm:Recover()
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
  local u = 0.3
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
  local force = 12000 * self:chargedForce(elapsed)

  local bullet = Bullet:new(self, self.x, self.y, rot)
  bullet:setMoveForce(force)
  bullet:impulse(dt)

  -- TODO global access
  world:add(bullet)

  -- play sound (should be in a before filter or state change callback)
  love.audio.play(Hero.sounds.throw)
end

function Hero:hurt(dt)
  self.fsm:Hurt()
end

-- draggable

function Hero:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end

