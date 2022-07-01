#line 1 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_4_Nux_BC/NUX_Embedded_C/Nux_BC_128.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/stdio.h"
#line 14 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_4_Nux_BC/NUX_Embedded_C/Nux_BC_128.c"
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
char sbox[16] = {0xE,0x7,0x8,0x4,0x1,0x9,0x2,0xF,0x5,0xA,0xB,0x0,0x6,0xC,0xD,0x3};
char p[32] = {15,11,7,3,2,14,10,6,5,1,13,9,8,4,0,12};




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





long int lcs_3(long int Input_16, long int *lcs_Input_16)
{
 *lcs_Input_16 = ((Input_16&0x1fffffff)<<3)|((Input_16&0xe0000000)>>(32-3));
}






long int lcs_8(long int Input_16, long int *lcs_Input_16)
{
 *lcs_Input_16 = ((Input_16&0x00ff)<<8)|((Input_16&0xff00)>>(16-8));
}






long int rcs_3(long int Input_16, long int *rcs_Input_16)
{
 *rcs_Input_16 = ((Input_16&0xfff8)>>3)|((Input_16&0x0007)<<(16-3));
}





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





long int p_box(long int Input_16, long int *p_Input_16)
{
 long int t=0;
 for (i=0;i<16;i++)
 {
 t |= ((Input_16>>i)&0x1)<<p[i];
 }
 *p_Input_16=t;
}




long int key_schedule_1(long int *rk)
{
 long int Key[4]={0x0,0x0,0x0,0x0};


 {rk[0] = Key[3];}


 for(i=0;i<31;i++)
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




long int nux_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{

 long int state=0, tmp_state=0, msb_1=0, msb_2=0, lsb_3=0, lsb_4=0;



 timer_init();


 msb_1 = ((msb_bits & 0xffff0000)>>16);
 msb_2 = (msb_bits & 0xffff);
 lsb_3 = ((lsb_bits & 0xffff0000)>>16);
 lsb_4 = (lsb_bits & 0xffff);


 rcs_3(msb_2,&state);
 s_box(state,&state);
 lcs_8(msb_1,&tmp_state);


 state = state ^ tmp_state ^ ((rk&0xffff0000)>>16);
 p_box(state, &state);
 p_box(msb_2,&tmp_state);
 lsb_bits = (state<<16) | tmp_state;


 lcs_8(lsb_3,&state);

 s_box(state,&state);

 rcs_3(lsb_4,&tmp_state);


 state = state ^ tmp_state ^ ((rk&0xffff));

 p_box(state,&state);


 p_box(lsb_3, &tmp_state);
 msb_bits = (tmp_state<<16) | state;



 *out_m =0;
 *out_l =0;
 *out_m = msb_bits;
 *out_l = lsb_bits;


 timer_stop();


}




int main()
{
 long int r_k[31]={0}, msb_out=0, lsb_out=0;
 long int pt[2] = {0x0, 0x0};
 int i;
 unsigned char t[2];
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 key_schedule_1(r_k);


 msb_out = pt[0];
 lsb_out = pt[1];



 for(i=0;i<31;i++)
 {
 nux_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
#line 247 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_4_Nux_BC/NUX_Embedded_C/Nux_BC_128.c"
 }



 LongintTohex(msb_out,ch);
 Lcd_out(1,1,ch);
 LongintTohex(lsb_out,ch);
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
