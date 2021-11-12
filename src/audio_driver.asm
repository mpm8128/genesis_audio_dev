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
    move.w  #$0, z80_bus_request_addr
    endm
    
M_split_by_channel_type: macro psg_fn, fm_fn, dac_fn, q_fn
    move.b  ch_channel_flags(a5), d5    ;d5 = channel flags
    andi.b  #0x0C, d5                   ;mask type bits
    
    tst.b   d5          ;if d5 == xxxx 00xx, PSG
    beq \psg_fn
    cmp.b   #0x04, d5   ;if d5 == xxxx 01xx, FM
    beq \fm_fn
    cmp.b   #0x08, d5   ;if d5 == xxxx 10xx, DAC/PCM (sample)
    beq \dac_fn
    ;else d5 == xxxx 11xx, "????" case?
    bra \q_fn
    endm
    

;============================================================================
;   Entry point -> audio_driver
;============================================================================

    ;top-level function for the audio driver
    ;this is the entry point for this 'module'
audio_driver:
    ;jsr top_level_stuff
    ;jsr handle_dac                  ;communication with z80
    jsr handle_all_fm_channels      ;all fm channels    
    jsr handle_all_psg_channels     ;all psg channels

    rts
    
    
;============================================================================
;   handle dac
;============================================================================
;handle_dac:
    
    ;rts
    
;============================================================================
;   pauses the z80 and sets up the 2612 for FM writes
;============================================================================
handle_all_fm_start:
    M_request_Z80_bus
    
    ;disable DAC
    move.b  0x2B, d0    ;DAC enable register
    move.b  0x00, d1    ;disable it
    jsr write_register_opn2_ctrl    ;write to chip
    rts
    

;============================================================================
;   unpauses the z80 and sets up the 2612 for DAC writes
;============================================================================
handle_all_fm_end:
    ;re-enable DAC
    move.b  0x2B, d0    ;DAC enable register
    move.b  0xFF, d1    ;enable it
    jsr write_register_opn2_ctrl    ;write to chip

    ;set address to DAC so the z80 doesn't have to
    move.b  0x2A, d0        ;DAC data register
    jsr set_address_opn2    ;write to chip

    ;unpause the z80
    M_return_Z80_bus
    rts


    
;============================================================================
;   handle_all_fm_channels
;============================================================================
handle_all_fm_channels:
    jsr handle_all_fm_start

    lea ch_fm_1, a5     ;a5 = pointer to first fm channel struct
    moveq   #5, d7      ;d7 = number of FM channels -1 (loop counter)
    
    ;for each channel
@loop_fm_ch:
    btst  #0, ch_channel_flags(a5)  ;if channel is disabled
    beq @next_channel               ;   skip it
                                    ;else
    jsr handle_stream               ;   handle stream events
    jsr handle_vibrato
    jsr handle_pitchbend            ;   handle pitchbend
    ;jsr envelopes                  ;   handle any active envelopes
    jsr fm_driver_write_to_chip
@next_channel:
    adda.w  #fm_ch_size, a5         ;next channel
    dbf d7, @loop_fm_ch             ;loop end

    jsr handle_all_fm_end
    rts

;============================================================================
;   handle_all_psg_channels
;============================================================================
handle_all_psg_channels:
    lea ch_psg_0, a5        ;a5 = pointer to first psg channel struct
    moveq   #3, d7          ;number of PSG channels -1 (loop counter)
    
    ;for each channel
@loop_psg_ch:
    btst  #0, ch_channel_flags(a5)  ;if channel is disabled
    beq @next_channel               ;   skip it
                                    ;else
    jsr handle_stream               ;   read stream events
    jsr handle_psg_adsr             ;   adjust with envelope
    jsr handle_vibrato
    jsr handle_pitchbend        ;   handle pitchbend
    jsr psg_driver_write_to_chip    ;   write to chip
@next_channel
    adda.w  #psg_ch_size, a5            ;next channel
    dbf d7, @loop_psg_ch            ;loop end
    
    rts
  
