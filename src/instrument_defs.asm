;   instrument_defs.asm

    
    ;0xA0 - FFFF FFFF
    ;F - 8-bit frequency lsb
    ;dc.b    f_lsb
    
    ;0xA4 - xxBB BFFF
    ;B - 3-bit block
    ;F - 3-bit frequency msb
    ;dc.b    f_msb
    
    ;0xA8 - FFFF FFFF
    ;F - 8-bit ch3 supplementary frequency
    ;dc.b    ch3_f_lsb
    
    ;0xAC - xxBB BFFF
    ;B - 3-bit ch3 block
    ;F - 3-bit ch3 supplementary frequency MSB
    ;dc.b    ch3_f_msb
    

M_Define_Operator: macro det_mul,tl,rs_ar,am_d1r,d2r,sl_rr
    ;0x30 - xDDD MMMM
    ;D - 3-bit fine-grained detune
    ;M - 4-bit multiple of fundamental
    dc.b    \det_mul
    
    ;0x40 - xTTT TTTT
    ;T - 7-bit "total level"
    dc.b    \tl
    
    ;0x50 - RRxA AAAA
    ;R - 2-bit rate scaling
    ;A - 5-bit attack rate
    dc.b    \rs_ar
    
    ;0x60 - AxxD DDDD
    ;A - 1-bit enable amplitude modulation for this operator
    ;D - 5-bit first decay rate (from TL to sustain level)
    dc.b    \am_d1r
    
    ;0x70 - xxxD DDDD
    ;D - 5-bit second decay rate (from sustain level to silence)
    dc.b    \d2r
    
    ;0x80 - SSSS RRRR
    ;S - 4-bit sustain level
    ;R - 4-bit release rate
    dc.b    \sl_rr
    
    ;0x90 - xxxx SSSS
    ;S - 4-bit SSG-EG (unused)
    ;dc.b    \ssg_eg
    endm

M_Define_Instrument: macro  op1_det_mul,op1_tl,op1_rs_ar,op1_am_d1r,op1_d2r,op1_sl_rr,&
                            op2_det_mul,op2_tl,op2_rs_ar,op2_am_d1r,op2_d2r,op2_sl_rr,&
                            op3_det_mul,op3_tl,op3_rs_ar,op3_am_d1r,op3_d2r,op3_sl_rr,&
                            op4_det_mul,op4_tl,op4_rs_ar,op4_am_d1r,op4_d2r,op4_sl_rr,&
                            fb_alg,lr_amfm
                            
    M_Define_Operator \op1_det_mul,\op1_tl,\op1_rs_ar,\op1_am_d1r,\op1_d2r,\op1_sl_rr
    M_Define_Operator \op2_det_mul,\op2_tl,\op2_rs_ar,\op2_am_d1r,\op2_d2r,\op2_sl_rr
    M_Define_Operator \op3_det_mul,\op3_tl,\op3_rs_ar,\op3_am_d1r,\op3_d2r,\op3_sl_rr
    M_Define_Operator \op4_det_mul,\op4_tl,\op4_rs_ar,\op4_am_d1r,\op4_d2r,\op4_sl_rr

    ;0xB0 - xxFF FAAA
    ;F - 3-bit feedback
    ;A - 3-bit algorithm
    dc.b    \fb_alg
    
    ;0xB4 - LRAA xFFF
    ;L/R - 2-bit stereo channel enable
    ;A - 2-bit LFO amplitute modulation level
    ;F - 3-bit LFO frequency modulation level
    dc.b    \lr_amfm
    
    endm