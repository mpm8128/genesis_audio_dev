;cza_3
    module

et  set     17 ;qn/3
qn  set     51
hn  set     (2*qn)
wn  set     (2*hn)
tm  set     (2*wn)

;====================================
;bass part
    
two_measure_qn:   macro note, octave
    rept    8
    M_play_note \note, \octave, et
    M_play_rest (et*2)
    endr
    endm

M_bass_a_section: macro
    two_measure_qn  note_C, 2
    two_measure_qn  note_Eb, 2
    two_measure_qn  note_C, 2
    two_measure_qn  note_F, 2
    two_measure_qn  note_A, 1
    two_measure_qn  note_Db, 2
    two_measure_qn  note_Ab, 1
    two_measure_qn  note_G, 1
    endm

;=============================
;harmony horns 2 (low part)

M_harmony_2_a_section: macro
    M_play_longnote note_C, 2, tm
    M_play_longnote note_G, 2, tm
    M_play_longnote note_G, 2, tm
    M_play_longnote note_C, 2, tm
    M_play_longnote note_F, 2, tm
    M_play_longnote note_Gb, 2, tm
    M_play_longnote note_Eb, 2, tm
    M_play_longnote note_B, 1, tm
    endm

;=============================
;harmony horns 1 (high part)

M_harmony_1_a_section: macro
    M_play_longnote note_G, 2, tm
    M_play_longnote note_Bb, 2, tm
    M_play_longnote note_B, 2, tm
    M_play_longnote note_A, 2, tm
    M_play_longnote note_A, 2, tm
    M_play_longnote note_Bb, 2, tm
    M_play_longnote note_B, 2, tm
    M_play_longnote note_F, 2, tm
    endm

;==========================
;lead horn
M_lead_a_section:   macro
    M_play_note note_C, 2, wn
    M_play_note note_C, 3, hn
    M_play_note note_G, 3, hn
    
    M_play_note note_Eb, 4, wn
    M_play_note note_Bb, 3, (hn+qn)
    M_play_note note_C, 4, qn
    
    M_play_note note_C, 2, wn
    M_play_note note_C, 3, hn
    M_play_note note_G, 3, hn
    
    M_play_note note_F, 4, wn
    M_play_note note_Bb, 3, wn
    
    M_play_note note_D, 4, wn
    M_play_note note_A, 3, hn
    M_play_note note_D, 4, hn
    
    M_play_note note_Db, 4, (hn+qn)
    M_play_note note_Bb, 3, qn
    M_play_note note_Gb, 3, hn
    M_play_note note_Db, 3, hn
    
    M_play_note note_Eb, 3, wn
    M_play_note note_Bb, 2, hn
    M_play_note note_Eb, 3, hn
    
    M_play_note note_D, 3, wn
    M_play_note note_B, 2, wn
    endm

;====================================
;wave SE

M_noise_a_section: macro
    M_play_note 4, 1, wn
    M_play_rest wn
    endm

;====================================
;PSG echo plucks

M_psg_a_01: macro
    M_play_note note_C, 3, et
    M_play_note note_Eb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Eb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_C, 4, et
    M_play_note note_Bb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Eb, 3, et
    endm

M_psg_a_02: macro
    M_play_note note_Eb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_G, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_C, 4, et
    M_play_note note_Eb, 4, et
    M_play_note note_C, 4, et
    M_play_note note_Bb, 3, et
    M_play_note note_C, 4, et
    M_play_note note_Bb, 3, et
    M_play_note note_G, 3, et
    endm

M_psg_a_03: macro
    M_play_note note_C, 3, et
    M_play_note note_Eb, 3, et
    M_play_note note_F, 3, et
    M_play_note note_Eb, 3, et
    M_play_note note_F, 3, et
    M_play_note note_A, 3, et
    M_play_note note_C, 4, et
    M_play_note note_A, 3, et
    M_play_note note_F, 3, et
    M_play_note note_A, 3, et
    M_play_note note_F, 3, et
    M_play_note note_Eb, 3, et
    endm

M_psg_a_04: macro
    M_play_note note_A, 2, et
    M_play_note note_C, 3, et
    M_play_note note_E, 3, et
    M_play_note note_C, 3, et
    M_play_note note_E, 3, et
    M_play_note note_G, 3, et
    M_play_note note_A, 3, et
    M_play_note note_G, 3, et
    M_play_note note_E, 3, et
    M_play_note note_G, 3, et
    M_play_note note_E, 3, et
    M_play_note note_C, 3, et
    endm

M_psg_a_05: macro
    M_play_note note_Db, 3, et
    M_play_note note_E, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_E, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_Db, 4, et
    M_play_note note_Bb, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_Bb, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_E, 3, et
    endm

M_psg_a_06: macro
    M_play_note note_Eb, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_Ab, 3, et
    M_play_note note_Gb, 3, et
    M_play_note note_Ab, 3, et
    M_play_note note_B, 3, et
    M_play_note note_Eb, 4, et
    M_play_note note_B, 3, et
    M_play_note note_Ab, 3, et
    M_play_note note_B, 3, et
    M_play_note note_Ab, 3, et
    M_play_note note_Gb, 3, et
    endm