;============================================================================
;   handle_stream
;
;parameter: pointer to psg channel struct in a5
;unusable: d7   
;============================================================================
handle_stream:
    move.b  ch_wait_time(a5), d6    ;check note duration
    beq     @done_waiting               ;if duration == 0, read new code from stream
                                        ;else
    subi.b  #1, ch_wait_time(a5)    ;decrement note duration counter
    beq     @done_waiting               ;   and check again so we don't wait too long
    rts                                 ;else return
    
@done_waiting:
    move.l  ch_stream_ptr(a5), a4   ;a4 = stream pointer for the channel
    cmp.l   #0, a4                      ;null check
    beq     stream_load_first_section

read_stream:
    clr.w   d6                      ;needs to be a clean slate for the cmp ahead
    lea     stream_jumptable, a3    ;a3 = jumptable pointer
    move.b  (a4)+, d6               ;read code from stream
    cmp     #num_sc, d6             ;if code# > number of codes
    bgt     bad_stream_code         ;   handle stream error
                                    ;else
    lsl.w   #2, d6                  ;   longword-align
    movea.l (a3, d6.w), a3          ;   a3 = indexed function
    jmp     (a3)                    ;   call the indexed function

    ;table of functions indexed by stream codes
stream_jumptable:
    dc.l    stream_stop    
    dc.l    stream_loop
    dc.l    stream_keyon
    dc.l    stream_keyoff    
    dc.l    stream_load_instrument
    dc.l    stream_reg_write
    dc.l    stream_hold
    dc.l    stream_end_section
    dc.l    stream_pitchbend
    dc.l    stream_vibrato
    dc.l    stream_send_z80_signal
    
;==============================================================
;   stream_load_first_section
;
;   special code for loading the first section
;==============================================================
stream_load_first_section:
    ;load table pointers
    movea.l ch_section_ptr(a5),  a3 ;a3 = section ptr
    movea.l ch_sequence_ptr(a5), a2 ;a2 = sequence ptr

    ;get section index from sequence_table[0]
    clr.w   d1              ;
    move.b  (a2), d1        ;d1.b = sequence_table[0]

    ;load stream pointer from section table
    lsl.w   #2, d1          ;longword-align
    movea.l (a3, d1.w), a4  ;a4 = next stream pointer 
    
    ;write back to struct
    moveq   #0, d0
    move.w  d0, ch_sequence_idx(a5) 
    move.l  a4, ch_stream_ptr(a5)
    bra read_stream


;==============================================================
;   stream_send_z80_signal
;
;parameters:
;   a4 - stream pointer
;       b   data to put in mailbox
;==============================================================
stream_send_z80_signal:
    move.b  (a4)+, d0
    jsr dac_send_signal_code
    bra read_stream


;==============================================================
;   stream_end_section
;==============================================================
stream_end_section:
    ;load table pointers
    movea.l ch_section_ptr(a5),  a3 ;a3 = section ptr
    movea.l ch_sequence_ptr(a5), a2 ;a2 = sequence ptr

    ;increment sequence index
    clr.w   d0                      ;
    move.w  ch_sequence_idx(a5), d0 ;d0.w = old index
    addi.w  #1, d0                  ;increment index
    
    ;get section index from sequence table
    clr.w   d1                  ;
    move.b  (a2, d0.w), d1      ;d1.b = sequence_table[d0]
    
    ;check if we're at the end of the table
    cmp.b   #-1, d1             ;if we're not at the end of the table
    bne @not_looping            ;   skip this section 
                                ;else
                                ;   handle looping
    
    move.b  $1(a2, d0.w), d0    ;d0.b = looping point
    
    ;get section index from sequence table again
    clr.w   d1                  ;
    move.b  (a2, d0.w), d1      ;d1.b = sequence_table[d0]
    
