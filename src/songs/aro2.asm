;aro2.asm
    module
    even
    
;==============================
;   Channel Table
aro2_channel_table:
    dc.l    0  ;FM ch1
    dc.l    0  ;FM ch2
    dc.l    0  ;FM ch3
    dc.l    0  ;FM ch4
    dc.l    0  ;FM ch5
    dc.l    0  ;FM ch6
    
    dc.l    aro2_psg0   ;psg ch0
    dc.l    aro2_psg1   ;psg ch1       
    dc.l    aro2_psg2   ;psg ch2        
    dc.l    0           ;noise

;================================
;   Sequence Tables

aro2_psg0:
    ;a section
    dc.b    0, 1, 1
    ;b section
    dc.b    3, 3
    ;unecho
    dc.b    2, 2
    ;c section
    dc.b    4   ;twice as long
    ;loop point
    dc.b    -1, 0
    
aro2_psg1:
    ;a section
    dc.b    0, 2, 1, 1
    ;b section
    dc.b    3, 3
    ;unecho
    dc.b    2
    ;c section
    dc.b    5, 5
    ;loop point
    dc.b    -1, 0

aro2_psg2:
    ;a section
    dc.b    0, 2, 2, 1, 1
    ;b section
    dc.b    3, 3
    ;unecho
    ;
    ;c section
    dc.b    6, 6
    ;loop point
    dc.b -1, 0

;================================
;   Section Table
aro2_section_table:
    dc.l    @load_echo_plink
    dc.l    @a_section
    dc.l    @echo_time
    dc.l    @b_section
    dc.l    @p0_c_section_4
    dc.l    @p1_c_section_5
    dc.l    @p2_c_section_6

@p0_c_section_4:
    M_load_inst Inst_aro2_fade_in
    M_play_note note_B, 5, 288
    M_load_inst Inst_aro2_pad
    M_play_note note_A, 5, 288
    M_play_note note_G, 5, 288
    M_play_note note_A, 5, 312
    M_play_note note_G, 5, 48
    M_play_note note_Fs, 5, 360
    M_play_note note_G, 5, 144
    M_play_note note_F, 5, 120
    M_play_note note_E, 5, 24
    M_play_note note_F, 5, 24
    M_play_note note_G, 5, 24
    M_play_note note_E, 5, 240
    M_play_note note_G, 5, 144
    M_play_note note_C, 6, 48
    M_play_note note_B, 5, 240
    M_load_inst Inst_aro2_fade_in
    M_play_note note_B, 5, 288
    M_load_inst Inst_aro2_pad
    M_play_note note_A, 5, 288
    M_play_note note_G, 5, 288
    M_play_note note_A, 5, 312
    M_play_note note_G, 5, 48
    M_play_note note_Fs, 5, 360
    M_play_note note_G, 5, 144
    M_play_note note_F, 5, 120
    M_play_note note_E, 5, 24
    M_play_note note_F, 5, 24
    M_play_note note_G, 5, 24
    M_play_note note_G, 5, 24
    M_play_note note_A, 5, 24
    M_play_note note_A, 5, 24
    M_play_note note_B, 5, 24
    M_play_note note_B, 5, 24
    M_play_note note_C, 6, 24
    M_play_note note_C, 6, 24
    M_play_note note_D, 6, 24
    M_play_note note_D, 6, 24
    M_play_note note_E, 6, 24
    M_play_note note_D, 6, 144
    M_play_note note_C, 6, 48
    M_play_note note_B, 5, 240
    dc.b    sc_end_section
    
@p1_c_section_5:
    M_load_inst Inst_aro2_fade_in
    M_play_note note_G, 5, 288
    M_load_inst Inst_aro2_pad
    M_play_note note_E, 5, 288
    M_play_note note_D, 5, 192
    M_play_note note_C, 5, 96
    M_play_note note_E, 5, 96
    M_play_note note_F, 5, 96
    M_play_note note_D, 5, 120
    M_play_note note_C, 5, 48
    M_play_note note_B, 4, 264
    M_play_note note_C, 5, 240
    M_play_note note_D, 5, 144
    M_play_note note_D, 5, 48
    M_play_note note_E, 5, 48
    M_play_note note_G, 5, 48
    M_play_note note_A, 5, 144
    M_play_note note_B, 5, 144
    M_play_note note_A, 5, 48
    M_play_note note_Gs, 5, 240
    dc.b    sc_end_section

@p2_c_section_6:
    M_load_inst Inst_aro2_fade_in
    M_play_note note_C, 5, 192
    M_load_inst Inst_aro2_pad
    M_play_note note_B, 4, 96
    M_play_note note_A, 4, 96
    M_play_note note_B, 4, 48
    M_play_note note_C, 5, 48
    M_play_note note_G, 4, 96
    M_play_note note_E, 4, 192
    M_play_note note_G, 4, 96
    M_play_note note_F, 4, 192
    M_play_note note_A, 4, 120
    M_play_note note_G, 4, 48
    M_play_note note_A, 4, 216
    M_play_note note_D, 4, 120
    M_play_note note_E, 4, 24
    M_play_note note_F, 4, 48
    M_play_note note_G, 4, 144
    M_play_note note_F, 4, 48
    M_play_note note_A, 4, 96
    M_play_note note_C, 5, 96
    M_play_note note_B, 4, 48
    M_play_note note_C, 5, 24
    M_play_note note_D, 5, 24
    M_play_note note_E, 5, 48
    M_play_note note_D, 5, 144
    M_play_note note_C, 5, 48
    M_play_note note_B, 4, 240
    dc.b    sc_end_section



