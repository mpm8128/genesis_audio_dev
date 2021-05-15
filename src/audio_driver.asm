;   audio_driver.asm

;============================================================================
;   Definitions and Macros
;============================================================================

opn2_addr_1     equ 0x00A04000
opn2_data_1     equ 0x00A04001
opn2_addr_2     equ 0x00A04002
opn2_data_2     equ 0x00A04003
z80_bus_request_addr    equ 0x00A11100

; PSG port address (accessible from 68000)
; The PSG can be accessed from both the 68000 and the Z80, although each has its own
; address from which to do so.
psg_control				equ 0x00C00011

;wait for 2612/opn2 to stop being busy
M_wait_for_busy_clear: macro
@wait_for_busy_clear\@:
    btst  #7, (a0)
    bne.b  @wait_for_busy_clear\@
    endm

M_request_Z80_bus: macro
    move.w  #$0100, z80_bus_request_addr
@wait_for_z80_to_halt\@
    btst    #0, z80_bus_request_addr
    bne     @wait_for_z80_to_halt\@
    endm
    
M_return_Z80_bus: macro
    move.w  #0, z80_bus_request_addr
    endm

    include 'instrument_defs.asm'

;============================================================================
;   Entry point -> audio_driver
;============================================================================

    ;top-level function for the audio driver
    ;this is the entry point for this 'module'
audio_driver:
    ;jsr top_level_stuff
    jsr handle_all_psg_channels ;all psg channels
    jsr handle_all_fm_channels      ;all fm channels    
    ;jsr handle_dac             ;or maybe make the z80 do this one
    rts
    
;============================================================================
;   handle_all_fm_channels
;============================================================================
handle_all_fm_channels:
    lea ch_fm_1, a5     ;a5 = pointer to first fm channel struct
    moveq   #5, d7      ;d7 = number of FM channels -1 (loop counter)
    
    ;for each channel
@loop_fm_ch:
    tst.b   fm_ch_is_enabled(a5)    ;if channel is disabled
    beq     @next_channel           ;   skip it
                                    ;else
    jsr handle_fm_channel           ;   handle it
@next_channel:
    adda.w  #fm_ch_size, a5         ;next channel
    dbf d7, @loop_fm_ch             ;loop end

    rts
    
;============================================================================
;   handle_fm_channel
;parameter: pointer to psg channel struct in a5
;unusable: d7   
;============================================================================
handle_fm_channel:
    move.b  fm_ch_note_time(a5), d6     ;check note duration
    beq     @done_waiting               ;if duration == 0, read new code from stream
                                        ;else
    subi.b  #1, fm_ch_note_time(a5)    ;decrement note duration counter
    rts                                 ;and return
    
@done_waiting:
    move.l  fm_ch_stream_ptr(a5), a4    ;a4 = stream pointer for the channel
    cmp.l   #0, a4                      ;null check
    beq     exit_stream              ;if stream ptr == null, cleanup and return
    
read_fm_stream:
    clr.w   d6                          ;needs to be a clean slate for the cmp ahead
    lea     fm_stream_jumptable, a3     ;a3 = jumptable pointer
    move.b  (a4)+, d6       ;read code from stream
    cmp     #num_sc, d6      ;if code# > number of codes
    bgt     bad_stream_code ;   handle stream error
                            ;else
    lsl.w   #2, d6          ;   longword-align
    movea.l (a3, d6.w), a3  ;   a3 = indexed function
    jmp     (a3)            ;   call the indexed function

    ;table of functions indexed by stream codes
fm_stream_jumptable:
    dc.l    stream_fm_stop    
    dc.l    stream_fm_loop
    dc.l    stream_fm_keyon
    dc.l    stream_fm_keyoff    
    dc.l    stream_fm_load_instrument
    dc.l    stream_fm_reg_write

    ;TODO
stream_fm_reg_write
    bra read_fm_stream  ;read more from stream

