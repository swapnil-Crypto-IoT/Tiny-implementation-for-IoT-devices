
_timer_init:

;Vayu_BC_Code.c,42 :: 		void timer_init() //start timer
;Vayu_BC_Code.c,44 :: 		TIMSK=0b00000001; // enabling the interrupt
	LDI        R27, 1
	OUT        TIMSK+0, R27
;Vayu_BC_Code.c,45 :: 		SREG_I_bit = 1;
	IN         R27, SREG_I_bit+0
	SBR        R27, BitMask(SREG_I_bit+0)
	OUT        SREG_I_bit+0, R27
;Vayu_BC_Code.c,46 :: 		TCCR0=0b00000001; // setting the prescaler-1 i.e. no prescalar
	LDI        R27, 1
	OUT        TCCR0+0, R27
;Vayu_BC_Code.c,47 :: 		}
L_end_timer_init:
	RET
; end of _timer_init

_timer_stop:

;Vayu_BC_Code.c,49 :: 		void timer_stop() //stop timer
;Vayu_BC_Code.c,51 :: 		TCCR0=0b00000000;
	LDI        R27, 0
	OUT        TCCR0+0, R27
;Vayu_BC_Code.c,52 :: 		}
L_end_timer_stop:
	RET
; end of _timer_stop

_interrupt:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;Vayu_BC_Code.c,55 :: 		void interrupt() org IVT_ADDR_TIMER0_OVF // Interrupt Service Routine for to keep tracking timer overflow
;Vayu_BC_Code.c,57 :: 		time_count++;    // variable storing the number of times timer0 overflows
	LDS        R16, _time_count+0
	LDS        R17, _time_count+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _time_count+0, R16
	STS        _time_count+1, R17
;Vayu_BC_Code.c,58 :: 		}
L_end_interrupt:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _interrupt

_lcs_3:

;Vayu_BC_Code.c,64 :: 		long int lcs_3(long int msb_32, long int *lcs_msb_32)
;Vayu_BC_Code.c,66 :: 		*lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 31
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__lcs_318:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__lcs_318
L__lcs_319:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 224
	LDI        R27, 29
L__lcs_320:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_320
L__lcs_321:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,67 :: 		}
L_end_lcs_3:
	RET
; end of _lcs_3

_lcs_7:

;Vayu_BC_Code.c,74 :: 		long int lcs_7(long int msb_32, long int *lcs_msb_32)
;Vayu_BC_Code.c,76 :: 		*lcs_msb_32 = ((msb_32&0x01ffffff)<<7)|((msb_32&0xfe000000)>>(32-7));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 1
	LDI        R27, 7
	MOVW       R20, R16
	MOVW       R22, R18
L__lcs_723:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__lcs_723
L__lcs_724:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 254
	LDI        R27, 25
L__lcs_725:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_725
L__lcs_726:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,77 :: 		}
L_end_lcs_7:
	RET
; end of _lcs_7

_rcs_7:

;Vayu_BC_Code.c,84 :: 		long int rcs_7(long int msb_32, long int *rcs_msb_32)
;Vayu_BC_Code.c,86 :: 		*rcs_msb_32 = ((msb_32&0xffffff80)>>7)|((msb_32&0x0000007f)<<(32-7));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 128
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 7
	MOVW       R20, R16
	MOVW       R22, R18
L__rcs_728:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__rcs_728
L__rcs_729:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 127
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 25
L__rcs_730:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_730
L__rcs_731:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,87 :: 		}
L_end_rcs_7:
	RET
; end of _rcs_7

_rcs_3:

;Vayu_BC_Code.c,94 :: 		long int rcs_3(long int msb_32, long int *rcs_msb_32)
;Vayu_BC_Code.c,96 :: 		*rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__rcs_333:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__rcs_333
L__rcs_334:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
L__rcs_335:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_335
L__rcs_336:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,97 :: 		}
L_end_rcs_3:
	RET
; end of _rcs_3

