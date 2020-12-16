inv = require("/tools/inventory")
m = require("/tools/moveModule")

rednet.open("left")
colorCode = "{Frequency:{middle:0,left:11,right:0}}"
startX = -488
startY = 94
startZ = 181

function refuel()
  inv.export(colorCode, "minecraft:coal_block", 64, 0)
  itemDict = inv.getItemDict()
  turtle.select(itemDict["minecraft:coal_block0"])
  turtle.refuel()
end

for i = 275, 370, 1 do
  for j = 1, 363, 1 do
    if turtle.getFuelLevel() < 20000 then
      refuel()
    end
    m.moveInXYZGrid(startX, startY + i - 1, startZ - j + 1)
    itemDict = inv.getItemDict()
    if itemDict["openblocks:canvas0"] ~= nil then
      turtle.select(itemDict["openblocks:canvas0"])
    else
      inv.export(colorCode, "openblocks:canvas", 896, 0)
      itemDict = inv.getItemDict()
      turtle.select(itemDict["openblocks:canvas0"])
    end
    turtle.placeDown()
  end
end
