for k,v in pairs(peripheral.getNames()) do
  print(k,v)
end
storage = peripheral.wrap("front")
storage.retrieve("minecraft:cobblestone", 0, 900, 0)
