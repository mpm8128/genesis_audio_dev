; demo_song

demo_psg_0:
    dc.b    sc_keyon, note_C, 0x04, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_G, 0x04, 0x30
    dc.b    sc_keyon, note_G, 0x03, 0x30
    dc.b    sc_keyoff, 0x18
    dc.b    sc_keyon, note_Eb, 0x04, 0x30
    ;dc.b    sc_stop
    dc.b    sc_loop
    dc.l    demo_psg_0