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
  Hero.images.throwLeft = love.graphics.newImage("assets/sprites/sballer/sballerLthrowLeft.png")
  Hero.images.throwRight = love.graphics.newImage("assets/sprites/sballer/sballerLthrowRight.png")
  Hero.images.windupLeft = love.graphics.newImage("assets/sprites/sballer/sballerLwindupLeft.png")
  Hero.images.windupRight = love.graphics.newImage("assets/sprites/sballer/sballerLwindupRight.png")

  Hero.images.runningHeadLeft = love.graphics.newImage("assets/sprites/sballer/sballerHrunLeft.png")
  Hero.images.runningTorsoLeft = love.graphics.newImage("assets/sprites/sballer/sballerTrunLeft.png")
  Hero.images.runningLegsLeft = love.graphics.newImage("assets/sprites/sballer/sballerLrunLeft.png")

  Hero.images.runningHeadRight = love.graphics.newImage("assets/sprites/sballer/sballerHrunRight.png")
  Hero.images.runningTorsoRight = love.graphics.newImage("assets/sprites/sballer/sballerTrunRight.png")
  Hero.images.runningLegsRight = love.graphics.newImage("assets/sprites/sballer/sballerLrunRight.png")

  Hero.images.stunLeft = love.graphics.newImage("assets/sprites/sballer/sballerLstunLeft.png")
  Hero.images.stunRight = love.graphics.newImage("assets/sprites/sballer/sballerLstunRight.png")
end

function Hero:init(x, y)
  self.__baseclass:init()

  if self ~= Hero then
    self:setPosition(x, y)
    self:setDimension(40, 60)
    self:setMoveForce(5000)
    self:setMass(10)

    self.reelingTimestamp = love.timer.getTime()
    self.windupTimestamp = love.timer.getTime()
    self.throwingTimestamp = love.timer.getTime()

    -- set animations for each state
    -- { animation, width, height, offsetX, offsetY }

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

    self.anim.winduping = {
      left = { all = { newAnimation(Hero.images.windupLeft, 75, 68, 0.1, 0), 58, 69, 0, 0 } },
      right = { all = { newAnimation(Hero.images.windupRight, 75, 68, 0.1, 0), 58, 69, 0, 0 } },
    }
    self.anim.winduping.left.all[1]:setMode('once')
    self.anim.winduping.right.all[1]:setMode('once')

    self.anim.throwing = {
      left = { all = { newAnimation(Hero.images.throwLeft, 75, 68, 0.075, 0), 58, 69, 0, 0 } },
      right = { all = { newAnimation(Hero.images.throwRight, 75, 68, 0.075, 0), 58, 69, 0, 0 } }
    }
    self.anim.throwing.left.all[1]:setMode('once')
    self.anim.throwing.right.all[1]:setMode('once')

    self.anim.reeling = {
      left = { all = { newAnimation(Hero.images.stunLeft, 58, 69, 0.175, 0), 58, 69, 0, 0 } },
      right = { all = { newAnimation(Hero.images.stunRight, 58, 69, 0.175, 0), 58, 69, 0, 0 } },
    }
    self.anim.reeling.left.all[1]:setMode('once')
    self.anim.reeling.right.all[1]:setMode('once')

    self.anim.utils = {
      reset = function(curr_anim)
        for k, e in pairs(curr_anim) do
          anim = e[1]
          anim:reset()
          anim:play()
        end
      end
    }

    self.curr_anim = self.anim.running.left


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
    -- winduping: cocking arm in preparation to throw
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
        { name = 'Stand', from = 'Crouching', to = 'Holding' }, -- timeout activated

        { name = 'OutstretchArms', from = {'Standing', 'Running'}, to = 'Catching' },
        { name = 'TuckArms', from = 'Catching', to = 'Holding' }, -- timeout activated

        { name = 'WindupThrow', from = 'Holding', to ='Winduping' },
        { name = 'ReleaseThrow', from = 'Winduping', to = 'Throwing' },
        { name = 'RecoverThrow', from = 'Throwing', to = 'Standing' },

        { name = 'Hurt',
          from = {'Standing', 'Running', 'Catching', 'Crouching', 'Holding', 'Winduping', 'Throwing' },
          to = 'Reeling' },
        { name = 'Recover', from = 'Reeling', to = 'Standing' },

        { name = 'Block', from = {'Holding', 'Carrying'}, to = 'Standing' },
      },
    })

  end
