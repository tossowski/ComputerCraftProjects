m = require "/tools/moveModule"
mio = require "/tools/modelIO"
inv = require "/tools/inventory"
blacklist = {[1]="enderstorage:ender_storage", [2]="computercraft:advanced_modem", [3]="minecraft:diamond_pickaxe", [4]="openblocks:canvas"}
blockConfig = inv.getItemDict()
blocks = mio.loadModelFile("/maps/jojo.txt") 
startX, startY, startZ = -330, 70, 246
blockNum = 1
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
    slotsUsed < 13 do
    block = blocks[blockNum]
    blockName = block[4]
    meta = block[5]
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
 
function handleBlockPlace (x2,y2,z2,blockID,meta)
  m.moveInXYZGrid(x2 + startX, y2 + startY, z2 + startZ)
    
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
  blockIndex = blockConfig[blockID .. meta]
  turtle.digDown()
  if blockIndex ~= nil then
    turtle.select(blockIndex)
    turtle.placeDown()
    success = turtle.detectDown()
  else   
    print("Requesting blocks")
    turtle.digUp()
    inv.dropAll("front", blacklist)
    sleep(3)
    blockRequest = getBlockRequest()
    for name, data in pairs(blockRequest) do
      print(name, data["amt"], data["meta"])
      inv.export(colorCode, name, data["amt"], data["meta"])
      sleep(3)
    end
    blockConfig = inv.getItemDict()
    blockIndex = blockConfig[blockID .. meta]
    if blockIndex ~= nil then
      turtle.select(blockIndex)
      turtle.placeDown()
    end
  end
  
end

for i = blockNum, #blocks, 1 do
  block = blocks[i]
  print(i)
  x1 = tonumber(block[1])
  y1 = tonumber(block[2])
  z1 = tonumber(block[3])
  blockName = block[4]
  meta = block[5]
  --print("X:" .. x .. " Y:" .. y .. " Z:" .. z)
  handleBlockPlace(x1, y1, z1, blockName, meta)
end
