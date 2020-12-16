local inventory = {}
fuelSource = "minecraft:coal"
 
function inventory.dropAll(side)
  local slot = 1
  for i = 1, 16, 1 do
    turtle.select(slot)
    if side == "up" then
      turtle.dropUp()
    elseif side == "front" then
      turtle.drop()
    else
      turtle.dropDown()
    end
    slot = slot + 1
  end
end
 
function inventory.isFull()
  local slot = 1
  for i = 1, 16,1 do
    if turtle.getItemSpace(slot) ~= 0 then
      return false
    end
    slot = slot + 1
  end
  return true
end
 
function inventory.isEmpty()
  local slot = 1
  for i = 1, 16, 1 do
    if turtle.getItemSpace(slot) ~= 64 then
      return false
    end
    slot = slot + 1
  end
  return true
end
 
function inventory.requestItems(blockRequest)
  rednet.open("right")
  message = {}
  x,y,z = gps.locate()
  if x ~= nil then
    message.x = x
    message.y = y
    message.z = z
    message.blockRequest = blockRequest
    rednet.broadcast(message, "refill")
    while message ~= "success" do
      id, message, protocol = rednet.receive("refill")
    end
  else
    print("Could not locate with gps")
    return
  end
  rednet.close("right")    
  return inventory.getItemDict()
end
 
 
 
function inventory.getItemDict ()
  invItems = {}
  for i = 1, 16, 1 do
    slotInfo = turtle.getItemDetail(i)
    if slotInfo ~= nil then
      invItems[slotInfo.name 
      .. slotInfo.damage] = i
    end
  end
  return invItems
end
 
 
 
function inventory.getItemStack (blockID, slot)
-- code to locate chest of items here
  turtle.select(slot)
  turtle.suckUp()
-- code to go back and reset orientation
end
 
return inventory
