#include<stdio.h>
//#include<conio.h>

unsigned int left_8(unsigned int);
unsigned int s_right_3(unsigned int);
unsigned int left_8_s(unsigned int);
unsigned int right_3(unsigned int);
unsigned int player(unsigned  int);

unsigned int s[16] = {0XE,7,8,4,1,9,2,0XF,5,0XA,0XB,0,6,0XC,0XD,3};
unsigned int p[16] = {15,11,7,3,2,14,10,6,5,1,13,9,8,4,0,12};

int main()
{
	unsigned int in1[4]={0x0,0x0,0x0,0x0},in[2]={0},r,i,j,tmp; 
	unsigned long long int k[2]={0x0,0x0},temp,m;
	
	for(r=0;r<31;r++)
 	{
 		in[1] = (right_3(in1[3])) ^ (left_8_s(in1[2])) ^ ((k[1]&0xffff));
 		printf("\nall xor lsb state: %04x\n",in[1]);
		in[0] = (left_8(in1[0])) ^ (s_right_3(in1[1])) ^ ((k[1]&0xffff0000)>>16);
		printf("\nall xor msb state: %04x\n",in[0]);
	
		in1[0] = player(in1[2]);
		printf("\nmsb_1: %04x\n",in1[0]);
		in1[2] = player(in[0]);
		printf("\nlsb_3: %04x\n",in1[2]);
		in1[3] = player(in1[1]);
		printf("\nlsb_4: %04x\n",in1[3]);
		in1[1] = player(in[1]);		
		printf("\nmsb_2: %04x\n",in1[1]);
		printf("\n key: %08llx\n",k[1]);    	
        // key scheduling______
		
		//Left shift - 13
		//Left hift - 13
		temp=k[1];
		k[1]= ((temp&0x0007ffffffffffff)<<13)|((k[0]&0xfff8000000000000)>>(64-13));
		k[0]= ((k[0]&0x0007ffffffffffff)<<13)|((temp&0xfff8000000000000)>>(64-13));
		
		//Sbox	
		m=0;	
		for(i=0; i<2; i++)
		{
			m|=(s[(k[1]>>(i*4))&0XF]<<i*4)&0xff;
		}
		k[1] &= (0Xffffffffffffff00);  
		k[1] |= (m&0xFF);
		
		//RC xor	
		temp = (((k[1]&0XF800000000000000)>>(64-5))^(0x1f&r));
		k[1] &= 0X07FFFFFFFFFFFFFF;
		k[1] |= temp<<(64-5);
		
		printf("\n %x %x %x %x \n",in1[0],in1[1],in1[2],in1[3]);
		printf("\n======================= round (%d)",r);
				
	}	printf("\n %x %x %x %x \n",in1[0],in1[1],in1[2],in1[3]);
	
	
}

unsigned int left_8(unsigned int a)
{
	a = ((((a&0x00ff)<<8)|((a&0xff00)>>(16-8)))&0xffff);
	return(a);
}

unsigned int s_right_3(unsigned int a)
{
	unsigned int i,d,j[17];
	unsigned int b=0;
	//a=0;
   	a = ((((a&0xfff8)>>3)|((a&0x0007)<<(16-3)))&0xffff);
	
	printf("\n rcs_3(a): %04x\n",a);
	for(i=0;i<4;i++)
	{
		b |= (s[(a>>i*4)&0xf]<<i*4); 
	}
	
	printf("\n s[rcs_3(a)]: %04x\n",b);
	return(b);
}

unsigned int left_8_s(unsigned int a)
{
	unsigned int i,d,j[17];
	unsigned int b=0;
   //	a=0;
	a = ((((a&0x00ff)<<8)|((a&0xff00)>>(16-8)))&0xffff);
	printf("\n lcs_8 (a): %04x\n",a);
	for(i=0;i<4;i++)
	{
		b |= (s[(a>>i*4)&0xf]<<i*4); 
	}
	
	printf("\n s[lcs_8(a)]: %04x\n", b);
	return(b);
}

unsigned int right_3(unsigned int a)
{
	a = ((((a&0xfff8)>>3)|((a&0x0007)<<(16-3)))&0xffff);
	return(a);
}

unsigned int player(unsigned int a)
 {
 
	 unsigned int b;
	unsigned int i;
 	 b=0;
    for (i=0;i<16;i++)
     {
		 b |= ((a>>i)&0x1)<<p[i];
		}
		
	 	 return(b);
 }

