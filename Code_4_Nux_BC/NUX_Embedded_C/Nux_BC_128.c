/*

This code domonstrates the Lightweight block cipher NUX with 128 bit key scheduling

Test vector : Plaintext = 0x00000000 0x00000000 and key = 0x00000000 0x00000000 0x00000000 0x00000000
              Ciphertext = 0xf73d6c7f 0x8e201493

Programing Author: Swapnil Ashok Sutar
Date : 23/07/2021

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
char sbox[16] = {0xE,0x7,0x8,0x4,0x1,0x9,0x2,0xF,0x5,0xA,0xB,0x0,0x6,0xC,0xD,0x3};   // SBOX NUX
char p[32] = {15,11,7,3,2,14,10,6,5,1,13,9,8,4,0,12}; // P-layer NUX

//=========================================================================================
//      Timer 0 setup to know hardware execution time of NUX
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

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Left circular shifted value of msb_bits by 3
//============================================================================================
long int lcs_3(long int Input_16, long int *lcs_Input_16)
{
        *lcs_Input_16 = ((Input_16&0x1fffffff)<<3)|((Input_16&0xe0000000)>>(32-3));
}

//============================================================================================
// Left circular shift by 8
// Input        : msb_bits (16 bits)
// Output        : Left circular shifted value of msb_bits by 8
//============================================================================================
long int lcs_8(long int Input_16, long int *lcs_Input_16)
{
        *lcs_Input_16 = ((Input_16&0x00ff)<<8)|((Input_16&0xff00)>>(16-8));
}

//============================================================================================
//        Right Circular Shift by 7
// Input        : msb_bits (32 bits)
// Output        : Right circular shifted value of msb_bits by 7
//============================================================================================
long int rcs_3(long int Input_16, long int *rcs_Input_16)
{
        *rcs_Input_16 = ((Input_16&0xfff8)>>3)|((Input_16&0x0007)<<(16-3));
}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : New substituted value for each nibble in n_nibble
//============================================================================================
long int s_box(long int Input_16, long long int *n_nibble)
{
     long int a[4];
     *n_nibble=0;
     for(i=0;i<16;i=i+4)
     {
       a[(i*1)/4]= sbox[((Input_16>>(i))&0xf)];
       *n_nibble |= a[(i*1)/4] << i;
     }
}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Permuted value for each bits in Input_16 bits
//============================================================================================
long int p_box(long int Input_16, long int *p_Input_16)
{
        long int t=0;
        for (i=0;i<16;i++)
        {
                 t |= ((Input_16>>i)&0x1)<<p[i];
        }
        *p_Input_16=t;
}

//============================================================================================
//       NUX Key Scheduling
//============================================================================================
long int key_schedule_1(long int *rk)
{
     long int Key[4]={0x0,0x0,0x0,0x0}; //hard coded 128 bit master key

        // if(j==1)
         {rk[0] = Key[3];}
         //if(j==2)
         //{b[0] = Key[1];}
      for(i=0;i<31;i++)
      {
        temp1 = temp2 = 0;
        temp1 = Key[0];
        //temp2 = Key[1];

        // Circular left shift by 13
        Key[0]  = ((temp1&0x0007ffff)<<13) |((Key[1]&0xfff80000)>>(32-13)) ;
        Key[1]  = ((Key[1]&0X0007ffff)<<13) |(((Key[2]&0xfff80000)>>(32-13)));
        Key[2]  = ((Key[2]&0x0007ffff)<<13) |(((Key[3]&0Xfff80000))>>(32-13));
        Key[3]  = ((Key[3]&0X0007ffff)<<13) |(((temp1&0Xfff80000))>>(32-13));    //left circular shift by 13

        // sub-byte
        temp1 = sbox[Key[3]&0xf] ;
        temp2 = sbox[((Key[3])>>4)&0xf];
        temp1 = ((temp2&0xf)<<4)| temp1 ;
        Key[3] = (Key[3]&0xffffff00)|(temp1); // SBOX[K7,K6,K5,K4] and SBOX[K3,K2,K1,K0]

        // RCi xor [k63-k59]
        temp1 = (key[2] & 0xf8000000) >> (32-5);
        temp1 = temp1 ^ ((i)&0x1f);
        key[2]=  (key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5))  ;

        {rk[i+1] = Key[3];}
        }

} // KSA end

//============================================================================================
//       NUX round function
//============================================================================================
long int nux_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{

        long int state=0, tmp_state=0, msb_1=0, msb_2=0, lsb_3=0, lsb_4=0;
        //printf("plaintext : %08x%08x\n", msb_bits, lsb_bits);

 // initialize and start timer
 timer_init();

        // seperating 32 bit groups into 16 bits group
        msb_1  = ((msb_bits & 0xffff0000)>>16);
        msb_2 = (msb_bits & 0xffff);
        lsb_3  = ((lsb_bits & 0xffff0000)>>16);
        lsb_4 = (lsb_bits & 0xffff);


        rcs_3(msb_2,&state);
        s_box(state,&state);
        lcs_8(msb_1,&tmp_state);


        state = state ^ tmp_state ^ ((rk&0xffff0000)>>16);
        p_box(state, &state);
        p_box(msb_2,&tmp_state);
        lsb_bits = (state<<16) | tmp_state; // swapping 1


        lcs_8(lsb_3,&state);

        s_box(state,&state);

        rcs_3(lsb_4,&tmp_state);


        state = state ^ tmp_state ^ ((rk&0xffff));

        p_box(state,&state);


        p_box(lsb_3, &tmp_state);
        msb_bits = (tmp_state<<16) | state; // swapping 2


        //joining 64 bits = msb_bits + lsb_bits
         *out_m =0;
         *out_l =0;
         *out_m = msb_bits;
         *out_l = lsb_bits;

// stop the timer after ending all rounds
    timer_stop();


} // Nux Round function end

//============================================================================================
//       Main function
//============================================================================================
int main()
{
 long int r_k[31]={0}, msb_out=0, lsb_out=0;
 long int pt[2] = {0x0, 0x0};      // hardcoded plaintext
 int i;
 unsigned char t[2];
 Lcd_Init();                        // Initialize LCD
 Lcd_Cmd(_LCD_CLEAR);               // Clear display
 Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

 // NUX KSA calling function
 key_schedule_1(r_k);           // key scheduling function call to store all the key

 // Round function calling
 msb_out = pt[0];
 lsb_out = pt[1];



 for(i=0;i<31;i++)
    {
      nux_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);

     /*//LCD display commands to view coding output
     LongintTohex(msb_out,ch);
     Lcd_out(1,1,ch);
     LongintTohex(lsb_out,ch);
     Lcd_out(1,10,ch);
     Delay_ms(100);
     Lcd_Cmd(_LCD_CLEAR);*/
    }// round = 25 for end


    //printing the final output i.e. ciphertext
    LongintTohex(msb_out,ch);
    Lcd_out(1,1,ch);
    LongintTohex(lsb_out,ch);
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

} // main end