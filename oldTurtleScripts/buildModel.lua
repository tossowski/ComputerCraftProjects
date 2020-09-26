m = require "/tools/moveModule"
mio = require "/tools/modelIO"
inv = require "/tools/inventory"
 
blockConfig = inv.getItemDict()
 
dimensions, blocks = mio.loadModelFile("/models/quarkcube.txt")
xLen = dimensions[1]
yLen = dimensions[2]
zLen = dimensions[3]
 
startX, startY, startZ = gps.locate()
 
function handleBlockPlace ()
  
  if turtle.getFuelLevel() < 10 then
    fuelSlot= blockConfig["minecraft:coal"]
    if turtle.getItemCount(fuelSlot) < 10 then
      --blockConfig = inv.refuel()
      while turtle.getItemCount(fuelSlot) < 10 do
        print("I need sustenance")
      end
      turtle.select(fuelSlot)
      turtle.refuel(10)
    else
      turtle.select(fuelSlot)
      turtle.refuel(10)
    end
  end  
        
  xPos, yPos, zPos = gps.locate()
  if xPos == nil then
    print("Error fetching coords")
    return
  end
  
  x = xPos - startX
  y = yPos - startY
  z = startZ - zPos
              
  block = blocks[x .. "-" .. y .. "-" .. z]            
              
  if block ~= nil then
    blockConfig = inv.getItemDict()
    blockIndex = blockConfig[block]
    if blockIndex ~= nil then
      turtle.select(blockIndex)
      success = turtle.placeDown()
      if not success then
        print("Requesting " .. block)
        blockConfig = inv.requestItems(block)
        blockIndex = blockConfig[block]
        turtle.select(blockIndex)
        turtle.placeDown()
      end
    end
  end
end
 
for i = 0, yLen-1, 1 do
  m.moveInXZGrid(xLen, zLen, handleBlockPlace)
  turtle.digUp()
  turtle.up()
  turtle.turnLeft()
  turtle.dig()
  turtle.forward()
  turtle.turnRight()  
end