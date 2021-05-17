; demo_cza_3

    module

et  set     17 ;qn/3
qn  set     51
hn  set     2*qn
wn  set     2*hn
tm  set     2*wn


;==========================


M_lead_a_section:   macro
    M_play_note note_C, 2, wn
    M_play_note note_C, 3, hn
    M_play_note note_G, 3, hn
    
    M_play_note note_Eb, 4, wn
    M_play_note note_Bb, 3, (hn+qn)
    M_play_note note_C, 4, qn
    
    M_play_note note_C, 2, wn
    M_play_note note_C, 3, hn
    M_play_note note_G, 3, hn
    
    M_play_note note_F, 4, wn
    M_play_note note_Bb, 3, wn
    
    M_play_note note_D, 4, wn
    M_play_note note_A, 3, hn
    M_play_note note_D, 4, hn
    
    M_play_note note_Db, 4, (hn+qn)
    M_play_note note_Bb, 3, qn
    M_play_note note_Gb, 3, hn
    M_play_note note_Db, 3, hn
    
    M_play_note note_Eb, 3, wn
    M_play_note note_Bb, 2, hn
    M_play_note note_Eb, 3, hn
    
    M_play_note note_D, 3, wn
    M_play_note note_B, 2, wn
    endm

;=============================
;lead horn

cza_3_lead_horn:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_1
    M_lead_a_section
    dc.b sc_loop
    even
    dc.l cza_3_lead_horn



;=============================
;harmony horns 2 (low part)

M_harmony_2_a_section: macro
    M_play_longnote note_C, 2, tm
    M_play_longnote note_G, 2, tm
    M_play_longnote note_G, 2, tm
    M_play_longnote note_C, 2, tm
    M_play_longnote note_F, 2, tm
    M_play_longnote note_Gb, 2, tm
    M_play_longnote note_Eb, 2, tm
    M_play_longnote note_B, 1, tm
    endm
    
cza_3_harmony_2:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_2
    M_harmony_2_a_section
    dc.b sc_loop
    even
    dc.l cza_3_harmony_2

;=============================
;harmony horns 1 (high part)

M_harmony_1_a_section: macro
    M_play_longnote note_G, 2, tm
    M_play_longnote note_Bb, 2, tm
    M_play_longnote note_B, 2, tm
    M_play_longnote note_A, 2, tm
    M_play_longnote note_A, 2, tm
    M_play_longnote note_Bb, 2, tm
    M_play_longnote note_B, 2, tm
    M_play_longnote note_F, 2, tm
    endm

cza_3_harmony_1:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_2
    M_harmony_1_a_section
    dc.b sc_loop
    even
    dc.l cza_3_harmony_1

;====================================
;bass part
    
two_measure_qn:   macro note, octave
    rept    8
    M_play_note \note, \octave, et
    M_play_rest (et*2)
    endr
    endm

M_bass_a_section: macro
    two_measure_qn  note_C, 2
    two_measure_qn  note_Eb, 2
    two_measure_qn  note_C, 2
    two_measure_qn  note_F, 2
    two_measure_qn  note_A, 1
    two_measure_qn  note_Db, 2
    two_measure_qn  note_Ab, 1
    two_measure_qn  note_G, 1
    endm

cza_3_bass:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_2
    M_bass_a_section
    dc.b sc_loop
    even
    dc.l cza_3_bass

M_noise_a_section: macro
    M_play_note note_C, 4, wn
    M_play_rest wn
    endm

demo_noise:
    rept 8
    M_noise_a_section
    endr
    dc.b    sc_loop
    even
    dc.l    demo_noise


    modend