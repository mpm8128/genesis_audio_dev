#!/usr/bin/python3

import sys

if len(sys.argv) <= 1:
    print("usage:")
    print("./parse_instruments.py <.y12 file>")
    exit()
    
#open file with "read" and "binary" modes
f = open(sys.argv[1], 'rb')

#all bytes for the file
hexbuf = f.read()
hex_list = []

#convert to strings to make this less awful
for byte in hexbuf:
    entry = ("0x{:02X}".format(byte))
    hex_list.append(entry)

#some label/comment formatting
print("Inst_" + str(sys.argv[1])[0:-4] + ":")
print("    ;       op1   op2   op3   op4")

#separate out the operators
op1 = hex_list[0:6]
op2 = hex_list[16:22]
op3 = hex_list[32:38]
op4 = hex_list[48:54]
#shift feedback/algorithm together properly
fb_alg = "0x{:02X}".format(hexbuf[65]<<3 | hexbuf[64])
#set stereo to center and ignore AM/FM for now
lr_amfm = "0xC0"

#special case for the first row - need the "dc.b" tag
print("    dc.b    " + op1[0] + ", " + op2[0] + ", " + op3[0] + ", " + op4[0] + ", &   ;det_mul")

format_string = " "*12 + "{1}, {2}, {3}, {4}, &   ;{0}"
comments = ["det_mul", "tl", "rs_ar", "am_d1r", "d2r", "sl_rr"]

#do the rest of the rows
for i in range(1, len(comments)):
    output = format_string.format(comments[i], op1[i], op2[i], op3[i], op4[i])
    print(output)

#special case for the last two rows
print(" "*12 + fb_alg  + ", &" + " "*21 + ";fb_alg")
print(" "*12 + lr_amfm + " "*24 + ";lr_amfm")