end

-- callbacks for FSM states

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
  self.anim.utils.reset(self.curr_anim)
end

function Hero:onWinduping(event, from, to)
  if (self.vx <= 0) then
    self.curr_anim = self.anim.winduping.left
  else
    self.curr_anim = self.anim.winduping.right
  end
end

function Hero:onleaveWinduping(event, from, to)
  self.anim.utils.reset(self.curr_anim)
end

function Hero:onThrowing(event, from, to)
  if (self.vx <= 0) then
    self.curr_anim = self.anim.throwing.left
  else
    self.curr_anim = self.anim.throwing.right
  end
end

function Hero:onleaveThrowing(event, from, to)
  self.anim.utils.reset(self.curr_anim)
end

-- callbacks for FSM events

function Hero:onWindupThrow(event, from, to)
  print("event: windup throw -- set windup timestamp")
  self.windupTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
end

function Hero:onReleaseThrow(event, from, to)
  print("event: release throw")
  if (self.vx <= 0) then
    self.curr_anim = self.anim.throwing.left
  else
    self.curr_anim = self.anim.throwing.right
  end
  self.throwingTimestamp = love.timer.getTime()
  love.audio.play(Hero.sounds.throw)
end

function Hero:onRecoverThrow(event, from, to)
  print("event: recover throw")
end

function Hero:onHurt(event, from, to)
  self.reelingTimestamp = love.timer.getTime()
  self:setAccel(0, 0)
  love.audio.play(Hero.sounds.thud)
end


-- drawing methods

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
  if (love.timer.getTime() - self.reelingTimestamp) > 2 then
    self.fsm:Recover()
  end

  if (love.timer.getTime() - self.throwingTimestamp) > 1 then
    self.fsm:RecoverThrow()
  end
end

-- hero specific actions

function Hero:windupForce(elapsed)
  local u = 0.3
  local sigma = 0.25
  return 1 / (sigma * math.sqrt(2 * math.pi)) *
    math.exp(-math.pow(elapsed - u, 2) / (2 * math.pow(sigma, 2)))
end

function Hero:moveLeft(dt)
  self.ax = -self.moveForce / self.mass
  self.fsm:Run()
end

function Hero:moveRight(dt)
  self.ax = self.moveForce / self.mass
  self.fsm:Run()
end

function Hero:moveUp(dt)
  self.ay = -self.moveForce / self.mass
  self.fsm:Run()
end

function Hero:moveDown(dt)
  self.ay = self.moveForce / self.mass
  self.fsm:Run()
end

function Hero:stopHorizontal(dt)
  self.ax = 0
  self.fsm:Stop()
end

function Hero:stopVertical(dt)
  self.ay = 0
  self.fsm:Stop()
end

function Hero:windupThrow(dt)
  print(self.fsm.current)
  self.fsm:Crouch()
  print(self.fsm.current)
  self.fsm:Stand()
  print(self.fsm.current)
  self.fsm:WindupThrow()
  print(self.fsm.current)
end

function Hero:releaseThrow(dt)
  dt = dt or love.timer.getDelta()
  local dx = eyesight.x - self.x
  local dy = eyesight.y - self.y
  local rot = math.atan2(dy, dx)

  local elapsed = love.timer.getTime() - self.windupTimestamp
  print(elapsed)
  local force = 12000 * self:windupForce(elapsed)

  local bullet = Bullet:new(self, self.x, self.y, rot)
  bullet:setMoveForce(force)
  bullet:impulse(dt)

  -- TODO global access
  world:add(bullet)

  self.fsm:ReleaseThrow()
end

function Hero:hurt(dt)
  self.fsm:Hurt()
end

-- draggable

function Hero:drag(friction, dt)
  self.vx = self.vx - friction * self.vx
  self.vy = self.vy - friction * self.vy
end

