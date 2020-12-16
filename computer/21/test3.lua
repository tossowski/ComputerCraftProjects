mio = require("/tools/modelIO")
blocks = mio.loadModelFile("/bulbasaurModel.txt")
for i = 1, #blocks, 1 do
  print(blocks[i][3])
end
