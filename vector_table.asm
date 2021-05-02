ROM_START:
	dc.l	$FFFFFF00       ;stack address
	dc.l	$00000200 	;code start
    
    ;interrupts
	dc.l	$0000044C	;bus error
	dc.l	$00000450	;address error
	dc.l	$00000454	;illegal instruction
	dc.l	$00000458	;div by zero
	dc.l	$0000045C	;CHK exception
	dc.l	$00000460	;TRAPV exception
	dc.l	$00000464	;privilege violation
	dc.l	$00000468	;TRACE exception
	dc.l	$00000440	;line-a emulator
	dc.l	$00000440	;line-f emulator
	dc.l	$00000440	;reserved
	dc.l	$00000440	;co-processor protocol violation
	dc.l	$00000440	;format error
	dc.l	$00000440	;uninitialized interrupt
	dc.l	$00000440	;reserved
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;spurious interrupt
    
    ;IRQ
	dc.l	$00000444	;lv 1
	dc.l	$00000444	;lv 2 (ext interrupt)
	dc.l	$00000444	;lv 3
	dc.l	HBLANK_ISR      ;lv 4 (VDP horizontal interrupt)
	dc.l	$00000444	;lv 5 
	dc.l	VBLANK_ISR	;lv 6 (VDP vertical interrupt)
	dc.l	$00000444	;lv 7
    
    ;TRAP (0x10)
	dc.l	$00000448	;traaaap
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
	dc.l	$00000448	;
    ;floating-point interrupts
	dc.l	$00000440	;branch or set on unordered condition
	dc.l	$00000440	;inexact result
	dc.l	$00000440	;div by zero
	dc.l	$00000440	;underflow
	dc.l	$00000440	;operand error
	dc.l	$00000440	;overflow
	dc.l	$00000440	;signalling NAN
	dc.l	$00000440	;unimplemented data type
    ;misc
	dc.l	$00000440	;MMU config error
	dc.l	$00000440	;MMU illegal operation
	dc.l	$00000440	;MMU access violation
	dc.l	$00000440	;reserved
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
	dc.l	$00000440	;
