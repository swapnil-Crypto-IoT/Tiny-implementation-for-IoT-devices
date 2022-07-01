
_timer_init:

;SIMON.c,45 :: 		void timer_init() //start timer
;SIMON.c,47 :: 		TIMSK=0b00000001; // enabling the interrupt
	LDI        R27, 1
	OUT        TIMSK+0, R27
;SIMON.c,48 :: 		SREG_I_bit = 1;
	IN         R27, SREG_I_bit+0
	SBR        R27, BitMask(SREG_I_bit+0)
	OUT        SREG_I_bit+0, R27
;SIMON.c,49 :: 		TCCR0=0b00000001; // setting the prescaler-1 i.e. no prescalar
	LDI        R27, 1
	OUT        TCCR0+0, R27
;SIMON.c,50 :: 		}
L_end_timer_init:
	RET
; end of _timer_init

_timer_stop:

;SIMON.c,52 :: 		void timer_stop() //stop timer
;SIMON.c,54 :: 		TCCR0=0b00000000;
	LDI        R27, 0
	OUT        TCCR0+0, R27
;SIMON.c,55 :: 		}
L_end_timer_stop:
	RET
; end of _timer_stop

_interrupt:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;SIMON.c,58 :: 		void interrupt() org IVT_ADDR_TIMER0_OVF // Interrupt Service Routine for to keep tracking timer overflow
;SIMON.c,60 :: 		time_count++;    // variable storing the number of times timer0 overflows
	LDS        R16, _time_count+0
	LDS        R17, _time_count+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _time_count+0, R16
	STS        _time_count+1, R17
;SIMON.c,61 :: 		}
L_end_interrupt:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _interrupt

_rcs_3:

;SIMON.c,67 :: 		long int rcs_3(long int msb_32, long int *rcs_msb_32)
;SIMON.c,69 :: 		*rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__rcs_316:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__rcs_316
L__rcs_317:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
L__rcs_318:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_318
L__rcs_319:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,70 :: 		}
L_end_rcs_3:
	RET
; end of _rcs_3

_rcs_4:

;SIMON.c,72 :: 		long int rcs_4(long int msb_32, long int *rcs_msb_32)
;SIMON.c,74 :: 		*rcs_msb_32 = ((msb_32&0xfffffff0)>>4)|((msb_32&0x0000000f)<<(32-4));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 240
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 4
	MOVW       R20, R16
	MOVW       R22, R18
L__rcs_421:
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	DEC        R27
	BRNE       L__rcs_421
L__rcs_422:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 15
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 28
L__rcs_423:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_423
L__rcs_424:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,75 :: 		}
L_end_rcs_4:
	RET
; end of _rcs_4

_rcs_1:

;SIMON.c,77 :: 		long int rcs_1(long int msb_32, long int *rcs_msb_32)
;SIMON.c,79 :: 		*rcs_msb_32 = ((msb_32&0xfffffffe)>>1)|((msb_32&0x00000001)<<(32-1));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 254
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	MOVW       R20, R16
	MOVW       R22, R18
	LSR        R23
	ROR        R22
	ROR        R21
	ROR        R20
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 1
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 31
L__rcs_126:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__rcs_126
L__rcs_127:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,80 :: 		}
L_end_rcs_1:
	RET
; end of _rcs_1

_rcs_8:

;SIMON.c,82 :: 		long int rcs_8(long int msb_32, long int *rcs_msb_32)
;SIMON.c,84 :: 		*rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	MOV        R20, R17
	MOV        R21, R18
	MOV        R22, R19
	LDI        R23, 0
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOV        R19, R16
	CLR        R16
	CLR        R17
	CLR        R18
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,85 :: 		}
L_end_rcs_8:
	RET
; end of _rcs_8

_lcs_1:

;SIMON.c,91 :: 		long int lcs_1(long int msb_32, long int *lcs_msb_32)
;SIMON.c,93 :: 		*lcs_msb_32 = ((msb_32&0x7fffffff)<<1)|((msb_32&0x80000000)>>(32-1));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 127
	MOVW       R20, R16
	MOVW       R22, R18
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 128
	LDI        R27, 31