_s_box:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 32
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Vayu_BC_Code.c,102 :: 		long int s_box(long int msb_32, long long int *n_nibble)
;Vayu_BC_Code.c,105 :: 		*n_nibble=0;
	MOVW       R30, R6
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Vayu_BC_Code.c,106 :: 		for(i=0;i<32;i=i+4)
	LDI        R27, 0
	STS        _i+0, R27
L_s_box0:
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__s_box38
	JMP        L_s_box1
L__s_box38:
;Vayu_BC_Code.c,108 :: 		a[(i*1)/4]= sbox[((msb_32>>(i))&0xf)];
	LDS        R16, _i+0
	LDI        R17, 0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	MOVW       R18, R28
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R24, R16
	ADD        R24, R18
	ADC        R25, R19
	LDS        R27, _i+0
	MOVW       R16, R2
	MOVW       R18, R4
	TST        R27
	BREQ       L__s_box40
L__s_box39:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__s_box39
L__s_box40:
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 15
	ANDI       R21, 0
	ANDI       R22, 0
	ANDI       R23, 0
	LDI        R16, #lo_addr(_sbox+0)
	LDI        R17, hi_addr(_sbox+0)
	MOVW       R30, R16
	ADD        R30, R20
	ADC        R31, R21
	LD         R16, Z
	MOVW       R30, R24
	ST         Z+, R16
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Vayu_BC_Code.c,109 :: 		*n_nibble |= a[(i*1)/4] << i;
	LDS        R16, _i+0
	LDI        R17, 0
	ASR        R17
	ROR        R16
	ASR        R17
	ROR        R16
	MOVW       R18, R28
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R18
	ADC        R31, R19
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	LDS        R27, _i+0
	MOVW       R20, R16
	MOVW       R22, R18
	TST        R27
	BREQ       L__s_box42
L__s_box41:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__s_box41
L__s_box42:
	MOVW       R30, R6
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,106 :: 		for(i=0;i<32;i=i+4)
	LDS        R16, _i+0
	SUBI       R16, 252
	STS        _i+0, R16
;Vayu_BC_Code.c,110 :: 		}
	JMP        L_s_box0
L_s_box1:
;Vayu_BC_Code.c,111 :: 		}
L_end_s_box:
	ADIW       R28, 31
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _s_box

_p_box:

;Vayu_BC_Code.c,117 :: 		long int p_box(long int msb_32, long int *p_msb_32)
;Vayu_BC_Code.c,119 :: 		long int t=0;
; t start address is: 8 (R8)
	CLR        R8
	CLR        R9
	CLR        R10
	CLR        R11
;Vayu_BC_Code.c,120 :: 		for (i=0;i<32;i++)
	LDI        R27, 0
	STS        _i+0, R27
; t end address is: 8 (R8)
L_p_box3:
; t start address is: 8 (R8)
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__p_box44
	JMP        L_p_box4
L__p_box44:
;Vayu_BC_Code.c,122 :: 		t |= ((msb_32>>i)&0x1)<<p[i];
	LDS        R27, _i+0
	MOVW       R16, R2
	MOVW       R18, R4
	TST        R27
	BREQ       L__p_box46
L__p_box45:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__p_box45
L__p_box46:
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 1
	ANDI       R21, 0
	ANDI       R22, 0
	ANDI       R23, 0
	LDI        R17, #lo_addr(_p+0)
	LDI        R18, hi_addr(_p+0)
	LDS        R16, _i+0
	MOV        R30, R16
	LDI        R31, 0
	ADD        R30, R17
	ADC        R31, R18
	LD         R16, Z
	MOV        R27, R16
	MOVW       R16, R20
	MOVW       R18, R22
	TST        R27
	BREQ       L__p_box48
L__p_box47:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__p_box47
L__p_box48:
	OR         R16, R8
	OR         R17, R9
	OR         R18, R10
	OR         R19, R11
	MOVW       R8, R16
	MOVW       R10, R18
;Vayu_BC_Code.c,120 :: 		for (i=0;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;Vayu_BC_Code.c,123 :: 		}
	JMP        L_p_box3
L_p_box4:
;Vayu_BC_Code.c,124 :: 		*p_msb_32=t;
	MOVW       R30, R6
	ST         Z+, R8
	ST         Z+, R9
	ST         Z+, R10
	ST         Z+, R11
