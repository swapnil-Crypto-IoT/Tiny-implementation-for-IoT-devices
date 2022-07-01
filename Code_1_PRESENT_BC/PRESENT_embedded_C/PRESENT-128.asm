
_s_box:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 32
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;PRESENT-128.c,59 :: 		long int s_box(long int temp1)
;PRESENT-128.c,62 :: 		temp2=0;
	LDI        R27, 0
	STS        _temp2+0, R27
	STS        _temp2+1, R27
	STS        _temp2+2, R27
	STS        _temp2+3, R27
;PRESENT-128.c,63 :: 		for(i=0;i<32;i=i+4)
	LDI        R27, 0
	STS        _i+0, R27
L_s_box0:
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__s_box32
	JMP        L_s_box1
L__s_box32:
;PRESENT-128.c,65 :: 		a[(i*1)/4]= sbox[((temp1>>(i))&0xf)];
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
	BREQ       L__s_box34
L__s_box33:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__s_box33
L__s_box34:
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
;PRESENT-128.c,66 :: 		temp2 |= a[(i*1)/4] << i;
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
	BREQ       L__s_box36
L__s_box35:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__s_box35
L__s_box36:
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	LDS        R18, _temp2+2
	LDS        R19, _temp2+3
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	STS        _temp2+0, R16
	STS        _temp2+1, R17
	STS        _temp2+2, R18
	STS        _temp2+3, R19
;PRESENT-128.c,63 :: 		for(i=0;i<32;i=i+4)
	LDS        R16, _i+0
	SUBI       R16, 252
	STS        _i+0, R16
;PRESENT-128.c,67 :: 		}
	JMP        L_s_box0
L_s_box1:
;PRESENT-128.c,68 :: 		return(temp2);
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	LDS        R18, _temp2+2
	LDS        R19, _temp2+3
;PRESENT-128.c,69 :: 		}
L_end_s_box:
	ADIW       R28, 31
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _s_box

_p_layer:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 0
	SBCI       R29, 2
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;PRESENT-128.c,72 :: 		long int p_layer(long int temp1, long int temp2, long int result[])
; result start address is: 22 (R22)
	MOVW       R30, R28
	SUBI       R30, 252
	SBCI       R31, 253
	LD         R22, Z+
	LD         R23, Z+
;PRESENT-128.c,74 :: 		long int pbox[64]={0};
	LDI        R30, #lo_addr(?ICSp_layer_pbox_L0+0)
	LDI        R31, hi_addr(?ICSp_layer_pbox_L0+0)
	MOVW       R26, R28
	LDI        R24, 0
	LDI        R25, 2
	CALL       ___CC2DW+0
;PRESENT-128.c,75 :: 		long int pbox_out[64]={0};
;PRESENT-128.c,77 :: 		for(i=0;i<32;i++)
	LDI        R27, 0
	STS        _i+0, R27
; result end address is: 22 (R22)
L_p_layer3:
; result start address is: 22 (R22)
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__p_layer38
	JMP        L_p_layer4
L__p_layer38:
;PRESENT-128.c,79 :: 		pbox[31-i]=(temp1>>i)&0x1;        //corrosponds to pt[0] msb
	LDS        R0, _i+0
	LDI        R27, 0
	MOV        R1, R27
	LDI        R16, 31
	LDI        R17, 0
	SUB        R16, R0
	SBC        R17, R1
	MOVW       R18, R28
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R18
	ADC        R21, R19
	LDS        R27, _i+0
	MOVW       R16, R2
	MOVW       R18, R4
	TST        R27
	BREQ       L__p_layer40
L__p_layer39:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__p_layer39
L__p_layer40:
	ANDI       R16, 1
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,77 :: 		for(i=0;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,80 :: 		}
	JMP        L_p_layer3
L_p_layer4:
;PRESENT-128.c,82 :: 		for(i=0;i<32;i++)
	LDI        R27, 0
	STS        _i+0, R27
; result end address is: 22 (R22)
L_p_layer6:
; result start address is: 22 (R22)
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__p_layer41
	JMP        L_p_layer7