;==============================================================
;   stream_fm_load_instrument
;   code: sc_load_inst
;
;   loads an FM instrument from the specified address
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       l   pointer to instrument data
;==============================================================
stream_fm_load_instrument:
    move.w  a4, d6          ;copy address to d6 to compare
    btst    #0, d6          ;check if stream ptr is odd or even
    beq     @word_aligned   ;
    tst.b   (a4)+           ;align that bad boy
@word_aligned:
    movea.l (a4)+, a1               ;a1 = instrument pointer
    move.b  fm_ch_channel(a5), d2   ;d2 = channel number
    jsr     load_FM_instrument
    bra read_fm_stream              ;read more from stream


;==============================================================
;   stream_fm_stop
;   code: sc_stop
;
;   mutes the channel and marks it as disabled, wipes stream ptr
;
;parameters:
;   a5 - channel struct pointer
;==============================================================
stream_fm_stop:
    clr.b   fm_ch_is_enabled(a5)   ;mark channel as "disabled"
    clr.l   fm_ch_stream_ptr(a5)   ;wipe stream pointer
    move.b  fm_ch_channel(a5), d2   ;d2 = channel number
    jsr     quick_mute_FM_channel   ;disable both stereo channels
    jsr     keyoff_FM_channel       ;write keyoff
    rts
    
;==============================================================
;   stream_fm_loop
;   code: sc_loop
;
;   moves the stream pointer to location specified in [addr]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       l   pointer to looping point
;==============================================================
stream_fm_loop:
    move.w  a4, d6          ;copy address to d6 to compare
    btst    #0, d6          ;check if stream ptr is odd or even
    beq     @word_aligned   ;
    tst.b   (a4)+           ;align that bad boy
@word_aligned:
    ;move new stream location to channel struct
    move.l  (a4), fm_ch_stream_ptr(a5)
    move.l  fm_ch_stream_ptr(a5), a4

    bra read_fm_stream     ;read more from stream

;==============================================================
;   stream_fm_keyon
;   code: sc_keyon
;
;   writes pitch information ([note], [octave]) from stream
;       and holds that note for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   note_name
;       b   note_octave
;       b   note_duration
;==============================================================
stream_fm_keyon:
    move.b  fm_ch_channel(a5), d2           ;d2 = channel number
    jsr keyoff_FM_channel
    
    move.b  (a4)+,  d6                      ;d6 = note name
    move.b  d6, fm_ch_note_name(a5)         ;write to struct also
    ext.w   d6                              ;sign-extend to word-length
    move.b  (a4)+,  d0                      ;d5 = note octave
    move.b  d0, fm_ch_note_octave(a5)       ;write to struct also
    lea     fm_frequency_table, a0
    lsl.w   #1, d6                          ;word-align
    move.w  (a0, d6.w), d1                  ;d1.w = frequency number
    move.b  fm_ch_channel(a5), d2           ;d2 = channel number
    
    jsr     set_FM_frequency                ;write frequency to 2612
    
    jsr     keyon_FM_channel                ;write keyon for fm channel

    move.b  (a4)+, fm_ch_note_time(a5)      ;set note duration
    bra exit_stream                         ;cleanup and return
    
;==============================================================
;   stream_fm_keyoff
;   code: sc_keyoff
;
;   writes keyoff and waits for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   note_duration
;==============================================================
stream_fm_keyoff:
    move.b  fm_ch_channel(a5), d2       ;d2 = channel number
    jsr     keyoff_FM_channel           ;write keyoff to 2612
    move.b  (a4)+, fm_ch_note_time(a5)  ;set silence duration

    bra exit_stream                     ;cleanup and return
    
;============================================================================
;   handle_all_psg_channels
;============================================================================
handle_all_psg_channels:
    lea ch_psg_0, a5        ;a5 = pointer to first psg channel struct
    moveq   #3, d7          ;number of PSG channels -1 (loop counter)
    
    ;for each channel
@loop_psg_ch:
    tst.b   psg_ch_is_enabled(a5)   ;if channel is disabled
    beq @next_channel               ;   skip it
                                    ;else
    jsr handle_psg_channel          ;   handle it
@next_channel
    adda.w  #psg_ch_size, a5         ;next channel
    dbf d7, @loop_psg_ch            ;loop end
    
    rts
    