L__lcs_130:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_130
L__lcs_131:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,94 :: 		}
L_end_lcs_1:
	RET
; end of _lcs_1

_lcs_2:

;SIMON.c,96 :: 		long int lcs_2(long int msb_32, long int *lcs_msb_32)
;SIMON.c,98 :: 		*lcs_msb_32 = ((msb_32&0x3fffffff)<<2)|((msb_32&0xc0000000)>>(32-2));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 63
	MOVW       R20, R16
	MOVW       R22, R18
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 192
	LDI        R27, 30
L__lcs_233:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_233
L__lcs_234:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,99 :: 		}
L_end_lcs_2:
	RET
; end of _lcs_2

_lcs_8:

;SIMON.c,101 :: 		long int lcs_8(long int msb_32, long int *lcs_msb_32)
;SIMON.c,103 :: 		*lcs_msb_32 = ((msb_32&0x00ffffff)<<8)|((msb_32&0xff000000)>>(32-8));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 0
	MOV        R23, R18
	MOV        R22, R17
	MOV        R21, R16
	CLR        R20
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 255
	MOV        R16, R19
	LDI        R17, 0
	MOV        R18, R17
	MOV        R19, R17
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,104 :: 		}
L_end_lcs_8:
	RET
; end of _lcs_8

_Key_Schedule:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 32
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;SIMON.c,109 :: 		long int Key_Schedule(long int *R_k)
;SIMON.c,111 :: 		long int Key[4]={0x03020100, 0x0b0a0908, 0x13121110, 0x1b1a1918}, z_m_32 = 0xfc2ce512, z_l_32 = 0x07a635db; // Hard coded key
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	LDI        R30, #lo_addr(?ICSKey_Schedule_Key_L0+0)
	LDI        R31, hi_addr(?ICSKey_Schedule_Key_L0+0)
	MOVW       R26, R28
	LDI        R24, 20
	LDI        R25, 0
	CALL       ___CC2DW+0
; z_l_32 start address is: 10 (R10)
	LDI        R27, 219
	MOV        R10, R27
	LDI        R27, 53
	MOV        R11, R27
	LDI        R27, 166
	MOV        R12, R27
	LDI        R27, 7
	MOV        R13, R27
;SIMON.c,112 :: 		long int c = 0xfffffffc, tmp_state[3]={0};
; c start address is: 6 (R6)
	LDI        R27, 252
	MOV        R6, R27
	LDI        R27, 255
	MOV        R7, R27
	MOV        R8, R27
	MOV        R9, R27
	LDI        R30, #lo_addr(?ICSKey_Schedule_tmp_state_L0+0)
	LDI        R31, hi_addr(?ICSKey_Schedule_tmp_state_L0+0)
	MOVW       R26, R28
	ADIW       R26, 20
	LDI        R24, 12
	LDI        R25, 0
	CALL       ___CC2DW+0
;SIMON.c,113 :: 		R_k[0] = Key[0]; //k[3] as per sequence in document
	MOVW       R30, R28
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R2
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,114 :: 		R_k[1] = Key[1]; //k[2]
	MOVW       R20, R2
	SUBI       R20, 252
	SBCI       R21, 255
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,115 :: 		R_k[2] = Key[2]; //k[1]
	MOVW       R20, R2
	SUBI       R20, 248
	SBCI       R21, 255
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,116 :: 		R_k[3] = Key[3]; //k[0]
	MOVW       R20, R2
	SUBI       R20, 244
	SBCI       R21, 255
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
;SIMON.c,118 :: 		for (i=4; i<44; i++)
	LDI        R27, 4
	STS        _i+0, R27
L_Key_Schedule0:
; c start address is: 6 (R6)
; c end address is: 6 (R6)
; z_l_32 start address is: 10 (R10)
; z_l_32 end address is: 10 (R10)
	LDS        R16, _i+0
	CPI        R16, 44
	BRLO       L__Key_Schedule37
	JMP        L_Key_Schedule1
