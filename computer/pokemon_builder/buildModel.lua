m = require "/tools/moveModule"
--mio = require "/tools/scuffedModelIO"
mio = require "/tools/modelIO"
inv = require "/tools/inventory"
blacklist = {[1]="enderstorage:ender_storage", [2]="computercraft:advanced_modem", [3]="minecraft:diamond_pickaxe", [4]="openblocks:canvas"}
blockConfig = inv.getItemDict()
blocks = mio.loadModelFile("/models/venusaurModel.txt") 
startX, startY, startZ = -196, 70, 238
blockNum = 49548
colorCode = "{Frequency:{middle:0,left:11,right:0}}"
   
function getBlockRequest()
  slotsUsed = 0
  for i = 1, 16, 1 do
    if turtle.getItemDetail(i) ~= nil then
      slotsUsed = slotsUsed + 1
    end
  end
  blockRequest = {}

  while blockNum <= #blocks and
    slotsUsed < 12 do
    block = blocks[blockNum]
    blockName = "openblocks:canvas"
    meta = 0
    if blockRequest[blockName] ~= nil then
      amt = blockRequest[blockName]["amt"]
      if amt % 64 == 0 then
        slotsUsed = slotsUsed + 1
      end
      blockRequest[blockName]["amt"] = amt + 1
    else
      blockRequest[blockName] = {["amt"]=1, ["meta"]=meta}
      slotsUsed = slotsUsed + 1
    end
    blockNum = blockNum + 1
      
  end
  
  return blockRequest
end
 
function handleBlockPlace (x2,y2,z2,blockID, color)
  m.moveInXYZGrid(x2 + startX, y2 + startY, z2 + startZ)
--  print(color)
  if turtle.getFuelLevel() < 10000 then
    turtle.digUp()
    inv.export(colorCode, "minecraft:coal_block", 64, 0)
    blockConfig = inv.getItemDict()
    fuelSlot= blockConfig["minecraft:coal_block0"]
    turtle.select(fuelSlot)
    turtle.refuel(64)
    sleep(5)
  end 
   
              
  blockConfig = inv.getItemDict()
  blockIndex = blockConfig[blockID]
  turtle.digDown()
  if blockIndex ~= nil then
    turtle.select(blockIndex)
    turtle.placeDown()
    success = turtle.detectDown()
  else   
    print("Requesting blocks")
    turtle.digUp()
    inv.dropAll("front", blacklist)
    blockRequest = getBlockRequest()
    sleep(3)
    for name, data in pairs(blockRequest) do
      print(name, data["amt"], data["meta"])
      inv.export(colorCode, name, data["amt"], data["meta"])
      sleep(3)
    end
    blockConfig = inv.getItemDict()
    blockIndex = blockConfig[blockID]
    if blockIndex ~= nil then
      turtle.select(blockIndex)
      turtle.placeDown()
    end
  end
  
  -- get paintbrush here
  turtle.digUp()
  inv.export(colorCode, "openblocks:paintbrush", 1, 0, "{color:" .. color .. "}")
  blockConfig = inv.getItemDict()
  sleep(2)
  turtle.select(blockConfig["openblocks:paintbrush0"])
  turtle.placeDown()
  inv.import(colorCode, blacklist)
end

for i = blockNum, #blocks, 1 do
  block = blocks[i]
  print(i)
  x1 = tonumber(block[1])
  y1 = tonumber(block[2])
  z1 = tonumber(block[3])
  blockName = "openblocks:canvas0"
  color = tonumber(block[4], 16)
  --print("X:" .. x .. " Y:" .. y .. " Z:" .. z)
  handleBlockPlace(x1, y1, z1, blockName, color)
end
