inv = require "/tools/inventory"
m = require "/tools/moveModule"

sapling = "minecraft:sapling"
log = "minecraft:log"
itemDict=inv.getItemDict()

 
function chopDownTree()
 
  actionStack = {}
  turtle.dig()
  turtle.forward()
  table.insert(actionStack, 1, turtle.back)
  success, data = turtle.inspectUp()
  
  while success and data.name == log do
    turtle.digUp()
    turtle.up()
    table.insert(actionStack, 1, turtle.down)
    success, data = turtle.inspectUp()
  end
 
  for i = 1, #actionStack, 1 do
    actionStack[i]()
  end

  turtle.down()
  turtle.dig()
  turtle.up()

  turtle.select(itemDict[sapling])
  turtle.place()
 
end
 
 
function checkTree()
  turtle.suckDown()
  success, data = turtle.inspect()
  if success and data.name==log then
    chopDownTree()
  end
end 