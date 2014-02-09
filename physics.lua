
physics = {}

function physics.isCollide(ax, ay, aw, ah, bx, by, bw, bh)
  local aleft = ax - aw / 2
  local aright = ax + aw / 2
  local atop = ay - ah / 2
  local abottom = ay + ah / 2

  local bleft = bx - bw / 2
  local bright = bx + bw / 2
  local btop = by - bh / 2
  local bbottom = by + bh / 2

  return physics.isOverlap(aleft, aright, bleft, bright)
    and physics.isOverlap(atop, abottom, btop, bbottom)
end

function physics.isOverlap(amin, amax, bmin, bmax)
  return (amax > bmin and amax < bmax) or (amin > bmin and amin < bmax)
    or (bmin > amin and bmin < amax)
end
