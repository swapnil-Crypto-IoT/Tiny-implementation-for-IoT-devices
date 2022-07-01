/*

This code domonstrates the Lightweight block cipher SIMON with 128 bit key scheduling & 64 bit plaintext

Test vector: | PT: 75 6E 64 20 6C 69 6B 65 |
             | K : 00 01 02 03 04 05 06 07 08 09 0A 0B 10 11 12 13 18 19 1A 1B |
             | CT:  7A A0 DF B9 20 FC C8 44 |

Test vetor in other words i.e. without byte to word conversion or vice versa
Test Vector: | PT: 65 6b 69 6c 20 64 6e 75|
             | K : 03 02 01 00 0b 0a 09 08 13 12 11 10 1b 1a 19 18|
             | CT:  44 c8 fc 20 b9 df a0 7a|

Programing Author: Swapnil Ashok Sutar
Date : 11 AUG 2021

*/
#include<stdio.h>
// LCD module connections
sbit LCD_RS at PORTD2_bit;
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
sbit LCD_D7_Direction at DDD7_bit;
// End LCD module connections

//=========================================================================================
//      Global Variable Declaration
//=========================================================================================
long int temp1, temp2;
char ch[5]; // 1 byte =8 bit, no. of required bits 64 bit = 8 byte to display on LCD
char i, j; // repeatative used in many functions

//=========================================================================================
//      Timer 0 setup to know hardware execution time of SIMON
//=========================================================================================
void timer_init() //start timer
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
}

//=============================================================================
// Input        : msb_bits (32 bits)
// Output        : Right circular shifted value of msb_bits by 3,4,1
//=============================================================================
long int rcs_3(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
long int rcs_4(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xfffffff0)>>4)|((msb_32&0x0000000f)<<(32-4));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
long int rcs_1(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xfffffffe)>>1)|((msb_32&0x00000001)<<(32-1));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
long int rcs_8(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Left circular shifted value of msb_bits by 1,2
//============================================================================================
long int lcs_1(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x7fffffff)<<1)|((msb_32&0x80000000)>>(32-1));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
long int lcs_2(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x3fffffff)<<2)|((msb_32&0xc0000000)>>(32-2));
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
long int lcs_8(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x00ffffff)<<8)|((msb_32&0xff000000)>>(32-8));
}

//=========================================================================================
//      128- Bit key scheduling SIMON
//=========================================================================================
long int Key_Schedule(long int *R_k)
{
 long int Key[4]={0x03020100, 0x0b0a0908, 0x13121110, 0x1b1a1918}, z_m_32 = 0xfc2ce512, z_l_32 = 0x07a635db; // Hard coded key
 long int c = 0xfffffffc, tmp_state[3]={0};
 R_k[0] = Key[0]; //k[3] as per sequence in document
 R_k[1] = Key[1]; //k[2]
 R_k[2] = Key[2]; //k[1]
 R_k[3] = Key[3]; //k[0]

 for (i=4; i<44; i++)
 {
  rcs_3(R_k[i-1],&tmp_state[0]);
  rcs_4(R_k[i-1],&tmp_state[1]);
  rcs_1(R_k[i-3],&tmp_state[2]);
  if((i-4)<=31)
  {
   R_k[i] = c ^ ((z_l_32>>(i-4))&1) ^ R_k[i-4] ^ tmp_state[0] ^ R_k[i-3] ^ tmp_state[1] ^ tmp_state[2];
  }
  else
  {
   R_k[i] = c ^ ((z_m_32>>((i-4)-32))&1) ^ R_k[i-4] ^ tmp_state[0] ^ R_k[i-3] ^ tmp_state[1] ^ tmp_state[2];
  }
 }
}

//=========================================================================================
//      SIMON ROUND FUNCTION
//=========================================================================================
long int simon_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{
 long int state=0,trail_1=0,trail_2=0;
 timer_init();
 lcs_1(msb_bits,&trail_1);
 lcs_8(msb_bits,&trail_2);
 state = trail_1 & trail_2;

 lcs_2(msb_bits,&trail_1);

 trail_2 = state ^ trail_1 ^ lsb_bits ^ rk;


 //swap
 lsb_bits = msb_bits;
 msb_bits = trail_2;

 //joining 64 bits = msb_bits + lsb_bits
 //*out_m =0;
 //*out_l =0;
 *out_m = msb_bits;
 *out_l = lsb_bits;
 timer_stop();
}

//=========================================================================================
//      Main (Engine)
//=========================================================================================
int main()
{
 long int R_k[44]= {0}, Msb_Out = 0, Lsb_Out=0;
 long int P_t[2]={0x656b696c,0x20646e75} ;// Plaintext register (hardcoded)
 char i;
 unsigned char t[2];

 Lcd_Init();                        // Initialize LCD
 Lcd_Cmd(_LCD_CLEAR);               // Clear display
 Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off


 // SIMON KSA calling function
 Key_Schedule(R_k);           // key scheduling function call to store all the key

 // SIMON Round function calling
 Msb_out = P_t[0];
 Lsb_out = P_t[1];
 for(i=0;i<44;i++)
 {
  simon_round(Msb_out, Lsb_out, R_k[i], &Msb_out, &Lsb_out);
 }

 //printing the final output i.e. ciphertext
    LongintTohex(Msb_out,ch);
    Lcd_out(1,1,ch);
    LongintTohex(Lsb_out,ch);
    Lcd_out(1,10,ch);
    Delay_ms(100);

    // printing internal timer values
    IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
    Lcd_out(3,1,"Overflows:");
    Lcd_out(3,13,t);             //
    IntToStr(TCNT0,t);
    Lcd_out(4,1,"TCNT0 Value:");
    Lcd_out(4,13,t);

    Delay_ms(100);


}