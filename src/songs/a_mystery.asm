;a mystery

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

even
demo_song_parts_table:
    dc.l    fm_demo_ch1
    dc.l    fm_demo_ch2
    dc.l    fm_demo_ch3
    dc.l    fm_demo_ch4
    dc.l    fm_demo_ch5
    dc.l    fm_demo_ch6
    
    dc.l    psg_ch_0
    dc.l    psg_ch_1
    dc.l    psg_ch_2
    dc.l    0

demo_ch1_section: macro
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
    
    demo_ch1_section
    
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

psg_ch_0:
    dc.b    sc_load_inst
    even
    dc.l    inst_psg_plink
    M_play_rest (wn*24)
    
    rept    96
    M_play_note note_E, 5, sn
    M_play_rest (sn+en)
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_pad
    M_play_note note_E, 3, (qn)
    endr
    
    dc.b    sc_loop
    even
    dc.l    psg_ch_0

M_play_3arp: macro duration, speed, n1,o1,n2,o2,n3,o3
num_loops = (\duration/(speed*3))
leftover = (\duration-(num_loops*speed*3))
    rept num_loops
    M_play_note \n1, \o1, \speed
    M_play_note \n2, \o2, \speed
    M_play_note \n3, \o3, \speed
    endr
    if (leftover>0)
    dc.b    sc_hold, leftover
    endc
    endm
    
psg_ch_1:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_soft
    
    M_play_rest (wn*24)
    rept 3
    M_play_3arp (hn*4), 5, note_E, 4, note_G, 4, note_B, 4
    M_play_3arp (hn*4), 4, note_B, 3, note_E, 4, note_G, 4
    M_play_3arp (hn*4), 3, note_G, 3, note_B, 3, note_E, 4
    M_play_3arp (hn*4), 4, note_E, 3, note_G, 3, note_B, 3
    endr
    
    M_play_3arp (wn*4), sn, note_A, 5, note_Fs, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_D, 5, note_Fs, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_D, 5, note_G, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_C, 5, note_F, 5, note_A, 5
    M_play_3arp (wn*4), sn, note_B, 5, note_E, 5, note_G, 5
    M_play_3arp (wn*4), sn, note_B, 5, note_D, 5, note_Fs, 5

    dc.b    sc_loop
    even
    dc.l    psg_ch_1


psg_ch_2:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_pad

    M_play_rest (wn*24)
    M_play_rest (wn*4*6)
    M_play_3arp (wn*4), sn, note_A, 5, note_Fs, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_D, 5, note_Fs, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_D, 5, note_G, 5, note_B, 5
    M_play_3arp (wn*4), sn, note_C, 5, note_F, 5, note_A, 5
    M_play_3arp (wn*4), sn, note_B, 5, note_E, 5, note_G, 5
    M_play_3arp (wn*4), sn, note_B, 5, note_D, 5, note_Fs, 5


    dc.b    sc_loop
    even
    dc.l    psg_ch_2

    modend