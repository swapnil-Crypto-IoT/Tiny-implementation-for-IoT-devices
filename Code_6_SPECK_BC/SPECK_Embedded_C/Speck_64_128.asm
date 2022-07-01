
_timer_init:

;Speck_64_128.c,43 :: 		void timer_init() //start timer
;Speck_64_128.c,45 :: 		TIMSK=0b00000001; // enabling the interrupt
	LDI        R27, 1
	OUT        TIMSK+0, R27
;Speck_64_128.c,46 :: 		SREG_I_bit = 1;
	IN         R27, SREG_I_bit+0
	SBR        R27, BitMask(SREG_I_bit+0)
	OUT        SREG_I_bit+0, R27
;Speck_64_128.c,47 :: 		TCCR0=0b00000001; // setting the prescaler-1 i.e. no prescalar
	LDI        R27, 1
	OUT        TCCR0+0, R27
;Speck_64_128.c,48 :: 		}
L_end_timer_init:
	RET
; end of _timer_init

_timer_stop:

;Speck_64_128.c,50 :: 		void timer_stop() //stop timer
;Speck_64_128.c,52 :: 		TCCR0=0b00000000;
	LDI        R27, 0
	OUT        TCCR0+0, R27
;Speck_64_128.c,53 :: 		}
L_end_timer_stop:
	RET
; end of _timer_stop

_interrupt:
	PUSH       R30
	PUSH       R31
	PUSH       R27
	IN         R27, SREG+0
	PUSH       R27

;Speck_64_128.c,56 :: 		void interrupt() org IVT_ADDR_TIMER0_OVF // Interrupt Service Routine for to keep tracking timer overflow
;Speck_64_128.c,58 :: 		time_count++;    // variable storing the number of times timer0 overflows
	LDS        R16, _time_count+0
	LDS        R17, _time_count+1
	SUBI       R16, 255
	SBCI       R17, 255
	STS        _time_count+0, R16
	STS        _time_count+1, R17
;Speck_64_128.c,59 :: 		}
L_end_interrupt:
	POP        R27
	OUT        SREG+0, R27
	POP        R27
	POP        R31
	POP        R30
	RETI
; end of _interrupt

_rcs_8:

;Speck_64_128.c,64 :: 		long int rcs_8(long int msb_32, long int *rcs_msb_32)
;Speck_64_128.c,66 :: 		*rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
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
;Speck_64_128.c,67 :: 		}
L_end_rcs_8:
	RET
; end of _rcs_8

_lcs_3:

;Speck_64_128.c,72 :: 		long int lcs_3(long int msb_32, long int *lcs_msb_32)
;Speck_64_128.c,74 :: 		*lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 255
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 31
	LDI        R27, 3
	MOVW       R20, R16
	MOVW       R22, R18
L__lcs_316:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__lcs_316
L__lcs_317:
	MOVW       R16, R2
	MOVW       R18, R4
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 224
	LDI        R27, 29
L__lcs_318:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__lcs_318
L__lcs_319:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R6
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Speck_64_128.c,75 :: 		}
L_end_lcs_3:
	RET
; end of _lcs_3

_Key_plus_encryption_speck:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 8
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Speck_64_128.c,82 :: 		long int Key_plus_encryption_speck(long int x, long int y, long int i, long int *t1, long int *t2)
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDD        R16, Y+12
	LDD        R17, Y+13
	LDD        R18, Y+14
	LDD        R19, Y+15
	STD        Y+12, R16
	STD        Y+13, R17
	STD        Y+14, R18
	STD        Y+15, R19
; t1 start address is: 24 (R24)
	LDD        R24, Y+16
	LDD        R25, Y+17
	LDD        R16, Y+18
	LDD        R17, Y+19
	STD        Y+18, R16
	STD        Y+19, R17
	STD        Y+0, R2
	STD        Y+1, R3
	STD        Y+2, R4
	STD        Y+3, R5
	STD        Y+4, R6
	STD        Y+5, R7
	STD        Y+6, R8
	STD        Y+7, R9
;Speck_64_128.c,85 :: 		rcs_8(x,&x);
	MOVW       R16, R28
	MOVW       R6, R16
	LDD        R2, Y+0
	LDD        R3, Y+1
	LDD        R4, Y+2
	LDD        R5, Y+3
	CALL       _rcs_8+0
