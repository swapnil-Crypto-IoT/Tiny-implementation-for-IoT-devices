
_timer_init:

;Nux_BC_128.c,41 :: 		void timer_init() //start timer
;Nux_BC_128.c,43 :: 		TIMSK=0b00000001; // enabling the interrupt
	LDI        R27, 1
	OUT        TIMSK+0, R27
;Nux_BC_128.c,44 :: 		SREG_I_bit = 1;
	IN         R27, SREG_I_bit+0
	SBR        R27, BitMask(SREG_I_bit+0)
	OUT        SREG_I_bit+0, R27
;Nux_BC_128.c,45 :: 		TCCR0=0b00000001; // setting the prescaler-1 i.e. no prescalar
	LDI        R27, 1
	OUT        TCCR0+0, R27
;Nux_BC_128.c,46 :: 		}
L_end_timer_init:
	RET
; end of _timer_init

_timer_stop:

;Nux_BC_128.c,48 :: 		void timer_stop() //stop timer
;Nux_BC_128.c,50 :: 		TCCR0=0b00000000;
	LDI        R27, 0
	OUT        TCCR0+0, R27
;Nux_BC_128.c,51 :: 		}
L_end_timer_stop:
	RET
; end of _timer_stop

_interrupt:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;Nux_BC_128.c,54 :: 		void interrupt() org IVT_ADDR_TIMER0_OVF // Interrupt Service Routine for to keep tracking timer overflow
;Nux_BC_128.c,56 :: 		time_count++;    // variable storing the number of times timer0 overflows
	LDS        R16, _time_count+0
	LDS        R17, _time_count+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _time_count+0, R16
	STS        _time_count+1, R17
;Nux_BC_128.c,57 :: 		}
L_end_interrupt:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _interrupt

_lcs_3:

;Nux_BC_128.c,63 :: 		long int lcs_3(long int Input_16, long int *lcs_Input_16)
;Nux_BC_128.c,65 :: 		*lcs_Input_16 = ((Input_16&0x1fffffff)<<3)|((Input_16&0xe0000000)>>(32-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 31
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__lcs_320:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__lcs_320
L__lcs_321:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 224
	LDI        R27, 29
L__lcs_322:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_322
L__lcs_323:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,66 :: 		}
L_end_lcs_3:
	RET
; end of _lcs_3

_lcs_8:

;Nux_BC_128.c,73 :: 		long int lcs_8(long int Input_16, long int *lcs_Input_16)
;Nux_BC_128.c,75 :: 		*lcs_Input_16 = ((Input_16&0x00ff)<<8)|((Input_16&0xff00)>>(16-8));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOV        R23, R18
	MOV        R22, R17
	MOV        R21, R16
	CLR        R20
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 255
	ANDI       R18, 0
	ANDI       R19, 0
	MOV        R16, R17
	MOV        R17, R18
	MOV        R18, R19
	LDI        R19, 0
	SBRC       R18, 7
	LDI        R19, 255
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,76 :: 		}
L_end_lcs_8:
	RET
; end of _lcs_8

_rcs_3:

;Nux_BC_128.c,83 :: 		long int rcs_3(long int Input_16, long int *rcs_Input_16)
;Nux_BC_128.c,85 :: 		*rcs_Input_16 = ((Input_16&0xfff8)>>3)|((Input_16&0x0007)<<(16-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__rcs_326:
	ASR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__rcs_326
L__rcs_327:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 13
L__rcs_328:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_328
L__rcs_329:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,86 :: 		}
L_end_rcs_3:
	RET
; end of _rcs_3

_s_box:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 16
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Nux_BC_128.c,92 :: 		long int s_box(long int Input_16, long long int *n_nibble)
;Nux_BC_128.c,95 :: 		*n_nibble=0;
	MOVW       R30, R6
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Nux_BC_128.c,96 :: 		for(i=0;i<16;i=i+4)
	LDI        R27, 0
	STS        _i+0, R27
L_s_box0:
	LDS        R16, _i+0
	CPI        R16, 16
	BRLO       L__s_box31
	JMP        L_s_box1
L__s_box31:
;Nux_BC_128.c,98 :: 		a[(i*1)/4]= sbox[((Input_16>>(i))&0xf)];
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
	BREQ       L__s_box33
L__s_box32:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__s_box32
L__s_box33:
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
;Nux_BC_128.c,99 :: 		*n_nibble |= a[(i*1)/4] << i;
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
	BREQ       L__s_box35
L__s_box34:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__s_box34
L__s_box35:
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
;Nux_BC_128.c,96 :: 		for(i=0;i<16;i=i+4)
	LDS        R16, _i+0
	SUBI       R16, 252
	STS        _i+0, R16
;Nux_BC_128.c,100 :: 		}
	JMP        L_s_box0