@not_looping:
    ;load stream pointer from section table
    lsl.w   #2, d1              ;longword-align
    movea.l (a3, d1.w), a4      ;a4 = next stream pointer 
    
    ;write back to struct
    move.w  d0, ch_sequence_idx(a5) 
    move.l  a4, ch_stream_ptr(a5)
    
    bra read_stream

;==============================================================
;   stream_hold
;   code: sc_hold
;
;   waits for [duration]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   time to wait
;==============================================================
stream_hold:
    move.b  (a4)+, ch_wait_time(a5) ;set note duration
    jmp exit_stream                 ;cleanup and return

exit_stream:
    move.l   a4, ch_stream_ptr(a5)  ;save stream pointer back to channel struct
    rts

;==============================================================
;   stream_reg_write
;parameters
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   register address
;       b   value to write
;==============================================================
stream_reg_write:
    M_split_by_channel_type stream_psg_reg_write, &
                            stream_fm_reg_write, &
                            read_stream, &
                            read_stream
;--------------------------------------------------------------
;   stream_psg_reg_write
;       TODO
;--------------------------------------------------------------
stream_psg_reg_write:
    move.b  (a4)+, d0   ;register
    move.b  (a4)+, d1   ;value
    bra read_stream     ;read more from stream
    
;--------------------------------------------------------------
;   stream_fm_reg_write
;--------------------------------------------------------------
stream_fm_reg_write:
    move.b  (a4)+, d0               ;d0 = address
    move.b  (a4)+, d1               ;d1 = value
    jsr     write_register_opn2
    bra read_stream  ;read more from stream

;==============================================================
;   stream_load_instrument
;
;   Determines if channel is PSG or FM, then calls the
;       appropriate helper function
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       l   pointer to instrument data
;==============================================================
stream_load_instrument:
    move.w  a4, d6              ;copy address to d6 to compare
    btst    #0, d6              ;check if stream ptr is odd or even
    beq     @word_aligned       ;
    tst.b   (a4)+               ;align that bad boy
@word_aligned:
    movea.l (a4)+, a1           ;a1 = instrument pointer
    M_split_by_channel_type stream_psg_load_instrument, &
                            stream_fm_load_instrument, &
                            read_stream, &
                            read_stream
    
;--------------------------------------------------------------
;   stream_psg_load_instrument
;   code: sc_load_inst
;
;   loads a PSG instrument from the specified address
;--------------------------------------------------------------
stream_psg_load_instrument:
    jsr load_PSG_instrument
    bra read_stream
    
;--------------------------------------------------------------
;   stream_fm_load_instrument
;   code: sc_load_inst
;
;   loads an FM instrument from the specified address
;--------------------------------------------------------------
stream_fm_load_instrument:
    jsr load_FM_instrument
    bra read_stream

;==============================================================
;   stream_stop
;   code: sc_stop
;
;   mutes the channel and marks it as disabled, wipes stream ptr
;
;parameters:
;   a5 - channel struct pointer
;==============================================================
stream_stop:
    clr.b   ch_channel_flags(a5)    ;mark channel as "disabled"
    clr.l   ch_stream_ptr(a5)       ;wipe stream pointer
    
    M_split_by_channel_type stream_psg_stop, &
                            stream_fm_stop, &
                            return, &
                            return

;--------------------------------------------------------------
;   stream_psg_stop
;   code: sc_stop
;--------------------------------------------------------------
stream_psg_stop:
    move.b  ch_channel_num(a5), d0  ;d0 = channel number
    move.b  #0, d1                  ;d1 = volume 0 (max attenuation)    
    jsr     PSG_SetVolume           ;PSG_SetVolume(channel, 0)
    rts

;--------------------------------------------------------------
;   stream_fm_stop
;   code: sc_stop
;--------------------------------------------------------------
stream_fm_stop:
    move.b  ch_channel_num(a5), d2  ;d2 = channel number
    jsr     quick_mute_FM_channel   ;disable both stereo channels
    jsr     keyoff_FM_channel       ;write keyoff
return:
    rts
    
