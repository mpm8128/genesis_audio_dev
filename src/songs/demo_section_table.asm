;demo section table
    module
    even
    
;===========================
;   Channel Table
demo_channel_table:
    dc.l    demo_fm_vibrato_seq_table
    ;dc.l    demo_ch1_seq_table
    ;dc.l    0
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


;===================
;   Sequence Tables
demo_ch0_seq_table:
    dc.b    0, 2
    dc.b    seq_table_stop_code
    dc.b    1           ;looping point
    
demo_psg0_seq_table:
    dc.b    1, 2
    dc.b    -1, 1

demo_fm_vibrato_seq_table:
    dc.b    0, 3
    dc.b    -1, 1

demo_psg_vibrato_seq_table:
    dc.b    1, 3
    dc.b    -1, 1


    even
;=====================
;   Section Table
demo_section_table:
    dc.l    @load_fm_inst_0
    dc.l    @load_psg_inst_1
    dc.l    @test_stuff_2
    dc.l    @test_vibrato_3
    
@load_fm_inst_0:
    M_load_inst Inst_percussive_organ_1
    dc.b    sc_end_section
    
@load_psg_inst_1:
    M_load_inst Inst_psg_organ
    dc.b    sc_end_section
    
@test_stuff_2:
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 29
    
    dc.b    sc_pitchbend, 38, 1    
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 14
    
    dc.b   sc_pitchbend, 0, 0
    M_play_note note_Fs, 5, 1
    M_play_note note_Fs, 4, 29
    
    dc.b    sc_pitchbend, -38, 1
    M_play_note note_Fs, 5, 1
    dc.b    sc_keyon, note_Fs, 4
    dc.b    sc_hold, 14
    dc.b    sc_pitchbend, 0, 0
    dc.b    sc_hold, 15
    dc.b    sc_keyoff
    
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 14
    dc.b    sc_end_section

@test_vibrato_3:
    dc.b    sc_keyon, note_C, 4
    ;dc.b    sc_hold, 30

    dc.b    sc_vibrato, 1, 10
    dc.b    sc_hold, 30
    
    dc.b    sc_vibrato, 1, 20
    dc.b    sc_hold, 30
    
    dc.b    sc_vibrato, 1, 40
    dc.b    sc_hold, 30
    
    dc.b    sc_vibrato, 2, 10
    dc.b    sc_hold, 30
    
    dc.b    sc_vibrato, 2, 20
    dc.b    sc_hold, 30
    
    dc.b    sc_vibrato, 2, 40
    dc.b    sc_hold, 30

    dc.b    sc_vibrato, 4, 10
    dc.b    sc_hold, 32
    
    dc.b    sc_vibrato, 4, 20
    dc.b    sc_hold, 32
    
    dc.b    sc_vibrato, 4, 40
    dc.b    sc_hold, 32
    
    dc.b    sc_vibrato, 8, 10
    dc.b    sc_hold, 64
    
    dc.b    sc_vibrato, 16, 20
    dc.b    sc_hold, 128
    
    dc.b    sc_vibrato, 32, 40
    dc.b    sc_hold, 128
    
    dc.b    sc_keyoff
    dc.b    sc_hold, 10
    dc.b    sc_end_section

    modend