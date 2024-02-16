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
	
	M_load_inst test_sample_addr
	
	M_play_sample test_sample_addr, 360
	
	dc.b 	sc_stop
	modend