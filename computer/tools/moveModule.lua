local moveModule = {}

--used for reversing actions
moveModule.turtleActionStack = {}
maxActionStackLength = 10000

--initial/current location and direction
--
x, y, z = -117,135,363
turtleDir = 3
 
--[[
Reverses the turtle's previous movements by nSteps number of movements.
Each one block translation or turn is counted as a movement.

Params: nSteps - the number of steps to reverse
--]]
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

--[[
Adds an action to the action stack.

Params: f - action to be added; one block movement or turn
--]]
function moveModule.addToActionStack(f)
  if #moveModule.turtleActionStack == maxActionStackLength then
    table.remove(moveModule.turtleActionStack, maxActionStackLength)
  else
    table.insert(moveModule.turtleActionStack, 1, f)
  end
end

--[[
Function that moves the turtle some number of blocks. Only
moves the turtle forwards, backwards, up, or down. No turns.

Params: distance - number of blocks to move, positive up
or forwards, negative down or backwards
	up - boolean describing if movement is vertical
	positive - boolean describing if distance should
be reversed
--]]
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
   
--[[
Function that moves the turtle to newX, newY, newZ. f is
currently deprecated.

Params - newX, newY, newZ: new location to be moved to
--]]
function moveModule.moveInXYZGrid (newX, newY, newZ,f)
  print(newX, newY, newZ)
  moveModule.move(newY - y, true, true)
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

--[[
Function that turns the turtle to face the specified direction.

Params - dir, the new dir to face. 0N,1E,2S,3W
--]]
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

--[[
Function that sets the turtle's x,y,z, and direction

Params - setx, sety, setz, direction: the x, y, z, and direction
(respectively) to be set.
--]]
function moveModule.set(setx, sety, setz, direction)
    x = setx
    y = sety
    z = setz
    turtleDir = direction
end
return moveModule
