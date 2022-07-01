//=================================================================================================
//        SPECK block cipher C code: 64 bit plaintext and 128 bit key scheduling implementation
//        Date: 12 Aug 2021
//        Author: Swapnil Sutar
//        Test Vector: | PT: 2d 43 75 74 74 65 72 3b |
//                     | K : 00 01 02 03 08 09 0a 0b 10 11 12 13 18 19 1a 1b |
//                     | CT:  8b 02 4e 45 48 a5 6f 8c |

//         Test vetor in other words i.e. without byte to word conversion or vice versa
//        Test Vector: | PT: 3b 72 65 74 74 75 43 2d |
//                     | K : 1b 1a 19 18 13 12 11 10 0b 0a 09 08 03 02 01 00 |
//                     | CT:  8c 6f a5 48 45 4e 02 8b |
//        Ph.D. Acharya Nagarjuna University
//=================================================================================================
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
//long int temp1, temp2;
char ch[5]={0}; // 1 byte =8 bit, no. of required bits 64 bit = 8 byte to display on LCD
//char i, j; // repeatative used in many functions

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

//=================================================================================================
// Right Circular Shift by 8
//=================================================================================================
long int rcs_8(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}

//=================================================================================================
// Left Circular Shift by 3
//=================================================================================================
long int lcs_3(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}

//=================================================================================================
// Speck key scheduling for 128 bit input
// Note: Speck follows similar function for both KSA and round function
// i.e. Key_plus_encryption_speck() calls in both KSA and round function
//=================================================================================================
long int Key_plus_encryption_speck(long int x, long int y, long int i, long int *t1, long int *t2)
{

        rcs_8(x,&x);
        x+=y;
        x^=i;
        *t1 = x;
        lcs_3(y,&y);
        y^=x;
        *t2 = y;
        

}
long int key_update(long int *key, long int *round_key)
{
        char i;
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
long int speck_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{
        //printf("\n msb: %08x , lsb: %08x\n", msb_bits, lsb_bits);

        Key_plus_encryption_speck(msb_bits,lsb_bits,rk,out_m,out_l);

}

int main() 
{

 long int Msb_Bits = 0x3b726574, Lsb_Bits = 0x7475432d; // hardcoded plaintext
 long int key[4] = {0x1b1a1918, 0x13121110, 0x0b0a0908, 0x03020100}; // hardcoded key
 long int R_key[27] = {0}; // key register to store all round key sequentially
 int i; // other variable used in main
 unsigned char t[2]; // printing byte of timer on LCD

 Lcd_Init();                        // Initialize LCD
 Lcd_Cmd(_LCD_CLEAR);               // Clear display
 Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off



 // Key function call
 key_update(key,R_key);



 // speck function call
 for(i=0; i<27; i++)
 {
  speck_round(Msb_Bits, Lsb_Bits,R_key[i], &Msb_Bits, &Lsb_Bits);
 }

  
 //printing the final output i.e. ciphertext
    //printing the final output i.e. ciphertext
    LongintTohex(Msb_Bits,ch);
    Lcd_out(1,1,ch);
    LongintTohex(Lsb_Bits,ch);
    Lcd_out(1,10,ch);
    Delay_ms(100);

    // printing internal timer values
    IntToStr(time_count,t);     // final execution time = {time_count x(256 x 1/8MHz)}  + {TCNT0 X 1/8MHz}
    Lcd_out(3,1,"Overflow:");
    Lcd_out(3,13,t);
    IntToStr(TCNT0,t);
    Lcd_out(4,1,"TCNT0 Value:");
    Lcd_out(4,13,t);

    Delay_ms(100);

}