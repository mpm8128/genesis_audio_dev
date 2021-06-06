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
    move.b  fm_ch_wait_time(a5), d6    ;check note duration
    beq     @done_waiting               ;if duration == 0, read new code from stream
                                        ;else
    subi.b  #1, fm_ch_wait_time(a5)    ;decrement note duration counter
    beq     @done_waiting               ;   and check again so we don't wait too long
    rts                                 ;else return
    
@done_waiting:
    move.l  fm_ch_stream_ptr(a5), a4   ;a4 = stream pointer for the channel
    cmp.l   #0, a4                      ;null check
    beq     fm_load_first_section

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
    dc.l    stream_fm_hold
    dc.l    stream_fm_end_section

;==============================================================
;==============================================================
fm_load_first_section:
    ;load table pointers
    movea.l     fm_ch_section_ptr(a5), a3  ;a3 = section ptr
    movea.l     fm_ch_sequence_ptr(a5), a2 ;a2 = sequence ptr

    ;get section index from sequence_table[0]
    clr.w   d1              ;
    move.b  (a2), d1  ;d1.b = sequence_table[0]

    ;load stream pointer from section table
    lsl.w   #2, d1          ;longword-align
    movea.l (a3, d1.w), a4  ;a4 = next stream pointer 
    
    ;write back to struct
    moveq   #0, d0
    move.w  d0, fm_ch_sequence_idx(a5) 
    move.l  a4, fm_ch_stream_ptr(a5)
    bra read_fm_stream

;==============================================================
;   stream_fm_end_section
;==============================================================
stream_fm_end_section:
    ;load table pointers
    movea.l     fm_ch_section_ptr(a5), a3  ;a3 = section ptr
    movea.l     fm_ch_sequence_ptr(a5), a2 ;a2 = sequence ptr

    ;increment sequence index
    clr.w   d0                          ;
    move.w  fm_ch_sequence_idx(a5), d0  ;d0.w = old index
    addi.w  #1, d0                      ;increment index
    
    ;get section index from sequence table
    clr.w   d1              ;
    move.b  (a2, d0.w), d1  ;d1.b = sequence_table[d0]
    
    ;check if we're at the end of the table
    cmp.b   #-1, d1             ;if we're not at the end of the table
    bne @not_looping            ;   skip this section 
                                ;else
                                ;   handle looping
    
    move.b  $1(a2, d0.w), d0    ;d0.b = looping point
    
    ;get section index from sequence table again
    clr.w   d1              ;
    move.b  (a2, d0.w), d1  ;d1.b = sequence_table[d0]
    
@not_looping:
    ;load stream pointer from section table
    lsl.w   #2, d1          ;longword-align
    movea.l (a3, d1.w), a4  ;a4 = next stream pointer 
    
    ;write back to struct
    move.w  d0, fm_ch_sequence_idx(a5) 
    move.l  a4, fm_ch_stream_ptr(a5)
    
    bra read_fm_stream

;==============================================================
;   stream_fm_hold
;   code: sc_hold
;
;   waits for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   time to wait
;==============================================================
stream_fm_hold:
    move.b  (a4)+, fm_ch_wait_time(a5)      ;set note duration
    jmp exit_fm_stream                     ;cleanup and return

exit_fm_stream:
    move.l   a4, fm_ch_stream_ptr(a5)  ;save stream pointer back to channel struct
    rts

;==============================================================\
;   fm reg write
;parameters
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   register address
;       b   value to write
;==============================================================
stream_fm_reg_write:
    move.b  (a4)+, d0               ;d0 = address
    move.b  (a4)+, d1               ;d1 = value
    
    jsr     write_register_opn2
    
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
    ;move.b  fm_ch_channel(a5), d2           ;d2 = channel number
    ;jsr keyoff_FM_channel
    
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
    move.b  fm_ch_channel(a5), d2           ;d2 = channel number
    jsr     keyon_FM_channel                ;write keyon for fm channel

    ;move.b  (a4)+, fm_ch_wait_time(a5)      ;set note duration
    jmp read_fm_stream                         ;cleanup and return
    
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
    ;move.b  (a4)+, fm_ch_wait_time(a5)  ;set silence duration

    jmp read_fm_stream                     ;cleanup and return
    
;============================================================================
;   handle_all_psg_channels
;============================================================================
handle_all_psg_channels:
    lea ch_psg_0, a5        ;a5 = pointer to first psg channel struct
    moveq   #3, d7          ;number of PSG channels -1 (loop counter)
    
    ;for each channel
