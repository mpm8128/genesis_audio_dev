; demo_song

qn  set 60
wn  set qn

M_noise_a_section: macro
    M_play_note 0, 1, wn
    M_play_rest wn
    M_play_note 4, 1, wn
    M_play_rest wn
    M_play_note 1, 1, wn
    M_play_rest wn
    M_play_note 5, 1, wn
    M_play_rest wn

    M_play_note 2, 1, wn
    M_play_rest wn
    M_play_note 6, 1, wn
    M_play_rest wn
    M_play_note 3, 1, wn
    M_play_rest wn
    M_play_note 7, 1, wn
    M_play_rest wn
    endm

demo_noise:
    dc.b    sc_load_inst
    even
    dc.l    Inst_noise_waves
    rept 8
    M_noise_a_section
    endr
    dc.b    sc_loop
    even
    dc.l    demo_noise


demo_psg_0:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_pluck
    
    M_play_note note_C, 3, qn
    M_play_note note_E, 3, qn
    M_play_rest (qn*2)
    M_play_note note_G, 3, qn
    M_play_rest qn
    M_play_rest qn
    M_play_note note_Bb, 3, qn
    M_play_rest (qn*3)
    ;M_play_rest qn
    ;M_play_rest qn

    dc.b    sc_loop
    even
    dc.l    demo_psg_0
    
demo_psg_1:
    dc.b    sc_keyon, note_G, 0x04, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_D, 0x05, 0x30
    dc.b    sc_keyon, note_D, 0x04, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_Bb, 0x04, 0x30
    ;dc.b    sc_stop
    dc.b    sc_loop
    dc.l    demo_psg_0

demo_psg_2:
    dc.b    sc_keyon, note_C, 0x05, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_G, 0x05, 0x30
    dc.b    sc_keyon, note_G, 0x04, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_Eb, 0x05, 0x30
    ;dc.b    sc_stop
    dc.b    sc_loop
    dc.l    demo_psg_1