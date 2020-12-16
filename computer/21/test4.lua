a = peripheral.wrap("back")
entities = a.getInfectedEntities()
john = a.getInfectedEntity(entities[1])
for k,v in pairs(entities) do
  print(k, v)
end
sleep(1)
john.mouseMove(500,0)
