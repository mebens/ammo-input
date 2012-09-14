local input = {}
input.key = {}
input.mouse = {}
input._maps = {}

function input.define(t, ...)
  if type(t) == "string" then
    input._maps[t] = { key = { ... } }
  else
    if type(t.key) == "string" then t.key = { t.key } end
    if type(t.mouse) == "string" then t.mouse = { t.mouse } end
    input._maps[t[1]] = t
  end
end

function input.pressed(name)
  return input.check(name, "pressed")
end

function input.down(name)
  return input.check(name, "down")
end

function input.released(name)
  return input.check(name, "released")
end

function input.axisPressed(negative, positive)
  return input.checkAxis(negative, positive, "pressed")
end

function input.axisDown(negative, positive)
  return input.checkAxis(negative, positive, "down")
end

function input.axisReleased(negative, positive)
  return input.checkAxis(negative, positive, "released")
end

function input.check(name, type)
  local map = input._maps[name]
  
  if map.key then
    for _, v in pairs(map.key) do
      if input.key[type][v] then return true end
    end
  end
  
  if map.mouse then
    for _, v in pairs(map.mouse) do
      if input.mouse[type][v] then return true end
    end
  end
  
  return false
end

function input.checkAxis(negative, positive, type)
  local axis = 0
  if input.check(negative, type) then axis = axis - 1 end
  if input.check(positive, type) then axis = axis + 1 end
  return axis
end

function input.update()
  input.key.pressed = { count = 0 }
  input.key.released = { count = 0 }
  input.mouse.pressed = { count = 0 }
  input.mouse.released = { count = 0 }
  input.mouse.x = love.mouse.getX()
  input.mouse.y = love.mouse.getY()
end

function input.keypressed(key)
  local k = input.key
  k.pressed[key] = true
  k.down[key] = true
  k.pressed.count = k.pressed.count + 1
  k.down.count = k.down.count + 1
end

function input.keyreleased(key)
  local k = input.key
  k.released[key] = true
  k.down[key] = nil
  k.released.count = k.released.count + 1
  k.down.count = k.down.count - 1
end

function input.mousepressed(x, y, button)
  local m = input.mouse
  m.pressed[button] = true
  m.down[button] = true
  m.pressed.count = m.pressed.count + 1
  m.down.count = m.down.count + 1
end

function input.mousereleased(x, y, button)
  local m = input.mouse
  m.released[button] = true
  m.down[button] = nil
  m.released.count = m.released.count + 1
  m.down.count = m.down.count - 1
end

for _, v in pairs{"pressed", "down", "released"} do
  input.key[v] = { count = 0 }
  input.mouse[v] = { count = 0 }
end

if not love.keypressed then love.keypressed = input.keypressed end
if not love.keyreleased then love.keyreleased = input.keyreleased end
if not love.mousepressed then love.mousepressed = input.mousepressed end
if not love.mousereleased then love.mousereleased = input.mousereleased end

return input
