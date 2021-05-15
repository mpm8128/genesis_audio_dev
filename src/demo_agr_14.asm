;   demo_agr_14

sn  equ     5
en  equ     2*sn
qn  equ     2*en
hn  equ     2*qn
wn  equ     2*wn

M_play_note: macro note, octave, duration
    dc.b    sc_keyon, \note, \octave, \duration-1
    endm

M_play_rest: macro duration
    dc.b    sc_keyoff, duration-1
    endm

;==============================================================
;   Lead    
;==============================================================

;staccato_walk
M_ch0__a_01:    macro
    M_play_note note_E, 3, sn
    M_play_rest sn
    M_play_note note_G, 3, sn
    M_play_rest sn
    M_play_note note_B, 3, sn
    M_play_rest sn
    M_play_note note_D, 4, sn
    M_play_rest sn
    M_play_note note_E, 4, sn
    M_play_rest sn
    M_play_note note_C, 4, sn
    M_play_rest sn
    M_play_note note_G, 3, sn
    M_play_rest sn
    M_play_note note_D, 3, sn
    M_play_rest sn
    endm

;C-major 
M_ch0_M_a_02_01:    macro
    M_play_note note_C, 3, sn
    M_play_note note_E, 3, sn
    M_play_note note_G, 3, sn
    M_play_note note_E, 3, sn
    endm

;Dsus4
M_ch0_M_a_02_02:    macro    
    M_play_note note_D, 3, sn
    M_play_note note_G, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_G, 3, sn
    endm

;arps
M_ch0__a_02:    macro
    M_ch0_M_a_02_01
    M_ch0_M_a_02_01
    M_ch0_M_a_02_02 
    M_ch0_M_a_02_02
    endm

;walk up
M_ch0_M_a_03_01:    macro
    M_play_note note_D, 3, sn
    M_play_note note_G, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_C, 4, sn
    endm

;arps then walk up
M_ch0__a_03:    macro
    M_ch0_M_a_02_01
    M_ch0_M_a_02_01
    M_ch0_M_a_02_02
    M_ch0_M_a_03_01
    endm

;staccato walk down
M_ch0__a_04:    macro
    M_play_note note_B, 3, sn
    M_play_rest sn
    M_play_note note_E, 4, sn
    M_play_rest sn
    M_play_note note_B, 4, sn
    M_play_rest sn
    M_play_note note_A, 4, sn
    M_play_rest sn
    M_play_note note_G, 4, sn
    M_play_rest sn
    M_play_note note_Fs, 4, sn
    M_play_rest sn
    M_play_note note_E, 4, sn
    M_play_rest sn
    M_play_note note_D, 4, sn
    M_play_rest sn
    endm

;fast walks down
M_ch0__a_05:    macro
    M_play_note note_Fs, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_G, 3, sn
    endm

M_ch0__a_06:    macro
    M_play_note note_E, 3, sn
    M_play_rest sn
    M_play_note note_G, 3, sn
    M_play_rest sn
    M_play_note note_A, 3, sn
    M_play_rest sn
    M_play_note note_B, 3, sn
    M_play_rest sn
    M_play_note note_C, 4, sn
    M_play_rest sn
    M_play_note note_B, 3, sn
    M_play_rest sn
    M_play_note note_G, 3, sn
    M_play_rest sn
    M_play_note note_A, 3, sn
    M_play_rest sn
    endm

M_ch0__a_07:    macro
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_G, 4, sn
    endm

M_ch0__a_section:   macro
    M_ch0__a_01
    M_ch0__a_02
    M_ch0__a_01
    M_ch0__a_03 
    M_ch0__a_04
    M_ch0__a_05
    M_ch0__a_06
    M_ch0__a_07
    endm

;fast octaves + rest
M_ch0_M_b_octave_jump   macro
    M_play_note note_E, 4, sn
    M_play_note note_E, 3, sn
    M_play_note note_E, 4, sn
    M_play_note note_E, 3, sn
    M_play_rest en
    endm

;fast octaves, then quarter-note G
M_ch0__b_01:    macro
    M_ch0_M_b_octave_jump
    M_ch0_M_b_octave_jump
    M_play_note note_G, 3, qn
    endm
    
;fast octaves, then stacatto walk down
M_ch0__b_02:    macro
    M_ch0_M_b_octave_jump
    M_play_note note_E, 4, sn
    M_play_note note_E, 3, sn
    M_play_note note_E, 4, sn
    M_play_rest sn
    M_play_note note_D, 4, sn
    M_play_rest sn
    M_play_note note_C, 4, sn
    M_play_rest sn
    M_play_note note_B, 3, sn
    M_play_rest sn
    endm
    
