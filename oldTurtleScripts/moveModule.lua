local moveModule = {}
 
turtleDir = 0
 
function moveModule.faceDirection (dir)
  while turtleDir ~= dir do
    turtle.turnLeft()
    turtleDir = (turtleDir + 1) % 4
  end    
end
 
function moveModule.getLoc ()
  local x, y, z = gps.locate(5)
  if not x then
    return nil
  else
    return vector.new(x, y, z)
  end
end
 
function moveModule.moveForward (x)
  for i = 1, x, 1 do
    turtle.dig()
    turtle.forward()
  end
end
 
function moveModule.moveInXZGrid (xLen,zLen,f)
  for i = 0, zLen-1, 1 do
    for j = 0, xLen-1, 1 do
      if f ~= nil then
        f()
      end
      turtle.dig()
      turtle.forward()
     end
    if f ~= nil then
      f()
    end
    if i % 2 == 0 then
      turtle.turnLeft()
      turtle.dig()
      turtle.forward()
      turtle.turnLeft()
    else
      turtle.turnRight()
      turtle.dig()
      turtle.forward()
      turtle.turnRight()
    end
  end
end
 
return moveModule