local moveModule = {}
moveModule.turtleActionStack = {}
maxActionStackLength = 10000
x, y, z = gps.locate()
turtle.forward()
nX, nY, nZ = gps.locate()
turtle.back()
turtleDir = 0
if nX > x then
    turtleDir = 1
elseif nX < x then
    turtleDir = 3
elseif nZ > z then
    turtleDir = 2
else
    turtleDir = 0
end
 
 
function moveModule.backtrack(nSteps)
  if nSteps == -1 or nSteps > #moveModule.turtleActionStack then
    nSteps = #moveModule.turtleActionStack
  end
  
  for i = 1, nSteps, 1 do
    if #moveModule.turtleActionStack > 0 then
      moveModule.turtleActionStack[1]()
      table.remove(moveModule.turtleActionStack, 1)
    end
  end
end
 
function moveModule.addToActionStack(f)
  if #moveModule.turtleActionStack == maxActionStackLength then
    table.remove(moveModule.turtleActionStack, maxActionStackLength)
  else
    table.insert(moveModule.turtleActionStack, 1, f)
  end
end
 
function moveModule.move (distance, up, positive)
    if not positive then
        distance = distance * -1
    end
    if distance > 0 then
        for i=1,distance,1 do
            if up then
                turtle.up()
                moveModule.addToActionStack(turtle.down)
            else
                turtle.forward()
                moveModule.addToActionStack(turtle.back)
            end
        end
    else
        distance = -1 * distance
        for i=1, distance, 1 do
            if up then
                turtle.down()
                moveModule.addToActionStack(turtle.up)
            else
                turtle.back()
                moveModule.addToActionStack(turtle.forward)
            end
        end
    end
end
    
function moveModule.moveInXYZGrid (newX, newY, newZ,f)
  x, y, z = gps.locate()
  moveModule.move(newY - y, true, true)
  --0N,1E,2S,3W
  if newX ~= x then
      if (turtleDir % 2) == 0 then
          turtle.turnRight()
          moveModule.addToActionStack(turtle.turnLeft)
          turtleDir = (turtleDir + 1) % 4
      end
  end
  moveModule.move(newX - x, false,
      turtleDir == 1)
  if newZ ~= z then
      if (turtleDir % 2) == 1 then
          turtle.turnRight()
          moveModule.addToActionStack(turtle.turnLeft)
          turtleDir = (turtleDir + 1) % 4
      end
  end
  moveModule.move(newZ - z, false,
      turtleDir == 2)
  x2, y2, z2 = gps.locate()
  if x2 ~= newX or y2 ~= newY or z2 ~= newZ then
      location = "x:" .. x2 .. " y:" .. y2 .. " z:" .. z2
      if turtle.getFuelLevel() == 0 then
          error("Turtle ran out of fuel at " .. location, 0)
      else
          error("Turtle encountered an obstacle at " .. location, 0)
      end
  end
end
 
return moveModule