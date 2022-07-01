/*

This code domonstrates the Lightweight block cipher PRESENT with 128 bit key scheduling

Test vector : Plaintext = 0x00000000 0x00000000 and key = 0x00000000 0x00000000 0x00000000 0x00000000
              Ciphertext = 0x96db702a 0x2e6900af

Programing Author: Swapnil Ashok Sutar
Date : 27/03/2019

*/
#include<stdio.h>
// LCD module connections
/*sbit LCD_RS at PORTD2_bit;
sbit LCD_EN at PORTD3_bit;
sbit LCD_D4 at PORTD4_bit;
sbit LCD_D5 at PORTD5_bit;
sbit LCD_D6 at PORTD6_bit;
sbit LCD_D7 at PORTD7_bit;

sbit LCD_RS_Direction at DDD2_bit;
sbit LCD_EN_Direction at DDD3_bit;
sbit LCD_D4_Direction at DDD4_bit;
sbit LCD_D5_Direction at DDD5_bit;
sbit LCD_D6_Direction at DDD6_bit;
sbit LCD_D7_Direction at DDD7_bit;*/
// End LCD module connections
//******************************************global variables**********************************************************
long int  temp1, temp2;
char sbox[16] = {0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2};
char player[64] = {0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,8,
24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63};

char i,j;
/*char ch[5];*/


//=========================================================================================
//      Timer 0 setup to know hardware execution time of ANU
//=========================================================================================
/*void timer_init() //start timer
{
  TIMSK=0b00000001; // enabling the interrupt
  SREG_I_bit = 1;
  TCCR0=0b00000001; // setting the prescaler-1 i.e. no prescalar
}

void timer_stop() //stop timer
{
 TCCR0=0b00000000;
}

int time_count=0;
void interrupt() org IVT_ADDR_TIMER0_OVF // Interrupt Service Routine for to keep tracking timer overflow
{
 time_count++;    // variable storing the number of times timer0 overflows
}*/
//******************************************slayer**********************************************************
long int s_box(long int temp1)
{
 long int a[8];
 temp2=0;
 for(i=0;i<32;i=i+4)
 {
   a[(i*1)/4]= sbox[((temp1>>(i))&0xf)];
   temp2 |= a[(i*1)/4] << i;
 }
 return(temp2);
}

//******************************************player**********************************************************
long int p_layer(long int temp1, long int temp2, long int result[])
{
 long int pbox[64]={0};
 long int pbox_out[64]={0};

 for(i=0;i<32;i++)
 {
  pbox[31-i]=(temp1>>i)&0x1;        //corrosponds to pt[0] msb
 }

 for(i=0;i<32;i++)
 {
  pbox[63-i]=(temp2>>i)&0x1;        //corrosponds to pt[1] msb
 }

for(i=0;i<64;i++)
 {
  pbox_out[player[i]] = pbox[i];
 }

 result[0]=0;
 for(i=0;i<32;i++)
 {
  result[0] |=  pbox_out[31-i]<<i;
 }

 result[1] = 0;
 for(i=0;i<32;i++)
 {
  result[1] |=  pbox_out[63-i]<<i;
 }
}

//******************************************Key layer**********************************************************
long int key_schedule_1(long int a[], long int b[])
{
//__________________
   for(j=1;j<=2;j++)
   {
     long int Key[4]={0x01234567,0x89abcdef,0x01234567,0x89abcdef}; //hard coded 128 bit master key

         if(j==1)
         {a[0] = Key[0];}
         if(j==2)
         {b[0] = Key[1];}


      for(i=1;i<32;i++)
      {
        temp1 = temp2 = 0;
        temp1 = Key[0];
        temp2 = Key[1];

        Key[0]  = ((Key[1]&0X7)<<29)|(((Key[2]&0XFFFFFFF8))>>3) ;
        Key[1]  = ((Key[2]&0X7)<<29) |(((Key[3]&0XFFFFFFF8))>>3);
        Key[2]  = ((Key[3]&0X7)<<29) |(((temp1&0XFFFFFFF8))>>3);
        Key[3]  = ((temp1&0X7)<<29) |(((temp2&0XFFFFFFF8))>>3);    //left circular shift by 61

        temp1 = (Key[0]&0xff000000)>>24;
        temp2 = sbox[temp1&0xf];
        temp1 = sbox[(temp1>>4)&0xf];
        temp1 = (temp1<<4)|temp2;
        Key[0] = (Key[0]&0x00ffffff)|(temp1<<24);

        temp1 = ((Key[1]&0x7)<<2)|((Key[2]&0xc0000000)>>30);
        temp1 = temp1 ^ (i&0x1f);
        Key[1] = (Key[1]&0xfffffff8)|((temp1&0x1c)>>2);
        Key[2] = (Key[2]&0x3fffffff)|((temp1&0x03)<<30);

        if(j==1)
        {a[i] = Key[0];}
        if(j==2)
        {b[i] = Key[1];}
       }
    }
}



//******************************************main function**********************************************************
int main()
{
    long int rk1[32]={0x0}, rk2[32]={0x0}, result[2];
    long int pt[2] = {0x01234567, 0x89abcdef};      // hardcoded plaintext
    int r;
   /*unsigned char t[2];
    Lcd_Init();                        // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);               // Clear display*/
    //Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off*/

   key_schedule_1(rk1,rk2);
   //******************************************data layer**********************************************************

           for(r=1;r<=31;r++)
            {
             /*if (r==1);
             {timer_init();}*/
             pt[0] = (pt[0]) ^ (rk1[r-1]);
             pt[1] = (pt[1]) ^ (rk2[r-1]);

             pt[0] = s_box(pt[0]);
             pt[1] = s_box(pt[1]);

             p_layer(pt[0], pt[1], result);


             pt[0] = result[0];
             pt[1] = result[1];

                                /*********************************/
                                    // LongintTohex(rk[0][i],ch);
                                    // Lcd_out(1,1,ch);
                                /*     LongintTohex(pt[0],ch);
                                        Lcd_out(1,1,ch);
                                     LongintTohex(pt[1],ch);
                                        Lcd_out(1,10,ch);
                                        IntTostr(i,ch);
                                        Lcd_out(2,1,ch);
                                        Delay_ms(100);
                                        Lcd_Cmd(_LCD_CLEAR);
                                /*********************************/
                  /*if (r==1);
                  {timer_stop();}*/
            }   // end of for loop i i.e. round

            pt[0] = pt[0]^rk1[31];
            pt[1] = pt[1]^rk2[31];


                               /*******************************
                                 LongintTohex(pt[0],ch);
                                        Lcd_out(1,1,ch);
                                      LongintTohex(pt[1],ch);
                                        Lcd_out(1,10,ch);

                                       // Delay_ms(1000);
                                       // Lcd_Cmd(_LCD_CLEAR);
                                /*********************************/

                                // printing internal timer values
   /*IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
    Lcd_out(3,1,"Overflows:");
    Lcd_out(3,13,t);             //
    IntToStr(TCNT0,t);
    Lcd_out(4,1,"TCNT0 Value:");
    Lcd_out(4,13,t);

    Delay_ms(100);*/
}