L__p_layer41:
;PRESENT-128.c,84 :: 		pbox[63-i]=(temp2>>i)&0x1;        //corrosponds to pt[1] msb
	LDS        R0, _i+0
	LDI        R27, 0
	MOV        R1, R27
	LDI        R16, 63
	LDI        R17, 0
	SUB        R16, R0
	SBC        R17, R1
	MOVW       R18, R28
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R18
	ADC        R21, R19
	LDS        R27, _i+0
	MOVW       R16, R6
	MOVW       R18, R8
	TST        R27
	BREQ       L__p_layer43
L__p_layer42:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__p_layer42
L__p_layer43:
	ANDI       R16, 1
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,82 :: 		for(i=0;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,85 :: 		}
	JMP        L_p_layer6
L_p_layer7:
;PRESENT-128.c,87 :: 		for(i=0;i<64;i++)
	LDI        R27, 0
	STS        _i+0, R27
; result end address is: 22 (R22)
	MOVW       R10, R22
L_p_layer9:
; result start address is: 10 (R10)
	LDS        R16, _i+0
	CPI        R16, 64
	BRLO       L__p_layer44
	JMP        L_p_layer10
L__p_layer44:
;PRESENT-128.c,89 :: 		pbox_out[player[i]] = pbox[i];
	LDI        R18, #lo_addr(_player+0)
	LDI        R19, hi_addr(_player+0)
	LDS        R16, _i+0
	LDI        R17, 0
	ADD        R16, R18
	ADC        R17, R19
	MOVW       R30, R16
	LD         R16, Z
	MOVW       R18, R28
	SUBI       R18, 0
	SBCI       R19, 255
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R18
	ADC        R21, R19
	MOVW       R18, R28
	LDS        R16, _i+0
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
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,87 :: 		for(i=0;i<64;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,90 :: 		}
	JMP        L_p_layer9
L_p_layer10:
;PRESENT-128.c,92 :: 		result[0]=0;
	MOVW       R30, R10
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;PRESENT-128.c,93 :: 		for(i=0;i<32;i++)
	LDI        R27, 0
	STS        _i+0, R27
; result end address is: 10 (R10)
L_p_layer12:
; result start address is: 10 (R10)
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__p_layer45
	JMP        L_p_layer13
L__p_layer45:
;PRESENT-128.c,95 :: 		result[0] |=  pbox_out[31-i]<<i;
	LDS        R0, _i+0
	LDI        R27, 0
	MOV        R1, R27
	LDI        R16, 31
	LDI        R17, 0
	SUB        R16, R0
	SBC        R17, R1
	MOVW       R18, R28
	SUBI       R18, 0
	SBCI       R19, 255
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
	LDS        R27, _i+0
	MOVW       R20, R16
	MOVW       R22, R18
	TST        R27
	BREQ       L__p_layer47
L__p_layer46:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__p_layer46
L__p_layer47:
	MOVW       R30, R10
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R10
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,93 :: 		for(i=0;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,96 :: 		}
	JMP        L_p_layer12
L_p_layer13:
;PRESENT-128.c,98 :: 		result[1] = 0;
	MOVW       R16, R10
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LDI        R27, 0
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
	ST         Z+, R27
;PRESENT-128.c,99 :: 		for(i=0;i<32;i++)
	LDI        R27, 0
	STS        _i+0, R27
L_p_layer15:
; result start address is: 10 (R10)
; result end address is: 10 (R10)
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__p_layer48
	JMP        L_p_layer16
L__p_layer48:
; result end address is: 10 (R10)
;PRESENT-128.c,101 :: 		result[1] |=  pbox_out[63-i]<<i;
; result start address is: 10 (R10)
	MOVW       R24, R10
	ADIW       R24, 4
	LDS        R0, _i+0
	LDI        R27, 0
	MOV        R1, R27
	LDI        R16, 63
	LDI        R17, 0
	SUB        R16, R0
	SBC        R17, R1
	MOVW       R18, R28
	SUBI       R18, 0
	SBCI       R19, 255
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
	LDS        R27, _i+0
	MOVW       R20, R16
	MOVW       R22, R18
	TST        R27
	BREQ       L__p_layer50
L__p_layer49:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__p_layer49
L__p_layer50:
	MOVW       R30, R24
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,99 :: 		for(i=0;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,102 :: 		}
; result end address is: 10 (R10)
	JMP        L_p_layer15
L_p_layer16:
;PRESENT-128.c,103 :: 		}
L_end_p_layer:
	SUBI       R28, 1
	SBCI       R29, 254
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _p_layer

