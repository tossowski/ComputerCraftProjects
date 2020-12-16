inv = require("/tools/inventory")
color = 0
colors = {[1]=1, [2]=7, [3]=14, [4]=12}
 
while true do
  while not inv.isFull() do
    turtle.suckUp()
  end
  
  inv.dropAll()
  
  for i = 1, colors[color + 1], 1 do
    redstone.setOutput("back", true)
    sleep(1)
    redstone.setOutput("back", false)
    sleep(3)
  end 
  
  color = (color + 1) % #colors
  while not inv.isFull() do
    turtle.suckDown()
  end
  
  inv.dropAll("front")
end