;============================================================================
;   handle_psg_channels
;parameter: pointer to psg channel struct in a5
;unusable: d7   
;============================================================================
handle_psg_channel:
    move.b  psg_ch_note_time(a5), d6    ;check note duration
    beq     @done_waiting               ;if duration == 0, read new code from stream
                                        ;else
    subi.b  #1, psg_ch_note_time(a5)    ;decrement note duration counter
    rts                                 ;and return
    
@done_waiting:
    move.l  psg_ch_stream_ptr(a5), a4   ;a4 = stream pointer for the channel
    cmp.l   #0, a4                      ;null check
    beq     exit_stream             ;if stream ptr == null, cleanup and return
    
read_psg_stream:
    clr.w   d6                          ;needs to be a clean slate for the cmp ahead
    lea     psg_stream_jumptable, a3    ;a3 = jumptable pointer
    move.b  (a4)+, d6       ;read code from stream
    cmp     #num_sc, d6      ;if code# > number of codes
    bgt     bad_stream_code ;   handle stream error
                            ;else
    lsl.w   #2, d6          ;   longword-align
    movea.l (a3, d6.w), a3  ;   a3 = indexed function
    jmp     (a3)            ;   call the indexed function

    ;table of functions indexed by stream codes
psg_stream_jumptable:
    dc.l    stream_psg_stop    
    dc.l    stream_psg_loop
    dc.l    stream_psg_keyon
    dc.l    stream_psg_keyoff
    dc.l    stream_psg_load_instrument
    dc.l    stream_psg_reg_write
    
    ;TODO
stream_psg_reg_write:
    bra read_psg_stream     ;read more from stream

    ;TODO
stream_psg_load_instrument:
    bra read_psg_stream     ;read more from stream
    
;============================================================================
;   bad_stream_code
;       error handler in case something goes wrong.
;       grinds everything to a halt
;parameter:
;   a5 - pointer to psg channel struct
;   a4 - stream pointer
;   d6 - offending code
;============================================================================
bad_stream_code:
    M_disable_interrupts
    bra     bad_stream_code
    
;============================================================================
;   exit_stream
;       writes stream pointer back to channel struct and returns
;============================================================================
exit_stream:
    move.l   a4, psg_ch_stream_ptr(a5)  ;save stream pointer back to channel struct
    rts
    
;==============================================================
;   stream_psg_stop
;   code: sc_stop
;
;   mutes the channel and marks it as disabled, wipes stream ptr
;
;parameters:
;   a5 - channel struct pointer
;==============================================================
stream_psg_stop:
    clr.b   psg_ch_is_enabled(a5)   ;mark channel as "disabled"
    clr.l   psg_ch_stream_ptr(a5)   ;wipe stream pointer
    move.b  psg_ch_channel(a5), d0  ;d0 = channel number
    move.b  #0, d1                  ;d1 = volume 0 (max attenuation)    
    jsr     PSG_SetVolume           ;PSG_SetVolume(channel, 0)
    rts

;==============================================================
;   stream_psg_loop
;   code: sc_loop
;
;   moves the stream pointer to location specified in [addr]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       l   pointer    
;==============================================================
stream_psg_loop:
    move.w  a4, d6          ;copy address to d6 to compare
    btst    #0, d6          ;check if stream ptr is odd or even
    beq     @word_aligned   ;
    tst.b   (a4)+           ;align that bad boy
@word_aligned:
    ;move new stream location to channel struct
    move.l  (a4), psg_ch_stream_ptr(a5)
    move.l  psg_ch_stream_ptr(a5), a4

    bra read_psg_stream     ;read more from stream