L__Key_Schedule37:
; c end address is: 6 (R6)
; z_l_32 end address is: 10 (R10)
;SIMON.c,120 :: 		rcs_3(R_k[i-1],&tmp_state[0]);
; z_l_32 start address is: 10 (R10)
; c start address is: 6 (R6)
	MOVW       R20, R28
	SUBI       R20, 236
	SBCI       R21, 255
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 1
	SBCI       R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	PUSH       R3
	PUSH       R2
	MOVW       R6, R20
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _rcs_3+0
	POP        R2
	POP        R3
;SIMON.c,121 :: 		rcs_4(R_k[i-1],&tmp_state[1]);
	MOVW       R16, R28
	SUBI       R16, 236
	SBCI       R17, 255
	MOVW       R20, R16
	SUBI       R20, 252
	SBCI       R21, 255
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 1
	SBCI       R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R3
	PUSH       R2
	MOVW       R6, R20
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _rcs_4+0
	POP        R2
	POP        R3
;SIMON.c,122 :: 		rcs_1(R_k[i-3],&tmp_state[2]);
	MOVW       R16, R28
	SUBI       R16, 236
	SBCI       R17, 255
	MOVW       R20, R16
	SUBI       R20, 248
	SBCI       R21, 255
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 3
	SBCI       R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R3
	PUSH       R2
	MOVW       R6, R20
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _rcs_1+0
	POP        R2
	POP        R3
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;SIMON.c,123 :: 		if((i-4)<=31)
	LDS        R18, _i+0
	LDI        R19, 0
	SUBI       R18, 4
	SBCI       R19, 0
	LDI        R16, 31
	LDI        R17, 0
	CP         R16, R18
	CPC        R17, R19
	BRGE       L__Key_Schedule38
	JMP        L_Key_Schedule3
L__Key_Schedule38:
;SIMON.c,125 :: 		R_k[i] = c ^ ((z_l_32>>(i-4))&1) ^ R_k[i-4] ^ tmp_state[0] ^ R_k[i-3] ^ tmp_state[1] ^ tmp_state[2];
	LDS        R16, _i+0
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R4, R16
	ADD        R4, R2
	ADC        R5, R3
	LDS        R24, _i+0
	LDI        R25, 0
	SBIW       R24, 4
	MOV        R27, R24
	MOVW       R16, R10
	MOVW       R18, R12
	TST        R27
	BREQ       L__Key_Schedule40
L__Key_Schedule39:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__Key_Schedule39
L__Key_Schedule40:
	ANDI       R16, 1
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOVW       R20, R6
	MOVW       R22, R8
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R16, R24
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R24, R28
	ADIW       R24, 20
	MOVW       R30, R24
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 3
	SBCI       R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R30, R24
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R30, R24
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R4
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,126 :: 		}
	JMP        L_Key_Schedule4
L_Key_Schedule3:
;SIMON.c,129 :: 		R_k[i] = c ^ ((z_m_32>>((i-4)-32))&1) ^ R_k[i-4] ^ tmp_state[0] ^ R_k[i-3] ^ tmp_state[1] ^ tmp_state[2];
	LDS        R16, _i+0
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R4, R16
	ADD        R4, R2
	ADC        R5, R3
	LDS        R24, _i+0
	LDI        R25, 0
	SBIW       R24, 4
	MOVW       R20, R24
	SUBI       R20, 32
	SBCI       R21, 0
	LDD        R16, Y+16
	LDD        R17, Y+17
	LDD        R18, Y+18
	LDD        R19, Y+19
	MOV        R27, R20
	TST        R27
	BREQ       L__Key_Schedule42
L__Key_Schedule41:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__Key_Schedule41
L__Key_Schedule42:
	ANDI       R16, 1
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOVW       R20, R6
	MOVW       R22, R8
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R16, R24
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R24, R28
	ADIW       R24, 20
	MOVW       R30, R24
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	LDS        R16, _i+0
	LDI        R17, 0
	SUBI       R16, 3
	SBCI       R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R30, R16
	ADD        R30, R2
	ADC        R31, R3
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R30, R24
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R20, R16
	EOR        R21, R17
	EOR        R22, R18
	EOR        R23, R19
	MOVW       R30, R24
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R4
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,130 :: 		}
L_Key_Schedule4:
;SIMON.c,118 :: 		for (i=4; i<44; i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;SIMON.c,131 :: 		}
; c end address is: 6 (R6)
; z_l_32 end address is: 10 (R10)
	JMP        L_Key_Schedule0
