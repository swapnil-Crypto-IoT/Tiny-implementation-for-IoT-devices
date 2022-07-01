//=================================================================================================
//	SIMON block cipher C code: 64 bit plaintext and 128 bit key scheduling implementation
//	Date: 9 Aug 2021
//	Author: Swapnil Sutar
//	Test Vector: | PT: 75 6E 64 20 6C 69 6B 65 |
//		     | K : 00 01 02 03 04 05 06 07 08 09 0A 0B 10 11 12 13 18 19 1A 1B |
//		     | CT:  7A A0 DF B9 20 FC C8 44 |	 

// 	Test vetor in other words i.e. without byte to word conversion or vice versa
//	Test Vector: | PT: 65 6b 69 6c 20 64 6e 75|
//		     | K : 03 02 01 00 0b 0a 09 08 13 12 11 10 1b 1a 19 18|
//		     | CT:  44 c8 fc 20 b9 df a0 7a|
//	Ph.D. Acharya Nagarjuna University
//=================================================================================================

//=================================================================================================
// Header Files
//=================================================================================================
#include<stdio.h>
#include<stdlib.h>

//=============================================================================
// Input	: msb_bits (32 bits)
// Output	: Right circular shifted value of msb_bits by 3,4,1
//=============================================================================
unsigned int rcs_3(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
unsigned int rcs_4(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xfffffff0)>>4)|((msb_32&0x0000000f)<<(32-4));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
unsigned int rcs_1(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xfffffffe)>>1)|((msb_32&0x00000001)<<(32-1));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
unsigned int rcs_8(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}

//============================================================================================
// Input	: msb_bits (32 bits)
// Output	: Left circular shifted value of msb_bits by 1,2
//============================================================================================
unsigned int lcs_1(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x7fffffff)<<1)|((msb_32&0x80000000)>>(32-1));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
unsigned int lcs_2(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x3fffffff)<<2)|((msb_32&0xc0000000)>>(32-2));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
unsigned int lcs_8(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x00ffffff)<<8)|((msb_32&0xff000000)>>(32-8));
}

//=================================================================================================
// Key Schedule
//=================================================================================================
unsigned int key_update(unsigned int *key_0, unsigned int *key_1, unsigned int *key_2, unsigned int *key_3, unsigned int *round_key)
{
 unsigned int i, c = 0xfffffffc, tmp_state[3]={0};	//unsigned int 32 bits unsinged long int 64 bit
 unsigned long int z = 0xfc2ce51207a635db; // c and z are fixed constant as per design of SIMON in initial phase
 
 round_key[0] = *key_0; //k[3] as per sequence in document
 round_key[1] = *key_1; //k[2]
 round_key[2] = *key_2; //k[1]
 round_key[3] = *key_3; //k[0]  
 
 for (i=0; i<04; i++)
 {
  printf("\n round key rk[%d]: %08x \n", i, round_key[i]);
 }
 for (i=4; i<44; i++)
 {
  rcs_3(round_key[i-1],&tmp_state[0]);
  rcs_4(round_key[i-1],&tmp_state[1]);
  rcs_1(round_key[i-3],&tmp_state[2]);
  round_key[i] = c ^ ((z>>(i-4))&1) ^ round_key[i-4] ^ tmp_state[0] ^ round_key[i-3] ^ tmp_state[1] ^ tmp_state[2];
  
  printf("\n round key rk[%d]: %08x \n", i, round_key[i]);
 }
}

//=================================================================================================
// Simon Round function
//=================================================================================================
unsigned int simon_round(unsigned int msb_bits, unsigned int lsb_bits, unsigned int rk, unsigned int *out_m, unsigned int *out_l)
{
 unsigned int state=0,trail_1=0,trail_2=0;
 printf("msb: %08x \t lsb: %08x", msb_bits,lsb_bits);
 lcs_1(msb_bits,&trail_1);
 lcs_8(msb_bits,&trail_2);
 state = trail_1 & trail_2;
 
 lcs_2(msb_bits,&trail_1);
 
 trail_2 = state ^ trail_1 ^ lsb_bits ^ rk;
 
 //state = trail_2 ^ rk ^ lsb_bits;
 //printf("\nstate: %x\n",state);
 //swap
 lsb_bits = msb_bits;
 msb_bits = trail_2; 
 
 //joining 64 bits = msb_bits + lsb_bits
 //*out_m =0;
 //*out_l =0;
 *out_m = msb_bits;
 *out_l = lsb_bits;
 printf("\nround key: %08x\n",rk);
 printf("round_cipher: %08x, %08x\n",*out_m,*out_l);
 printf("\n ================ \n");
}

//=============================================================================
// main
//=============================================================================
int main()
{
 // msb_bits = Pt[1], lsb_bits = Pt[0] =  75 6E 64 20 6C 69 6B 65
 // key[4] = k[3], k[2], k[1], k[0]
 unsigned int msb_bits = 0x656b696c, lsb_bits = 0x20646e75 /* equivalent to {75 6e 64 20 6c 69 6b 65}*/, out_msb,out_lsb, tmp_state; 
 unsigned int key[4] = {0x03020100, 0x0b0a0908, 0x13121110, 0x1b1a1918}; // equivalent to {00 01 02 03 04 05 06 07 08 09 0a 0b 10 11 12 13 18 19 1a 1b};
 unsigned int r_k[44]={0};
 unsigned char i;
 key_update(&key[0],&key[1],&key[2],&key[3],r_k);
 
 out_msb = msb_bits;
 out_lsb = lsb_bits;
 for(i=0;i<44;i++)
 {
 	printf("------------i %d \n",i);
 	simon_round(out_msb, out_lsb, r_k[i], &out_msb, &out_lsb);
 	
 }
 
 printf("\n final: == :%08x, %08x\n",out_msb,out_lsb);
}
