local inventory = {}
fuelSource = "minecraft:coal"

function inventory.import(colorCode)
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  inventory.dropAll("up")
  rednet.send(13, {["colorCode"]=colorCode}, "import")
  id, message, protocol = rednet.receive("import")
  turtle.digUp()
end

function inventory.export(colorCode, id, amount, metadata, nbt)
  message = {}
  requestInfo = {}
  blockRequest = {}
  requestInfo["amount"] = amount
  requestInfo["metadata"] = metadata
  if nbt ~= nil then
    requestInfo["nbt"] = nbt
  end
  blockRequest[id] = requestInfo
  message["blockRequest"] = blockRequest
  message["colorCode"] = colorCode
  rednet.send(13, message, "export")
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  id, message, protocol = rednet.receive("export")
  while turtle.suckUp() do
  end
  turtle.digUp()
end 
   
function inventory.dropAll(side)
  slotsTaken = {}
  for i = 1, 16, 1 do
    if turtle.getItemCount(i) > 0 then
      slotsTaken[i] = 1
    end
  end
  for k,v in pairs(slotsTaken) do
    turtle.select(k)
    if side == "up" then
      turtle.dropUp()
    elseif side == "front" then
      turtle.drop()
    else
      turtle.dropDown()
    end
  end
  turtle.select(1)
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
