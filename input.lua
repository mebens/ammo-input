t = {}
t.key = {}
t.mouse = {}
t._maps = {}

function t.define(t, ...)
  if type(t) == "string" then
    t._maps[t] = { key = { ... } }
  else
    if type(t.key) == "string" then t.key = { t.key } end
    if type(t.mouse) == "string" then t.mouse = { t.mouse } end
    t._maps[t[1]] = t
  end
end

function t.pressed(name)
  return t._check(name, "pressed")
end

function t.down(name)
  return t._check(name, "down")
end

function t.released(name)
  return t._check(name, "released")
end

function t.update()
  t.key.pressed = { count = 0 }
  t.key.released = { count = 0 }
  t.mouse.pressed = { count = 0 }
  t.mouse.released = { count = 0 }
  t.mouse.x = love.mouse.getX()
  t.mouse.y = love.mouse.getY()
end

function t.keypressed(key)
  local k = t.key
  k.pressed[key] = true
  k.down[key] = true
  k.pressed.count = k.pressed.count + 1
  k.down.count = k.down.count + 1
end

function t.keyreleased(key)
  local k = t.key
  k.released[key] = true
  k.down[key] = nil
  k.released.count = k.released.count + 1
  k.down.count = k.down.count - 1
end

function t.mousepressed(x, y, button)
  local m = t.mouse
  m.pressed[button] = true
  m.down[button] = true
  m.pressed.count = m.pressed.count + 1
  m.down.count = m.down.count + 1
end

function t.mousereleased(x, y, button)
  local m = t.mouse
  m.released[button] = true
  m.down[button] = nil
  m.released.count = m.released.count + 1
  m.down.count = m.down.count - 1
end

function t._check(name, type)
  local map = t._maps[name]
  
  if map.key then
    for _, v in pairs(map.key) do
      if t.key[type][v] then return true end
    end
  end
  
  if map.mouse then
    for _, v in pairs(map.mouse) do
      if t.mouse[type][v] then return true end
    end
  end
  
  return false
end

for _, v in pairs{"pressed", "down", "released"} do
  t.key[v] = { count = 0 }
  t.mouse[v] = { count = 0 }
end

if not love.keypressed then love.keypressed = t.keypressed end
if not love.keyreleased then love.keyreleased = t.keyreleased end
if not love.mousepressed then love.mousepressed = t.mousepressed end
if not love.mousereleased then love.mousereleased = t.mousereleased end

return t