_key_schedule_1:
	PUSH       R28
	PUSH       R29
	IN         R28, SPL+0
	IN         R29, SPL+1
	SBIW       R28, 16
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;PRESENT-128.c,106 :: 		long int key_schedule_1(long int a[], long int b[])
;PRESENT-128.c,109 :: 		for(j=1;j<=2;j++)
	LDI        R27, 1
	STS        _j+0, R27
L_key_schedule_118:
	LDS        R17, _j+0
	LDI        R16, 2
	CP         R16, R17
	BRSH       L__key_schedule_152
	JMP        L_key_schedule_119
L__key_schedule_152:
;PRESENT-128.c,111 :: 		long int Key[4]={0x01234567,0x89abcdef,0x01234567,0x89abcdef}; //hard coded 128 bit master key
	LDI        R30, #lo_addr(?ICSkey_schedule_1_Key_L1+0)
	LDI        R31, hi_addr(?ICSkey_schedule_1_Key_L1+0)
	MOVW       R26, R28
	LDI        R24, 16
	LDI        R25, 0
	CALL       ___CC2DW+0
;PRESENT-128.c,113 :: 		if(j==1)
	LDS        R16, _j+0
	CPI        R16, 1
	BREQ       L__key_schedule_153
	JMP        L_key_schedule_121
L__key_schedule_153:
;PRESENT-128.c,114 :: 		{a[0] = Key[0];}
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
L_key_schedule_121:
;PRESENT-128.c,115 :: 		if(j==2)
	LDS        R16, _j+0
	CPI        R16, 2
	BREQ       L__key_schedule_154
	JMP        L_key_schedule_122
L__key_schedule_154:
;PRESENT-128.c,116 :: 		{b[0] = Key[1];}
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R4
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
L_key_schedule_122:
;PRESENT-128.c,119 :: 		for(i=1;i<32;i++)
	LDI        R27, 1
	STS        _i+0, R27
L_key_schedule_123:
	LDS        R16, _i+0
	CPI        R16, 32
	BRLO       L__key_schedule_155
	JMP        L_key_schedule_124
L__key_schedule_155:
;PRESENT-128.c,121 :: 		temp1 = temp2 = 0;
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
;PRESENT-128.c,122 :: 		temp1 = Key[0];
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
;PRESENT-128.c,123 :: 		temp2 = Key[1];
	MOVW       R30, R24
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	STS        _temp2+0, R16
	STS        _temp2+1, R17
	STS        _temp2+2, R18
	STS        _temp2+3, R19
;PRESENT-128.c,125 :: 		Key[0]  = ((Key[1]&0X7)<<29)|(((Key[2]&0XFFFFFFF8))>>3) ;
	MOVW       R30, R24
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
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
	MOVW       R30, R24
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
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
;PRESENT-128.c,126 :: 		Key[1]  = ((Key[2]&0X7)<<29) |(((Key[3]&0XFFFFFFF8))>>3);
	MOVW       R6, R28
	MOVW       R24, R6
	ADIW       R24, 4
	MOVW       R30, R6
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_160:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_160
L__key_schedule_161:
	MOVW       R30, R6
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
L__key_schedule_162:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_162
L__key_schedule_163:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,127 :: 		Key[2]  = ((Key[3]&0X7)<<29) |(((temp1&0XFFFFFFF8))>>3);
	MOVW       R16, R28
	MOVW       R24, R16
	ADIW       R24, 8
	MOVW       R30, R16
	ADIW       R30, 12
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_164:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_164
L__key_schedule_165:
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
L__key_schedule_166:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
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
;PRESENT-128.c,128 :: 		Key[3]  = ((temp1&0X7)<<29) |(((temp2&0XFFFFFFF8))>>3);    //left circular shift by 61
	MOVW       R16, R28
	MOVW       R30, R16
	ADIW       R30, 12
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 29
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_168:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_168
L__key_schedule_169:
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	LDS        R18, _temp2+2
	LDS        R19, _temp2+3
	ANDI       R16, 248
	ANDI       R17, 255
	ANDI       R18, 255
	ANDI       R19, 255
	LDI        R27, 3
L__key_schedule_170:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_170
L__key_schedule_171:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,130 :: 		temp1 = (Key[0]&0xff000000)>>24;
	MOVW       R10, R28
	MOVW       R30, R10
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 255
	MOV        R22, R19
	LDI        R23, 0
	MOV        R24, R23
	MOV        R25, R23
	STS        _temp1+0, R22
	STS        _temp1+1, R23
	STS        _temp1+2, R24
	STS        _temp1+3, R25