; t end address is: 8 (R8)
;Vayu_BC_Code.c,125 :: 		}
L_end_p_box:
	RET
; end of _p_box

_key_schedule_1:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 16
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Vayu_BC_Code.c,130 :: 		long int key_schedule_1(long int *rk)
;Vayu_BC_Code.c,132 :: 		long int Key[4]={0x01234567,0x89abcdef,0x01234567,0x89abcdef}; //hard coded 128 bit master key
	LDI        R30, #lo_addr(?ICSkey_schedule_1_Key_L0+0)
	LDI        R31, hi_addr(?ICSkey_schedule_1_Key_L0+0)
	MOVW       R26, R28
	LDI        R24, 16
	LDI        R25, 0
	CALL       ___CC2DW+0
;Vayu_BC_Code.c,135 :: 		{rk[0] = Key[3];}
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R2
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,138 :: 		for(i=0;i<31;i++)
	LDI        R27, 0
	STS        _i+0, R27
L_key_schedule_16:
	LDS        R16, _i+0
	CPI        R16, 31
	BRLO       L__key_schedule_150
	JMP        L_key_schedule_17
L__key_schedule_150:
;Vayu_BC_Code.c,140 :: 		temp1 = temp2 = 0;
	LDI        R27, 0
	STS        _temp2+0, R27
	STS        _temp2+1, R27
	STS        _temp2+2, R27
	STS        _temp2+3, R27
	LDI        R27, 0
	STS        _temp1+0, R27
	STS        _temp1+1, R27
	STS        _temp1+2, R27
	STS        _temp1+3, R27
;Vayu_BC_Code.c,141 :: 		temp1 = Key[0];
	MOVW       R24, R28
	MOVW       R30, R24
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	STS        _temp1+0, R16
	STS        _temp1+1, R17
	STS        _temp1+2, R18
	STS        _temp1+3, R19
;Vayu_BC_Code.c,145 :: 		Key[0]  = ((temp1&0x0007ffff)<<13) |((Key[1]&0xfff80000)>>(32-13)) ;
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 7
	ANDI       R19, 0
	LDI        R27, 13
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_151:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_151
L__key_schedule_152:
	MOVW       R30, R24
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 248
	ANDI       R19, 255
	LDI        R27, 19
L__key_schedule_153:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_153
L__key_schedule_154:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,146 :: 		Key[1]  = ((Key[1]&0X0007ffff)<<13) |(((Key[2]&0xfff80000)>>(32-13)));
	MOVW       R4, R28
	MOVW       R24, R4
	ADIW       R24, 4
	MOVW       R30, R4
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 7
	ANDI       R19, 0
	LDI        R27, 13
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_155:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_155
L__key_schedule_156:
	MOVW       R30, R4
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 248
	ANDI       R19, 255
	LDI        R27, 19
L__key_schedule_157:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_157
L__key_schedule_158:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,147 :: 		Key[2]  = ((Key[2]&0x0007ffff)<<13) |(((Key[3]&0Xfff80000))>>(32-13));
	MOVW       R4, R28
	MOVW       R24, R4
	ADIW       R24, 8
	MOVW       R30, R4
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 7
	ANDI       R19, 0
	LDI        R27, 13
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_159:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_159
L__key_schedule_160:
	MOVW       R30, R4
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 248
	ANDI       R19, 255
	LDI        R27, 19
L__key_schedule_161:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_161
L__key_schedule_162:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,148 :: 		Key[3]  = ((Key[3]&0X0007ffff)<<13) |(((temp1&0Xfff80000))>>(32-13));    //left circular shift by 13
	MOVW       R16, R28
	MOVW       R24, R16
	ADIW       R24, 12
	MOVW       R30, R16
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 7
	ANDI       R19, 0
	LDI        R27, 13
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_163:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_163
L__key_schedule_164:
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 248
	ANDI       R19, 255
	LDI        R27, 19
