;demo section table
    module
    
    even
demo_channel_table:
    dc.l    demo_ch0_seq_table
    ;dc.l    demo_ch1_seq_table
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0
    
    ;dc.l    demo_psg0_seq_table
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0

demo_section_table:
    dc.l    @sect_0
    dc.l    @sect_1
    dc.l    @sect_2
    dc.l    @sect_3
    dc.l    @sect_4
    
@sect_0:
    dc.b    sc_load_inst
    even
    dc.l    Inst_agr_horn_1
    dc.b    sc_end_section
    
@sect_1:
    M_play_note note_C, 3, 16
    M_play_note note_F, 3, 16
    M_play_rest 16
    dc.b    sc_end_section

@sect_2:
    M_play_note note_B, 3, 5
    M_play_note note_E, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_E, 5, 6
    M_play_note note_G, 5, 5
    M_play_note note_B, 5, 6
    M_play_note note_Fs, 5, 5
    M_play_note note_G, 5, 6
    M_play_note note_E, 5, 5
    M_play_note note_C, 5, 6
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 6
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 17
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 6
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 6
    M_play_rest 11
    M_play_note note_B, 3, 5
    M_play_note note_E, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_B, 4, 5
    M_play_note note_E, 5, 6
    M_play_note note_G, 5, 5
    M_play_note note_B, 5, 6
    M_play_note note_Fs, 5, 5
    M_play_note note_G, 5, 6
    M_play_note note_E, 5, 5
    M_play_note note_C, 5, 6
    M_play_note note_B, 4, 5
    M_play_note note_E, 3, 5
    M_play_note note_G, 3, 6
    M_play_note note_B, 3, 5
    M_play_note note_E, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_B, 4, 6
    M_play_note note_D, 5, 5
    M_play_note note_B, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_E, 4, 6
    M_play_rest 10
    M_play_note note_B, 3, 6
    M_play_note note_E, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_B, 4, 5
    M_play_note note_E, 5, 6
    M_play_note note_G, 5, 5
    M_play_note note_B, 5, 6
    M_play_note note_Fs, 5, 5
    M_play_note note_G, 5, 6
    M_play_note note_E, 5, 5
    M_play_note note_C, 5, 5
    M_play_note note_B, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_G, 4, 5
    M_play_rest 17
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    M_play_rest 11
    M_play_note note_B, 3, 6
    M_play_note note_E, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_B, 4, 5
    M_play_note note_E, 5, 6
    M_play_note note_G, 5, 5
    M_play_note note_B, 5, 6
    M_play_note note_Fs, 5, 5
    M_play_note note_G, 5, 5
    M_play_note note_E, 5, 6
    M_play_note note_C, 5, 5
    M_play_note note_B, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 6
    M_play_note note_G, 4, 5
    M_play_note note_Fs, 4, 6
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 6
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 6
    M_play_note note_E, 4, 5
    M_play_note note_E, 4, 6
    M_play_note note_E, 4, 5

    dc.b    sc_end_section
    
@sect_3:
    dc.b    sc_end_section
    
@sect_4:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_soft
    dc.b    sc_end_section


demo_psg0_seq_table:
    dc.b    3, 2, 4, 2, 2, 1, 1, 1, 2
    dc.b    seq_table_stop_code
    dc.b    5           ;looping point


;===================

demo_ch0_seq_table:
    dc.b    0, 2
    dc.b    seq_table_stop_code
    dc.b    1           ;looping point
    
demo_ch1_seq_table:
    dc.b    0, 3
    dc.b    seq_table_stop_code
    dc.b    1
    
    modend