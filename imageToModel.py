import skimage
import numpy as np
import sys

imageName = sys.argv[1]
image = skimage.io.imread(imageName)
# w, h, d = image.shape
# image = skimage.transform.resize(image, (w//4, h//4, 3)) * 255
# print(image.shape)
colors = {}

for i in range(len(image)):
    for j in range(len(image[0])):
        color = [int(x) for x in image[i,j,:3]]
        hexed = '#%02x%02x%02x' % tuple(color)
        if hexed in colors:
            colors[hexed] += 1
        else:
            colors[hexed] = 1

print(len(list(colors.keys())))
print(len(image) * len(image[0]))