#line 1 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_2_ANU_BC/3_ANU_embedded_C/ANU_BC_Code.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/stdio.h"
#line 15 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_2_ANU_BC/3_ANU_embedded_C/ANU_BC_Code.c"
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
char sbox[16] = {0x2,0x9,0x7,0xE,0x1,0xC,0xa,0x0,0x4,0x3,0x8,0xD,0xF,0x6,0x5,0xB};
char p[32] = {20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,3,7,14,10,6,2,9,13,1,5,12,8,4,0};





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





long int lcs_3(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}





long int rcs_8(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}




long int s_box(long int msb_32, long long int *n_nibble)
{
 long int a[8];
 *n_nibble=0;
 for(i=0;i<32;i=i+4)
 {
 a[(i*1)/4]= sbox[((msb_32>>(i))&0xf)];
 *n_nibble |= a[(i*1)/4] << i;
 }

}





long int p_box(long int msb_32, long int *p_msb_32)
{
 long int t=0;
 for (i=0;i<32;i++)
 {
 t |= ((msb_32>>i)&0x1)<<p[i];
 }
 *p_msb_32=t;
}




long int key_schedule_1(long int *rk)
{
 long int Key[4]={0x00000000,0x00000000,0x00000000,0x00000000};


 {rk[0] = Key[3];}


 for(i=0;i<25;i++)
 {
 temp1 = temp2 = 0;
 temp1 = Key[0];



 Key[0] = ((temp1&0x0007ffff)<<13) |((Key[1]&0xfff80000)>>(32-13)) ;
 Key[1] = ((Key[1]&0X0007ffff)<<13) |(((Key[2]&0xfff80000)>>(32-13)));
 Key[2] = ((Key[2]&0x0007ffff)<<13) |(((Key[3]&0Xfff80000))>>(32-13));
 Key[3] = ((Key[3]&0X0007ffff)<<13) |(((temp1&0Xfff80000))>>(32-13));


 temp1 = sbox[Key[3]&0xf] ;
 temp2 = sbox[((Key[3])>>4)&0xf];
 temp1 = ((temp2&0xf)<<4)| temp1 ;
 Key[3] = (Key[3]&0xffffff00)|(temp1);


 temp1 = (key[2] & 0xf8000000) >> (32-5);
 temp1 = temp1 ^ ((i)&0x1f);
 key[2]= (key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5)) ;

 {rk[i+1] = Key[3];}
 }

}




long int anu_round(long int msb, long int lsb, long int rk, long int *msbout, long int *lsbout)
{
 long int state=0,trail_1=0,trail_2=0;

 lcs_3(msb,&state);
 s_box(state,&trail_1);

 rcs_8(msb,&state);
 s_box(state,&trail_2);

 state = trail_1 ^ trail_2 ^ rk ^ lsb;


 p_box(msb,&trail_1);
 p_box(state,&trail_2);


 lsb = trail_1;
 msb = trail_2;




 *msbout = msb;
 *lsbout = lsb;
}




int main()
{
 long int r_k[25]={0}, msb_out=0, lsb_out=0;
 long int pt[2] = {0x00000000, 0x00000000};
 int i;
 unsigned char t[2];
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);




 key_schedule_1(r_k);


 msb_out = pt[0];
 lsb_out = pt[1];



 timer_init();
 for(i=0;i<25;i++)
 {
 anu_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
#line 213 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_2_ANU_BC/3_ANU_embedded_C/ANU_BC_Code.c"
 }

 timer_stop();



 LongintTohex(msb_out,ch);
 Lcd_out(1,1,ch);
 LongintTohex(lsb_out,ch);
 Lcd_out(1,10,ch);



 IntToStr(time_count,t);
 Lcd_out(3,1,"Overflows:");
 Lcd_out(3,13,t);
 IntToStr(TCNT0,t);
 Lcd_out(4,1,"TCNT0 Value:");
 Lcd_out(4,13,t);

 Delay_ms(100);

}