;==============================================================
;   stream_loop
;   code: sc_loop
;
;   moves the stream pointer to location specified in [addr]
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       l   pointer to looping point
;==============================================================
stream_loop:
    move.w  a4, d6          ;copy address to d6 to compare
    btst    #0, d6          ;check if stream ptr is odd or even
    beq     @word_aligned   ;
    tst.b   (a4)+           ;align that bad boy
@word_aligned:
    ;move new stream location to channel struct
    move.l  (a4), ch_stream_ptr(a5)
    move.l  ch_stream_ptr(a5), a4

    bra read_stream         ;read more from stream

;==============================================================
;   stream_keyon
;   code: sc_keyon
;
;   writes "keyon" and pitch information ([note], [octave]) 
;       from stream
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   note_name
;       b   note_octave
;==============================================================
stream_keyon:
    move.b  (a4)+,  d6              ;d6 = note name
    ext.w   d6                      ;sign-extend to word-length
    move.b  d6, ch_note_name(a5)    ;write to struct also

    move.b  (a4)+,  d0              ;d0 = note octave
    ext.w   d0                      ;sign-extend to word-length
    move.b  d0, ch_note_octave(a5)  ;write to struct also

    M_split_by_channel_type stream_psg_keyon, &
                            stream_fm_keyon, &
                            read_stream, &
                            read_stream
                            
stream_keyon_cleanup:
    ;save to struct
    move.w  d1, ch_base_freq(a5)
    move.w  d1, ch_adj_freq(a5)
    bset    #6, ch_inst_flags(a5)   ;set "keyon" flag
    bset    #4, ch_inst_flags(a5)   ;set "pitch update" flag
    jmp read_stream
;--------------------------------------------------------------
;   stream_psg_keyon
;   code: sc_keyon
;--------------------------------------------------------------
stream_psg_keyon:
    move.w  d0, d5  ;restore note octave to d5
    jsr get_psg_freq_from_note_name_and_octave  ;d1 = timer_value
    bra stream_keyon_cleanup
    
;--------------------------------------------------------------
;   stream_fm_keyon
;   code: sc_keyon
;--------------------------------------------------------------
stream_fm_keyon:
    lea     fm_frequency_table, a0
    lsl.w   #1, d6                          ;word-align
    move.w  (a0, d6.w), d1                  ;d1.w = frequency number
    bra stream_keyon_cleanup
    
;==============================================================
;   stream_keyoff
;   code: sc_keyoff
;
;   handles keyoff events from the stream
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;==============================================================
stream_keyoff:
    bset  #5, ch_inst_flags(a5)     ;set keyoff flag
    jmp read_stream

    M_split_by_channel_type stream_psg_keyoff, &
                            stream_fm_keyoff, &
                            read_stream, &
                            read_stream

;--------------------------------------------------------------
;   stream_psg_keyoff
;   code: sc_keyoff
;
;   marks the "keyoff" flag in the channel struct
;--------------------------------------------------------------
stream_psg_keyoff:    
    bset  #5, ch_inst_flags(a5)     ;set keyoff flag
    jmp read_stream

;--------------------------------------------------------------
;   stream_fm_keyoff
;   code: sc_keyoff
;
;   writes "keyoff" to the 2612
;--------------------------------------------------------------
stream_fm_keyoff:
    move.b  ch_channel_num(a5), d2  ;d2 = channel number
    jsr     keyoff_FM_channel       ;write keyoff to 2612
    jmp     read_stream             ;cleanup and return
    
;==============================================================
;   stream_pitchbend  
;   code: sc_pitchbend
;
;   sets pitchbend rate/scale
;       rate 0 is no pitchbend              
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b   rate (signed amount to bend)
;       b   scale (number of frames to wait)
;==============================================================
stream_pitchbend:
    move.b  (a4)+, d0   ;rate
    M_split_by_channel_type @invert, @no_invert, @no_invert, @no_invert
    
@invert:
    neg.b   d0          ;switch sign because psg chip is backwards
    