;fast octaves, then stacatto walk up
M_ch0__b_03:    macro
    M_ch0_M_b_octave_jump
    M_play_note note_E, 3, sn
    M_play_note note_G, 3, sn
    M_play_note note_E, 3, sn
    M_play_rest sn
    M_play_note note_Fs, 3, sn
    M_play_rest sn
    M_play_note note_G, 3, sn
    M_play_rest sn
    M_play_note note_A, 3, sn
    M_play_rest sn
    endm
    
M_ch0__b_section:   macro
    M_ch0__b_01
    M_ch0__b_02
    M_ch0__b_01
    M_ch0__b_03
    endm

;C-section first run
M_ch0__c_01:    macro
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_B, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    endm

;C-section second run
M_ch0__c_02:    macro
    M_play_note note_G, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_G, 3, sn
    M_play_note note_A, 3, sn
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    M_play_note note_G, 3, sn
    endm

;C-section third run
M_ch0__c_03:    macro
    M_play_note note_A, 3, sn
    M_play_note note_B, 3, sn
    M_play_note note_C, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_G, 4, sn
    M_play_note note_D, 4, sn
    M_play_note note_C, 4, sn
    M_play_note note_B, 3, sn
    endm

M_ch0__c_section    macro
    M_ch0__c_01
    M_ch0__c_01
    M_ch0__c_02 ;twice as long, only play it once
    M_ch0__c_03
    M_ch0__c_03
    M_play_note note_Fs, 3, hn
    M_play_note note_G, 3, qn
    M_play_note note_A, 3, qn
    M_ch0__c_01
    M_ch0__c_01
    M_ch0__c_02 ;twice as long, only play it once
    M_ch0__c_03
    M_ch0__c_03
    M_play_note note_D, 4, hn
    M_play_note note_C, 4, qn
    M_play_note note_B, 3, qn
    endm

;lead
agr_14_ch0:
    dc.b    sc_load_inst
    even
    dc.l    Inst_percussive_organ_1
    M_ch0__a_section
    M_ch0__a_section
    M_ch0__b_section
    M_ch0__c_section
    M_ch0__c_section
    dc.b sc_loop
    even
    dc.l agr_14_ch0
    
;==============================================================
;   Bass    
;==============================================================
    
M_half_measure_gallop:  macro   note, octave
    M_play_note \note, \octave, sn
    M_play_rest sn
    M_play_note \note, \octave, sn
    M_play_note \note, \octave, sn
    M_play_note \note, \octave, sn
    M_play_rest sn
    M_play_note \note, \octave, sn
    M_play_note \note, \octave, sn
    endm
    
M_whole_measure_gallop: macro note, octave
    M_half_measure_gallop \note, \octave
    M_half_measure_gallop \note, \octave
    endm
    
M_ch1__a_section:   macro
    M_whole_measure_gallop  note_E, 2
    M_half_measure_gallop   note_C, 2
    M_half_measure_gallop   note_D, 2
    
    M_whole_measure_gallop  note_E, 2
    M_half_measure_gallop   note_C, 2
    M_half_measure_gallop   note_D, 2
    
    M_whole_measure_gallop  note_A, 1
    M_half_measure_gallop   note_C, 2
    M_half_measure_gallop   note_B, 1
    
    M_whole_measure_gallop  note_G, 1
    M_half_measure_gallop   note_C, 2
    M_half_measure_gallop   note_E, 1
    endm
    
; M_ch1__b_section:   macro
    ; endm
    
M_ch1__c_section:   macro
    M_whole_measure_gallop  note_B, 2
    M_whole_measure_gallop  note_G, 2
    M_whole_measure_gallop  note_A, 2
    M_half_measure_gallop   note_Fs, 2
    M_play_note note_Fs, 2, sn
    M_play_rest sn
    M_play_note note_G, 2, sn
    M_play_rest sn
    M_play_note note_A, 2, sn
    M_play_rest sn
    M_play_note note_As, 2, sn
    M_play_rest sn
    M_whole_measure_gallop  note_B, 2
    M_whole_measure_gallop  note_G, 2
    M_whole_measure_gallop  note_A, 2
    M_half_measure_gallop   note_D, 2
    M_play_note note_E, 2, sn
    M_play_rest sn
    M_play_note note_E, 2, sn
    M_play_rest sn
    M_play_note note_E, 2, sn
    M_play_rest sn
    M_play_note note_B, 1, sn
    M_play_rest sn
    endm
    
;bass
agr_14_ch1:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_and_hat_1
    M_ch1__a_section
    M_ch1__a_section
    M_ch0__b_section
    M_ch1__c_section
    M_ch1__c_section
    dc.b sc_loop
    even
    dc.l agr_14_ch1
