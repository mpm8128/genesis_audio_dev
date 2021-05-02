;**************************************************
;*    SEGA GENESIS CARTRIDGE ID TABLE             *
;*                                                *
;*    STANDARD FORMAT FOR THIRD PARTIES           *
;*                                                *
;*    NOV 26 1990 SEGA OF AMERICA                 *
;*                                                *
;**************************************************

check_sum equ  $0000
    ORG $0100
;------------------------------------------------------------------------
    dc.b 'SEGA GENESIS    '        ;100
    dc.b '(C)T-XX 202X.XXX'        ;110 release year.month
    dc.b 'audio driver    '        ;120 title
    dc.b '                '        ;130
    dc.b '                '        ;140
    dc.b 'audio driver    '        ;150 title
    dc.b '                '        ;160
    dc.b '                '        ;170
    dc.b 'GM T-XXXXXX XX'          ;180 product #, version
    dc.w check_sum                 ;18E check sum
    dc.b 'J               '        ;190 controller
    dc.l $00000000,$00007fff
    dc.l $00ff0000,$00ffffff       ;1A0
    dc.b '                '        ;1B0
    dc.b '                '        ;1C0
    dc.b '                '        ;1D0
    dc.b '                '        ;1E0
    dc.b 'U               '        ;1F0
