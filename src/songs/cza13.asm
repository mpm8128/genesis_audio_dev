;cza13.asm
    module
    even
    
;==============
;channel table
cza13_channel_table:
    dc.l    cza13_bass1_seq_table   ;FM ch1
    dc.l    cza13_bass2_seq_table   ;FM ch2
    dc.l    cza13_plink_seq_table   ;FM ch3
    dc.l    cza13_lead_seq_table    ;FM ch4
    dc.l    cza13_echo_seq_table    ;FM ch5
    dc.l    cza13_drum_seq_table    ;FM ch6
    
    dc.l    0       ;psg ch0
    dc.l    0       ;psg ch1       
    dc.l    0       ;psg ch2        
    dc.l    0       ;noise
    
;================
;sequence tables
cza13_bass1_seq_table:
    ;load instrument
    dc.b    1
    ;a section
    rept    4
    dc.b    7, 7, 8, 8, 8, 8
    endr
    ;b section
    rept    4
    dc.b    9, 9, 9, 10
    dc.b    11, 11, 11, 12
    endr
    dc.b    -1, 1
    
cza13_bass2_seq_table:
    ;load instrument
    dc.b    2
    ;a section
    rept    4
    dc.b    7, 7, 8, 8, 8, 8
    endr
    ;b section
    rept    4
    dc.b    9, 9, 9, 10
    dc.b    11, 11, 11, 12
    endr
    dc.b    -1, 1
    
cza13_plink_seq_table:
    ;load inst
    dc.b    3
    ;a section
    rept    2
    dc.b    23, 23, 24, 24
    dc.b    23, 23, 24, 25
    endr
    ;b section
    rept    2
    dc.b    26, 27, 26, 28
    dc.b    29, 30
    dc.b    26, 27, 26, 28
    dc.b    29, 31
    endr
    dc.b    -1, 1

cza13_lead_seq_table:
    ;load instr
    dc.b    4
    ;a section
    dc.b    32, 33, 32, 34
    ;b section
    rept    2
    dc.b    35, 36, 35, 37
    endr
    dc.b    -1, 1
    
cza13_echo_seq_table:
    dc.b    5, 0
    ;a section
    dc.b    32, 33, 32, 34
    ;b section
    rept    2
    dc.b    35, 36, 35, 37
    endr
    dc.b    -1, 2

cza13_drum_seq_table:
    ;a section
    rept    2
    dc.b    16, 16, 17, 18
    dc.b    16, 16, 17, 19
    endr
    ;b section
    rept    4
    dc.b    13, 14, 13, 15
    dc.b    20, 21, 20, 22
    endr
    dc.b    -1, 0

    even
;=================================================
;section table
cza13_section_table:
    ;loading instruments
    dc.l    @echo_wait
    dc.l    @load_bass1_01
    dc.l    @load_bass2_02
    dc.l    @load_plink_03
    dc.l    @load_lead_04
    dc.l    @load_echo_05
    dc.l    0

    ;bass
    dc.l    @bass_a1_07
    dc.l    @bass_a2_08
    dc.l    @bass_b1_09
    dc.l    @bass_b2_10
    dc.l    @bass_b3_11
    dc.l    @bass_b4_12

    ;drums
    dc.l    @drum_b1_13
    dc.l    @drum_b2_14
    dc.l    @drum_b3_15
    dc.l    @drum_a1_16
    dc.l    @drum_a2_17
    dc.l    @drum_a3_18
    dc.l    @drum_a4_19
    dc.l    @drum_b4_20
    dc.l    @drum_b5_21
    dc.l    @drum_b6_22

    ;plink
    dc.l    @plink_a1_23
    dc.l    @plink_a2_24
    dc.l    @plink_a3_25
    dc.l    @plink_b1_26
    dc.l    @plink_b2_27
    dc.l    @plink_b3_28
    dc.l    @plink_b4_29
    dc.l    @plink_b5_30
    dc.l    @plink_b6_31
    
    ;lead & echo
    dc.l    @lead_a1_32
    dc.l    @lead_a2_33
    dc.l    @lead_a3_34
    dc.l    @lead_b1_35
    dc.l    @lead_b2_36
    dc.l    @lead_b3_37

;====
;sections

@echo_wait:
    M_play_rest 20
    dc.b    sc_end_section

