require('class')

World = class:new()
print("World")
print(World)

function World:init()
  self._friendlies = {}
  self._enemies = {}
  self._projectiles = {}
end

function World:add(category, entity)
  table.insert(self["_" .. category], entity)
end

function World:remove(category, i)
  table.remove(self["_" .. category], i)
end

function World:each(iter)
  local count = 0
  self:each_actor(function(e, i)
    iter(e, count)
    count = count + 1
  end)
  self:each_projectile(function(e, i)
    iter(e, count)
    count = count + 1
  end)
end

function World:each_actor(iter)
  for i, e in ipairs(self:friendlies()) do
    iter(e, i)
  end
  for i, e in ipairs(self:enemies()) do
    iter(e, table.getn(self:friendlies()) + i)
  end
end

function World:each_enemy(iter)
  for i, e in ipairs(self:enemies()) do
    iter(e, i)
  end
end

function World:each_projectile(iter)
  for i, e in ipairs(self:projectiles()) do
    iter(e, i)
  end
end

function World:friendlies()
  return self._friendlies
end

function World:enemies()
  return self._enemies
end

function World:projectiles()
  return self._projectiles
end

-- should know something about the field of view or bullet range from point of origin
function World:removeAllOutOfView()
  for i, bullet in ipairs(self:projectiles()) do
    if bullet.y < 0 then
      self:remove('projectiles', i)
    end
  end
end