;Speck_64_128.c,86 :: 		x+=y;
	LDD        R20, Y+0
	LDD        R21, Y+1
	LDD        R22, Y+2
	LDD        R23, Y+3
	LDD        R16, Y+4
	LDD        R17, Y+5
	LDD        R18, Y+6
	LDD        R19, Y+7
	ADD        R20, R16
	ADC        R21, R17
	ADC        R22, R18
	ADC        R23, R19
	STD        Y+0, R20
	STD        Y+1, R21
	STD        Y+2, R22
	STD        Y+3, R23
;Speck_64_128.c,87 :: 		x^=i;
	LDD        R16, Y+12
	LDD        R17, Y+13
	LDD        R18, Y+14
	LDD        R19, Y+15
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	STD        Y+0, R16
	STD        Y+1, R17
	STD        Y+2, R18
	STD        Y+3, R19
;Speck_64_128.c,88 :: 		*t1 = x;
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
; t1 end address is: 24 (R24)
;Speck_64_128.c,89 :: 		lcs_3(y,&y);
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R6, R16
	LDD        R2, Y+4
	LDD        R3, Y+5
	LDD        R4, Y+6
	LDD        R5, Y+7
	CALL       _lcs_3+0
;Speck_64_128.c,90 :: 		y^=x;
	LDD        R20, Y+4
	LDD        R21, Y+5
	LDD        R22, Y+6
	LDD        R23, Y+7
	LDD        R16, Y+0
	LDD        R17, Y+1
	LDD        R18, Y+2
	LDD        R19, Y+3
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	STD        Y+4, R16
	STD        Y+5, R17
	STD        Y+6, R18
	STD        Y+7, R19
;Speck_64_128.c,91 :: 		*t2 = y;
	LDD        R30, Y+18
	LDD        R31, Y+19
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;Speck_64_128.c,94 :: 		}
L_end_Key_plus_encryption_speck:
	POP        R9
	POP        R8
	POP        R7
	POP        R6
	POP        R5
	POP        R4
	POP        R3
	POP        R2
	ADIW       R28, 7
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _Key_plus_encryption_speck

_key_update:

;Speck_64_128.c,95 :: 		long int key_update(long int *key, long int *round_key)
;Speck_64_128.c,98 :: 		for(i=0; i<27; i+=3)
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
; i start address is: 26 (R26)
	LDI        R26, 0
; i end address is: 26 (R26)
L_key_update0:
; i start address is: 26 (R26)
	CPI        R26, 27
	BRLO       L__key_update22
	JMP        L_key_update1
L__key_update22:
;Speck_64_128.c,100 :: 		if(i==0)
	CPI        R26, 0
	BREQ       L__key_update23
	JMP        L_key_update3
L__key_update23:
;Speck_64_128.c,102 :: 		round_key[i] = key[3];
	MOV        R16, R26
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R4
	ADC        R21, R5
	MOVW       R30, R2
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
;Speck_64_128.c,104 :: 		}
L_key_update3:
;Speck_64_128.c,106 :: 		Key_plus_encryption_speck(key[2],key[3],i,&key[2],&key[3]);
	MOVW       R6, R2
	LDI        R27, 244
	SUB        R6, R27
	LDI        R27, 255
	SBC        R7, R27
	MOVW       R24, R2
	ADIW       R24, 8
	MOVW       R30, R2
	ADIW       R30, 12
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R30, R2
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R26
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	PUSH       R7
	PUSH       R6
	PUSH       R25
	PUSH       R24
	LDI        R27, 0
	PUSH       R27
	PUSH       R27
	PUSH       R27
	PUSH       R26
	MOVW       R6, R20
	MOVW       R8, R22
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _Key_plus_encryption_speck+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R26
;Speck_64_128.c,107 :: 		round_key[i+1] = key[3];
	MOV        R16, R26
	LDI        R17, 0
	SUBI       R16, 255
	SBCI       R17, 255
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R4
	ADC        R21, R5
	MOVW       R30, R2
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
;Speck_64_128.c,110 :: 		Key_plus_encryption_speck(key[1],key[3],i+1,&key[1],&key[3]);
	MOVW       R8, R2
	LDI        R27, 244
	SUB        R8, R27
	LDI        R27, 255
	SBC        R9, R27
	MOVW       R6, R2
	LDI        R27, 252
	SUB        R6, R27
	LDI        R27, 255
	SBC        R7, R27
	MOV        R24, R26
	LDI        R25, 0
	SUBI       R24, 255
	SBCI       R25, 255
	MOVW       R30, R2
	ADIW       R30, 12
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R30, R2
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R26
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	PUSH       R9
	PUSH       R8
	PUSH       R7
	PUSH       R6
	LDI        R27, 0
	SBRC       R25, 7
	LDI        R27, 255
	PUSH       R27
	PUSH       R27
	PUSH       R25
	PUSH       R24
	MOVW       R6, R20
	MOVW       R8, R22
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _Key_plus_encryption_speck+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R26
;Speck_64_128.c,111 :: 		round_key[i+2] = key[3];
	MOV        R16, R26
	LDI        R17, 0
	SUBI       R16, 254
	SBCI       R17, 255
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R4
	ADC        R21, R5
	MOVW       R30, R2
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
;Speck_64_128.c,114 :: 		Key_plus_encryption_speck(key[0],key[3],i+2,&key[0],&key[3]);
	MOVW       R6, R2
	LDI        R27, 244
	SUB        R6, R27
	LDI        R27, 255
	SBC        R7, R27
	MOV        R24, R26
	LDI        R25, 0
	SUBI       R24, 254
	SBCI       R25, 255
	MOVW       R30, R2
	ADIW       R30, 12
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R30, R2
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R26
	PUSH       R5
	PUSH       R4
	PUSH       R3
	PUSH       R2
	PUSH       R7
	PUSH       R6
	PUSH       R3
	PUSH       R2
	LDI        R27, 0
	SBRC       R25, 7
	LDI        R27, 255
	PUSH       R27
	PUSH       R27
	PUSH       R25
	PUSH       R24
	MOVW       R6, R20
	MOVW       R8, R22
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _Key_plus_encryption_speck+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R2
	POP        R3
	POP        R4
	POP        R5
	POP        R26