@lead_b1_35:
    M_play_note note_B, 3, 90
    M_play_note note_D, 4, 10
    M_play_rest 10
    M_play_note note_G, 4, 20
    M_play_note note_Fs, 4, 10
    M_play_note note_E, 4, 10
    M_play_note note_G, 4, 10
    M_play_note note_E, 4, 10
    M_play_rest 20
    M_play_note note_B, 3, 70
    M_play_rest 10
    M_play_note note_D, 4, 10
    M_play_rest 10
    M_play_note note_B, 4, 10
    M_play_rest 10
    M_play_note note_G, 4, 10
    M_play_note note_A, 4, 10
    M_play_note note_A, 4, 20
    M_play_note note_G, 4, 10
    M_play_note note_Fs, 4, 80
    M_play_note note_A, 4, 20
    M_play_note note_G, 4, 10
    M_play_note note_B, 4, 20
    M_play_note note_A, 4, 10
    M_play_note note_C, 5, 20
    M_play_note note_A, 4, 10
    M_play_note note_B, 4, 20
    M_play_note note_G, 4, 10
    dc.b    sc_end_section

@lead_b2_36:    
    M_play_note note_A, 4, 20
    M_play_note note_G, 4, 10
    M_play_note note_B, 4, 20
    M_play_note note_A, 4, 10
    M_play_note note_E, 5, 20
    dc.b    sc_end_section
    
@lead_b3_37:
    M_play_note note_A, 4, 20
    M_play_note note_G, 4, 10
    M_play_note note_Fs, 4, 20
    M_play_note note_E, 4, 10
    M_play_note note_D, 4, 10
    M_play_note note_C, 4, 10
    dc.b    sc_end_section
    
@lead_a1_32:
    M_play_note note_E, 4, 80
    M_play_note note_E, 3, 10
    M_play_note note_B, 4, 10
    M_play_note note_A, 4, 10
    M_play_note note_G, 4, 10
    M_play_note note_Fs, 4, 10
    M_play_note note_E, 4, 15
    M_play_note note_D, 4, 10
    M_play_rest 5
    M_play_note note_A, 3, 5
    M_play_rest 5
    M_play_note note_G, 3, 110
    M_play_rest 10
    M_play_note note_D, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_G, 3, 5
    M_play_note note_A, 3, 5
    M_play_note note_C, 4, 5
    M_play_note note_D, 4, 5
    M_play_note note_E, 4, 5
    M_play_note note_G, 4, 5
    M_play_note note_E, 4, 65
    M_play_rest 5
    M_play_note note_E, 3, 10
    M_play_note note_B, 4, 10
    M_play_note note_A, 4, 10
    M_play_note note_G, 4, 10
    M_play_note note_Fs, 4, 10
    M_play_note note_G, 4, 15
    M_play_note note_A, 4, 10
    M_play_rest 5
    M_play_note note_C, 5, 5
    M_play_rest 5
    M_play_note note_B, 4, 20
    M_play_note note_E, 5, 20
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_play_note note_C, 5, 5
    M_play_note note_B, 4, 5
    M_play_rest 10
    dc.b    sc_end_section
    
@lead_a2_33:
    M_play_note note_C, 5, 5
    M_play_rest 5
    M_play_note note_B, 4, 20
    M_play_note note_E, 5, 20
    M_play_note note_D, 5, 5
    M_play_rest 5
    M_play_note note_C, 5, 5
    M_play_note note_B, 4, 5
    M_play_note note_A, 4, 5
    M_play_note note_G, 4, 5
    dc.b    sc_end_section
    
@lead_a3_34:
    M_play_note note_C, 5, 5
    M_play_rest 5
    M_play_note note_B, 4, 20
    M_play_note note_E, 5, 15
    M_play_note note_D, 5, 5
    M_play_note note_E, 5, 5
    M_play_note note_D, 5, 5
    M_play_note note_G, 5, 5
    M_play_note note_Fs, 5, 15
    dc.b    sc_end_section

@plink_b1_26:
    M_play_note note_B, 3, 20
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 15
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_play_note note_A, 3, 10
    dc.b    sc_end_section
    
@plink_b2_27:
    M_play_note note_B, 3, 20
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 15
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 15
    dc.b    sc_end_section
    
@plink_b3_28:
    M_play_note note_B, 3, 20
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_note note_B, 4, 5
    M_play_rest 15
    M_play_note note_D, 4, 5
    M_play_note note_E, 4, 5
    M_play_note note_B, 4, 10
    M_play_note note_G, 4, 10
    dc.b    sc_end_section

@plink_b4_29:    
    M_play_note note_E, 4, 20
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_rest 25
    M_play_note note_Fs, 4, 5
    M_play_rest 5
    M_play_note note_D, 4, 10
    M_play_note note_E, 4, 20
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_rest 15
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_rest 15
    M_play_note note_E, 4, 20
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_rest 15
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_note note_Fs, 4, 5
    M_play_rest 5
    M_play_note note_D, 4, 10
    dc.b    sc_end_section

