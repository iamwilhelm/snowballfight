require('physics')

require('world')
require('hero')
require('bullet')
require('enemy')

require('camera')
require('map')

function love.load()
  -- initialize world objects

  world = World:new()

  hero = Hero:new(300, 400)
  world:add(hero)
  for i = 0, 6 do
    local enemy = Enemy:new(i * 100 + 100, 300)
    world:add(enemy)
  end

  -- initialize map and tiles

  image = love.graphics.newImage("assets/secretofmana.png")
  map = Map:new(60, 40)
  map:setupTileset("assets/tileset.png")

  camera = Camera:new(0, 0)

  rand = love.math.newRandomGenerator()
  rand:setSeed(os.time())
end

function love.draw()
  camera:set()

  -- draw the map
  map:draw()

  -- the order to be drawn should be sorted according to z-order
  world:sortByY()

  -- draw entities
  world:each(function (entity, i)
    entity:draw()
  end)

  camera:unset()
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

  camera:update(dt)
  camera:drag(0.05, dt)

  -- check for win or lose
end

function love.keypressed(key, unicode)
  if (key == "escape") then
    love.event.quit()
  end
end

function love.keyreleased(key)
  if (key == " ") then
    hero:shoot()
  end
end


function love.quit()
  print("Thanks for playing!")
end