L_s_box1:
;Nux_BC_128.c,101 :: 		}
L_end_s_box:
	ADIW       R28, 15
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _s_box

_p_box:

;Nux_BC_128.c,107 :: 		long int p_box(long int Input_16, long int *p_Input_16)
;Nux_BC_128.c,109 :: 		long int t=0;
; t start address is: 8 (R8)
	CLR        R8
	CLR        R9
	CLR        R10
	CLR        R11
;Nux_BC_128.c,110 :: 		for (i=0;i<16;i++)
	LDI        R27, 0
	STS        _i+0, R27
; t end address is: 8 (R8)
L_p_box3:
; t start address is: 8 (R8)
	LDS        R16, _i+0
	CPI        R16, 16
	BRLO       L__p_box37
	JMP        L_p_box4
L__p_box37:
;Nux_BC_128.c,112 :: 		t |= ((Input_16>>i)&0x1)<<p[i];
	LDS        R27, _i+0
	MOVW       R16, R2
	MOVW       R18, R4
	TST        R27
	BREQ       L__p_box39
L__p_box38:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__p_box38
L__p_box39:
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
	BREQ       L__p_box41
L__p_box40:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__p_box40
L__p_box41:
	OR         R16, R8
	OR         R17, R9
	OR         R18, R10
	OR         R19, R11
	MOVW       R8, R16
	MOVW       R10, R18
;Nux_BC_128.c,110 :: 		for (i=0;i<16;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;Nux_BC_128.c,113 :: 		}
	JMP        L_p_box3
L_p_box4:
;Nux_BC_128.c,114 :: 		*p_Input_16=t;
	MOVW       R30, R6
	ST         Z+, R8
	ST         Z+, R9
	ST         Z+, R10
	ST         Z+, R11
; t end address is: 8 (R8)
;Nux_BC_128.c,115 :: 		}
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

;Nux_BC_128.c,120 :: 		long int key_schedule_1(long int *rk)
;Nux_BC_128.c,122 :: 		long int Key[4]={0x0,0x0,0x0,0x0}; //hard coded 128 bit master key
	LDI        R30, #lo_addr(?ICSkey_schedule_1_Key_L0+0)
	LDI        R31, hi_addr(?ICSkey_schedule_1_Key_L0+0)
	MOVW       R26, R28
	LDI        R24, 16
	LDI        R25, 0
	CALL       ___CC2DW+0
;Nux_BC_128.c,125 :: 		{rk[0] = Key[3];}
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
;Nux_BC_128.c,128 :: 		for(i=0;i<31;i++)
	LDI        R27, 0
	STS        _i+0, R27
L_key_schedule_16:
	LDS        R16, _i+0
	CPI        R16, 31
	BRLO       L__key_schedule_143
	JMP        L_key_schedule_17
L__key_schedule_143:
;Nux_BC_128.c,130 :: 		temp1 = temp2 = 0;
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
;Nux_BC_128.c,131 :: 		temp1 = Key[0];
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
;Nux_BC_128.c,135 :: 		Key[0]  = ((temp1&0x0007ffff)<<13) |((Key[1]&0xfff80000)>>(32-13)) ;
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 7
	ANDI       R19, 0
	LDI        R27, 13
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_144:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_144
L__key_schedule_145:
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
L__key_schedule_146:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_146
L__key_schedule_147:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,136 :: 		Key[1]  = ((Key[1]&0X0007ffff)<<13) |(((Key[2]&0xfff80000)>>(32-13)));
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
L__key_schedule_148:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_148
L__key_schedule_149:
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
L__key_schedule_150:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_150
L__key_schedule_151:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,137 :: 		Key[2]  = ((Key[2]&0x0007ffff)<<13) |(((Key[3]&0Xfff80000))>>(32-13));
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
L__key_schedule_152:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_152
L__key_schedule_153:
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
L__key_schedule_154:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_154
L__key_schedule_155:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,138 :: 		Key[3]  = ((Key[3]&0X0007ffff)<<13) |(((temp1&0Xfff80000))>>(32-13));    //left circular shift by 13
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
L__key_schedule_156:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_156
L__key_schedule_157:
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 248
	ANDI       R19, 255
	LDI        R27, 19