L__key_schedule_165:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_165
L__key_schedule_166:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,151 :: 		temp1 = sbox[Key[3]&0xf] ;
	MOVW       R24, R28
	MOVW       R30, R24
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 15
	ANDI       R21, 0
	ANDI       R22, 0
	ANDI       R23, 0
	LDI        R16, #lo_addr(_sbox+0)
	LDI        R17, hi_addr(_sbox+0)
	MOVW       R30, R16
	ADD        R30, R20
	ADC        R31, R21
	LD         R16, Z
	STS        _temp1+0, R16
	LDI        R27, 0
	STS        _temp1+1, R27
	STS        _temp1+2, R27
	STS        _temp1+3, R27
;Vayu_BC_Code.c,152 :: 		temp2 = sbox[((Key[3])>>4)&0xf];
	MOVW       R30, R24
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	LDI        R27, 4
L__key_schedule_167:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_167
L__key_schedule_168:
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 15
	ANDI       R21, 0
	ANDI       R22, 0
	ANDI       R23, 0
	LDI        R16, #lo_addr(_sbox+0)
	LDI        R17, hi_addr(_sbox+0)
	MOVW       R30, R16
	ADD        R30, R20
	ADC        R31, R21
	LD         R16, Z
	STS        _temp2+0, R16
	LDI        R27, 0
	STS        _temp2+1, R27
	STS        _temp2+2, R27
	STS        _temp2+3, R27
;Vayu_BC_Code.c,153 :: 		temp1 = ((temp2&0xf)<<4)| temp1 ;
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	LDS        R18, _temp2+2
	LDS        R19, _temp2+3
	ANDI       R16, 15
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 4
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_169:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_169
L__key_schedule_170:
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	MOVW       R4, R20
	MOVW       R6, R22
	OR         R4, R16
	OR         R5, R17
	OR         R6, R18
	OR         R7, R19
	STS        _temp1+0, R4
	STS        _temp1+1, R5
	STS        _temp1+2, R6
	STS        _temp1+3, R7
;Vayu_BC_Code.c,154 :: 		Key[3] = (Key[3]&0xffffff00)|(temp1); // SBOX[K7,K6,K5,K4] and SBOX[K3,K2,K1,K0]
	MOVW       R20, R24
	SUBI       R20, 244
	SBCI       R21, 255
	MOVW       R30, R24
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	OR         R16, R4
	OR         R17, R5
	OR         R18, R6
	OR         R19, R7
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,157 :: 		temp1 = (key[2] & 0xf8000000) >> (32-5);
	MOVW       R8, R28
	MOVW       R30, R8
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 248
	LDI        R27, 27
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_171:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__key_schedule_171
L__key_schedule_172:
	STS        _temp1+0, R20
	STS        _temp1+1, R21
	STS        _temp1+2, R22
	STS        _temp1+3, R23
;Vayu_BC_Code.c,158 :: 		temp1 = temp1 ^ ((i)&0x1f);
	LDS        R16, _i+0
	ANDI       R16, 31
	MOVW       R4, R20
	MOVW       R6, R22
	EOR        R4, R16
	LDI        R27, 0
	EOR        R5, R27
	EOR        R6, R27
	EOR        R7, R27
	STS        _temp1+0, R4
	STS        _temp1+1, R5
	STS        _temp1+2, R6
	STS        _temp1+3, R7
;Vayu_BC_Code.c,159 :: 		key[2]=  (key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5))  ;
	MOVW       R24, R8
	ADIW       R24, 8
	MOVW       R30, R8
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 255
	ANDI       R21, 255
	ANDI       R22, 255
	ANDI       R23, 7
	MOVW       R16, R4
	MOVW       R18, R6
	ANDI       R16, 31
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 27
L__key_schedule_173:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__key_schedule_173
L__key_schedule_174:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,161 :: 		{rk[i+1] = Key[3];}
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 255
	SBCI       R17, 255
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R2
	ADC        R21, R3
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,138 :: 		for(i=0;i<31;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;Vayu_BC_Code.c,162 :: 		}
	JMP        L_key_schedule_16
L_key_schedule_17:
;Vayu_BC_Code.c,164 :: 		} // KSA end
L_end_key_schedule_1:
	ADIW       R28, 15
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _key_schedule_1

