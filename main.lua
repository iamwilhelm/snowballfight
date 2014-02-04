require('hero')
require('enemy')


function love.load()
  world = {}
  projectiles = {}

  image = love.graphics.newImage("assets/secretofmana.png")

  hero = Hero:new(300, 400)
  table.insert(world, hero)

  for i = 0, 6 do
    local enemy = Enemy:new(i * 100 + 100, 100)
    table.insert(world, enemy)
  end

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

  -- entities
  for i, entity in ipairs(world) do
    entity:draw()
  end

  -- projectiles
  for i, projectile in ipairs(projectiles) do
    projectile:draw()
  end
end

function love.update(dt)
  Bullet.removeAllOutOfView()

  --------------- physics ----------------

  -- all physics
  for i, bullet in ipairs(projectiles) do
    for j, entity in ipairs(world) do
      if checkCollision(bullet.x, bullet.y, bullet.width, bullet.height,
                        entity.x, entity.y, entity.width, entity.height) then
        table.remove(world, j)
        table.remove(projectiles, i)
      end

    end
  end

  -- check for collisions between hero and enemies
  for i, entity in ipairs(world) do
    checkCollision(hero.x, hero.y, hero.width, hero.height,
                   entity.x, entity.y, entity.width, entity.height)
  end

  -------------- move entities -------------

  -- move the bullets
  for i, bullet in ipairs(projectiles) do
    bullet:update(dt)
  end

  -- move all entities in the world
  for i, entity in ipairs(world) do
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

function checkCollision(ax, ay, aw, ah, bx, by, bw, bh)
  local aleft = ax - aw / 2
  local aright = ax + aw / 2
  local atop = ay - ah / 2
  local abottom = ay + ah / 2

  local bleft = bx - bw / 2
  local bright = bx + bw / 2
  local btop = by - bh / 2
  local bbottom = by + bh / 2

  return isOverlap(aleft, aright, bleft, bright)
    and isOverlap(atop, abottom, btop, bbottom)
end

function isOverlap(amin, amax, bmin, bmax)
  return (amax > bmin and amax < bmax) or (amin > bmin and amin < bmax)
    or (bmin > amin and bmin < amax)
end
