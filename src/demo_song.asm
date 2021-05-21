demo_song

    module

;en  set 16
;sn  set (en/2)
tn  set     4
en  set     14
sn  set     (en/2)
qn  set     (en*2)
hn  set     (qn*2)
qt  set     (hn/3)
wn  set     (hn*2)    

demo_song_parts_table:
    dc.l    fm_demo_ch1
    dc.l    fm_demo_ch2
    dc.l    fm_demo_ch3
    dc.l    fm_demo_ch4
    dc.l    fm_demo_ch5
    dc.l    fm_demo_7
    
    dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0

demo_a_section: macro
    dc.b    sc_reg_write, 0x30, 0x00
    M_start_note note_E, 2
    dc.b    sc_reg_write, 0x30, 0x01
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x02
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x03   
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x04
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x05
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x06
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x07
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x08
    dc.b    sc_reg_write, 0xB0, 0x1A
    dc.b    sc_reg_write, 0x4C, 0x10
    M_start_note note_G, 2
    dc.b    sc_reg_write, 0x30, 0x07
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x06
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x05
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x04
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x03
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x02
    dc.b    sc_hold, tn
    dc.b    sc_reg_write, 0x30, 0x01
    dc.b    sc_hold, tn
    M_stop_note
    endm

fm_demo_ch1:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_1
    
    demo_a_section
    
    dc.b    sc_loop
    even
    dc.l    fm_demo_ch1


demo_ch2_section: macro
    M_play_note note_B, 4, en
    M_play_rest en
    M_play_note note_A, 4, en
    M_play_rest en
    M_play_note note_G, 4, qn
    
    M_play_note note_B, 4, en
    M_play_rest en
    M_play_note note_A, 4, en
    M_play_rest en
    M_play_note note_G, 4, qn

    M_play_note note_B, 4, sn
    M_play_note note_A, 4, sn
    M_play_note note_G, 4, sn
    M_play_note note_E, 4, sn
    M_play_note note_G, 4, en
    M_play_note note_E, 4, en
    endm

fm_demo_ch2:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_2
    dc.b    sc_reg_write, 0xB4, 0x80
    M_play_rest (hn*3)
    demo_ch2_section
    dc.b    sc_loop
    even
    dc.l    fm_demo_ch2

fm_demo_ch3:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_2
    dc.b    sc_reg_write, 0x34, 0x03
    dc.b    sc_reg_write, 0xB4, 0x40
    M_play_rest (hn*5)
    demo_ch2_section
    dc.b    sc_loop
    even
    dc.l    fm_demo_ch3

fm_demo_ch4:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_2
    dc.b    sc_reg_write, 0x34, 0x05
    dc.b    sc_reg_write, 0xB4, 0xC0
    M_play_rest (hn*7)
    demo_ch2_section
    dc.b    sc_loop
    even
    dc.l    fm_demo_ch4
    
fm_demo_ch5:
    dc.b    sc_load_inst
    even
    dc.l    Inst_test_organ_0
    
    M_play_note note_Fs, 6, (wn*4)
    M_play_note note_D, 6, (wn*4)
    M_play_note note_G, 5, (wn*4)
    M_play_note note_C, 6, (wn*4)
    M_play_note note_B, 4, (wn*8)

    dc.b    sc_loop
    even
    dc.l    fm_demo_ch5
    
fm_demo_ch6:
    dc.b    sc_load_inst
    even
    dc.l    Inst_test_organ_0

    M_play_note note_A, 6, (wn*4)
    M_play_note note_Fs, 6, (wn*4)
    M_play_note note_D, 6, (wn*4)
    M_play_note note_F, 6, (wn*4)
    M_play_note note_E, 2, (wn*8)

    dc.b    sc_loop
    even
    dc.l    fm_demo_ch6

M_fm_demo_7_cycle: macro note, octave, duration
count = (\duration/hn)
    do
    M_start_note \note, \octave
    dc.b    sc_hold, qt
    dc.b    sc_reg_write, 0x30, 0x72
    dc.b    sc_reg_write, 0x34, 0x41
    dc.b    sc_hold, (qt)
    dc.b    sc_reg_write, 0x30, 0x73
    dc.b    sc_reg_write, 0x34, 0x53
    dc.b    sc_hold, (qt)
    dc.b    sc_keyoff
count = (count-1)
    until (count=0)
    endm

fm_demo_7:
    dc.b    sc_load_inst
    even
    dc.l    Inst_test_organ_0

    M_fm_demo_7_cycle note_A, 6, (wn*4)
    M_fm_demo_7_cycle note_Fs, 6, (wn*4)
    M_fm_demo_7_cycle note_D, 6, (wn*4)
    M_fm_demo_7_cycle note_F, 6, (wn*4)
    M_fm_demo_7_cycle note_E, 2, (wn*8)
        
    dc.b    sc_loop
    even
    dc.l    fm_demo_7


    modend