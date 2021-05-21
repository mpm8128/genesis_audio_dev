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
            0x40, 0x40, 0x40, 0x12, &   ;tl
            0x0F, 0x01, 0x08, 0x0F, &   ;rs_ar
            0x11, 0x10, 0x10, 0x10, &   ;am_d1r
            0x00, 0x00, 0x00, 0x00, &   ;d2r
            0x0F, 0x0F, 0x0F, 0x0F, &   ;sl_rr
            0x01, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_test_organ_1:
    ;       op1   op2   op3   op4 
    dc.b    0x22, 0x33, 0x54, 0x61, &   ;det_mul
            0x18, 0x18, 0x18, 0x18, &   ;tl
            0x0F, 0x0F, 0x0F, 0x0F, &   ;rs_ar
            0x12, 0x0F, 0x0F, 0x0F, &   ;am_d1r
            0x00, 0x00, 0x00, 0x00, &   ;d2r
            0xFF, 0x0F, 0x0F, 0x0F, &   ;sl_rr
            0x3F, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_percussive_organ_1:
    ;       op1   op2   op3   op4 
    dc.b    0x66, 0x73, 0x31, 0x02, &   ;det_mul
            0x1A, 0x19, 0x22, 0x1E, &   ;tl
            0x1C, 0x1F, 0x98, 0x1F, &   ;rs_ar
            0x00, 0x00, 0x00, 0x00, &   ;am_d1r
            0x00, 0x00, 0x00, 0x00, &   ;d2r
            0x88, 0x88, 0x88, 0x88, &   ;sl_rr
            0x1F, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_bass_and_hat_1:
    ;       op1   op2   op3   op4 
    dc.b    0x00, 0x01, 0x00, 0x01, &   ;det_mul
            0x01, 0x1B, 0x11, 0x0A, &   ;tl
            0x18, 0x1F, 0x1F, 0x1D, &   ;rs_ar
            0x05, 0x0C, 0x1F, 0x10, &   ;am_d1r
            0x00, 0x00, 0x13, 0x00, &   ;d2r
            0xFF, 0x0F, 0x08, 0x48, &   ;sl_rr
            0x3C, &                     ;fb_alg
            0xC0                        ;lr_amfm

    
;===============
;cza 3 instruments
    
Inst_bass_2:
    ;       op1   op2   op3   op4 
    dc.b    0x01, 0x04, 0x02, 0x01, &   ;det_mul
            0x23, 0x42, 0x16, 0x02, &   ;tl
            0xD8, 0xDF, 0xDF, 0x9F, &   ;rs_ar
            0x05, 0x06, 0x08, 0x07, &   ;am_d1r
            0x00, 0x00, 0x00, 0x06, &   ;d2r
            0x29, 0x50, 0x22, 0x25, &   ;sl_rr
            0x22, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_horn_1:
    ;       op1   op2   op3   op4 
    dc.b    0x01, 0x02, 0x02, 0x02, &   ;det_mul
            0x1C, 0x1A, 0x1A, 0x1A, &   ;tl
            0x10, 0x50, 0x50, 0x50, &   ;rs_ar
            0x07, 0x08, 0x08, 0x08, &   ;am_d1r
            0x01, 0x00, 0x00, 0x06, &   ;d2r
            0x20, 0x17, 0x17, 0x17, &   ;sl_rr
            0x3D, &                     ;fb_alg
            0xC0                        ;lr_amfm

Inst_horn_2:
    ;       op1   op2   op3   op4 
    dc.b    0x01, 0x02, 0x02, 0x02, &   ;det_mul
            0x1C, 0x16, 0x16, 0x16, &   ;tl
            0x09, 0x49, 0x49, 0x49, &   ;rs_ar
            0x07, 0x08, 0x08, 0x08, &   ;am_d1r
            0x01, 0x00, 0x00, 0x06, &   ;d2r
            0x20, 0x17, 0x17, 0x17, &   ;sl_rr
            0x3E, &                     ;fb_alg
            0xC0                        ;lr_amfm
    
Inst_noise_waves:
            ;Ar     ML    D    S     R     NM
    dc.b    0x01, 0x0F, 0x01, 0x00, 0x01, 0x05
    dc.b    0x01,       0x10,       0x05
    
Inst_psg_bass:
        ;   A      ML    D      S     R    NM
    dc.b    0x0F, 0x0F, 0x02, 0x05, 0x0F, 0x00 
    dc.b    0x00,       0x00,       0x00
    
Inst_psg_pluck:
        ;   A      ML    D      S     R    NM
    dc.b    0x04, 0x08, 0x02, 0x04, 0x01, 0x00 
    dc.b    0x00,       0x00,       0x01
    
Inst_psg_organ:
        ;   A      ML    D      S     R    NM
    dc.b    0x05, 0x0F, 0x05, 0x08, 0x0F, 0x00 
    dc.b    0x00,       0x00,       0x00

    even
    
    
    include 'automation_envelopes.asm'