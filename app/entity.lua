require('class')
require('lib/ext/math')

Entity = class:new()

print("Entity")
print(Entity)

-- instance methods

function Entity:init(typename)
  self.typename = typename
  self.toDelete = false

  -- set default and shared values
  self:setDimension(40, 40)
  self:setPosition(0, 0)
  self:setVelocity(0, 0)
  self:setAccel(0, 0)

  self:setMoveForce(5000)
  self:setMass(10)
end

function Entity:setDimension(w, h)
  self.width = w
  self.height = h
end

function Entity:setPosition(x, y)
  self.x = x
  self.y = y
end

function Entity:setVelocity(vx, vy)
  self.vx = vx
  self.vy = vy
end

function Entity:setAccel(ax, ay)
  self.ax = ax
  self.ay = ay
end

function Entity:setMoveForce(force)
  self.moveForce = force
end

function Entity:setMass(mass)
  self.mass = mass
end

function Entity:update(dt)
  self:think(dt)
  self:move(dt)
end

function Entity:think(dt)
  -- no thinking by default
end

function Entity:move(dt)
  self.vx = self.vx + self.ax * dt
  self.x = self.x + self.vx * dt

  self.vy = self.vy + self.ay * dt
  self.y = self.y + self.vy * dt
end

function Entity:markForDeletion()
  self.toDelete = true
end

-- entity state queries

function Entity:left()
  return self.x - self.width / 2
end

function Entity:right()
  return self.x + self.width/ 2
end

function Entity:top()
  return self.y - self.height / 2
end

function Entity:bottom()
  return self.y + self.height / 2
end

