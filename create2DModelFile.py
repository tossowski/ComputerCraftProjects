xyzs = []
blocks = []

from matplotlib import pyplot as plt
import random
import numpy as np

#blockIDS = ["minecraft:cobblestone",  "minecraft:stone", "rustic:slate", "minecraft:hardened_clay", "minecraft:planks", "minecraft:gold_ore", "minecraft:dirt", "quark:jasper", "chisel:marble2", "chisel:limestone2", "chisel:basalt2", "minecraft:obsidian"]
#blockIDS = ["quark:jasper"]
# color_to_block = {(228,228,228):"white",
# (160,167,167):"light gray",
# (65,65,65):"gray",
# (24,20,20):"black",
# (158,43,39):"red",
# (234,126,53):"orange",
# (194,181,28):"yellow",
# (57,186,46):"lime green",
# (54,75,24):"green",
# (99,135,210):"light blue",
# (38,113,145):"cyan",
# (37,49,147):"blue",
# (126,52,191):"purple",
# (190,73,201):"magenta",
# (217,129,153):"pink",
# (86,51,28):"brown",
# }


blockCounts = {}
# print(len(blockIDS))


def getClosestColor(color):
    colors = list(color_to_block.keys())
    return sorted(colors, key=lambda x: np.sqrt((x[0]-color[0]) **2 + (x[1]-color[1]) **2 + (x[2]-color[2]) **2))[0]

levels = {}

def create_path(blocks, pos):
    path = []
    while len(blocks) > 1:
        closestBlock = sorted(blocks, key=lambda x : abs(x[0] - pos[0]) + abs(x[1] - pos[1]) + abs(x[2] - pos[2]))[0]
        path.append(closestBlock)
        blocks.remove(closestBlock)
        pos = closestBlock
    path.append(blocks[0])
    return path


with open("Dragon.txt", 'r') as f:
    for line in f:
        line = line.replace(" ", "")
        line = line.replace("\n", "")
        data = line.split(",")
        x = int(data[0])
        y = int(data[1])
        z = int(data[2])
        # color = (int(data[3]), int(data[4]), int(data[5]))
        # if color not in color_to_block:
        #     color = getClosestColor(color)
        # block= color_to_block[color]
        block="minecraft:cobblestone"
        if y in levels:
            levels[y].append([x,y,z,block, 0])
        else:
            levels[y] = [[x,y,z,block, 0]]
        #val = random.randint(0, len(blockIDS) - 1)
        #blocks.append(blockIDS[val])

numYLevels = max(levels.keys()) + 1
print(len(levels[0]))

final_path = []
currBlock = [0,0,0]
for i in range(numYLevels):
    path = create_path(levels[i], currBlock)
    final_path += path
    currBlock = path[-1][0:3]
    currBlock[1] += 1
    

with open("dragonModel.txt", "w") as f:
    for block in final_path:
        blockname = block[3]
        f.write(str(block[0]))
        f.write(",")
        f.write(str(block[1]))
        f.write(",")
        f.write(str(block[2]))
        f.write(",")
        f.write(str(block[3]))
        f.write(",")
        f.write(str(block[4]))
        f.write("\n")

        if blockname in blockCounts:
            blockCounts[blockname] += 1
        else:
            blockCounts[blockname] = 1
        

print(blockCounts)




# with open("sphere.txt", 'w') as f:
#     f.write("7,7,7\n")
#     for i in range(len(xyzs)):
#         f.write(xyzs[i])
#         f.write(",")
#         f.write(blocks[i])
#         f.write("\n")

        