;==============================================================
;   stream_psg_keyon
;   code: sc_keyon
;
;   writes pitch information ([note], [octave]) from stream
;       and holds that note for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   note_name
;       b   note_octave
;       b   note_duration
;==============================================================
stream_psg_keyon:
    move.b  (a4)+,  d6                  ;d6 = note name
    move.b  d6, psg_ch_note_name(a5)    ;write to struct also
    ext.w   d6                          ;sign-extend to word-length
    move.b  (a4)+,  d5                  ;d5 = note octave
    move.b  d5, psg_ch_note_octave(a5)  ;write to struct also
    ext.w   d5                          ;sign-extend to word-length
    jsr get_psg_freq_from_note_name_and_octave  ;d1 = timer_value
    
    move.b  psg_ch_channel(a5), d0      ;d0 = channel number
    jsr     PSG_SetFrequency    ;set_frequency(channel, timer_value)

    move.b  psg_ch_channel(a5), d0      ;d0 = channel number
    move.b  psg_ch_base_vol(a5), d1     ;d1 = base volume
    jsr     PSG_SetVolume               ;PSG_SetVolume(channel, 0)

    move.b  (a4)+, psg_ch_note_time(a5)  ;set note duration

    bra exit_stream                 ;cleanup and return

;==============================================================
;   stream_psg_keyoff
;   code: sc_keyoff
;
;   mutes the channel for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   note_duration
;==============================================================
stream_psg_keyoff:
    move.b  psg_ch_channel(a5), d0  ;d0 = channel number
    move.b  #0, d1                  ;d1 = volume 0 (max attenuation)    
    jsr     PSG_SetVolume           ;PSG_SetVolume(channel, 0)
    
    move.b  (a4)+, psg_ch_note_time(a5)     ;set silence duration

    bra exit_stream             ;cleanup and return
    
;==============================================================
;   stream codes
;==============================================================
    RSRESET
sc_stop         rs.b        1
sc_loop         rs.b        1
sc_keyon        rs.b        1
sc_keyoff       rs.b        1
sc_load_inst    rs.b        1
sc_reg_write    rs.b        1
num_sc          rs.b        0
    
;==============================================================
;   note codes
;==============================================================
    RSRESET
note_C      rs.b    1
note_Cs     rs.b    0
note_Db     rs.b    1
note_D      rs.b    1
note_Ds     rs.b    0
note_Eb     rs.b    1
note_E      rs.b    1
note_F      rs.b    1
note_Fs     rs.b    0
note_Gb     rs.b    1
note_G      rs.b    1
note_Gs     rs.b    0
note_Ab     rs.b    1
note_A      rs.b    1
note_As     rs.b    0
note_Bb     rs.b    1
note_B      rs.b    1    
    
;==============================================================
;   PSG Channel Structure
;==============================================================
    RSRESET
;PSG channel instrument information
psg_ch_is_enabled       rs.b    1   ;0 (disabled) or !0 (enabled)
psg_ch_channel          rs.b    1   ;channel id (0-3)
psg_ch_note_time        rs.w    1   ;number of frames to hold the note for

psg_ch_stream_ptr       rs.l    1   ;pointer to stream of audio data

psg_ch_base_vol         rs.b    1   ;"base" volume (pre-trem/envelope)
psg_ch_note_name        rs.b    1   ;current note (pre-vibr/envelope)
psg_ch_note_octave      rs.b    1   ;current octave (pre-vibr/envelope)
psg_ch_noise_mode       rs.b    1   ;0-3

;psg_ch_inst_ptr         rs.l    1 ;unused

;PSG channel automation information
psg_ch_freq_auto_idx    rs.b    1   ;index into pitchbend envelope
psg_ch_freq_auto_time   rs.b    1   ;number of frames on each index
psg_ch_freq_auto_ptr    rs.l    1   ;pointer to the envelope

psg_ch_vol_auto_idx     rs.b    1   ;index into volume envelope
psg_ch_vol_auto_time    rs.b    1   ;number of frames on each index
psg_ch_vol_auto_ptr     rs.l    1   ;pointer to the envelope

psg_ch_vibrato_time     rs.b    1   ;number of frames before increment/decrement
psg_ch_vibrato_size     rs.b    1   ;max deviation from base frequency

psg_ch_tremelo_time     rs.b    1   ;number of frames before increment/decrement
psg_ch_tremelo_size     rs.b    1   ;max deviation from base volume

