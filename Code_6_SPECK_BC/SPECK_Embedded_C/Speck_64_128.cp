#line 1 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_6_SPECK_BC/SPECK_Embedded_C/Speck_64_128.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/stdio.h"
#line 18 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_6_SPECK_BC/SPECK_Embedded_C/Speck_64_128.c"
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






char ch[5]={0};





void timer_init()
{
 TIMSK=0b00000001;
 SREG_I_bit = 1;
 TCCR0=0b00000001;
}

void timer_stop()
{
 TCCR0=0b00000000;
}

int time_count=0;
void interrupt() org IVT_ADDR_TIMER0_OVF
{
 time_count++;
}




long int rcs_8(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}




long int lcs_3(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}






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

 }

 Key_plus_encryption_speck(key[2],key[3],i,&key[2],&key[3]);
 round_key[i+1] = key[3];


 Key_plus_encryption_speck(key[1],key[3],i+1,&key[1],&key[3]);
 round_key[i+2] = key[3];


 Key_plus_encryption_speck(key[0],key[3],i+2,&key[0],&key[3]);
 round_key[i+3] = key[3];

 }



}




long int speck_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{


 Key_plus_encryption_speck(msb_bits,lsb_bits,rk,out_m,out_l);

}

int main()
{

 long int Msb_Bits = 0x3b726574, Lsb_Bits = 0x7475432d;
 long int key[4] = {0x1b1a1918, 0x13121110, 0x0b0a0908, 0x03020100};
 long int R_key[27] = {0};
 int i;
 unsigned char t[2];

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 key_update(key,R_key);




 for(i=0; i<27; i++)
 {
 speck_round(Msb_Bits, Lsb_Bits,R_key[i], &Msb_Bits, &Lsb_Bits);
 }




 LongintTohex(Msb_Bits,ch);
 Lcd_out(1,1,ch);
 LongintTohex(Lsb_Bits,ch);
 Lcd_out(1,10,ch);
 Delay_ms(100);


 IntToStr(time_count,t);
 Lcd_out(3,1,"Overflow:");
 Lcd_out(3,13,t);
 IntToStr(TCNT0,t);
 Lcd_out(4,1,"TCNT0 Value:");
 Lcd_out(4,13,t);

 Delay_ms(100);

}