L__key_schedule_158:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_158
L__key_schedule_159:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,141 :: 		temp1 = sbox[Key[3]&0xf] ;
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
;Nux_BC_128.c,142 :: 		temp2 = sbox[((Key[3])>>4)&0xf];
	MOVW       R30, R24
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	LDI        R27, 4
L__key_schedule_160:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_160
L__key_schedule_161:
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
;Nux_BC_128.c,143 :: 		temp1 = ((temp2&0xf)<<4)| temp1 ;
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
L__key_schedule_162:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_162
L__key_schedule_163:
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
;Nux_BC_128.c,144 :: 		Key[3] = (Key[3]&0xffffff00)|(temp1); // SBOX[K7,K6,K5,K4] and SBOX[K3,K2,K1,K0]
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
;Nux_BC_128.c,147 :: 		temp1 = (key[2] & 0xf8000000) >> (32-5);
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
L__key_schedule_164:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__key_schedule_164
L__key_schedule_165:
	STS        _temp1+0, R20
	STS        _temp1+1, R21
	STS        _temp1+2, R22
	STS        _temp1+3, R23
;Nux_BC_128.c,148 :: 		temp1 = temp1 ^ ((i)&0x1f);
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
;Nux_BC_128.c,149 :: 		key[2]=  (key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5))  ;
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
L__key_schedule_166:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__key_schedule_166
L__key_schedule_167:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,151 :: 		{rk[i+1] = Key[3];}
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
;Nux_BC_128.c,128 :: 		for(i=0;i<31;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;Nux_BC_128.c,152 :: 		}
	JMP        L_key_schedule_16
L_key_schedule_17:
;Nux_BC_128.c,154 :: 		} // KSA end
L_end_key_schedule_1:
	ADIW       R28, 15
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _key_schedule_1

_nux_round:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 24
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Nux_BC_128.c,159 :: 		long int nux_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
	LDD        R16, Y+28
	LDD        R17, Y+29
	LDD        R18, Y+30
	LDD        R19, Y+31
	STD        Y+28, R16
	STD        Y+29, R17
	STD        Y+30, R18
	STD        Y+31, R19
	LDD        R16, Y+32
	LDD        R17, Y+33
	STD        Y+32, R16
	STD        Y+33, R17
; out_l start address is: 24 (R24)
	LDD        R24, Y+34
	LDD        R25, Y+35
;Nux_BC_128.c,162 :: 		long int state=0, tmp_state=0, msb_1=0, msb_2=0, lsb_3=0, lsb_4=0;
	PUSH       R25
	PUSH       R24
	LDI        R27, 0
	STD        Y+0, R27
	STD        Y+1, R27
	STD        Y+2, R27
	STD        Y+3, R27
	POP        R24
	POP        R25
	LDI        R27, 0
	STD        Y+4, R27
	STD        Y+5, R27
	STD        Y+6, R27
	STD        Y+7, R27
;Nux_BC_128.c,166 :: 		timer_init();
	CALL       _timer_init+0
;Nux_BC_128.c,169 :: 		msb_1  = ((msb_bits & 0xffff0000)>>16);
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 255
	ANDI       R19, 255
	MOV        R16, R18
	MOV        R17, R19
	LDI        R18, 0
	MOV        R19, R18
	STD        Y+8, R16
	STD        Y+9, R17
	STD        Y+10, R18
	STD        Y+11, R19
;Nux_BC_128.c,170 :: 		msb_2 = (msb_bits & 0xffff);
	MOVW       R20, R2
	MOVW       R22, R4
	ANDI       R20, 255
	ANDI       R21, 255
	ANDI       R22, 0
	ANDI       R23, 0
	STD        Y+12, R20
	STD        Y+13, R21
	STD        Y+14, R22
	STD        Y+15, R23
;Nux_BC_128.c,171 :: 		lsb_3  = ((lsb_bits & 0xffff0000)>>16);
	MOVW       R16, R6
	MOVW       R18, R8
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 255
	ANDI       R19, 255
	MOV        R16, R18
	MOV        R17, R19
	LDI        R18, 0
	MOV        R19, R18
	STD        Y+16, R16
	STD        Y+17, R17
	STD        Y+18, R18
	STD        Y+19, R19
;Nux_BC_128.c,172 :: 		lsb_4 = (lsb_bits & 0xffff);
	MOVW       R16, R6
	MOVW       R18, R8
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 0
	ANDI       R19, 0
	STD        Y+20, R16
	STD        Y+21, R17
	STD        Y+22, R18
	STD        Y+23, R19