@loop_psg_ch:
    btst  #7, psg_ch_inst_flags(a5)   ;if channel is disabled
    beq @next_channel               ;   skip it
                                    ;else
    jsr handle_psg_stream           ;   read stream events
    jsr handle_psg_adsr             ;   adjust with envelope
    jsr psg_driver_write_to_chip    ;   write to chip
@next_channel
    adda.w  #psg_ch_size, a5         ;next channel
    dbf d7, @loop_psg_ch            ;loop end
    
    rts
    
;============================================================================
;   handle_psg_stream
;parameter: pointer to psg channel struct in a5
;unusable: d7   
;============================================================================
handle_psg_stream:
    move.b  psg_ch_wait_time(a5), d6    ;check note duration
    beq     @done_waiting               ;if duration == 0, read new code from stream
                                        ;else
    subi.b  #1, psg_ch_wait_time(a5)    ;decrement note duration counter
    beq     @done_waiting               ;   and check again so we don't wait too long
    rts                                 ;else return
    
@done_waiting:
    move.l  psg_ch_stream_ptr(a5), a4   ;a4 = stream pointer for the channel
    cmp.l   #0, a4                      ;null check
    beq     stream_fm_end_section
    ;beq     exit_psg_stream             ;if stream ptr == null, cleanup and return
    
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
    dc.l    stream_psg_hold
    dc.l    stream_psg_end_section
    
    
;============================================================================
;   stream_psg_end_section
;       advances stream to the next section
;
;parameters:
;   a4 - old stream pointer
;   a5 - channel struct pointer
;       psg_ch_section_ptr
;       psg_ch_sequence_ptr
;============================================================================
stream_psg_end_section:
    ;load table pointers
    movea.l     psg_ch_section_ptr(a5), a3  ;a3 = section ptr
    movea.l     psg_ch_sequence_ptr(a5), a2 ;a2 = sequence ptr

    ;increment sequence index
    clr.w   d0                          ;
    move.b  psg_ch_sequence_idx(a5), d0 ;d0.w = old index
    addi.b  #1, d0                      ;increment index
    
    ;get section index from sequence table
    clr.w   d1              ;
    move.b  (a2, d0.w), d1  ;d1.b = sequence_table[d0]
    
    ;check if we're at the end of the table
    cmp.b   #-1, d1             ;if we're not at the end of the table
    bne @not_looping            ;   skip this section 
                                ;else
                                ;   handle looping
    
    move.b  $1(a2, d0.w), d0    ;d0.b = looping point
    
    ;get section index from sequence table again
    clr.w   d1              ;
    move.b  (a2, d0.w), d1  ;d1.b = sequence_table[d0]
    
@not_looping:
    ;load stream pointer from section table
    lsl.w   #2, d1          ;longword-align
    movea.l (a3, d1.w), a4  ;a4 = next stream pointer 
    
    ;write back to struct
    move.w  d0, psg_ch_sequence_idx(a5) 
    move.l  a4, psg_ch_stream_ptr(a5)
    
    bra read_psg_stream
    
;============================================================================
;   stream_psg_reg_write
;============================================================================
;TODO
stream_psg_reg_write:
    bra read_psg_stream     ;read more from stream

;============================================================================
;   load psg instrument from stream
;============================================================================
stream_psg_load_instrument:
    move.w  a4, d6          ;copy address to d6 to compare
    btst    #0, d6          ;check if stream ptr is odd or even
    beq     @word_aligned   ;
    tst.b   (a4)+           ;align that bad boy
@word_aligned:
    movea.l (a4)+, a1               ;a1 = instrument pointer
    move.b  psg_ch_channel(a5), d2
    jsr     load_PSG_instrument
    bra read_psg_stream
    
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
;   exit_psg_stream
;       writes stream pointer back to channel struct and returns
;============================================================================
exit_psg_stream:
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
    clr.b   psg_ch_inst_flags(a5)   ;mark channel as "disabled"
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

    jmp read_psg_stream     ;read more from stream


