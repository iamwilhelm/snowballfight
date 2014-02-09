require('class')

Entity = class:new()

print("Entity table:")
print(Entity)

function Entity.limit(num, cap)
  if num > cap then
    return cap
  end
  if num < -cap then
    return -cap
  end
  return num
end

function Entity:init(x, y, w, h)
  self.width = 30
  self.height = 30

  self.x = x
  self.y = y

  self.vx = 0
  self.vy = 0

  self.ax = 0
  self.ay = 0
end

function Entity:setMaxVelocity(max)
  self.v_max = max
end

function Entity:setMaxAccel(max)
  self.a_max = max
end

function Entity:move(dt)
  self.vx = Entity.limit(self.vx + self.ax * dt, self.v_max)
  self.x = self.x + self.vx * dt

  self.vy = Entity.limit(self.vy + self.ay * dt, self.v_max)
  self.y = self.y + self.vy * dt
end

-- entity state queries

function Entity:bottom()
  return self.y + self.height / 2
end

