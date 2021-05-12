;   instrument_defs.asm

    ;0x30 - xDDD MMMM
    ;D - 3-bit fine-grained detune
    ;M - 4-bit multiple of fundamental
    
    ;0x40 - xTTT TTTT
    ;T - 7-bit "total level"
    
    ;0x50 - RRxA AAAA
    ;R - 2-bit rate scaling
    ;A - 5-bit attack rate
    
    ;0x60 - AxxD DDDD
    ;A - 1-bit enable amplitude modulation for this operator
    ;D - 5-bit first decay rate (from TL to sustain level)
    
    ;0x70 - xxxD DDDD
    ;D - 5-bit second decay rate (from sustain level to silence)
    
    ;0x80 - SSSS RRRR
    ;S - 4-bit sustain level
    ;R - 4-bit release rate
    
    ;0x90 - xxxx SSSS
    ;S - 4-bit SSG-EG (unused)
    
    ;0xA0 - FFFF FFFF
    ;F - 8-bit frequency lsb
    
    ;0xA4 - xxBB BFFF
    ;B - 3-bit block
    ;F - 3-bit frequency msb
    
    ;0xA8 - FFFF FFFF
    ;F - 8-bit ch3 supplementary frequency
    
    ;0xAC - xxBB BFFF
    ;B - 3-bit ch3 block
    ;F - 3-bit ch3 supplementary frequency MSB
    
    ;0xB0 - xxFF FAAA
    ;F - 3-bit feedback
    ;A - 3-bit algorithm
    
    ;0xB4 - LRAA xFFF
    ;L/R - 2-bit stereo channel enable
    ;A - 2-bit LFO amplitute modulation level
    ;F - 3-bit LFO frequency modulation level
    

size_instrument_data    equ (size_operator_data*4) + 2    
Inst_test_organ_0:
    ;       op1   op2   op3   op4 
    dc.b    0x22, 0x33, 0x54, 0x61, &   ;det_mul
            0x12, 0x12, 0x12, 0x12, &   ;tl
            0x00, 0x00, 0x00, 0x00, &   ;rs_ar
            0x10, 0x10, 0x10, 0x10, &   ;am_d1r
            0x1F, 0x1F, 0x1F, 0x1F, &   ;d2r
            0xF0, 0xF0, 0xF0, 0xF0, &   ;sl_rr
            0x3F, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_test_organ_1:
    ;       op1   op2   op3   op4 
    dc.b    0x22, 0x33, 0x54, 0x61, &   ;det_mul
            0x6E, 0x6E, 0x11, 0x11, &   ;tl
            0x01, 0x01, 0x01, 0x01, &   ;rs_ar
            0x10, 0x10, 0x10, 0x10, &   ;am_d1r
            0x1F, 0x1F, 0x1F, 0x1F, &   ;d2r
            0x81, 0xC1, 0xD1, 0xE1, &   ;sl_rr
            0x3F, &                     ;fb_alg
            0x80                        ;lr_amfm
    
    even