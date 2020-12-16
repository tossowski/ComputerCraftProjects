m = require("/tools/moveModule")
 
selectedSlot = 1
 
function withdrawItems(amount)
  withdrawn = 0
  
  while amount - withdrawn > 64 do
    turtle.suckDown(64)
    withdrawn = withdrawn + 64
    selectedSlot = selectedSlot + 1
    turtle.select(selectedSlot)  
  end
 
  turtle.suckDown(amount - withdrawn)  
end
 
function getBlocks(blockRequest)
  selectedSlot = 1
  success, data = turtle.inspectUp()
  while success do
    if blockRequest[data.name .. data.metadata] ~= nil then
      withdrawItems(blockRequest[data.name 
        .. data.metadata])
    end
  
    turtle.forward()
    table.insert(m.turtleActionStack, 1, turtle.back)
    success, data = turtle.inspectUp()
  end
end
 
function executeTask (x, y, z, blockRequest, recipientID)
  getBlocks(blockRequest)  
  m.moveInXYZGrid(x,y+1,z)  
  
  for i = 1, 16, 1 do
    turtle.select(i)
    turtle.dropDown()
  end
  
  rednet.open("left")
  rednet.send(tonumber(recipientID), "success", "refill")
  rednet.close("left")
  m.backtrack(-1)
  while turtle.dropDown() do
  end     
end
 
rednet.open("left")
rednet.broadcast(os.getComputerLabel(), "register")
rednet.host("refillBots", "refillBot")
dispatcher = rednet.lookup("refillDispatcher")
print("Got response from computer " .. dispatcher)
 
while 1 == 1 do
  id, message, protocol = rednet.receive()
  if protocol == "ping" then
    x,y,z = gps.locate()
    coords={["x"]=x,["y"]=y,["z"]=z}
    rednet.send(id, coords, "ping")
  elseif protocol == "task" then
    rednet.close("left")
    for k, v in pairs(message.blockRequest) do
      print(k,v)
    end
    ok, err = pcall(executeTask(message.x, message.y, 
        message.z, 
        message.blockRequest, 
        message.recipientID))
    rednet.open("left")
    if not ok then
      rednet.broadcast(err,"error")
    end 
  end
end