stream_psg_hold:
    move.b  (a4)+, psg_ch_wait_time(a5)      ;set note duration
    jmp exit_psg_stream                     ;cleanup and return


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
    ext.w   d6                          ;sign-extend to word-length
    move.b  (a4)+,  d5                  ;d5 = note octave
    ext.w   d5                          ;sign-extend to word-length
    jsr get_psg_freq_from_note_name_and_octave  ;d1 = timer_value
    
    ;save to struct
    move.w  d1, psg_ch_base_freq(a5)
    move.w  d1, psg_ch_adj_freq(a5)
    
    bset    #6, psg_ch_inst_flags(a5)   ;set "keyon" flag
    bset    #4, psg_ch_inst_flags(a5)   ;set "pitch update" flag
    
    ;move.b  (a4)+, psg_ch_wait_time(a5) ;set note duration
    jmp read_psg_stream                 ;cleanup and return

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
    bset  #5, psg_ch_inst_flags(a5)     ;set keyoff flag

    ;move.b  (a4)+, psg_ch_wait_time(a5) ;set silence duration
    ;bra exit_psg_stream                 ;cleanup and return
    jmp read_psg_stream
    
;==============================================================
;   handle_psg_automation
;       gets called after stream handling, per channel
;   xYZx LPTV
;   bit 0 - "V" - vibrato enable
;   bit 1 - "T" - tremelo enable
;   bit 2 - "P" - pitch envelope enable
;   bit 3 - "L" - volume envelope enable
;   bit 4 - unused
;   bit 5 - "Z" - pitch envelope mode (0 - one-shot, 1 - loop)
;   bit 6 - "Y" - volume envelope mode (0 - one-shot, 1 - loop)
;   bit 7 - unused
;==============================================================
; handle_psg_automation:
    ; move.b  psg_ch_auto_flags(a5), d6   ;d6 = auto flags
    ; btst    #0, d6              ;check if vibrato is enabled
    ; beq     @skip_vibrato       ;if not, skip it
    ; ;jsr     handle_vibrato
; @skip_vibrato:

    ; btst    #1, d6
    ; beq     @skip_tremelo
    ; ;jsr    handle_tremelo
; @skip_tremelo:

    ; btst    #2, d6
    ; beq     @skip_pitch_envelope
    ; ;jsr    handle_pitch_envelope
; @skip_pitch_envelope

    ; btst    #3, d6
    ; beq     @skip_vol_envelope
    ; jsr     handle_vol_envelope
; @skip_vol_envelope:
    ; rts
    
    ; ;;
; handle_vol_envelope:
    ; move.w  psg_ch_vol_auto_idx(a5), d5     ;d5 = idx
    ; move.l  psg_ch_vol_auto_ptr(a5), a4     ;a4 = envelope
    ; move.b  (a4, d5.w), d1                  ;d1 = envelope[idx]
    ; move.b  psg_ch_channel(a5), d0
    ; jsr     PSG_SetVolume
    
    ; addi.w  #1, d5                          ;increment idx
    ; move.w  psg_ch_vol_auto_len(a5), d4
    ; cmp.w   d4, d5     
    ; blt     @cleanup
    
    ; btst    #6, d6
    ; bne     @loop_envelope
    ; ;else
    ; subi.w  #1, d5
    ; bra     @cleanup
; @loop_envelope
    ; ;move.w  psg_ch_vol_auto_len(a5), d6
    ; moveq   #0, d5
    
; @cleanup:
    ; move.w  d5, psg_ch_vol_auto_idx(a5)
    ; rts
    
;==============================================================
;   handle psg adsr
;==============================================================
handle_psg_adsr:
    move.b  psg_ch_inst_flags(a5), d0   ;d0 = inst flags
;@check_keyon:
    btst    #6, d0          ;check for keyon event
    beq     @no_keyon           
                            ;else handle keyon
    andi.b  #0x90, d0       ;clear everything but the "enable" bit
    move.b  psg_ch_attack_scaling(a5), psg_ch_adsr_counter(a5)
    bra     @handle_envelope
@no_keyon:
;@check_status
    btst    #2, d0                      ;check status bit
    beq     @check_keyoff         ;if clear, check keyoff
;@channel_silent:
    move.b  #0, d2  ;current vol = 0
    move.b  #0, d3  ;adsr counter = 0
    move.b  #4, d1  ;channel flags = keep status bit set
    bra     @writeback_to_struct

@check_keyoff:
    btst    #5, d0          ;check for keyoff event
    beq @no_keyoff
                            ;else handle keyoff
    bclr    #5, d0          ;clear keyoff bit
    ;ori.b   #0x03, d0       ;set bits 0-1 for release
    move.b  #0x93, d0
    
    move.b  psg_ch_release_scaling(a5), d3   ;reload adsr counter
    ;bra @check_release
