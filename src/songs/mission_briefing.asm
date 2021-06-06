;mission briefing

    module
    
qn  set     36
en  set     (qn/2)
et  set     (qn/3)
sn  set     (en/2)
st  set     (en/3)
hn  set     (qn*2)
wn  set     (hn*2)

mission_briefing_parts_table:
    dc.l    mb_horn_1_ch          ;FM ch1
    dc.l    mb_horn_2_ch          ;FM ch2
    dc.l    0x00000000          ;FM ch3
    dc.l    0x00000000          ;FM ch4
    dc.l    mb_bass_ch          ;FM ch5
    dc.l    mb_snare_ch          ;FM ch6
    
    ;no PSG
    dc.l    0x00000000          ;0
    dc.l    0x00000000          ;1
    dc.l    0x00000000          ;2
    dc.l    0x00000000          ;noise
    
mission_briefing_section_table:
    dc.l    0;mb_horn_1_st
    dc.l    0;mb_horn_2_st
    dc.l    0;mb_lead_1_st
    dc.l    0;mb_lead_2_st
    dc.l    0;mb_bass_st
    dc.l    mission_briefing_drum_section_table
    
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0
    

    
M_bass_triplets: macro note, octave
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_rest (st*5)
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_rest (st*2)
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_note \note, \octave, st
    M_play_rest (st*2)
    endm
    
M_db_intro: macro
    M_bass_triplets note_B, 2
    M_bass_triplets note_B, 2
    M_bass_triplets note_B, 2
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_rest (st*11)
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st

    endm

M_db_a_section: macro
    M_bass_triplets note_B, 2
    M_bass_triplets note_C, 3
    M_bass_triplets note_B, 2
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_rest (st*5)
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_rest (st*2)
    M_play_note note_C, 3, st
    M_play_rest (st*2)
    M_play_note note_A, 2, st
    M_play_rest (st*2)
    endm
    
M_db_b_section: macro
    M_bass_triplets note_D, 3
    M_bass_triplets note_E, 3
    M_bass_triplets note_F, 3
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_rest (st*5)
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_note note_G, 3, st
    M_play_rest (st*2)
    M_play_note note_G, 3, st
    M_play_rest (st*2)
    M_play_note note_E, 3, st
    M_play_rest (st*2) 
    endm
    
mb_snare_ch:
    dc.b    sc_load_inst
    even
    dc.l    Inst_FM_snare_1
    
    dc.b    sc_loop
    even
    dc.l    mb_db_loop
    
mb_bass_ch:
    dc.b    sc_load_inst
    even
    dc.l    Inst_agr_bass_1
    
mb_db_loop:
    M_db_intro
    M_db_a_section
    M_db_a_section
    M_db_b_section
    M_db_b_section
    dc.b    sc_loop
    even
    dc.l    mb_db_loop
;====================================
mission_briefing_drum_section_table
    dc.l    @load_drums
    ;intro/looping point
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_end_intro
    ;a section 1
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_c_triplets_1m
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_end_a_section
    ;a section 2
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_c_triplets_1m
    dc.l    @drum_b_triplets_1m
    dc.l    @drum_end_a_section
    ;b section 1
    dc.l    @drum_b_section
    dc.l    @drum_b_section
    dc.l    (-1)                ;stop code
    dc.l    1                   ;loop point
    
@load_drums:
    dc.b    sc_load_inst
    even
    dc.l    Inst_FM_snare_1
    dc.b    sc_end_section
    
@drum_b_triplets_1m:
    M_bass_triplets note_B, 2
    dc.b    sc_end_section

@drum_c_triplets_1m:
    M_bass_triplets note_C, 2
    dc.b    sc_end_section

@drum_end_a_section:
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_rest (st*5)
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_note note_C, 3, st
    M_play_rest (st*2)
    M_play_note note_C, 3, st
    M_play_rest (st*2)
    M_play_note note_A, 2, st
    M_play_rest (st*2)
    dc.b    sc_end_section

@drum_end_intro:
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_rest (st*11)
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    M_play_note note_B, 2, st
    dc.b    sc_end_section
    
@drum_b_section:
    M_db_b_section
    dc.b    sc_end_section
;=====================================

mb_harm_high_intro: macro
    M_play_note note_Fs, 2, (wn-sn)
    M_play_rest sn
    M_play_note note_Fs, 2, (wn-sn)
    M_play_rest sn
    M_play_note note_Fs, 2, (wn-sn)
    M_play_rest sn
    M_play_note note_Fs, 2, (qn)
    M_play_rest (qn*3)
    endm

mb_harm_high_a_section: macro
    M_play_note note_Fs, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_Fs, 2, (qn-sn)
    M_play_rest sn
    M_play_note note_G, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_G, 2, (qn-sn)
    M_play_rest sn
    
    M_play_note note_Fs, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_Fs, 2, (qn-sn)
    M_play_rest sn
    M_play_note note_G, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_G, 2, sn
    M_play_rest sn
    M_play_note note_E, 2, sn
    M_play_rest sn 
    endm

mb_harm_high_b_section: macro
    M_play_note note_A, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_A, 2, (qn-sn)
    M_play_rest sn
    M_play_note note_B, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_B, 2, (qn-sn)
    M_play_rest sn
    
    M_play_note note_C, 3, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_C, 3, (qn-sn)
    M_play_rest sn
    M_play_note note_D, 3, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_D, 3, sn
    M_play_rest sn
    M_play_note note_B, 2, sn
    M_play_rest sn 
    endm

mb_horn_1_ch:
    dc.b    sc_load_inst
    even
    dc.l    Inst_agr_horn_1
    
mb_harm_high:
    mb_harm_high_intro
    mb_harm_high_a_section
    mb_harm_high_a_section
    mb_harm_high_b_section
    mb_harm_high_b_section
    dc.b    sc_loop
    even
    dc.l    mb_harm_high
    
;=======
mb_harm_low_intro: macro
    M_play_note note_B, 1, (wn-sn)
    M_play_rest sn
    M_play_note note_B, 1, (wn-sn)
    M_play_rest sn
    M_play_note note_B, 1, (wn-sn)
    M_play_rest sn
    M_play_note note_B, 1, (qn)
    M_play_rest (qn*3)
    endm
    
mb_harm_low_a_section: macro
    M_play_note note_B, 1, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_B, 1, (qn-sn)
    M_play_rest sn
    M_play_note note_C, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_C, 2, (qn-sn)
    M_play_rest sn
    
    M_play_note note_B, 1, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_B, 1, (qn-sn)
    M_play_rest sn
    M_play_note note_C, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_C, 2, sn
    M_play_rest sn
    M_play_note note_A, 1, sn
    M_play_rest sn 
    endm
    
mb_harm_low_b_section: macro
    M_play_note note_D, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_D, 2, (qn-sn)
    M_play_rest sn
    M_play_note note_E, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_E, 2, (qn-sn)
    M_play_rest sn
    
    M_play_note note_F, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_F, 2, (qn-sn)
    M_play_rest sn
    M_play_note note_G, 2, ((qn*3)-sn)
    M_play_rest sn
    M_play_note note_G, 2, sn
    M_play_rest sn
    M_play_note note_E, 2, sn
    M_play_rest sn 
    endm
    
mb_horn_2_ch:
    dc.b    sc_load_inst
    even
    dc.l    Inst_agr_horn_1
mb_harm_low:
    mb_harm_low_intro
    mb_harm_low_a_section
    mb_harm_low_a_section
    mb_harm_low_b_section
    mb_harm_low_b_section

    dc.b    sc_loop
    even
    dc.l    mb_harm_low

    
    modend