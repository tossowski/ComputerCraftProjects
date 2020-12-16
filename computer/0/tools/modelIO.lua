local modelIO = {}
 
function modelIO.loadModelFile (path)
  blocks = {}
  for line in io.lines(path) do
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