L_Key_Schedule1:
;SIMON.c,132 :: 		}
L_end_Key_Schedule:
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	ADIW       R28, 31
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _Key_Schedule

_simon_round:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 12
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;SIMON.c,137 :: 		long int simon_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
; rk start address is: 10 (R10)
	LDD        R10, Y+16
	LDD        R11, Y+17
	LDD        R12, Y+18
	LDD        R13, Y+19
	LDD        R16, Y+20
	LDD        R17, Y+21
	STD        Y+20, R16
	STD        Y+21, R17
; out_l start address is: 24 (R24)
	LDD        R24, Y+22
	LDD        R25, Y+23
;SIMON.c,139 :: 		long int state=0,trail_1=0,trail_2=0;
	PUSH       R25
	PUSH       R24
	LDI        R27, 0
	STD        Y+4, R27
	STD        Y+5, R27
	STD        Y+6, R27
	STD        Y+7, R27
	POP        R24
	POP        R25
	LDI        R27, 0
	STD        Y+8, R27
	STD        Y+9, R27
	STD        Y+10, R27
	STD        Y+11, R27
;SIMON.c,140 :: 		timer_init();
	CALL       _timer_init+0
;SIMON.c,141 :: 		lcs_1(msb_bits,&trail_1);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	MOVW       R6, R16
	CALL       _lcs_1+0
;SIMON.c,142 :: 		lcs_8(msb_bits,&trail_2);
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 255
	MOVW       R6, R16
	CALL       _lcs_8+0
;SIMON.c,143 :: 		state = trail_1 & trail_2;
	LDD        R20, Y+4
	LDD        R21, Y+5
	LDD        R22, Y+6
	LDD        R23, Y+7
	LDD        R16, Y+8
	LDD        R17, Y+9
	LDD        R18, Y+10
	LDD        R19, Y+11
	AND        R16, R20
	AND        R17, R21
	AND        R18, R22
	AND        R19, R23
	STD        Y+0, R16
	STD        Y+1, R17
	STD        Y+2, R18
	STD        Y+3, R19
;SIMON.c,145 :: 		lcs_2(msb_bits,&trail_1);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R6, R16
	CALL       _lcs_2+0
	POP        R6
	POP        R7
	POP        R8
	POP        R9
;SIMON.c,147 :: 		trail_2 = state ^ trail_1 ^ lsb_bits ^ rk;
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
	EOR        R16, R6
	EOR        R17, R7
	EOR        R18, R8
	EOR        R19, R9
	EOR        R16, R10
	EOR        R17, R11
	EOR        R18, R12
	EOR        R19, R13
; rk end address is: 10 (R10)
	STD        Y+8, R16
	STD        Y+9, R17
	STD        Y+10, R18
	STD        Y+11, R19
;SIMON.c,151 :: 		lsb_bits = msb_bits;
	MOVW       R6, R2
	MOVW       R8, R4
;SIMON.c,152 :: 		msb_bits = trail_2;
	MOVW       R2, R16
	MOVW       R4, R18
;SIMON.c,157 :: 		*out_m = msb_bits;
	LDD        R30, Y+20
	LDD        R31, Y+21
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,158 :: 		*out_l = lsb_bits;
	MOVW       R30, R24
	ST         Z+, R6
	ST         Z+, R7
	ST         Z+, R8
	ST         Z+, R9
; out_l end address is: 24 (R24)
;SIMON.c,159 :: 		timer_stop();
	CALL       _timer_stop+0
;SIMON.c,160 :: 		}
L_end_simon_round:
	ADIW       R28, 11
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _simon_round

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 194
	SBCI       R29, 0
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;SIMON.c,165 :: 		int main()
;SIMON.c,167 :: 		long int R_k[44]= {0}, Msb_Out = 0, Lsb_Out=0;
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDI        R30, #lo_addr(?ICSmain_R_k_L0+0)
	LDI        R31, hi_addr(?ICSmain_R_k_L0+0)
	MOVW       R26, R28
	ADIW       R26, 2
	LDI        R24, 192
	LDI        R25, 0
	CALL       ___CC2DW+0
