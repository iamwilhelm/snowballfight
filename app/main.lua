require('physics')

require('map')
require('world')
require('entity/hero')
require('entity/bullet')
require('entity/enemy')

require('camera')
require('eyesight')

function love.load()
  rand = love.math.newRandomGenerator()
  rand:setSeed(os.time())

  -- load actor assets
  Hero.loadAssets()
  Enemy.loadAssets()
  Bullet.loadAssets()

  -- initialize map and tiles
  map = Map:new(30, 20)
  map:setupTileset("assets/tiles/snow_on_stones.png")

  -- initialize world objects
  world = World:new()

  hero = Hero:new(400, 300)
  world:add(hero)

  for i = 0, 40 do
    local enemy = Enemy:new(i * 100 + 100, 250)
    world:add(enemy)
  end

  -- initialize camera to center of screen
  camera = Camera:new()
  camera:map(map)
  map:track(camera)
  camera:track(hero)

  -- interface objects
  eyesight = Eyesight:new(camera)

  -- misc
  isOverlap = false
end

function love.update(dt)
  --------------- physics ----------------

  -- check for collisions between bullets and enemies
  -- for i, bullet in ipairs(world:projectiles()) do
  world:each_projectile(function(bullet, i)
    world:each_actor(function(actor, j)
      if bullet:isLethalTo(actor) and physics.isCollide(bullet, actor) then
        bullet:hitTarget()
        actor:stun()
        physics.transferMomentum(bullet, actor, 1)
      end
    end)
  end)

  -- friction on the ground
  world:each_actor(function(entity, i)
    if entity.drag then
      entity:drag(0.075, dt)
    end
  end)
  camera:drag(0.1, dt)

  -- mark for deletion for non-moving projectiles
  world:each_projectile(function(bullet, i)
    if math.abs(bullet.vx) < 5 and math.abs(bullet.vy) < 5 then
      bullet:markForDeletion()
    end
  end)

  -------------- entities think -------------

  world:each(function(entity, i)
    entity:think(dt)
  end)
  camera:think(dt)

  -------------- move entities -------------

  world:each(function(entity, i)
    entity:move(dt)
  end)
  camera:move(dt)
  map:move(dt)

  -------------- limit actors to map --------
  world:each_actor(function(entity, i)
    map:putInside(entity)
  end)

  -------------- update interface elements

  eyesight:think(dt)

  -------------- bookkeeping ---------------

  world:removeOutOfView()
  world:removeMarkedForDeletion()

  -- check for win or lose

  if physics.isCollide(eyesight, hero) then
    isOverlap = true
  else
    isOverlap = false
  end
end

function love.draw()
  -- draw the map
  map:draw()

  camera:set()

  -- the order to be drawn should be sorted according to z-order
  world:sortByY()

  -- draw entities
  world:each(function (entity, i)
    entity:draw()
  end)

  -- draw interface
  eyesight:draw()

  camera:unset()

  if isOverlap == true then
    love.graphics.print("overlap", 10, 10)
  end
end

function love.keypressed(key, unicode)
  if (key == "escape") then
    love.event.quit()
  end
end

function love.keyreleased(key)
  if (key == "t") then
    camera:toggleTracking()
  end
end

function love.mousepressed(x, y, button)
  hero:charge(dt)
end

function love.mousereleased(x, y, button)
  hero:shoot(dt)
end

function love.quit()
  print("Thanks for playing!")
end