@no_invert:
    move.b  d0, ch_pitchbend_rate(a5)
    
    move.b  (a4)+, d0   ;scaling
    move.b  d0, ch_pitchbend_scaling(a5)
    move.b  d0, ch_pitchbend_counter(a5)
    bra read_stream

;==============================================================
;   stream_vibrato
;   code: sc_vibrato
;
;   sets vibrato speed and depth
;
;parameters:
;   a5 - channel struct pointer
;   a4 - stream pointer
;       b - speed (quarter of a period)
;       b - depth (max deviation from base value)
;==============================================================
stream_vibrato:
    ;move.b  (a4)+, ch_vibrato_speed(a5)
    move.b  (a4)+, d0   ;vibrato speed
    move.b  d0, ch_vibrato_speed(a5)
    move.b  d0, ch_vibrato_counter(a5)  ;reset counter
    ext.w   d0
    
    move.b  (a4)+, d1   ;ch_vibrato_depth(a5)
    move.b  d1, ch_vibrato_depth(a5)
    ext.w   d1
    
    tst.w   d0
    beq     @skip_div   ;don't divide by zero
    tst.w   d1
    beq     @skip_div   ;don't divide zero by anything
    
    divu    d0, d1  ;d1 = d1/d0 [16b(r), 16b(q)]
                    ;d1 = vibrato rate
                    ;ignore remainder
@skip_div:
    move.b  d1, ch_vibrato_rate(a5)
    
    ;reset adj_freq from any previous vibrato/automation
    move.w  ch_base_freq(a5), ch_adj_freq(a5)
    
    jmp read_stream

    
;============================================================================
;   handle_pitchbend
;============================================================================
handle_pitchbend:
    tst.b   ch_pitchbend_rate(a5)
    beq     @return

    move.b  ch_inst_flags(a5), d0
    move.w  ch_adj_freq(a5), d1    
    move.b  ch_pitchbend_counter(a5), d3

;@check pitchbend
    tst.b   d3
    ble     @apply_pitchbend
    ;else
    subq    #1, d3
    bra     @writeback_to_struct

@apply_pitchbend:
    bset    #4, d0                              ;"update pitch" flag
    move.b  ch_pitchbend_scaling(a5), d3    ;reload counter
    move.b  ch_pitchbend_rate(a5), d2       ;d2 = rate
    ext.w   d2                                  ;sign-extend rate
    add.w   d2, d1                              ;d1 = freq + adjustment
    
    M_split_by_channel_type @clip_psg_freq, &
                            @clip_fm_freq, &
                            @writeback_to_struct, &
                            @writeback_to_struct

@clip_psg_freq
;@check max freq
    cmp.w   #max_psg_freq, d1       ;
    blt     @psg_check_min_freq         ;
    move.w  #max_psg_freq, d1       ;clip
    bra     @writeback_to_struct    ;
@psg_check_min_freq:
    cmp.w   #min_psg_freq, d1       ;
    bgt     @writeback_to_struct    ;
    move.w  #min_psg_freq, d1       ;clip
    bra     @writeback_to_struct    ;

@clip_fm_freq
;@check max freq
    cmp.w   #max_fm_freq, d1        ;
    blt     @fm_check_min_freq         ;
    move.w  #max_fm_freq, d1        ;clip
    bra     @writeback_to_struct    ;
@fm_check_min_freq:
    cmp.w   #min_fm_freq, d1        ;
    bgt     @writeback_to_struct    ;
    move.w  #min_fm_freq, d1        ;clip
    ;bra     @writeback_to_struct    ;

@writeback_to_struct:
    move.b  d0, ch_inst_flags(a5)
    move.w  d1, ch_adj_freq(a5)
    move.w  d1, ch_base_freq(a5)    ;overwrite base freq too
                                    ;this will play nicer with 
                                    ; vibrato and other automation

    move.b  d3, ch_pitchbend_counter(a5)
    
@return:
    rts
    
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
    move.b  ch_inst_flags(a5), d0   ;d0 = inst flags
