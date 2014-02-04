require('hero')
require('enemy')


function love.load()
  image = love.graphics.newImage("assets/secretofmana.png")

  hero = Hero:new(300, 400)

  enemies = {}
  for i = 0, 6 do
    local enemy = Enemy:new(i * 100 + 100, 100)
    table.insert(enemies, enemy)
  end

end

function love.draw()
  -- background
  love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.draw(image)

  -- ground
  love.graphics.setColor(0, 200, 0, 255)
  love.graphics.rectangle("fill", 0, 465, 800, 150)

  -- hero
  hero:draw()

  -- hero shots
  for i, bullet in ipairs(hero.shots) do
    bullet:draw()
  end

  -- enemies
  for i, enemy in ipairs(enemies) do
    enemy:draw()
  end

end

function love.update(dt)
  -- all physics
  for i, bullet in ipairs(hero.shots) do
    for j, enemy in ipairs(enemies) do
      if checkCollision(bullet.x, bullet.y, bullet.width, bullet.height,
                        enemy.x, enemy.y, enemy.width, enemy.height) then
        table.remove(enemies, j)
        table.remove(hero.shots, i)
      end

    end
  end

  -- check for collisions between hero and enemies
  for i, enemy in ipairs(enemies) do
    checkCollision(hero.x, hero.y, hero.width, hero.height,
                  enemy.x, enemy.y, enemy.width, enemy.height)
  end

  -- move the hero
  hero:update(dt)

  -- move the bullets
  for i, bullet in ipairs(hero.shots) do
    bullet:update(dt)
  end
  Bullet.removeAllOutOfView()

  -- move the enemies
  for i, enemy in ipairs(enemies) do
    enemy:update(dt)
    if enemy.y > 465 then
      love.graphics.print('You lose!')
    end
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
