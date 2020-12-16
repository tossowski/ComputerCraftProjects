inv = require("/tools/inventory")
mio = require("/tools/modelIO")
m = require("/tools/moveModule")

rednet.open("left")
colorCode = "{Frequency:{middle:0,left:11,right:0}}"
startX = -487
startY = 462
startZ = 181

function refuel()
  inv.export(colorCode, "minecraft:coal_block", 64, 0)
  itemDict = inv.getItemDict()
  turtle.select(itemDict["minecraft:coal_block0"])
  turtle.refuel()
  sleep(5)
end

info = mio.loadModelFile("monkalisa.txt")
for i = 132460, #info, 1 do
  print(i)
  yy = tonumber(info[i][1])
  xx = tonumber(info[i][2])
  c = info[i][3]
  if turtle.getFuelLevel() < 20000 then
    refuel()
  end
  m.moveInXYZGrid(startX, startY -  yy, startZ - xx)
  m.face(3)
  itemDict = inv.getItemDict()
  inv.export(colorCode, "openblocks:paintbrush", 1, 0, "{color:" .. c .. "}")
  itemDict = inv.getItemDict()
  turtle.select(itemDict["openblocks:paintbrush0"])  
  turtle.place()
  inv.import(colorCode)
  sleep(2)
end

