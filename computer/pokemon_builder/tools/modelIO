local modelIO = {}
 
function modelIO.loadModelFile (path)
  blocks = {}
  file = io.open(path)
  for line in file:lines() do
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
