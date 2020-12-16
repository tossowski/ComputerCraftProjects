a = peripheral.wrap("back")
entities = a.getInfectedEntities()
john = a.getInfectedEntity(entities[1])
--john.keyPress("space")
--while true do
  --turtle.dropDown()
--john.click(3)
--sleep(1)

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
  john.keyPress("F")
  sleep(0.5)
end
