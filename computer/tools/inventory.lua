local inventory = {}

--fuel the turtle will try to use
fuelSource = "minecraft:coal"

--id of the bot to refill with
targetRefillBot = 13

--[[
Function that causes the turtle to send its blacklisted inventory
back to the main system using the ender chest of the specified 
color code

Params: colorCode - the color code of the ender chest to be used
	blacklist - list of items to be sent back to the main system
--]]
function inventory.import(colorCode, blacklist)
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  inventory.dropAll("up", blacklist)
  shell.run("equip", itemDict["computercraft:advanced_modem0"], "right")
  rednet.open("right")
  ok, err = pcall(rednet.send, targetRefillBot, {["colorCode"]=colorCode}, "import")
  while not ok do
    print("Import Oopsie")
    sleep(5)
    ok, err = pcall(rednet.send, targetRefillBot, {["colorCode"]=colorCode}, "import")
  end
  --rednet.send(targetRefillBot, {["colorCode"]=colorCode}, "import")
  id, message, protocol = rednet.receive("import")
  itemDict = inventory.getItemDict()
  shell.run("equip", itemDict["minecraft:diamond_pickaxe0"], "right")
  turtle.digUp()
end

--[[
Function that causes the turtle to get items from the main system
using the ender chest matching the color code, with the id being
the id of the request, and amount, metadata, and nbt describing
the requested item.

Params: colorCode - ender chest to be used
	id - request id
	amount - amount of item requested
	metadata - metadata of item requested
	nbt - nbt of item requested
--]]
function inventory.export(colorCode, id, amount, metadata, nbt)
  itemDict = inventory.getItemDict()
  shell.run("equip", itemDict["computercraft:advanced_modem0"], "right")
  print("Before open")
  rednet.open("right")
  print("After open")
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
  ok, err = pcall(rednet.send, targetRefillBot, message, "export")
  while not ok do
    print("Oopsies")
    sleep(5)
    ok, err = pcall(rednet.send, targetRefillBot, message, "export")
  end
 -- rednet.send(targetRefillBot, message, "export")
  print("After send")
  itemDict = inventory.getItemDict()
  turtle.select(itemDict["enderstorage:ender_storage0"])
  turtle.placeUp()
  id, message, protocol = rednet.receive("export")
  print("After receive")
  while turtle.suckUp() do
  end
  itemDict = inventory.getItemDict()
  
  shell.run("equip", itemDict["minecraft:diamond_pickaxe0"], "right")
  turtle.digUp()
end 
  
--[[
Function that cuases the turtle to drop all items in the blacklist
from the specified side (top or bottom)

Params: side - side to be dropped from
	blacklist - list of items to be dropped
--]]
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

[[
Function that returns true if the inventory is full,
and false otherwise

Returns: a boolean describing if the inventory is full
]]
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

[[
Function that returns true if the inventory is empty,
and false otherwise

Returns: a boolean describing if the inventory is empty
]]
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

--[[
Deprecated function that requests blocks in blockRequest to
position x, y, z

Params: blockRequest - the blocks to be requested
--]]
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
 
--[[
Function that returns the item descriptions of all items
in the turtle inventory

Returns: a dictionary of all items in the turtle inventory,
with the key being the location and the value being item 
description
--]]
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
 
--[[
Function that gets a stack of items from a chest

Params: blockID - block ID of block to be gotten
	slot - slot of turtle to be put into
--]]
function inventory.getItemStack (blockID, slot)
-- code to locate chest of items here
  turtle.select(slot)
  turtle.suckUp()
-- code to go back and reset orientation
end
 
return inventory
