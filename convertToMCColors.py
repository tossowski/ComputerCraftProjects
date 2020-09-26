import sys
import skimage
from matplotlib import pyplot as plt
filename = sys.argv[1]
image = skimage.io.imread(filename)

print(image.shape)

color_to_block = {(228,228,228):"white",
(160,167,167):"light gray",
(65,65,65):"gray",
(24,20,20):"black",
(158,43,39):"red",
(234,126,53):"orange",
(194,181,28):"yellow",
(57,186,46):"lime green",
(54,75,24):"green",
(99,135,210):"light blue",
(38,113,145):"cyan",
(37,49,147):"blue",
(126,52,191):"purple",
(190,73,201):"magenta",
(217,129,153):"pink",
(86,51,28):"brown",
}

def dist(a, b):
    return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2

for i in range(len(image)):
    for j in range(len(image[0])):
        color = image[i,j,0:3]
        closest_color = sorted(list(color_to_block.keys()), key = lambda x: dist(x, color))[0]
        image[i,j,0:3] = closest_color

plt.imshow(image)
plt.show()

skimage.io.imsave("BaronFinal.png", image)