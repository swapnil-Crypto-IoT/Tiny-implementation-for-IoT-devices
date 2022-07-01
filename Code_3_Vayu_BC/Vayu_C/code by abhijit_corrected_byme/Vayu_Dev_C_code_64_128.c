#include<stdio.h>
unsigned char p[32] = {20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,03,07,14,10,6,2,9,13,1,5,12,8,4,0};
unsigned char sbox[16] = {2,9,7,0xE,1,0xC,0xA,0,4,3,8,0xD,0xF,0x6,0x5,0xB};

unsigned long int LCS(unsigned long int msb)
{
	return((((msb&0x01ffffff)<<7)|((msb&0xfe000000)>>(32-7)))^(((msb&0x1fffffff)<<3)|((msb&0xe0000000)>>(32-3))));
}

unsigned long int RCS(unsigned long int lsb)
{
	return((((lsb&0xffffff80)>>7)|((lsb&0x0000007f)<<(32-7)))^(((lsb&0xfffffff8)>>3)|((lsb&0x00000007)<<(32-3))));
}

unsigned long int Sbox(unsigned long int in)
{
	unsigned long int a=0;
	int i;
	
	for(i=0;i<8;i++)
	{
		a |= (sbox[(in>>i*4)&0xf]<<i*4); 
	}
	
	return(a);
}

unsigned long int player(unsigned long int in)
{
	unsigned long int a = 0;
	int i;
	
	for(i=0;i<32;i++)
	{
		a |= ((in>>i)&1)<<p[i];
	 } 
	 return(a);
}

int main()
{
	unsigned long int in[2]={0x01234567,0x89abcdef},b,bn;
	unsigned long long k[2] = {0x123456789abcdef,0x123456789abcdef},temp;
	int r,i,j;
	temp = in[0];
	
	printf("PT = %llx",(temp<<32)|in[1]);
	
	for(r=0;r<31;r++)
	{
		//printf("\t----------- round = %d \n",r);
		b = Sbox(in[0]);
		//printf("\t Sbox: %08lx",b);
		b = LCS(b);
		//printf("\t lcs %08lx",b);
		bn = player(b^in[1]);
		////printf("\t LSB after player : %08lx \n", bn);
		//printf("\t MSB SBOXIN : %08lx \n", b);
		b = Sbox(b^in[1]);
		//printf("\t MSB SBOX-- : %08lx \n", b);
		b = RCS(b);
		//printf("\t MSB RCS : %08lx \n", b);
		in[1] = player(b^in[0]^(k[1]&0xffffffff));
		in[0] = bn;
		//printf("\t MSB with player & key add: %08lx (k: %08llx) \n", in[1],(k[1]&0xffffffff));
		//Left hift - 13
		temp=k[1];
		k[1]= ((temp&0x0007ffffffffffff)<<13)|((k[0]&0xfff8000000000000)>>(64-13));
		k[0]= ((k[0]&0x0007ffffffffffff)<<13)|((temp&0xfff8000000000000)>>(64-13));
		//printf("\n <<<13: %016llx%016llx",k[0],k[1]);
		
		//Sbox	
		j=0;	
		for(i=0; i<2; i++)
		{
			j|=(sbox[(k[1]>>(i*4))&0XF]<<i*4)&0xff;
		}
		k[1] &= (0Xffffffffffffff00);  
		k[1] |= ((j&0xFF));
		
		//printf("\n Sbox K: %016llx%016llx",k[0],k[1]);
		//RC xor	
		temp = (((k[1]&0XF800000000000000)>>(64-5))^(0x1f&r));
		k[1] &= 0X07FFFFFFFFFFFFFF;
		k[1] |= temp<<(64-5); 
		//printf("\n Rci: %016llx",k[1]);
	
	}
	
	temp = in[0];
	printf("\nCT = %llx",(temp<<32|in[1]));
}