;Speck_64_128.c,115 :: 		round_key[i+3] = key[3];
	MOV        R16, R26
	LDI        R17, 0
	SUBI       R16, 253
	SBCI       R17, 255
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R4
	ADC        R21, R5
	MOVW       R30, R2
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
;Speck_64_128.c,98 :: 		for(i=0; i<27; i+=3)
	MOV        R16, R26
	SUBI       R16, 253
	MOV        R26, R16
;Speck_64_128.c,117 :: 		}
; i end address is: 26 (R26)
	JMP        L_key_update0
L_key_update1:
;Speck_64_128.c,121 :: 		}
L_end_key_update:
	POP        R9
	POP        R8
	POP        R7
	POP        R6
	RET
; end of _key_update

_speck_round:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	ADIW       R28, 5

;Speck_64_128.c,126 :: 		long int speck_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
; rk start address is: 16 (R16)
	LDD        R16, Y+0
	LDD        R17, Y+1
	LDD        R18, Y+2
	LDD        R19, Y+3
; out_m start address is: 20 (R20)
	LDD        R20, Y+4
	LDD        R21, Y+5
; out_l start address is: 22 (R22)
	LDD        R22, Y+6
	LDD        R23, Y+7
;Speck_64_128.c,130 :: 		Key_plus_encryption_speck(msb_bits,lsb_bits,rk,out_m,out_l);
	PUSH       R23
	PUSH       R22
; out_l end address is: 22 (R22)
	PUSH       R21
	PUSH       R20
; out_m end address is: 20 (R20)
	PUSH       R19
	PUSH       R18
	PUSH       R17
	PUSH       R16
; rk end address is: 16 (R16)
	CALL       _Key_plus_encryption_speck+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
;Speck_64_128.c,132 :: 		}
L_end_speck_round:
	POP        R29
	POP        R28
	RET
; end of _speck_round

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 134
	SBCI       R29, 0
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;Speck_64_128.c,134 :: 		int main()
;Speck_64_128.c,137 :: 		long int Msb_Bits = 0x3b726574, Lsb_Bits = 0x7475432d; // hardcoded plaintext
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDI        R30, #lo_addr(?ICSmain_Msb_Bits_L0+0)
	LDI        R31, hi_addr(?ICSmain_Msb_Bits_L0+0)
	MOVW       R26, R28
	ADIW       R26, 2
	LDI        R24, 132
	LDI        R25, 0
	CALL       ___CC2DW+0
;Speck_64_128.c,138 :: 		long int key[4] = {0x1b1a1918, 0x13121110, 0x0b0a0908, 0x03020100}; // hardcoded key
;Speck_64_128.c,139 :: 		long int R_key[27] = {0}; // key register to store all round key sequentially
;Speck_64_128.c,143 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;Speck_64_128.c,144 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Speck_64_128.c,145 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	LDI        R27, 12
	MOV        R2, R27
	CALL       _Lcd_Cmd+0
