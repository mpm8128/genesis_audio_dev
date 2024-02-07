;pcm_test.asm

	even
	module

pcm_test_channel_table:
	dc.l    0
    dc.l    0
    dc.l    0
	
    dc.l    0
    dc.l    0
    dc.l    pcm_test_seq_table	;DAC
    
	;psg
	dc.l    0
    dc.l    0
    dc.l    0
    dc.l    0

pcm_test_section_table:
	dc.l	@play_test_sample


pcm_test_seq_table:
	dc.b	0, -1, 0


@play_test_sample:
	dc.b	sc_set_ch_type, ch_type_dac

	M_load_inst	test_sample_addr	;as DAC, hopefully
	
	dc.b	sc_signal_z80, 0x01
	M_play_rest 	254
	dc.b 	sc_end_section
	modend