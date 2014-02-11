require('class')

World = class:new()
print("World")
print(World)

function World:init()
  self.entities = {}
end

function World:add(entity)
  table.insert(self.entities, entity)
end

function World:remove(i)
  table.remove(self.entities, i)
end

-- TODO implement method missing, so we don't need all these access methods
-- function World:method_missing(key)
--   print("method missing!")
-- end

function World:all()
  return self.entities
end

function World:each(iter)
  for i, e in ipairs(self:all()) do
    iter(e, i)
  end
end

function World:each_actor(iter)
  for i, e in ipairs(self:all()) do
    if e.typename == "friendly" or e.typename == "enemy" then
      iter(e, i)
    end
  end
end

function World:each_enemy(iter)
  for i, e in ipairs(self:all()) do
    if e.typename == "enemy" then
      iter(e, i)
    end
  end
end

function World:each_projectile(iter)
  for i, e in ipairs(self:all()) do
    if e.typename == "projectile" then
      iter(e, i)
    end
  end
end

-- should know something about the field of view or bullet range from point of origin
function World:removeOutOfView()
  self:each_projectile(function(bullet, i)
    if bullet.y < 0 then
      self:remove(i)
    end
  end)
end

function World:removeMarkedForDeletion()
  self:each(function(entity, i)
    if entity.toDelete == true then
      self:remove(i)
    end
  end)
end

function World:sortByY()
  table.sort(world:all(), function(a, b)
    return a:bottom() < b:bottom()
  end)
end

