
function math.limit(num, cap, cap2)
  if cap2 == nil then
    if num > cap then
      return cap
    end
    if num < -cap then
      return -cap
    end
    return num
  else
    if num > cap2 then
      return cap2
    end
    if num < cap then
      return cap
    end
    return num
  end
end

function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