;Speck_64_128.c,150 :: 		key_update(key,R_key);
	MOVW       R18, R28
	SUBI       R18, 230
	SBCI       R19, 255
	MOVW       R16, R28
	SUBI       R16, 246
	SBCI       R17, 255
	MOVW       R4, R18
	MOVW       R2, R16
	CALL       _key_update+0
;Speck_64_128.c,155 :: 		for(i=0; i<27; i++)
; i start address is: 24 (R24)
	LDI        R24, 0
	LDI        R25, 0
; i end address is: 24 (R24)
L_main4:
; i start address is: 24 (R24)
	LDI        R16, 27
	LDI        R17, 0
	CP         R24, R16
	CPC        R25, R17
	BRLT       L__main26
	JMP        L_main5
L__main26:
;Speck_64_128.c,157 :: 		speck_round(Msb_Bits, Lsb_Bits,R_key[i], &Msb_Bits, &Lsb_Bits);
	MOVW       R22, R28
	SUBI       R22, 250
	SBCI       R23, 255
	MOVW       R20, R28
	SUBI       R20, 254
	SBCI       R21, 255
	MOVW       R18, R28
	SUBI       R18, 230
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
	LDD        R6, Y+6
	LDD        R7, Y+7
	LDD        R8, Y+8
	LDD        R9, Y+9
	LDD        R2, Y+2
	LDD        R3, Y+3
	LDD        R4, Y+4
	LDD        R5, Y+5
	PUSH       R23
	PUSH       R22
	PUSH       R21
	PUSH       R20
	PUSH       R19
	PUSH       R18
	PUSH       R17
	PUSH       R16
	CALL       _speck_round+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 8
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R24
	POP        R25
;Speck_64_128.c,155 :: 		for(i=0; i<27; i++)
	MOVW       R16, R24
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R24, R16
;Speck_64_128.c,158 :: 		}
; i end address is: 24 (R24)
	JMP        L_main4
L_main5:
;Speck_64_128.c,163 :: 		LongintTohex(Msb_Bits,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	LDD        R2, Y+2
	LDD        R3, Y+3
	LDD        R4, Y+4
	LDD        R5, Y+5
	CALL       _LongIntToHex+0
;Speck_64_128.c,164 :: 		Lcd_out(1,1,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,165 :: 		LongintTohex(Lsb_Bits,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R6, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R7, R27
	LDD        R2, Y+6
	LDD        R3, Y+7
	LDD        R4, Y+8
	LDD        R5, Y+9
	CALL       _LongIntToHex+0
;Speck_64_128.c,166 :: 		Lcd_out(1,10,ch);
	LDI        R27, #lo_addr(_ch+0)
	MOV        R4, R27
	LDI        R27, hi_addr(_ch+0)
	MOV        R5, R27
	LDI        R27, 10
	MOV        R3, R27
	LDI        R27, 1
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,167 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main7:
	DEC        R16
	BRNE       L_main7
	DEC        R17
	BRNE       L_main7
	DEC        R18
	BRNE       L_main7
;Speck_64_128.c,170 :: 		IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
	MOVW       R16, R28
	MOVW       R4, R16
	LDS        R2, _time_count+0
	LDS        R3, _time_count+1
	CALL       _IntToStr+0
;Speck_64_128.c,171 :: 		Lcd_out(3,1,"Overflow:");
	LDI        R27, #lo_addr(?lstr1_Speck_64_128+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr1_Speck_64_128+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,172 :: 		Lcd_out(3,13,t);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 3
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,173 :: 		IntToStr(TCNT0,t);
	MOVW       R16, R28
	MOVW       R4, R16
	IN         R2, TCNT0+0
	LDI        R27, 0
	MOV        R3, R27
	CALL       _IntToStr+0
;Speck_64_128.c,174 :: 		Lcd_out(4,1,"TCNT0 Value:");
	LDI        R27, #lo_addr(?lstr2_Speck_64_128+0)
	MOV        R4, R27
	LDI        R27, hi_addr(?lstr2_Speck_64_128+0)
	MOV        R5, R27
	LDI        R27, 1
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,175 :: 		Lcd_out(4,13,t);
	MOVW       R16, R28
	MOVW       R4, R16
	LDI        R27, 13
	MOV        R3, R27
	LDI        R27, 4
	MOV        R2, R27
	CALL       _Lcd_Out+0
;Speck_64_128.c,177 :: 		Delay_ms(100);
	LDI        R18, 5
	LDI        R17, 15
	LDI        R16, 242
L_main9:
	DEC        R16
	BRNE       L_main9
	DEC        R17
	BRNE       L_main9
	DEC        R18
	BRNE       L_main9
;Speck_64_128.c,179 :: 		}
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
