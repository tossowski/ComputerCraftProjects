local idToLabel = {}
local monitor = peripheral.wrap("monitor_0")
monitor.setTextScale(1)
term.redirect(monitor)
term.clear()
term.setCursorPos(1,1)
 
rednet.open("right")

function getBotName(id)
    if idToLabel.id ~= nil then
      return idToLabel.id .. " (id " .. id .. ")"
    else
      return "Bot " .. id
    end
end
 
while true do
  id, message, protocol = rednet.receive()
  local botName = getBotName(id)
  if protocol == "log" then
    term.setTextColor(colors.green)
    print(botName .. ": " .. message)
  elseif protocol == "error" then
    term.setTextColor(colors.red)
    print(botName .. ": " .. message)
  term.setTextColor(colors.white)
  elseif protocol == "register" then
    idToLabel[id] = message
  end
end
 
