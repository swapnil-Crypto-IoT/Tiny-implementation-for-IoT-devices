/*

This code domonstrates the Lightweight block cipher Vayu with 128 bit key scheduling

Test vector : Plaintext = 0x00000000 0x00000000 and key = 0x01234567 0x89abcdef 0x01234567 0x89abcdef
              Ciphertext = 0x01234567 0x89abcdef

Programing Author: Swapnil Ashok Sutar

*/

//=========================================================================================
//      Global Variable Declaration
//=========================================================================================
long int temp1, temp2;
char ch[5]; // 1 byte =8 bit, no. of required bits 64 bit = 8 byte to display on LCD
char i, j; // repeatative used in many functions
char sbox[16] = {0x2,0x9,0x7,0xE,0x1,0xC,0xa,0x0,0x4,0x3,0x8,0xD,0xF,0x6,0x5,0xB};   // SBOX ANU
char p[32] = {20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,3,7,14,10,6,2,9,13,1,5,12,8,4,0}; // P-layer ANU

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Left circular shifted value of msb_bits by 3
//============================================================================================
long int lcs_3(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}

//============================================================================================
// Left circular shift by 7
// Input        : msb_bits (32 bits)
// Output        : Left circular shifted value of msb_bits by 7
//============================================================================================
long int lcs_7(long int msb_32, long int *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x01ffffff)<<7)|((msb_32&0xfe000000)>>(32-7));
}

//============================================================================================
//        Right Circular Shift by 7
// Input        : msb_bits (32 bits)
// Output        : Right circular shifted value of msb_bits by 7
//============================================================================================
long int rcs_7(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xffffff80)>>7)|((msb_32&0x0000007f)<<(32-7));
}

//============================================================================================
//        Right Circular Shift by 3
// Input        : msb_bits (32 bits)
// Output        : Right circular shifted value of msb_bits by 7
//============================================================================================
long int rcs_3(long int msb_32, long int *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xfffffff8)>>3)|((msb_32&0x00000007)<<(32-3));
}
//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : New substituted value for each nibble in n_nibble
//============================================================================================
long int s_box(long int msb_32, long int *n_nibble)
{
     long int a[8];
     *n_nibble=0;
     for(i=0;i<32;i=i+4)
     {
       a[(i*1)/4]= sbox[((msb_32>>(i))&0xf)];
       *n_nibble |= a[(i*1)/4] << i;
     }
}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Permuted value for each bits in msb_32 bits
//============================================================================================
long int p_box(long int msb_32, long int *p_msb_32)
{
        long int t=0;
        for (i=0;i<32;i++)
        {
                 t |= ((msb_32>>i)&0x1)<<p[i];
        }
        *p_msb_32=t;
}

//============================================================================================
//       VAYU Key Scheduling
//============================================================================================
long int key_schedule_1(long int *rk)
{
     long int Key[4]={0x01234567,0x89abcdef,0x01234567,0x89abcdef}; //hard coded 128 bit master key

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
        temp1 = (Key[2] & 0xf8000000) >> (32-5);
        temp1 = temp1 ^ ((i)&0x1f);
        Key[2]=  (Key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5))  ;

        {rk[i+1] = Key[3];}
        }

} // KSA end

//============================================================================================
//       VAYU round function
//============================================================================================
long int vayu_round(long int msb_bits, long int lsb_bits, long int rk, long int *out_m, long int *out_l)
{
  long int state=0,trail_1=0,trail_2=0;

        // f1 function
       s_box(msb_bits, &trail_1);
       lcs_7(trail_1,&trail_2);
       lcs_3(trail_1,&trail_1);
       lsb_bits = trail_1 ^ trail_2 ^ lsb_bits;
       
       //f2 function
       s_box(lsb_bits, &trail_1);
       rcs_7(trail_1,&trail_2);
       rcs_3(trail_1,&trail_1);

        msb_bits = trail_1 ^ trail_2 ^ msb_bits ^ rk; // add round key


        //bit permutation lsb and msb
        p_box(msb_bits, &trail_1);
        p_box(lsb_bits, &trail_2);


        //swapping
        lsb_bits = trail_1;
        msb_bits = trail_2;


        //joining 64 bits = msb_bits + lsb_bits
         *out_m =0;
         *out_l =0;
         *out_m = msb_bits;
         *out_l = lsb_bits;

} // VAYU Round function end

void setup() {
  // put your setup code here, to run once:
 Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

long int r_k[31]={0}, msb_out=0, lsb_out=0;
long int pt[2] = {0x01234567, 0x89abcdef};      // hardcoded plaintext
int i;

 // ANU KSA calling function
 key_schedule_1(r_k);           // key scheduling function call to store all the key

 // Round function calling
 msb_out = pt[0];
 lsb_out = pt[1];


 
 for(i=0;i<31;i++)
    {unsigned long StartTime = micros();
      vayu_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
    /* if(i==30)
      {
        pt[0]=msb_out;
        pt[1]=lsb_out;
       }*/
       unsigned long CurrentTime = micros();
  unsigned long ElapsedTime = CurrentTime - StartTime;
  Serial.println(ElapsedTime);
    }// round = 30 vayu end


  
  
/*
 Serial.println(pt[0],HEX);
 delay(100);
 Serial.println(pt[1],HEX);
 delay(100);
*/


}