@no_keyoff:

@handle_envelope:
    move.b  d0, d1                      ;d1 = copy of d0
    andi.b  #0x03, d1                   ;adsr bits only
    move.b  psg_ch_current_vol(a5), d2  ;d2 = cur_vol
    move.b  psg_ch_adsr_counter(a5), d3 ;d3 = adsr counter

;@check_attack:
    cmp.b   #0x00, d1        ;check if attack
    bne     @check_decay
                            ;else handle attack
;@check attack scaling
    tst.b   d3                      ;if d3 <= 0
    ble     @apply_attack           ;   apply attack
                                    ;else 
    subq    #1, d3                  ;   d3--
    bra     @writeback_to_struct    ;   writeback
@apply_attack:
    move.b  psg_ch_attack_scaling(a5), d3   ;reload adsr counter
    add.b   psg_ch_attack_rate(a5), d2  ;d2 + ar
    cmp.b   psg_ch_max_level(a5), d2    ;if max_vol > d2
    blt     @writeback_to_struct           ;write to struct and return
                                        ;else (max_vol <= d2)
    move.b  psg_ch_max_level(a5), d2    ;d2 = max_vol
    bra     @next_state
    
@check_decay:
    cmp.b   #0x01, d1               ;check decay
    bne     @check_sustain
;@check decay scaling
    tst.b   d3                      ;if d3 <= 0
    ble     @apply_decay            ;   apply decay
                                    ;else 
    subq    #1, d3                  ;   d3--
    bra     @writeback_to_struct    ;   writeback
@apply_decay:
    move.b  psg_ch_decay_scaling(a5), d3    ;reload adsr counter
    sub.b   psg_ch_decay_rate(a5), d2       ;d2 - dr
    cmp.b   psg_ch_sus_level(a5), d2        ;if sus_vol < d2
    bgt     @writeback_to_struct            ;write to struct
                                            ;else (sus_vol >= d2)
    move.b  psg_ch_sus_level(a5), d2        ;d2 = sus_vol
    bra     @next_state
    
@check_sustain:
    cmp.b   #0x02, d1           ;check sustain
    beq     @cleanup_and_return ;don't do anything for sustain
@check_release:
    cmp.b   #0x03, d1
    bne     @just_return
;@check release scaling
    tst.b   d3                      ;if d3 <= 0
    ble     @apply_release          ;   apply release
                                    ;else 
    subq    #1, d3                  ;   d3--
    bra     @writeback_to_struct    ;   writeback
@apply_release:
    move.b  psg_ch_release_scaling(a5), d3   ;reload adsr counter

    sub.b   psg_ch_release_rate(a5), d2 ;d2 - rr
    tst.b   d2                          ;if d2 > 0
    bgt     @writeback_to_struct        ;   write to struct   
                                        ;else (d2 < 0)
    clr.b   d2                          ;   d2 = 0
@next_state:
    addi.b  #1, d1                      ;state++
@writeback_to_struct:
    move.b  d2, psg_ch_current_vol(a5)  ;writeback vol
    move.b  d3, psg_ch_adsr_counter(a5) ;writeback adsr counter
    bra @cleanup_and_return
@cleanup_and_return:
    andi.b  #0x90, d0                   ;mask off low bits
    or.b    d1, d0                      ;d0 |= d1
    move.b  d0, psg_ch_inst_flags(a5)   ;write to struct
@just_return:
    rts
    
;==============================================================
;   psg write to chip
;==============================================================
psg_driver_write_to_chip:
    move.b  psg_ch_channel(a5), d0      ;d0 = channel
    move.b  psg_ch_current_vol(a5), d1  ;d1 = vol
    jsr PSG_SetVolume       ;(channel (d0.b), vol (d1.b))
    
    move.b psg_ch_inst_flags(a5), d5
    btst    #4, d5  ;check pitch update flag
    beq     @return
    bclr    #4, d5  ;clear pitch update flag
    move.b  psg_ch_channel(a5), d0      ;d0 = channel
    move.w  psg_ch_adj_freq(a5), d1      ;d0 = channel
    jsr PSG_SetFrequency    ;(channel (d0.b), counter (d1.w))
    move.b  d5, psg_ch_inst_flags(a5)
@return
    rts
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
sc_hold         rs.b        1
sc_end_section  rs.b        1
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
    
    include 'channel_structs.asm'
  
