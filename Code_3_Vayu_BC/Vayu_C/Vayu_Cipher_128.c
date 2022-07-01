//=========================================================================
//	Author: Swapnil Sutar
//	Vayu C code for test vector
//	
// 	For given Sbox and pbox : Plaintext = 0123456789abcdef	Key = 0123456789abcdef0123456789abcdef 
//	Ciphertext = e35253ca9995d467
// 	
// 	Sbox and Pbox can be replace with new one available in Bansod paper
//=========================================================================

#include<stdio.h>
#include<stdlib.h>
//============================================================================================
// Input	: msb_bits (32 bits)
// Output	: New substituted value for each nibble in n_nibble
//============================================================================================
unsigned int s_box(unsigned int msb_32, unsigned int *n_nibble)
{
	unsigned char i;
	*n_nibble =0; 
	unsigned char s[16] ={2,9,7,0xE,1,0xC,0xA,0,4,3,8,0xD,0xF,0x6,0x5,0xB};
	for(i=0;i<8;i++)
	{
	 *n_nibble |= s[msb_32 >>(i*4) & 0xf]<<(i*4);
	}
}

//============================================================================================
// Left circular shift by 3
// Input	: msb_bits (32 bits)
// Output	: Left circular shifted value of msb_bits by 3
//============================================================================================
unsigned int lcs_3(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}

//============================================================================================
// Left circular shift by 7
// Input	: msb_bits (32 bits)
// Output	: Left circular shifted value of msb_bits by 7
//============================================================================================
unsigned int lcs_7(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x01ffffff)<<7)|((msb_32&0xfe000000)>>(32-7));
}

//============================================================================================
//	Right Circular Shift by 7
// Input	: msb_bits (32 bits)
// Output	: Right circular shifted value of msb_bits by 7
//============================================================================================
unsigned int rcs_7(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xffffff80)>>7)|((msb_32&0x0000007f)<<(32-7));
}

//============================================================================================
//	Right Circular Shift by 3
// Input	: msb_bits (32 bits)
// Output	: Right circular shifted value of msb_bits by 7
//============================================================================================
unsigned int rcs_3(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
}

//============================================================================================
// 32 bit permutation layer
// Input	: msb_bits (32 bits)
// Output	: Permuted value for each bits in msb_32 bits
//============================================================================================
unsigned int p_box(unsigned int msb_32, unsigned int *p_msb_32)
{
	unsigned int t=0;
	unsigned char i; 
	unsigned char p[32] = {20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,03,07,14,10,6,2,9,13,1,5,12,8,4,0};
	for (i=0;i<32;i++)
	{
		 t |= ((msb_32>>i)&0x1)<<p[i];
	}
	*p_msb_32=t;
}


//=========================================================================
//	Key Scheduling 
// Input	: key_0, key_1, key_2, key_3 (key sequence from MSB to LSB)
// Return	: round_key (lowest i.e. LSB 32 bits k31-k0)  
//=========================================================================
unsigned int key_update(unsigned int *key_0, unsigned int *key_1, unsigned int *key_2, unsigned int *key_3, unsigned int *round_key)
{
	unsigned char s[16] ={0x2,0x9,0x7,0xe,0x1,0xc,0xa,0x0,0x4,0x3,0x8,0xd,0xf,0x6,0x5,0xb};
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
// Input: msb_bits, lsb_bits (both are 64 bit plaintext)
// Output: intermediate_ciphertext
//============================================================================================
unsigned int vayu_round(unsigned int msb_bits, unsigned int lsb_bits, unsigned int rk, unsigned int *out_m, unsigned int *out_l)
{
	unsigned int state=0,trail_1=0,trail_2=0;
	printf("plaintext : %08x%08x\n",msb_bits,lsb_bits);
	
	// f1 function
	s_box(msb_bits, &trail_1);
	printf("\t F1| sbox : %08x\n",trail_1);
	lcs_7(trail_1,&trail_2);
	printf("\t F1| <<<7 : %08x\n",trail_2);
	lcs_3(trail_1,&trail_1);
	printf("\t F1| <<<3 : %08x\n",trail_1);
	lsb_bits = trail_1 ^ trail_2 ^ lsb_bits; 
	printf("\t F1_out ^ lsb : %08x\n",lsb_bits);
	
	//f2 function
	s_box(lsb_bits, &trail_1);
	printf("\t F2| sbox : %08x\n",trail_1);
	rcs_7(trail_1,&trail_2);
	printf("\t F2| >>>7 : %08x\n",trail_2);
	rcs_3(trail_1,&trail_1);
	printf("\t F2| >>>3 : %08x\n",trail_1);
	msb_bits = trail_1 ^ trail_2 ^ msb_bits ^ rk; // add round key 
	printf("\t F2_out ^ msb_bits ^ rk : %08x (rk: %08x)\n",msb_bits,rk);
	
	//bit permutation lsb and msb
	p_box(msb_bits, &trail_1);
	p_box(lsb_bits, &trail_2);
	printf("pbox_msb: %08x\tpbox_lsb: %08x\n",trail_1,trail_2);
	
	//swapping
	lsb_bits = trail_1;
	msb_bits = trail_2;
	printf("swap: %08x %08x\n",msb_bits,lsb_bits);
	
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
	unsigned int msb_bits = 0x01234567, lsb_bits = 0x89abcdef, out_msb,out_lsb;
	unsigned int key[4] = {0x01234567,0x89abcdef,0x01234567,0x89abcdef};
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
		 	vayu_round(out_msb, out_lsb, r_k[i], &out_msb, &out_lsb);
		 	printf("\n");
		 }
}
