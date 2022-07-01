#line 1 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_5_Simon_BC/SIMON_Embedded_C/SIMON.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/stdio.h"
#line 20 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_5_Simon_BC/SIMON_Embedded_C/SIMON.c"
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





long int temp1, temp2;
char ch[5];
char i, j;




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





long int rcs_3(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
}

long int rcs_4(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xfffffff0)>>4)|((msb_32&0x0000000f)<<(32-4));
}

long int rcs_1(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xfffffffe)>>1)|((msb_32&0x00000001)<<(32-1));
}

long int rcs_8(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}





long int lcs_1(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x7fffffff)<<1)|((msb_32&0x80000000)>>(32-1));
}

long int lcs_2(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x3fffffff)<<2)|((msb_32&0xc0000000)>>(32-2));
}

long int lcs_8(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x00ffffff)<<8)|((msb_32&0xff000000)>>(32-8));
}




long int Key_Schedule(long int *R_k)
{
 long int Key[4]={0x03020100, 0x0b0a0908, 0x13121110, 0x1b1a1918}, z_m_32 = 0xfc2ce512, z_l_32 = 0x07a635db;
 long int c = 0xfffffffc, tmp_state[3]={0};
 R_k[0] = Key[0];
 R_k[1] = Key[1];
 R_k[2] = Key[2];
 R_k[3] = Key[3];

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




long int simon_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{
 long int state=0,trail_1=0,trail_2=0;
 timer_init();
 lcs_1(msb_bits,&trail_1);
 lcs_8(msb_bits,&trail_2);
 state = trail_1 & trail_2;

 lcs_2(msb_bits,&trail_1);

 trail_2 = state ^ trail_1 ^ lsb_bits ^ rk;



 lsb_bits = msb_bits;
 msb_bits = trail_2;




 *out_m = msb_bits;
 *out_l = lsb_bits;
 timer_stop();
}




int main()
{
 long int R_k[44]= {0}, Msb_Out = 0, Lsb_Out=0;
 long int P_t[2]={0x656b696c,0x20646e75} ;
 char i;
 unsigned char t[2];

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);



 Key_Schedule(R_k);


 Msb_out = P_t[0];
 Lsb_out = P_t[1];
 for(i=0;i<44;i++)
 {
 simon_round(Msb_out, Lsb_out, R_k[i], &Msb_out, &Lsb_out);
 }


 LongintTohex(Msb_out,ch);
 Lcd_out(1,1,ch);
 LongintTohex(Lsb_out,ch);
 Lcd_out(1,10,ch);
 Delay_ms(100);


 IntToStr(time_count,t);
 Lcd_out(3,1,"Overflows:");
 Lcd_out(3,13,t);
 IntToStr(TCNT0,t);
 Lcd_out(4,1,"TCNT0 Value:");
 Lcd_out(4,13,t);

 Delay_ms(100);


}
