local modelIO = {}
 
function modelIO.loadModelFile(path)
  blocks = {}
  fil = io.open(path)
  for line in fil:lines() do
    blockInfo={}
    for q in string.gmatch(line, "([^"..",".."]+)") do
      table.insert(blockInfo, q)
     end
  table.insert(blocks, blockInfo)   
  end
  print("Successfully Read " .. #blocks .. " blocks")
  return blocks
end
 
return modelIO