_vayu_round:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 8
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Vayu_BC_Code.c,169 :: 		long int vayu_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
; rk start address is: 10 (R10)
	LDD        R10, Y+12
	LDD        R11, Y+13
	LDD        R12, Y+14
	LDD        R13, Y+15
	LDD        R16, Y+16
	LDD        R17, Y+17
	STD        Y+16, R16
	STD        Y+17, R17
	LDD        R16, Y+18
	LDD        R17, Y+19
	STD        Y+18, R16
	STD        Y+19, R17
;Vayu_BC_Code.c,171 :: 		long int state=0,trail_1=0,trail_2=0;
	LDI        R30, #lo_addr(?ICSvayu_round_trail_1_L0+0)
	LDI        R31, hi_addr(?ICSvayu_round_trail_1_L0+0)
	MOVW       R26, R28
	LDI        R24, 8
	LDI        R25, 0
	CALL       ___CC2DW+0
;Vayu_BC_Code.c,177 :: 		s_box(msb_bits, &trail_1);
	MOVW       R16, R28
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	MOVW       R6, R16
	CALL       _s_box+0
;Vayu_BC_Code.c,178 :: 		lcs_7(trail_1,&trail_2);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _lcs_7+0
;Vayu_BC_Code.c,179 :: 		lcs_3(trail_1,&trail_1);
	MOVW       R16, R28
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _lcs_3+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Vayu_BC_Code.c,180 :: 		lsb_bits = trail_1 ^ trail_2 ^ lsb_bits;
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R20, R16
	MOVW       R22, R18
	EOR        R20, R6
	EOR        R21, R7
	EOR        R22, R8
	EOR        R23, R9
	MOVW       R6, R20
	MOVW       R8, R22
;Vayu_BC_Code.c,183 :: 		s_box(lsb_bits, &trail_1);
	MOVW       R16, R28
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R6, R16
	MOVW       R2, R20
	MOVW       R4, R22
	CALL       _s_box+0
;Vayu_BC_Code.c,184 :: 		rcs_7(trail_1,&trail_2);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _rcs_7+0
;Vayu_BC_Code.c,185 :: 		rcs_3(trail_1,&trail_1);
	MOVW       R16, R28
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _rcs_3+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
;Vayu_BC_Code.c,187 :: 		msb_bits = trail_1 ^ trail_2 ^ msb_bits ^ rk; // add round key
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	EOR        R16, R2
	EOR        R17, R3
	EOR        R18, R4
	EOR        R19, R5
	MOVW       R20, R16
	MOVW       R22, R18
	EOR        R20, R10
	EOR        R21, R11
	EOR        R22, R12
	EOR        R23, R13
; rk end address is: 10 (R10)
	MOVW       R2, R20
	MOVW       R4, R22
;Vayu_BC_Code.c,191 :: 		p_box(msb_bits, &trail_1);
	MOVW       R16, R28
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R6, R16
	MOVW       R2, R20
	MOVW       R4, R22
	CALL       _p_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Vayu_BC_Code.c,192 :: 		p_box(lsb_bits, &trail_2);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R2, R6
	MOVW       R4, R8
	MOVW       R6, R16
	CALL       _p_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Vayu_BC_Code.c,196 :: 		lsb_bits = trail_1;
	LDD        R6, Y+0
	LDD        R7, Y+1
	LDD        R8, Y+2
	LDD        R9, Y+3
;Vayu_BC_Code.c,197 :: 		msb_bits = trail_2;
	LDD        R2, Y+4
	LDD        R3, Y+5
	LDD        R4, Y+6
	LDD        R5, Y+7
;Vayu_BC_Code.c,201 :: 		*out_m =0;
	LDD        R30, Y+16
	LDD        R31, Y+17
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Vayu_BC_Code.c,202 :: 		*out_l =0;
	LDD        R30, Y+18
	LDD        R31, Y+19
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Vayu_BC_Code.c,203 :: 		*out_m = msb_bits;
	LDD        R30, Y+16
	LDD        R31, Y+17
	ST         Z+, R2
	ST         Z+, R3
	ST         Z+, R4
	ST         Z+, R5
