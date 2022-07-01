//==============================================================================================================
//	Programming Author : Swapnil Sutar
//	Cipher : NUX (128 bit KSA)
//	Test Vector:
//	
//==============================================================================================================


#include<stdio.h>
#include<stdlib.h>
//============================================================================================
// Input	: msb_bits (32 bits)
// Output	: New substituted value for each nibble in n_nibble
//============================================================================================
unsigned int s_box(unsigned int Input_16, unsigned int *n_nibble)
{
	unsigned char i;
	*n_nibble =0; 
	unsigned char s[16] ={0xE,0x7,0x8,0x4,0x1,0x9,0x2,0xF,0x5,0xA,0xB,0x0,0x6,0xC,0xD,0x3};
	for(i=0;i<4;i++)
	{
	 *n_nibble |= s[Input_16 >>(i*4) & 0xf]<<(i*4);
	}
}

//============================================================================================
// Left circular shift by 8
// Input	: msb_bits (32 bits)
// Output	: Left circular shifted value of msb_bits by 8
//============================================================================================
unsigned int lcs_8(unsigned int Input_16, unsigned int *lcs_Input_16)
{
	*lcs_Input_16 = ((Input_16&0x00ff)<<8)|((Input_16&0xff00)>>(16-8));
}

//============================================================================================
//	Right Circular Shift by 3
// Input	: msb_bits (32 bits)
// Output	: Right circular shifted value of msb_bits by 3
//============================================================================================
unsigned int rcs_3(unsigned int Input_16, unsigned int *rcs_Input_16)
{
	*rcs_Input_16 = ((Input_16&0xfff8)>>3)|((Input_16&0x0007)<<(16-3));
}

//============================================================================================
// 16 bit permutation layer
// Input	: bits (16 bits)
// Output	: Permuted value for each bits in bits
//============================================================================================
unsigned int p_box(unsigned int Input_16, unsigned int *p_Input_16)
{
	unsigned int t=0;
	unsigned char i; 
	unsigned char p[16] = {15,11,7,3,2,14,10,6,5,1,13,9,8,4,0,12};
	for (i=0;i<16;i++)
	{
		 t |= ((Input_16>>i)&0x1)<<p[i];
	}
	*p_Input_16=t;
}

