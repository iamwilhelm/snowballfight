
physics = {}

function physics.isCollide(entity_a, entity_b)
  return physics.isOverlap(entity_a:left(), entity_a:right(),
                           entity_b:left(), entity_b:right())
    and physics.isOverlap(entity_a:top(), entity_a:bottom(),
                          entity_b:top(), entity_b:bottom())
end

function physics.isOverlap(amin, amax, bmin, bmax)
  return (amax > bmin and amax < bmax) or (amin > bmin and amin < bmax)
    or (bmin > amin and bmin < amax)
end

-- cor: coefficient of restituion. Look it up on wikipedia
function physics.transferMomentum(a, b, cor)
  cor = cor or 1

  local new_a_vx = (cor * b.mass * (b.vx - a.vx) + a.mass * a.vx + b.mass * b.vx) /
                   (a.mass + b.mass)
  local new_a_vy = (cor * b.mass * (b.vy - a.vy) + a.mass * a.vy + b.mass * b.vy) /
                   (a.mass + b.mass)

  local new_b_vx = (cor * a.mass * (a.vx - b.vx) + a.mass * a.vx + b.mass * b.vx) /
                   (a.mass + b.mass)
  local new_b_vy = (cor * a.mass * (a.vy - b.vy) + a.mass * a.vy + b.mass * b.vy) /
                   (a.mass + b.mass)

  a:setVelocity(new_a_vx, new_a_vy)
  b:setVelocity(new_b_vx, new_b_vy)
  a:setAccel(0, 0)
  b:setAccel(0, 0)
end