@load_echo_plink:
    M_load_inst Inst_aro2_psg_echo
    dc.b    sc_end_section

@echo_time:
    M_play_rest 7
    dc.b    sc_end_section

@a_section:
    M_play_note note_A, 4, 12
    M_play_rest 24
    M_play_note note_A, 5, 12
    M_play_rest 24
    M_play_note note_F, 5, 72
    M_play_rest 48
    M_play_note note_A, 3, 12
    M_play_note note_A, 2, 12
    M_play_rest 12
    M_play_note note_D, 3, 12
    M_play_rest 24
    M_play_note note_F, 3, 12
    M_play_rest 36
    M_play_note note_E, 3, 12
    M_play_rest 60
    M_play_note note_A, 2, 168
    M_play_rest 24
    M_play_note note_A, 4, 12
    M_play_rest 24
    M_play_note note_A, 5, 12
    M_play_rest 24
    M_play_note note_F, 5, 72
    M_play_rest 48
    M_play_note note_A, 3, 12
    M_play_note note_A, 2, 12
    M_play_rest 12
    M_play_note note_D, 3, 12
    M_play_rest 24
    M_play_note note_F, 3, 12
    M_play_rest 36
    M_play_note note_G, 3, 12
    M_play_note note_G, 4, 12
    M_play_note note_D, 4, 12
    M_play_rest 24
    M_play_note note_B, 3, 12
    M_play_note note_A, 3, 12
    M_play_rest 24
    M_play_note note_G, 3, 84
    M_play_rest 24
    M_play_note note_G, 3, 12
    M_play_rest 12
    M_play_note note_A, 3, 12
    M_play_rest 12
    M_play_note note_A, 4, 12
    M_play_rest 24
    M_play_note note_A, 5, 12
    M_play_rest 24
    M_play_note note_F, 5, 72
    M_play_rest 48
    M_play_note note_A, 3, 12
    M_play_note note_A, 2, 12
    M_play_rest 12
    M_play_note note_D, 3, 12
    M_play_rest 24
    M_play_note note_F, 3, 12
    M_play_rest 36
    M_play_note note_E, 3, 12
    M_play_rest 36
    M_play_note note_C, 3, 12
    M_play_note note_As, 2, 12
    M_play_note note_A, 2, 120
    M_play_note note_A, 4, 12
    M_play_rest 12
    M_play_note note_C, 5, 12
    M_play_rest 12
    M_play_note note_B, 4, 12
    M_play_rest 12
    M_play_note note_A, 4, 12
    M_play_rest 24
    M_play_note note_A, 5, 12
    M_play_note note_B, 5, 12
    M_play_rest 12
    M_play_note note_F, 5, 72
    M_play_note note_E, 5, 12
    M_play_rest 60
    M_play_note note_E, 5, 12
    M_play_rest 12
    M_play_note note_D, 5, 12
    M_play_rest 12
    M_play_note note_F, 5, 12
    M_play_rest 12
    M_play_note note_C, 5, 12
    M_play_rest 12
    M_play_note note_D, 5, 12
    M_play_rest 12
    M_play_note note_B, 4, 12
    M_play_rest 12
    M_play_note note_C, 5, 12
    M_play_rest 12
    M_play_note note_Gs, 4, 180
    M_play_rest 12
    dc.b    sc_end_section

@b_section:
    M_play_note note_D, 5, 12
    M_play_note note_Cs, 5, 12
    M_play_note note_A, 4, 72
    M_play_rest 48
    M_play_note note_E, 4, 12
    M_play_note note_F, 4, 12
    M_play_note note_B, 4, 72
    M_play_rest 48
    M_play_note note_D, 5, 12
    M_play_note note_Cs, 5, 12
    M_play_note note_A, 4, 72
    M_play_rest 48
    M_play_note note_E, 4, 12
    M_play_note note_F, 4, 12
    M_play_note note_E, 5, 12
    M_play_rest 36
    M_play_note note_E, 5, 12
    M_play_rest 12
    M_play_note note_D, 5, 12
    M_play_rest 36
    M_play_note note_D, 5, 12
    M_play_note note_Cs, 5, 12
    M_play_note note_A, 4, 72
    M_play_rest 48
    M_play_note note_E, 4, 12
    M_play_note note_F, 4, 12
    M_play_note note_B, 4, 72
    M_play_note note_A, 4, 12
    M_play_rest 36
    M_play_note note_D, 5, 12
    M_play_note note_Cs, 5, 12
    M_play_note note_F, 4, 48
    M_play_note note_E, 4, 48
    M_play_rest 24
    M_play_note note_E, 4, 12
    M_play_note note_F, 4, 12
    M_play_note note_E, 5, 12
    M_play_rest 36
    M_play_note note_E, 5, 12
    M_play_rest 12
    M_play_note note_D, 5, 12
    M_play_rest 12
    M_play_note note_F, 5, 12
    M_play_rest 12
    dc.b    sc_end_section

    
    modend