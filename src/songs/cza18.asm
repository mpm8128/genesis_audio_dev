;cza18.asm
    module
    even
    
;===========================
;   Channel Table
cza18_channel_table:
    dc.l    cza18_ch0_seq_table
    dc.l    cza18_ch1_seq_table
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
cza18_ch0_seq_table:
    dc.b    0, 1, 2, 3, 4, 5
    dc.b    3, 4, 3, 4
    dc.b    6, 7
    dc.b    -1, 10   ; looping point
    
cza18_ch1_seq_table:
    rept    10
    dc.b    10
    endr
    dc.b    9, 8
    dc.b    -1, 10
    
cza18_psg0_seq_table:
    dc.b    1, 2
    dc.b    -1, 1

    even
;=====================
;   Section Table
cza18_section_table:
    dc.l    @base_drum_loop_0
    dc.l    @base_drum_loop_1
    dc.l    @base_drum_loop_2
    dc.l    @base_drum_loop_3
    dc.l    @base_drum_loop_4
    dc.l    @base_drum_loop_5
    dc.l    @base_drum_loop_6
    dc.l    @base_drum_loop_7
    dc.l    @pluck_loop_8
    dc.l    @pluck_load_inst_9
    dc.l    @silence_one_loop_10
    
@silence_one_loop_10:
    M_play_rest 192
    dc.b    sc_end_section
    
@pluck_load_inst_9:
    M_load_inst Inst_cza18_pluck
    dc.b    sc_end_section
    
@pluck_loop_8:
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_Ds, 5, 1
    M_play_note note_Ds, 4, 2
    M_play_rest 3
    M_play_note note_Ds, 5, 1
    M_play_note note_Ds, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_Ds, 5, 1
    M_play_note note_Ds, 4, 2
    M_play_rest 3
    M_play_note note_Ds, 5, 1
    M_play_note note_Ds, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 5, 1
    M_play_note note_C, 4, 2
    M_play_rest 3
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 3
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 3
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 3
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 3
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 3
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 3
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_note note_Ds, 3, 1
    M_play_note note_Ds, 2, 2
    M_play_note note_G, 3, 1
    M_play_note note_G, 2, 2
    M_play_note note_As, 3, 1
    M_play_note note_As, 2, 2
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 3
    M_play_note note_Fs, 4, 1
    M_play_note note_Fs, 3, 2
    M_play_rest 3
    M_play_note note_G, 4, 1
    M_play_note note_G, 3, 2
    M_play_rest 21
    M_play_note note_G, 4, 1
    M_play_note note_G, 3, 2
    M_play_rest 15
    M_play_note note_Fs, 4, 1
    M_play_note note_Fs, 3, 2
    M_play_rest 3
    M_play_note note_G, 4, 1
    M_play_note note_G, 3, 2
    M_play_rest 15
    M_play_note note_Fs, 4, 1
    M_play_note note_Fs, 3, 2
    M_play_rest 3
    M_play_note note_G, 4, 1
    M_play_note note_G, 3, 2
    M_play_rest 3
    M_play_note note_F, 4, 1
    M_play_note note_F, 3, 2
    M_play_rest 3
    M_play_note note_Ds, 4, 1
    M_play_note note_Ds, 3, 2
    M_play_rest 3
    M_play_note note_D, 4, 1
    M_play_note note_D, 3, 2
    M_play_rest 3
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_C, 4, 1
    M_play_note note_C, 3, 2
    M_play_rest 9
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_note note_C, 3, 1
    M_play_note note_C, 2, 2
    M_play_rest 9
    M_play_note note_Ds, 4, 1
    M_play_note note_Ds, 3, 2
    M_play_rest 9
    dc.b    sc_end_section
    
    
@base_drum_loop_0:
    M_load_inst Inst_cza18_kick_max
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_max
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_mid
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_max
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section
    
@base_drum_loop_1:
    M_load_inst Inst_cza18_kick_maxw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxw
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section
    
@base_drum_loop_2:
    M_load_inst Inst_cza18_kick_maxw
    ;dc.b    sc_reg_write, 0x84, 0xFF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xEF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xEF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0xDF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xDF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0xCF
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xCF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0xBF
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xAF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x9F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x9F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0x8F
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x8F
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section

@base_drum_loop_3:
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x4F
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x4F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x3F
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section

@base_drum_loop_4:
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x3F
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x3F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x4F
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section

@base_drum_loop_5:
    dc.b    sc_reg_write, 0x84, 0x8F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x9F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0x9F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0xAF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xAF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0xBF
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xBF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0xCF
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xDF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxw
    dc.b    sc_reg_write, 0x84, 0xEF
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midw
    dc.b    sc_reg_write, 0x84, 0xEF
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0xFF
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxw
    ;dc.b    sc_reg_write, 0x84, 0xFF
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section

@base_drum_loop_6:
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x4F
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x4F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x3F
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section

@base_drum_loop_7:
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x0F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x1F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x48, 0x12
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x2F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x3F
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x3F
    M_play_note note_C, 3, 6
    
    dc.b    sc_reg_write, 0x84, 0x4F
    dc.b    sc_reg_write, 0x48, 0x12
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x5F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_Cs, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    M_play_note note_C, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_play_rest 3
    
    M_load_inst Inst_cza18_kick_midx
    dc.b    sc_reg_write, 0x84, 0x6F
    M_play_note note_C, 3, 6
    dc.b    sc_reg_write, 0x48, 0x67
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_Cs, 3, 6
    M_play_note note_Ds, 3, 6
    M_load_inst Inst_cza18_snare
    M_play_note note_C, 4, 3
    M_load_inst Inst_cza18_kick_maxx
    dc.b    sc_reg_write, 0x84, 0x7F
    M_play_note note_E, 3, 3
    M_play_note note_F, 3, 3
    M_play_note note_Fs, 3, 3
    dc.b    sc_end_section
    
    modend