;@check_keyon:
    btst    #6, d0          ;check for keyon event
    beq     @no_keyon
                            ;else handle keyon
    andi.b  #0x90, d0       ;clear everything but the "enable" bit
    move.b  ch_attack_scaling(a5), ch_adsr_counter(a5)
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
    move.b  #0x93, d0
    
    move.b  ch_release_scaling(a5), d3   ;reload adsr counter
    ;bra @check_release
@no_keyoff:

@handle_envelope:
    move.b  d0, d1                      ;d1 = copy of d0
    andi.b  #0x03, d1                   ;adsr bits only
    move.b  ch_current_vol(a5), d2  ;d2 = cur_vol
    move.b  ch_adsr_counter(a5), d3 ;d3 = adsr counter

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
    move.b  ch_attack_scaling(a5), d3   ;reload adsr counter
    add.b   ch_attack_rate(a5), d2  ;d2 + ar
    cmp.b   ch_max_level(a5), d2    ;if max_vol > d2
    blt     @writeback_to_struct           ;write to struct and return
                                        ;else (max_vol <= d2)
    move.b  ch_max_level(a5), d2    ;d2 = max_vol
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
    move.b  ch_decay_scaling(a5), d3    ;reload adsr counter
    sub.b   ch_decay_rate(a5), d2       ;d2 - dr
    cmp.b   ch_sus_level(a5), d2        ;if sus_vol < d2
    bgt     @writeback_to_struct            ;write to struct
                                            ;else (sus_vol >= d2)
    move.b  ch_sus_level(a5), d2        ;d2 = sus_vol
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
    move.b  ch_release_scaling(a5), d3   ;reload adsr counter

    sub.b   ch_release_rate(a5), d2 ;d2 - rr
    tst.b   d2                          ;if d2 > 0
    bgt     @writeback_to_struct        ;   write to struct   
                                        ;else (d2 < 0)
    clr.b   d2                          ;   d2 = 0
@next_state:
    addi.b  #1, d1                      ;state++
@writeback_to_struct:
    move.b  d2, ch_current_vol(a5)  ;writeback vol
    move.b  d3, ch_adsr_counter(a5) ;writeback adsr counter
    bra @cleanup_and_return
@cleanup_and_return:
    andi.b  #0x90, d0                   ;mask off low bits
    or.b    d1, d0                      ;d0 |= d1
    move.b  d0, ch_inst_flags(a5)   ;write to struct
@just_return:
    rts
    
;==============================================================
;   handle_vibrato
;==============================================================
handle_vibrato:
    tst.b   ch_vibrato_depth(a5)
    beq     @return ;no action needed if depth is zero
    ;else depth != 0
    
;@adjust_pitch
    move.b  ch_inst_flags(a5), d0       ;d0 = inst flags
    bset    #4, d0      ; set "update pitch" flag

    move.b  ch_vibrato_rate(a5), d2     ;d2 = rate
    ext.w   d2  ;sign-extend rate
    move.w  ch_adj_freq(a5), d1     ;d1 = adj freq
    add.w   d2, d1  ;adj freq = adj + rate

    move.b  ch_vibrato_counter(a5), d3  ;d3 = counter
    
    tst.b   d3  ;if counter == 0
    ble     @switch_direction
    ;else
    subi.b  #1, d3
    bra     @writeback_to_struct
    
@switch_direction:
    move.b  ch_vibrato_speed(a5), d3    ;reload counter
    lsl.b   #1, d3      ;counter = 1/2 period
    ;d2 = rate
    neg.b   d2  ;invert d2 and write it back
    move.b  d2, ch_vibrato_rate(a5)
    
@writeback_to_struct:
    move.b  d0, ch_inst_flags(a5)
    move.w  d1, ch_adj_freq(a5)
    move.b  d3, ch_vibrato_counter(a5)
@return:
    rts
    
