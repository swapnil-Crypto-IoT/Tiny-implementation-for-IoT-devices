//=================================================================================================
//	SPECK block cipher C code: 64 bit plaintext and 128 bit key scheduling implementation
//	Date: 12 Aug 2021
//	Author: Swapnil Sutar
//	Test Vector: | PT: 2d 43 75 74 74 65 72 3b |
//		     | K : 00 01 02 03 08 09 0a 0b 10 11 12 13 18 19 1a 1b |
//		     | CT:  8b 02 4e 45 48 a5 6f 8c |	 

// 	Test vetor in other words i.e. without byte to word conversion or vice versa
//	Test Vector: | PT: 3b 72 65 74 74 75 43 2d |
//		     | K : 1b 1a 19 18 13 12 11 10 0b 0a 09 08 03 02 01 00 |
//		     | CT:  8c 6f a5 48 45 4e 02 8b |
//	Ph.D. Acharya Nagarjuna University
//=================================================================================================

//=================================================================================================
// Header Files
//=================================================================================================
#include<stdio.h>
#include<stdlib.h>

//=================================================================================================
// Right Circular Shift by 8
//=================================================================================================
unsigned int rcs_8(unsigned int msb_32, unsigned int *rcs_msb_32)
{
	*rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}

//=================================================================================================
// Left Circular Shift by 3
//=================================================================================================
unsigned int lcs_3(unsigned int msb_32, unsigned int *lcs_msb_32)
{
	*lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}

//=================================================================================================
// Speck key scheduling for 128 bit input
// Note: Speck follows similar function for both KSA and round function 
// i.e. Key_plus_encryption_speck() calls in both KSA and round function
//=================================================================================================
unsigned int Key_plus_encryption_speck(unsigned int x, unsigned int y, unsigned int i, unsigned int *t1, unsigned int *t2)
{
	rcs_8(x,&x);
	x+=y;
	x^=i;
	*t1 = x;
	lcs_3(y,&y);
	y^=x;
	*t2 = y;
}
unsigned int key_update(unsigned int *key, unsigned int *round_key)
{
	unsigned char i;
	for(i=0; i<27; i+=3)
	{
	 if(i==0)
	 {
	 	round_key[i] = key[3];
	 //printf("\n Round key [%d]: %08x \n",i,round_key[i]);
	 }
	 
	 Key_plus_encryption_speck(key[2],key[3],i,&key[2],&key[3]);
	 round_key[i+1] = key[3];
	 //printf("\n Round key [%d]: %08x \n",i+1,round_key[i+1]);	 
	 
	 Key_plus_encryption_speck(key[1],key[3],i+1,&key[1],&key[3]);
	 round_key[i+2] = key[3];
	 //printf("\n Round key [%d]: %08x \n",i+2,round_key[i+2]);	 
	 
	 Key_plus_encryption_speck(key[0],key[3],i+2,&key[0],&key[3]);
	 round_key[i+3] = key[3];
	 //printf("\n Round key [%d]: %08x \n",i+3,round_key[i+3]);	 	 
	}
	
		
						
}

//=================================================================================================
// Speck round function for 64 bit input
//=================================================================================================
unsigned int speck_round(unsigned int msb_bits, unsigned int lsb_bits, unsigned int rk, unsigned int *out_m, unsigned int *out_l)
{
	//printf("\n msb: %08x , lsb: %08x\n", msb_bits, lsb_bits);
	Key_plus_encryption_speck(msb_bits,lsb_bits,rk,out_m,out_l);
}

//=================================================================================================
// Main function
//=================================================================================================
int main()
{
	unsigned int Msb_Bits = 0x3b726574, Lsb_Bits = 0x7475432d; // hardcoded plaintext
	unsigned int key[4] = {0x1b1a1918, 0x13121110, 0x0b0a0908, 0x03020100}; // hardcoded key
	unsigned int R_key[27] = {0}; // key register to store all round key sequentially  
	unsigned char i; // other variable used in main
	
	// Key function call
	key_update(key,R_key);
	
	// speck function call
	for(i=0; i<27; i++)
	{
		speck_round(Msb_Bits, Lsb_Bits,R_key[i], &Msb_Bits, &Lsb_Bits);
		printf("\n (%08x, %08x)\n",Msb_Bits, Lsb_Bits);
	}
	/*for(i=0; i<27; i++)
	{
		printf("\n Round key [%d]: %08x\n",i,R_key[i]);
	}*/ // printing round keys		
}

