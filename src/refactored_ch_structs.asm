;==============================================================
;   Channel Structure
;==============================================================
    RSRESET

;===================
; Stream information
fm_ch_is_enabled        rs.b    0
ch_channel_flags        rs.b    1
;   xxxx TTME
;
;   bit 0: "E" - enabled
;       0 = disabled
;       1 = enabled
;
;   bit 1: "M" - muted
;       0 = unmuted
;       1 = muted
;
;   bits 2-3: "T" - type
;       00 = PSG
;       01 = FM
;       10 = DAC/PCM (sample)
;       11 = ????
;
;   bits 4-7 - unused

fm_ch_channel           rs.b    0
psg_ch_channel          rs.b    0
ch_channel_num          rs.b    1   ;(0-2, 4-6 for FM, 0 for noise, 1-3 for PSG)

fm_ch_wait_time         rs.w    0
psg_ch_wait_time        rs.w    0
ch_wait_time            rs.w    1   ;number of frames until next stream event

fm_ch_sequence_idx      rs.w    0
psg_ch_sequence_idx     rs.w    0
ch_sequence_idx         rs.w    1   ;index into sequence table

fm_ch_stream_ptr        rs.l    0
psg_ch_stream_ptr       rs.l    0
ch_stream_ptr           rs.l    1   ;pointer to stream of audio data

fm_ch_section_ptr       rs.l    0
psg_ch_section_ptr      rs.l    0
ch_section_ptr          rs.l    1   ;pointer to section table

fm_ch_sequence_ptr      rs.l    0
psg_ch_sequence_ptr     rs.l    0
ch_sequence_ptr         rs.l    1   ;pointer to sequence table

;======================
; Instrument information

fm_ch_inst_ptr          rs.l    0
psg_ch_inst_ptr         rs.l    0
ch_inst_ptr             rs.l    1   ;pointer to instrument data on ROM


psg_ch_inst_flags       rs.b    0
ch_inst_flags           rs.b    1   
    ;EKOP xSaa
    ;bits 0-1: "aa" - envelope bits
    ;   00 = attack
    ;   01 = decay
    ;   10 = sustain
    ;   11 = release
    ;bit 2 - status bit - set to 0 while note is playing
    ;   gets set to 1 after release fades to zero
    ;bit 3 - unused
    ;bit 4 - "P" - pitch update   - 1 if new pitch
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

;fm_ch_base_vol          rs.b    1   ;"base" volume (pre-trem/envelope)
fm_ch_note_name         rs.b    1   ;current note (pre-vibr/envelope)
fm_ch_note_octave       rs.b    1   ;current octave (pre-vibr/envelope)
;fm_ch_algorithm         rs.b    1   ;algorithm (0-7)
fm_ch_lr_amfm           rs.b    1   ;LRAA xFFF

;-----------------------
;Software ADSR envelope:

psg_ch_current_vol      rs.b    0   ;0-15
ch_current_vol          rs.b    1   

psg_ch_attack_rate      rs.b    0
ch_attack_rate          rs.b    1   ;attack rate(1-15)
                                ;    rise in volume per-frame during the
                                ;    "attack" phase of the ADSR envelope
psg_ch_max_level        rs.b    0
ch_max_level            rs.b    1   ;max_level (0-15)
                                ;   target volume for the "attack" phase.
                                ;   Once we reach this volume, we transition
                                ;   to the "decay" phase of the ADSR envelope
psg_ch_decay_rate       rs.b    0
ch_decay_rate           rs.b    1   ;decay rate (0-15)
                                ;   fall in volume per-frame during the
                                ;   "decay" phase of the ADSR envelope
psg_ch_sus_level        rs.b    0
ch_sus_level            rs.b    1   ;sustain level (0-15)
                                ;   target volume for the "decay" phase
                                ;   we hold this volume until we receive
                                ;   a keyoff event
psg_ch_release_rate     rs.b    0
ch_release_rate         rs.b    1   ;release rate (0-15)
                                ;   fall in volume per-frame during the
                                ;   "release" phase of the ADSR envelope
psg_ch_attack_scaling   rs.b    0
ch_attack_scaling       rs.b    1   ;attack scaling (1-255)
                                ;   number of frames to wait before adding the
                                ;   attack rate in the "attack" phase
                                ;   of the ADSR envelope
                                
psg_ch_decay_scaling    rs.b    0
ch_decay_scaling        rs.b    1   ;decay scaling (1-255)

psg_ch_release_scaling  rs.b    0
ch_release_scaling      rs.b    1   ;release scaling (1-255)

psg_ch_adsr_counter     rs.b    0
ch_adsr_counter         rs.b    1   ;counter for scaling > 1

;-----------------------
;Software Pitch Envelope

psg_ch_base_freq        rs.w    0
ch_base_freq            rs.w    1   ;10-bit frequency register value. 
                                ;   Can be adjusted by pitch envelopes

psg_ch_adj_freq         rs.w    0
ch_adj_freq             rs.w    1   ;10-bit frequency register value.
                                ;   working space for adjusting pitch
                                ;   via envelope. This is what gets
                                ;   written to the SN76489

;   PSG channel automation information
psg_ch_pitchbend_rate   rs.b    0
ch_pitchbend_rate       rs.b    1   ;signed amount to bend up/down
                                    ;   inverted for PSG chip so that
                                    ;   we can use positive to mean
                                    ;   "pitch up" and negative to mean
                                    ;   "pitch down" in the song files
psg_ch_pitchbend_scaling    rs.b    0
ch_pitchbend_scaling        rs.b    1   ;number of frames until next 
                                    ;   pitch adjustment
psg_ch_pitchbend_counter    rs.b    0                                    
ch_pitchbend_counter        rs.b    1   ;counter for scaling

psg_ch_size             rs.w    0
fm_ch_size              rs.w    0
ch_size                 rs.w    0

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