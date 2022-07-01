//=================================================================================================
//	PRESENT block cipher C code: 64 bit plaintext and 128 bit key scheduling implementation
//	Date: 17 Aug 2021
//	Author: Swapnil Sutar
//	Test Vector: | PT: 01 23 45 67 89 AB CD EF |
//		     | K : 01 23 45 67 89 AB CD EF 01 23 45 67 89 AB CD EF|
//		     | CT:  0E 9D 28 68 5E 67 1D D6 |	 
//	Ph.D. Acharya Nagarjuna University
//=================================================================================================

#include<stdio.h>
#include<stdlib.h>

//============================================================================================
// Input	: 64_bits 
// Output	: New substituted value for each nibble in n_nibble
//============================================================================================
unsigned long int s_box(unsigned long int bits_64, unsigned long int *n_nibble)
{
	unsigned int i;
	unsigned long int t=0; 
	unsigned long int s[16] ={0xc,5,6,0xb,9,0,0xa,0xd,3,0xe,0xf,8,4,7,1,2};
	for(i=0;i<16;i++)
	{
	 t |= s[bits_64 >>(i*4) & 0xf]<<(i*4);
	}
	*n_nibble =t;
}

//============================================================================================
// Input	: 64_bits
// Output	: Permuted value for each bits in 64_bits
//============================================================================================
unsigned long int p_box(unsigned long int bits_64, unsigned long int *p_bits_64)
{
	unsigned long long int t=0;
	unsigned int i; 
	unsigned char p[64] = {0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,8,
24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63};
	for (i=0;i<64;i++)
	{
		 t |= ((bits_64>>i)&0x1)<<p[i];
	}
	*p_bits_64=t;
}

//============================================================================================
// Input	: key_0, key_1, key_2, key_3 (key sequence from MSB to LSB)
// Return	: round_key (LSB & MSB [64 bits grouping])  
//============================================================================================
unsigned long int key_update(unsigned long *key_high, unsigned long int *key_low , unsigned long int *subkey)
{
	unsigned long int subkey1[32]={0};
	unsigned long long int temp,m,i;
	unsigned int i1;
	unsigned char s[16] = {0xc,5,6,0xb,9,0,0xa,0xd,3,0xe,0xf,8,4,7,1,2};	

	subkey[0]=*key_high;
	subkey1[0]=*key_low;
	for (i=0;i<31;i++)
	{		
		temp=*key_low;
		*key_low = (temp<<61)|((*key_high)>>(64-61));
		*key_high = ((*key_high)<<61)|(temp>>(64-61)); // 128 bit key left circular shift by 61

		//Sbox	
			m=0;	
			for(i1=0; i1<2; i1++)
			{
				m|=(s[(((*key_high>>56)&0xff)>>(i1*4))&0xf]<<i1*4)&0xff;
			}
			*key_high &= (0X00ffffffffffffff);  
			*key_high |= (((m<<56)&0xff00000000000000));
			*key_low ^= ( ( (i+1) & 0x03 ) << 62 );			
			*key_high ^= (  (i+1)  >> 2);
	 subkey[i+1]=*key_high;
	 subkey1[i+1]=*key_low;
	
	}

	/*for (i=0;i<32;i++)
	{		
	printf("\n the value of subkey at round %02lld is %016lx(H) %016lx(L)\n",i,subkey[i],subkey1[i]);  
	}*/
	
}


//============================================================================================
// Round function
// Parameter
// --------
// Input: 64_bit (both are 64 bit plaintext)
// Output: intermediate_ciphertext
//============================================================================================
unsigned long int present_round(unsigned long int state, unsigned long int rk, unsigned long int i, unsigned long int *updated_state)
{
	if(i<=30)
	{
		state ^=  rk;
		s_box(state,&state);
		p_box(state,&state);
		*updated_state = state;
	}
	
	else // post key whitening
	{	
		state ^=  rk;
		*updated_state = state;
	}
}

//============================================================================================
// main function
// Input	: msb_bits, lsb_bits, key[4]
// Output : Round keys: r_k, Ciphertext
//============================================================================================
int main()
{
 unsigned long int pt_64bits=0x0000000000000000; //64_bit plaintext
 unsigned long int key[2] = {0x0000000000000000,0x0000000000000000}; //128_bit key
 unsigned long int r_k[32]={0};
 unsigned char i;

 key_update(&key[0],&key[1],r_k);
   
 for (i=0; i<=31; i++)
 {
 	present_round(pt_64bits,r_k[i],i,&pt_64bits);

 }
 //	printf("\n \u2767 PT %02d| :%016lx: (Round key applied::%016lx::)\n",i,pt_64bits,r_k[i]);
}
