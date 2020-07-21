from PIL import Image
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('file')
args = parser.parse_args()
pic = Image.open(args.file)
pixels = []

for x in range(pic.width):
    for y in range(pic.height):
        print(pic.getpixel((x, y)))
        r, g, b = pic.getpixel((x, y))[:3]
        pixel = "{:0>5b}{:0>5b}{:0>5b}00".format(r>>3, g>>3, b>>3)
        pixels.append("{:0>8x}\n".format(int(pixel, 2)))


with open(args.file+".hex", "w") as f:
    f.write("v2.0 raw\n")
    f.writelines(pixels)
        