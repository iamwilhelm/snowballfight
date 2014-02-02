require('hero')

function love.load()
  image = love.graphics.newImage("assets/secretofmana.png")

  hero = Hero:new(300, 400)

  enemies = {}

  for i = 0, 7 do
    enemy = {}
    enemy.width = 40
    enemy.height = 20
    enemy.x = i * (enemy.width + 60) + 100
    enemy.y = enemy.height + 100
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
  love.graphics.setColor(255, 255, 255, 255)
  for i, v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end

  -- enemies
  love.graphics.setColor(0, 255, 255, 255)
  for i, v in ipairs(enemies) do
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    hero:moveLeft(dt)
  elseif love.keyboard.isDown("right") then
    hero:moveRight(dt)
  end

  local remEnemy = {}
  local remShot = {}

  for i, v in ipairs(hero.shots) do
    -- move shots up
    v.y = v.y - dt * 100

    if v.y < 0 then
      table.insert(remShot, i)
    end

    for ii, vv in ipairs(enemies) do
      if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
        table.insert(remEnemy, ii)
        table.insert(remShot, i)
      end
    end

  end

  for i, v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end

  for i, v in ipairs(remShot) do
    table.remove(hero.shots, v)
  end

  for i, v in ipairs(enemies) do
    v.y = v.y + dt
    if v.y > 465 then
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
