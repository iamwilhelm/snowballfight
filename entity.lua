require('class')
require('ext/math')

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

  self:setMaxVelocity(200)
  self:setMaxAccel(400)
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

function Entity:setMaxVelocity(max)
  self.v_max = max
end

function Entity:setMaxAccel(max)
  self.a_max = max
end

function Entity:update(dt)
  self:think(dt)
  self:move(dt)
end

function Entity:think(dt)
  -- no thinking by default
end

function Entity:move(dt)
  self.vx = math.limit(self.vx + self.ax * dt, self.v_max)
  self.x = self.x + self.vx * dt

  self.vy = math.limit(self.vy + self.ay * dt, self.v_max)
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

