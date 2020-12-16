idToLabel = {}
local monitor = peripheral.wrap("monitor_0")
monitor.setTextScale(1)
term.redirect(monitor)
term.clear()
term.setCursorPos(1,1)
print("Welcome to Nexus 1.0") 
rednet.open("left")
 
function getBotName(id)
    if idToLabel[id] ~= nil then
      return idToLabel[id] .. " (id " .. id .. ")"
    else
      return "Bot " .. id
    end
end
 
while true do
  id, message, protocol = rednet.receive()
  botName = getBotName(id)
  if protocol == "log" then
    term.setTextColor(colors.green)
    print(botName .. ": " .. message)
  elseif protocol == "error" then
    term.setTextColor(colors.red)
    print(botName .. ": " .. message)
  elseif protocol == "register" then
    term.setTextColor(colors.purple)
    print("Registering " .. message .. " id: " .. id)
    idToLabel[id] = message
  elseif protocol == "backup" then
    term.setTextColor(colors.lightBlue)
    print("Backing Up " .. message)
    id, contents = rednet.receive("fileInfo")
    fs.delete("/disk/" .. message)
    outfile = fs.open("/disk/" .. message, "w")
    outfile.write(contents)
    outfile.flush()
    print("Successfully backed up " .. message)
  end
  term.setTextColor(colors.white)
end