;==============================================================
;   psg write to chip
;==============================================================
psg_driver_write_to_chip:
    move.b  ch_channel_num(a5), d0  ;d0 = channel
    move.b  ch_current_vol(a5), d1  ;d1 = vol
    jsr PSG_SetVolume               ;(channel (d0.b), vol (d1.b))
    
    move.b  ch_inst_flags(a5), d5
    btst    #4, d5                  ;check pitch update flag
    beq     @return
    bclr    #4, d5                  ;clear pitch update flag
    move.b  ch_channel_num(a5), d0  ;d0 = channel
    move.w  ch_adj_freq(a5), d1     ;d0 = channel
    jsr PSG_SetFrequency            ;(channel (d0.b), counter (d1.w))
    move.b  d5, ch_inst_flags(a5)
@return
    rts
    
;==============================================================
;   fm write to chip
;==============================================================
fm_driver_write_to_chip:
    ;move.b  ch_channel_num(a5), d0  ;d0 = channel
    ;move.b  ch_current_vol(a5), d1  ;d1 = vol
    ;jsr PSG_SetVolume               ;(channel (d0.b), vol (d1.b))
    
    move.b  ch_inst_flags(a5), d5
@check_keyoff:
    btst    #5, d5  ;check keyoff
    beq     @check_pitch_update
    bclr    #5, d5  ;clear keyoff
    move.b  ch_channel_num(a5), d2
    jsr keyoff_FM_channel

@check_pitch_update:
    btst    #4, d5                  ;check pitch update flag
    beq     @check_keyon
    bclr    #4, d5                  ;clear pitch update flag

    move.b  ch_channel_num(a5), d2  ;d2 = channel
    move.w  ch_adj_freq(a5), d1     ;d1 = adjusted frequency
    move.b  ch_note_octave(a5), d0  ;d0 = octave (block)
    jsr set_FM_frequency            ;(channel (d0.b), counter (d1.w))
    
@check_keyon:
    btst    #6, d5          ;check keyon
    beq     @cleanup_and_return
    bclr    #6, d5          ;clear keyon
    move.b  ch_channel_num(a5), d2
    jsr     keyon_FM_channel

@cleanup_and_return
    move.b  d5, ch_inst_flags(a5)
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
sc_pitchbend    rs.b        1
sc_vibrato      rs.b        1
sc_signal_z80   rs.b        1
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
    ;include 'refactored_ch_structs.asm'
;================================================
song_record_size        equ     2
song_record_size_bytes  equ     (song_record_size*size_long)

    RSRESET
offset_silence      rs.l    song_record_size
offset_cza13        rs.l    song_record_size
offset_demo         rs.l    song_record_size
offset_cza3         rs.l    song_record_size
offset_aro2         rs.l    song_record_size
offset_cza18        rs.l    song_record_size
;offset_agr14        rs.l    2
;offset_mb           rs.l    2
num_songs           rs.l    0

    even
song_table:
    ;       channel table,              section table       ;,      ptr to name
    dc.l    silence_channel_table,  silence_section_table   ;,  silence_name
    dc.l    demo_channel_table,     demo_section_table      ;,     0
    dc.l    cza13_channel_table,    cza13_section_table     ;,    0
    dc.l    cza3_channel_table,     cza3_section_table      ;,     0
    dc.l    aro2_channel_table,     aro2_section_table
    dc.l    cza18_channel_table,    cza18_section_table     ;,    0
    ;dc.l    agr14_channel_table, agr14_section_table
    ;dc.l    mission_briefing_parts_table, 0
    
    even
silence_channel_table:
    dc.l    silence_fm  ;FM ch1
    dc.l    silence_fm  ;FM ch2
    dc.l    silence_fm  ;FM ch3
    dc.l    silence_fm  ;FM ch4
    dc.l    silence_fm  ;FM ch5
    dc.l    silence_fm  ;FM ch6
    dc.l    silence_psg ;psg ch0
    dc.l    silence_psg ;psg ch1       
    dc.l    silence_psg ;psg ch2        
    dc.l    silence_psg ;noise

