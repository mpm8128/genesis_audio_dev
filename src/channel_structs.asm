;==============================================================
;   PSG Channel Structure
;==============================================================
    RSRESET
;PSG channel instrument information
psg_ch_inst_ptr         rs.l    1   ;pointer to instrument data on ROM
psg_ch_inst_flags       rs.b    1   
    ;EKOx xSaa
    ;bits 0-1: "aa" - envelope bits
    ;   00 = attack
    ;   01 = decay
    ;   10 = sustain
    ;   11 = release
    ;bit 2 - status bit - set to 0 while note is playing
    ;   gets set to 1 after release fades to zero
    ;bit 3 - unused
    ;bit 4 - unused
    ;bit 5 - "O" - keyoff - set to 1 if we just 
    ;   got a keyoff event from the stream. This
    ;   will get cleared when we actually write 
    ;   the keyoff to the chip.
    ;bit 6 - "K" - keyon - set to 1 if we just
    ;   got a keyon event from the stream. This
    ;   will get cleared when we actually write
    ;   the keyoff to the chip
    ;bit 7 - "E" - channel enable bit. Will not process
    ;   stream events while set to zero
    
psg_ch_channel          rs.b    1   ;channel id (0-3)
psg_ch_attack_rate      rs.b    1   ;attack rate(1-15)
                                    ;    rise in volume per-frame during the
                                    ;    "attack" phase of the ADSR envelope
psg_ch_max_level        rs.b    1   ;max_level (0-15)
                                    ;   target volume for the "attack" phase.
                                    ;   Once we reach this volume, we transition
                                    ;   to the "decay" phase of the ADSR envelope
psg_ch_decay_rate       rs.b    1   ;decay rate (0-15)
                                    ;   fall in volume per-frame during the
                                    ;   "decay" phase of the ADSR envelope
psg_ch_sus_level        rs.b    1   ;sustain level (0-15)
                                    ;   target volume for the "decay" phase
                                    ;   we hold this volume until we receive
                                    ;   a keyoff event
psg_ch_release_rate     rs.b    1   ;release rate (0-15)
                                    ;   fall in volume per-frame during the
                                    ;   "release" phase of the ADSR envelope
psg_ch_attack_scaling   rs.b    1   ;attack scaling (1-255)
                                    ;   number of frames to wait before adding the
                                    ;   attack rate in the "attack" phase
                                    ;   of the ADSR envelope
psg_ch_decay_scaling    rs.b    1   ;decay scaling (1-255)
psg_ch_release_scaling  rs.b    1   ;release scaling (1-255)
psg_ch_adsr_counter     rs.b    1   ;counter for scaling > 1

psg_ch_noise_mode       rs.b    1   ;0-3 (0 for square-wave channels)
psg_ch_current_vol      rs.b    1   ;0-15
;stream stuff
psg_ch_wait_time        rs.w    1   ;number of frames until next stream event
psg_ch_stream_ptr       rs.l    1   ;pointer to stream of audio data

psg_ch_base_freq        rs.w    1   ;10-bit frequency register value. 
                                    ;   Can be adjusted by pitch envelopes

psg_ch_adj_freq         rs.w    1   ;10-bit frequency register value.
                                    ;   working space for adjusting pitch
                                    ;   via envelope. This is what gets
                                    ;   written to the SN76489



; ;PSG channel automation information
; psg_ch_freq_auto_idx    rs.w    1   ;index into pitchbend envelope
; psg_ch_freq_auto_ptr    rs.l    1   ;pointer to the envelope

; psg_ch_vol_auto_idx     rs.w    1   ;index into volume envelope
; psg_ch_vol_auto_len     rs.w    1   ;length of the envelope in bytes
; psg_ch_vol_auto_ptr     rs.l    1   ;pointer to the envelope + 2

; psg_ch_vol_auto_time    rs.b    1   ;number of frames on each index
; psg_ch_freq_auto_time   rs.b    1   ;number of frames on each index

; psg_ch_vibrato_time     rs.b    1   ;number of frames before increment/decrement
; psg_ch_vibrato_size     rs.b    1   ;max deviation from base frequency

; psg_ch_tremelo_time     rs.b    1   ;number of frames before increment/decrement
; psg_ch_tremelo_size     rs.b    1   ;max deviation from base volume

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
fm_ch_wait_time         rs.w    1   ;number of frames to hold the note for

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