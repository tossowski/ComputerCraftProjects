inv = require("/tools/inventory")
mio = require("/tools/modelIO")
a = peripheral.wrap("back")
entities = a.getInfectedEntities()
john = a.getInfectedEntity(entities[1])

blocks = mio.loadModelFile("/venusaurModel.txt")

colors = {}
for i = 1, #blocks, 1 do
  if colors[blocks[i][4]] ~= nil then
  else
    colors[blocks[i][4]] = 1
  end
end

sleep(10)
turtle.select(1)
for color, v in pairs(colors) do
  while turtle.getItemCount() == 0 do
    redstone.setOutput("left", true)
    sleep(2)
    redstone.setOutput("left", false)
    sleep(2)
  end
  sleep(1)
  turtle.dropDown()
--hex code
  john.click(3)
  sleep(0.5)
  john.mouseMove(998, 525)
  sleep(0.5)
  john.click(1)
  sleep(0.5)
  for j = 1, 6, 1 do
    john.keyPress("back_space")
    sleep(0.5)
  end
  for j = 1, 6, 1 do
    john.keyPress(string.sub(color, j, j))
    sleep(0.5)
  end
  -- on mix button
  john.mouseMove(1050,450)
  sleep(0.5)
  john.click(1)
  redstone.setOutput("right", true)
  sleep(1)
  redstone.setOutput("right", false)
  sleep(15)
  john.keyPress("escape")
  turtle.suckDown()
  turtle.place()
  sleep(1)
  john.click(3)
  sleep(1)
  john.click(1)
  sleep(2)
  john.keyPress("1")
  sleep(0.5)
  john.keyPress("q")
  
  while not turtle.suck() do
  end
  sleep(1)
  john.keyPress("2")
  sleep(0.5)
  john.keyPress("q")
  sleep(0.5)
  while not turtle.suck() do
  end
  sleep(1)
  inv.dropAll("up")
  turtle.select(1)
  john.keyPress("1")
  sleep(0.5)
end  
  --end
