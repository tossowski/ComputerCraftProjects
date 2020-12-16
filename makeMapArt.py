import skimage
import numpy as np
import sys
from matplotlib import pyplot as plt
import copy
from collections import defaultdict

from skimage import feature

imageName = sys.argv[1]
image = skimage.io.imread(imageName)
# bw = skimage.color.rgb2gray(image)
# edges = feature.canny(bw)
# bw[edges] *= 0.8
# image = skimage.color.gray2rgb(bw)
image = skimage.transform.resize(image, (128,128))
image = (image[:,:,:3] * 255).astype(np.uint8)
# print(image.shape)
colors = {(127, 178, 56):["minecraft:grass", 0],
          (247, 233, 163):["minecraft:planks", 2],
          (199, 199, 199):["minecraft:web", 0],
          (255, 0, 0):["minecraft:redstone_block", 0],
          (160, 160, 255):["minecraft:ice", 0],
          (167, 167, 167):["minecraft:iron_block", 0],
          (0, 124, 0):["minecraft:leaves", 0],
          (255, 255, 255):["minecraft:wool", 0],
          (164, 168, 184):["minecraft:clay", 0],
          (151, 109, 77):["minecraft:dirt", 0],
          (112, 112, 112):["minecraft:stone", 0],
          (143, 119, 72):["minecraft:planks", 0],
          (255, 252, 245):["minecraft:stone", 3],
          (216, 127, 51):["minecraft:planks", 4],
          (178, 76, 216):["minecraft:wool", 2],
          (102, 153, 216):["minecraft:wool", 3],
          (229, 229, 51):["minecraft:wool", 4],
          (127, 204, 25):["minecraft:wool", 5],
          (242, 127, 165):["minecraft:wool", 6],
          (76, 76, 76):["minecraft:wool", 7],
          (153, 153, 153):["minecraft:wool", 8],
          (76, 127, 153):["minecraft:wool", 9],
          (127, 63, 178):["minecraft:wool", 10],
          (51, 76, 178):["minecraft:wool", 11],
          (102, 76, 51):["minecraft:wool", 12],
          (102, 127, 51):["minecraft:wool", 13],
          (153, 51, 51):["minecraft:wool", 14],
          (25, 25, 25):["minecraft:wool", 15],
          (250, 238, 77):["minecraft:gold_block", 0],
          (92, 219, 213):["minecraft:diamond_block", 0],
          (74, 128, 255):["minecraft:lapis_block", 0],
          (0, 217, 58):["minecraft:emerald_block", 0],
          (129, 86, 49):["minecraft:dirt", 2],
          (112, 2, 0):["minecraft:netherrack", 0],
          (209, 177, 161):["minecraft:stained_hardened_clay", 0],
          (159, 82, 36):["minecraft:stained_hardened_clay", 1],
          (149, 87, 108):["minecraft:stained_hardened_clay", 2],
          (112, 108, 138):["minecraft:stained_hardened_clay", 3],
          (186, 133, 36):["minecraft:stained_hardened_clay", 4],
          (103, 117, 53):["minecraft:stained_hardened_clay", 5],
          (160, 77, 78):["minecraft:stained_hardened_clay", 6],
          (57, 41, 35):["minecraft:stained_hardened_clay", 7],
          (135, 107, 98):["minecraft:stained_hardened_clay", 8],
          (87, 92, 92):["minecraft:stained_hardened_clay", 9],
          (122, 73, 88):["minecraft:stained_hardened_clay", 10],
          (76, 62, 92):["minecraft:stained_hardened_clay", 11],
          (76, 50, 35):["minecraft:stained_hardened_clay", 12],
          (76, 82, 42):["minecraft:stained_hardened_clay", 13],
          (142, 60, 46):["minecraft:stained_hardened_clay", 14],
          (37, 22, 16):["minecraft:stained_hardened_clay", 15]}

#north: negative Z = up on image
# east: positive X = right on image

# bright = go down 1 y
# dark = go up 1 y
# neutral 

for color in list(colors.keys()):
    dark = tuple([int(x * 220 / 255) for x in color])
    darkest = tuple([int(x * 180 / 255) for x in color])

    
    colors[dark] = copy.copy(colors[color])
    colors[darkest] = copy.copy(colors[color])

    colors[color].append(-1)
    colors[dark].append(0)
    colors[darkest].append(1)


def dist(a,b):
    return (a[0]-b[0]) ** 2 + (a[1]-b[1]) ** 2 + (a[2]-b[2]) ** 2

def getClosestColor(c):
    return sorted(list(colors.keys()), key = lambda x: dist(x, c))[0]


blocks = []
blockCounts = defaultdict(int)
converted_image = np.zeros_like(image)
zCoord = 0
for x in range(len(image[0])):
    y= 0
    for z in range(len(image) -1, -1, -1):
        color = [int(a) for a in image[z,x,:3]]
        closestColor =  getClosestColor(color)
        converted_image[z,x,:] = closestColor
        blockInfo = colors[closestColor]
        blocks.append([x,y,z - len(image) + 1,blockInfo[0], blockInfo[1]])
        blockCounts[blockInfo[0] + str(blockInfo[1])] += 1
        y += blockInfo[2] # To get different shades, change y level of next block
    blocks.append([x,y,-len(image),"minecraft:wool", 0])

print(blockCounts)

with open("jojo.txt", "w") as f:
    for block in blocks:
        f.write("{},{},{},{},{}\n".format(block[0],block[1],block[2],block[3],block[4]))


        


    
        
fig, ax = plt.subplots(1,2)
ax[0].imshow(converted_image)
ax[1].imshow(image)
plt.show()