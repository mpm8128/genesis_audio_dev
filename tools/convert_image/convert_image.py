#!/usr/bin/python3

import sys
import PIL.Image

def nearest_color_64(pixel):
    if pixel < (0x00 + ((0x90 - 0x00)/2)):
        return 0x00
    #if pixel < (0x34 + ((0x57 - 0x34)/2)):
    #    return 0x34    
    #if pixel < (0x57 + ((0x74 - 0x57)/2)):
    #    return 0x57
    #if pixel < (0x74 + ((0x90 - 0x74)/2)):
    #    return 0x74
    if pixel < (0x90 + ((0xCE - 0x90)/2)):
        return 0x90
    #if pixel < (0xAC + ((0xCE - 0xAC)/2)):
    #    return 0xAC
    if pixel < (0xCE + ((0xFF - 0xCE)/2)):
        return 0xCE
    else:
        return 0xFF

def nearest_color_512(pixel):
    if pixel < (0x00 + ((0x34 - 0x00)/2)):
        return 0x00
    if pixel < (0x34 + ((0x57 - 0x34)/2)):
        return 0x34    
    if pixel < (0x57 + ((0x74 - 0x57)/2)):
        return 0x57
    if pixel < (0x74 + ((0x90 - 0x74)/2)):
        return 0x74
    if pixel < (0x90 + ((0xAC - 0x90)/2)):
        return 0x90
    if pixel < (0xAC + ((0xCE - 0xAC)/2)):
        return 0xAC
    if pixel < (0xCE + ((0xFF - 0xCE)/2)):
        return 0xCE
    else:
        return 0xFF


def main():
    if len(sys.argv) == 1:
        print("usage")
        print("\tconvert_image.py <image file>")
        exit()

    with PIL.Image.open(sys.argv[1]) as img:
        #print("opened " + sys.argv[1])
        #resized = img.resize((320, 224))
        #resized = img.resize((32, 32))
        resized = img
        #converted = PIL.Image.eval(resized, nearest_color_512)
        
        converted = PIL.Image.eval(resized, nearest_color_64)
        converted.save("out.png")

if __name__ == "__main__":
    main()