;Nux_BC_128.c,175 :: 		rcs_3(msb_2,&state);
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
	CALL       _rcs_3+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Nux_BC_128.c,176 :: 		s_box(state,&state);
	MOVW       R16, R28
	PUSH       R25
	PUSH       R24
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _s_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
	POP        R24
	POP        R25
;Nux_BC_128.c,177 :: 		lcs_8(msb_1,&tmp_state);
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
	MOVW       R6, R16
	LDD        R2, Y+8
	LDD        R3, Y+9
	LDD        R4, Y+10
	LDD        R5, Y+11
	CALL       _lcs_8+0
;Nux_BC_128.c,180 :: 		state = state ^ tmp_state ^ ((rk&0xffff0000)>>16);
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	LDD        R16, Y+28
	LDD        R17, Y+29
	LDD        R18, Y+30
	LDD        R19, Y+31
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 255
	ANDI       R19, 255
	MOV        R16, R18
	MOV        R17, R19
	LDI        R18, 0
	MOV        R19, R18
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	STD        Y+0, R20
	STD        Y+1, R21
	STD        Y+2, R22
	STD        Y+3, R23
;Nux_BC_128.c,181 :: 		p_box(state, &state);
	MOVW       R16, R28
	MOVW       R6, R16
	MOVW       R2, R20
	MOVW       R4, R22
	CALL       _p_box+0
;Nux_BC_128.c,182 :: 		p_box(msb_2,&tmp_state);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R6, R16
	LDD        R2, Y+12
	LDD        R3, Y+13
	LDD        R4, Y+14
	LDD        R5, Y+15
	CALL       _p_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Nux_BC_128.c,183 :: 		lsb_bits = (state<<16) | tmp_state; // swapping 1
	LDD        R16, Y+0
	LDD        R17, Y+1
	LDD        R18, Y+2
	LDD        R19, Y+3
	MOV        R23, R17
	MOV        R22, R16
	CLR        R20
	CLR        R21
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R6, R16
	MOVW       R8, R18
;Nux_BC_128.c,186 :: 		lcs_8(lsb_3,&state);
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
	LDD        R2, Y+16
	LDD        R3, Y+17
	LDD        R4, Y+18
	LDD        R5, Y+19
	CALL       _lcs_8+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Nux_BC_128.c,188 :: 		s_box(state,&state);
	MOVW       R16, R28
	PUSH       R25
	PUSH       R24
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _s_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
	POP        R24
	POP        R25
;Nux_BC_128.c,190 :: 		rcs_3(lsb_4,&tmp_state);
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
	MOVW       R6, R16
	LDD        R2, Y+20
	LDD        R3, Y+21
	LDD        R4, Y+22
	LDD        R5, Y+23
	CALL       _rcs_3+0
;Nux_BC_128.c,193 :: 		state = state ^ tmp_state ^ ((rk&0xffff));
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	LDD        R16, Y+28
	LDD        R17, Y+29
	LDD        R18, Y+30
	LDD        R19, Y+31
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 0
	ANDI       R19, 0
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	STD        Y+0, R20
	STD        Y+1, R21
	STD        Y+2, R22
	STD        Y+3, R23
;Nux_BC_128.c,195 :: 		p_box(state,&state);
	MOVW       R16, R28
	MOVW       R6, R16
	MOVW       R2, R20
	MOVW       R4, R22
	CALL       _p_box+0
;Nux_BC_128.c,198 :: 		p_box(lsb_3, &tmp_state);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R6, R16
	LDD        R2, Y+16
	LDD        R3, Y+17
	LDD        R4, Y+18
	LDD        R5, Y+19
	CALL       _p_box+0
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;Nux_BC_128.c,199 :: 		msb_bits = (tmp_state<<16) | state; // swapping 2
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	MOV        R23, R17
	MOV        R22, R16
	CLR        R20
	CLR        R21
	LDD        R16, Y+0
	LDD        R17, Y+1
	LDD        R18, Y+2
	LDD        R19, Y+3
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R2, R16
	MOVW       R4, R18
;Nux_BC_128.c,203 :: 		*out_m =0;
	LDD        R30, Y+32
	LDD        R31, Y+33
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Nux_BC_128.c,204 :: 		*out_l =0;
	MOVW       R30, R24
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;Nux_BC_128.c,205 :: 		*out_m = msb_bits;
	LDD        R30, Y+32
	LDD        R31, Y+33
	ST         Z+, R2
	ST         Z+, R3
	ST         Z+, R4
	ST         Z+, R5
