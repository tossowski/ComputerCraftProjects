local moveModule = {}
moveModule.turtleActionStack = {}
maxActionStackLength = 10000
x, y, z = -388, 360, 107
turtleDir = 3
 
 
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
                turtle.digUp()
                turtle.up()
                moveModule.addToActionStack(turtle.down)
            else
                turtle.dig()
                turtle.forward()
                moveModule.addToActionStack(turtle.back)
            end
        end
    else
        distance = -1 * distance
        for i=1, distance, 1 do
            if up then
                turtle.digDown()
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
  moveModule.move(newY - y, true, true)
  --0N,1E,2S,3W
  if newX - x > 0 then
      moveModule.face(1)
  elseif newX - x < 0 then
      moveModule.face(3)
  end
  moveModule.move(math.abs(newX - x), false, true)
  if newZ - z > 0 then
      moveModule.face(2)
  elseif newZ - z < 0 then
      moveModule.face(0)
  end
  moveModule.move(math.abs(newZ - z), false, true)
  x, y, z = newX, newY, newZ
end

function moveModule.face(dir)
    difference = turtleDir - dir
    if difference == 0 then
        return
    elseif difference == 1 or difference == -3 then
        turtle.turnLeft()
    elseif difference == 2 or difference == -2 then
        turtle.turnLeft()
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
    turtleDir = dir
end
 
function moveModule.set(setx, sety, setz, direction)
    x = setx
    y = sety
    z = setz
    turtleDir = direction
end
return moveModule
