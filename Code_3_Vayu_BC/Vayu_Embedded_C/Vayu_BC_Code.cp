#line 1 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_3_Vayu_BC/Vayu_Embedded_C/Vayu_BC_Code.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for avr/include/stdio.h"
#line 15 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_3_Vayu_BC/Vayu_Embedded_C/Vayu_BC_Code.c"
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






long int lcs_7(long int msb_32, long int *lcs_msb_32)
{
 *lcs_msb_32 = ((msb_32&0x01ffffff)<<7)|((msb_32&0xfe000000)>>(32-7));
}






long int rcs_7(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xffffff80)>>7)|((msb_32&0x0000007f)<<(32-7));
}






long int rcs_3(long int msb_32, long int *rcs_msb_32)
{
 *rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
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
 long int Key[4]={0x01234567,0x89abcdef,0x01234567,0x89abcdef};


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




long int vayu_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{
 long int state=0,trail_1=0,trail_2=0;





 s_box(msb_bits, &trail_1);
 lcs_7(trail_1,&trail_2);
 lcs_3(trail_1,&trail_1);
 lsb_bits = trail_1 ^ trail_2 ^ lsb_bits;


 s_box(lsb_bits, &trail_1);
 rcs_7(trail_1,&trail_2);
 rcs_3(trail_1,&trail_1);

 msb_bits = trail_1 ^ trail_2 ^ msb_bits ^ rk;



 p_box(msb_bits, &trail_1);
 p_box(lsb_bits, &trail_2);



 lsb_bits = trail_1;
 msb_bits = trail_2;



 *out_m =0;
 *out_l =0;
 *out_m = msb_bits;
 *out_l = lsb_bits;



}




int main()
{
 long int r_k[31]={0}, msb_out=0, lsb_out=0;
 long int pt[2] = {0x01234567, 0x89abcdef};
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
 vayu_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
#line 244 "D:/Ph_D_ANU/my_phd_papers/paper_2/Implementation_codes/Atmega_coding/Code_with_simulation_setup/Code_3_Vayu_BC/Vayu_Embedded_C/Vayu_BC_Code.c"
 }



 LongintTohex(msb_out,ch);
 Lcd_out(1,1,ch);
 LongintTohex(lsb_out,ch);
 Lcd_out(1,10,ch);










 Delay_ms(100);

}