M_psg_a_07: macro
    M_play_note note_G, 3, et
    M_play_note note_B, 3, et
    M_play_note note_D, 4, et
    M_play_note note_B, 3, et
    M_play_note note_D, 4, et
    M_play_note note_E, 4, et
    M_play_note note_G, 4, et
    M_play_note note_E, 4, et
    M_play_note note_D, 4, et
    M_play_note note_E, 4, et
    M_play_note note_D, 4, et
    M_play_note note_B, 3, et
    
    M_play_note note_G, 3, et
    M_play_note note_B, 3, et
    M_play_note note_D, 4, et
    M_play_note note_B, 3, et
    M_play_note note_D, 4, et
    M_play_note note_E, 4, et
    M_play_note note_G, 4, et
    M_play_note note_E, 4, et
    M_play_note note_G, 4, et
    M_play_note note_B, 4, et
    M_play_note note_D, 5, et
    M_play_note note_G, 5, et
    endm
    
M_psg_wait_16_measures: macro
    M_play_rest (wn*16)
    endm

;=========================================================
;channel table
    even
cza3_channel_table:
    dc.l    cza3_bass_seq_table     ;FM ch1
    dc.l    cza3_harm1_seq_table    ;FM ch2
    dc.l    cza3_harm2_seq_table    ;FM ch3
    dc.l    cza3_lead_seq_table     ;FM ch4
    dc.l    0                       ;FM ch5
    dc.l    0                       ;FM ch6
    
    dc.l    cza3_psg0_seq_table     ;psg ch0
    dc.l    cza3_psg1_seq_table     ;psg ch1       
    dc.l    cza3_psg2_seq_table     ;psg ch2        
    dc.l    cza3_noise_seq_table    ;noise
    
;=========================================================
;section table
cza3_section_table
    dc.l    @load_bass      ;0
    dc.l    @bass_full_song ;1

    dc.l    @load_lead      ;2
    dc.l    @lead_full_song ;3
    
    dc.l    @load_harm      ;4
    dc.l    @harm1_full_song;5
    dc.l    @harm2_full_song;6
    
    dc.l    @load_noise     ;7
    dc.l    @noise_wave     ;8
    
    dc.l    @delay_6        ;9
    dc.l    @load_psg_pluck ;10
    dc.l    @psg_rest_16m   ;11
    dc.l    @psg_a_12
    dc.l    @psg_a_13
    dc.l    @psg_a_14
    dc.l    @psg_a_15
    dc.l    @psg_a_16
    dc.l    @psg_a_17
    dc.l    @psg_a_18
    
@load_bass:
    dc.b    sc_load_inst
    even
    dc.l    Inst_bass_2
    dc.b    sc_end_section
    
@bass_full_song:
    M_bass_a_section
    dc.b    sc_end_section

@load_lead:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_1
    dc.b    sc_end_section
    
@lead_full_song:
    M_lead_a_section
    dc.b    sc_end_section

@load_harm:
    dc.b    sc_load_inst
    even
    dc.l    Inst_horn_2
    dc.b    sc_end_section

@harm1_full_song:
    M_harmony_1_a_section
    dc.b    sc_end_section
    
@harm2_full_song:
    M_harmony_2_a_section
    dc.b    sc_end_section

@load_noise:
    dc.b    sc_load_inst
    even
    dc.l    Inst_noise_waves
    dc.b    sc_end_section
    
@noise_wave:
    M_play_note 4, 1, wn
    M_play_rest wn
    dc.b    sc_end_section
    
@delay_6:
    M_play_rest 6
    dc.b    sc_end_section
    
@load_psg_pluck:
    dc.b    sc_load_inst
    even
    dc.l    Inst_psg_pluck
    dc.b    sc_end_section
    
@psg_rest_16m:
    M_psg_wait_16_measures
    dc.b    sc_end_section
    
@psg_a_12:
    M_psg_a_01
    dc.b    sc_end_section

@psg_a_13:
    M_psg_a_02
    dc.b    sc_end_section

@psg_a_14:
    M_psg_a_03
    dc.b    sc_end_section

@psg_a_15:
    M_psg_a_04
    dc.b    sc_end_section

@psg_a_16:
    M_psg_a_05
    dc.b    sc_end_section
    
@psg_a_17:
    M_psg_a_06
    dc.b    sc_end_section
    
@psg_a_18:
    M_psg_a_07
    dc.b    sc_end_section
    
;=======================================================
;sequence tables
cza3_bass_seq_table:
    dc.b    0, 1
    dc.b    -1, 1 ; stop code, loop index

cza3_lead_seq_table:
    dc.b    2, 3
    dc.b    -1, 1 ; stop code, loop index

cza3_harm1_seq_table:
    dc.b    4, 5
    dc.b    -1, 1 ; stop code, loop index
    
cza3_harm2_seq_table:
    dc.b    4, 6
    dc.b    -1, 1 ; stop code, loop index

cza3_noise_seq_table:
    dc.b    7, 8
    dc.b    -1, 1 ; stop code, loop index

M_psg_sequence: macro
    dc.b    10, 11
    dc.b    12, 12, 13, 13, 12, 12, 14, 14
    dc.b    15, 15, 16, 16, 17, 17, 18
    endm

cza3_psg0_seq_table:
    M_psg_sequence
    dc.b    -1, 1 ; stop code, loop index

cza3_psg1_seq_table:
    dc.b    9
    M_psg_sequence    
    dc.b    -1, 2 ; stop code, loop index

cza3_psg2_seq_table:
    dc.b    9, 9
    M_psg_sequence
    dc.b    -1, 3 ; stop code, loop index

    modend