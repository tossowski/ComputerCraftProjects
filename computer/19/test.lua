for k,v in pairs(peripheral.getNames()) do
  print(k, v)
end
antenna = peripheral.wrap("top")
print(antenna.getPlayerName())