psg_ch_auto_flags       rs.b    1   ;xYZx LPTV
                                    ;bit 0 - "V" - vibrato enable
                                    ;bit 1 - "T" - tremelo enable
                                    ;bit 2 - "P" - pitch envelope enable
                                    ;bit 3 - "L" - volume envelope enable
                                    ;bit 4 - unused
                                    ;bit 5 - "Z" - pitch envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 6 - "Y" - volume envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 7 - unused

psg_ch_size             rs.w    0   ;size of the struct
;psg_ch_size     equ     0x20

;==============================================================
;   FM Channel Structure
;==============================================================
    RSRESET
;fm channel instrument information
fm_ch_is_enabled        rs.b    1   ;0 (disabled) or !0 (enabled)
fm_ch_channel           rs.b    1   ;channel id (0-3)
fm_ch_note_time         rs.w    1   ;number of frames to hold the note for

fm_ch_stream_ptr        rs.l    1   ;pointer to stream of audio data

fm_ch_base_vol          rs.b    1   ;"base" volume (pre-trem/envelope)
fm_ch_note_name         rs.b    1   ;current note (pre-vibr/envelope)
fm_ch_note_octave       rs.b    1   ;current octave (pre-vibr/envelope)
fm_ch_algorithm         rs.b    1   ;algorithm (0-7)
fm_ch_lr_amfm           rs.b    1   ;LRAA xFFF

fm_ch_inst_ptr          rs.l    1   ;pointer to "base" instrument data

;fm channel automation information
fm_ch_freq_auto_idx     rs.b    1   ;index into pitchbend envelope
fm_ch_freq_auto_time    rs.b    1   ;number of frames on each index
fm_ch_freq_auto_ptr     rs.l    1   ;pointer to the envelope

fm_ch_vol_auto_idx      rs.b    1   ;index into volume envelope
fm_ch_vol_auto_time     rs.b    1   ;number of frames on each index
fm_ch_vol_auto_ptr      rs.l    1   ;pointer to the envelope

fm_ch_st_auto_idx       rs.b    1   ;index into stereo envelope
fm_ch_st_auto_time      rs.b    1   ;number of frames on each index
fm_ch_st_auto_ptr       rs.l    1   ;pointer to the envelope

fm_ch_vibrato_time      rs.b    1   ;number of frames before increment/decrement
fm_ch_vibrato_size      rs.b    1   ;max deviation from base frequency

fm_ch_tremelo_time      rs.b    1   ;number of frames before increment/decrement
fm_ch_tremelo_size      rs.b    1   ;max deviation from base volume

fm_ch_auto_flags        rs.b    1   ;XYZS LPTV
                                    ;bit 0 - "V" - vibrato enable
                                    ;bit 1 - "T" - tremelo enable
                                    ;bit 2 - "P" - pitch envelope enable
                                    ;bit 3 - "L" - volume envelope enable
                                    ;bit 4 - "S" - stereo envelope enable
                                    ;bit 5 - "Z" - pitch envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 6 - "Y" - volume envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 7 - "X" - stereo envelope mode (0 - one-shot, 1 - loop)


fm_ch_size              rs.w    0   ;size of the struct


;==============================================================
; MEMORY MAP
;==============================================================
	RSSET 0x00FF1000    
; PSG Channel Headers:
ch_psg_0                    rs.b    psg_ch_size
ch_psg_1                    rs.b    psg_ch_size
ch_psg_2                    rs.b    psg_ch_size
ch_psg_noise                rs.b    psg_ch_size

ch_fm_1                     rs.b    fm_ch_size
ch_fm_2                     rs.b    fm_ch_size
ch_fm_3                     rs.b    fm_ch_size
ch_fm_4                     rs.b    fm_ch_size
ch_fm_5                     rs.b    fm_ch_size
ch_fm_6                     rs.b    fm_ch_size

;ch_dac                      rs.b    fm_ch_size    
;============================================================================
;   PSG Functions
;============================================================================

    include 'psg_helper_functions.asm'

;============================================================================
;   FM Functions
;============================================================================
  
    include 'fm_helper_functions.asm'
    
    
    include 'demo_song.asm'
    include 'demo_agr_14.asm'