;PRESENT-128.c,131 :: 		temp2 = sbox[temp1&0xf];
	MOVW       R18, R22
	MOVW       R20, R24
	ANDI       R18, 15
	ANDI       R19, 0
	ANDI       R20, 0
	ANDI       R21, 0
	LDI        R16, #lo_addr(_sbox+0)
	LDI        R17, hi_addr(_sbox+0)
	MOVW       R30, R16
	ADD        R30, R18
	ADC        R31, R19
	LD         R16, Z
	STS        _temp2+0, R16
	LDI        R27, 0
	STS        _temp2+1, R27
	STS        _temp2+2, R27
	STS        _temp2+3, R27
;PRESENT-128.c,132 :: 		temp1 = sbox[(temp1>>4)&0xf];
	LDI        R27, 4
	MOVW       R16, R22
	MOVW       R18, R24
L__key_schedule_172:
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_172
L__key_schedule_173:
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
;PRESENT-128.c,133 :: 		temp1 = (temp1<<4)|temp2;
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	LDI        R27, 4
	MOVW       R20, R16
	MOVW       R22, R18
L__key_schedule_174:
	LSL        R20
	ROL        R21
	ROL        R22
	ROL        R23
	DEC        R27
	BRNE       L__key_schedule_174
L__key_schedule_175:
	LDS        R16, _temp2+0
	LDS        R17, _temp2+1
	LDS        R18, _temp2+2
	LDS        R19, _temp2+3
	MOVW       R6, R20
	MOVW       R8, R22
	OR         R6, R16
	OR         R7, R17
	OR         R8, R18
	OR         R9, R19
	STS        _temp1+0, R6
	STS        _temp1+1, R7
	STS        _temp1+2, R8
	STS        _temp1+3, R9
;PRESENT-128.c,134 :: 		Key[0] = (Key[0]&0x00ffffff)|(temp1<<24);
	MOVW       R30, R10
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 255
	ANDI       R21, 255
	ANDI       R22, 255
	ANDI       R23, 0
	MOV        R19, R6
	CLR        R16
	CLR        R17
	CLR        R18
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R10
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,136 :: 		temp1 = ((Key[1]&0x7)<<2)|((Key[2]&0xc0000000)>>30);
	MOVW       R10, R28
	MOVW       R30, R10
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 7
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
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
	MOVW       R30, R10
	ADIW       R30, 8
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	ANDI       R16, 0
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 192
	LDI        R27, 30
L__key_schedule_176:
	LSR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	DEC        R27
	BRNE       L__key_schedule_176
L__key_schedule_177:
	OR         R20, R16
	OR         R21, R17
	OR         R22, R18
	OR         R23, R19
	STS        _temp1+0, R20
	STS        _temp1+1, R21
	STS        _temp1+2, R22
	STS        _temp1+3, R23
;PRESENT-128.c,137 :: 		temp1 = temp1 ^ (i&0x1f);
	LDS        R16, _i+0
	ANDI       R16, 31
	MOVW       R6, R20
	MOVW       R8, R22
	EOR        R6, R16
	LDI        R27, 0
	EOR        R7, R27
	EOR        R8, R27
	EOR        R9, R27
	STS        _temp1+0, R6
	STS        _temp1+1, R7
	STS        _temp1+2, R8
	STS        _temp1+3, R9
;PRESENT-128.c,138 :: 		Key[1] = (Key[1]&0xfffffff8)|((temp1&0x1c)>>2);
	MOVW       R24, R10
	ADIW       R24, 4
	MOVW       R30, R10
	ADIW       R30, 4
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R20, R16
	MOVW       R22, R18
	ANDI       R20, 248
	ANDI       R21, 255
	ANDI       R22, 255
	ANDI       R23, 255
	MOVW       R16, R6
	MOVW       R18, R8
	ANDI       R16, 28
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	ASR        R19
	ROR        R18
	ROR        R17
	ROR        R16
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,139 :: 		Key[2] = (Key[2]&0x3fffffff)|((temp1&0x03)<<30);
	MOVW       R16, R28
	MOVW       R24, R16
	ADIW       R24, 8
	MOVW       R30, R16
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
	ANDI       R23, 63
	LDS        R16, _temp1+0
	LDS        R17, _temp1+1
	LDS        R18, _temp1+2
	LDS        R19, _temp1+3
	ANDI       R16, 3
	ANDI       R17, 0
	ANDI       R18, 0
	ANDI       R19, 0
	LDI        R27, 30
