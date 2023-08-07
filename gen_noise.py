from PIL import Image
import numpy
import os

imagesize = (600, 800 * 5)
randomByteArray = bytearray(os.urandom(imagesize[0] * imagesize[1]))
flatNumpyArray = numpy.array(randomByteArray)

grayImage = flatNumpyArray.reshape(imagesize)
pilout = Image.fromarray(numpy.uint8(grayImage))
pilout.save('noise.png')