//=========================================================================
// Key Scheduling 
// Input	: key_0, key_1, key_2, key_3 (key sequence from MSB to LSB)
// Return	: round_key (lowest i.e. LSB 32 bits k31-k0)  
//=========================================================================
unsigned int key_update(unsigned int *key_0, unsigned int *key_1, unsigned int *key_2, unsigned int *key_3, unsigned int *round_key)
{
	unsigned char s[16] ={0xE,0x7,0x8,0x4,0x1,0x9,0x2,0xF,0x5,0xA,0xB,0x0,0x6,0xC,0xD,0x3};
	unsigned char i,sub;
	unsigned int tmp=0;
	round_key[0] = *key_3; //shift k31-k0 in round key r_k[0]
	//printf("%08x\n",round_key[0]);
	
	for (i=0;i<31;i++)
	{
	printf("------------i %d \n",i);
	printf("1. before_ LCS13: %08x%08x%08x%08x\n",*key_0,*key_1,*key_2,*key_3);
	// LCS BY 13 [k127-k0]
	tmp = (*key_0);
	*key_0 = (tmp&0x0007ffff)<<13 | ((*key_1&0xfff80000)>>(32-13));
	*key_1 = (*key_1&0x0007ffff)<<13 | ((*key_2&0xfff80000)>>(32-13));
	*key_2 = (*key_2&0x0007ffff)<<13 | ((*key_3&0xfff80000)>>(32-13));
	*key_3 = (*key_3&0x0007ffff)<<13 | ((tmp&0xfff80000)>>(32-13));
	printf("2. LCS13: %08x%08x%08x%08x\n",*key_0,*key_1,*key_2,*key_3);
	
	// SUB-BYTE [k7-k4][k3-k0]
	tmp = (*key_3 & 0xff);
	tmp = (s[tmp&0xf]|(s[tmp>>4&0x0f])<<4);
	*key_3 = (*key_3 & 0xffffff00) | tmp;
	printf("3. subyte: %08x\n",*key_3);
		
	// RCi xor [k63-k59]
	*key_2 ^=  (((i)&0x1f)<<(32-5));
	printf("6. xorcount= %08x\n",(((i))<<(32-5)));
	//*key_2 |= tmp;
	printf("5. RCi: %08x\n",*key_2);
	
	// return round key
	round_key[i+1] = *key_3;
	printf("6. return_key: %08x%08x%08x%08x\n\n",*key_0,*key_1,*key_2,*key_3);
	}
}
//============================================================================================
// Round function
// Parameter
// --------
// Input: msb_1, msb_2, lsb_3, lsb_4 (generalized feistel p1, p2, p3, p4)
// Output: *out_m, *out_l (round ciphertext)
//============================================================================================
unsigned int nux_round(unsigned int msb_bits, unsigned int lsb_bits, unsigned int rk, unsigned int *out_m, unsigned int *out_l)
{

	unsigned int state=0, tmp_state=0, msb_1=0, msb_2=0, lsb_3=0, lsb_4=0;
	printf("plaintext : %08x%08x\n", msb_bits, lsb_bits);
	
	// seperating 32 bit groups into 16 bits group
	msb_1  = ((msb_bits & 0xffff0000)>>16);
	printf("\n msb_1: %04x\n",msb_1);
	msb_2 = (msb_bits & 0xffff);
	printf("\n msb_2: %04x\n",msb_2);
	lsb_3  = ((lsb_bits & 0xffff0000)>>16);
	printf("\n lsb_3: %04x\n",lsb_3);
	lsb_4 = (lsb_bits & 0xffff);
	printf("\n lsb_4: %04x\n",lsb_4);
	
	rcs_3(msb_2,&state);
	printf("\n rcs_3(msb_2): %04x\n",state);
	s_box(state,&state);
	printf("\n sbox[rcs_3(msb_2)]: %04x\n",state);
	lcs_8(msb_1,&tmp_state);
	printf("\n lcs_8(msb_1): %04x\n",tmp_state);
	
	printf("\n key: %08x\n",rk);  
	state = state ^ tmp_state ^ ((rk&0xffff0000)>>16);
	printf("\n pbox input (state) : %04x\n",state);
	p_box(state, &state);
	printf("\n pbox(state): %04x\n", state);
	
	p_box(msb_2,&tmp_state);
	lsb_bits = (state<<16) | tmp_state; // swapping 1
	printf("\n out_l_34: %08x\n", lsb_bits);
	
	lcs_8(lsb_3,&state);
	printf("\n lcs_8(lsb_3): %04x\n",state);
	s_box(state,&state);
	printf("\n sbox[lcs_8(lsb_3)]: %04x\n",state);
	rcs_3(lsb_4,&tmp_state);
	printf("\n rcs_3(lsb_4): %04x\n",tmp_state);
	
	state = state ^ tmp_state ^ ((rk&0xffff));
	printf("\n Pbox input (state): %04x \n",state);
	p_box(state,&state);
	printf("\n pbox(state): %04x\n", state);
	
	p_box(lsb_3, &tmp_state);
	msb_bits = (tmp_state<<16) | state; // swapping 2
	printf("\n out_m_12: %08x\n", msb_bits);
	
	//joining 64 bits = msb_bits + lsb_bits
	 *out_m =0;
	 *out_l =0;
	 *out_m = msb_bits;
	 *out_l = lsb_bits;
	 printf("round_cipher: %08x%08x\n",*out_m,*out_l);
}
//=========================================================================
//	main function
//=========================================================================
int main()
{
	unsigned int msb_bits = 0, lsb_bits = 0, out_msb,out_lsb;
	unsigned int key[4] = {0,0,0,0};
	unsigned int r_k[31]={0};
	unsigned char i;
	
	// Key scheduling call
	key_update(&key[0],&key[1],&key[2],&key[3],r_k);
	
	// round function implementation
	out_msb = msb_bits;
 	out_lsb = lsb_bits;
 		for(i=0;i<31;i++)
		 {
		 	printf("------------i %d \n",i);
		 	nux_round(out_msb, out_lsb, r_k[i], &out_msb, &out_lsb);
		 	printf("\n");
		 }
}