;================================================
    RSRESET
offset_demo         rs.l    2
offset_cza_3        rs.l    2
offset_agr_14       rs.l    2
offset_mb           rs.l    2
num_songs           rs.l    0

    even
song_table:
    ;dc.l    demo_song_parts_table
    ;       channel table,        section table
    dc.l    demo_channel_table, demo_section_table
    dc.l    cza_3_parts_table, 0
    dc.l    agr_14_parts_table, 0
    dc.l    mission_briefing_parts_table, 0
    
    
;================================================
;   parameter - d0.w    index of song
;================================================
load_song_from_parts_table:
    lsl.w   #1, d0      ;2x longword-align d0
    lea     song_table, a0  ;a0 = *songtable
    movea.l $4(a0,d0.w), a2 ;a2 = section_table
    movea.l $0(a0,d0.w), a0   ;a0 = channel_table
                            ;[channel_table, section_table]
    
    ;load FM channels
@load_channel_1:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_2
    lea ch_fm_1, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #0, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
@load_channel_2:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_3
    lea ch_fm_2, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #1, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
@load_channel_3:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_4
    lea ch_fm_3, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #2, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
@load_channel_4:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_5
    lea ch_fm_4, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #4, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
@load_channel_5:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_6
    lea ch_fm_5, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #5, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
@load_channel_6:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_psg_channels
    lea ch_fm_6, a5     ;channel 
    move.b #1, fm_ch_is_enabled(a5)
    move.b #6, fm_ch_channel(a5)
    move.l  a1, fm_ch_sequence_ptr(a5)
    move.l  #0, fm_ch_stream_ptr(a5)
    move.l  a2, fm_ch_section_ptr(a5)
    
;do PSG
@load_psg_channels:

    moveq   #3, d1  ;loop counter
    move.b  #0, d2  ;channel number
    lea ch_psg_0, a5
@for_each_psg_channel
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @next_psg_channel
    move.b  #0x80, psg_ch_inst_flags(a5)
    move.b  d2, psg_ch_channel(a5)
    move.l  a1, psg_ch_sequence_ptr(a5)
    move.l  #0, psg_ch_stream_ptr(a5)
    move.l  a2, psg_ch_section_ptr(a5)
@next_psg_channel
    adda.w  #psg_ch_size, a5
    addi.b  #1, d2
    dbf d1, @for_each_psg_channel

    rts
  
;============================================================================
;   PSG Functions
;============================================================================

    include 'psg_helper_functions.asm'

;============================================================================
;   FM Functions
;============================================================================
  
    include 'fm_helper_functions.asm'
    
;============================================================================
;   Song macros and includes
;============================================================================

M_play_shortnote: macro note, octave, duration
    ;dc.b    sc_keyon, \note, \octave, \duration
    dc.b    sc_keyon, \note, \octave
    dc.b    sc_hold, \duration
    dc.b    sc_keyoff
    endm

M_play_longnote: macro note, octave, duration
longtime = (\duration)
    dc.b    sc_keyon, \note, \octave
    do
    dc.b    sc_hold, 255
longtime = (longtime-255)
    until   (longtime<256)
    dc.b    sc_hold, longtime
    dc.b    sc_keyoff
    endm
    
M_play_note: macro note, octave, duration
    if (\duration<256)
    M_play_shortnote \note, \octave, \duration
    else
    M_play_longnote \note, \octave, \duration
    endc
    endm
    
M_start_note: macro note, octave
    dc.b    sc_keyon, \note, \octave
    endm
    
M_stop_note: macro
    dc.b    sc_keyoff
    endm

M_play_shortrest: macro duration
    dc.b    sc_keyoff
    dc.b    sc_hold, \duration
    endm

M_play_longrest: macro duration
longtime = (\duration)
    dc.b    sc_keyoff
    do
    dc.b    sc_hold, 255
longtime = (longtime-255)
    until   (longtime<256)
    dc.b    sc_hold, longtime
    endm

M_play_rest: macro duration
    if (\duration<256)
    M_play_shortrest \duration
    else
    M_play_longrest \duration
    endc
    endm
    
    include 'instrument_defs.asm'
    
    include 'songs/demo_section_table.asm'
    include 'songs/a_mystery.asm'
    include 'songs/agr_14.asm'
    include 'songs/cza_3.asm'
    include 'songs/mission_briefing.asm'
