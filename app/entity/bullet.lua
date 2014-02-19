require('entity')

Bullet = Entity:new("projectile")

print("Bullet")
print(Bullet)

function Bullet.loadAssets()
  Bullet.sounds = {}
  Bullet.sounds.splat = love.audio.newSource("assets/sounds/snow_splat.mp3")
end

function Bullet:init(x, y, rot)
  self.__baseclass:init(x, y)

  if self ~= Bullet then
    self:setDimension(20, 20)
    self:setPosition(x, y)
    self:setMass(5)
    self:setMoveForce(20000)
    self.rot = rot

    -- TODO global
    self.hero = hero

    self.z = 0.75 * self.hero.height
    self.vz = 0
  end
end

function Bullet:move(dt)
  Entity.move(self, dt)

  -- a hack for making snowballs fall to the ground
  self.vz = self.vz - 30 * 9.81 * dt
  self.z = self.z + self.vz * dt
  if self.z < 0 then
    self:markForDeletion()
  end
end

function Bullet:impulse(dt)
  local ax = self.moveForce / self.mass * math.cos(self.rot)
  local ay = self.moveForce / self.mass * math.sin(self.rot)
  local fudgeDt = 0.1
  self.vx = self.vx + ax * fudgeDt
  self.vy = self.vy + ay * fudgeDt
end

-- TODO use global sound
function Bullet:hitTarget()
  self:markForDeletion()
  love.audio.play(Bullet.sounds.splat)
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle("fill", self.x,
    self.y + (0.75 * self.hero.height - self.z),
    self.width / 2)
end