;SIMON.c,168 :: 		long int P_t[2]={0x656b696c,0x20646e75} ;// Plaintext register (hardcoded)
;SIMON.c,172 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;SIMON.c,173 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;SIMON.c,174 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;SIMON.c,178 :: 		Key_Schedule(R_k);           // key scheduling function call to store all the key
	MOVW       R16, R28
	SUBI       R16, 254
	SBCI       R17, 255
	MOVW       R2, R16
	CALL       _Key_Schedule+0
;SIMON.c,181 :: 		Msb_out = P_t[0];
	MOVW       R20, R28
	SUBI       R20, 70
	SBCI       R21, 255
	MOVW       R30, R20
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 78
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,182 :: 		Lsb_out = P_t[1];
	MOVW       R16, R20
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R28
	SUBI       R30, 74
	SBCI       R31, 255
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;SIMON.c,183 :: 		for(i=0;i<44;i++)
; i start address is: 24 (R24)
	LDI        R24, 0
; i end address is: 24 (R24)
L_main5:
; i start address is: 24 (R24)
	CPI        R24, 44
	BRLO       L__main45
	JMP        L_main6
L__main45:
;SIMON.c,185 :: 		simon_round(Msb_out, Lsb_out, R_k[i], &Msb_out, &Lsb_out);
	MOVW       R22, R28
	SUBI       R22, 74
	SBCI       R23, 255
	MOVW       R20, R28
	SUBI       R20, 78
	SBCI       R21, 255
	MOVW       R18, R28
	SUBI       R18, 254
	SBCI       R19, 255
	MOV        R16, R24
	LDI        R17, 0
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
	PUSH       R24
	MOVW       R30, R28
	SUBI       R30, 74
	SBCI       R31, 255
	LD         R6, Z+
	LD         R7, Z+
	LD         R8, Z+
	LD         R9, Z+
	MOVW       R30, R28
	SUBI       R30, 78
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
	CALL       _simon_round+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R24
;SIMON.c,183 :: 		for(i=0;i<44;i++)
	MOV        R16, R24
	SUBI       R16, 255
	MOV        R24, R16
;SIMON.c,186 :: 		}
; i end address is: 24 (R24)
	JMP        L_main5
L_main6:
;SIMON.c,189 :: 		LongintTohex(Msb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 78
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;SIMON.c,190 :: 		Lcd_out(1,1,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,191 :: 		LongintTohex(Lsb_out,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	MOVW       R30, R28
	SUBI       R30, 74
	SBCI       R31, 255
	LD         R2, Z+
	LD         R3, Z+
	LD         R4, Z+
	LD         R5, Z+
	CALL       _LongIntToHex+0
;SIMON.c,192 :: 		Lcd_out(1,10,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 10
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,193 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main8:
	DEC        R16
	BRNE       L_main8
	DEC        R17
	BRNE       L_main8
	DEC        R18
	BRNE       L_main8
;SIMON.c,196 :: 		IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
	MOVW       R16, R28
	MOVW       R4, R16
	LDS        R2, _time_count+0
	LDS        R3, _time_count+1
	CALL       _IntToStr+0
;SIMON.c,197 :: 		Lcd_out(3,1,"Overflows:");
	LDI        R27, #lo_addr(?lstr1_SIMON+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr1_SIMON+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,198 :: 		Lcd_out(3,13,t);             //
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,199 :: 		IntToStr(TCNT0,t);
	MOVW       R16, R28
	MOVW       R4, R16
	IN         R2, TCNT0+0
	LDI        R27, 0
	MOV        R3, R27
	CALL       _IntToStr+0
;SIMON.c,200 :: 		Lcd_out(4,1,"TCNT0 Value:");
	LDI        R27, #lo_addr(?lstr2_SIMON+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr2_SIMON+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,201 :: 		Lcd_out(4,13,t);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;SIMON.c,203 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main10:
	DEC        R16
	BRNE       L_main10
	DEC        R17
	BRNE       L_main10
	DEC        R18
	BRNE       L_main10
;SIMON.c,206 :: 		}
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
