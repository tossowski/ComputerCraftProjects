inv = require("/tools/inventory")
moveModule = require("/tools/moveModule")
mio = require("/tools/modelIO")
blocks = mio.loadPainting("/paintings/monkalisa.txt")
itemDict = inv.getItemDict()

function refuel()
    inv.export("minecraft:coal_block", 64, 0)
    itemDict = inv.getItemDict()
    turtle.select(itemDict["minecraft:coal_block0"])
    turtle.refuel()
end

request = {}
request["amount"] = amount
request["metadata"] = metadata
request["nbt"] = nbt
blockRequest[id] = request
message

startX =
startY =
startZ = 

for i = 1, #blocks, 1 do
    if turtle.getFuelLevel() < 100 then
      refuel()
    end
    blockInfo = blocks[i]
    y = blockInfo[1]
    x = blockInfo[2]
    color = blockInfo[4]
    m.moveInXYZGrid(x,y,startZ)
    inv.export("openblocks:paintbrush", 1, 0, color)
    itemDict = inv.getItemDict()
    turtle.place(itemDict["openblocks:paintbrush0"])
    inv.import()
end