L__key_schedule_178:
	LSL        R16
	ROL        R17
	ROL        R18
	ROL        R19
	DEC        R27
	BRNE       L__key_schedule_178
L__key_schedule_179:
	OR         R16, R20
	OR         R17, R21
	OR         R18, R22
	OR         R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,141 :: 		if(j==1)
	LDS        R16, _j+0
	CPI        R16, 1
	BREQ       L__key_schedule_180
	JMP        L_key_schedule_126
L__key_schedule_180:
;PRESENT-128.c,142 :: 		{a[i] = Key[0];}
	LDS        R16, _i+0
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R2
	ADC        R21, R3
	MOVW       R30, R28
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
L_key_schedule_126:
;PRESENT-128.c,143 :: 		if(j==2)
	LDS        R16, _j+0
	CPI        R16, 2
	BREQ       L__key_schedule_181
	JMP        L_key_schedule_127
L__key_schedule_181:
;PRESENT-128.c,144 :: 		{b[i] = Key[1];}
	LDS        R16, _i+0
	LDI        R17, 0
	LSL        R16
	ROL        R17
	LSL        R16
	ROL        R17
	MOVW       R20, R16
	ADD        R20, R4
	ADC        R21, R5
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
L_key_schedule_127:
;PRESENT-128.c,119 :: 		for(i=1;i<32;i++)
	LDS        R16, _i+0
	SUBI       R16, 255
	STS        _i+0, R16
;PRESENT-128.c,145 :: 		}
	JMP        L_key_schedule_123
L_key_schedule_124:
;PRESENT-128.c,109 :: 		for(j=1;j<=2;j++)
	LDS        R16, _j+0
	SUBI       R16, 255
	STS        _j+0, R16
;PRESENT-128.c,146 :: 		}
	JMP        L_key_schedule_118
L_key_schedule_119:
;PRESENT-128.c,147 :: 		}
L_end_key_schedule_1:
	ADIW       R28, 15
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	POP        R29
	POP        R28
	RET
; end of _key_schedule_1

_main:
	LDI        R27, 255
	OUT        SPL+0, R27
	LDI        R27, 0
	OUT        SPL+1, R27
	IN         R28, SPL+0
	IN         R29, SPL+1
	SUBI       R28, 18
	SBCI       R29, 1
	OUT        SPL+0, R28
	OUT        SPL+1, R29
	ADIW       R28, 1

;PRESENT-128.c,152 :: 		int main()
;PRESENT-128.c,154 :: 		long int rk1[32]={0x0}, rk2[32]={0x0}, result[2];
	PUSH       R2
	PUSH       R3
	PUSH       R4
	PUSH       R5
	PUSH       R6
	PUSH       R7
	PUSH       R8
	PUSH       R9
	LDI        R30, #lo_addr(?ICSmain_rk1_L0+0)
	LDI        R31, hi_addr(?ICSmain_rk1_L0+0)
	MOVW       R26, R28
	ADIW       R26, 8
	LDI        R24, 8
	LDI        R25, 1
	CALL       ___CC2DW+0
;PRESENT-128.c,155 :: 		long int pt[2] = {0x01234567, 0x89abcdef};      // hardcoded plaintext
;PRESENT-128.c,162 :: 		key_schedule_1(rk1,rk2);
	MOVW       R18, R28
	SUBI       R18, 120
	SBCI       R19, 255
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 255
	MOVW       R4, R18
	MOVW       R2, R16
	CALL       _key_schedule_1+0
;PRESENT-128.c,165 :: 		for(r=1;r<=31;r++)
; r start address is: 4 (R4)
	LDI        R27, 1
	MOV        R4, R27
	LDI        R27, 0
	MOV        R5, R27
; r end address is: 4 (R4)
L_main28:
; r start address is: 4 (R4)
	LDI        R16, 31
	LDI        R17, 0
	CP         R16, R4
	CPC        R17, R5
	BRGE       L__main83
	JMP        L_main29
