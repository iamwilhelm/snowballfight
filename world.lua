require('class')

World = class:new()
print("World")
print(World)

function World:init()
  self._entities = {}
  self._projectiles = {}
end

function World:add(category, entity)
  table.insert(self["_" .. category], entity)
end

function World:remove(category, i)
  table.remove(self["_" .. category], i)
end

function World:all()
  return self:entities() .. self:projectiles()
end

function World:projectiles()
  return self._projectiles
end

function World:entities()
  return self._entities
end

-- should know something about the field of view or bullet range from point of origin
function World:removeAllOutOfView()
  for i, bullet in ipairs(self:projectiles()) do
    if bullet.y < 0 then
      self:remove('projectiles', i)
    end
  end
end



