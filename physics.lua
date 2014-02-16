
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
