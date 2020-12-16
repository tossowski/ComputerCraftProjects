mio = require("/tools/modelIO")
blocks = mio.loadPainting("/paintings/monkalisa.txt")
block = blocks[1]
x = block[1]
y = block[2]
color = block[3]
print(x,y,color)
