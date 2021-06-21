
from matplotlib import pyplot as plt
import numpy as np
from sklearn.cluster import KMeans
import skimage

blockCounts = {}
levels = {}
colors = []
blocks = []

fileName = "models/beedrill.txt"

def dist(c1, c2):
    total = 0
    for i in range(len(c1)):
        total += (c1[i] - c2[i]) ** 2
    return np.sqrt(total)

def getBestColors(colorSet, num_colors):
    colors = np.reshape(np.array(list(colorSet)), (-1,3))
    kmeans = KMeans(n_clusters=num_colors, random_state=0).fit(colors)
    cols = kmeans.cluster_centers_

    return cols



def create_path(blocks, pos):
    path = []
    while len(blocks) > 1:
        closestBlock = sorted(blocks, key=lambda x : abs(x[0] - pos[0]) + abs(x[1] - pos[1]) + abs(x[2] - pos[2]))[0]
        path.append(closestBlock)
        blocks.remove(closestBlock)
        pos = closestBlock
    path.append(blocks[0])
    return path


colorSet = set()
with open(fileName, 'r') as f:
    for line in f:
        line = line.replace(" ", "")
        line = line.replace("\n", "")
        data = line.split(",")
        x = int(data[0])
        y = int(data[1])
        z = int(data[2])
        r = int(data[3])
        g = int(data[4])
        b = int(data[5])
        colorSet.add((r,g,b))

colors = getBestColors(colorSet, 30)

with open(fileName, 'r') as f:
    for line in f:
        line = line.replace(" ", "")
        line = line.replace("\n", "")
        data = line.split(",")
        x = int(data[0])
        y = int(data[1])
        z = int(data[2])
        r = int(data[3])
        g = int(data[4])
        b = int(data[5])
        closestColor = sorted(colors, key = lambda x: dist([r,g,b], x))[0]
        
        closestColor = '%02x%02x%02x' % tuple(map(int, closestColor))
        
        blocks.append([x,y,z,closestColor])


for block in blocks:
    y = block[1]
    if y in levels:
        levels[y].append(block)
    else:
        levels[y] = [block]


numYLevels = max(levels.keys()) + 1

final_path = []
currBlock = [0,0,0]
for i in range(numYLevels):
    path = create_path(levels[i], currBlock)
    final_path += path
    currBlock = path[-1][0:3]
    currBlock[1] += 1
    

with open("finalModels/beedrillModel.txt", "w") as f:
    for block in final_path:
        blockname = block[3]
        f.write(str(block[0]))
        f.write(",")
        f.write(str(block[1]))
        f.write(",")
        f.write(str(block[2]))
        f.write(",")
        f.write(str(block[3]))
        f.write("\n")

        if blockname in blockCounts:
            blockCounts[blockname] += 1
        else:
            blockCounts[blockname] = 1
        

print(blockCounts)


        