@plink_b5_30:    
    M_play_note note_A, 4, 20
    M_play_note note_G, 4, 10
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_play_note note_B, 4, 10
    M_play_note note_A, 4, 10
    M_play_note note_E, 5, 10
    M_play_note note_A, 3, 10
    dc.b    sc_end_section

@plink_b6_31:
    M_play_note note_A, 4, 20
    M_play_note note_E, 4, 5
    M_play_rest 5
    M_play_note note_Fs, 4, 5
    M_play_rest 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_Fs, 4, 5
    M_play_rest 5
    M_play_note note_D, 4, 5
    M_play_rest 5
    M_play_note note_C, 4, 5
    M_play_rest 5
    dc.b    sc_end_section


@plink_a1_23:
    M_play_rest 20
    M_play_note note_E, 5, 5
    M_play_note note_E, 5, 5
    M_play_note note_E, 5, 5
    M_play_rest 25
    M_play_note note_E, 5, 5
    M_play_rest 15
    dc.b    sc_end_section
    
@plink_a2_24:
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_A, 4, 5
    M_play_rest 15
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_A, 4, 5
    M_play_rest 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    dc.b    sc_end_section
    
@plink_a3_25:
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_A, 4, 5
    M_play_rest 15
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_play_note note_C, 5, 5
    M_play_note note_B, 4, 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    dc.b    sc_end_section

@drum_b4_20:
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_play_note note_A, 2, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    dc.b    sc_end_section

@drum_b5_21:
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_play_note note_A, 2, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 10
    dc.b    sc_end_section

@drum_b6_22:
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 15
    M_play_note note_A, 2, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_E, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    dc.b    sc_end_section
    

@drum_a1_16:
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_play_note note_E, 3, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 10
    dc.b    sc_end_section
    
@drum_a2_17:
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_note note_G, 4, 5
    dc.b    sc_end_section
    
@drum_a3_18:    
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    dc.b    sc_end_section
    
@drum_a4_19:
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_G, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_A, 4, 5
    M_play_note note_A, 4, 5
    M_play_note note_A, 4, 5
    M_play_note note_A, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_A, 2, 5
    dc.b    sc_end_section

@drum_b1_13:
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_play_note note_E, 3, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    dc.b    sc_end_section
    
@drum_b2_14:
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_play_note note_E, 3, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 10
    dc.b    sc_end_section
    
@drum_b3_15:
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_play_rest 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_play_rest 15
    M_play_note note_E, 3, 5
    M_play_rest 5
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    M_load_inst Inst_cza13_snare
    M_play_note note_B, 4, 5
    M_load_inst Inst_cza13_kick
    M_play_note note_E, 3, 5
    dc.b    sc_end_section

@load_bass1_01:
    M_load_inst Inst_cza13_bass1
    dc.b    sc_end_section
    
@load_bass2_02:
    M_load_inst Inst_cza13_bass2
    dc.b    sc_end_section

@load_plink_03:
    M_load_inst Inst_cza13_plink
    dc.b    sc_end_section

@load_lead_04:
    M_load_inst Inst_cza13_lead
    dc.b    sc_end_section

@load_echo_05:
    M_load_inst Inst_cza13_echo
    ;wait echo time
    dc.b    sc_end_section

@bass_a1_07:
    M_play_note note_G, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_G, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_G, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    M_play_note note_E, 3, 5
    dc.b    sc_end_section

@bass_a2_08:
    M_play_note note_G, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_G, 3, 5
    M_play_note note_A, 2, 5
    dc.b    sc_end_section
    
@bass_b1_09:
    M_play_note note_B, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_G, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_B, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_C, 3, 5
    M_play_note note_E, 2, 5
    dc.b    sc_end_section
    
@bass_b2_10:
    M_play_note note_B, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_G, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_B, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_E, 2, 5
    M_play_note note_G, 2, 5
    M_play_note note_E, 2, 5
    dc.b    sc_end_section
    
@bass_b3_11:
    M_play_note note_D, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_C, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_D, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_E, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_F, 3, 5
    M_play_note note_E, 3, 5
    dc.b    sc_end_section
    
@bass_b4_12:
    M_play_note note_D, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_C, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_E, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_A, 2, 5
    M_play_note note_D, 3, 5
    M_play_note note_A, 2, 5
    M_play_note note_C, 3, 5
    M_play_note note_A, 2, 5
    dc.b    sc_end_section
    
    modend