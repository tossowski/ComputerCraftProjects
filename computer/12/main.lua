locX, locY, locZ = gps.locate()
rednet.open("right")
rednet.host("refillDispatcher", "dispatcher")
while true do
  id, msg, protocol = rednet.receive()
  if protocol == "refill" then
    msg["recipientID"] = id
    availableBots = {rednet.lookup("refillBots")}
    print(#availableBots .. " bots available")
    if #availableBots == 0 then
      print("No bots available")
    else
      closestBot = 1
      minDist = 100000
      for i = 1, #availableBots do
        rednet.send(availableBots[i], "", "ping")
        id, message, protocol = rednet.receive()
        
        print("Got response from bot " .. id)
        dist = math.abs(message.x - msg.x) 
            + math.abs(message.y - msg.y)
            + math.abs(message.z - msg.z)
        if dist < minDist then
          minDist = dist
          closestBot = availableBots[i]
        end 
      end
      rednet.send(closestBot, msg, "task")
    end      
  end
  
end