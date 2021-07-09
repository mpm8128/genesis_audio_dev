;demo section table
    module
    
    even
demo_channel_table:
    dc.l    demo_ch0_seq_table
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0
    
    dc.l    demo_psg0_seq_table
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
    rept    4
    M_play_note note_E, 4, 16
    M_play_note note_Eb, 4, 4
    endr
    dc.b    sc_end_section
    
@sect_3:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_plink
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
    dc.b    0, 2, 2, 2, 2, 1, 1, 1, 2
    dc.b    seq_table_stop_code
    dc.b    5           ;looping point
    
    
    modend