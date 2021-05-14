; demo_song

demo_psg_0:
    dc.b    sc_keyon, note_C, 0x04, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_G, 0x04, 0x30
    dc.b    sc_keyon, note_G, 0x03, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_Eb, 0x04, 0x30
    dc.b    sc_stop
    ;dc.b    sc_loop
    ;dc.l    demo_psg_0
    
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