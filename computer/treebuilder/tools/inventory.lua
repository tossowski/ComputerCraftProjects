local inventory = {}
fuelSource = "minecraft:coal"

function inventory.import(colorCode)
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  inventory.dropAll("up")
  shell.run("equip", itemDict["computercraft:advanced_modem0"], "right")
  rednet.open("right")
  rednet.send(26, {["colorCode"]=colorCode}, "import")
  id, message, protocol = rednet.receive("import")
  itemDict = inventory.getItemDict()
  shell.run("equip", itemDict["minecraft:diamond_pickaxe0"], "right")
  turtle.digUp()
end

function inventory.export(colorCode, id, amount, metadata, nbt)
  itemDict = inventory.getItemDict()
  shell.run("equip", itemDict["computercraft:advanced_modem0"], "right")
  sleep(3)
  rednet.open("right")
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
  rednet.send(26, message, "export")
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  id, message, protocol = rednet.receive("export")
  while turtle.suckUp() do
  end
  itemDict = inventory.getItemDict()
  print("Equipping pickaxe...")
  print(itemDict["minecraft:pickaxe0"])
  shell.run("equip", itemDict["minecraft:diamond_pickaxe0"], "right")
  turtle.digUp()
end 
   
function inventory.dropAll(side, blacklist)
  slotsTaken = {}
  for i = 1, 16, 1 do
    if turtle.getItemCount(i) > 0 then
      valid = true
      if blacklist ~= nil then
        for j = 1, #blacklist, 1 do
          data = turtle.getItemDetail(i)
          if blacklist[j] == data.name then
            valid = false
            break
          end
        end
      end
      if valid then
        slotsTaken[i] = 1  
      end
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