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
  love.graphics.draw(image)

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
    for ii, enemy in ipairs(enemies) do
      if CheckCollision(bullet.x, bullet.y, 2, 5,
                        enemy.x, enemy.y, enemy.width, enemy.height) then
        table.remove(enemies, ii)
        table.remove(hero.shots, i)
      end
    end
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

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 > bx2 and ax2 > bx1 and ay1 > by2 and ay2 > by1
end
