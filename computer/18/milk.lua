inv = require("/tools/inventory")
turtle.select(1)
while true do
  turtle.select(1)
  redstone.setOutput("back", true)
  sleep(2)
  redstone.setOutput("back", false)
  turtle.place()
  inv.dropAll()
end