L__main83:
;PRESENT-128.c,169 :: 		pt[0] = (pt[0]) ^ (rk1[r-1]);
	MOVW       R24, R28
	SUBI       R24, 248
	SBCI       R25, 254
	MOVW       R30, R24
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R16, R4
	SUBI       R16, 1
	SBCI       R17, 0
	MOVW       R18, R28
	SUBI       R18, 248
	SBCI       R19, 255
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
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,170 :: 		pt[1] = (pt[1]) ^ (rk2[r-1]);
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 254
	MOVW       R24, R16
	ADIW       R24, 4
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R16, R4
	SUBI       R16, 1
	SBCI       R17, 0
	MOVW       R18, R28
	SUBI       R18, 120
	SBCI       R19, 255
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
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,172 :: 		pt[0] = s_box(pt[0]);
	MOVW       R20, R28
	SUBI       R20, 248
	SBCI       R21, 254
	MOVW       R16, R20
	MOVW       R30, R28
	SUBI       R30, 240
	SBCI       R31, 254
	ST         Z+, R16
	ST         Z+, R17
	MOVW       R30, R20
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R5
	PUSH       R4
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _s_box+0
	MOVW       R30, R28
	SUBI       R30, 240
	SBCI       R31, 254
	LD         R20, Z+
	LD         R21, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,173 :: 		pt[1] = s_box(pt[1]);
	MOVW       R18, R28
	SUBI       R18, 248
	SBCI       R19, 254
	MOVW       R16, R18
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R28
	SUBI       R30, 240
	SBCI       R31, 254
	ST         Z+, R16
	ST         Z+, R17
	MOVW       R16, R18
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _s_box+0
	MOVW       R30, R28
	SUBI       R30, 240
	SBCI       R31, 254
	LD         R20, Z+
	LD         R21, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,175 :: 		p_layer(pt[0], pt[1], result);
	MOVW       R2, R28
	MOVW       R24, R28
	SUBI       R24, 248
	SBCI       R25, 254
	MOVW       R16, R24
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R30, R24
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	PUSH       R3
	PUSH       R2
	MOVW       R6, R20
	MOVW       R8, R22
	MOVW       R2, R16
	MOVW       R4, R18
	CALL       _p_layer+0
	IN         R26, SPL+0
	IN         R27, SPL+1
	ADIW       R26, 2
	OUT        SPL+0, R26
	OUT        SPL+1, R27
	POP        R4
	POP        R5
;PRESENT-128.c,178 :: 		pt[0] = result[0];
	MOVW       R20, R28
	SUBI       R20, 248
	SBCI       R21, 254
	MOVW       R16, R28
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,179 :: 		pt[1] = result[1];
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 254
	MOVW       R20, R16
	SUBI       R20, 252
	SBCI       R21, 255
	MOVW       R16, R28
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	MOVW       R30, R20
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,165 :: 		for(r=1;r<=31;r++)
	MOVW       R16, R4
	SUBI       R16, 255
	SBCI       R17, 255
	MOVW       R4, R16
;PRESENT-128.c,195 :: 		}   // end of for loop i i.e. round
; r end address is: 4 (R4)
	JMP        L_main28
L_main29:
;PRESENT-128.c,197 :: 		pt[0] = pt[0]^rk1[31];
	MOVW       R24, R28
	SUBI       R24, 248
	SBCI       R25, 254
	MOVW       R30, R24
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 255
	SUBI       R16, 132
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,198 :: 		pt[1] = pt[1]^rk2[31];
	MOVW       R16, R28
	SUBI       R16, 248
	SBCI       R17, 254
	MOVW       R24, R16
	ADIW       R24, 4
	SUBI       R16, 252
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R20, Z+
	LD         R21, Z+
	LD         R22, Z+
	LD         R23, Z+
	MOVW       R16, R28
	SUBI       R16, 120
	SBCI       R17, 255
	SUBI       R16, 132
	SBCI       R17, 255
	MOVW       R30, R16
	LD         R16, Z+
	LD         R17, Z+
	LD         R18, Z+
	LD         R19, Z+
	EOR        R16, R20
	EOR        R17, R21
	EOR        R18, R22
	EOR        R19, R23
	MOVW       R30, R24
	ST         Z+, R16
	ST         Z+, R17
	ST         Z+, R18
	ST         Z+, R19
;PRESENT-128.c,220 :: 		}
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