silence_section_table:
    dc.l    mute_fm
    dc.l    mute_psg
    dc.l    stop_channel

mute_fm:
    dc.b    sc_keyoff
    dc.b    sc_reg_write, 0xB4, 0x00
    dc.b    sc_hold, 0xFE
    dc.b    sc_end_section
    
mute_psg:
    dc.b    sc_keyoff
    dc.b    sc_hold, 0xFE
    dc.b    sc_end_section
    
stop_channel:
    dc.b    sc_stop
    dc.b    sc_end_section
    
silence_fm:
    dc.b    0, -1, 0
    
silence_psg:
    dc.b    1, -1, 0
    
    even
;================================================
;   clear audio memory
;================================================
clear_audio_memory:
    moveq   #3, d3             ;num psg channels -1
    lea     ch_psg_0, a3        ;RAM pointer
@for_each_psg:
    move.w  #(psg_ch_size-1), d4    ;size of channel
@clear_single_psg:
    clr.b   (a3)+
    dbf d4, @clear_single_psg
    dbf d3, @for_each_psg
    
    moveq   #5, d3           ;num FM channels -1
    lea     ch_fm_1, a3
@for_each_fm:
    move.w  #(fm_ch_size-1), d4
@clear_single_fm:
    clr.b   (a3)+
    dbf d4, @clear_single_fm
    dbf d3, @for_each_fm

    rts
    
;================================================
;   parameter - d0.w    index of song
;================================================
load_song_from_parts_table:
    move.w  d0, -(sp)   ;push d0

    jsr     clear_audio_memory
    jsr     PSG_Init            ;re-init psg
    jsr     FM_init             ;re-init fm
    ;jsr     DAC_init           ;re-init dac

    move.w  (sp)+, d0   ;pop d0

    lea     song_table, a0  ;a0 = *songtable
    movea.l $4(a0,d0.w), a2 ;a2 = section_table
    movea.l $0(a0,d0.w), a0 ;a0 = channel_table
                            ;[channel_table, section_table]
                            
    ;load FM channels
@load_channel_1:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_2
    lea     ch_fm_1, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #0, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
@load_channel_2:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_3
    lea     ch_fm_2, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #1, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
@load_channel_3:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_4
    lea     ch_fm_3, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #2, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
@load_channel_4:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_5
    lea     ch_fm_4, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #4, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
@load_channel_5:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_channel_6
    lea     ch_fm_5, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #5, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
@load_channel_6:
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @load_psg_channels
    lea     ch_fm_6, a5     ;channel 
    move.b  #5, ch_channel_flags(a5) ; 0000 0101 (FM, Enabled)
    move.b  #6, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
    
;do PSG
@load_psg_channels:

    moveq   #3, d1  ;loop counter
    move.b  #0, d2  ;channel number
    lea     ch_psg_0, a5
@for_each_psg_channel
    movea.l (a0)+, a1
    move.l  a1, d0
    tst.l   d0
    beq     @next_psg_channel
    move.b  #1, ch_channel_flags(a5) ; 0000 0001 (PSG, Enabled)
    move.b  d2, ch_channel_num(a5)
    move.l  a1, ch_sequence_ptr(a5)
    move.l  #0, ch_stream_ptr(a5)
    move.l  a2, ch_section_ptr(a5)
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
    include 'dac_helper_functions.asm'
    
;============================================================================
;   Song macros and includes
;============================================================================

seq_table_stop_code     equ     (-1)

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
    
M_load_inst: macro inst_name
    dc.b    sc_load_inst
    even
    dc.l    \inst_name
    endm
    
    include 'instrument_defs.asm'
    
    include 'songs/demo_section_table.asm'
    ;include 'songs/a_mystery.asm'
    ;include 'songs/agr_14.asm'
    include 'songs/cza_3.asm'
    include 'songs/cza13.asm'
    include 'songs/aro2.asm'
    include 'songs/cza18.asm'
    ;include 'songs/mission_briefing.asm'