;Nux_BC_128.c,206 :: 		*out_l = lsb_bits;
	MOVW       R30, R24
	ST         Z+, R6
	ST         Z+, R7
	ST         Z+, R8
	ST         Z+, R9
; out_l end address is: 24 (R24)
;Nux_BC_128.c,209 :: 		timer_stop();
	CALL       _timer_stop+0
;Nux_BC_128.c,212 :: 		} // Nux Round function end
L_end_nux_round:
	ADIW       R28, 23
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _nux_round

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 142
	SBCI       R29, 0
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Nux_BC_128.c,217 :: 		int main()
;Nux_BC_128.c,219 :: 		long int r_k[31]={0}, msb_out=0, lsb_out=0;
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
	ADIW       R26, 2
	LDI        R24, 140
	LDI        R25, 0
	CALL       ___CC2DW+0
;Nux_BC_128.c,220 :: 		long int pt[2] = {0x0, 0x0};      // hardcoded plaintext
;Nux_BC_128.c,223 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Nux_BC_128.c,224 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Nux_BC_128.c,225 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Nux_BC_128.c,228 :: 		key_schedule_1(r_k);           // key scheduling function call to store all the key
	MOVW       R16, R28
	SUBI       R16, 254
	SBCI       R17, 255
	MOVW       R2, R16
	CALL       _key_schedule_1+0
;Nux_BC_128.c,231 :: 		msb_out = pt[0];
	MOVW       R20, R28
	SUBI       R20, 122
	SBCI       R21, 255
	MOVW       R30, R20
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 130
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,232 :: 		lsb_out = pt[1];
	MOVW       R16, R20
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 126
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Nux_BC_128.c,236 :: 		for(i=0;i<31;i++)
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
	BRLT       L__main70
	JMP        L_main10
L__main70:
;Nux_BC_128.c,238 :: 		nux_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
	MOVW       R22, R28
	SUBI       R22, 126
	SBCI       R23, 255
	MOVW       R20, R28
	SUBI       R20, 130
	SBCI       R21, 255
	MOVW       R18, R28
	SUBI       R18, 254
	SBCI       R19, 255
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
	SUBI       R30, 126
	SBCI       R31, 255
	LD         R6, Z+
	LD         R7, Z+
	LD         R8, Z+
	LD         R9, Z+
	MOVW       R30, R28
	SUBI       R30, 130
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
	CALL       _nux_round+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R24
	POP        R25
;Nux_BC_128.c,236 :: 		for(i=0;i<31;i++)
	MOVW       R16, R24
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R24, R16
;Nux_BC_128.c,247 :: 		}// round = 25 for end
; i end address is: 24 (R24)
	JMP        L_main9
L_main10:
;Nux_BC_128.c,251 :: 		LongintTohex(msb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 130
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;Nux_BC_128.c,252 :: 		Lcd_out(1,1,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,253 :: 		LongintTohex(lsb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 126
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;Nux_BC_128.c,254 :: 		Lcd_out(1,10,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 10
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,255 :: 		Delay_ms(100);
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
;Nux_BC_128.c,258 :: 		IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
	MOVW       R16, R28
	MOVW       R4, R16
	LDS        R2, _time_count+0
	LDS        R3, _time_count+1
	CALL       _IntToStr+0
;Nux_BC_128.c,259 :: 		Lcd_out(3,1,"Overflows:");
	LDI        R27, #lo_addr(?lstr1_Nux_BC_128+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr1_Nux_BC_128+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,260 :: 		Lcd_out(3,13,t);             //
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,261 :: 		IntToStr(TCNT0,t);
	MOVW       R16, R28
	MOVW       R4, R16
	IN         R2, TCNT0+0
	LDI        R27, 0
	MOV        R3, R27
	CALL       _IntToStr+0
;Nux_BC_128.c,262 :: 		Lcd_out(4,1,"TCNT0 Value:");
	LDI        R27, #lo_addr(?lstr2_Nux_BC_128+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr2_Nux_BC_128+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,263 :: 		Lcd_out(4,13,t);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Nux_BC_128.c,265 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main14:
	DEC        R16
	BRNE       L_main14
	DEC        R17
	BRNE       L_main14
	DEC        R18
	BRNE       L_main14
;Nux_BC_128.c,267 :: 		} // main end
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
