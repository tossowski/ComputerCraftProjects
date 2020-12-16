inv = require("/tools/inventory")
storage = nil
targetID = 27

function executeImportTask(colorCode)
  turtle.select(1)
  print(colorCode)
  storage.retrieve("enderstorage:ender_storage", 0, 1, 9, colorCode)
  turtle.placeUp()
  while turtle.suckUp() do
  end
  inv.dropAll("down")
  turtle.select(1)
  turtle.digUp()
  turtle.dropDown()
end

function executeExportTask (colorCode, blockRequest)
  turtle.select(1)
  storage.retrieve("enderstorage:ender_storage", 0, 1, 9, colorCode)
  turtle.placeUp()
  for id, data in pairs(blockRequest) do
    if data.nbt ~= nil then
      storage.retrieve(id, data.metadata, data.amount, 9, data.nbt)
    else
      storage.retrieve(id, data.metadata, data.amount, 9)
    end
    inv.dropAll("up")  
  end
  turtle.digUp()
  turtle.dropDown()      
end
 
storage = peripheral.wrap("front") 
rednet.open("left")
rednet.broadcast(os.getComputerLabel(), "register")
rednet.host("storageBots", "storageBot")
dispatcher = rednet.lookup("storageDispatcher")
--print("Got response from computer " .. dispatcher)
 
while 1 == 1 do
  id, message, protocol = rednet.receive()
  if id == targetID then
    if protocol == "export" then
      rednet.close("left")
      ok, err = pcall(executeExportTask,
          message["colorCode"], 
          message["blockRequest"])
      rednet.open("left")
      rednet.send(targetID, "", "export")
      if not ok then
        rednet.broadcast(err,"error")
      end
    elseif protocol == "import" then
      rednet.close("left")
      ok, err = pcall(executeImportTask,
        message.colorCode)
      rednet.open("left") 
      rednet.send(targetID, "", "import")
    end
  end
end
