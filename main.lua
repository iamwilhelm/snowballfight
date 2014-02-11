require('physics')

require('world')
require('hero')
require('enemy')

function love.load()
  world = World:new()
  image = love.graphics.newImage("assets/secretofmana.png")

  hero = Hero:new(300, 400)
  world:add('entities', hero)

  for i = 0, 6 do
    local enemy = Enemy:new(i * 100 + 100, 300)
    world:add('entities', enemy)
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
  table.sort(world, function(a, b)
    return a:bottom() < b:bottom()
  end)

  -- entities
  for i, entity in ipairs(world:entities()) do
    entity:draw()
  end

  -- projectiles
  for i, projectile in ipairs(world:projectiles()) do
    projectile:draw()
  end
end

function love.update(dt)
  world:removeAllOutOfView()

  --------------- physics ----------------

  -- check for collisions between bullets and enemies
  for i, bullet in ipairs(world:projectiles()) do
    for j, entity in ipairs(world:entities()) do
      if physics.isCollide(bullet.x, bullet.y, bullet.width, bullet.height,
                           entity.x, entity.y, entity.width, entity.height) then
        world:remove('entities', j)
        world:remove('projectiles', i)
      end
    end
  end

  -- check for collisions between hero and enemies
  for i, entity in ipairs(world:entities()) do
    --physics.isCollide(hero.x, hero.y, hero.width, hero.height,
    --                  entity.x, entity.y, entity.width, entity.height)
  end

  -- friction on the ground
  for i, entity in ipairs(world:entities()) do
    if entity.drag then
      entity:drag(0.05, dt)
    end
  end

  -------------- move entities -------------

  -- move the bullets
  for i, bullet in ipairs(world:projectiles()) do
    bullet:update(dt)
  end

  -- move all entities in the world
  for i, entity in ipairs(world:entities()) do
    entity:update(dt)
  end

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

