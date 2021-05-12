
psg_frequency_table:
;                0    1    2    3    4    5    6    7    8    9    10   11    
;                C    C#   D    D#   E    F    F#   G    G#   A    A#   B    
    dc.w          0,   0,   0,   0,   0,   0,   0,   0,  0, 1017, 960, 906, &   ;A2 -> B2
                855, 807, 762, 719, 679, 641, 605, 571, 539, 508, 480, 453, &   ;C3 -> B3
                428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, &   ;C4 -> B4
                214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113, &   ;C5 -> B5
                107, 101,  95,  90,  85,  80,  76,  71,  67,  64,  60,  57, &   ;C6 -> B6
                 53,  50,  48,  45,  42,  40,  38,  36,  34,  32,  30,  28, &   ;C7 -> B7
                 27,  25,  24,  22,  21,  20,  19,  18,  17,  16,  15,  14      ;C8 -> B8
                  
;==============================================================
;   get_psg_freq_from_note_name_and_octave
;parameters:
    ;   d1.w -> note name (0-11)
    ;   d2.w -> octave (2-8)
;returns:
    ;   d0 -> register value
;==============================================================
get_psg_freq_from_note_name_and_octave:
    lea     (psg_frequency_table), a0
    subi.w  #2, d2                          ;octave# -> row offset
    subi.w  #12, d1                         ;
@calc_octave_offset:                        ;
    addi.w  #12, d1                         ;note_offset = note_name + 12(octave - 2)
    dbf     d2, @calc_octave_offset         ;
    asl.w   #1, d1                          ;word-align
    move.w  (a0, d1.w), d0 ;d0 = psg_frequency_table[note_offset]
    rts

;==============================================================
;   get_psg_freq_from_table_offset
;parameters:
    ;   d1.w -> note offset (9-84)
;returns:
    ;   d0 -> register value
;==============================================================
get_psg_freq_from_table_offset:
    lea     (psg_frequency_table), a0
    asl.w   #1, d1                          ;word-align
    move.w  (a0,d1.w), d0  ;d0 = psg_frequency_table[note_offset]
    rts