;Vayu_BC_Code.c,204 :: 		*out_l = lsb_bits;
	LDD        R30, Y+18
	LDD        R31, Y+19
	ST         Z+, R6
	ST         Z+, R7
	ST         Z+, R8
	ST         Z+, R9
;Vayu_BC_Code.c,208 :: 		} // VAYU Round function end
L_end_vayu_round:
	ADIW       R28, 7
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _vayu_round

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 140
	SBCI       R29, 0
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Vayu_BC_Code.c,213 :: 		int main()
;Vayu_BC_Code.c,215 :: 		long int r_k[31]={0}, msb_out=0, lsb_out=0;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDI        R30, #lo_addr(?ICSmain_r_k_L0+0)
	LDI        R31, hi_addr(?ICSmain_r_k_L0+0)
	MOVW       R26, R28
	LDI        R24, 140
	LDI        R25, 0
	CALL       ___CC2DW+0
;Vayu_BC_Code.c,216 :: 		long int pt[2] = {0x01234567, 0x89abcdef};      // hardcoded plaintext
;Vayu_BC_Code.c,219 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Vayu_BC_Code.c,220 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Vayu_BC_Code.c,221 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Vayu_BC_Code.c,225 :: 		key_schedule_1(r_k);           // key scheduling function call to store all the key
	MOVW       R16, R28
	MOVW       R2, R16
	CALL       _key_schedule_1+0
;Vayu_BC_Code.c,228 :: 		msb_out = pt[0];
	MOVW       R20, R28
	SUBI       R20, 124
	SBCI       R21, 255
	MOVW       R30, R20
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 132
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,229 :: 		lsb_out = pt[1];
	MOVW       R16, R20
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 128
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Vayu_BC_Code.c,233 :: 		for(i=0;i<31;i++)
; i start address is: 24 (R24)
	LDI        R24, 0
	LDI        R25, 0
; i end address is: 24 (R24)
L_main9:
; i start address is: 24 (R24)
	LDI        R16, 31
	LDI        R17, 0
	CP         R24, R16
	CPC        R25, R17
	BRLT       L__main77
	JMP        L_main10
L__main77:
;Vayu_BC_Code.c,235 :: 		vayu_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
	MOVW       R22, R28
	SUBI       R22, 128
	SBCI       R23, 255
	MOVW       R20, R28
	SUBI       R20, 132
	SBCI       R21, 255
	MOVW       R18, R28
	MOVW       R16, R24
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	ADD        R16, R18
	ADC        R17, R19
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R25
	PUSH       R24
	MOVW       R30, R28
	SUBI       R30, 128
	SBCI       R31, 255
	LD         R6, Z+
	LD         R7, Z+
	LD         R8, Z+
	LD         R9, Z+
	MOVW       R30, R28
	SUBI       R30, 132
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	PUSH       R23
	PUSH       R22
	PUSH       R21
	PUSH       R20
	PUSH       R19
	PUSH       R18
	PUSH       R17
	PUSH       R16
	CALL       _vayu_round+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R24
	POP        R25
;Vayu_BC_Code.c,233 :: 		for(i=0;i<31;i++)
	MOVW       R16, R24
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R24, R16
;Vayu_BC_Code.c,244 :: 		}// round = 25 for end
; i end address is: 24 (R24)
	JMP        L_main9
L_main10:
;Vayu_BC_Code.c,248 :: 		LongintTohex(msb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 132
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;Vayu_BC_Code.c,249 :: 		Lcd_out(1,1,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Vayu_BC_Code.c,250 :: 		LongintTohex(lsb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 128
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;Vayu_BC_Code.c,251 :: 		Lcd_out(1,10,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 10
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Vayu_BC_Code.c,262 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main12:
	DEC        R16
	BRNE       L_main12
	DEC        R17
	BRNE       L_main12
	DEC        R18
	BRNE       L_main12
;Vayu_BC_Code.c,264 :: 		} // main end
L_end_main:
	POP        R9
	POP        R8
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	POP        R3
	POP        R2
L__main_end_loop:
	JMP        L__main_end_loop
; end of _main
