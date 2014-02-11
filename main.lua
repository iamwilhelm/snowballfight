require('physics')

require('world')
require('hero')
require('enemy')

function love.load()
  world = World:new()
  image = love.graphics.newImage("assets/secretofmana.png")

  hero = Hero:new(300, 400)
  world:add(hero)

  for i = 0, 6 do
    local enemy = Enemy:new(i * 100 + 100, 300)
    world:add(enemy)
  end

  rand = love.math.newRandomGenerator()
  rand:setSeed(os.time())
end

function love.draw()
  -- background
  love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.draw(image)

  -- sky
  love.graphics.setColor(0, 200, 200, 255)
  love.graphics.rectangle("fill", 0, 0, 800, 200)

  -- ground
  love.graphics.setColor(0, 200, 0, 255)
  love.graphics.rectangle("fill", 0, 200, 800, 400)

  -- the order to be drawn should be sorted according to z-order
  --table.sort(world:all(), function(a, b)
  --  return a:bottom() < b:bottom()
  --end)

  -- draw entities
  world:each(function (entity, i)
    entity:draw()
  end)
end

function love.update(dt)
  --------------- physics ----------------

  -- check for collisions between bullets and enemies
  -- for i, bullet in ipairs(world:projectiles()) do
  world:each_projectile(function(bullet, i)
    world:each_enemy(function(enemy, j)
      if physics.isCollide(bullet, enemy) then
        enemy:markForDeletion()
        bullet:markForDeletion()
      end
    end)
  end)

  -- check for collisions between hero and enemies
  -- world:each_enemy(function(enemy, j)
  --   if physics.isCollide(hero, enemy) then
  --     hero:markForDeletion()
  --   end
  -- end)

  -- friction on the ground
  world:each_actor(function(entity, i)
    if entity.drag then
      entity:drag(0.05, dt)
    end
  end)

  -------------- move entities -------------

  -- move all entities
  world:each(function(entity, i)
    entity:update(dt)
  end)

  world:removeOutOfView()
  world:removeMarkedForDeletion()

  world:sortByY()

  -- check for win or lose
end

function love.keyreleased(key)
  if (key == " ") then
    hero:shoot()
  end
end


function love.quit()
  print("Thanks for playing!")
end

